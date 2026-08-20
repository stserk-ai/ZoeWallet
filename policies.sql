-- Pocket / Wallet Monitoring - RLS policies
-- Run this AFTER schema.sql, in the Supabase SQL editor.
-- Model: any authenticated user (you or Zoe) can read everything.
-- Some writes are parent-only, enforced via the users.role lookup below.

create or replace function is_parent()
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1 from users where id = auth.uid() and role = 'parent'
  );
$$;

-- users --------------------------------------------------------------
alter table users enable row level security;

create policy "users can read all profiles"
  on users for select
  to authenticated
  using (true);

create policy "users can update own profile"
  on users for update
  to authenticated
  using (id = auth.uid());

-- a user's own row gets inserted on first login (see app logic)
create policy "users can insert own profile"
  on users for insert
  to authenticated
  with check (id = auth.uid());

-- goals ----------------------------------------------------------------
alter table goals enable row level security;

create policy "authenticated can read goals"
  on goals for select
  to authenticated
  using (true);

create policy "authenticated can insert goals"
  on goals for insert
  to authenticated
  with check (true);

create policy "authenticated can update goals"
  on goals for update
  to authenticated
  using (true);

-- transactions -----------------------------------------------------------
alter table transactions enable row level security;

create policy "authenticated can read transactions"
  on transactions for select
  to authenticated
  using (true);

create policy "authenticated can insert transactions"
  on transactions for insert
  to authenticated
  with check (true);

-- transactions are append-only: no update/delete policy defined,
-- so no one (beyond the table owner) can modify history.

-- chore_templates ------------------------------------------------------
alter table chore_templates enable row level security;

create policy "authenticated can read chore_templates"
  on chore_templates for select
  to authenticated
  using (true);

create policy "parent can manage chore_templates"
  on chore_templates for insert
  to authenticated
  with check (is_parent());

create policy "parent can update chore_templates"
  on chore_templates for update
  to authenticated
  using (is_parent());

-- chore_entries ----------------------------------------------------------
alter table chore_entries enable row level security;

create policy "authenticated can read chore_entries"
  on chore_entries for select
  to authenticated
  using (true);

-- creating today's entries (system-generated) and checking a chore
-- (status -> pending_approval) both happen as plain inserts/updates;
-- approval/rejection is restricted to the parent.
create policy "authenticated can insert chore_entries"
  on chore_entries for insert
  to authenticated
  with check (true);

create policy "daughter can check chores"
  on chore_entries for update
  to authenticated
  using (not is_parent())
  with check (not is_parent());

create policy "parent can review chores"
  on chore_entries for update
  to authenticated
  using (is_parent())
  with check (is_parent());
