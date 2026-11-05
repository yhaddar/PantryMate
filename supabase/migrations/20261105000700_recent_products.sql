create table public.recent_product_usage (
  user_id uuid not null references public.profiles(id) on delete cascade,
  household_id uuid not null references public.households(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  use_count integer not null default 1 check (use_count > 0),
  last_used_at timestamptz not null default now(),
  primary key (user_id, household_id, product_id)
);

create index recent_product_usage_order
  on public.recent_product_usage(user_id, household_id, last_used_at desc);

alter table public.recent_product_usage enable row level security;

create policy recent_product_usage_self_member_access
on public.recent_product_usage
for select
using (user_id = auth.uid() and public.is_household_member(household_id));

create or replace function public.record_recent_product(
  p_household_id uuid,
  p_product_id uuid
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null or not public.is_household_member(p_household_id) then
    raise exception using errcode = '42501', message = 'Household access denied';
  end if;
  if not exists (
    select 1 from public.products
    where id = p_product_id and household_id = p_household_id and archived_at is null
  ) then
    raise exception using errcode = '22023', message = 'Product is not available';
  end if;
  insert into public.recent_product_usage(user_id, household_id, product_id)
  values (auth.uid(), p_household_id, p_product_id)
  on conflict (user_id, household_id, product_id) do update
    set use_count = recent_product_usage.use_count + 1,
        last_used_at = now();
end;
$$;

revoke all on function public.record_recent_product(uuid, uuid) from public;
grant execute on function public.record_recent_product(uuid, uuid) to authenticated;
