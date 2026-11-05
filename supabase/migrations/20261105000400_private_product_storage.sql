insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('product-images', 'product-images', false, 10485760, array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do update set public = false, file_size_limit = 10485760, allowed_mime_types = excluded.allowed_mime_types;

create policy product_images_member_read on storage.objects for select using (
  bucket_id = 'product-images' and exists (
    select 1 from public.products p
    where p.household_id::text = (storage.foldername(name))[1]
      and public.is_household_member(p.household_id)
  )
);

create policy product_images_member_insert on storage.objects for insert with check (
  bucket_id = 'product-images' and exists (
    select 1 from public.products p
    where p.household_id::text = (storage.foldername(name))[1]
      and public.is_household_member(p.household_id)
  )
);

create policy product_images_member_delete on storage.objects for delete using (
  bucket_id = 'product-images' and exists (
    select 1 from public.products p
    where p.household_id::text = (storage.foldername(name))[1]
      and public.is_household_member(p.household_id)
  )
);
