-- DOMIVIK schema starter. Run in a NEW Supabase project SQL editor.
-- All household data is protected by RLS. Extend with explicit permission checks
-- before exposing shared mutations to non-owner members.
create extension if not exists pgcrypto;
create table public.households (id uuid primary key default gen_random_uuid(), name text not null, owner_id uuid not null references auth.users(id), created_at timestamptz not null default now());
create table public.memberships (household_id uuid not null references public.households(id) on delete cascade, user_id uuid not null references auth.users(id) on delete cascade, role text not null check(role in ('owner','member')), can_mark_bills_paid boolean not null default false, can_add_documents boolean not null default false, joined_at timestamptz not null default now(), primary key(household_id,user_id));
create or replace function public.is_household_member(h uuid) returns boolean language sql stable security definer set search_path = '' as $$ select exists(select 1 from public.memberships m where m.household_id=h and m.user_id=(select auth.uid())) $$;
create or replace function public.is_household_owner(h uuid) returns boolean language sql stable security definer set search_path = '' as $$ select exists(select 1 from public.households x where x.id=h and x.owner_id=(select auth.uid())) $$;
create table public.records (id uuid primary key default gen_random_uuid(), household_id uuid not null references public.households(id) on delete cascade, created_by uuid not null default auth.uid() references auth.users(id), kind text not null check(kind in ('product','receipt','bill','transaction','loan','vehicle','project','event','meter_reading')), title text not null, amount numeric(14,2), due_date date, metadata jsonb not null default '{}'::jsonb, visibility text not null default 'private' check(visibility in ('private','shared')), paid boolean not null default false, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create table public.documents (id uuid primary key default gen_random_uuid(), record_id uuid not null references public.records(id) on delete cascade, uploaded_by uuid not null default auth.uid() references auth.users(id), storage_path text not null, original_name text not null, mime_type text, created_at timestamptz not null default now());
alter table public.households enable row level security;
alter table public.memberships enable row level security;
alter table public.records enable row level security;
alter table public.documents enable row level security;
create policy households_select on public.households for select to authenticated using (public.is_household_member(id) or owner_id=(select auth.uid()));
create policy households_insert on public.households for insert to authenticated with check(owner_id=(select auth.uid()));
create policy households_update on public.households for update to authenticated using(owner_id=(select auth.uid())) with check(owner_id=(select auth.uid()));
create policy memberships_select on public.memberships for select to authenticated using(user_id=(select auth.uid()) or public.is_household_owner(household_id));
create policy memberships_insert_owner on public.memberships for insert to authenticated with check(public.is_household_owner(household_id));
create policy memberships_update_owner on public.memberships for update to authenticated using(public.is_household_owner(household_id)) with check(public.is_household_owner(household_id));
create policy memberships_delete_owner on public.memberships for delete to authenticated using(public.is_household_owner(household_id));
create policy records_select on public.records for select to authenticated using(public.is_household_member(household_id) and (visibility='shared' or created_by=(select auth.uid()) or public.is_household_owner(household_id)));
create policy records_insert on public.records for insert to authenticated with check(public.is_household_member(household_id) and created_by=(select auth.uid()) and (public.is_household_owner(household_id) or (kind='receipt' and exists(select 1 from public.memberships m where m.household_id=records.household_id and m.user_id=(select auth.uid()) and m.can_add_documents))));
create policy records_update on public.records for update to authenticated using(public.is_household_owner(household_id) or (created_by=(select auth.uid()) and public.is_household_member(household_id))) with check(public.is_household_member(household_id));
create policy records_delete on public.records for delete to authenticated using(public.is_household_owner(household_id) or (created_by=(select auth.uid()) and public.is_household_member(household_id)));
create policy documents_select on public.documents for select to authenticated using(exists(select 1 from public.records r where r.id=documents.record_id));
create policy documents_insert on public.documents for insert to authenticated with check(uploaded_by=(select auth.uid()) and exists(select 1 from public.records r where r.id=documents.record_id and (public.is_household_owner(r.household_id) or (r.created_by=(select auth.uid()) and public.is_household_member(r.household_id)))));
-- Security TODO: paid-only updates require a SECURITY DEFINER RPC that checks
-- can_mark_bills_paid and updates ONLY the paid column; no direct general UPDATE grant.
-- Security TODO: invite acceptance, storage bucket policies, audit trail, and
-- secure offline sync must be implemented and tested before real data is used.
