create table public.organizations (
  id text primary key,
  name text not null,
  created_at timestamptz not null default now()
);

create table public.projects (
  id uuid primary key default gen_random_uuid(),
  organization_id text not null references public.organizations(id) on delete cascade,
  repository_url text not null,
  repository_name text not null,
  created_at timestamptz not null default now(),
  unique (organization_id, id)
);

create table public.analyses (
  id uuid primary key default gen_random_uuid(),
  organization_id text not null references public.organizations(id) on delete cascade,
  project_id uuid not null,
  status text not null check (status in ('queued', 'running', 'completed', 'failed')),
  created_at timestamptz not null default now(),
  completed_at timestamptz,
  unique (organization_id, id),
  foreign key (organization_id, project_id)
    references public.projects(organization_id, id) on delete cascade
);

create table public.files (
  id uuid primary key default gen_random_uuid(),
  organization_id text not null references public.organizations(id) on delete cascade,
  analysis_id uuid not null,
  path text not null,
  language text not null,
  created_at timestamptz not null default now(),
  unique (organization_id, id),
  unique (organization_id, analysis_id, path),
  foreign key (organization_id, analysis_id)
    references public.analyses(organization_id, id) on delete cascade
);

create table public.edges (
  id uuid primary key default gen_random_uuid(),
  organization_id text not null references public.organizations(id) on delete cascade,
  analysis_id uuid not null,
  source_file_id uuid not null,
  target_file_id uuid not null,
  specifier text not null,
  kind text not null check (kind in ('import', 're-export', 'dynamic-import', 'require')),
  created_at timestamptz not null default now(),
  foreign key (organization_id, analysis_id)
    references public.analyses(organization_id, id) on delete cascade,
  foreign key (organization_id, source_file_id)
    references public.files(organization_id, id) on delete cascade,
  foreign key (organization_id, target_file_id)
    references public.files(organization_id, id) on delete cascade
);

create table public.routes (
  id uuid primary key default gen_random_uuid(),
  organization_id text not null references public.organizations(id) on delete cascade,
  analysis_id uuid not null,
  file_id uuid not null,
  method text not null,
  path text not null,
  created_at timestamptz not null default now(),
  foreign key (organization_id, analysis_id)
    references public.analyses(organization_id, id) on delete cascade,
  foreign key (organization_id, file_id)
    references public.files(organization_id, id) on delete cascade
);

create table public.explanations (
  id uuid primary key default gen_random_uuid(),
  organization_id text not null references public.organizations(id) on delete cascade,
  analysis_id uuid not null,
  file_id uuid not null,
  body text not null,
  created_at timestamptz not null default now(),
  foreign key (organization_id, analysis_id)
    references public.analyses(organization_id, id) on delete cascade,
  foreign key (organization_id, file_id)
    references public.files(organization_id, id) on delete cascade
);

create table public.file_roles (
  id uuid primary key default gen_random_uuid(),
  organization_id text not null references public.organizations(id) on delete cascade,
  analysis_id uuid not null,
  file_id uuid not null,
  role text not null,
  created_at timestamptz not null default now(),
  foreign key (organization_id, analysis_id)
    references public.analyses(organization_id, id) on delete cascade,
  foreign key (organization_id, file_id)
    references public.files(organization_id, id) on delete cascade
);

create table public.insights (
  id uuid primary key default gen_random_uuid(),
  organization_id text not null references public.organizations(id) on delete cascade,
  analysis_id uuid not null,
  kind text not null,
  body text not null,
  created_at timestamptz not null default now(),
  foreign key (organization_id, analysis_id)
    references public.analyses(organization_id, id) on delete cascade
);

create index projects_organization_id_idx on public.projects (organization_id);
create index analyses_organization_id_created_at_idx on public.analyses (organization_id, created_at desc);
create index analyses_project_id_idx on public.analyses (organization_id, project_id);
create index files_analysis_id_idx on public.files (organization_id, analysis_id);
create index edges_analysis_id_idx on public.edges (organization_id, analysis_id);
create index edges_source_file_id_idx on public.edges (organization_id, source_file_id);
create index edges_target_file_id_idx on public.edges (organization_id, target_file_id);
create index routes_analysis_id_idx on public.routes (organization_id, analysis_id);
create index routes_file_id_idx on public.routes (organization_id, file_id);
create index explanations_analysis_id_idx on public.explanations (organization_id, analysis_id);
create index explanations_file_id_idx on public.explanations (organization_id, file_id);
create index file_roles_analysis_id_idx on public.file_roles (organization_id, analysis_id);
create index file_roles_file_id_idx on public.file_roles (organization_id, file_id);
create index insights_analysis_id_idx on public.insights (organization_id, analysis_id);

alter table public.organizations enable row level security;
alter table public.projects enable row level security;
alter table public.analyses enable row level security;
alter table public.files enable row level security;
alter table public.edges enable row level security;
alter table public.routes enable row level security;
alter table public.explanations enable row level security;
alter table public.file_roles enable row level security;
alter table public.insights enable row level security;

create policy "organization members can read their organization"
  on public.organizations for select to authenticated
  using (id = (select coalesce(auth.jwt()->>'org_id', auth.jwt()->'o'->>'id')));

create policy "organization members can read their projects"
  on public.projects for select to authenticated
  using (organization_id = (select coalesce(auth.jwt()->>'org_id', auth.jwt()->'o'->>'id')));

create policy "organization members can read their analyses"
  on public.analyses for select to authenticated
  using (organization_id = (select coalesce(auth.jwt()->>'org_id', auth.jwt()->'o'->>'id')));

create policy "organization members can read their files"
  on public.files for select to authenticated
  using (organization_id = (select coalesce(auth.jwt()->>'org_id', auth.jwt()->'o'->>'id')));

create policy "organization members can read their edges"
  on public.edges for select to authenticated
  using (organization_id = (select coalesce(auth.jwt()->>'org_id', auth.jwt()->'o'->>'id')));

create policy "organization members can read their routes"
  on public.routes for select to authenticated
  using (organization_id = (select coalesce(auth.jwt()->>'org_id', auth.jwt()->'o'->>'id')));

create policy "organization members can read their explanations"
  on public.explanations for select to authenticated
  using (organization_id = (select coalesce(auth.jwt()->>'org_id', auth.jwt()->'o'->>'id')));

create policy "organization members can read their file roles"
  on public.file_roles for select to authenticated
  using (organization_id = (select coalesce(auth.jwt()->>'org_id', auth.jwt()->'o'->>'id')));

create policy "organization members can read their insights"
  on public.insights for select to authenticated
  using (organization_id = (select coalesce(auth.jwt()->>'org_id', auth.jwt()->'o'->>'id')));

grant select on public.organizations, public.projects, public.analyses, public.files,
  public.edges, public.routes, public.explanations, public.file_roles, public.insights
  to authenticated;
