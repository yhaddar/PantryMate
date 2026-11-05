create extension if not exists pgcrypto;

create type public.household_role as enum ('owner', 'admin', 'member');
create type public.outbox_operation_status as enum ('pending', 'processing', 'synced', 'failed');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  avatar_path text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.households (
  id uuid primary key default gen_random_uuid(),
  name text not null check (length(trim(name)) between 1 and 120),
  timezone text not null default 'UTC',
  deletion_requested_at timestamptz,
  deleted_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.household_members (
  household_id uuid not null references public.households(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete restrict,
  role public.household_role not null,
  joined_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (household_id, user_id)
);

create unique index one_owner_per_household on public.household_members(household_id)
where role = 'owner';

create table public.categories (
  id text primary key,
  name text not null unique
);

create table public.storage_locations (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households(id) on delete cascade,
  name text not null check (length(trim(name)) between 1 and 80),
  archived_at timestamptz,
  created_at timestamptz not null default now(),
  unique (household_id, name)
);

create table public.products (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households(id) on delete cascade,
  name text not null check (length(trim(name)) between 1 and 160),
  category_id text not null references public.categories(id),
  base_unit text not null,
  barcode text,
  brand text,
  notes text,
  image_path text,
  archived_at timestamptz,
  revision bigint not null default 0,
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (household_id, barcode)
);

create table public.inventory_batches (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete restrict,
  quantity numeric(18, 3) not null check (quantity >= 0),
  unit text not null,
  location_id uuid not null references public.storage_locations(id) on delete restrict,
  expires_on date,
  archived_at timestamptz,
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (quantity = round(quantity, 3))
);

create table public.inventory_events (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households(id) on delete cascade,
  batch_id uuid references public.inventory_batches(id) on delete set null,
  product_id uuid not null references public.products(id) on delete restrict,
  operation_id uuid not null,
  event_type text not null,
  quantity_delta numeric(18, 3) not null,
  unit text not null,
  reason text,
  actor_id uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  unique (household_id, operation_id)
);

create table public.operation_receipts (
  operation_id uuid primary key,
  household_id uuid not null references public.households(id) on delete cascade,
  result jsonb not null,
  created_at timestamptz not null default now()
);

create table public.change_log (
  revision bigint generated always as identity primary key,
  household_id uuid not null references public.households(id) on delete cascade,
  entity_type text not null,
  entity_id uuid not null,
  operation text not null,
  changed_at timestamptz not null default now()
);

create index inventory_batches_household_product on public.inventory_batches(household_id, product_id);
create index inventory_batches_household_expiry on public.inventory_batches(household_id, expires_on);
create index change_log_household_revision on public.change_log(household_id, revision);

create or replace function public.is_household_member(target_household uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.household_members m
    join public.households h on h.id = m.household_id
    where m.household_id = target_household
      and m.user_id = auth.uid()
      and h.deleted_at is null
  );
$$;

create or replace function public.household_role_for(target_household uuid)
returns public.household_role language sql stable security definer set search_path = public as $$
  select role from public.household_members
  where household_id = target_household and user_id = auth.uid();
$$;

alter table public.profiles enable row level security;
alter table public.households enable row level security;
alter table public.household_members enable row level security;
alter table public.storage_locations enable row level security;
alter table public.products enable row level security;
alter table public.inventory_batches enable row level security;
alter table public.inventory_events enable row level security;
alter table public.change_log enable row level security;

create policy profiles_self_or_member on public.profiles for select using (
  id = auth.uid() or exists (select 1 from public.household_members m where m.user_id = profiles.id and public.is_household_member(m.household_id))
);
create policy households_member_read on public.households for select using (public.is_household_member(id));
create policy members_member_read on public.household_members for select using (public.is_household_member(household_id));
create policy locations_member_access on public.storage_locations for all using (public.is_household_member(household_id)) with check (public.is_household_member(household_id));
create policy products_member_access on public.products for all using (public.is_household_member(household_id)) with check (public.is_household_member(household_id));
create policy batches_member_access on public.inventory_batches for all using (public.is_household_member(household_id)) with check (public.is_household_member(household_id));
create policy events_member_read on public.inventory_events for select using (public.is_household_member(household_id));
create policy changes_member_read on public.change_log for select using (public.is_household_member(household_id));

revoke all on public.inventory_events from authenticated;
revoke all on public.change_log from authenticated;

alter table public.operation_receipts enable row level security;
revoke all on public.operation_receipts from authenticated;

create or replace function public.consume_inventory(
  p_operation_id uuid,
  p_household_id uuid,
  p_product_id uuid,
  p_quantity numeric,
  p_reason text default 'consumed'
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  existing_result jsonb;
  remaining numeric := p_quantity;
  batch record;
  deduction numeric;
  result jsonb := jsonb_build_object('operation_id', p_operation_id, 'deductions', '[]'::jsonb);
begin
  if auth.uid() is null or not public.is_household_member(p_household_id) then
    raise exception using errcode = '42501', message = 'Not authorized for household';
  end if;
  if p_quantity is null or p_quantity <= 0 then
    raise exception using errcode = '22003', message = 'Quantity must be greater than zero';
  end if;

  select r.result into existing_result from public.operation_receipts r
  where r.operation_id = p_operation_id;
  if existing_result is not null then
    return existing_result;
  end if;

  for batch in
    select b.id, b.quantity, b.unit
    from public.inventory_batches b
    where b.household_id = p_household_id
      and b.product_id = p_product_id
      and b.archived_at is null
      and b.quantity > 0
      and (b.expires_on is null or b.expires_on >= current_date)
    order by (b.expires_on is null), b.expires_on, b.created_at
    for update
  loop
    exit when remaining <= 0;
    deduction := least(batch.quantity, remaining);
    update public.inventory_batches set quantity = quantity - deduction, updated_at = now()
    where id = batch.id;
    insert into public.inventory_events(household_id, batch_id, product_id, operation_id, event_type, quantity_delta, unit, reason, actor_id)
    values (p_household_id, batch.id, p_product_id, p_operation_id, 'consumed', -deduction, batch.unit, p_reason, auth.uid());
    result := jsonb_set(result, '{deductions}', (result->'deductions') || jsonb_build_array(jsonb_build_object('batch_id', batch.id, 'quantity', deduction)));
    remaining := remaining - deduction;
  end loop;

  if remaining > 0 then
    raise exception using errcode = '22003', message = 'Quantity exceeds available stock';
  end if;

  insert into public.operation_receipts(operation_id, household_id, result)
  values (p_operation_id, p_household_id, result);
  return result;
end;
$$;

revoke all on function public.consume_inventory(uuid, uuid, uuid, numeric, text) from public;
grant execute on function public.consume_inventory(uuid, uuid, uuid, numeric, text) to authenticated;
