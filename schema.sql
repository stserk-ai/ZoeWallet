-- Pocket / Wallet Monitoring - Supabase schema
-- Run this in the Supabase SQL editor (Project > SQL Editor > New query)

create extension if not exists "uuid-ossp";

create table users (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  role text not null check (role in ('parent', 'daughter')),
  display_name text not null
);

create table goals (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  target numeric,
  saved numeric not null default 0,
  is_default boolean not null default false,
  created_at timestamptz not null default now(),
  completed_at timestamptz
);

-- only one default goal at a time
create unique index goals_single_default on goals (is_default) where is_default;

create table transactions (
  id uuid primary key default uuid_generate_v4(),
  goal_id uuid not null references goals(id),
  name text not null,
  amount numeric not null,
  type text not null check (type in ('in', 'out')),
  source text not null check (source in ('manual', 'chore')),
  source_id uuid,
  created_by uuid references users(id),
  created_at timestamptz not null default now()
);

create table chore_templates (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  pay numeric not null,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table chore_entries (
  id uuid primary key default uuid_generate_v4(),
  template_id uuid not null references chore_templates(id),
  goal_id uuid references goals(id),
  date date not null,
  status text not null default 'pending'
    check (status in ('pending', 'pending_approval', 'approved', 'rejected', 'missed')),
  checked_at timestamptz,
  reviewed_at timestamptz,
  reviewed_by uuid references users(id),
  transaction_id uuid references transactions(id),
  unique (template_id, date)
);

-- balance is always computed, never stored:
--   select coalesce(sum(case when type = 'in' then amount else -amount end), 0) as balance from transactions;
-- per-goal saved should match:
--   select goal_id, coalesce(sum(case when type='in' then amount else -amount end),0) as saved
--   from transactions group by goal_id;
