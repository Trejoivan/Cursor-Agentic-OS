BEGIN;

-- Generic Agentic OS datastore (JSON-first) lives in its own schema.
-- This is intentionally minimal: namespaces + records (KV-ish) + append-only events.
CREATE SCHEMA IF NOT EXISTS ao;

-- updated_at maintenance
CREATE OR REPLACE FUNCTION ao.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS ao.namespaces (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS ao.records (
  id BIGSERIAL PRIMARY KEY,
  namespace_id BIGINT NOT NULL REFERENCES ao.namespaces(id) ON DELETE CASCADE,
  key TEXT NOT NULL,
  value JSONB NOT NULL DEFAULT '{}'::jsonb,
  tags TEXT[] NOT NULL DEFAULT ARRAY[]::text[],
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  version INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (namespace_id, key)
);

DROP TRIGGER IF EXISTS trg_records_set_updated_at ON ao.records;
CREATE TRIGGER trg_records_set_updated_at
BEFORE UPDATE ON ao.records
FOR EACH ROW
EXECUTE FUNCTION ao.set_updated_at();

CREATE INDEX IF NOT EXISTS idx_ao_records_namespace_id ON ao.records (namespace_id);
CREATE INDEX IF NOT EXISTS idx_ao_records_key ON ao.records (key);
CREATE INDEX IF NOT EXISTS idx_ao_records_tags_gin ON ao.records USING GIN (tags);
CREATE INDEX IF NOT EXISTS idx_ao_records_value_gin ON ao.records USING GIN (value jsonb_path_ops);

CREATE TABLE IF NOT EXISTS ao.events (
  id BIGSERIAL PRIMARY KEY,
  namespace_id BIGINT REFERENCES ao.namespaces(id) ON DELETE SET NULL,
  event_type TEXT NOT NULL,
  payload JSONB NOT NULL DEFAULT '{}'::jsonb,
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_ao_events_occurred_at ON ao.events (occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_ao_events_type ON ao.events (event_type);
CREATE INDEX IF NOT EXISTS idx_ao_events_payload_gin ON ao.events USING GIN (payload jsonb_path_ops);

-- Convenience view for "latest records" browsing
CREATE OR REPLACE VIEW ao.latest_records AS
SELECT
  n.name AS namespace,
  r.key,
  r.value,
  r.tags,
  r.version,
  r.updated_at
FROM ao.records r
JOIN ao.namespaces n ON n.id = r.namespace_id
ORDER BY r.updated_at DESC;

-- Starter namespaces (safe on re-run)
INSERT INTO ao.namespaces (name) VALUES
  ('agentic-os'),
  ('personal-os'),
  ('work-os'),
  ('meeting-os'),
  ('career-os')
ON CONFLICT (name) DO NOTHING;

COMMIT;
