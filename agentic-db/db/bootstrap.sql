\set ON_ERROR_STOP on

DO $$
DECLARE
  app_user TEXT := :'app_user';
  app_password TEXT := :'app_password';
  app_db TEXT := :'app_db';
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = app_user) THEN
    EXECUTE format('CREATE ROLE %I LOGIN PASSWORD %L', app_user, app_password);
  ELSE
    EXECUTE format('ALTER ROLE %I WITH LOGIN PASSWORD %L', app_user, app_password);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = app_db) THEN
    EXECUTE format('CREATE DATABASE %I OWNER %I', app_db, app_user);
  END IF;
END
$$;

