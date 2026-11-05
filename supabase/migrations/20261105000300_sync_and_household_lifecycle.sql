create or replace function public.record_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  record_household uuid;
  record_id uuid;
begin
  record_household := coalesce(new.household_id, old.household_id);
  record_id := coalesce(new.id, old.id);
  insert into public.change_log(household_id, entity_type, entity_id, operation)
  values (record_household, tg_table_name, record_id, lower(tg_op));
  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end;
$$;

create trigger products_change_log after insert or update or delete on public.products
for each row execute function public.record_change();
create trigger inventory_batches_change_log after insert or update or delete on public.inventory_batches
for each row execute function public.record_change();
create trigger shopping_lists_change_log after insert or update or delete on public.shopping_lists
for each row execute function public.record_change();
create trigger shopping_list_items_change_log after insert or update or delete on public.shopping_list_items
for each row execute function public.record_change();

create or replace function public.transfer_household_ownership(p_household_id uuid, p_new_owner uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if public.household_role_for(p_household_id) <> 'owner' then
    raise exception using errcode = '42501', message = 'Only the current owner may transfer ownership';
  end if;
  if not exists (select 1 from public.household_members where household_id = p_household_id and user_id = p_new_owner) then
    raise exception using errcode = '22023', message = 'New owner must be a household member';
  end if;
  update public.household_members set role = 'admin', updated_at = now()
  where household_id = p_household_id and user_id = auth.uid();
  update public.household_members set role = 'owner', updated_at = now()
  where household_id = p_household_id and user_id = p_new_owner;
end;
$$;

create or replace function public.remove_household_member(p_household_id uuid, p_user_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  actor_role public.household_role;
  target_role public.household_role;
begin
  actor_role := public.household_role_for(p_household_id);
  select role into target_role from public.household_members where household_id = p_household_id and user_id = p_user_id;
  if target_role is null or target_role = 'owner' then
    raise exception using errcode = '22023', message = 'Target member cannot be removed';
  end if;
  if actor_role = 'owner' or (actor_role = 'admin' and target_role = 'member') then
    delete from public.household_members where household_id = p_household_id and user_id = p_user_id;
  else
    raise exception using errcode = '42501', message = 'Not authorized to remove member';
  end if;
end;
$$;

create or replace function public.request_household_deletion(p_household_id uuid)
returns timestamptz
language plpgsql
security definer
set search_path = public
as $$
declare
  deletion_time timestamptz;
begin
  if public.household_role_for(p_household_id) <> 'owner' then
    raise exception using errcode = '42501', message = 'Only the owner may request deletion';
  end if;
  deletion_time := now();
  update public.households set deletion_requested_at = deletion_time, updated_at = deletion_time
  where id = p_household_id and deleted_at is null;
  return deletion_time + interval '30 days';
end;
$$;

create or replace function public.cancel_household_deletion(p_household_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if public.household_role_for(p_household_id) <> 'owner' then
    raise exception using errcode = '42501', message = 'Only the owner may recover a household';
  end if;
  update public.households set deletion_requested_at = null, updated_at = now()
  where id = p_household_id and deleted_at is null and deletion_requested_at > now() - interval '30 days';
end;
$$;

revoke all on function public.transfer_household_ownership(uuid, uuid) from public;
grant execute on function public.transfer_household_ownership(uuid, uuid) to authenticated;
revoke all on function public.remove_household_member(uuid, uuid) from public;
grant execute on function public.remove_household_member(uuid, uuid) to authenticated;
revoke all on function public.request_household_deletion(uuid) from public;
grant execute on function public.request_household_deletion(uuid) to authenticated;
revoke all on function public.cancel_household_deletion(uuid) from public;
grant execute on function public.cancel_household_deletion(uuid) to authenticated;
