create table public.health_events (
    id uuid primary key default gen_random_uuid(),

    user_id uuid not null
        references public.profiles(id)
        on delete cascade,

    event_type text not null
        check (event_type in ('food', 'exercise', 'weight')),

    occurred_at timestamptz,

    occurred_precision text not null
        check (occurred_precision in ('exact', 'approximate', 'date_only', 'unknown')),

    source text not null
        check (source in ('natural_language', 'image', 'notion_recipe', 'manual', 'system')),

    status text not null default 'confirmed'
        check (status in ('pending', 'confirmed')),

    raw_input jsonb,

    confidence numeric,

    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

alter table public.health_events enable row level security;

create policy "Users can view their own health events"
on public.health_events
for select
to authenticated
using (user_id = auth.uid());

create policy "Users can create their own health events"
on public.health_events
for insert
to authenticated
with check (user_id = auth.uid());

create policy "Users can update their own health events"
on public.health_events
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

create policy "Users can delete their own health events"
on public.health_events
for delete
to authenticated
using (user_id = auth.uid());

-- Food entries
create table public.food_entries (
    id uuid primary key default gen_random_uuid(),

    event_id uuid not null
        references public.health_events(id)
        on delete cascade,

    name text not null,
    quantity numeric,
    unit text,

    calories numeric,
    protein_g numeric,
    carbs_g numeric,
    fat_g numeric,
    fiber_g numeric,

    nutrition_basis text,
    source_reference text,
    confidence numeric,
    notes text
);

-- Exercise entries
create table public.exercise_entries (
    event_id uuid primary key
        references public.health_events(id)
        on delete cascade,

    exercise_type text not null,
    duration_minutes numeric,
    repetitions numeric,
    intensity text,
    calories_burned numeric,
    notes text
);

-- Weight entries
create table public.weight_entries (
    event_id uuid primary key
        references public.health_events(id)
        on delete cascade,

    weight_kg numeric not null,
    measurement_context text,
    notes text
);


-- Enable RLS
alter table public.food_entries enable row level security;
alter table public.exercise_entries enable row level security;
alter table public.weight_entries enable row level security;


-- Food entries policies
create policy "Users can view their own food entries"
on public.food_entries
for select
to authenticated
using (
    exists (
        select 1
        from public.health_events
        where health_events.id = food_entries.event_id
        and health_events.user_id = auth.uid()
    )
);

create policy "Users can create their own food entries"
on public.food_entries
for insert
to authenticated
with check (
    exists (
        select 1
        from public.health_events
        where health_events.id = food_entries.event_id
        and health_events.user_id = auth.uid()
    )
);

create policy "Users can update their own food entries"
on public.food_entries
for update
to authenticated
using (
    exists (
        select 1
        from public.health_events
        where health_events.id = food_entries.event_id
        and health_events.user_id = auth.uid()
    )
)
with check (
    exists (
        select 1
        from public.health_events
        where health_events.id = food_entries.event_id
        and health_events.user_id = auth.uid()
    )
);

create policy "Users can delete their own food entries"
on public.food_entries
for delete
to authenticated
using (
    exists (
        select 1
        from public.health_events
        where health_events.id = food_entries.event_id
        and health_events.user_id = auth.uid()
    )
);


-- Exercise entries policies
create policy "Users can view their own exercise entries"
on public.exercise_entries
for select
to authenticated
using (
    exists (
        select 1
        from public.health_events
        where health_events.id = exercise_entries.event_id
        and health_events.user_id = auth.uid()
    )
);

create policy "Users can create their own exercise entries"
on public.exercise_entries
for insert
to authenticated
with check (
    exists (
        select 1
        from public.health_events
        where health_events.id = exercise_entries.event_id
        and health_events.user_id = auth.uid()
    )
);

create policy "Users can update their own exercise entries"
on public.exercise_entries
for update
to authenticated
using (
    exists (
        select 1
        from public.health_events
        where health_events.id = exercise_entries.event_id
        and health_events.user_id = auth.uid()
    )
)
with check (
    exists (
        select 1
        from public.health_events
        where health_events.id = exercise_entries.event_id
        and health_events.user_id = auth.uid()
    )
);

create policy "Users can delete their own exercise entries"
on public.exercise_entries
for delete
to authenticated
using (
    exists (
        select 1
        from public.health_events
        where health_events.id = exercise_entries.event_id
        and health_events.user_id = auth.uid()
    )
);


-- Weight entries policies
create policy "Users can view their own weight entries"
on public.weight_entries
for select
to authenticated
using (
    exists (
        select 1
        from public.health_events
        where health_events.id = weight_entries.event_id
        and health_events.user_id = auth.uid()
    )
);

create policy "Users can create their own weight entries"
on public.weight_entries
for insert
to authenticated
with check (
    exists (
        select 1
        from public.health_events
        where health_events.id = weight_entries.event_id
        and health_events.user_id = auth.uid()
    )
);

create policy "Users can update their own weight entries"
on public.weight_entries
for update
to authenticated
using (
    exists (
        select 1
        from public.health_events
        where health_events.id = weight_entries.event_id
        and health_events.user_id = auth.uid()
    )
)
with check (
    exists (
        select 1
        from public.health_events
        where health_events.id = weight_entries.event_id
        and health_events.user_id = auth.uid()
    )
);

create policy "Users can delete their own weight entries"
on public.weight_entries
for delete
to authenticated
using (
    exists (
        select 1
        from public.health_events
        where health_events.id = weight_entries.event_id
        and health_events.user_id = auth.uid()
    )
);