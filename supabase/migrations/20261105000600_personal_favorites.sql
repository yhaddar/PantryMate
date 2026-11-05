create table public.favorite_products (
  user_id uuid not null references public.profiles(id) on delete cascade,
  household_id uuid not null references public.households(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, product_id),
  unique (user_id, household_id, product_id)
);

create index favorite_products_household_user
  on public.favorite_products(household_id, user_id);

alter table public.favorite_products enable row level security;

create policy favorite_products_self_member_access
on public.favorite_products
for all
using (user_id = auth.uid() and public.is_household_member(household_id))
with check (user_id = auth.uid() and public.is_household_member(household_id));
