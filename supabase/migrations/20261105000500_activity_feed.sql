create table public.activity_events (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households(id) on delete cascade,
  actor_id uuid references public.profiles(id) on delete set null,
  event_type text not null,
  summary text not null,
  entity_type text,
  entity_id uuid,
  created_at timestamptz not null default now()
);

create index activity_events_household_created on public.activity_events(household_id, created_at desc);
alter table public.activity_events enable row level security;
create policy activity_member_read on public.activity_events for select using (public.is_household_member(household_id));

create or replace function public.record_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  record_household uuid;
  record_id uuid;
  action text := lower(tg_op);
begin
  record_household := coalesce(new.household_id, old.household_id);
  record_id := coalesce(new.id, old.id);
  insert into public.change_log(household_id, entity_type, entity_id, operation)
  values (record_household, tg_table_name, record_id, action);
  insert into public.activity_events(household_id, actor_id, event_type, summary, entity_type, entity_id)
  values (record_household, auth.uid(), tg_table_name || '.' || action, initcap(action) || ' ' || replace(tg_table_name, '_', ' '), tg_table_name, record_id);
  if tg_op = 'DELETE' then return old; end if;
  return new;
end;
$$;
