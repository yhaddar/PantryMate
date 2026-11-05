create table public.household_invitations (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households(id) on delete cascade,
  email text,
  assigned_role public.household_role not null check (assigned_role <> 'owner'),
  token_hash text not null unique,
  expires_at timestamptz not null default (now() + interval '7 days'),
  accepted_at timestamptz,
  cancelled_at timestamptz,
  invited_by uuid not null references public.profiles(id) on delete restrict,
  created_at timestamptz not null default now()
);

create table public.shopping_lists (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households(id) on delete cascade,
  name text not null check (length(trim(name)) between 1 and 120),
  is_default boolean not null default false,
  archived_at timestamptz,
  revision bigint not null default 0,
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index one_active_default_list on public.shopping_lists(household_id)
where is_default and archived_at is null;

create table public.shopping_list_items (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households(id) on delete cascade,
  list_id uuid not null references public.shopping_lists(id) on delete cascade,
  product_id uuid references public.products(id) on delete set null,
  name text not null check (length(trim(name)) between 1 and 160),
  quantity numeric(18, 3) not null check (quantity > 0),
  unit text not null,
  priority text not null default 'normal' check (priority in ('low', 'normal', 'high')),
  notes text,
  purchased_at timestamptz,
  purchased_by uuid references public.profiles(id) on delete set null,
  removed_at timestamptz,
  revision bigint not null default 0,
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.shopping_history (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households(id) on delete cascade,
  list_item_id uuid references public.shopping_list_items(id) on delete set null,
  product_id uuid references public.products(id) on delete set null,
  name text not null,
  quantity numeric(18, 3) not null check (quantity > 0),
  unit text not null,
  actor_id uuid references public.profiles(id) on delete set null,
  purchased_at timestamptz not null default now(),
  operation_id uuid not null,
  unique (household_id, operation_id)
);

create table public.notification_preferences (
  user_id uuid not null references public.profiles(id) on delete cascade,
  category text not null,
  enabled boolean not null default true,
  quiet_hours_start time not null default '22:00',
  quiet_hours_end time not null default '08:00',
  reminder_hour smallint not null default 9 check (reminder_hour between 0 and 23),
  reminder_minute smallint not null default 0 check (reminder_minute between 0 and 59),
  updated_at timestamptz not null default now(),
  primary key (user_id, category)
);

create table public.device_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  device_id text not null,
  platform text not null check (platform in ('android', 'ios')),
  token text not null,
  invalidated_at timestamptz,
  updated_at timestamptz not null default now(),
  unique (user_id, device_id)
);

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  household_id uuid references public.households(id) on delete cascade,
  event_key text not null,
  category text not null,
  title text not null,
  body text not null,
  deep_link text,
  scheduled_at timestamptz not null,
  sent_at timestamptz,
  failed_at timestamptz,
  created_at timestamptz not null default now(),
  unique (user_id, event_key)
);

create table public.feedback_submissions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete set null,
  category text not null,
  message text not null check (length(trim(message)) between 1 and 5000),
  screenshot_path text,
  created_at timestamptz not null default now()
);

create index household_invitations_household on public.household_invitations(household_id, expires_at);
create index shopping_items_list on public.shopping_list_items(list_id, removed_at, purchased_at);
create index notifications_user_schedule on public.notifications(user_id, scheduled_at);

create or replace function public.accept_invitation(p_token_hash text)
returns public.household_members
language plpgsql
security definer
set search_path = public
as $$
declare
  invitation public.household_invitations;
  membership public.household_members;
begin
  if auth.uid() is null then
    raise exception using errcode = '42501', message = 'Authentication required';
  end if;
  select * into invitation from public.household_invitations
  where token_hash = p_token_hash
    and accepted_at is null
    and cancelled_at is null
    and expires_at > now()
  for update;
  if not found then
    raise exception using errcode = '22023', message = 'Invitation is invalid or expired';
  end if;
  if exists (select 1 from public.household_members where household_id = invitation.household_id and user_id = auth.uid()) then
    raise exception using errcode = '23505', message = 'User is already a household member';
  end if;
  insert into public.household_members(household_id, user_id, role)
  values (invitation.household_id, auth.uid(), invitation.assigned_role)
  returning * into membership;
  update public.household_invitations set accepted_at = now() where id = invitation.id;
  return membership;
end;
$$;

create or replace function public.create_household(p_name text, p_timezone text default 'UTC')
returns public.households
language plpgsql
security definer
set search_path = public
as $$
declare
  created public.households;
begin
  if auth.uid() is null then
    raise exception using errcode = '42501', message = 'Authentication required';
  end if;
  if p_name is null or length(trim(p_name)) not between 1 and 120 then
    raise exception using errcode = '22023', message = 'Household name is invalid';
  end if;
  insert into public.households(name, timezone) values (trim(p_name), coalesce(nullif(trim(p_timezone), ''), 'UTC')) returning * into created;
  insert into public.household_members(household_id, user_id, role) values (created.id, auth.uid(), 'owner');
  return created;
end;
$$;

create or replace function public.purchase_shopping_item(
  p_operation_id uuid,
  p_item_id uuid,
  p_quantity numeric,
  p_unit text,
  p_location_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  item public.shopping_list_items;
  product public.products;
  batch_id uuid;
  existing jsonb;
  result jsonb;
begin
  select jsonb_build_object('operation_id', p_operation_id) into existing
  from public.shopping_history where operation_id = p_operation_id;
  if existing is not null then return existing; end if;
  select i.* into item from public.shopping_list_items i where i.id = p_item_id for update;
  if not found or not public.is_household_member(item.household_id) then
    raise exception using errcode = '42501', message = 'Shopping item is unavailable';
  end if;
  if item.purchased_at is not null or item.removed_at is not null then
    raise exception using errcode = '22023', message = 'Shopping item is not purchasable';
  end if;
  if p_quantity is null or p_quantity <= 0 then
    raise exception using errcode = '22003', message = 'Purchased quantity must be greater than zero';
  end if;
  if p_location_id is null or not exists (select 1 from public.storage_locations where id = p_location_id and household_id = item.household_id and archived_at is null) then
    raise exception using errcode = '22023', message = 'Storage location is invalid';
  end if;
  if item.product_id is not null then
    select * into product from public.products where id = item.product_id for share;
    if not found or product.household_id <> item.household_id or product.archived_at is not null or product.base_unit <> p_unit then
      raise exception using errcode = '22023', message = 'Product or unit is invalid';
    end if;
    insert into public.inventory_batches(household_id, product_id, quantity, unit, location_id, created_by)
    values (item.household_id, item.product_id, p_quantity, p_unit, p_location_id, auth.uid())
    returning id into batch_id;
    insert into public.inventory_events(household_id, batch_id, product_id, operation_id, event_type, quantity_delta, unit, reason, actor_id)
    values (item.household_id, batch_id, item.product_id, p_operation_id, 'purchased', p_quantity, p_unit, 'shopping_purchase', auth.uid());
  end if;
  update public.shopping_list_items set purchased_at = now(), purchased_by = auth.uid(), updated_at = now() where id = item.id;
  insert into public.shopping_history(household_id, list_item_id, product_id, name, quantity, unit, actor_id, operation_id)
  values (item.household_id, item.id, item.product_id, item.name, p_quantity, p_unit, auth.uid(), p_operation_id);
  result := jsonb_build_object('operation_id', p_operation_id, 'item_id', item.id, 'batch_id', batch_id);
  return result;
end;
$$;

alter table public.household_invitations enable row level security;
alter table public.shopping_lists enable row level security;
alter table public.shopping_list_items enable row level security;
alter table public.shopping_history enable row level security;
alter table public.notification_preferences enable row level security;
alter table public.device_tokens enable row level security;
alter table public.notifications enable row level security;
alter table public.feedback_submissions enable row level security;

create policy invitations_member_access on public.household_invitations for select using (public.is_household_member(household_id));
create policy lists_member_access on public.shopping_lists for all using (public.is_household_member(household_id)) with check (public.is_household_member(household_id));
create policy items_member_access on public.shopping_list_items for all using (public.is_household_member(household_id)) with check (public.is_household_member(household_id));
create policy shopping_history_member_read on public.shopping_history for select using (public.is_household_member(household_id));
create policy notification_preferences_self on public.notification_preferences for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy device_tokens_self on public.device_tokens for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy notifications_self on public.notifications for select using (user_id = auth.uid());
create policy feedback_authenticated_insert on public.feedback_submissions for insert with check (user_id = auth.uid());

revoke all on function public.accept_invitation(text) from public;
grant execute on function public.accept_invitation(text) to authenticated;
revoke all on function public.create_household(text, text) from public;
grant execute on function public.create_household(text, text) to authenticated;
revoke all on function public.purchase_shopping_item(uuid, uuid, numeric, text, uuid) from public;
grant execute on function public.purchase_shopping_item(uuid, uuid, numeric, text, uuid) to authenticated;
