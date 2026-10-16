-- Supabase / PostgreSQL migration. Apply after configuring authenticated users.
create table public.words (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 word text not null, kana text not null, meaning text not null, example text not null default '',
 level text not null default 'N5', mastery integer not null default 0 check (mastery between 0 and 2),
 due date not null default current_date, created_at timestamptz not null default now()
);
create table public.grammar_notes (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 title text not null, content text not null, example text not null default '', created_at timestamptz not null default now()
);
create table public.learning_logs (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 date date not null, type text not null check (type in ('word','grammar','review','task','kana','speaking','reading')),
 detail text not null, created_at timestamptz not null default now()
);
create index words_user_due on public.words(user_id,due);
create index learning_logs_user_date on public.learning_logs(user_id,date);
alter table public.words enable row level security;
alter table public.grammar_notes enable row level security;
alter table public.learning_logs enable row level security;
create policy own_words on public.words for all to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy own_grammar on public.grammar_notes for all to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy own_logs on public.learning_logs for all to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);
