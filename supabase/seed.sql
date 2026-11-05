insert into public.categories (id, name) values
  ('produce', 'Produce'),
  ('dairy', 'Dairy'),
  ('meat', 'Meat and seafood'),
  ('pantry', 'Pantry'),
  ('frozen', 'Frozen'),
  ('beverages', 'Beverages'),
  ('snacks', 'Snacks'),
  ('household', 'Household')
on conflict (id) do nothing;
