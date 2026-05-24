# Agentic OS DB (Postgres)

Local Postgres database for storing Agentic OS data saves (generic JSON record store).

## Prereqs

- One of:
  - Docker Desktop (with Docker Compose), or
  - A local Postgres install (you already have `psql` / `postgres`)

## Option A: Run Postgres via Docker (recommended if available)

1) From `agentic-db/`, create a `.env`:

- Copy `.env.example` to `.env`
- Update `POSTGRES_PASSWORD`

2) Start Postgres:

```powershell
docker compose up -d
```

3) Verify it’s healthy:

```powershell
docker compose ps
```

The first time the container creates the database, it will run `db/init.sql` automatically.

## Option B: Use your existing local Postgres (no Docker)

This repo includes a helper script that:
- creates/updates the app role + database
- applies `db/init.sql`

1) From `agentic-db/`, create and edit `.env`:

- Copy `.env.example` to `.env`
- Set a strong `POSTGRES_PASSWORD`

2) Run setup:

```powershell
.\scripts\setup-local.ps1
```

By default it connects as admin user `postgres` to admin DB `postgres` on `localhost:5432` and will prompt you for the admin password.

You can override admin connection via environment variables:
- `PGHOST` (default `localhost`)
- `PGPORT` (default `5432`)
- `PGADMINUSER` (default `postgres`)
- `PGADMINDB` (default `postgres`)

## Connect (psql)

After setup, connect with:

```powershell
psql "postgresql://agentic_user:YOUR_PASSWORD@localhost:5432/agentic_os"
```

## Quick usage

Create a namespace and upsert a JSON record:

```sql
INSERT INTO ao.namespaces (name)
VALUES ('notes')
ON CONFLICT (name) DO NOTHING;

INSERT INTO ao.records (namespace_id, key, value, tags)
VALUES (
  (SELECT id FROM ao.namespaces WHERE name = 'notes'),
  '2026-05-23-daily',
  '{"title":"Daily log","items":["idea: ...","todo: ..."]}'::jsonb,
  ARRAY['daily','journal']
)
ON CONFLICT (namespace_id, key)
DO UPDATE SET
  value = EXCLUDED.value,
  tags = EXCLUDED.tags,
  version = ao.records.version + 1;
```

Query latest saved records:

```sql
SELECT * FROM ao.latest_records LIMIT 25;
```

Query JSON fields (example):

```sql
SELECT
  n.name AS namespace,
  r.key,
  r.value->>'title' AS title
FROM ao.records r
JOIN ao.namespaces n ON n.id = r.namespace_id
WHERE n.name = 'notes'
ORDER BY r.updated_at DESC;
```

Append an event (audit trail / agent runs / tool calls):

```sql
INSERT INTO ao.events (namespace_id, event_type, payload)
VALUES (
  (SELECT id FROM ao.namespaces WHERE name = 'agentic-os'),
  'agent.run.completed',
  '{"agent":"cursor","status":"ok","duration_ms":1234}'::jsonb
);
```

## Stop / reset

Stop:

```powershell
docker compose down
```

Stop and delete all data:

```powershell
docker compose down -v
```

