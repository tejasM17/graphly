-- Local fixture data for exercising organization-scoped dashboard reads.
-- Replace the fixture IDs with real Clerk organization IDs to test in the app.
insert into public.organizations (id, name)
values
  ('org_seed_acme', 'Acme Engineering'),
  ('org_seed_studio', 'Studio North')
on conflict (id) do update set name = excluded.name;

insert into public.projects (id, organization_id, repository_url, repository_name)
values
  ('10000000-0000-4000-8000-000000000001', 'org_seed_acme', 'https://github.com/acme/web', 'acme/web'),
  ('20000000-0000-4000-8000-000000000001', 'org_seed_studio', 'https://github.com/studio-north/site', 'studio-north/site')
on conflict (id) do update
set repository_url = excluded.repository_url,
    repository_name = excluded.repository_name;

insert into public.analyses (id, organization_id, project_id, status, created_at, completed_at)
values
  ('10000000-0000-4000-8000-000000000002', 'org_seed_acme', '10000000-0000-4000-8000-000000000001', 'completed', now() - interval '2 hours', now() - interval '1 hour 58 minutes'),
  ('20000000-0000-4000-8000-000000000002', 'org_seed_studio', '20000000-0000-4000-8000-000000000001', 'running', now() - interval '5 minutes', null)
on conflict (id) do update
set status = excluded.status,
    created_at = excluded.created_at,
    completed_at = excluded.completed_at;
