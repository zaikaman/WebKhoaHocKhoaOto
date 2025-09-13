--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 17.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA pgsodium;


ALTER SCHEMA pgsodium OWNER TO supabase_admin;

--
-- Name: pgsodium; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgsodium WITH SCHEMA pgsodium;


--
-- Name: EXTENSION pgsodium; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgsodium IS 'Pgsodium is a modern cryptography library for Postgres.';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
begin
  insert into public.profiles (id, student_id, full_name, role)
  values (
    new.id, 
    split_part(new.email, '@', 1), -- Lấy mã số từ phần đầu của email
    coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)),
    case 
      when split_part(new.email, '@', 1) = 'admin' then 'admin'
      when split_part(new.email, '@', 1) similar to 'gv[0-9]+' then 'teacher'
      else 'student'
    end
  );
  return new;
end;
$$;


ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(objects.path_tokens, 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

--
-- Name: secrets_encrypt_secret_secret(); Type: FUNCTION; Schema: vault; Owner: supabase_admin
--

CREATE FUNCTION vault.secrets_encrypt_secret_secret() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		BEGIN
		        new.secret = CASE WHEN new.secret IS NULL THEN NULL ELSE
			CASE WHEN new.key_id IS NULL THEN NULL ELSE pg_catalog.encode(
			  pgsodium.crypto_aead_det_encrypt(
				pg_catalog.convert_to(new.secret, 'utf8'),
				pg_catalog.convert_to((new.id::text || new.description::text || new.created_at::text || new.updated_at::text)::text, 'utf8'),
				new.key_id::uuid,
				new.nonce
			  ),
				'base64') END END;
		RETURN new;
		END;
		$$;


ALTER FUNCTION vault.secrets_encrypt_secret_secret() OWNER TO supabase_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_id text NOT NULL,
    client_secret_hash text NOT NULL,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity_logs (
    id bigint NOT NULL,
    activity_type text NOT NULL,
    details text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.activity_logs OWNER TO postgres;

--
-- Name: activity_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.activity_logs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.activity_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: assignment_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assignment_questions (
    id bigint NOT NULL,
    assignment_id uuid,
    content text NOT NULL,
    type text NOT NULL,
    points numeric(5,2) NOT NULL,
    options jsonb,
    correct_answer text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);


ALTER TABLE public.assignment_questions OWNER TO postgres;

--
-- Name: assignment_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.assignment_questions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.assignment_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: assignment_submissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assignment_submissions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    assignment_id uuid,
    student_id uuid,
    content text,
    file_url text,
    score numeric(5,2),
    submitted_at timestamp with time zone,
    graded_at timestamp with time zone,
    feedback text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    answers jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.assignment_submissions OWNER TO postgres;

--
-- Name: assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assignments (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    class_id uuid,
    title text NOT NULL,
    description text,
    due_date timestamp with time zone NOT NULL,
    total_points numeric(5,2) DEFAULT 10,
    file_url text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    type text DEFAULT 'multiple_choice'::text NOT NULL
);


ALTER TABLE public.assignments OWNER TO postgres;

--
-- Name: classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classes (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    subject_id uuid,
    teacher_id uuid,
    code text NOT NULL,
    name text NOT NULL,
    semester text NOT NULL,
    academic_year text NOT NULL,
    status text DEFAULT 'active'::text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);


ALTER TABLE public.classes OWNER TO postgres;

--
-- Name: enrollments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enrollments (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    class_id uuid,
    student_id uuid,
    status text DEFAULT 'enrolled'::text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);


ALTER TABLE public.enrollments OWNER TO postgres;

--
-- Name: exam_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exam_questions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    exam_id uuid,
    content text NOT NULL,
    type text NOT NULL,
    points numeric(5,2) NOT NULL,
    options jsonb,
    correct_answer text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);


ALTER TABLE public.exam_questions OWNER TO postgres;

--
-- Name: exam_submissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exam_submissions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    exam_id uuid,
    student_id uuid,
    answers jsonb,
    score numeric(5,2),
    submitted_at timestamp with time zone,
    graded_at timestamp with time zone,
    feedback text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    file_url text,
    content text
);


ALTER TABLE public.exam_submissions OWNER TO postgres;

--
-- Name: COLUMN exam_submissions.file_url; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.exam_submissions.file_url IS 'URL của file đính kèm bài nộp';


--
-- Name: COLUMN exam_submissions.content; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.exam_submissions.content IS 'Nội dung bài làm dạng text';


--
-- Name: exams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exams (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    class_id uuid,
    title text NOT NULL,
    description text,
    type text NOT NULL,
    duration integer NOT NULL,
    total_points numeric(5,2) DEFAULT 10,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    status text DEFAULT 'upcoming'::text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);


ALTER TABLE public.exams OWNER TO postgres;

--
-- Name: lectures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lectures (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    class_id uuid,
    title text NOT NULL,
    description text,
    file_url text NOT NULL,
    file_type text NOT NULL,
    file_size integer NOT NULL,
    download_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    original_filename text
);


ALTER TABLE public.lectures OWNER TO postgres;

--
-- Name: COLUMN lectures.original_filename; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.lectures.original_filename IS 'Tên file gốc khi upload';


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    student_id text NOT NULL,
    full_name text,
    role text NOT NULL,
    class_code text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    CONSTRAINT profiles_role_check CHECK ((role = ANY (ARRAY['student'::text, 'teacher'::text, 'admin'::text]))),
    CONSTRAINT profiles_status_check CHECK ((status = ANY (ARRAY['active'::text, 'inactive'::text])))
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subjects (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    description text,
    credits integer NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);


ALTER TABLE public.subjects OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	03157925-3427-4a6e-9ba5-5f5e371d67f4	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"student@auto.edu.vn","user_id":"e6f5b15e-f908-45ee-8b9b-60ff4762fa9e","user_phone":""}}	2025-02-20 16:46:50.497318+00	
00000000-0000-0000-0000-000000000000	2e90fa49-a209-409c-94f3-4f7e3a731141	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"teacher@auto.edu.vn","user_id":"1d4c4d08-c072-4de6-b97a-45baedc58970","user_phone":""}}	2025-02-20 16:47:14.402517+00	
00000000-0000-0000-0000-000000000000	d4f47a54-c8d3-42eb-b7f6-2ddc96ab68d8	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"student@auto.edu.vn","user_id":"e6f5b15e-f908-45ee-8b9b-60ff4762fa9e","user_phone":""}}	2025-02-20 17:00:30.360893+00	
00000000-0000-0000-0000-000000000000	b88fe17c-c0dc-474d-877f-709698ad79e9	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"teacher@auto.edu.vn","user_id":"1d4c4d08-c072-4de6-b97a-45baedc58970","user_phone":""}}	2025-02-20 17:01:53.92985+00	
00000000-0000-0000-0000-000000000000	60b2d3c4-0192-456a-827f-f932ece252f6	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"3122560072@auto.edu.vn","user_id":"675cb387-258d-46c9-a647-1a9230adc7f4","user_phone":""}}	2025-02-20 17:02:37.483297+00	
00000000-0000-0000-0000-000000000000	31b7f24b-074e-48fe-b11d-ac7ea2610292	{"action":"login","actor_id":"675cb387-258d-46c9-a647-1a9230adc7f4","actor_username":"3122560072@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-20 17:06:16.485245+00	
00000000-0000-0000-0000-000000000000	a5e93a7b-21c6-42af-a430-e33a0425f7f2	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"gv001@auto.edu.vn","user_id":"1d599439-3ef7-48c5-9dd6-8d5a693db54c","user_phone":""}}	2025-02-20 17:07:58.67533+00	
00000000-0000-0000-0000-000000000000	dd4e1666-d669-4d36-8735-c23c1051dbf6	{"action":"login","actor_id":"1d599439-3ef7-48c5-9dd6-8d5a693db54c","actor_username":"gv001@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-20 17:08:26.488002+00	
00000000-0000-0000-0000-000000000000	7468be74-ee0d-4ecd-8c0b-30ec20cb74b3	{"action":"token_refreshed","actor_id":"1d599439-3ef7-48c5-9dd6-8d5a693db54c","actor_username":"gv001@auto.edu.vn","actor_via_sso":false,"log_type":"token"}	2025-02-21 04:16:56.780717+00	
00000000-0000-0000-0000-000000000000	c2c98a76-e5b4-4074-8919-62ba7c97a308	{"action":"token_revoked","actor_id":"1d599439-3ef7-48c5-9dd6-8d5a693db54c","actor_username":"gv001@auto.edu.vn","actor_via_sso":false,"log_type":"token"}	2025-02-21 04:16:56.790063+00	
00000000-0000-0000-0000-000000000000	2d171169-395b-4939-9b70-4456da72c327	{"action":"login","actor_id":"1d599439-3ef7-48c5-9dd6-8d5a693db54c","actor_username":"gv001@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:17:55.60448+00	
00000000-0000-0000-0000-000000000000	5dec0798-106d-432d-9ba4-c0be9d873104	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"admin@auto.edu.vn","user_id":"a204e5f6-3d70-457a-ba66-244977d74290","user_phone":""}}	2025-02-21 04:22:26.930356+00	
00000000-0000-0000-0000-000000000000	256e3928-a19f-4702-962c-b54c26b9d9de	{"action":"login","actor_id":"1d599439-3ef7-48c5-9dd6-8d5a693db54c","actor_username":"gv001@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:25:59.976867+00	
00000000-0000-0000-0000-000000000000	76646232-d373-4dc1-8c23-8d61633aceea	{"action":"login","actor_id":"1d599439-3ef7-48c5-9dd6-8d5a693db54c","actor_username":"gv001@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:26:05.980837+00	
00000000-0000-0000-0000-000000000000	221dacec-7306-4e58-a2f7-fdc1b111de1a	{"action":"login","actor_id":"1d599439-3ef7-48c5-9dd6-8d5a693db54c","actor_username":"gv001@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:26:07.898842+00	
00000000-0000-0000-0000-000000000000	0236b87e-dd9a-4056-909a-b403c555d55b	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:26:24.730796+00	
00000000-0000-0000-0000-000000000000	8c6e7aad-d82e-4c4a-9a81-e45b7c961b6c	{"action":"login","actor_id":"1d599439-3ef7-48c5-9dd6-8d5a693db54c","actor_username":"gv001@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:26:37.89759+00	
00000000-0000-0000-0000-000000000000	8f076323-456b-4aec-83d0-31ce337a40c0	{"action":"login","actor_id":"1d599439-3ef7-48c5-9dd6-8d5a693db54c","actor_username":"gv001@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:28:15.637219+00	
00000000-0000-0000-0000-000000000000	a408372d-28a0-46ac-9f11-cb7d60289688	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:28:21.029671+00	
00000000-0000-0000-0000-000000000000	e2038477-0e1d-4394-9a1e-2f226d47a546	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:29:52.92423+00	
00000000-0000-0000-0000-000000000000	e2760844-949e-4ce7-9c04-1b6eb83f68d0	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:29:58.244964+00	
00000000-0000-0000-0000-000000000000	03882abf-141e-42d5-8cf2-315269a9aaba	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:30:52.806231+00	
00000000-0000-0000-0000-000000000000	500fb769-0305-428c-b0b9-352de54ccb70	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:31:15.052515+00	
00000000-0000-0000-0000-000000000000	83ff0c75-ad02-4f28-8555-5ac58f3af5df	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:31:28.008791+00	
00000000-0000-0000-0000-000000000000	5d9173f1-db7a-420b-9954-0e28a80873e5	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:32:33.170871+00	
00000000-0000-0000-0000-000000000000	07a4ceca-4913-4288-80c7-c19b59ed172a	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:32:42.816305+00	
00000000-0000-0000-0000-000000000000	3d24fb26-ae27-402d-a62d-2c7661521685	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:32:45.895319+00	
00000000-0000-0000-0000-000000000000	17a0cd5f-7f3c-4183-b4b8-9bf329d7b0d9	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:34:15.372175+00	
00000000-0000-0000-0000-000000000000	ebe85841-01cf-425e-8670-0b0485ed2394	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:34:46.708062+00	
00000000-0000-0000-0000-000000000000	fa55dfae-23a7-434a-bf3f-cbb31be46a4b	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:37:02.316846+00	
00000000-0000-0000-0000-000000000000	dcca1221-f5e5-49dc-ac4d-d602881fea22	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:37:14.124952+00	
00000000-0000-0000-0000-000000000000	d9406113-5c09-4be9-b1e2-794175e16686	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:37:23.680255+00	
00000000-0000-0000-0000-000000000000	0bd2f14b-2cf8-43a6-a19c-f78e968357e8	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:37:54.958152+00	
00000000-0000-0000-0000-000000000000	acf0b65a-af74-44b2-a376-2cdf32f2b30c	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:42:37.792182+00	
00000000-0000-0000-0000-000000000000	570f0663-0323-474f-b731-b543de28e5c0	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:42:54.511968+00	
00000000-0000-0000-0000-000000000000	03c4550a-e36e-48d1-b5e3-6f179d704892	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:45:59.513852+00	
00000000-0000-0000-0000-000000000000	804157d8-c486-4c42-9d17-06d1e6f25621	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:46:03.314525+00	
00000000-0000-0000-0000-000000000000	dc1a0b84-b0de-4b4a-8a74-a75df9ba93d5	{"action":"login","actor_id":"675cb387-258d-46c9-a647-1a9230adc7f4","actor_username":"3122560072@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:46:38.258252+00	
00000000-0000-0000-0000-000000000000	773fa51a-992c-442e-9166-d60b99c4ed86	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:48:26.361829+00	
00000000-0000-0000-0000-000000000000	03aa0d95-59e3-4154-bc2e-f67a5eea6f0e	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:50:02.884086+00	
00000000-0000-0000-0000-000000000000	540afa08-a370-4cc1-8bc9-2794870f3a54	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:50:08.761178+00	
00000000-0000-0000-0000-000000000000	293d4bba-4b54-40e2-b434-f17bb5ccbb06	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:50:32.403036+00	
00000000-0000-0000-0000-000000000000	fa7e5b69-9012-424c-9be2-8f887152bb41	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:51:42.696111+00	
00000000-0000-0000-0000-000000000000	026ce3c5-6b9b-41e9-8f7a-49ebf6821509	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:51:50.921172+00	
00000000-0000-0000-0000-000000000000	ad3035ea-8526-4f5f-adfe-02188f143ea3	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:53:11.595687+00	
00000000-0000-0000-0000-000000000000	0018fc84-c0cc-45e1-9328-a8ef09e58802	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:54:38.41895+00	
00000000-0000-0000-0000-000000000000	ce9ab9f3-9eea-4833-94e1-5635bc2b4dd1	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:54:50.284238+00	
00000000-0000-0000-0000-000000000000	e2d67d1b-e09f-4145-9622-798a9d87c99c	{"action":"login","actor_id":"a204e5f6-3d70-457a-ba66-244977d74290","actor_username":"admin@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:58:21.723426+00	
00000000-0000-0000-0000-000000000000	fccacc97-b414-4d3a-8f4a-905132409c94	{"action":"login","actor_id":"1d599439-3ef7-48c5-9dd6-8d5a693db54c","actor_username":"gv001@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 04:58:26.235607+00	
00000000-0000-0000-0000-000000000000	ba08a79f-4a32-4adf-a692-8f4c34aab1cd	{"action":"login","actor_id":"1d599439-3ef7-48c5-9dd6-8d5a693db54c","actor_username":"gv001@auto.edu.vn","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 05:00:14.948057+00	
00000000-0000-0000-0000-000000000000	bc538f37-259b-460e-93be-5777ebd7a9c7	{"action":"user_confirmation_requested","actor_id":"73cd034e-7676-4aa8-8031-6ab985a58988","actor_username":"3122560075@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-02-21 05:26:36.255883+00	
00000000-0000-0000-0000-000000000000	822b359d-a859-4b73-8333-83a94b863bf8	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"3122560075@gmail.com","user_id":"73cd034e-7676-4aa8-8031-6ab985a58988","user_phone":""}}	2025-02-21 05:27:03.371143+00	
00000000-0000-0000-0000-000000000000	f1e449aa-b753-4b6e-ba54-a4cb635bd9a5	{"action":"user_confirmation_requested","actor_id":"cfecc79e-b806-42ab-80a8-06db1cd47f68","actor_username":"3122560073@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-02-21 05:27:49.943183+00	
00000000-0000-0000-0000-000000000000	c88fc9c1-63a4-4114-b787-a848747c3a62	{"action":"user_signedup","actor_id":"7337bd71-d43c-4989-9129-c46bed93b4e7","actor_username":"3122560172@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-21 05:29:26.046279+00	
00000000-0000-0000-0000-000000000000	c872348e-7b73-47c3-8704-0cc66864a8bd	{"action":"login","actor_id":"7337bd71-d43c-4989-9129-c46bed93b4e7","actor_username":"3122560172@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 05:29:26.050967+00	
00000000-0000-0000-0000-000000000000	30694168-b35e-42c2-8cac-7590fdbdedfd	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"3122560073@gmail.com","user_id":"cfecc79e-b806-42ab-80a8-06db1cd47f68","user_phone":""}}	2025-02-21 05:29:52.664985+00	
00000000-0000-0000-0000-000000000000	634853b5-a7ff-4dd6-8786-58942e575b3b	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"3122560172@gmail.com","user_id":"7337bd71-d43c-4989-9129-c46bed93b4e7","user_phone":""}}	2025-02-21 05:29:52.732272+00	
00000000-0000-0000-0000-000000000000	b352537b-98dc-4636-9500-f76a5b2bf43d	{"action":"user_signedup","actor_id":"dc743d86-49ee-43d6-a8c7-eb7a8b032a93","actor_username":"3122560572@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-21 05:32:45.74942+00	
00000000-0000-0000-0000-000000000000	b8b9e9df-4b96-4db8-8d1e-f0c8b1fa610f	{"action":"login","actor_id":"dc743d86-49ee-43d6-a8c7-eb7a8b032a93","actor_username":"3122560572@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 05:32:45.753213+00	
00000000-0000-0000-0000-000000000000	f275f186-55e0-4713-b5e1-871e875fb181	{"action":"user_signedup","actor_id":"0af601e2-d596-49c7-9b53-12d86ecb6d12","actor_username":"3122569072@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-21 05:34:02.946085+00	
00000000-0000-0000-0000-000000000000	15877fe4-677e-4894-8d70-e2c3c1ca996e	{"action":"login","actor_id":"0af601e2-d596-49c7-9b53-12d86ecb6d12","actor_username":"3122569072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 05:34:02.950913+00	
00000000-0000-0000-0000-000000000000	1ab2e9f7-19b2-4c52-8c91-68fec9897030	{"action":"user_signedup","actor_id":"620de24c-a40a-432a-be36-86852092f3c1","actor_username":"3122569172@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-21 05:37:07.006592+00	
00000000-0000-0000-0000-000000000000	803c7995-2037-498a-8b43-349274a35aef	{"action":"login","actor_id":"620de24c-a40a-432a-be36-86852092f3c1","actor_username":"3122569172@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 05:37:07.01039+00	
00000000-0000-0000-0000-000000000000	c0e58374-0901-44b4-9643-dbf5060a3600	{"action":"login","actor_id":"620de24c-a40a-432a-be36-86852092f3c1","actor_username":"3122569172@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 05:46:18.157362+00	
00000000-0000-0000-0000-000000000000	94056d84-f444-4c8b-9713-f75ecb2ceae9	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"admin@auto.edu.vn","user_id":"a204e5f6-3d70-457a-ba66-244977d74290","user_phone":""}}	2025-02-21 05:46:57.8684+00	
00000000-0000-0000-0000-000000000000	0ceee295-c204-492c-848e-7e003fc41fcb	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"3122560072@auto.edu.vn","user_id":"675cb387-258d-46c9-a647-1a9230adc7f4","user_phone":""}}	2025-02-21 05:46:57.996493+00	
00000000-0000-0000-0000-000000000000	a7aed380-3ed2-4822-9672-fa603d7c98e3	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"gv001@auto.edu.vn","user_id":"1d599439-3ef7-48c5-9dd6-8d5a693db54c","user_phone":""}}	2025-02-21 05:46:58.060809+00	
00000000-0000-0000-0000-000000000000	2cbae47e-33f8-493c-afe1-69571b098d87	{"action":"user_signedup","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-21 05:51:03.421851+00	
00000000-0000-0000-0000-000000000000	ddccc50c-c404-4edd-a499-e0717098d4e9	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 05:51:03.426597+00	
00000000-0000-0000-0000-000000000000	fa340c3a-2732-4326-a408-b5bc79b96d9c	{"action":"user_signedup","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-21 05:51:53.362581+00	
00000000-0000-0000-0000-000000000000	981da9c9-79ce-4005-879d-ff09ad3fff7e	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 05:51:53.365527+00	
00000000-0000-0000-0000-000000000000	0c1fccbe-504a-477f-8715-8fa15a798b67	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 05:52:08.810201+00	
00000000-0000-0000-0000-000000000000	5baedf85-b3c9-4338-9d9a-6fb6fdc6e427	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-21 07:43:26.246022+00	
00000000-0000-0000-0000-000000000000	677f4995-f4f4-468f-b2e3-cb650d6ee12b	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-21 07:43:26.263599+00	
00000000-0000-0000-0000-000000000000	df343005-7559-4aed-b3df-8302d82d7e96	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-21 07:43:26.972011+00	
00000000-0000-0000-0000-000000000000	cff15831-ad84-4805-82ab-78766b61144e	{"action":"user_signedup","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-21 08:15:30.224858+00	
00000000-0000-0000-0000-000000000000	fb8e09a0-ade5-4afb-a13a-6d1574d34107	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 08:15:30.233077+00	
00000000-0000-0000-0000-000000000000	bb66f67e-de8a-4c63-bf84-d7cf246e8cc1	{"action":"token_refreshed","actor_id":"620de24c-a40a-432a-be36-86852092f3c1","actor_username":"3122569172@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-21 09:59:09.817921+00	
00000000-0000-0000-0000-000000000000	cf36f8e4-2186-4462-86a1-c0465dbb2729	{"action":"token_revoked","actor_id":"620de24c-a40a-432a-be36-86852092f3c1","actor_username":"3122569172@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-21 09:59:09.821546+00	
00000000-0000-0000-0000-000000000000	bd063e47-ff50-4280-a037-30d5ba07af49	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 09:59:17.504569+00	
00000000-0000-0000-0000-000000000000	1274f8c9-b6f8-4bcb-b0da-2a0a6101f45b	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 10:06:51.760055+00	
00000000-0000-0000-0000-000000000000	fb346e2e-0885-4cb8-8bea-285837f76d79	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 10:06:54.929978+00	
00000000-0000-0000-0000-000000000000	aaf56311-ef86-4b0a-9939-ba4e19df737c	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 10:07:02.305722+00	
00000000-0000-0000-0000-000000000000	7af676a3-76a3-4bc4-94ec-be1398e24743	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 10:07:10.35554+00	
00000000-0000-0000-0000-000000000000	6cc0ea95-5ea9-4c77-8d31-07fe281da30c	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 10:09:43.267442+00	
00000000-0000-0000-0000-000000000000	9cc24c07-0744-4817-9843-ffa50e972ca2	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-21 10:11:16.005101+00	
00000000-0000-0000-0000-000000000000	df59b508-2498-4e39-b9f3-1d36b3f2cf1e	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 10:11:17.725216+00	
00000000-0000-0000-0000-000000000000	16683b6b-200c-49f2-8817-60a86d3d77f7	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-21 10:11:52.341152+00	
00000000-0000-0000-0000-000000000000	1b4e5ca7-ee7b-420d-862f-84b3afa2ae7b	{"action":"login","actor_id":"620de24c-a40a-432a-be36-86852092f3c1","actor_username":"3122569172@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 10:11:57.218843+00	
00000000-0000-0000-0000-000000000000	505c7b76-5a84-4c91-a4d0-abb633c02dd3	{"action":"logout","actor_id":"620de24c-a40a-432a-be36-86852092f3c1","actor_username":"3122569172@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-21 10:12:01.61553+00	
00000000-0000-0000-0000-000000000000	0d6fb90d-a0bf-41b4-873a-129a8524bc7a	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 10:15:27.80858+00	
00000000-0000-0000-0000-000000000000	14e24f8c-0b8a-4d9f-9555-2f0252613105	{"action":"user_signedup","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-21 10:17:00.937558+00	
00000000-0000-0000-0000-000000000000	278ea72f-121c-45aa-b79c-ef31a41f9978	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 10:17:00.941855+00	
00000000-0000-0000-0000-000000000000	08f6b832-0eb7-4487-b2df-10313d2de90f	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 10:17:34.116936+00	
00000000-0000-0000-0000-000000000000	0c0dcb80-9625-4d33-983e-04ab9afc7eec	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 10:40:57.172786+00	
00000000-0000-0000-0000-000000000000	a21078c2-1c61-4805-aafe-a23b8d88c1ec	{"action":"user_signedup","actor_id":"2956b155-1d48-4058-acdb-c1151fa5c9fd","actor_username":"gv002@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-02-21 10:44:50.44744+00	
00000000-0000-0000-0000-000000000000	aadcadec-75a2-4ed3-beb3-0bd7c897a7e6	{"action":"login","actor_id":"2956b155-1d48-4058-acdb-c1151fa5c9fd","actor_username":"gv002@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 10:44:50.451424+00	
00000000-0000-0000-0000-000000000000	ef4739cf-5f98-42ce-9a95-db52abf23191	{"action":"login","actor_id":"2956b155-1d48-4058-acdb-c1151fa5c9fd","actor_username":"gv002@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 10:45:04.10563+00	
00000000-0000-0000-0000-000000000000	97886d85-50af-49bc-9b45-9278c12edb18	{"action":"token_refreshed","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-21 11:05:34.951338+00	
00000000-0000-0000-0000-000000000000	6b956d46-494c-455c-bcd8-90e875251613	{"action":"token_revoked","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-21 11:05:34.953277+00	
00000000-0000-0000-0000-000000000000	09c597ad-6ded-4011-99f1-e4d02ab5025b	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 11:06:44.031887+00	
00000000-0000-0000-0000-000000000000	e8070e33-4001-459f-b743-bb6e191d0dae	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 11:24:59.819431+00	
00000000-0000-0000-0000-000000000000	2dc6ffe5-4e1c-4dd5-a466-c3353068e2f8	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-21 11:26:42.461473+00	
00000000-0000-0000-0000-000000000000	e77186a7-7bdb-4abb-a0e6-486b573a8823	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 11:27:05.833667+00	
00000000-0000-0000-0000-000000000000	ba1dceeb-b555-447d-afff-901c180c8a18	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-21 11:38:05.612499+00	
00000000-0000-0000-0000-000000000000	a0da86c2-72b4-42df-9523-1b645bfcac7a	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-22 13:55:06.071152+00	
00000000-0000-0000-0000-000000000000	66426ab1-5fc7-47a7-a1ee-e5735d3862e6	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-22 13:55:06.084036+00	
00000000-0000-0000-0000-000000000000	b8a5b285-b84b-4a29-8b3c-8bcfc6e85912	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-22 13:55:06.144076+00	
00000000-0000-0000-0000-000000000000	b50ae0a3-2a8d-42bc-8514-ab03096f9f24	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 04:18:53.009067+00	
00000000-0000-0000-0000-000000000000	356570e6-549d-4d08-8003-adbb78bd91e0	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 04:19:40.305601+00	
00000000-0000-0000-0000-000000000000	fba2e9de-e1d5-41cb-8b69-d6a91909bebf	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 04:21:15.886941+00	
00000000-0000-0000-0000-000000000000	81fc8416-5f72-4a69-97b5-6e982e16b1ce	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 04:21:24.02404+00	
00000000-0000-0000-0000-000000000000	bba2afba-f0c8-4666-b092-1ff323f669d0	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 04:21:28.539923+00	
00000000-0000-0000-0000-000000000000	93209c4d-3923-45b4-88e9-2d1836425d1e	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 04:21:41.509111+00	
00000000-0000-0000-0000-000000000000	f82a8b37-445b-446e-8f30-527730b507f7	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 04:22:28.429143+00	
00000000-0000-0000-0000-000000000000	2cae6f03-015a-48d8-8363-2708efafb2b6	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 04:27:45.813807+00	
00000000-0000-0000-0000-000000000000	e2f3c186-f65c-4a0e-a54a-d80be17ef55e	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 04:38:59.780635+00	
00000000-0000-0000-0000-000000000000	901bf1d4-4ce3-4fd6-8824-711187785440	{"action":"token_refreshed","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-23 05:31:07.926704+00	
00000000-0000-0000-0000-000000000000	1f1082e0-bb63-469f-be45-5673dad4c8b5	{"action":"token_revoked","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-23 05:31:07.9296+00	
00000000-0000-0000-0000-000000000000	d9e52dae-3d38-4c8c-93ee-e7416bf79739	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 05:33:32.480152+00	
00000000-0000-0000-0000-000000000000	284bd476-88ab-44e2-a2b5-58508874791e	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 05:34:40.77827+00	
00000000-0000-0000-0000-000000000000	1915df6e-89c5-4775-be35-d17e9165d9fe	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 05:35:44.678213+00	
00000000-0000-0000-0000-000000000000	d1660d0f-2c16-48a6-a557-acbbb7ec764e	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-23 05:35:56.410008+00	
00000000-0000-0000-0000-000000000000	506cebea-5d81-46f5-b13c-546f8748b93d	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 05:35:57.880299+00	
00000000-0000-0000-0000-000000000000	d7a0e14c-f9a4-44aa-a565-7ab2664fff7b	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 06:59:44.431362+00	
00000000-0000-0000-0000-000000000000	cadc7ec1-8aa8-471b-a3df-a9aa37f6ae37	{"action":"token_refreshed","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-23 07:03:26.687573+00	
00000000-0000-0000-0000-000000000000	b894d28c-1d08-4b23-b589-b51dab031787	{"action":"token_revoked","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-23 07:03:26.689037+00	
00000000-0000-0000-0000-000000000000	96999083-e760-42de-958c-c6c084d70414	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 07:03:37.009579+00	
00000000-0000-0000-0000-000000000000	a7d26052-0f48-4c4c-ab3a-9b2ec9abc246	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 07:06:14.628831+00	
00000000-0000-0000-0000-000000000000	96b2fdc1-2bd1-4801-ba26-988d55c1122d	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-23 07:06:23.415776+00	
00000000-0000-0000-0000-000000000000	900342d3-ee21-4255-8e85-646b58bede1b	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 07:06:28.372484+00	
00000000-0000-0000-0000-000000000000	dd80bf87-c901-4723-b641-77bef23b1eaf	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 07:40:41.781147+00	
00000000-0000-0000-0000-000000000000	ee44725e-e563-4f2a-b901-5d3a9660a7d5	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 07:48:25.7546+00	
00000000-0000-0000-0000-000000000000	14c29629-353f-485b-a84f-a6675bbb137b	{"action":"logout","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-23 07:52:00.641508+00	
00000000-0000-0000-0000-000000000000	fc23e93d-c429-4dbd-8ba4-fe5de2d6ccbf	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 07:55:15.495407+00	
00000000-0000-0000-0000-000000000000	9d380fe1-5e2d-45bf-910e-10e7e2d85c71	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-23 08:04:37.001917+00	
00000000-0000-0000-0000-000000000000	d10b6da7-d0b0-4cb8-ac15-8343f2842af7	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-23 08:04:37.003907+00	
00000000-0000-0000-0000-000000000000	875cbaa5-8b90-48e3-9c11-623e14f15ea8	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-23 11:01:11.121395+00	
00000000-0000-0000-0000-000000000000	2b1b3ee8-727f-445b-b444-ecfe6cd1ea1b	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-23 11:01:11.127539+00	
00000000-0000-0000-0000-000000000000	bed2c9e8-ae9c-4761-b3d3-60e6cbc1279e	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 11:01:11.688207+00	
00000000-0000-0000-0000-000000000000	b5623f8a-868e-491e-95fc-33ec87f739d6	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 11:21:43.693368+00	
00000000-0000-0000-0000-000000000000	531b81be-e1eb-4e44-ada5-2b928bbd6f42	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 11:22:14.886539+00	
00000000-0000-0000-0000-000000000000	ea391493-7e41-4a1b-88bb-81306bf8d738	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-23 12:00:56.99672+00	
00000000-0000-0000-0000-000000000000	6279c546-410f-4deb-95b8-707364135e5a	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 12:00:59.867096+00	
00000000-0000-0000-0000-000000000000	a50f339f-a8aa-4a05-86cd-8c1fda8f387d	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-23 12:10:18.497118+00	
00000000-0000-0000-0000-000000000000	3b2e2fa9-caf7-4a51-b88e-50cdfc74ff64	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 12:10:20.665072+00	
00000000-0000-0000-0000-000000000000	d1b13adb-a4a2-4c7a-9928-c10129ce28b4	{"action":"token_refreshed","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-23 13:08:44.283275+00	
00000000-0000-0000-0000-000000000000	fc01154f-441f-4d84-9feb-d9a49040f817	{"action":"token_revoked","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-23 13:08:44.288608+00	
00000000-0000-0000-0000-000000000000	ed896e6f-f560-4479-86e2-f1718ebde121	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 13:25:58.027632+00	
00000000-0000-0000-0000-000000000000	092c2532-e61b-478e-a8c7-aaf3c3bf8bac	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-23 13:26:18.276977+00	
00000000-0000-0000-0000-000000000000	937ed4ef-966e-4e9e-b457-0cf6cec7e5ca	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 13:26:22.573245+00	
00000000-0000-0000-0000-000000000000	c0560364-10de-4533-a800-b9c7875a0ae0	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-23 13:27:57.861262+00	
00000000-0000-0000-0000-000000000000	802fca63-d025-4fc8-9889-1275b71be4ee	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 04:24:54.434943+00	
00000000-0000-0000-0000-000000000000	bbf795ba-87d8-49fb-92b7-f9f4316b7225	{"action":"token_refreshed","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 04:46:06.086134+00	
00000000-0000-0000-0000-000000000000	49cf4e4c-26f1-499d-aed3-b65a3bcfc8ce	{"action":"token_revoked","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 04:46:06.088406+00	
00000000-0000-0000-0000-000000000000	45c2abff-7c18-4bb8-8918-f7fca026bec8	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 04:46:06.200314+00	
00000000-0000-0000-0000-000000000000	bf5b1bd9-3042-4989-93d2-1933f7ff074c	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 04:46:22.858172+00	
00000000-0000-0000-0000-000000000000	ab4455bc-6188-4d40-b2b9-9ced6a752aa6	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 04:46:28.17242+00	
00000000-0000-0000-0000-000000000000	98180b53-3217-409b-a3ac-edda296bb1e6	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 04:51:38.59892+00	
00000000-0000-0000-0000-000000000000	389af1e8-7670-4dbc-a7d6-cf2bf454972d	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 04:51:41.713929+00	
00000000-0000-0000-0000-000000000000	f7f0c62c-ab4a-4047-99b9-75a4facc1c41	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 04:56:08.772998+00	
00000000-0000-0000-0000-000000000000	5835a000-17b2-4533-bd1b-3a2509c02190	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 04:57:30.841357+00	
00000000-0000-0000-0000-000000000000	68294933-e196-4b7f-a6e3-5a12ab3a0395	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 04:57:34.124016+00	
00000000-0000-0000-0000-000000000000	2dabd076-eb0b-4c51-8122-d5cd0f900e36	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 06:59:29.10627+00	
00000000-0000-0000-0000-000000000000	06e72052-78ff-4fc1-82aa-c3ffb5ab8694	{"action":"logout","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 07:00:31.07819+00	
00000000-0000-0000-0000-000000000000	700ce34a-d676-4326-99af-ed85764f17d0	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 07:00:43.633953+00	
00000000-0000-0000-0000-000000000000	262dec03-ad7e-4ee9-8af4-3e7da82ca2b1	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 07:03:06.488527+00	
00000000-0000-0000-0000-000000000000	99b8de0d-6d93-4277-9fe0-582afd71613d	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 07:07:02.428179+00	
00000000-0000-0000-0000-000000000000	3bd7becb-d670-42fc-b22a-1ba0c5262585	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 07:07:06.156993+00	
00000000-0000-0000-0000-000000000000	2ff43b03-eaaf-46ad-962c-bb741851d7a4	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 08:05:28.20659+00	
00000000-0000-0000-0000-000000000000	1a0f17c1-63e3-4007-b122-bc93c13a1f02	{"action":"token_refreshed","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 08:17:35.03573+00	
00000000-0000-0000-0000-000000000000	837c937c-611f-4d00-8772-fefc0b0d2653	{"action":"token_revoked","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 08:17:35.039824+00	
00000000-0000-0000-0000-000000000000	8492c5f2-a79f-4338-a8a1-30756b7ff097	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 08:17:36.038435+00	
00000000-0000-0000-0000-000000000000	c7918fb1-ab7f-4305-9e88-0d892921e134	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 08:18:13.34501+00	
00000000-0000-0000-0000-000000000000	9b9d486e-c5b9-4a0a-9122-4ce8dad5125b	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 08:56:54.923581+00	
00000000-0000-0000-0000-000000000000	76af5299-ae1c-4b90-9237-c0fcd3242174	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 08:56:54.92653+00	
00000000-0000-0000-0000-000000000000	83ac078a-fc66-4b70-826c-e6d12c07a4c9	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 08:56:57.026128+00	
00000000-0000-0000-0000-000000000000	638b12c5-89c5-4a1e-84b8-7fe2d13d5b05	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 08:57:19.893483+00	
00000000-0000-0000-0000-000000000000	65de91d3-e778-4862-b34c-8251b545e7a3	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 08:57:22.671948+00	
00000000-0000-0000-0000-000000000000	71b5098c-33b4-4118-bd44-330eae798be4	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 09:04:07.337069+00	
00000000-0000-0000-0000-000000000000	92495b31-7778-4398-980e-5a28a866c495	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 09:04:10.185866+00	
00000000-0000-0000-0000-000000000000	eeda7769-cbbf-49d5-8a21-4443151358e7	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-28 01:36:17.729262+00	
00000000-0000-0000-0000-000000000000	fdb9d2b0-d738-428d-9c9f-9049d4a4d5c8	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 09:05:37.791864+00	
00000000-0000-0000-0000-000000000000	f8ddd411-1aa6-493a-b225-0cecb9a471b1	{"action":"token_refreshed","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 09:05:39.533995+00	
00000000-0000-0000-0000-000000000000	2d9fb779-94dc-4329-8152-4ca49a88b5ac	{"action":"token_revoked","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 09:05:39.534595+00	
00000000-0000-0000-0000-000000000000	bfc13c35-8801-4575-9b7e-b5c96a2c02c2	{"action":"logout","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 09:05:48.695526+00	
00000000-0000-0000-0000-000000000000	e9b65913-5abf-4869-a0db-9bce70348f50	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 09:09:51.238035+00	
00000000-0000-0000-0000-000000000000	7a2b5c99-9126-4994-b1cb-441b569408db	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 09:23:18.006883+00	
00000000-0000-0000-0000-000000000000	01dbfb26-d83f-4943-b933-d51be3c9b680	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 09:23:21.146099+00	
00000000-0000-0000-0000-000000000000	935d8a45-b283-44c9-96c7-ad3106a13333	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 09:23:48.225775+00	
00000000-0000-0000-0000-000000000000	942a079a-8a88-4521-b515-49ca463e591a	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 09:23:49.676142+00	
00000000-0000-0000-0000-000000000000	3721bebc-015f-48a4-96b2-04061425db09	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 09:28:14.701609+00	
00000000-0000-0000-0000-000000000000	03a26ab7-18ed-491a-8850-a10260954f75	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 09:34:56.750842+00	
00000000-0000-0000-0000-000000000000	f4e0bed7-ad88-417f-877e-2009a203f02f	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 09:35:00.24426+00	
00000000-0000-0000-0000-000000000000	6b822412-e6ca-4cc2-820d-fd56b917b372	{"action":"logout","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 10:03:44.36424+00	
00000000-0000-0000-0000-000000000000	248b91fd-ad99-4096-975a-ba6d801401fd	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 10:04:00.37557+00	
00000000-0000-0000-0000-000000000000	991f59bc-5272-4d02-9fd4-f5e2cb0f23c6	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 10:19:28.364459+00	
00000000-0000-0000-0000-000000000000	26b8f031-201a-4e11-94c0-b93bdc54e5f7	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 10:23:19.026838+00	
00000000-0000-0000-0000-000000000000	ef1da446-c3d3-403d-8b90-40b001ddcd4b	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 10:23:50.796072+00	
00000000-0000-0000-0000-000000000000	fbb4f3ca-376c-4ceb-872f-c3933b7599b4	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 10:23:57.737375+00	
00000000-0000-0000-0000-000000000000	00407e71-391c-4297-b745-74ded78f9b23	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 10:24:02.858849+00	
00000000-0000-0000-0000-000000000000	8f3d623a-40c2-4e24-9ce9-a94553fc27e0	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 10:26:37.333272+00	
00000000-0000-0000-0000-000000000000	011dcc73-741e-4b1c-b4f0-002a35065ec7	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 10:26:40.373565+00	
00000000-0000-0000-0000-000000000000	6d002cf8-3c94-4908-b9a0-0e0c4eba0b65	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 10:27:53.88566+00	
00000000-0000-0000-0000-000000000000	d5703026-f92c-4d81-a995-c86343a5f087	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 10:31:40.110928+00	
00000000-0000-0000-0000-000000000000	4b1d3b18-1f9d-44d5-97ca-32b1af631656	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 10:31:59.014823+00	
00000000-0000-0000-0000-000000000000	79d0b5a0-1949-4265-aa90-e6281d6e670a	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 10:32:01.323096+00	
00000000-0000-0000-0000-000000000000	ae035f5b-78f1-441a-bea2-8b85e4be0603	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 10:34:16.674804+00	
00000000-0000-0000-0000-000000000000	45226e69-4cf1-4ee1-9c96-4d4efa4d063f	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 10:34:25.082241+00	
00000000-0000-0000-0000-000000000000	69f98d09-717e-4961-989d-31f2865b524b	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 10:34:28.015428+00	
00000000-0000-0000-0000-000000000000	c07e9ffa-9ee7-40d9-a038-db09df97621e	{"action":"token_refreshed","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 11:09:02.55992+00	
00000000-0000-0000-0000-000000000000	5530f4c5-52c3-42c9-b4a5-9a5a437e3e1d	{"action":"token_revoked","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 11:09:02.56532+00	
00000000-0000-0000-0000-000000000000	900e1690-6f4e-46ee-a1c3-a02e01a66fc7	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 12:32:32.608263+00	
00000000-0000-0000-0000-000000000000	16a4e51e-3089-4629-be10-2af048617cd1	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 12:32:32.61172+00	
00000000-0000-0000-0000-000000000000	d147be1d-e6a3-4365-af33-dde4b5c44ae9	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 12:32:33.759472+00	
00000000-0000-0000-0000-000000000000	f3d7dfa5-fbbe-4779-ac5e-41d9f9034ba0	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-24 12:32:41.497129+00	
00000000-0000-0000-0000-000000000000	961b3dbe-8f99-4d67-a29a-ad2d364eadfa	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 12:32:43.989016+00	
00000000-0000-0000-0000-000000000000	6397e00d-c0bf-48d9-9ca9-c3faa8163691	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 13:03:55.612207+00	
00000000-0000-0000-0000-000000000000	881e177e-356a-4c0e-98be-298a143bc1e0	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 14:01:29.859552+00	
00000000-0000-0000-0000-000000000000	7d099f92-c2a1-416a-b258-8190fca2bf3b	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 15:01:27.51258+00	
00000000-0000-0000-0000-000000000000	a97b8057-968c-40cd-bbee-781b3e1387d0	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 15:01:27.518843+00	
00000000-0000-0000-0000-000000000000	3ab19b89-cdd8-47d7-b36d-b8162d535c89	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 15:01:28.19189+00	
00000000-0000-0000-0000-000000000000	0c86e844-24a1-48cf-b6e5-5c7aa18a9f84	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 15:04:59.744366+00	
00000000-0000-0000-0000-000000000000	103ba822-5250-469d-97ff-b4de1ed91680	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-24 15:04:59.745164+00	
00000000-0000-0000-0000-000000000000	9f4331f6-ecbf-454c-8aa6-27f71a16ba92	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-24 15:05:00.466743+00	
00000000-0000-0000-0000-000000000000	7f2661cf-fcfc-412a-ba2b-7b3d35fef798	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-25 10:53:04.457884+00	
00000000-0000-0000-0000-000000000000	916310f6-09af-49de-8c9e-c7df097484e5	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-25 10:53:04.472134+00	
00000000-0000-0000-0000-000000000000	868b8ee3-1cb5-4736-8666-9b3308e52dde	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-25 10:53:34.925726+00	
00000000-0000-0000-0000-000000000000	7d2a8732-f685-4cc7-9dcd-daddb75fe222	{"action":"token_refreshed","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 08:11:10.372353+00	
00000000-0000-0000-0000-000000000000	98f836be-d107-408e-9207-d258f987d11e	{"action":"token_revoked","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 08:11:10.388785+00	
00000000-0000-0000-0000-000000000000	789be00d-51c4-415d-bfc4-488b656bf3ec	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 08:11:12.489623+00	
00000000-0000-0000-0000-000000000000	afaa0efa-495a-4865-805b-cc1acaf7eeda	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 08:18:36.040534+00	
00000000-0000-0000-0000-000000000000	26f0aa4a-0781-4068-8c39-3f7a0b5bcc35	{"action":"token_refreshed","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 09:18:33.725037+00	
00000000-0000-0000-0000-000000000000	e647b0c3-339f-4678-b5ec-8e3115d0a59f	{"action":"token_revoked","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-26 09:18:33.728787+00	
00000000-0000-0000-0000-000000000000	4e8e538f-5767-4a74-bc27-41ae80d9b4d5	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-26 10:08:05.831319+00	
00000000-0000-0000-0000-000000000000	7bf82ccf-9683-4f03-92f7-ea513021ba58	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 00:42:12.711234+00	
00000000-0000-0000-0000-000000000000	187d2c23-4b96-4613-9894-c38f030aba64	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 01:00:52.137303+00	
00000000-0000-0000-0000-000000000000	29b81c7b-9825-4254-bfa0-9034e0d6b3d1	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 01:13:37.629731+00	
00000000-0000-0000-0000-000000000000	a547505d-7b19-4676-9df5-a704955214d1	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 01:24:22.422844+00	
00000000-0000-0000-0000-000000000000	52e0ee81-b679-48cb-81b2-d6fd2c459674	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-27 01:24:22.428716+00	
00000000-0000-0000-0000-000000000000	e55b0daa-be8a-459d-a86c-c6e6886a07a5	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 01:24:22.810132+00	
00000000-0000-0000-0000-000000000000	a0a3268e-d344-4471-bf56-1c2d2fb17e57	{"action":"login","actor_id":"620de24c-a40a-432a-be36-86852092f3c1","actor_username":"3122569172@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 02:10:32.61643+00	
00000000-0000-0000-0000-000000000000	87fa87e1-c108-4d71-ade0-fab4d28e3cbc	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-27 02:16:43.446366+00	
00000000-0000-0000-0000-000000000000	da35a3a0-64a8-400a-b87b-e433e1f45ad9	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 01:31:14.862599+00	
00000000-0000-0000-0000-000000000000	eb90f3a3-e0ce-4723-9cb7-1eeee6cd27a0	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-28 01:31:14.888181+00	
00000000-0000-0000-0000-000000000000	26e245f5-c7ab-4795-a7f6-2c688d341efd	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-28 01:31:14.910238+00	
00000000-0000-0000-0000-000000000000	4fa69ccc-c51f-4345-a541-cb5e382522f6	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-28 01:36:20.079772+00	
00000000-0000-0000-0000-000000000000	21804b24-237f-4864-96f4-dba9c958723e	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-28 02:26:00.003161+00	
00000000-0000-0000-0000-000000000000	8633dfaa-8b94-48f5-9391-460f16ead600	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-28 03:15:47.159396+00	
00000000-0000-0000-0000-000000000000	51ab82bf-f43a-4b8b-a1c4-2067170ba7ce	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-28 03:19:29.329767+00	
00000000-0000-0000-0000-000000000000	10bbb551-a749-4958-b95e-2298e60d7c99	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-28 03:22:02.037987+00	
00000000-0000-0000-0000-000000000000	c1542013-1ba6-49a1-b131-fca18de2e39d	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-28 03:26:57.530266+00	
00000000-0000-0000-0000-000000000000	75ab5309-9ffc-4bb9-927a-7cd3bf6bce6c	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-28 03:33:43.531055+00	
00000000-0000-0000-0000-000000000000	82badc1b-484a-438f-ae45-70b4d504a781	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-02-28 03:36:35.817711+00	
00000000-0000-0000-0000-000000000000	86d10f77-652d-4e35-97b3-b1c15ecf1a9f	{"action":"token_refreshed","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-01 10:37:40.106542+00	
00000000-0000-0000-0000-000000000000	fc2acd83-6d4e-4885-8868-94c5f05ed4f3	{"action":"token_revoked","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-01 10:37:40.120794+00	
00000000-0000-0000-0000-000000000000	a4f30db5-08d3-4449-b1db-a61965ac6fd1	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-01 10:37:40.995271+00	
00000000-0000-0000-0000-000000000000	046e2612-e9ff-48cb-823e-454595706536	{"action":"token_refreshed","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-01 11:36:22.936884+00	
00000000-0000-0000-0000-000000000000	8ec41d59-ad73-4b8a-a2f5-3316ed66f2ae	{"action":"token_revoked","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-01 11:36:22.941786+00	
00000000-0000-0000-0000-000000000000	914345fa-48db-4c08-ac0f-f526fe0d18d1	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-01 13:08:51.191758+00	
00000000-0000-0000-0000-000000000000	13ed7a79-9fec-4b50-8477-fb1ac48509db	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-01 13:20:02.254778+00	
00000000-0000-0000-0000-000000000000	50b58802-1b5d-47c4-85fe-3d95d0a80f3c	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-01 14:18:33.853603+00	
00000000-0000-0000-0000-000000000000	2afc1a86-14e9-4eaa-b22f-38eeb7af17dd	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-01 14:18:33.85742+00	
00000000-0000-0000-0000-000000000000	5210cf22-caaf-4b8f-aaf4-2ad64a3b2fbd	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-01 16:06:16.513734+00	
00000000-0000-0000-0000-000000000000	97b97a22-3fba-4699-ad38-e64b28b9af6b	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-01 16:06:16.517718+00	
00000000-0000-0000-0000-000000000000	03e0fc20-fa64-4e10-b05d-9ecc51167932	{"action":"token_refreshed","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-02 01:34:47.084516+00	
00000000-0000-0000-0000-000000000000	92ed4a09-ef65-433e-b9bb-46f4c1cc6e1d	{"action":"token_revoked","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-02 01:34:47.095746+00	
00000000-0000-0000-0000-000000000000	237c8d9b-096d-4a6b-b2af-3b9dd7e7d34d	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-02 01:34:48.142753+00	
00000000-0000-0000-0000-000000000000	db0fcc66-c022-42bf-889b-12c6f53c3321	{"action":"token_refreshed","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-02 02:33:04.992832+00	
00000000-0000-0000-0000-000000000000	98343808-e3fa-4db1-bb7d-3ddd93587dd2	{"action":"token_revoked","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-02 02:33:05.001853+00	
00000000-0000-0000-0000-000000000000	98ed9323-ca35-42d4-add0-13042e2e83bc	{"action":"token_refreshed","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-02 03:32:08.10302+00	
00000000-0000-0000-0000-000000000000	d7ce0941-e5d4-433e-97d6-7629d9061997	{"action":"token_revoked","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-02 03:32:08.106894+00	
00000000-0000-0000-0000-000000000000	acb3b9f4-0cdc-40c1-9ad7-8c83e2f28301	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-02 03:42:14.130773+00	
00000000-0000-0000-0000-000000000000	67cbb0fb-783d-4e94-a7f9-f3d35128b943	{"action":"token_refreshed","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-09 03:14:30.432427+00	
00000000-0000-0000-0000-000000000000	53b9ddb6-9358-49af-a89f-7807251c065b	{"action":"token_revoked","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-09 03:14:30.437965+00	
00000000-0000-0000-0000-000000000000	e60fb6d7-656e-4951-884f-7765d2ee136d	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-09 03:14:30.499359+00	
00000000-0000-0000-0000-000000000000	f1a66915-de65-4e58-b0a6-a34efeccbdcc	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-11 12:14:02.534177+00	
00000000-0000-0000-0000-000000000000	f7adc1be-f42a-400f-aabd-dbd22ed3c7b3	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-11 12:14:02.555641+00	
00000000-0000-0000-0000-000000000000	84265902-967d-435b-8897-215b6e3bb53b	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-11 12:14:09.369403+00	
00000000-0000-0000-0000-000000000000	41955bb7-b900-40c4-877f-59dd10f49a93	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-11 12:47:38.775625+00	
00000000-0000-0000-0000-000000000000	47f0d354-e214-46b3-b40c-b8bac02eab26	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-11 12:47:41.325143+00	
00000000-0000-0000-0000-000000000000	e97df9e7-24fd-454f-aa81-50383497d531	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-12 11:37:25.498513+00	
00000000-0000-0000-0000-000000000000	0dcf03d1-a588-4c04-b3c5-3c0ff4f8d529	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-12 12:35:52.4824+00	
00000000-0000-0000-0000-000000000000	dfed5ca9-92f7-4904-9b1b-9efd26ec298d	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-12 12:38:39.524762+00	
00000000-0000-0000-0000-000000000000	bb5f2e37-8b37-42fb-b287-a07a92faeff5	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-12 12:38:39.526989+00	
00000000-0000-0000-0000-000000000000	90c675ee-1fdb-4a14-b750-9d3c20be6fff	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-12 13:57:12.856248+00	
00000000-0000-0000-0000-000000000000	1422b889-1439-41c3-975d-33d58fc2cd9d	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-12 13:57:12.858859+00	
00000000-0000-0000-0000-000000000000	d014a44a-e4f5-434c-9c48-a23a16361985	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-12 16:55:52.166264+00	
00000000-0000-0000-0000-000000000000	3616570e-4b8d-4d85-aea4-b28c63f7aa66	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-12 16:55:52.170067+00	
00000000-0000-0000-0000-000000000000	52f6310a-9e42-4f98-a62e-c5e79bd6af4f	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-12 16:55:52.6469+00	
00000000-0000-0000-0000-000000000000	3b5d40bc-d8d3-4d3a-8429-76fae141f649	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-12 16:55:57.285837+00	
00000000-0000-0000-0000-000000000000	e4163df2-d246-47c2-b6cc-4187c6708e9e	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-12 16:55:57.286462+00	
00000000-0000-0000-0000-000000000000	a58c3e6a-f24e-4539-beed-1fac6bf03c2e	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-13 00:12:53.674737+00	
00000000-0000-0000-0000-000000000000	2f40cebf-f85d-4a18-ad56-8c4b3e8844e3	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-13 00:12:53.70171+00	
00000000-0000-0000-0000-000000000000	553d42f1-0b6b-47c4-a1be-a03bb90ebd3d	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 00:12:56.393554+00	
00000000-0000-0000-0000-000000000000	e4c827de-4355-4f1c-9b35-a57439022a0c	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-13 00:19:02.342539+00	
00000000-0000-0000-0000-000000000000	a32ac817-3a5d-49c5-aeb3-12b587a92a0c	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-13 00:19:02.345029+00	
00000000-0000-0000-0000-000000000000	c37b7596-7744-4cc9-82a2-1279001223b6	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 00:19:02.984068+00	
00000000-0000-0000-0000-000000000000	fa443d45-e055-40c5-a374-c1321d414417	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 00:22:12.306731+00	
00000000-0000-0000-0000-000000000000	5d97511d-bb01-41ba-a4ee-7c5bdfe743ce	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 00:33:02.542367+00	
00000000-0000-0000-0000-000000000000	3c029098-89ff-47a5-8632-b4404c593ee3	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 01:21:47.97597+00	
00000000-0000-0000-0000-000000000000	b683af2d-5871-4bd2-b4f5-ab4a2ed549c3	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 01:21:51.21794+00	
00000000-0000-0000-0000-000000000000	561cdf2c-dd6b-4030-a506-80bd491f97a0	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 01:26:25.747712+00	
00000000-0000-0000-0000-000000000000	92e75a1e-5990-4cda-9b37-141272e29d34	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 01:26:28.010799+00	
00000000-0000-0000-0000-000000000000	8e4dc9f5-7968-418b-a885-09c890f5f45a	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 02:14:43.690993+00	
00000000-0000-0000-0000-000000000000	c37295e8-d728-4427-a994-06e60c73e964	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 02:20:05.965893+00	
00000000-0000-0000-0000-000000000000	74f6acee-213e-4599-94db-58f596d556f7	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 02:20:29.931733+00	
00000000-0000-0000-0000-000000000000	2033edba-bd27-47f4-8d39-d159ae3b9341	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 02:31:35.727087+00	
00000000-0000-0000-0000-000000000000	d5af6fc4-23b4-468b-83d6-6f79a128a124	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 02:38:14.657389+00	
00000000-0000-0000-0000-000000000000	a27854f9-c0a9-4da2-9df1-da630d32dfc2	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 02:38:27.566199+00	
00000000-0000-0000-0000-000000000000	efc50e5e-2281-41a3-9f3d-7822934a240b	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 02:39:29.707427+00	
00000000-0000-0000-0000-000000000000	c4e233c3-9945-4572-8ee2-58cbc17dd11c	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 02:47:12.888921+00	
00000000-0000-0000-0000-000000000000	90bf7023-71ff-42c3-a3d3-0c786d865d5e	{"action":"token_refreshed","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-13 04:45:17.091275+00	
00000000-0000-0000-0000-000000000000	74412d55-74e1-412b-bf4f-d90f30da8e15	{"action":"token_revoked","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-13 04:45:17.094209+00	
00000000-0000-0000-0000-000000000000	2712199a-69de-4605-a5d1-49ac2d712889	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 04:45:18.257826+00	
00000000-0000-0000-0000-000000000000	9aef7d8c-75fb-444a-a731-512129e1e4a5	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-13 04:46:45.686636+00	
00000000-0000-0000-0000-000000000000	835a6e9f-061a-4180-b5ab-02ff6a24257a	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-13 04:46:45.687294+00	
00000000-0000-0000-0000-000000000000	20812e7d-4202-42cb-8148-a6b68ac94a0b	{"action":"token_refreshed","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-13 05:44:47.79861+00	
00000000-0000-0000-0000-000000000000	e48da241-5ddb-4fab-877e-1349fd2b8cff	{"action":"token_revoked","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-13 05:44:47.801488+00	
00000000-0000-0000-0000-000000000000	8fc205eb-298b-4bd7-b862-08af32cf2093	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-13 06:02:34.803795+00	
00000000-0000-0000-0000-000000000000	06f07574-40ad-48bf-aa56-61c6e1b7d762	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-13 06:02:34.805626+00	
00000000-0000-0000-0000-000000000000	2b1d8f45-b2f8-4e7a-8fc4-ac890a0821f0	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 06:20:37.624196+00	
00000000-0000-0000-0000-000000000000	a463257e-508d-4455-a2fa-ac07c1c81e62	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 06:21:47.77109+00	
00000000-0000-0000-0000-000000000000	fe2601b5-d990-47b7-a26f-195585a41891	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 06:21:52.35871+00	
00000000-0000-0000-0000-000000000000	71bdd3fc-b9af-4619-9038-f119a4455799	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 06:29:05.980738+00	
00000000-0000-0000-0000-000000000000	ce9785c6-0b44-4bcc-aa1a-56075e287b73	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 06:47:18.501351+00	
00000000-0000-0000-0000-000000000000	2ae7a3cf-2549-4c79-83d2-823e24e5b448	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 06:47:24.400549+00	
00000000-0000-0000-0000-000000000000	ff53d23a-3e15-4d5b-bda0-137daa05a5f4	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 06:53:32.045447+00	
00000000-0000-0000-0000-000000000000	1f243fc3-27e9-43f7-9337-244888e7165e	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 06:54:37.133535+00	
00000000-0000-0000-0000-000000000000	739deb6b-7fb1-4dcf-bda1-f1f7bb2e2815	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 06:54:40.319237+00	
00000000-0000-0000-0000-000000000000	242575af-790b-4174-b01b-97abca195da4	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 07:13:23.803281+00	
00000000-0000-0000-0000-000000000000	0baa715f-1b26-4585-a209-1c61ea863c91	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 08:00:43.461806+00	
00000000-0000-0000-0000-000000000000	88e2a52c-e9dc-4155-89a2-ce11742a29bf	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 08:00:47.759694+00	
00000000-0000-0000-0000-000000000000	20586615-15c4-41ae-bf2a-b43cfd18ea40	{"action":"token_refreshed","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-13 08:03:50.658731+00	
00000000-0000-0000-0000-000000000000	a6e97cdf-2635-4759-b69f-bc5c1182ba3f	{"action":"token_revoked","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-13 08:03:50.661062+00	
00000000-0000-0000-0000-000000000000	c122f867-e8e9-402c-a9f6-8f52ac2b1e01	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 08:29:59.483875+00	
00000000-0000-0000-0000-000000000000	ed2db511-5b8c-445e-9f1f-619d6ab3d370	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 08:30:02.109716+00	
00000000-0000-0000-0000-000000000000	1c28c1bd-bf19-407c-b81b-ea47849dd881	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 08:30:41.552157+00	
00000000-0000-0000-0000-000000000000	9920de90-7b85-4915-92e3-d2cbfbafb350	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 08:42:38.32138+00	
00000000-0000-0000-0000-000000000000	91e992a2-2ee2-48f6-a9a5-c20f913900ac	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 08:42:41.471585+00	
00000000-0000-0000-0000-000000000000	822e41e8-8ade-4b2a-9526-4de63570d37d	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 08:51:46.011589+00	
00000000-0000-0000-0000-000000000000	81dc9e41-2cc6-4281-bbe9-48993152260a	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 08:55:51.0371+00	
00000000-0000-0000-0000-000000000000	48263f5f-8974-466d-a353-9a170e4085e5	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 08:55:54.667131+00	
00000000-0000-0000-0000-000000000000	5e6d3643-88d3-4949-bfc1-b0b5e59367f9	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 08:56:23.538509+00	
00000000-0000-0000-0000-000000000000	ab748899-af46-4993-8092-25e9e45af0c7	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 08:56:26.590137+00	
00000000-0000-0000-0000-000000000000	9f3a7341-8f6d-43ae-bb87-c9eabecc1586	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 08:57:58.613725+00	
00000000-0000-0000-0000-000000000000	6d29f134-22ea-4b2d-9480-8341738cd540	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 08:58:01.372458+00	
00000000-0000-0000-0000-000000000000	7310addf-08e6-474d-b838-27ace06d6b01	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 08:58:25.773586+00	
00000000-0000-0000-0000-000000000000	e52ae15e-8e5d-4097-a243-a21839588e6a	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 08:58:28.175535+00	
00000000-0000-0000-0000-000000000000	dc604fbd-f064-4032-97cb-052291a96826	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 09:00:07.0154+00	
00000000-0000-0000-0000-000000000000	fb4f7ab0-19de-4a80-980a-8911f13f9b54	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 09:00:09.076742+00	
00000000-0000-0000-0000-000000000000	f041614e-d703-4683-9668-47cfb08ed16e	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 09:00:49.296395+00	
00000000-0000-0000-0000-000000000000	de887bea-cf1d-46d4-aef8-8b517549e3d9	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 09:00:52.335144+00	
00000000-0000-0000-0000-000000000000	5ca30cda-93ca-4022-821e-07fa56ab1554	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 09:01:20.475099+00	
00000000-0000-0000-0000-000000000000	9a9cfa86-2140-475d-a211-a62aebb5b955	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 09:01:23.539461+00	
00000000-0000-0000-0000-000000000000	a54aba67-545d-406b-b983-07df586aad6f	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 09:09:36.45431+00	
00000000-0000-0000-0000-000000000000	3a23e1fc-8585-4f47-abc6-c3d644a668b7	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 09:10:55.351245+00	
00000000-0000-0000-0000-000000000000	2053672a-b6b1-45a6-9cfa-0ba25dfc576d	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 09:10:58.895533+00	
00000000-0000-0000-0000-000000000000	50684c30-975a-47be-92dd-40227a0201fa	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 09:15:18.423484+00	
00000000-0000-0000-0000-000000000000	cbd8f24b-344b-4b74-bce1-b7b3c3a27f41	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 09:15:21.487319+00	
00000000-0000-0000-0000-000000000000	de59681d-3173-4e50-9218-e768a69a1973	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 09:15:59.965584+00	
00000000-0000-0000-0000-000000000000	6b08931e-db09-4b2b-9488-9e96fff0e375	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-13 09:22:33.854587+00	
00000000-0000-0000-0000-000000000000	7d006dc9-9cf0-4b20-a76e-4bfa7bb0043a	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-13 09:22:36.521777+00	
00000000-0000-0000-0000-000000000000	8ed4826b-8b9f-43f1-b1ba-6c27bddd383f	{"action":"token_refreshed","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-14 09:46:17.408932+00	
00000000-0000-0000-0000-000000000000	9496bc95-e3bd-4a9b-b5a6-ab46c3b1e601	{"action":"token_revoked","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-14 09:46:17.42503+00	
00000000-0000-0000-0000-000000000000	1bb3bb75-a0c3-4461-8d69-4c982184b8cc	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-14 09:47:10.293767+00	
00000000-0000-0000-0000-000000000000	4218eff3-2175-4794-bea1-ac869e6fc982	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-14 09:54:52.642575+00	
00000000-0000-0000-0000-000000000000	44b97dd4-00de-4b30-8d32-b0ac0af54a9e	{"action":"user_updated_password","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-03-14 09:55:53.781373+00	
00000000-0000-0000-0000-000000000000	d3df5e8f-45dd-464d-9468-9276bc52bbce	{"action":"user_modified","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-03-14 09:55:53.783883+00	
00000000-0000-0000-0000-000000000000	d2453642-7db8-4664-ab52-9a8ab9764096	{"action":"logout","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-14 10:04:57.820283+00	
00000000-0000-0000-0000-000000000000	7b944e69-55cf-4507-b34a-e46f68787300	{"action":"login","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-14 10:04:59.710612+00	
00000000-0000-0000-0000-000000000000	fd18868a-44c1-45fb-956a-c9c1ee81a00d	{"action":"user_updated_password","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-03-14 10:14:19.205844+00	
00000000-0000-0000-0000-000000000000	4d4ebe0d-d5a5-4db2-aded-6e3764f4d179	{"action":"user_modified","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-03-14 10:14:19.209485+00	
00000000-0000-0000-0000-000000000000	9f801143-d441-41a4-b369-2626c076d3c7	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-15 08:52:09.17173+00	
00000000-0000-0000-0000-000000000000	1def59a9-d983-4915-a6f4-4a86c75319f5	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-15 08:56:54.105576+00	
00000000-0000-0000-0000-000000000000	3318e1ea-d2fe-403b-b922-a339bd3ef7f7	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-15 09:06:19.111537+00	
00000000-0000-0000-0000-000000000000	fefab8e7-0d8c-47eb-aa9b-52bbbcd2c156	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-15 10:03:59.953429+00	
00000000-0000-0000-0000-000000000000	582f5ac5-a7fd-46b4-bcec-890ce41e3baa	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-15 10:10:24.637711+00	
00000000-0000-0000-0000-000000000000	8d12c60f-5ed5-425c-aa88-b1411d4d507a	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-15 10:10:37.123589+00	
00000000-0000-0000-0000-000000000000	8d5ec753-d619-4904-a62d-c626c0bea1e5	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-15 10:10:40.304856+00	
00000000-0000-0000-0000-000000000000	63191715-ba7b-45a2-b431-d4d05353e437	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-15 10:24:50.044784+00	
00000000-0000-0000-0000-000000000000	6326bfa2-a5aa-4bb8-bf00-dbb0e8b50574	{"action":"token_refreshed","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-15 14:14:13.222067+00	
00000000-0000-0000-0000-000000000000	62a5f1fd-1461-4a8e-be7f-67fa6d317ed3	{"action":"token_revoked","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-15 14:14:13.226412+00	
00000000-0000-0000-0000-000000000000	f9009cfc-2a3e-47ed-a998-d2d104ae1180	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-15 17:25:57.830669+00	
00000000-0000-0000-0000-000000000000	caa23584-ab3e-463f-a96b-782a4a372454	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-15 17:25:57.832245+00	
00000000-0000-0000-0000-000000000000	041d63f9-dd6f-4f37-b707-d45cb88cdbfb	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-15 17:25:58.752575+00	
00000000-0000-0000-0000-000000000000	ff4bb80f-e351-4ac1-ae8e-3e58c0dedbf3	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-15 17:28:09.764235+00	
00000000-0000-0000-0000-000000000000	e432d407-1a57-409a-b513-ef620981b1dd	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-21 04:10:09.271784+00	
00000000-0000-0000-0000-000000000000	c6f76c96-b377-40ff-9651-3764ec98d2f8	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-21 04:10:24.079479+00	
00000000-0000-0000-0000-000000000000	732a17b1-4687-4306-95a9-ec348ddc0de7	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-21 04:10:30.54845+00	
00000000-0000-0000-0000-000000000000	9d2cdece-a631-4909-846c-e049826a860e	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-21 04:11:09.67306+00	
00000000-0000-0000-0000-000000000000	522157fa-d4f7-4112-879a-48600a374a46	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-21 04:11:18.456609+00	
00000000-0000-0000-0000-000000000000	c6bf60a9-e24a-47d9-9519-f8147abd3446	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-21 04:13:38.80388+00	
00000000-0000-0000-0000-000000000000	2176af0c-fb64-41ee-956f-f9abbbd00f1c	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-21 04:14:25.176287+00	
00000000-0000-0000-0000-000000000000	f4b886f1-74e4-49bf-bab7-08ca2b2950fe	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-21 04:14:28.793584+00	
00000000-0000-0000-0000-000000000000	10d6e9f6-ffb1-44c3-88db-caa0f295bdb9	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-21 04:16:16.845396+00	
00000000-0000-0000-0000-000000000000	c54d6b4f-59e9-472c-94c4-cdec391a833a	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-21 04:16:27.265207+00	
00000000-0000-0000-0000-000000000000	32f94bbc-c1e9-48cc-91fd-9e918273638b	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-22 00:43:46.526092+00	
00000000-0000-0000-0000-000000000000	0d761de1-2067-4d7e-91b8-6f9fc69b728f	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-22 00:43:46.556037+00	
00000000-0000-0000-0000-000000000000	08dd1478-9c41-498f-82c3-7ebc03b96756	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-22 00:44:32.181454+00	
00000000-0000-0000-0000-000000000000	095c9e7c-0fd2-4b88-bd4f-e18e41ec2990	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-22 00:49:06.596945+00	
00000000-0000-0000-0000-000000000000	6ab9444e-e171-44c9-ab35-c8dd734fdcbe	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-22 00:49:20.437647+00	
00000000-0000-0000-0000-000000000000	6bb477fa-f846-469c-b097-3f612583d932	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-22 00:49:30.688419+00	
00000000-0000-0000-0000-000000000000	b000c16d-a5bf-4485-acf9-e4980ad923e5	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-22 00:53:00.487225+00	
00000000-0000-0000-0000-000000000000	d63df996-1a5f-4628-a91d-4780724e6a30	{"action":"token_refreshed","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-23 08:23:48.200707+00	
00000000-0000-0000-0000-000000000000	0276e6bf-2ea1-4a54-b68e-4e8b2ff1db4e	{"action":"token_revoked","actor_id":"557d4ebc-ccbf-4402-ae59-4dd4b357e97c","actor_username":"3122410471@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-23 08:23:48.22819+00	
00000000-0000-0000-0000-000000000000	fafd4fc9-a273-4695-a6e1-c57fefe9080d	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-23 08:26:36.471941+00	
00000000-0000-0000-0000-000000000000	d70f96f5-7a93-414f-b856-853c4c21eca7	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-25 02:55:55.973176+00	
00000000-0000-0000-0000-000000000000	27cfd6a6-9e1d-4610-857c-f790cb95e13c	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-25 02:56:20.853351+00	
00000000-0000-0000-0000-000000000000	ab6b63c0-d1c7-40f7-8e3a-7d2e1bc33507	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-25 02:56:23.319673+00	
00000000-0000-0000-0000-000000000000	7a48392a-6342-4bfc-8fd8-4601d05a393e	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-27 00:35:17.203403+00	
00000000-0000-0000-0000-000000000000	3e46e08b-c5cf-4657-93fa-1348561a58ad	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-27 00:35:17.230853+00	
00000000-0000-0000-0000-000000000000	234c04c7-421d-4c77-b06b-42510728cb48	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-27 00:36:09.33806+00	
00000000-0000-0000-0000-000000000000	721d8c50-7e50-4e05-af68-9e7be9de8211	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-27 00:46:18.510938+00	
00000000-0000-0000-0000-000000000000	76a1fbb4-754c-4c3c-a134-b4a3b4666de9	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-03 03:51:18.496441+00	
00000000-0000-0000-0000-000000000000	7a3138f3-9b5f-4ba1-85e6-60953497527f	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 04:23:15.646635+00	
00000000-0000-0000-0000-000000000000	9d575ef3-9902-4b66-9b2f-b199a528e4c5	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 04:23:21.282369+00	
00000000-0000-0000-0000-000000000000	8941d816-2431-49fd-a9a0-163a59614a0a	{"action":"token_refreshed","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 04:28:56.054315+00	
00000000-0000-0000-0000-000000000000	ab69a743-d2f1-4a20-8353-088a0e1b7767	{"action":"token_revoked","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 04:28:56.056433+00	
00000000-0000-0000-0000-000000000000	8ca9f7c6-74f8-4c7b-a086-1c76ef761248	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 04:28:57.317123+00	
00000000-0000-0000-0000-000000000000	aa40086d-4497-411f-b791-89382bafbf95	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 04:29:01.191946+00	
00000000-0000-0000-0000-000000000000	8b926fdf-1f94-4738-9fa8-5e9fcf317c73	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 04:29:03.997393+00	
00000000-0000-0000-0000-000000000000	1207e970-4991-4285-bbae-0d1385c4c6bf	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 05:21:54.262738+00	
00000000-0000-0000-0000-000000000000	f8b800a6-f789-4093-9eb0-dfa5a42fe4bb	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 05:21:54.267636+00	
00000000-0000-0000-0000-000000000000	bfd98773-4b99-4595-8c3c-25c5916bd6e0	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 05:22:56.469433+00	
00000000-0000-0000-0000-000000000000	07195e68-e022-403e-b000-525545ed0239	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 05:29:42.163238+00	
00000000-0000-0000-0000-000000000000	560c787a-7e44-47ac-8b33-a8631a77b36a	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 05:32:06.283576+00	
00000000-0000-0000-0000-000000000000	20d12b7c-7f5e-4dc5-a343-3159fecf7e6f	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 06:01:00.980025+00	
00000000-0000-0000-0000-000000000000	de288c92-e8b5-4c57-9e1f-13b12fcd9264	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 06:01:41.486272+00	
00000000-0000-0000-0000-000000000000	5c3a7d99-de3c-4be4-aecd-bb9f25f4b07b	{"action":"user_updated_password","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-04-28 06:02:04.298431+00	
00000000-0000-0000-0000-000000000000	d1b93069-ac81-44eb-91cc-ac4b18da4c75	{"action":"user_modified","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-04-28 06:02:04.30055+00	
00000000-0000-0000-0000-000000000000	d23e9680-d7e8-45ba-8ad4-c536d66fbd21	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 06:02:08.691792+00	
00000000-0000-0000-0000-000000000000	171044ad-8ffe-4452-80ff-62a48f6a808d	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 06:02:10.473062+00	
00000000-0000-0000-0000-000000000000	3178c61a-7ca6-48dd-b5bc-3f9fd7863c57	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 06:02:17.647428+00	
00000000-0000-0000-0000-000000000000	7c8d45b9-7467-44b6-baef-ee27431a3228	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 06:03:48.521705+00	
00000000-0000-0000-0000-000000000000	fa45eaf5-6da0-440f-b79f-08a2f6391ce6	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 06:04:49.793568+00	
00000000-0000-0000-0000-000000000000	1422ee31-633b-4050-ad10-b09e13b446e5	{"action":"user_modified","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"user","traits":{"user_email":"3122560072@gmail.com","user_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","user_phone":""}}	2025-04-28 06:22:32.56255+00	
00000000-0000-0000-0000-000000000000	38293aa8-5cb8-453a-8ce8-a88bf62bd0f3	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 06:22:59.444952+00	
00000000-0000-0000-0000-000000000000	7b017065-d109-4c76-a7c2-aa524b4828c3	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 06:23:08.33776+00	
00000000-0000-0000-0000-000000000000	de9c11ce-5e4b-401e-a9d3-9ea67926ed51	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 06:27:54.883674+00	
00000000-0000-0000-0000-000000000000	7f4afc6b-b106-440b-ad99-81a5a831f24b	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 06:28:02.781253+00	
00000000-0000-0000-0000-000000000000	383507d8-a08c-4ecb-9caa-7cb907520d8b	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-07 04:55:47.361828+00	
00000000-0000-0000-0000-000000000000	7f5b07f2-b9fa-4ac8-8d0f-5d695965cf37	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-07 04:56:20.233002+00	
00000000-0000-0000-0000-000000000000	5144ec2e-7968-46ef-8208-9a5795c47bfd	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-07 04:59:01.577461+00	
00000000-0000-0000-0000-000000000000	e6d81bf4-3888-4788-a985-6fb5621cbc6e	{"action":"user_modified","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"user","traits":{"user_email":"gv001@gmail.com","user_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","user_phone":""}}	2025-06-07 05:01:47.528375+00	
00000000-0000-0000-0000-000000000000	333ebb08-d552-420c-a9e3-6e142aece6e2	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-07 05:02:02.707811+00	
00000000-0000-0000-0000-000000000000	1f9db0d6-8c08-48f1-85e2-9ebf8cc10400	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-07 05:03:31.851973+00	
00000000-0000-0000-0000-000000000000	92b8cf0d-fce4-441a-a2ea-66d9b2c1e48f	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-07 05:03:58.425601+00	
00000000-0000-0000-0000-000000000000	0a6c7418-2948-42b2-8479-c07e1be6e896	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-07 05:08:00.144302+00	
00000000-0000-0000-0000-000000000000	e6a3e2a3-77bd-4239-8079-f59e2aaf8eea	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-07 07:29:30.326086+00	
00000000-0000-0000-0000-000000000000	e067b507-4deb-463c-b6eb-b5568418348d	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-07 13:33:31.029923+00	
00000000-0000-0000-0000-000000000000	774eefbb-7682-4842-b84f-59be17c4da6d	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-07 13:33:31.041427+00	
00000000-0000-0000-0000-000000000000	81392748-1eca-4d6d-9bdf-b410109527b4	{"action":"token_refreshed","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-10 03:05:23.251664+00	
00000000-0000-0000-0000-000000000000	09fa8e7b-4613-4d0d-85af-b775bab6f99a	{"action":"token_revoked","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-10 03:05:23.258886+00	
00000000-0000-0000-0000-000000000000	a448d973-2e58-48ac-b6bf-aaa8d162ed0f	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 03:05:56.434164+00	
00000000-0000-0000-0000-000000000000	ea4ba782-f404-46c5-9479-c33e2cde6226	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 03:28:01.859655+00	
00000000-0000-0000-0000-000000000000	02e9e13d-8d9a-4f49-97f1-4a65665239f1	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 03:29:21.999137+00	
00000000-0000-0000-0000-000000000000	7a33063a-84a0-4861-8f70-a2bf15cd034e	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 03:30:11.740555+00	
00000000-0000-0000-0000-000000000000	15d4d49a-75c4-46b5-94e6-a7a53acbde6a	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 03:31:03.861616+00	
00000000-0000-0000-0000-000000000000	55a9d66a-ec74-4fa0-9db2-20571642bcc9	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-10 09:32:11.080413+00	
00000000-0000-0000-0000-000000000000	bbaae37b-8ae7-4720-adc7-1139ad18c619	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-10 09:32:11.085599+00	
00000000-0000-0000-0000-000000000000	ebe55b44-e141-4dbd-bc51-0c2ba7d84402	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 09:32:11.950476+00	
00000000-0000-0000-0000-000000000000	2ca95248-d8fd-4ea4-a3c5-48749481d8d1	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 09:32:50.684255+00	
00000000-0000-0000-0000-000000000000	0d4b17f0-ecc6-44b3-8bff-4b95b7c6dd7f	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 09:33:42.061876+00	
00000000-0000-0000-0000-000000000000	620f24dc-7d7d-4753-ad42-e0b615ecfb09	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 09:33:57.691363+00	
00000000-0000-0000-0000-000000000000	f021a291-10e0-4e4c-8623-9eda24e9123a	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 09:49:12.717821+00	
00000000-0000-0000-0000-000000000000	b1ef1541-203b-49ff-814a-efb353e77964	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 09:49:16.48513+00	
00000000-0000-0000-0000-000000000000	809cee34-a340-408b-834d-6da85a67bd43	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 09:52:50.991811+00	
00000000-0000-0000-0000-000000000000	7b34fc18-7e87-4b4c-a5eb-26e14a9a06fc	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 09:52:55.515532+00	
00000000-0000-0000-0000-000000000000	affb8125-2669-4540-bdf1-51b25b156b90	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 10:17:05.848588+00	
00000000-0000-0000-0000-000000000000	a05f69fa-afdc-41b3-85a9-a4d0070e746c	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 10:17:09.582742+00	
00000000-0000-0000-0000-000000000000	3de4f06f-9035-4712-9a38-7d67488140e2	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 10:20:35.614668+00	
00000000-0000-0000-0000-000000000000	573aabf8-6606-48b2-9ddc-8904770de691	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 10:20:39.255852+00	
00000000-0000-0000-0000-000000000000	4449af21-245e-4954-a84e-173f74cb2db5	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 10:21:11.855581+00	
00000000-0000-0000-0000-000000000000	7381a3ae-4664-4e01-af76-a8a39447eb4a	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 10:21:17.278723+00	
00000000-0000-0000-0000-000000000000	79ef6b11-fd87-45f8-b76f-564555d91b22	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 10:28:24.145017+00	
00000000-0000-0000-0000-000000000000	f8d431be-d188-4790-98f3-786163e154b3	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 10:35:33.51081+00	
00000000-0000-0000-0000-000000000000	c33afd56-ee75-418e-be71-15b1b1d1b3f9	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 10:35:35.923299+00	
00000000-0000-0000-0000-000000000000	58d8ab3d-703c-461c-a16c-1ab902ad8165	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 10:37:59.986903+00	
00000000-0000-0000-0000-000000000000	f202492b-c9a8-415f-bf29-7af682ad81bd	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 10:38:44.491724+00	
00000000-0000-0000-0000-000000000000	eb5f4b23-ffac-45b1-96e0-da81c9a6c532	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 10:39:03.540796+00	
00000000-0000-0000-0000-000000000000	f482b662-80e4-4eed-b1c5-3715046f2456	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 10:39:06.075683+00	
00000000-0000-0000-0000-000000000000	2045767d-df85-498d-b026-a617ca10ea89	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 10:41:05.849211+00	
00000000-0000-0000-0000-000000000000	c1dbc6c4-babd-4073-980e-aad36221bd1b	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 10:41:08.76865+00	
00000000-0000-0000-0000-000000000000	d913a1e1-e862-4d4a-8e04-a1ff0f270755	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 10:44:05.088361+00	
00000000-0000-0000-0000-000000000000	27cc1f80-1752-407f-8e8c-4392e97d8f39	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 10:44:07.495059+00	
00000000-0000-0000-0000-000000000000	bd0c625f-b0b4-4198-87c4-cb77965308f6	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 10:47:07.297653+00	
00000000-0000-0000-0000-000000000000	07ab8614-85ae-4d2e-a335-a636b642e1db	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 10:47:10.329039+00	
00000000-0000-0000-0000-000000000000	3d6a248c-be1d-4afc-acae-7db47ef88e80	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 10:48:48.539147+00	
00000000-0000-0000-0000-000000000000	51260cad-c9ad-4b1c-9725-bfb70fdb4c52	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 10:48:51.028507+00	
00000000-0000-0000-0000-000000000000	20538068-252a-4099-b336-7bd90c84137c	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 10:53:25.183852+00	
00000000-0000-0000-0000-000000000000	cc76a348-408d-452b-916d-3831b97cb1b9	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 10:53:28.451652+00	
00000000-0000-0000-0000-000000000000	473595df-d2d1-489e-8489-685734eb3143	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 10:55:12.446084+00	
00000000-0000-0000-0000-000000000000	e5261052-ca4f-4f52-a673-4ff0475c3fe1	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 10:55:16.403505+00	
00000000-0000-0000-0000-000000000000	5aaa08f3-c4d1-4c91-8a1e-eedb87b583b6	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 10:56:47.270119+00	
00000000-0000-0000-0000-000000000000	84fd8371-dfc4-467e-b07a-b43bfa62a6ac	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 10:56:50.292568+00	
00000000-0000-0000-0000-000000000000	782894a4-7bb5-4971-8584-6c591a1201c3	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 11:35:03.697894+00	
00000000-0000-0000-0000-000000000000	e12079e6-ebb2-49bd-add3-3834035d07d9	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 11:35:07.974996+00	
00000000-0000-0000-0000-000000000000	b44b5a06-055e-44f6-ab11-6560ea12a601	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-10 11:49:34.161386+00	
00000000-0000-0000-0000-000000000000	01bc05ad-5918-4f74-9f2b-d556def2e00f	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 11:49:37.290896+00	
00000000-0000-0000-0000-000000000000	b9be739a-3359-45ed-9897-23bf1fac2561	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-10 12:34:46.820414+00	
00000000-0000-0000-0000-000000000000	e01cca97-bbb5-4359-8075-0e18ed898d9f	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-11 02:32:25.964207+00	
00000000-0000-0000-0000-000000000000	3658d5df-0cde-4fa4-8690-b96ba53552b8	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-11 02:33:01.146472+00	
00000000-0000-0000-0000-000000000000	8755756b-3aca-441c-8e5f-f7a309df4f3d	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-13 06:24:19.797946+00	
00000000-0000-0000-0000-000000000000	922a214f-307f-4247-87a4-8e77499c2fcc	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-11 02:34:01.106127+00	
00000000-0000-0000-0000-000000000000	f6c76e52-7ed0-43a7-9e24-a365655a3441	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 03:50:49.598939+00	
00000000-0000-0000-0000-000000000000	a8176f70-9ff0-46e5-9566-7930154254df	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-13 03:52:55.899027+00	
00000000-0000-0000-0000-000000000000	c8d2c24a-7005-42a5-bb27-e812dddae57d	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 03:53:39.906321+00	
00000000-0000-0000-0000-000000000000	79161b9c-134f-4c22-8f98-b5fbe4565c39	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 04:08:47.708144+00	
00000000-0000-0000-0000-000000000000	4f3cfdaa-bf21-4d2b-b9a1-1db50c848baf	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 04:16:03.721752+00	
00000000-0000-0000-0000-000000000000	1f3184f1-482c-4258-b51a-22926ee443bd	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 04:20:53.78349+00	
00000000-0000-0000-0000-000000000000	bce54538-d6cb-4935-9265-3c108b314084	{"action":"user_repeated_signup","actor_id":"2956b155-1d48-4058-acdb-c1151fa5c9fd","actor_username":"gv002@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-06-13 04:34:31.841417+00	
00000000-0000-0000-0000-000000000000	9f14eda9-ddcf-4f33-8d0d-212a0ad0eef1	{"action":"user_signedup","actor_id":"8c75fb07-ba4b-4df0-badd-6f7b8a3a8361","actor_username":"gv003@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-06-13 04:34:52.286847+00	
00000000-0000-0000-0000-000000000000	27fe9c52-ad52-47bf-b9a5-0a1b269923a1	{"action":"login","actor_id":"8c75fb07-ba4b-4df0-badd-6f7b8a3a8361","actor_username":"gv003@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 04:34:52.297568+00	
00000000-0000-0000-0000-000000000000	770184e9-5cfc-44b5-8e17-76925318705a	{"action":"login","actor_id":"8c75fb07-ba4b-4df0-badd-6f7b8a3a8361","actor_username":"gv003@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 04:35:08.450962+00	
00000000-0000-0000-0000-000000000000	03a803fc-46a8-4713-b584-98587c48f40d	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 04:38:04.343738+00	
00000000-0000-0000-0000-000000000000	2718612e-5b0d-4616-b3ce-a8d1d62e67ae	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-13 04:45:14.143802+00	
00000000-0000-0000-0000-000000000000	9ab4c75e-ddf1-4bb6-8839-078c1cfe8326	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 04:45:18.141625+00	
00000000-0000-0000-0000-000000000000	456e83e3-838b-4dbd-b91d-c1ce9a0ecc6a	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 04:50:56.463155+00	
00000000-0000-0000-0000-000000000000	596e1ad1-f9b5-4a8f-9b6d-9204fd9e660b	{"action":"logout","actor_id":"8c75fb07-ba4b-4df0-badd-6f7b8a3a8361","actor_username":"gv003@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-13 05:04:21.45283+00	
00000000-0000-0000-0000-000000000000	ed8cae73-b700-47b3-a253-aa19f4fc6ec4	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 05:04:25.110246+00	
00000000-0000-0000-0000-000000000000	83cfc7a8-5a2b-446e-805b-218a00ade3e7	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-13 05:04:42.825878+00	
00000000-0000-0000-0000-000000000000	dacfffc4-edf7-4782-9e6c-d49f0f5ae1fb	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 05:04:45.777783+00	
00000000-0000-0000-0000-000000000000	0bd5e90d-ec26-41d9-8bcf-d997568ab259	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-13 05:05:08.706325+00	
00000000-0000-0000-0000-000000000000	05c5213f-d231-4714-8c2b-d51f51f5892b	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 05:05:12.024461+00	
00000000-0000-0000-0000-000000000000	5324c8da-f188-4a9f-a209-ccf427f8ea78	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-13 05:14:11.323081+00	
00000000-0000-0000-0000-000000000000	4f6150a0-a806-4747-bf80-5048ffddf9e1	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 05:14:15.536159+00	
00000000-0000-0000-0000-000000000000	01af6998-8a4a-4d5e-b1ca-60f6d1af462b	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 05:22:17.5282+00	
00000000-0000-0000-0000-000000000000	71c5289c-dd8e-4f0a-9d51-83e8b78c0471	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-13 05:24:17.017382+00	
00000000-0000-0000-0000-000000000000	ef2224a4-4d8b-4237-8a32-46cd1afa2929	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 05:24:21.475893+00	
00000000-0000-0000-0000-000000000000	f1ff6129-3675-485e-a08e-8c0ade97d90b	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 05:32:53.993012+00	
00000000-0000-0000-0000-000000000000	82da4b2a-be9f-4616-adb2-cb6b3b7651f4	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 05:33:47.596879+00	
00000000-0000-0000-0000-000000000000	77c3c9ce-4baf-4dd6-8960-a2b1f106f6f1	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-13 05:36:22.874812+00	
00000000-0000-0000-0000-000000000000	d0771bfd-a946-4733-8939-b914728df5a3	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 05:36:26.283279+00	
00000000-0000-0000-0000-000000000000	163ad7a0-8807-4666-af3a-1e804ace9aaf	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 06:09:57.995486+00	
00000000-0000-0000-0000-000000000000	1d7f8caa-a46b-468a-b826-744bae29cfdd	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 06:10:34.658285+00	
00000000-0000-0000-0000-000000000000	5663d01a-2da8-4bba-8727-872b88852f4c	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 06:24:34.161845+00	
00000000-0000-0000-0000-000000000000	50af25c7-46e4-416a-8f77-4f46bb08c6a3	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 11:20:50.270489+00	
00000000-0000-0000-0000-000000000000	21eacf9a-0527-466c-909c-bc7f5772e4a5	{"action":"token_refreshed","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-13 11:25:26.909372+00	
00000000-0000-0000-0000-000000000000	b8157bdf-f1a8-4bab-ad3c-0c2787d3d87f	{"action":"token_revoked","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-13 11:25:26.911321+00	
00000000-0000-0000-0000-000000000000	e8c2ff88-2beb-46fc-b0d6-975c391b4c67	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 11:25:40.044846+00	
00000000-0000-0000-0000-000000000000	1de63e9d-b9b3-4184-bda0-35a5c52bb8cc	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-13 11:32:02.343018+00	
00000000-0000-0000-0000-000000000000	4ce8ed6b-dd35-4846-8d18-e2b29badf93f	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 11:32:05.935615+00	
00000000-0000-0000-0000-000000000000	180d778b-6fae-4d3b-8cbd-c8d74435419c	{"action":"token_refreshed","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-13 11:36:03.777956+00	
00000000-0000-0000-0000-000000000000	b365477c-4a6d-49ce-a779-84029f6e3e70	{"action":"token_revoked","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-13 11:36:03.779865+00	
00000000-0000-0000-0000-000000000000	2a9cb1eb-32f4-4ee2-b3eb-c37ffa708c5b	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 11:36:12.928031+00	
00000000-0000-0000-0000-000000000000	0b8b2b95-8ebb-43a3-9b2e-7d360abf7eae	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-13 11:55:12.691456+00	
00000000-0000-0000-0000-000000000000	b57dfc6d-47ef-416b-9259-098922c33f57	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-17 03:36:01.551092+00	
00000000-0000-0000-0000-000000000000	c820adcc-ca20-4d27-a31c-53e93ac49551	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-17 03:36:01.565261+00	
00000000-0000-0000-0000-000000000000	71d0cd43-fc05-4a4c-87e5-ac784361af1f	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-17 03:36:23.080407+00	
00000000-0000-0000-0000-000000000000	5edadc03-2596-4a27-8a31-bf365ee41838	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-17 03:39:19.207642+00	
00000000-0000-0000-0000-000000000000	fed6dbc5-a3d3-4266-9174-2067db348a36	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-17 03:43:51.363806+00	
00000000-0000-0000-0000-000000000000	ab59239e-3bf1-40bf-8b43-1dc3245c0625	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-17 03:43:55.547916+00	
00000000-0000-0000-0000-000000000000	85e38c1e-9f0e-4c29-9ade-bd4ea71fbfec	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-17 03:49:35.004011+00	
00000000-0000-0000-0000-000000000000	5f756fcd-8901-46ea-9947-f508c8793ab4	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-17 03:49:38.488603+00	
00000000-0000-0000-0000-000000000000	2caa1197-241f-4265-9c1d-dd7983fece1b	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-17 03:54:13.280286+00	
00000000-0000-0000-0000-000000000000	6c90eed2-3e45-43ee-a453-b9fba78f4b2b	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-17 03:54:16.599617+00	
00000000-0000-0000-0000-000000000000	e13b0898-c00a-4454-80ee-ac30b8ab4e32	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-17 03:54:40.90108+00	
00000000-0000-0000-0000-000000000000	16fcc2b8-ff52-4306-afb6-5209bd871a45	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-17 03:54:43.018339+00	
00000000-0000-0000-0000-000000000000	86c36b76-f255-4e27-8317-2b1c72060aa0	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-17 03:54:53.299079+00	
00000000-0000-0000-0000-000000000000	4e761a24-e128-4f10-8023-aff46c56b644	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-17 03:54:55.661253+00	
00000000-0000-0000-0000-000000000000	cbc5a727-9937-46b1-b3f1-27a53e9fc465	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-17 03:59:10.918634+00	
00000000-0000-0000-0000-000000000000	12c14709-ba73-4a62-b067-77fc9def2e0a	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-17 03:59:14.906226+00	
00000000-0000-0000-0000-000000000000	41a9be01-fe06-4154-9bb7-29feac5717ac	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-17 03:59:32.765187+00	
00000000-0000-0000-0000-000000000000	89e6ea89-56f3-4680-962b-5c753a43aae0	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-17 03:59:35.444905+00	
00000000-0000-0000-0000-000000000000	6f822456-4e17-4df3-b141-13ac19d945b1	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-17 04:01:23.743381+00	
00000000-0000-0000-0000-000000000000	46f404c8-5f68-4b56-a603-7ad986141755	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-17 04:01:27.492771+00	
00000000-0000-0000-0000-000000000000	dd917ed1-d3e5-4ac2-909a-8ea26b5c0864	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-17 04:09:21.777707+00	
00000000-0000-0000-0000-000000000000	39238da8-fdf8-4ca7-8d4e-c24729d49f88	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-17 04:16:18.700783+00	
00000000-0000-0000-0000-000000000000	5bfc75a7-abbc-41a4-abcc-c21307df6636	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-17 04:16:23.890306+00	
00000000-0000-0000-0000-000000000000	7b045a43-15c8-40c7-ba76-2e2a5ab592ff	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-17 04:21:35.438966+00	
00000000-0000-0000-0000-000000000000	fc1e9dec-0cf1-43cd-80b3-629ed7926a7e	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-17 04:21:56.804481+00	
00000000-0000-0000-0000-000000000000	1e0ea186-f161-43c4-be65-4a769d841288	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-17 04:51:42.372644+00	
00000000-0000-0000-0000-000000000000	d12bf578-d76e-4cc6-9408-5f5e503afd5a	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-17 04:51:46.603789+00	
00000000-0000-0000-0000-000000000000	cfebda58-fc5e-47a2-ba31-70e0492014f5	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 06:25:27.000772+00	
00000000-0000-0000-0000-000000000000	74a8f914-6736-4530-a0c7-6040f2669ebd	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-19 06:29:22.94208+00	
00000000-0000-0000-0000-000000000000	e355a610-3c92-4780-9406-9f7f9d312293	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 06:29:34.165759+00	
00000000-0000-0000-0000-000000000000	27aeddb1-b684-4180-ba77-c37bedcdd916	{"action":"user_signedup","actor_id":"2a29ff32-0dbd-4f3f-ba8d-f7c868e36744","actor_username":"gv000@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-06-19 06:31:16.370102+00	
00000000-0000-0000-0000-000000000000	a30f8c60-7fd1-46b6-a828-207684dc9151	{"action":"login","actor_id":"2a29ff32-0dbd-4f3f-ba8d-f7c868e36744","actor_username":"gv000@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 06:31:16.379226+00	
00000000-0000-0000-0000-000000000000	0458657e-7aa4-435c-b1ff-6ff774f214d2	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 06:32:21.898632+00	
00000000-0000-0000-0000-000000000000	a77d35c2-16d3-49f9-aef5-b8c72be07334	{"action":"user_signedup","actor_id":"d12c4359-e2b0-4165-959d-aec89b853e1a","actor_username":"sv123456@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-06-19 06:32:42.847623+00	
00000000-0000-0000-0000-000000000000	848e39f4-d407-4ecf-8bee-f3cbd3141ed1	{"action":"login","actor_id":"d12c4359-e2b0-4165-959d-aec89b853e1a","actor_username":"sv123456@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 06:32:42.85186+00	
00000000-0000-0000-0000-000000000000	6d0efcd1-3c8a-430b-8b02-4802f809fd40	{"action":"user_signedup","actor_id":"3b4201ff-ee15-44ec-9954-633782fcd401","actor_username":"sv123@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-06-19 06:33:48.348645+00	
00000000-0000-0000-0000-000000000000	63aa7641-7e98-42c1-8fd1-b78d07e13756	{"action":"login","actor_id":"3b4201ff-ee15-44ec-9954-633782fcd401","actor_username":"sv123@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 06:33:48.351736+00	
00000000-0000-0000-0000-000000000000	20dcad86-fe55-4a25-967d-cfc0472a5f71	{"action":"user_signedup","actor_id":"89fd994d-0d19-4920-ad87-027b3757ac03","actor_username":"ngominhphat@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-06-19 06:34:15.452739+00	
00000000-0000-0000-0000-000000000000	28423ccb-215a-44d8-808c-dc186fcab50c	{"action":"login","actor_id":"89fd994d-0d19-4920-ad87-027b3757ac03","actor_username":"ngominhphat@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 06:34:15.455671+00	
00000000-0000-0000-0000-000000000000	c00f73e8-686a-4155-9b41-68cf644234b2	{"action":"user_modified","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"user","traits":{"user_email":"3122410449@gmail.com","user_id":"e368b85d-7038-4211-be16-c959c7931de0","user_phone":""}}	2025-06-19 06:41:06.077289+00	
00000000-0000-0000-0000-000000000000	2f6dea98-58e3-455c-8981-05c61f02d6f3	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 06:41:15.090176+00	
00000000-0000-0000-0000-000000000000	5ca53daf-89df-4b84-b363-6c2e8c5f60d4	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 06:48:14.623227+00	
00000000-0000-0000-0000-000000000000	fad14ba6-db3e-4813-8863-4c7236d093e6	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 12:41:44.37934+00	
00000000-0000-0000-0000-000000000000	8c0abc03-ef07-4574-bc69-fb8367ae386d	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 12:51:05.48616+00	
00000000-0000-0000-0000-000000000000	7acea2da-0427-413c-a61f-f6fecd2ed4a8	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-19 12:51:32.821625+00	
00000000-0000-0000-0000-000000000000	c3a6a991-20ec-4d60-8afd-f8eaedcc539e	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 12:51:40.697294+00	
00000000-0000-0000-0000-000000000000	bd3dccdd-c8d4-4750-987e-cb51119f1921	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-19 12:59:22.948536+00	
00000000-0000-0000-0000-000000000000	f25a889b-7f41-418e-a5cc-2ca603c03316	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-19 12:59:22.953329+00	
00000000-0000-0000-0000-000000000000	4595a7ec-c09a-4a2c-8ddb-1fadc1d0956d	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 12:59:24.684479+00	
00000000-0000-0000-0000-000000000000	4bcac9ca-6faa-4bfd-a72f-7711260c1004	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-19 12:59:55.000124+00	
00000000-0000-0000-0000-000000000000	e05936c0-09a9-4e27-ad77-dab8f886b30e	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 13:00:37.610655+00	
00000000-0000-0000-0000-000000000000	5a380481-d9de-4c02-a93a-e3cbf33a9b7b	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 13:00:55.286466+00	
00000000-0000-0000-0000-000000000000	6ff056d4-b52c-4d56-a622-2581f435eae7	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 13:24:46.361926+00	
00000000-0000-0000-0000-000000000000	b6852760-fd3c-42b8-9f4a-a1bfcebfd3fe	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-19 13:32:52.246217+00	
00000000-0000-0000-0000-000000000000	02d70e9b-984b-40b4-8724-0b5b036a778a	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 13:32:59.500622+00	
00000000-0000-0000-0000-000000000000	70676dd4-c4e1-4a58-8629-9172dd775de4	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-19 13:33:04.126649+00	
00000000-0000-0000-0000-000000000000	2ecf4a8c-25ff-4bcb-837b-40ecedd912e7	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 13:33:06.190683+00	
00000000-0000-0000-0000-000000000000	414007fd-587c-4b91-8478-d14660123e73	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-19 13:52:20.36743+00	
00000000-0000-0000-0000-000000000000	f4cc0e0c-39b7-4190-8bb9-f793160f2d7d	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 13:52:24.944117+00	
00000000-0000-0000-0000-000000000000	fcdfec67-8135-45ee-b978-d41dc33785e2	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-19 13:53:56.395943+00	
00000000-0000-0000-0000-000000000000	5ceff835-d292-48b8-a86b-6db580fab5f3	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 13:53:59.184469+00	
00000000-0000-0000-0000-000000000000	a4c9cb38-5945-4b9b-9de7-0e6d1de92d9d	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 13:57:56.384879+00	
00000000-0000-0000-0000-000000000000	0326edb6-cec9-4dbb-9b70-04628d14f192	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-19 14:08:47.45552+00	
00000000-0000-0000-0000-000000000000	6731418c-5c98-48aa-8d8a-da299b2661e1	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 14:09:00.934498+00	
00000000-0000-0000-0000-000000000000	0de23826-1af2-4338-8ad3-a78f48daadf5	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-19 14:09:08.894209+00	
00000000-0000-0000-0000-000000000000	78f2c940-e851-4025-90eb-695c44945a11	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 14:09:11.379444+00	
00000000-0000-0000-0000-000000000000	4b432f7e-4635-43db-9a75-6e1dc59ce04f	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 14:10:03.785787+00	
00000000-0000-0000-0000-000000000000	2bd69d2d-a8db-43a3-855d-e7ecf3605831	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-19 14:12:00.797338+00	
00000000-0000-0000-0000-000000000000	5dd98c57-854c-48e8-9b8a-d344b510bcf8	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 14:12:03.45083+00	
00000000-0000-0000-0000-000000000000	6878f0e8-74a5-4c08-8c52-4990f167e30c	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-19 14:13:37.637126+00	
00000000-0000-0000-0000-000000000000	afee83e8-52e6-4692-910c-bb8a0d0493c1	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-19 14:13:39.73926+00	
00000000-0000-0000-0000-000000000000	d9a6b97e-04bf-4586-85d7-d42ad46b08a9	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-20 02:18:22.048524+00	
00000000-0000-0000-0000-000000000000	1f67e6ce-f978-4a03-82d6-d6941044cad1	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-20 02:19:59.098716+00	
00000000-0000-0000-0000-000000000000	22430e02-bd1c-446b-8a06-fba0b612a6c0	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-20 02:20:02.822415+00	
00000000-0000-0000-0000-000000000000	6f3b9ed2-6b05-4327-a216-7314654ea91c	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-20 02:22:51.947538+00	
00000000-0000-0000-0000-000000000000	f63aa2c2-2576-40db-99d7-e80effddf309	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-20 02:22:51.95181+00	
00000000-0000-0000-0000-000000000000	68a44b12-7dbb-47ba-8580-2b381737649f	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-20 02:22:54.408979+00	
00000000-0000-0000-0000-000000000000	fce1597f-a98c-477e-a3e9-0697df8842d3	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-20 02:48:27.942516+00	
00000000-0000-0000-0000-000000000000	0d9549e5-4056-4e7c-a8f2-7f90cdb93e3b	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-20 02:48:31.465411+00	
00000000-0000-0000-0000-000000000000	60b66c5d-987d-4cd5-a67d-72a86836cc0a	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-20 02:49:42.08628+00	
00000000-0000-0000-0000-000000000000	e6f77fec-556b-4a12-8cb3-47229fc291cc	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-20 02:49:44.361628+00	
00000000-0000-0000-0000-000000000000	64b8c92c-84b8-4923-b14f-2a0ef156578c	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-20 02:51:11.588842+00	
00000000-0000-0000-0000-000000000000	861d5e5c-aeba-4a8c-bc49-a5b37b91df60	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-20 02:51:14.135933+00	
00000000-0000-0000-0000-000000000000	38914a81-c238-443d-a4d0-6756e82728b8	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-20 02:51:32.938894+00	
00000000-0000-0000-0000-000000000000	8eae1c5d-9437-495a-997b-b323a52e8271	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-20 02:51:35.29187+00	
00000000-0000-0000-0000-000000000000	6c888131-e1f1-427d-bae2-b55a9ef0bd67	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-20 03:21:32.190923+00	
00000000-0000-0000-0000-000000000000	bdd3d9d9-fc05-4c7c-93cd-0a1c6e701acb	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-20 03:21:35.199752+00	
00000000-0000-0000-0000-000000000000	ada8da42-443c-4813-b4e5-1f678150b4be	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-20 03:22:43.655498+00	
00000000-0000-0000-0000-000000000000	9f109b87-8375-4f79-9f70-dc84e5a48a76	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-20 03:22:47.686335+00	
00000000-0000-0000-0000-000000000000	813fb7e3-d561-4a34-bda6-f635a0ae01b2	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-20 04:21:02.528366+00	
00000000-0000-0000-0000-000000000000	455cf9d9-cc9e-4db0-aeb3-8da8309eb070	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-20 04:21:02.539481+00	
00000000-0000-0000-0000-000000000000	bbfcfa5b-9573-4973-9675-370785aa8196	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-20 12:16:13.289758+00	
00000000-0000-0000-0000-000000000000	d5996894-21f5-4370-83ad-afd8b8ce610d	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-20 12:18:40.888983+00	
00000000-0000-0000-0000-000000000000	f686c8f7-62a4-4482-90db-b3c1fecd56bd	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-20 13:57:42.659283+00	
00000000-0000-0000-0000-000000000000	8e948f08-48ed-47b5-972c-86d3fb0fe7d8	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-20 13:57:42.666275+00	
00000000-0000-0000-0000-000000000000	0345296e-a2e9-475c-9c43-72ac510c9f06	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-20 14:03:48.839203+00	
00000000-0000-0000-0000-000000000000	69e4c954-1fe8-4750-905a-d8a17a111eba	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-06-20 14:25:30.459714+00	
00000000-0000-0000-0000-000000000000	45e3ea15-bd8b-4bba-880e-73f077cc7d41	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-20 14:26:04.641953+00	
00000000-0000-0000-0000-000000000000	d827839d-e7b9-431c-b755-8f2b5e9910e6	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-24 04:33:47.138924+00	
00000000-0000-0000-0000-000000000000	aeb5e62d-e0e8-4157-a645-6422a6ec67dd	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-24 07:34:11.41727+00	
00000000-0000-0000-0000-000000000000	99aa0c5b-28e6-417d-bdb2-3c2c75272182	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-24 07:34:11.436057+00	
00000000-0000-0000-0000-000000000000	439bccde-14a4-4a49-ba51-9d4590fc1f0f	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-24 12:10:27.713429+00	
00000000-0000-0000-0000-000000000000	0d207b5e-394f-4d16-8e27-73dd8cb40537	{"action":"token_refreshed","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-24 17:55:48.122243+00	
00000000-0000-0000-0000-000000000000	ebaa9b5f-2ac6-420d-868d-b5203f53fe39	{"action":"token_revoked","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-06-24 17:55:48.127128+00	
00000000-0000-0000-0000-000000000000	f0dfa353-ad9c-4d7b-ae4d-915eeb139965	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-15 13:16:09.981105+00	
00000000-0000-0000-0000-000000000000	6855a1fc-aea1-4c58-a171-fc672daa2da0	{"action":"token_refreshed","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-07-30 03:20:32.470586+00	
00000000-0000-0000-0000-000000000000	e6df14bc-729b-4a7f-9661-1b20f6441fbe	{"action":"token_revoked","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-07-30 03:20:32.480021+00	
00000000-0000-0000-0000-000000000000	6966c9d3-eaae-4bc3-a330-61b3f7034842	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-30 03:24:03.682279+00	
00000000-0000-0000-0000-000000000000	2d5ae664-271f-44aa-a896-833545f4d1c1	{"action":"token_refreshed","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-07-31 15:21:12.231291+00	
00000000-0000-0000-0000-000000000000	d577658d-1106-4903-801f-d2912c9b5053	{"action":"token_revoked","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-07-31 15:21:12.240403+00	
00000000-0000-0000-0000-000000000000	5555a5d5-4117-47d5-9c2f-c4c3315a450a	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-31 15:21:14.119232+00	
00000000-0000-0000-0000-000000000000	37bb9301-124f-44d9-a086-6e7a43be8f5f	{"action":"logout","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-07-31 15:21:19.76527+00	
00000000-0000-0000-0000-000000000000	2348c1ac-0ecd-4233-bd5b-24aca1843025	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-31 15:21:23.017006+00	
00000000-0000-0000-0000-000000000000	491d03d3-42af-4fc9-935e-90d3c5717254	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-31 15:54:28.597675+00	
00000000-0000-0000-0000-000000000000	dd333487-be26-46e2-a1f3-79668968d2a7	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-15 09:06:02.560932+00	
00000000-0000-0000-0000-000000000000	b3fc3e4e-bee5-4272-a0a4-b5b33764204a	{"action":"logout","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-08-15 09:06:13.213075+00	
00000000-0000-0000-0000-000000000000	d741111e-1e05-4e8a-a981-4a6ee12bdcdf	{"action":"token_refreshed","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-08-23 15:41:01.613188+00	
00000000-0000-0000-0000-000000000000	6108338b-335f-4b22-b600-07a88483bb09	{"action":"token_revoked","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-08-23 15:41:01.643195+00	
00000000-0000-0000-0000-000000000000	d29d0c67-21ff-4108-9bf2-05f5f1bf150c	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-24 06:14:03.12431+00	
00000000-0000-0000-0000-000000000000	acf7b238-d462-49e4-b83c-7b2d0728eeb6	{"action":"logout","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-08-24 06:16:46.315136+00	
00000000-0000-0000-0000-000000000000	2de5010b-26f2-4726-a796-b007a8efdabb	{"action":"user_signedup","actor_id":"3ada3240-643f-4735-b17d-39fc4ec262a2","actor_username":"123123@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-08-24 06:18:22.639415+00	
00000000-0000-0000-0000-000000000000	7e34e789-1ad1-48c1-9726-53955aef6600	{"action":"login","actor_id":"3ada3240-643f-4735-b17d-39fc4ec262a2","actor_username":"123123@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-24 06:18:22.659494+00	
00000000-0000-0000-0000-000000000000	ea98b2eb-a955-4bde-bea6-03ad67b444f4	{"action":"user_repeated_signup","actor_id":"2956b155-1d48-4058-acdb-c1151fa5c9fd","actor_username":"gv002@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-08-24 06:19:24.783626+00	
00000000-0000-0000-0000-000000000000	f3524a14-bae5-48fa-9b8d-a1610996cace	{"action":"user_signedup","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-08-24 06:19:32.392252+00	
00000000-0000-0000-0000-000000000000	10277241-6916-4382-aee1-f3a92b9e4305	{"action":"login","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-24 06:19:32.396229+00	
00000000-0000-0000-0000-000000000000	b15bb92e-b842-47ee-97fd-1efcdb4677e0	{"action":"login","actor_id":"3ada3240-643f-4735-b17d-39fc4ec262a2","actor_username":"123123@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-24 06:19:52.067449+00	
00000000-0000-0000-0000-000000000000	84558be8-8668-46e1-bb6d-cc0bf3d554ca	{"action":"login","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-24 06:20:09.535299+00	
00000000-0000-0000-0000-000000000000	8c53ba58-1d17-4a6e-8d63-cc81952fa60f	{"action":"logout","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-08-24 06:22:10.529151+00	
00000000-0000-0000-0000-000000000000	24ff0e97-45a6-46e0-943d-0877d922961d	{"action":"login","actor_id":"3ada3240-643f-4735-b17d-39fc4ec262a2","actor_username":"123123@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-24 06:22:12.819887+00	
00000000-0000-0000-0000-000000000000	21da9798-b735-46a3-91ce-d1ca11c6bcf8	{"action":"logout","actor_id":"3ada3240-643f-4735-b17d-39fc4ec262a2","actor_username":"123123@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-08-24 06:24:10.74432+00	
00000000-0000-0000-0000-000000000000	d34833e3-fcc5-4dae-ad33-edb3676c74e1	{"action":"login","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-24 06:24:15.541652+00	
00000000-0000-0000-0000-000000000000	91b0218c-b34a-4db4-b102-045c696202c8	{"action":"logout","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-08-24 06:28:51.189694+00	
00000000-0000-0000-0000-000000000000	fae22267-84f1-4058-9694-129fed12b0f9	{"action":"login","actor_id":"3ada3240-643f-4735-b17d-39fc4ec262a2","actor_username":"123123@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-24 06:28:55.269179+00	
00000000-0000-0000-0000-000000000000	e8a462de-0c2a-47e3-959a-8560598f9bb0	{"action":"logout","actor_id":"3ada3240-643f-4735-b17d-39fc4ec262a2","actor_username":"123123@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-08-24 06:30:37.316172+00	
00000000-0000-0000-0000-000000000000	3636a4c2-23ae-4bbc-af0a-69e28f376089	{"action":"login","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-24 06:30:40.314661+00	
00000000-0000-0000-0000-000000000000	3bbd1365-d6a6-4680-8df9-930ce2dd2cd6	{"action":"logout","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-08-24 06:40:35.321077+00	
00000000-0000-0000-0000-000000000000	af672c2a-62ae-47cc-9827-f5d5e6ce7989	{"action":"login","actor_id":"3ada3240-643f-4735-b17d-39fc4ec262a2","actor_username":"123123@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-24 06:49:53.777355+00	
00000000-0000-0000-0000-000000000000	9eed71f1-709d-4984-bff6-d67b67f71d07	{"action":"logout","actor_id":"3ada3240-643f-4735-b17d-39fc4ec262a2","actor_username":"123123@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-08-24 06:50:09.588636+00	
00000000-0000-0000-0000-000000000000	74b5461c-7ae6-471a-ba11-1363b78359c2	{"action":"login","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-24 06:50:13.716491+00	
00000000-0000-0000-0000-000000000000	c7845805-9ad5-4e83-8c68-610c500f3fb8	{"action":"logout","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-08-24 06:52:46.833366+00	
00000000-0000-0000-0000-000000000000	44a362fe-b8f9-4c22-b539-8b5107748e39	{"action":"login","actor_id":"3ada3240-643f-4735-b17d-39fc4ec262a2","actor_username":"123123@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-24 06:52:48.97139+00	
00000000-0000-0000-0000-000000000000	a46fbbb9-c1b4-483a-af0a-16dbce41fd8c	{"action":"logout","actor_id":"3ada3240-643f-4735-b17d-39fc4ec262a2","actor_username":"123123@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-08-24 06:55:18.216194+00	
00000000-0000-0000-0000-000000000000	af49d39e-865a-44b6-b39f-21f89ba19715	{"action":"login","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-24 06:55:22.520011+00	
00000000-0000-0000-0000-000000000000	1c3b2394-7274-4035-84be-b07b8eb122f8	{"action":"logout","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-08-24 06:57:05.159456+00	
00000000-0000-0000-0000-000000000000	4cb12abf-fea9-4cee-ac51-4214d441a073	{"action":"login","actor_id":"3ada3240-643f-4735-b17d-39fc4ec262a2","actor_username":"123123@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-24 06:57:07.305294+00	
00000000-0000-0000-0000-000000000000	7b42faf1-5833-4e92-8523-062fd3fcf786	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-08-24 06:59:55.330265+00	
00000000-0000-0000-0000-000000000000	63ad8f8a-5a1b-4727-8985-c4d5ecab615e	{"action":"login","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 03:33:07.264212+00	
00000000-0000-0000-0000-000000000000	8013579b-58b3-4a0f-90c5-16e573699fc8	{"action":"user_modified","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"user","traits":{"user_email":"123123@gmail.com","user_id":"3ada3240-643f-4735-b17d-39fc4ec262a2","user_phone":""}}	2025-09-13 03:46:33.14769+00	
00000000-0000-0000-0000-000000000000	a3880d3b-b08f-482d-a9d4-f20c6088bdf0	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 03:47:05.378611+00	
00000000-0000-0000-0000-000000000000	25d936e2-372e-445c-9e71-19fbce8be5f1	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 03:47:16.698945+00	
00000000-0000-0000-0000-000000000000	5fe4de73-327f-4654-80eb-c36e60fe3f2e	{"action":"user_modified","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"user","traits":{"user_email":"123123@gmail.com","user_id":"3ada3240-643f-4735-b17d-39fc4ec262a2","user_phone":""}}	2025-09-13 03:48:25.156585+00	
00000000-0000-0000-0000-000000000000	4c568180-4bd7-423a-b627-5bd582bb5b7c	{"action":"user_modified","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"user","traits":{"user_email":"gv003@gmail.com","user_id":"8c75fb07-ba4b-4df0-badd-6f7b8a3a8361","user_phone":""}}	2025-09-13 03:48:56.211936+00	
00000000-0000-0000-0000-000000000000	dc2c8228-5223-4bcb-8544-59d009549e4d	{"action":"login","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 03:51:53.645042+00	
00000000-0000-0000-0000-000000000000	7f0399d0-0277-49f3-8644-1233cec2d34b	{"action":"logout","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-13 03:53:22.622502+00	
00000000-0000-0000-0000-000000000000	2134049c-dbac-4ed9-9eef-c9bba60f6e42	{"action":"login","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 03:53:47.05663+00	
00000000-0000-0000-0000-000000000000	f3c90d71-7a59-4268-b02c-9709a6de8afb	{"action":"logout","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-13 04:04:22.331625+00	
00000000-0000-0000-0000-000000000000	93e902e2-1ac0-45e1-b392-44d528beacf0	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:04:50.926945+00	
00000000-0000-0000-0000-000000000000	39c9caba-9783-4907-94c5-82f6a2080172	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:05:00.095818+00	
00000000-0000-0000-0000-000000000000	3cd8eccc-eac5-413f-a4ee-5c656cd6fb51	{"action":"user_modified","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"user","traits":{"user_email":"123123@gmail.com","user_id":"3ada3240-643f-4735-b17d-39fc4ec262a2","user_phone":""}}	2025-09-13 04:25:03.901495+00	
00000000-0000-0000-0000-000000000000	ec77c91e-88ec-4b8d-b717-a23a8d7f8abb	{"action":"login","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:25:24.468272+00	
00000000-0000-0000-0000-000000000000	be2cbf50-dafe-4b69-b2b0-9354255529a0	{"action":"logout","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-13 04:26:35.566851+00	
00000000-0000-0000-0000-000000000000	46416569-a141-4f38-a9de-1e7b3d98e56d	{"action":"login","actor_id":"e368b85d-7038-4211-be16-c959c7931de0","actor_username":"3122410449@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:26:41.368756+00	
00000000-0000-0000-0000-000000000000	c5061404-8542-4cf0-968b-035d2b17204f	{"action":"user_signedup","actor_id":"1d0458b8-1c9c-4120-8474-4b3467af2c53","actor_username":"sv0000@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:27:19.673379+00	
00000000-0000-0000-0000-000000000000	1031f0de-96d4-4d16-aa15-0bb41ca43dc8	{"action":"login","actor_id":"1d0458b8-1c9c-4120-8474-4b3467af2c53","actor_username":"sv0000@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:27:19.680507+00	
00000000-0000-0000-0000-000000000000	586e6b4d-0ed3-4be3-94ba-30edd3c9fbc4	{"action":"login","actor_id":"1d0458b8-1c9c-4120-8474-4b3467af2c53","actor_username":"sv0000@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:27:35.195076+00	
00000000-0000-0000-0000-000000000000	7a563313-0f55-4675-864f-79d41605cb26	{"action":"user_signedup","actor_id":"ab2f529a-dda7-4dad-8d6f-27572f4871c1","actor_username":"22145433@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:29:40.405575+00	
00000000-0000-0000-0000-000000000000	292f6daf-267e-4257-b7f4-e5b4f1dff3ed	{"action":"login","actor_id":"ab2f529a-dda7-4dad-8d6f-27572f4871c1","actor_username":"22145433@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:29:40.411761+00	
00000000-0000-0000-0000-000000000000	62d3a549-0c3a-41d6-b500-99b574e2b7da	{"action":"login","actor_id":"ab2f529a-dda7-4dad-8d6f-27572f4871c1","actor_username":"22145433@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:29:54.957122+00	
00000000-0000-0000-0000-000000000000	a961a8c7-ae86-45fb-bdf4-bd8a81888e72	{"action":"user_signedup","actor_id":"cbe2858c-b62c-4e42-b212-5353934cc62f","actor_username":"22145097@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:33:11.002224+00	
00000000-0000-0000-0000-000000000000	a66a3fb9-26bf-4810-b069-0a9868be0adc	{"action":"login","actor_id":"cbe2858c-b62c-4e42-b212-5353934cc62f","actor_username":"22145097@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:33:11.008154+00	
00000000-0000-0000-0000-000000000000	b426ac31-710c-4320-a828-97ae345e5b28	{"action":"login","actor_id":"cbe2858c-b62c-4e42-b212-5353934cc62f","actor_username":"22145097@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:33:34.373096+00	
00000000-0000-0000-0000-000000000000	2e235757-e78f-4809-8548-85a166e02688	{"action":"user_signedup","actor_id":"695940da-8528-4f2a-a452-6cf9481ae155","actor_username":"22145105@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:34:49.578421+00	
00000000-0000-0000-0000-000000000000	b3c27d1f-54a6-4473-9bd6-cc26ad0eb994	{"action":"login","actor_id":"695940da-8528-4f2a-a452-6cf9481ae155","actor_username":"22145105@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:34:49.587189+00	
00000000-0000-0000-0000-000000000000	3e101bd7-6de8-478c-aa38-2650c7a1297e	{"action":"user_signedup","actor_id":"6f5dacff-4e81-4e42-83e2-1a7cd07bd690","actor_username":"19145225@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:35:02.129707+00	
00000000-0000-0000-0000-000000000000	95a07b7c-659b-449e-b7b7-ea025e4edbf6	{"action":"login","actor_id":"6f5dacff-4e81-4e42-83e2-1a7cd07bd690","actor_username":"19145225@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:35:02.134824+00	
00000000-0000-0000-0000-000000000000	2b7691c9-b0a2-4d45-83b0-cb8ce4bfeec9	{"action":"user_signedup","actor_id":"641a180f-65a1-45b4-a648-a2df8482e0f4","actor_username":"20145112@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:35:21.016155+00	
00000000-0000-0000-0000-000000000000	4e81c7fc-6e0f-4729-92b2-15fd5288be65	{"action":"login","actor_id":"641a180f-65a1-45b4-a648-a2df8482e0f4","actor_username":"20145112@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:35:21.020354+00	
00000000-0000-0000-0000-000000000000	5449e91c-bbe1-4c02-b00e-5cfa7d4ea0a1	{"action":"user_signedup","actor_id":"2ae0b466-781d-4e52-836e-6511c8155742","actor_username":"22145206@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:35:40.065335+00	
00000000-0000-0000-0000-000000000000	e334690f-28e1-456d-abb9-444bd5158e23	{"action":"login","actor_id":"2ae0b466-781d-4e52-836e-6511c8155742","actor_username":"22145206@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:35:40.070014+00	
00000000-0000-0000-0000-000000000000	95b2c67d-f3e1-4af5-826c-f91dac2cd3d2	{"action":"user_signedup","actor_id":"3210fe05-0793-44df-bb7e-a5cb93566759","actor_username":"22145207@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:36:00.021741+00	
00000000-0000-0000-0000-000000000000	90dd4bc0-2c4b-46f9-8269-ab0a88e86ebf	{"action":"login","actor_id":"3210fe05-0793-44df-bb7e-a5cb93566759","actor_username":"22145207@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:36:00.025288+00	
00000000-0000-0000-0000-000000000000	39d422ea-e205-40fd-94d4-414fde749711	{"action":"user_signedup","actor_id":"bf88a0b8-25bf-4743-bf2e-e06ef356a633","actor_username":"22145210@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:36:17.27836+00	
00000000-0000-0000-0000-000000000000	fefa5128-b857-462a-b163-76a1cc306330	{"action":"login","actor_id":"bf88a0b8-25bf-4743-bf2e-e06ef356a633","actor_username":"22145210@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:36:17.281491+00	
00000000-0000-0000-0000-000000000000	f3f641e3-7aeb-4ab4-b6f3-0759e772e0c6	{"action":"user_signedup","actor_id":"09d98c9d-a1a7-4b65-9d6c-ae4e293dbead","actor_username":"22145211@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:36:33.622477+00	
00000000-0000-0000-0000-000000000000	2e444532-b8a9-497e-a029-a313b595eaf5	{"action":"login","actor_id":"09d98c9d-a1a7-4b65-9d6c-ae4e293dbead","actor_username":"22145211@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:36:33.625323+00	
00000000-0000-0000-0000-000000000000	f0b495d2-1187-4461-a1a4-7f80e10245f1	{"action":"user_signedup","actor_id":"a675dd83-18f6-41c2-ba55-92cd88e14541","actor_username":"22145212@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:36:45.138863+00	
00000000-0000-0000-0000-000000000000	ebc91f79-67e8-4cfb-974b-ee80dc99925b	{"action":"login","actor_id":"a675dd83-18f6-41c2-ba55-92cd88e14541","actor_username":"22145212@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:36:45.14185+00	
00000000-0000-0000-0000-000000000000	026aa1b3-d1cb-4b39-b38e-99f224028ce5	{"action":"logout","actor_id":"a675dd83-18f6-41c2-ba55-92cd88e14541","actor_username":"22145212@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-13 04:36:59.096+00	
00000000-0000-0000-0000-000000000000	375cf7ef-a04f-45c4-bf06-3f7c2bd591ef	{"action":"login","actor_id":"2ae0b466-781d-4e52-836e-6511c8155742","actor_username":"22145206@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:37:29.098042+00	
00000000-0000-0000-0000-000000000000	7405e05d-f68c-4fc6-8756-46528356d6f4	{"action":"user_signedup","actor_id":"ed0914b9-f329-4286-b1b9-3cb2a39ff750","actor_username":"22145213@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:37:54.673633+00	
00000000-0000-0000-0000-000000000000	87c0f701-e639-40cd-be39-f2bc9430e0d5	{"action":"login","actor_id":"ed0914b9-f329-4286-b1b9-3cb2a39ff750","actor_username":"22145213@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:37:54.681065+00	
00000000-0000-0000-0000-000000000000	f3d730fa-d006-49ba-9f59-9c15d492e7fc	{"action":"logout","actor_id":"ed0914b9-f329-4286-b1b9-3cb2a39ff750","actor_username":"22145213@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-13 04:37:59.072909+00	
00000000-0000-0000-0000-000000000000	ff5c597c-80c0-480e-b25e-ecfc28800db2	{"action":"login","actor_id":"ed0914b9-f329-4286-b1b9-3cb2a39ff750","actor_username":"22145213@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:38:17.53745+00	
00000000-0000-0000-0000-000000000000	741e8400-512b-41cd-be63-8cbe7eb286a3	{"action":"user_signedup","actor_id":"19fd552e-1b8d-4eba-9fd7-7621451f6272","actor_username":"22145215@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:38:38.697792+00	
00000000-0000-0000-0000-000000000000	792fcad2-b542-487e-a346-33ff78c77d1d	{"action":"login","actor_id":"19fd552e-1b8d-4eba-9fd7-7621451f6272","actor_username":"22145215@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:38:38.700959+00	
00000000-0000-0000-0000-000000000000	d5501e31-2f58-4715-aafb-db94299e1c7a	{"action":"user_signedup","actor_id":"c608c9e1-9cc8-47c4-a71b-28fe5bcf1635","actor_username":"22145216@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:38:51.381843+00	
00000000-0000-0000-0000-000000000000	fd846eb0-c2a9-4d27-a545-52b3a1ad31a9	{"action":"login","actor_id":"c608c9e1-9cc8-47c4-a71b-28fe5bcf1635","actor_username":"22145216@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:38:51.384529+00	
00000000-0000-0000-0000-000000000000	63462e14-f84e-41a9-a033-876739c1b5ab	{"action":"user_signedup","actor_id":"91d20798-accf-4fe7-b038-b9af34a50aad","actor_username":"22145218@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:39:08.144635+00	
00000000-0000-0000-0000-000000000000	0c6375ec-cabb-4355-9411-70d9875d1407	{"action":"login","actor_id":"91d20798-accf-4fe7-b038-b9af34a50aad","actor_username":"22145218@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:39:08.148981+00	
00000000-0000-0000-0000-000000000000	d0c2ed63-549d-4725-8784-339e22f22d8b	{"action":"user_signedup","actor_id":"d677ddb9-7459-44f3-94f9-fcb42ae3cbf5","actor_username":"22145220@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:39:31.354315+00	
00000000-0000-0000-0000-000000000000	bcd4c17b-1e22-4b7f-9bd5-8b23af9f9b6a	{"action":"login","actor_id":"d677ddb9-7459-44f3-94f9-fcb42ae3cbf5","actor_username":"22145220@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:39:31.357831+00	
00000000-0000-0000-0000-000000000000	d7e3c1ea-9178-4b7c-907b-c2a1173d36e2	{"action":"user_signedup","actor_id":"dfc3cb8c-7ab1-4891-b54d-e6101aeccf7a","actor_username":"22145226@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:39:43.753073+00	
00000000-0000-0000-0000-000000000000	4989a1ef-aa55-4e47-910c-03b74b20246b	{"action":"login","actor_id":"dfc3cb8c-7ab1-4891-b54d-e6101aeccf7a","actor_username":"22145226@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:39:43.760357+00	
00000000-0000-0000-0000-000000000000	47e70844-5f19-419c-ac0d-ab915196e553	{"action":"user_signedup","actor_id":"c2d1083d-d480-40cc-947d-cad7294eedc2","actor_username":"22145228@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:39:58.002849+00	
00000000-0000-0000-0000-000000000000	a73415f1-b7ae-4f94-9ca1-6af3f758db68	{"action":"login","actor_id":"c2d1083d-d480-40cc-947d-cad7294eedc2","actor_username":"22145228@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:39:58.005668+00	
00000000-0000-0000-0000-000000000000	3aa53fdc-355a-4979-9271-9d7332934f07	{"action":"logout","actor_id":"c2d1083d-d480-40cc-947d-cad7294eedc2","actor_username":"22145228@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-13 04:40:10.962615+00	
00000000-0000-0000-0000-000000000000	1aac3a3d-d3b0-4072-b5c0-d89998713a91	{"action":"login","actor_id":"c2d1083d-d480-40cc-947d-cad7294eedc2","actor_username":"22145228@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:40:20.750584+00	
00000000-0000-0000-0000-000000000000	e15e3fdc-17f6-462e-99f7-f7c42e277c1a	{"action":"user_signedup","actor_id":"1a921e78-7463-4404-b054-bf6302b40c11","actor_username":"22145230@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:40:51.856765+00	
00000000-0000-0000-0000-000000000000	b009d020-4d35-4a4d-8cf5-dd61bc1dcf80	{"action":"login","actor_id":"1a921e78-7463-4404-b054-bf6302b40c11","actor_username":"22145230@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:40:51.872351+00	
00000000-0000-0000-0000-000000000000	28cdf845-901d-4585-93ba-26f6e2d23f95	{"action":"user_signedup","actor_id":"697fec7b-74d6-4df7-b165-87d112eaf2fc","actor_username":"22145280@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:41:06.789984+00	
00000000-0000-0000-0000-000000000000	cac3ebc2-322d-46a9-8471-85fa1ca1c7fb	{"action":"login","actor_id":"697fec7b-74d6-4df7-b165-87d112eaf2fc","actor_username":"22145280@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:41:06.796997+00	
00000000-0000-0000-0000-000000000000	0351a8c2-9f95-4ff7-b4ce-e73b37fbe7f0	{"action":"user_signedup","actor_id":"89800f22-6220-467a-b58d-5f6f22db2647","actor_username":"22145290@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-13 04:41:19.353191+00	
00000000-0000-0000-0000-000000000000	6ecaa01b-fa33-4883-b00b-af987fa9df33	{"action":"login","actor_id":"89800f22-6220-467a-b58d-5f6f22db2647","actor_username":"22145290@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:41:19.363111+00	
00000000-0000-0000-0000-000000000000	7a569f3e-3198-4fd8-a220-94e6a9d1f769	{"action":"login","actor_id":"ab2f529a-dda7-4dad-8d6f-27572f4871c1","actor_username":"22145433@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:42:43.290418+00	
00000000-0000-0000-0000-000000000000	052fa0cc-1e72-443d-9d1e-28db6a9c2211	{"action":"login","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 04:43:51.856997+00	
00000000-0000-0000-0000-000000000000	65e815b6-65ea-4f0b-bfa3-b1f747a39ca1	{"action":"login","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 05:27:10.121421+00	
00000000-0000-0000-0000-000000000000	7cbd1129-141c-4b5a-ac97-1ac516b83005	{"action":"login","actor_id":"6477eb40-4562-4138-97e1-56d9cea1bd3d","actor_username":"3122560072@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 05:27:20.176362+00	
00000000-0000-0000-0000-000000000000	f90aff49-3658-43a0-814b-42df61ba526c	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"3122560073@gmail.com","user_id":"7a9ab239-22d2-4094-9d44-67239a322094","user_phone":""}}	2025-09-13 05:30:37.548577+00	
00000000-0000-0000-0000-000000000000	e49fbb85-cf14-47a2-a9d2-89c2d353b385	{"action":"login","actor_id":"7a9ab239-22d2-4094-9d44-67239a322094","actor_username":"3122560073@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 05:30:50.429274+00	
00000000-0000-0000-0000-000000000000	9c3801be-5286-4d6a-81d3-698a038e7c48	{"action":"logout","actor_id":"7a9ab239-22d2-4094-9d44-67239a322094","actor_username":"3122560073@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-13 05:31:01.402571+00	
00000000-0000-0000-0000-000000000000	7ffd5d98-d591-4d09-9caa-c5fa5db4950b	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"gv007@gmail.com","user_id":"acc521ce-1c0e-4911-8ff2-c168f6a7100f","user_phone":""}}	2025-09-13 05:31:20.676725+00	
00000000-0000-0000-0000-000000000000	b05f3036-65ac-4a59-9e50-fd343609bfa1	{"action":"login","actor_id":"acc521ce-1c0e-4911-8ff2-c168f6a7100f","actor_username":"gv007@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 05:31:31.867879+00	
00000000-0000-0000-0000-000000000000	58772fd4-f776-4aff-88dc-e42941dd4714	{"action":"token_refreshed","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-13 05:37:23.972416+00	
00000000-0000-0000-0000-000000000000	0162d10d-00c5-4cd9-9b7c-69984804abc4	{"action":"token_revoked","actor_id":"e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0","actor_username":"gv001@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-13 05:37:23.978918+00	
00000000-0000-0000-0000-000000000000	ded7e201-260d-4d93-86b1-86601db87e8e	{"action":"login","actor_id":"acc521ce-1c0e-4911-8ff2-c168f6a7100f","actor_username":"gv007@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-13 05:37:30.727808+00	
00000000-0000-0000-0000-000000000000	10c7808f-1e46-4c60-abbf-6725c8d59b09	{"action":"token_refreshed","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-13 05:42:25.240774+00	
00000000-0000-0000-0000-000000000000	a4d77616-7dcd-4523-835f-5eff2c6defcd	{"action":"token_revoked","actor_id":"a0740794-4a85-4037-9340-89567cd20f04","actor_username":"gv0000@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-09-13 05:42:25.242262+00	
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
dc743d86-49ee-43d6-a8c7-eb7a8b032a93	dc743d86-49ee-43d6-a8c7-eb7a8b032a93	{"sub": "dc743d86-49ee-43d6-a8c7-eb7a8b032a93", "role": "student", "email": "3122560572@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-02-21 05:32:45.746919+00	2025-02-21 05:32:45.746963+00	2025-02-21 05:32:45.746963+00	d90ccfe3-7a7f-480a-be0b-5ef711cee2b0
0af601e2-d596-49c7-9b53-12d86ecb6d12	0af601e2-d596-49c7-9b53-12d86ecb6d12	{"sub": "0af601e2-d596-49c7-9b53-12d86ecb6d12", "role": "student", "email": "3122569072@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-02-21 05:34:02.943707+00	2025-02-21 05:34:02.943754+00	2025-02-21 05:34:02.943754+00	e5116011-009b-48e2-8407-be9e01bff46e
620de24c-a40a-432a-be36-86852092f3c1	620de24c-a40a-432a-be36-86852092f3c1	{"sub": "620de24c-a40a-432a-be36-86852092f3c1", "role": "student", "email": "3122569172@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-02-21 05:37:07.004143+00	2025-02-21 05:37:07.004196+00	2025-02-21 05:37:07.004196+00	7e2ba1f7-86d3-4d02-93bc-abaecec56dbb
6477eb40-4562-4138-97e1-56d9cea1bd3d	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"sub": "6477eb40-4562-4138-97e1-56d9cea1bd3d", "role": "student", "email": "3122560072@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-02-21 05:51:03.418551+00	2025-02-21 05:51:03.418597+00	2025-02-21 05:51:03.418597+00	8f1beaa2-783f-4d8c-99d4-d169a79bd0a4
e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{"sub": "e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0", "role": "teacher", "email": "gv001@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-02-21 05:51:53.360666+00	2025-02-21 05:51:53.360711+00	2025-02-21 05:51:53.360711+00	707511ab-cd93-415c-b5b5-17e504544973
557d4ebc-ccbf-4402-ae59-4dd4b357e97c	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	{"sub": "557d4ebc-ccbf-4402-ae59-4dd4b357e97c", "role": "teacher", "email": "3122410471@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-02-21 08:15:30.21908+00	2025-02-21 08:15:30.21914+00	2025-02-21 08:15:30.21914+00	02dcc65c-7095-4ffd-9dcd-4fc44c9ecfd5
e368b85d-7038-4211-be16-c959c7931de0	e368b85d-7038-4211-be16-c959c7931de0	{"sub": "e368b85d-7038-4211-be16-c959c7931de0", "role": "student", "email": "3122410449@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-02-21 10:17:00.935308+00	2025-02-21 10:17:00.935356+00	2025-02-21 10:17:00.935356+00	7db338e8-316e-4d35-b625-29df2ae3b185
2956b155-1d48-4058-acdb-c1151fa5c9fd	2956b155-1d48-4058-acdb-c1151fa5c9fd	{"sub": "2956b155-1d48-4058-acdb-c1151fa5c9fd", "role": "teacher", "email": "gv002@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-02-21 10:44:50.445092+00	2025-02-21 10:44:50.445142+00	2025-02-21 10:44:50.445142+00	5d562c16-383e-450e-b27e-9a532e3cca99
8c75fb07-ba4b-4df0-badd-6f7b8a3a8361	8c75fb07-ba4b-4df0-badd-6f7b8a3a8361	{"sub": "8c75fb07-ba4b-4df0-badd-6f7b8a3a8361", "role": "teacher", "email": "gv003@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-06-13 04:34:52.280659+00	2025-06-13 04:34:52.280717+00	2025-06-13 04:34:52.280717+00	0899e280-ed26-46c3-aecb-2986c700bbd5
2a29ff32-0dbd-4f3f-ba8d-f7c868e36744	2a29ff32-0dbd-4f3f-ba8d-f7c868e36744	{"sub": "2a29ff32-0dbd-4f3f-ba8d-f7c868e36744", "role": "teacher", "email": "gv000@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-06-19 06:31:16.366328+00	2025-06-19 06:31:16.366382+00	2025-06-19 06:31:16.366382+00	a7571502-b7d2-4e5b-912c-e8e57779a23e
d12c4359-e2b0-4165-959d-aec89b853e1a	d12c4359-e2b0-4165-959d-aec89b853e1a	{"sub": "d12c4359-e2b0-4165-959d-aec89b853e1a", "role": "student", "email": "sv123456@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-06-19 06:32:42.844872+00	2025-06-19 06:32:42.844925+00	2025-06-19 06:32:42.844925+00	2991caac-af27-427f-a1fd-2b79b6fede43
3b4201ff-ee15-44ec-9954-633782fcd401	3b4201ff-ee15-44ec-9954-633782fcd401	{"sub": "3b4201ff-ee15-44ec-9954-633782fcd401", "role": "student", "email": "sv123@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-06-19 06:33:48.346637+00	2025-06-19 06:33:48.346684+00	2025-06-19 06:33:48.346684+00	34b4c9bd-a3eb-423d-bb6a-22e9f8d2416f
89fd994d-0d19-4920-ad87-027b3757ac03	89fd994d-0d19-4920-ad87-027b3757ac03	{"sub": "89fd994d-0d19-4920-ad87-027b3757ac03", "role": "student", "email": "ngominhphat@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-06-19 06:34:15.450797+00	2025-06-19 06:34:15.450842+00	2025-06-19 06:34:15.450842+00	5f8d89c7-cf6c-4bc6-aa7e-9d15fba4625c
3ada3240-643f-4735-b17d-39fc4ec262a2	3ada3240-643f-4735-b17d-39fc4ec262a2	{"sub": "3ada3240-643f-4735-b17d-39fc4ec262a2", "role": "student", "email": "123123@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-08-24 06:18:22.633679+00	2025-08-24 06:18:22.633742+00	2025-08-24 06:18:22.633742+00	e2a784a8-2c4e-445a-bebb-c0528b03f95b
a0740794-4a85-4037-9340-89567cd20f04	a0740794-4a85-4037-9340-89567cd20f04	{"sub": "a0740794-4a85-4037-9340-89567cd20f04", "role": "teacher", "email": "gv0000@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-08-24 06:19:32.389154+00	2025-08-24 06:19:32.389202+00	2025-08-24 06:19:32.389202+00	c3f40f2e-1a38-4637-8d47-fb1d393abb46
1d0458b8-1c9c-4120-8474-4b3467af2c53	1d0458b8-1c9c-4120-8474-4b3467af2c53	{"sub": "1d0458b8-1c9c-4120-8474-4b3467af2c53", "role": "student", "email": "sv0000@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:27:19.666405+00	2025-09-13 04:27:19.666458+00	2025-09-13 04:27:19.666458+00	ac7c4f5a-570a-4f4a-9dd5-2d72b7f3ca39
ab2f529a-dda7-4dad-8d6f-27572f4871c1	ab2f529a-dda7-4dad-8d6f-27572f4871c1	{"sub": "ab2f529a-dda7-4dad-8d6f-27572f4871c1", "role": "student", "email": "22145433@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:29:40.402184+00	2025-09-13 04:29:40.402229+00	2025-09-13 04:29:40.402229+00	ca486a16-a89b-4458-9b10-88e1022e67f9
cbe2858c-b62c-4e42-b212-5353934cc62f	cbe2858c-b62c-4e42-b212-5353934cc62f	{"sub": "cbe2858c-b62c-4e42-b212-5353934cc62f", "role": "student", "email": "22145097@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:33:10.999557+00	2025-09-13 04:33:10.999606+00	2025-09-13 04:33:10.999606+00	5d8fa7b9-d3c7-429a-9645-a316b0f7ec02
695940da-8528-4f2a-a452-6cf9481ae155	695940da-8528-4f2a-a452-6cf9481ae155	{"sub": "695940da-8528-4f2a-a452-6cf9481ae155", "role": "student", "email": "22145105@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:34:49.572838+00	2025-09-13 04:34:49.572885+00	2025-09-13 04:34:49.572885+00	8d5e32ba-a9da-4398-87c4-38335d559dde
6f5dacff-4e81-4e42-83e2-1a7cd07bd690	6f5dacff-4e81-4e42-83e2-1a7cd07bd690	{"sub": "6f5dacff-4e81-4e42-83e2-1a7cd07bd690", "role": "student", "email": "19145225@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:35:02.12678+00	2025-09-13 04:35:02.126832+00	2025-09-13 04:35:02.126832+00	398b9871-753b-4760-bfdc-66d3c1970fbd
641a180f-65a1-45b4-a648-a2df8482e0f4	641a180f-65a1-45b4-a648-a2df8482e0f4	{"sub": "641a180f-65a1-45b4-a648-a2df8482e0f4", "role": "student", "email": "20145112@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:35:21.014167+00	2025-09-13 04:35:21.014213+00	2025-09-13 04:35:21.014213+00	dae1ad50-4b55-4c03-9178-5c5bab0444ca
2ae0b466-781d-4e52-836e-6511c8155742	2ae0b466-781d-4e52-836e-6511c8155742	{"sub": "2ae0b466-781d-4e52-836e-6511c8155742", "role": "student", "email": "22145206@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:35:40.063365+00	2025-09-13 04:35:40.063407+00	2025-09-13 04:35:40.063407+00	668bfe02-9112-4e79-beb7-30eb88d417ed
3210fe05-0793-44df-bb7e-a5cb93566759	3210fe05-0793-44df-bb7e-a5cb93566759	{"sub": "3210fe05-0793-44df-bb7e-a5cb93566759", "role": "student", "email": "22145207@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:36:00.016971+00	2025-09-13 04:36:00.017016+00	2025-09-13 04:36:00.017016+00	c0952e5f-e672-46f0-8498-8dae0a79ddb6
bf88a0b8-25bf-4743-bf2e-e06ef356a633	bf88a0b8-25bf-4743-bf2e-e06ef356a633	{"sub": "bf88a0b8-25bf-4743-bf2e-e06ef356a633", "role": "student", "email": "22145210@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:36:17.276303+00	2025-09-13 04:36:17.276352+00	2025-09-13 04:36:17.276352+00	97a49c93-7a0d-410a-a417-a813b154d537
09d98c9d-a1a7-4b65-9d6c-ae4e293dbead	09d98c9d-a1a7-4b65-9d6c-ae4e293dbead	{"sub": "09d98c9d-a1a7-4b65-9d6c-ae4e293dbead", "role": "student", "email": "22145211@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:36:33.620706+00	2025-09-13 04:36:33.620752+00	2025-09-13 04:36:33.620752+00	b3a869e3-7aa3-49eb-bc00-49f923ce9c50
a675dd83-18f6-41c2-ba55-92cd88e14541	a675dd83-18f6-41c2-ba55-92cd88e14541	{"sub": "a675dd83-18f6-41c2-ba55-92cd88e14541", "role": "student", "email": "22145212@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:36:45.136922+00	2025-09-13 04:36:45.13697+00	2025-09-13 04:36:45.13697+00	e3416101-15ae-4d48-bf99-a327736d2c89
ed0914b9-f329-4286-b1b9-3cb2a39ff750	ed0914b9-f329-4286-b1b9-3cb2a39ff750	{"sub": "ed0914b9-f329-4286-b1b9-3cb2a39ff750", "role": "student", "email": "22145213@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:37:54.667965+00	2025-09-13 04:37:54.668014+00	2025-09-13 04:37:54.668014+00	7bcfcc88-e55c-435f-bdbd-dfc52f49f37e
19fd552e-1b8d-4eba-9fd7-7621451f6272	19fd552e-1b8d-4eba-9fd7-7621451f6272	{"sub": "19fd552e-1b8d-4eba-9fd7-7621451f6272", "role": "student", "email": "22145215@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:38:38.695116+00	2025-09-13 04:38:38.695159+00	2025-09-13 04:38:38.695159+00	13f9845d-547e-47bd-b303-1dc5398b6639
c608c9e1-9cc8-47c4-a71b-28fe5bcf1635	c608c9e1-9cc8-47c4-a71b-28fe5bcf1635	{"sub": "c608c9e1-9cc8-47c4-a71b-28fe5bcf1635", "role": "student", "email": "22145216@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:38:51.380035+00	2025-09-13 04:38:51.380082+00	2025-09-13 04:38:51.380082+00	6eb86470-bf1e-4a34-9626-245595291d4f
91d20798-accf-4fe7-b038-b9af34a50aad	91d20798-accf-4fe7-b038-b9af34a50aad	{"sub": "91d20798-accf-4fe7-b038-b9af34a50aad", "role": "student", "email": "22145218@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:39:08.142929+00	2025-09-13 04:39:08.142974+00	2025-09-13 04:39:08.142974+00	30fd2642-386f-49e7-9ae9-b4e845ecea92
d677ddb9-7459-44f3-94f9-fcb42ae3cbf5	d677ddb9-7459-44f3-94f9-fcb42ae3cbf5	{"sub": "d677ddb9-7459-44f3-94f9-fcb42ae3cbf5", "role": "student", "email": "22145220@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:39:31.352089+00	2025-09-13 04:39:31.352135+00	2025-09-13 04:39:31.352135+00	e73bdee9-bd9b-4219-9647-ee7d4c5a3ec9
dfc3cb8c-7ab1-4891-b54d-e6101aeccf7a	dfc3cb8c-7ab1-4891-b54d-e6101aeccf7a	{"sub": "dfc3cb8c-7ab1-4891-b54d-e6101aeccf7a", "role": "student", "email": "22145226@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:39:43.751393+00	2025-09-13 04:39:43.751437+00	2025-09-13 04:39:43.751437+00	cb479069-f3f3-49e5-a51b-d270b50ffce8
c2d1083d-d480-40cc-947d-cad7294eedc2	c2d1083d-d480-40cc-947d-cad7294eedc2	{"sub": "c2d1083d-d480-40cc-947d-cad7294eedc2", "role": "student", "email": "22145228@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:39:57.999622+00	2025-09-13 04:39:57.999665+00	2025-09-13 04:39:57.999665+00	0fbabe80-5f15-46f3-aba3-7b27a25f87f9
1a921e78-7463-4404-b054-bf6302b40c11	1a921e78-7463-4404-b054-bf6302b40c11	{"sub": "1a921e78-7463-4404-b054-bf6302b40c11", "role": "student", "email": "22145230@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:40:51.834109+00	2025-09-13 04:40:51.834178+00	2025-09-13 04:40:51.834178+00	77316610-d447-4860-bcb7-fd1c8175efc2
697fec7b-74d6-4df7-b165-87d112eaf2fc	697fec7b-74d6-4df7-b165-87d112eaf2fc	{"sub": "697fec7b-74d6-4df7-b165-87d112eaf2fc", "role": "student", "email": "22145280@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:41:06.787447+00	2025-09-13 04:41:06.787493+00	2025-09-13 04:41:06.787493+00	941bc4cc-3699-4be9-aa3f-845241065650
89800f22-6220-467a-b58d-5f6f22db2647	89800f22-6220-467a-b58d-5f6f22db2647	{"sub": "89800f22-6220-467a-b58d-5f6f22db2647", "role": "student", "email": "22145290@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 04:41:19.330407+00	2025-09-13 04:41:19.330455+00	2025-09-13 04:41:19.330455+00	d37fe24a-d8be-417c-89c6-a50bdda5ce64
7a9ab239-22d2-4094-9d44-67239a322094	7a9ab239-22d2-4094-9d44-67239a322094	{"sub": "7a9ab239-22d2-4094-9d44-67239a322094", "email": "3122560073@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 05:30:37.542763+00	2025-09-13 05:30:37.542842+00	2025-09-13 05:30:37.542842+00	b4c817ca-83b2-4d28-8a5a-e350a323289c
acc521ce-1c0e-4911-8ff2-c168f6a7100f	acc521ce-1c0e-4911-8ff2-c168f6a7100f	{"sub": "acc521ce-1c0e-4911-8ff2-c168f6a7100f", "email": "gv007@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-13 05:31:20.675889+00	2025-09-13 05:31:20.675942+00	2025-09-13 05:31:20.675942+00	9facc81e-5e9d-4fc3-be84-491a95995c8b
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
9dfeb7a8-e6fe-4cc3-b745-40ce979507da	2025-02-21 10:44:50.455318+00	2025-02-21 10:44:50.455318+00	password	db3df238-fa5f-4866-8fff-b0c815d6e7eb
e2a38421-eb86-4044-8d69-847a586ca278	2025-02-21 10:45:04.108237+00	2025-02-21 10:45:04.108237+00	password	c282254d-851b-4da0-bb97-4117f7eb8bf6
87e1d4e1-a14a-4ac1-aa49-e76b2ccbd51a	2025-02-27 02:10:32.630474+00	2025-02-27 02:10:32.630474+00	password	60c9f4ca-934c-4bbb-9f73-97d0f5734942
1c156039-eae6-407e-a73e-071967d01ca4	2025-03-14 10:04:59.721536+00	2025-03-14 10:04:59.721536+00	password	258e6704-2bb4-4e4b-b9cb-6bf6872022d9
4f357219-b631-4e2b-8ac0-550c6a92f189	2025-02-21 05:32:45.756468+00	2025-02-21 05:32:45.756468+00	password	d8bce818-321c-4ef5-a143-7e89f42f6ced
04f08f9a-ece0-4c06-822b-35535d3d6fee	2025-02-21 05:34:02.95416+00	2025-02-21 05:34:02.95416+00	password	53514688-70d5-431b-80e3-0bd2b0563c61
dcfc3142-0057-41a3-a04c-616bdb1631f7	2025-06-19 06:31:16.382683+00	2025-06-19 06:31:16.382683+00	password	9d68ca31-2042-4449-a0ac-2076a38a43eb
d38e3b28-91bb-42eb-ad64-ca2c777fc36b	2025-06-19 06:32:42.854866+00	2025-06-19 06:32:42.854866+00	password	208f4112-fcaa-41ea-afc2-3eb8290949a6
8d8a0ca0-3d73-4392-ba4f-d5afa4c7a019	2025-06-19 06:33:48.355271+00	2025-06-19 06:33:48.355271+00	password	b9ea271c-bbf7-4db6-af10-d490049e64f0
a531d88f-d111-4fb4-b70e-645f13921136	2025-06-19 06:34:15.458681+00	2025-06-19 06:34:15.458681+00	password	609998ef-399b-452c-801c-c4f4525df12d
4564e55f-7694-4b15-85be-828b6c006506	2025-08-24 06:59:55.335757+00	2025-08-24 06:59:55.335757+00	password	9145c600-f8eb-4e7f-9614-f8ec12e509b3
bfd130de-2182-46de-9ae0-d4febf3ea99c	2025-09-13 03:47:05.404584+00	2025-09-13 03:47:05.404584+00	password	b08bdb4f-9ff7-41e3-9189-6fa01d0d3884
aa9c8ce9-0129-415f-b007-62a1e778402a	2025-09-13 03:47:16.703283+00	2025-09-13 03:47:16.703283+00	password	c303ae16-fc40-4bcf-b08b-f3f0c2c10317
cb877a7e-9731-48f3-bbe1-382679f5dcd7	2025-09-13 04:04:50.954089+00	2025-09-13 04:04:50.954089+00	password	7e9f52ab-5617-4c73-8746-da9710a88297
875f99ae-7cc5-497c-a38a-74bb0730d3be	2025-09-13 04:05:00.104298+00	2025-09-13 04:05:00.104298+00	password	c57c499a-59ca-4f1e-a0d9-99651c048b27
27a5d6b0-8069-45c2-8924-e706ce05c62f	2025-09-13 04:26:41.373779+00	2025-09-13 04:26:41.373779+00	password	ae23ae8a-a250-4fde-8662-5a6cc66dd944
87ae1a68-72de-4cbb-b1e1-87b6873f65a4	2025-09-13 04:27:19.686168+00	2025-09-13 04:27:19.686168+00	password	42d0f63d-61d1-4d42-ba75-9dc1bd1925a7
476043b6-d59e-4927-8197-8fadc6bf85aa	2025-09-13 04:27:35.198041+00	2025-09-13 04:27:35.198041+00	password	119220be-fedb-49bc-b831-a9d0dd4a4d40
8fa09bfa-598e-4a71-84e0-8fff69658907	2025-09-13 04:29:40.418254+00	2025-09-13 04:29:40.418254+00	password	17778456-c945-4746-b7b7-173a11cb4718
5409e0e5-4d37-4f83-b3b9-bf4f3afcecf0	2025-09-13 04:29:54.959953+00	2025-09-13 04:29:54.959953+00	password	e520a09d-fde0-4439-8694-21f19a2a486a
4ff14f7f-ac56-44d7-bffa-ab821146449e	2025-09-13 04:33:11.01296+00	2025-09-13 04:33:11.01296+00	password	3691e4f6-6f6d-4584-9395-9cc5178b833e
9ea88bda-b54d-4d4f-b990-94bdd85874bb	2025-09-13 04:33:34.376708+00	2025-09-13 04:33:34.376708+00	password	fa683d8f-2781-42a4-8b01-56ce287b9eed
7c64bab5-8ca8-48b9-aad8-150ada4c9fcd	2025-09-13 04:34:49.605942+00	2025-09-13 04:34:49.605942+00	password	a22c69f2-dff2-47b4-8d05-9a2b04ced7ee
dc0d80db-9956-44b0-b6a4-fa25d47b70a6	2025-09-13 04:35:02.139603+00	2025-09-13 04:35:02.139603+00	password	054849d0-ebba-4f6c-b6b0-84de4d6c733f
199f5a24-e80d-43b1-ad58-da90cc7c8c9f	2025-09-13 04:35:21.026071+00	2025-09-13 04:35:21.026071+00	password	e7e1bc05-ae25-4398-8c59-8a27260063f3
7aa4b4fd-efe0-40d1-a204-11e387beb605	2025-09-13 04:35:40.074934+00	2025-09-13 04:35:40.074934+00	password	882fef74-2072-4740-9ea3-315615813807
8561b298-63d2-43bc-9dd3-2ff4a9572c6f	2025-09-13 04:36:00.027717+00	2025-09-13 04:36:00.027717+00	password	08d80486-6128-4e50-a041-6da62a47d5e7
321bfb15-d447-463f-be0e-779fe9e22210	2025-09-13 04:36:17.28472+00	2025-09-13 04:36:17.28472+00	password	a6f849a3-66a6-4d3e-b395-c35ec2b6c8bb
01b61702-0d39-4188-899d-727794792a97	2025-09-13 04:36:33.627567+00	2025-09-13 04:36:33.627567+00	password	0f0bad5d-05e9-4bd5-b954-74522dbb43b8
cac60e15-f295-4c83-bbd7-d6a4338fcaf8	2025-09-13 04:37:29.101742+00	2025-09-13 04:37:29.101742+00	password	dd90c993-a285-42ad-8d0e-315e0090afa7
0bbb5b12-fb3b-44b5-9493-d4813dbc1eb5	2025-09-13 04:38:17.541016+00	2025-09-13 04:38:17.541016+00	password	2c01d5d9-482b-405c-aa0a-7d8033621f30
136fe919-fd56-46c1-a893-c9f2b904b744	2025-09-13 04:38:38.70494+00	2025-09-13 04:38:38.70494+00	password	a632ae27-2169-4e92-9a71-f87548f64e86
5fb939fb-46dc-4dd7-8aac-c939fbe4c090	2025-09-13 04:38:51.386639+00	2025-09-13 04:38:51.386639+00	password	35093ff3-2076-4158-a67a-98e97d5b413c
8a0a901e-8bd1-4e02-9e8d-215d22bc9253	2025-09-13 04:39:08.151334+00	2025-09-13 04:39:08.151334+00	password	0424566e-bb5a-41b4-a183-20c80377eda6
90d934dc-1f5f-4c48-a66f-ebdd0202a887	2025-09-13 04:39:31.359974+00	2025-09-13 04:39:31.359974+00	password	ae23ec0d-38d8-4d84-ae55-4e3f87a5ec71
06f001f2-0877-40ee-82a3-6325925586c6	2025-09-13 04:39:43.76526+00	2025-09-13 04:39:43.76526+00	password	d423383a-90fe-40f4-a050-f3f021e91541
5cf295bf-7cfb-404e-bff3-293df3965896	2025-09-13 04:40:20.75505+00	2025-09-13 04:40:20.75505+00	password	a78c62f6-00e2-446f-a893-6b41ee1b6442
a58e64ec-ca30-4720-bf6f-209fd4d77e90	2025-09-13 04:40:51.8978+00	2025-09-13 04:40:51.8978+00	password	09b02bca-6461-400a-9086-0dccebc2cc39
b2513c94-92db-4c5b-a034-7084ca4d3170	2025-09-13 04:41:06.800325+00	2025-09-13 04:41:06.800325+00	password	419734eb-77c9-491f-b004-76affaca60d1
69d93bf3-1e59-4ea9-95ad-6e45f5ba7142	2025-09-13 04:41:19.365488+00	2025-09-13 04:41:19.365488+00	password	cad843b6-295e-4592-98c8-87f23135bd13
251fcfbd-690c-4310-8e36-5dba562949df	2025-09-13 04:42:43.296118+00	2025-09-13 04:42:43.296118+00	password	ebed510b-2122-4d09-af31-1edb1c542a1b
2f2f4915-5059-46eb-bc57-1bbdd8237093	2025-09-13 04:43:51.860824+00	2025-09-13 04:43:51.860824+00	password	3ce57bb6-6c60-4484-9d4f-8f8bd116074b
42a3adeb-9425-4d90-b28c-478b2a494b70	2025-09-13 05:27:10.196182+00	2025-09-13 05:27:10.196182+00	password	b2ae3c36-db92-4be4-9c29-837f3587104e
96d2b8e9-0239-453e-80bf-963737efef85	2025-09-13 05:27:20.185272+00	2025-09-13 05:27:20.185272+00	password	f4c22e76-65ed-46c8-ba7b-c22592b8f98d
2f43df4b-32d9-4887-95e7-bd164c66d264	2025-09-13 05:31:31.873228+00	2025-09-13 05:31:31.873228+00	password	5ed37a68-26e9-4324-aaf4-29bf12b97a52
77b27248-4822-4835-9c28-263d1b5260f3	2025-09-13 05:37:30.732435+00	2025-09-13 05:37:30.732435+00	password	4e032bac-e496-41db-88a4-46a46a76564c
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	66	auUo3-_cyGLyDtivHJLqRw	2956b155-1d48-4058-acdb-c1151fa5c9fd	f	2025-02-21 10:44:50.453621+00	2025-02-21 10:44:50.453621+00	\N	9dfeb7a8-e6fe-4cc3-b745-40ce979507da
00000000-0000-0000-0000-000000000000	67	rCRYJV3h4kb6-KszSYlocA	2956b155-1d48-4058-acdb-c1151fa5c9fd	f	2025-02-21 10:45:04.10713+00	2025-02-21 10:45:04.10713+00	\N	e2a38421-eb86-4044-8d69-847a586ca278
00000000-0000-0000-0000-000000000000	252	fzas9ffSE0GzsAbYnfCb1A	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	t	2025-03-14 10:04:59.714653+00	2025-03-23 08:23:48.230003+00	\N	1c156039-eae6-407e-a73e-071967d01ca4
00000000-0000-0000-0000-000000000000	273	z0zTRW0JkRH2eBO0DlVhSQ	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	f	2025-03-23 08:23:48.244211+00	2025-03-23 08:23:48.244211+00	fzas9ffSE0GzsAbYnfCb1A	1c156039-eae6-407e-a73e-071967d01ca4
00000000-0000-0000-0000-000000000000	44	Oag97LI6nqXMECm8PP6qDQ	dc743d86-49ee-43d6-a8c7-eb7a8b032a93	f	2025-02-21 05:32:45.754755+00	2025-02-21 05:32:45.754755+00	\N	4f357219-b631-4e2b-8ac0-550c6a92f189
00000000-0000-0000-0000-000000000000	45	JNs5EHzrajVQCVCnobUwCQ	0af601e2-d596-49c7-9b53-12d86ecb6d12	f	2025-02-21 05:34:02.952481+00	2025-02-21 05:34:02.952481+00	\N	04f08f9a-ece0-4c06-822b-35535d3d6fee
00000000-0000-0000-0000-000000000000	167	Jdb1aolYxXIFbp7q875Zow	620de24c-a40a-432a-be36-86852092f3c1	f	2025-02-27 02:10:32.624477+00	2025-02-27 02:10:32.624477+00	\N	87e1d4e1-a14a-4ac1-aa49-e76b2ccbd51a
00000000-0000-0000-0000-000000000000	451	e2htxwxn2wrn	e368b85d-7038-4211-be16-c959c7931de0	f	2025-09-13 03:47:05.392167+00	2025-09-13 03:47:05.392167+00	\N	bfd130de-2182-46de-9ae0-d4febf3ea99c
00000000-0000-0000-0000-000000000000	452	lcqxrfljjew2	e368b85d-7038-4211-be16-c959c7931de0	f	2025-09-13 03:47:16.702075+00	2025-09-13 03:47:16.702075+00	\N	aa9c8ce9-0129-415f-b007-62a1e778402a
00000000-0000-0000-0000-000000000000	455	nd3gxbrtc25z	e368b85d-7038-4211-be16-c959c7931de0	f	2025-09-13 04:04:50.9444+00	2025-09-13 04:04:50.9444+00	\N	cb877a7e-9731-48f3-bbe1-382679f5dcd7
00000000-0000-0000-0000-000000000000	456	xtvsxltxd4re	e368b85d-7038-4211-be16-c959c7931de0	f	2025-09-13 04:05:00.101012+00	2025-09-13 04:05:00.101012+00	\N	875f99ae-7cc5-497c-a38a-74bb0730d3be
00000000-0000-0000-0000-000000000000	458	qy6ztd2wnckh	e368b85d-7038-4211-be16-c959c7931de0	f	2025-09-13 04:26:41.371494+00	2025-09-13 04:26:41.371494+00	\N	27a5d6b0-8069-45c2-8924-e706ce05c62f
00000000-0000-0000-0000-000000000000	459	jbxpuyrgvl66	1d0458b8-1c9c-4120-8474-4b3467af2c53	f	2025-09-13 04:27:19.683102+00	2025-09-13 04:27:19.683102+00	\N	87ae1a68-72de-4cbb-b1e1-87b6873f65a4
00000000-0000-0000-0000-000000000000	460	s2myin3jutpx	1d0458b8-1c9c-4120-8474-4b3467af2c53	f	2025-09-13 04:27:35.19688+00	2025-09-13 04:27:35.19688+00	\N	476043b6-d59e-4927-8197-8fadc6bf85aa
00000000-0000-0000-0000-000000000000	461	lmlq6y6us4vb	ab2f529a-dda7-4dad-8d6f-27572f4871c1	f	2025-09-13 04:29:40.414919+00	2025-09-13 04:29:40.414919+00	\N	8fa09bfa-598e-4a71-84e0-8fff69658907
00000000-0000-0000-0000-000000000000	462	lmlbdxruae2z	ab2f529a-dda7-4dad-8d6f-27572f4871c1	f	2025-09-13 04:29:54.958869+00	2025-09-13 04:29:54.958869+00	\N	5409e0e5-4d37-4f83-b3b9-bf4f3afcecf0
00000000-0000-0000-0000-000000000000	463	fxc4ip4wjeon	cbe2858c-b62c-4e42-b212-5353934cc62f	f	2025-09-13 04:33:11.009921+00	2025-09-13 04:33:11.009921+00	\N	4ff14f7f-ac56-44d7-bffa-ab821146449e
00000000-0000-0000-0000-000000000000	464	iutzjbs5m7fw	cbe2858c-b62c-4e42-b212-5353934cc62f	f	2025-09-13 04:33:34.374906+00	2025-09-13 04:33:34.374906+00	\N	9ea88bda-b54d-4d4f-b990-94bdd85874bb
00000000-0000-0000-0000-000000000000	465	wpyeasvkn4wv	695940da-8528-4f2a-a452-6cf9481ae155	f	2025-09-13 04:34:49.600039+00	2025-09-13 04:34:49.600039+00	\N	7c64bab5-8ca8-48b9-aad8-150ada4c9fcd
00000000-0000-0000-0000-000000000000	466	ot26lirek7fb	6f5dacff-4e81-4e42-83e2-1a7cd07bd690	f	2025-09-13 04:35:02.136991+00	2025-09-13 04:35:02.136991+00	\N	dc0d80db-9956-44b0-b6a4-fa25d47b70a6
00000000-0000-0000-0000-000000000000	467	7x6orte6ome6	641a180f-65a1-45b4-a648-a2df8482e0f4	f	2025-09-13 04:35:21.022499+00	2025-09-13 04:35:21.022499+00	\N	199f5a24-e80d-43b1-ad58-da90cc7c8c9f
00000000-0000-0000-0000-000000000000	468	7bbfwkdcvdrg	2ae0b466-781d-4e52-836e-6511c8155742	f	2025-09-13 04:35:40.073782+00	2025-09-13 04:35:40.073782+00	\N	7aa4b4fd-efe0-40d1-a204-11e387beb605
00000000-0000-0000-0000-000000000000	469	xz2g3lxhtteq	3210fe05-0793-44df-bb7e-a5cb93566759	f	2025-09-13 04:36:00.026549+00	2025-09-13 04:36:00.026549+00	\N	8561b298-63d2-43bc-9dd3-2ff4a9572c6f
00000000-0000-0000-0000-000000000000	470	apbnntdsmrcb	bf88a0b8-25bf-4743-bf2e-e06ef356a633	f	2025-09-13 04:36:17.282788+00	2025-09-13 04:36:17.282788+00	\N	321bfb15-d447-463f-be0e-779fe9e22210
00000000-0000-0000-0000-000000000000	471	w67or2zqnlp4	09d98c9d-a1a7-4b65-9d6c-ae4e293dbead	f	2025-09-13 04:36:33.626593+00	2025-09-13 04:36:33.626593+00	\N	01b61702-0d39-4188-899d-727794792a97
00000000-0000-0000-0000-000000000000	473	3vpoiqjdvuds	2ae0b466-781d-4e52-836e-6511c8155742	f	2025-09-13 04:37:29.100524+00	2025-09-13 04:37:29.100524+00	\N	cac60e15-f295-4c83-bbd7-d6a4338fcaf8
00000000-0000-0000-0000-000000000000	475	zwwv4vonhuxf	ed0914b9-f329-4286-b1b9-3cb2a39ff750	f	2025-09-13 04:38:17.539131+00	2025-09-13 04:38:17.539131+00	\N	0bbb5b12-fb3b-44b5-9493-d4813dbc1eb5
00000000-0000-0000-0000-000000000000	476	47tkv3f56hxs	19fd552e-1b8d-4eba-9fd7-7621451f6272	f	2025-09-13 04:38:38.703201+00	2025-09-13 04:38:38.703201+00	\N	136fe919-fd56-46c1-a893-c9f2b904b744
00000000-0000-0000-0000-000000000000	477	e36trsklqaab	c608c9e1-9cc8-47c4-a71b-28fe5bcf1635	f	2025-09-13 04:38:51.385638+00	2025-09-13 04:38:51.385638+00	\N	5fb939fb-46dc-4dd7-8aac-c939fbe4c090
00000000-0000-0000-0000-000000000000	478	nrqijfjc7zlq	91d20798-accf-4fe7-b038-b9af34a50aad	f	2025-09-13 04:39:08.150383+00	2025-09-13 04:39:08.150383+00	\N	8a0a901e-8bd1-4e02-9e8d-215d22bc9253
00000000-0000-0000-0000-000000000000	479	yxpggldwa3va	d677ddb9-7459-44f3-94f9-fcb42ae3cbf5	f	2025-09-13 04:39:31.358942+00	2025-09-13 04:39:31.358942+00	\N	90d934dc-1f5f-4c48-a66f-ebdd0202a887
00000000-0000-0000-0000-000000000000	381	rym6zbgx2kr5	2a29ff32-0dbd-4f3f-ba8d-f7c868e36744	f	2025-06-19 06:31:16.380901+00	2025-06-19 06:31:16.380901+00	\N	dcfc3142-0057-41a3-a04c-616bdb1631f7
00000000-0000-0000-0000-000000000000	480	exvrsnzwc5oi	dfc3cb8c-7ab1-4891-b54d-e6101aeccf7a	f	2025-09-13 04:39:43.763217+00	2025-09-13 04:39:43.763217+00	\N	06f001f2-0877-40ee-82a3-6325925586c6
00000000-0000-0000-0000-000000000000	383	wbqvswhelsut	d12c4359-e2b0-4165-959d-aec89b853e1a	f	2025-06-19 06:32:42.85364+00	2025-06-19 06:32:42.85364+00	\N	d38e3b28-91bb-42eb-ad64-ca2c777fc36b
00000000-0000-0000-0000-000000000000	384	2sbtkjbt4lcu	3b4201ff-ee15-44ec-9954-633782fcd401	f	2025-06-19 06:33:48.353631+00	2025-06-19 06:33:48.353631+00	\N	8d8a0ca0-3d73-4392-ba4f-d5afa4c7a019
00000000-0000-0000-0000-000000000000	385	l7wlrlwv2xuz	89fd994d-0d19-4920-ad87-027b3757ac03	f	2025-06-19 06:34:15.457439+00	2025-06-19 06:34:15.457439+00	\N	a531d88f-d111-4fb4-b70e-645f13921136
00000000-0000-0000-0000-000000000000	482	ch5vdap4wjhy	c2d1083d-d480-40cc-947d-cad7294eedc2	f	2025-09-13 04:40:20.753837+00	2025-09-13 04:40:20.753837+00	\N	5cf295bf-7cfb-404e-bff3-293df3965896
00000000-0000-0000-0000-000000000000	483	gpkgqlj5omm5	1a921e78-7463-4404-b054-bf6302b40c11	f	2025-09-13 04:40:51.88601+00	2025-09-13 04:40:51.88601+00	\N	a58e64ec-ca30-4720-bf6f-209fd4d77e90
00000000-0000-0000-0000-000000000000	484	a3lmu3fepcel	697fec7b-74d6-4df7-b165-87d112eaf2fc	f	2025-09-13 04:41:06.799294+00	2025-09-13 04:41:06.799294+00	\N	b2513c94-92db-4c5b-a034-7084ca4d3170
00000000-0000-0000-0000-000000000000	485	jdsuvjxfhz5m	89800f22-6220-467a-b58d-5f6f22db2647	f	2025-09-13 04:41:19.364357+00	2025-09-13 04:41:19.364357+00	\N	69d93bf3-1e59-4ea9-95ad-6e45f5ba7142
00000000-0000-0000-0000-000000000000	486	5ii7dss74xza	ab2f529a-dda7-4dad-8d6f-27572f4871c1	f	2025-09-13 04:42:43.293383+00	2025-09-13 04:42:43.293383+00	\N	251fcfbd-690c-4310-8e36-5dba562949df
00000000-0000-0000-0000-000000000000	449	aidr6nfcucud	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	t	2025-08-24 06:59:55.333445+00	2025-09-13 05:37:23.980754+00	\N	4564e55f-7694-4b15-85be-828b6c006506
00000000-0000-0000-0000-000000000000	488	5hc5xngibl7t	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	f	2025-09-13 05:27:10.158614+00	2025-09-13 05:27:10.158614+00	\N	42a3adeb-9425-4d90-b28c-478b2a494b70
00000000-0000-0000-0000-000000000000	489	gg3kpzmo34fp	6477eb40-4562-4138-97e1-56d9cea1bd3d	f	2025-09-13 05:27:20.180177+00	2025-09-13 05:27:20.180177+00	\N	96d2b8e9-0239-453e-80bf-963737efef85
00000000-0000-0000-0000-000000000000	491	zywjvvket2cm	acc521ce-1c0e-4911-8ff2-c168f6a7100f	f	2025-09-13 05:31:31.87076+00	2025-09-13 05:31:31.87076+00	\N	2f43df4b-32d9-4887-95e7-bd164c66d264
00000000-0000-0000-0000-000000000000	492	fw3y437v73tg	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	f	2025-09-13 05:37:23.985627+00	2025-09-13 05:37:23.985627+00	aidr6nfcucud	4564e55f-7694-4b15-85be-828b6c006506
00000000-0000-0000-0000-000000000000	493	26kygfffxlzi	acc521ce-1c0e-4911-8ff2-c168f6a7100f	f	2025-09-13 05:37:30.730605+00	2025-09-13 05:37:30.730605+00	\N	77b27248-4822-4835-9c28-263d1b5260f3
00000000-0000-0000-0000-000000000000	487	c5mb47ygstht	a0740794-4a85-4037-9340-89567cd20f04	t	2025-09-13 04:43:51.858595+00	2025-09-13 05:42:25.243907+00	\N	2f2f4915-5059-46eb-bc57-1bbdd8237093
00000000-0000-0000-0000-000000000000	494	g7mkn4kiayji	a0740794-4a85-4037-9340-89567cd20f04	f	2025-09-13 05:42:25.245759+00	2025-09-13 05:42:25.245759+00	c5mb47ygstht	2f2f4915-5059-46eb-bc57-1bbdd8237093
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag) FROM stdin;
9dfeb7a8-e6fe-4cc3-b745-40ce979507da	2956b155-1d48-4058-acdb-c1151fa5c9fd	2025-02-21 10:44:50.451965+00	2025-02-21 10:44:50.451965+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36 Edg/133.0.0.0	42.119.229.184	\N
e2a38421-eb86-4044-8d69-847a586ca278	2956b155-1d48-4058-acdb-c1151fa5c9fd	2025-02-21 10:45:04.106432+00	2025-02-21 10:45:04.106432+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36 Edg/133.0.0.0	42.119.229.184	\N
4f357219-b631-4e2b-8ac0-550c6a92f189	dc743d86-49ee-43d6-a8c7-eb7a8b032a93	2025-02-21 05:32:45.753778+00	2025-02-21 05:32:45.753778+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	171.252.154.193	\N
04f08f9a-ece0-4c06-822b-35535d3d6fee	0af601e2-d596-49c7-9b53-12d86ecb6d12	2025-02-21 05:34:02.951482+00	2025-02-21 05:34:02.951482+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	171.252.154.193	\N
87e1d4e1-a14a-4ac1-aa49-e76b2ccbd51a	620de24c-a40a-432a-be36-86852092f3c1	2025-02-27 02:10:32.620458+00	2025-02-27 02:10:32.620458+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	113.161.85.113	\N
1c156039-eae6-407e-a73e-071967d01ca4	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	2025-03-14 10:04:59.712177+00	2025-03-23 08:23:48.263525+00	\N	aal1	\N	2025-03-23 08:23:48.25995	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36	27.74.122.20	\N
dcfc3142-0057-41a3-a04c-616bdb1631f7	2a29ff32-0dbd-4f3f-ba8d-f7c868e36744	2025-06-19 06:31:16.37986+00	2025-06-19 06:31:16.37986+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	118.70.192.159	\N
d38e3b28-91bb-42eb-ad64-ca2c777fc36b	d12c4359-e2b0-4165-959d-aec89b853e1a	2025-06-19 06:32:42.853009+00	2025-06-19 06:32:42.853009+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	118.70.192.159	\N
8d8a0ca0-3d73-4392-ba4f-d5afa4c7a019	3b4201ff-ee15-44ec-9954-633782fcd401	2025-06-19 06:33:48.352956+00	2025-06-19 06:33:48.352956+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	118.70.192.159	\N
a531d88f-d111-4fb4-b70e-645f13921136	89fd994d-0d19-4920-ad87-027b3757ac03	2025-06-19 06:34:15.456222+00	2025-06-19 06:34:15.456222+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	118.70.192.159	\N
bfd130de-2182-46de-9ae0-d4febf3ea99c	e368b85d-7038-4211-be16-c959c7931de0	2025-09-13 03:47:05.387592+00	2025-09-13 03:47:05.387592+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
aa9c8ce9-0129-415f-b007-62a1e778402a	e368b85d-7038-4211-be16-c959c7931de0	2025-09-13 03:47:16.701354+00	2025-09-13 03:47:16.701354+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
cb877a7e-9731-48f3-bbe1-382679f5dcd7	e368b85d-7038-4211-be16-c959c7931de0	2025-09-13 04:04:50.940065+00	2025-09-13 04:04:50.940065+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
875f99ae-7cc5-497c-a38a-74bb0730d3be	e368b85d-7038-4211-be16-c959c7931de0	2025-09-13 04:05:00.097394+00	2025-09-13 04:05:00.097394+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
27a5d6b0-8069-45c2-8924-e706ce05c62f	e368b85d-7038-4211-be16-c959c7931de0	2025-09-13 04:26:41.370088+00	2025-09-13 04:26:41.370088+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
87ae1a68-72de-4cbb-b1e1-87b6873f65a4	1d0458b8-1c9c-4120-8474-4b3467af2c53	2025-09-13 04:27:19.681752+00	2025-09-13 04:27:19.681752+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
476043b6-d59e-4927-8197-8fadc6bf85aa	1d0458b8-1c9c-4120-8474-4b3467af2c53	2025-09-13 04:27:35.196133+00	2025-09-13 04:27:35.196133+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
8fa09bfa-598e-4a71-84e0-8fff69658907	ab2f529a-dda7-4dad-8d6f-27572f4871c1	2025-09-13 04:29:40.412928+00	2025-09-13 04:29:40.412928+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
5409e0e5-4d37-4f83-b3b9-bf4f3afcecf0	ab2f529a-dda7-4dad-8d6f-27572f4871c1	2025-09-13 04:29:54.95817+00	2025-09-13 04:29:54.95817+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
4ff14f7f-ac56-44d7-bffa-ab821146449e	cbe2858c-b62c-4e42-b212-5353934cc62f	2025-09-13 04:33:11.008832+00	2025-09-13 04:33:11.008832+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
9ea88bda-b54d-4d4f-b990-94bdd85874bb	cbe2858c-b62c-4e42-b212-5353934cc62f	2025-09-13 04:33:34.374229+00	2025-09-13 04:33:34.374229+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
7c64bab5-8ca8-48b9-aad8-150ada4c9fcd	695940da-8528-4f2a-a452-6cf9481ae155	2025-09-13 04:34:49.593667+00	2025-09-13 04:34:49.593667+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
dc0d80db-9956-44b0-b6a4-fa25d47b70a6	6f5dacff-4e81-4e42-83e2-1a7cd07bd690	2025-09-13 04:35:02.136221+00	2025-09-13 04:35:02.136221+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
199f5a24-e80d-43b1-ad58-da90cc7c8c9f	641a180f-65a1-45b4-a648-a2df8482e0f4	2025-09-13 04:35:21.020977+00	2025-09-13 04:35:21.020977+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
7aa4b4fd-efe0-40d1-a204-11e387beb605	2ae0b466-781d-4e52-836e-6511c8155742	2025-09-13 04:35:40.073035+00	2025-09-13 04:35:40.073035+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
8561b298-63d2-43bc-9dd3-2ff4a9572c6f	3210fe05-0793-44df-bb7e-a5cb93566759	2025-09-13 04:36:00.025939+00	2025-09-13 04:36:00.025939+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
321bfb15-d447-463f-be0e-779fe9e22210	bf88a0b8-25bf-4743-bf2e-e06ef356a633	2025-09-13 04:36:17.282079+00	2025-09-13 04:36:17.282079+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
01b61702-0d39-4188-899d-727794792a97	09d98c9d-a1a7-4b65-9d6c-ae4e293dbead	2025-09-13 04:36:33.625909+00	2025-09-13 04:36:33.625909+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
cac60e15-f295-4c83-bbd7-d6a4338fcaf8	2ae0b466-781d-4e52-836e-6511c8155742	2025-09-13 04:37:29.099775+00	2025-09-13 04:37:29.099775+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
0bbb5b12-fb3b-44b5-9493-d4813dbc1eb5	ed0914b9-f329-4286-b1b9-3cb2a39ff750	2025-09-13 04:38:17.538479+00	2025-09-13 04:38:17.538479+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
136fe919-fd56-46c1-a893-c9f2b904b744	19fd552e-1b8d-4eba-9fd7-7621451f6272	2025-09-13 04:38:38.701499+00	2025-09-13 04:38:38.701499+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
5fb939fb-46dc-4dd7-8aac-c939fbe4c090	c608c9e1-9cc8-47c4-a71b-28fe5bcf1635	2025-09-13 04:38:51.385075+00	2025-09-13 04:38:51.385075+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
8a0a901e-8bd1-4e02-9e8d-215d22bc9253	91d20798-accf-4fe7-b038-b9af34a50aad	2025-09-13 04:39:08.149587+00	2025-09-13 04:39:08.149587+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
90d934dc-1f5f-4c48-a66f-ebdd0202a887	d677ddb9-7459-44f3-94f9-fcb42ae3cbf5	2025-09-13 04:39:31.358367+00	2025-09-13 04:39:31.358367+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
06f001f2-0877-40ee-82a3-6325925586c6	dfc3cb8c-7ab1-4891-b54d-e6101aeccf7a	2025-09-13 04:39:43.761482+00	2025-09-13 04:39:43.761482+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
4564e55f-7694-4b15-85be-828b6c006506	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-08-24 06:59:55.33132+00	2025-09-13 05:37:23.990575+00	\N	aal1	\N	2025-09-13 05:37:23.990491	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	171.252.155.68	\N
5cf295bf-7cfb-404e-bff3-293df3965896	c2d1083d-d480-40cc-947d-cad7294eedc2	2025-09-13 04:40:20.751647+00	2025-09-13 04:40:20.751647+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
a58e64ec-ca30-4720-bf6f-209fd4d77e90	1a921e78-7463-4404-b054-bf6302b40c11	2025-09-13 04:40:51.875366+00	2025-09-13 04:40:51.875366+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
b2513c94-92db-4c5b-a034-7084ca4d3170	697fec7b-74d6-4df7-b165-87d112eaf2fc	2025-09-13 04:41:06.797631+00	2025-09-13 04:41:06.797631+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
69d93bf3-1e59-4ea9-95ad-6e45f5ba7142	89800f22-6220-467a-b58d-5f6f22db2647	2025-09-13 04:41:19.363699+00	2025-09-13 04:41:19.363699+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
251fcfbd-690c-4310-8e36-5dba562949df	ab2f529a-dda7-4dad-8d6f-27572f4871c1	2025-09-13 04:42:43.291495+00	2025-09-13 04:42:43.291495+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
42a3adeb-9425-4d90-b28c-478b2a494b70	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-09-13 05:27:10.144086+00	2025-09-13 05:27:10.144086+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	171.252.155.68	\N
96d2b8e9-0239-453e-80bf-963737efef85	6477eb40-4562-4138-97e1-56d9cea1bd3d	2025-09-13 05:27:20.178275+00	2025-09-13 05:27:20.178275+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	171.252.155.68	\N
2f43df4b-32d9-4887-95e7-bd164c66d264	acc521ce-1c0e-4911-8ff2-c168f6a7100f	2025-09-13 05:31:31.870068+00	2025-09-13 05:31:31.870068+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	171.252.155.68	\N
77b27248-4822-4835-9c28-263d1b5260f3	acc521ce-1c0e-4911-8ff2-c168f6a7100f	2025-09-13 05:37:30.728873+00	2025-09-13 05:37:30.728873+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	171.252.155.68	\N
2f2f4915-5059-46eb-bc57-1bbdd8237093	a0740794-4a85-4037-9340-89567cd20f04	2025-09-13 04:43:51.857858+00	2025-09-13 05:42:25.248541+00	\N	aal1	\N	2025-09-13 05:42:25.248472	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	91.196.220.245	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	dc743d86-49ee-43d6-a8c7-eb7a8b032a93	authenticated	authenticated	3122560572@gmail.com	$2a$10$J2yofg3zaPFwvtG/kcFIO.Zcu/soZGLfy8L9HsjM94SykU2gs8Jb6	2025-02-21 05:32:45.750152+00	\N		\N		\N			\N	2025-02-21 05:32:45.753712+00	{"provider": "email", "providers": ["email"]}	{"sub": "dc743d86-49ee-43d6-a8c7-eb7a8b032a93", "role": "student", "email": "3122560572@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 05:32:45.742462+00	2025-02-21 05:32:45.756075+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	2956b155-1d48-4058-acdb-c1151fa5c9fd	authenticated	authenticated	gv002@gmail.com	$2a$10$XeB9HZXUKle57cZzsi.EJu.MTXwFXpmg2Dq0a4I9liN9qnBAV7v/2	2025-02-21 10:44:50.448086+00	\N		\N		\N			\N	2025-02-21 10:45:04.106359+00	{"provider": "email", "providers": ["email"]}	{"sub": "2956b155-1d48-4058-acdb-c1151fa5c9fd", "role": "teacher", "email": "gv002@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 10:44:50.439267+00	2025-02-21 10:45:04.107966+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	0af601e2-d596-49c7-9b53-12d86ecb6d12	authenticated	authenticated	3122569072@gmail.com	$2a$10$j37/bi/eL88IFmGn3USRbO6hAKCA0ULwghVqTJHYHu3mUaJJvyO9O	2025-02-21 05:34:02.946716+00	\N		\N		\N			\N	2025-02-21 05:34:02.951408+00	{"provider": "email", "providers": ["email"]}	{"sub": "0af601e2-d596-49c7-9b53-12d86ecb6d12", "role": "student", "email": "3122569072@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 05:34:02.939525+00	2025-02-21 05:34:02.953723+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	620de24c-a40a-432a-be36-86852092f3c1	authenticated	authenticated	3122569172@gmail.com	$2a$10$tw4Apk0t.Uh8uuuf5Ma8JOtYHkG0GBmwqYOrOV1usNsPHiwRnhybm	2025-02-21 05:37:07.007255+00	\N		\N		\N			\N	2025-02-27 02:10:32.620378+00	{"provider": "email", "providers": ["email"]}	{"sub": "620de24c-a40a-432a-be36-86852092f3c1", "role": "student", "email": "3122569172@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 05:37:06.999745+00	2025-02-27 02:10:32.629909+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	authenticated	authenticated	3122410471@gmail.com	$2a$10$pX5RE8CQkDPIXKJ33oDWpuMB3HIarFvm6KrUas7K22u7cMUs9hDDC	2025-02-21 08:15:30.226186+00	\N		\N		\N			\N	2025-03-14 10:04:59.712104+00	{"provider": "email", "providers": ["email"]}	{"sub": "557d4ebc-ccbf-4402-ae59-4dd4b357e97c", "role": "teacher", "email": "3122410471@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 08:15:30.199727+00	2025-03-23 08:23:48.25037+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	3b4201ff-ee15-44ec-9954-633782fcd401	authenticated	authenticated	sv123@gmail.com	$2a$10$dUEwlztfqWhAtiRPFiH/Peojf6gQPmY.ivySbSPhAiUOsoY4kcJIG	2025-06-19 06:33:48.349203+00	\N		\N		\N			\N	2025-06-19 06:33:48.352886+00	{"provider": "email", "providers": ["email"]}	{"sub": "3b4201ff-ee15-44ec-9954-633782fcd401", "role": "student", "email": "sv123@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-06-19 06:33:48.342962+00	2025-06-19 06:33:48.354481+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	89fd994d-0d19-4920-ad87-027b3757ac03	authenticated	authenticated	ngominhphat@gmail.com	$2a$10$aMm9XMMDrmPCs.zrS/JFkO2ef91Cu7.R3LUokEmn9Ih3Duem8mhBu	2025-06-19 06:34:15.453235+00	\N		\N		\N			\N	2025-06-19 06:34:15.456156+00	{"provider": "email", "providers": ["email"]}	{"sub": "89fd994d-0d19-4920-ad87-027b3757ac03", "role": "student", "email": "ngominhphat@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-06-19 06:34:15.448327+00	2025-06-19 06:34:15.458365+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	8c75fb07-ba4b-4df0-badd-6f7b8a3a8361	authenticated	authenticated	gv003@gmail.com	$2a$10$E/e/Rxjt5UvA58qvcaVQn.yh4Q7./vjlX0bu.ysttmL1.WNezOD6C	2025-06-13 04:34:52.289591+00	\N		\N		\N			\N	2025-06-13 04:35:08.451606+00	{"provider": "email", "providers": ["email"]}	{"sub": "8c75fb07-ba4b-4df0-badd-6f7b8a3a8361", "role": "teacher", "email": "gv003@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-06-13 04:34:52.264403+00	2025-09-13 03:48:56.210875+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	authenticated	authenticated	gv001@gmail.com	$2a$10$HuDproFlUhxw.If2V3toY.hJRjBbWToO7Pu8VgprWUMycxgbNYx/q	2025-02-21 05:51:53.363042+00	\N		\N		\N			\N	2025-09-13 05:27:10.142757+00	{"provider": "email", "providers": ["email"]}	{"sub": "e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0", "role": "teacher", "email": "gv001@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 05:51:53.358174+00	2025-09-13 05:37:23.988289+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	d12c4359-e2b0-4165-959d-aec89b853e1a	authenticated	authenticated	sv123456@gmail.com	$2a$10$5Zwr3WseCQ4wym3Q2sfycekfIB72j0VA.zb.fNbqb1aHurk94mykO	2025-06-19 06:32:42.849319+00	\N		\N		\N			\N	2025-06-19 06:32:42.852944+00	{"provider": "email", "providers": ["email"]}	{"sub": "d12c4359-e2b0-4165-959d-aec89b853e1a", "role": "student", "email": "sv123456@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-06-19 06:32:42.841268+00	2025-06-19 06:32:42.854537+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e368b85d-7038-4211-be16-c959c7931de0	authenticated	authenticated	3122410449@gmail.com	$2a$10$MixpCSjnS7aPt2lw5SLIWuMejKQB9QLGTE8Nj.yhwZtsWB5M0TYoi	2025-02-21 10:17:00.938163+00	\N		\N		\N			\N	2025-09-13 04:26:41.37002+00	{"provider": "email", "providers": ["email"]}	{"sub": "e368b85d-7038-4211-be16-c959c7931de0", "role": "student", "email": "3122410449@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 10:17:00.927194+00	2025-09-13 04:26:41.373193+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	2a29ff32-0dbd-4f3f-ba8d-f7c868e36744	authenticated	authenticated	gv000@gmail.com	$2a$10$UKEoODw2Cfz2xW7hCnLGTeDM1Jk7ghiB2p5XEIbenyNiL0MCdfC1u	2025-06-19 06:31:16.371425+00	\N		\N		\N			\N	2025-06-19 06:31:16.379784+00	{"provider": "email", "providers": ["email"]}	{"sub": "2a29ff32-0dbd-4f3f-ba8d-f7c868e36744", "role": "teacher", "email": "gv000@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-06-19 06:31:16.34367+00	2025-06-19 06:31:16.38225+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	6477eb40-4562-4138-97e1-56d9cea1bd3d	authenticated	authenticated	3122560072@gmail.com	$2a$10$PNOpGoZhRRcOI24PvQgFQOV/cCkreWdE4ZukoE8XhBvLFQm92H29S	2025-02-21 05:51:03.423192+00	\N		\N		\N			\N	2025-09-13 05:27:20.177648+00	{"provider": "email", "providers": ["email"]}	{"sub": "6477eb40-4562-4138-97e1-56d9cea1bd3d", "role": "student", "email": "3122560072@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 05:51:03.412102+00	2025-09-13 05:27:20.184937+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	1d0458b8-1c9c-4120-8474-4b3467af2c53	authenticated	authenticated	sv0000@gmail.com	$2a$10$O5jtQfmuhUeJ.rOIRgGuHuNVxF1../HVWgqRWf0XlwiyyAvP2vaIa	2025-09-13 04:27:19.673965+00	\N		\N		\N			\N	2025-09-13 04:27:35.196062+00	{"provider": "email", "providers": ["email"]}	{"sub": "1d0458b8-1c9c-4120-8474-4b3467af2c53", "role": "student", "email": "sv0000@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:27:19.634876+00	2025-09-13 04:27:35.197754+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	09d98c9d-a1a7-4b65-9d6c-ae4e293dbead	authenticated	authenticated	22145211@gmail.com	$2a$10$Q/RHI41IFCRRMQMS6IXtxu.u9/ZeOXChLYAgUvCqfP2XhKJblSl16	2025-09-13 04:36:33.622944+00	\N		\N		\N			\N	2025-09-13 04:36:33.625835+00	{"provider": "email", "providers": ["email"]}	{"sub": "09d98c9d-a1a7-4b65-9d6c-ae4e293dbead", "role": "student", "email": "22145211@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:36:33.618478+00	2025-09-13 04:36:33.627367+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	cbe2858c-b62c-4e42-b212-5353934cc62f	authenticated	authenticated	22145097@gmail.com	$2a$10$3DvFRg2QZqUBdQqKHtywD.hjCoAS77kabcfgJ0YpNkDByMjLPOuZm	2025-09-13 04:33:11.004014+00	\N		\N		\N			\N	2025-09-13 04:33:34.374155+00	{"provider": "email", "providers": ["email"]}	{"sub": "cbe2858c-b62c-4e42-b212-5353934cc62f", "role": "student", "email": "22145097@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:33:10.992989+00	2025-09-13 04:33:34.376416+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	641a180f-65a1-45b4-a648-a2df8482e0f4	authenticated	authenticated	20145112@gmail.com	$2a$10$EUztm0wyu57d90HNqJWNGersrfSrJN/kZG2F.MgckCiS4QnLhrXL6	2025-09-13 04:35:21.017224+00	\N		\N		\N			\N	2025-09-13 04:35:21.020884+00	{"provider": "email", "providers": ["email"]}	{"sub": "641a180f-65a1-45b4-a648-a2df8482e0f4", "role": "student", "email": "20145112@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:35:21.009774+00	2025-09-13 04:35:21.025705+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	6f5dacff-4e81-4e42-83e2-1a7cd07bd690	authenticated	authenticated	19145225@gmail.com	$2a$10$T2mRIn5Yz4WYM8LKkoHQHuka5V/eH.5mm1AB0kspEB/HbNhmpOgWm	2025-09-13 04:35:02.131838+00	\N		\N		\N			\N	2025-09-13 04:35:02.13613+00	{"provider": "email", "providers": ["email"]}	{"sub": "6f5dacff-4e81-4e42-83e2-1a7cd07bd690", "role": "student", "email": "19145225@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:35:02.121843+00	2025-09-13 04:35:02.139231+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	3ada3240-643f-4735-b17d-39fc4ec262a2	authenticated	authenticated	123123@gmail.com	$2a$10$dzLxoeimmqCFW.eSpSDQ5elYxej63UBVaIE4kw9RTDlgc1HjHdOqW	2025-08-24 06:18:22.643529+00	\N		\N		\N			\N	2025-08-24 06:57:07.306022+00	{"provider": "email", "providers": ["email"]}	{"sub": "3ada3240-643f-4735-b17d-39fc4ec262a2", "role": "student", "email": "123123@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-08-24 06:18:22.600464+00	2025-09-13 04:25:03.879725+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	ab2f529a-dda7-4dad-8d6f-27572f4871c1	authenticated	authenticated	22145433@gmail.com	$2a$10$xmrQanQQKMqjLHzR1QtO7.ZEicUeRq9rKGj6D6K0PCdVbEj/lRKum	2025-09-13 04:29:40.408512+00	\N		\N		\N			\N	2025-09-13 04:42:43.291416+00	{"provider": "email", "providers": ["email"]}	{"sub": "ab2f529a-dda7-4dad-8d6f-27572f4871c1", "role": "student", "email": "22145433@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:29:40.395423+00	2025-09-13 04:42:43.295478+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	695940da-8528-4f2a-a452-6cf9481ae155	authenticated	authenticated	22145105@gmail.com	$2a$10$ZmOrl9scll7gvedOLIcRmePZpSQJQghhuwptEq1BxeKvyF2l2cU52	2025-09-13 04:34:49.580123+00	\N		\N		\N			\N	2025-09-13 04:34:49.592784+00	{"provider": "email", "providers": ["email"]}	{"sub": "695940da-8528-4f2a-a452-6cf9481ae155", "role": "student", "email": "22145105@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:34:49.541372+00	2025-09-13 04:34:49.605458+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	a675dd83-18f6-41c2-ba55-92cd88e14541	authenticated	authenticated	22145212@gmail.com	$2a$10$.ESOkQykzqC/.r8bDhuZVeGcPD9bVI99bA8s9eoaXJKgWCzcd7D.S	2025-09-13 04:36:45.139637+00	\N		\N		\N			\N	2025-09-13 04:36:45.142336+00	{"provider": "email", "providers": ["email"]}	{"sub": "a675dd83-18f6-41c2-ba55-92cd88e14541", "role": "student", "email": "22145212@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:36:45.133759+00	2025-09-13 04:36:45.144573+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	3210fe05-0793-44df-bb7e-a5cb93566759	authenticated	authenticated	22145207@gmail.com	$2a$10$4js37cYqE6CXrkZaJLFoW.xs7NcjOqeBkeC0gkpVdJ10DR46z91im	2025-09-13 04:36:00.022189+00	\N		\N		\N			\N	2025-09-13 04:36:00.02586+00	{"provider": "email", "providers": ["email"]}	{"sub": "3210fe05-0793-44df-bb7e-a5cb93566759", "role": "student", "email": "22145207@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:36:00.013856+00	2025-09-13 04:36:00.027433+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	2ae0b466-781d-4e52-836e-6511c8155742	authenticated	authenticated	22145206@gmail.com	$2a$10$/FLCDqd5.nsBKJKwA0FI8.nwG4eE4sMjA6jxqQDohmcRYhR5wcuOG	2025-09-13 04:35:40.066157+00	\N		\N		\N			\N	2025-09-13 04:37:29.099702+00	{"provider": "email", "providers": ["email"]}	{"sub": "2ae0b466-781d-4e52-836e-6511c8155742", "role": "student", "email": "22145206@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:35:40.059999+00	2025-09-13 04:37:29.101355+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	bf88a0b8-25bf-4743-bf2e-e06ef356a633	authenticated	authenticated	22145210@gmail.com	$2a$10$SzlMq4YE9ig4KL9VjkrxheEcoGGjeBaWdERoxL7K2dZTfSXr46DzG	2025-09-13 04:36:17.279112+00	\N		\N		\N			\N	2025-09-13 04:36:17.282012+00	{"provider": "email", "providers": ["email"]}	{"sub": "bf88a0b8-25bf-4743-bf2e-e06ef356a633", "role": "student", "email": "22145210@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:36:17.271313+00	2025-09-13 04:36:17.284448+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	a0740794-4a85-4037-9340-89567cd20f04	authenticated	authenticated	gv0000@gmail.com	$2a$10$Li39.PPDomipqUCqiC7gde3qO/PQroiCBDmpT90R7Cydto1CgIPSe	2025-08-24 06:19:32.392999+00	\N		\N		\N			\N	2025-09-13 04:43:51.857783+00	{"provider": "email", "providers": ["email"]}	{"sub": "a0740794-4a85-4037-9340-89567cd20f04", "role": "teacher", "email": "gv0000@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-08-24 06:19:32.381199+00	2025-09-13 05:42:25.246886+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	acc521ce-1c0e-4911-8ff2-c168f6a7100f	authenticated	authenticated	gv007@gmail.com	$2a$10$ErfITQ5E2kYkRJHGfU5Ptekf.i6WdNVrXkz1uwX6UOaKNbkPxjNgi	2025-09-13 05:31:20.680636+00	\N		\N		\N			\N	2025-09-13 05:37:30.728786+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-09-13 05:31:20.674422+00	2025-09-13 05:37:30.732125+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	ed0914b9-f329-4286-b1b9-3cb2a39ff750	authenticated	authenticated	22145213@gmail.com	$2a$10$wZhsYvmfPoGLicp9BOIV6OVKUnEweDcC2ZqhSRjb7fcoNIo2Pfm/W	2025-09-13 04:37:54.674446+00	\N		\N		\N			\N	2025-09-13 04:38:17.538411+00	{"provider": "email", "providers": ["email"]}	{"sub": "ed0914b9-f329-4286-b1b9-3cb2a39ff750", "role": "student", "email": "22145213@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:37:54.665614+00	2025-09-13 04:38:17.540792+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c2d1083d-d480-40cc-947d-cad7294eedc2	authenticated	authenticated	22145228@gmail.com	$2a$10$H36d8wO5xeVrPqRqg4ot9uWF8Ao8.9nkqzQttDkr0wxOcuEQliiC.	2025-09-13 04:39:58.00324+00	\N		\N		\N			\N	2025-09-13 04:40:20.751574+00	{"provider": "email", "providers": ["email"]}	{"sub": "c2d1083d-d480-40cc-947d-cad7294eedc2", "role": "student", "email": "22145228@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:39:57.996931+00	2025-09-13 04:40:20.754658+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	91d20798-accf-4fe7-b038-b9af34a50aad	authenticated	authenticated	22145218@gmail.com	$2a$10$3mazPmqYAiLCjXaCeQ7ybOkpehDdvHKOVshE4hulNOYCjnDDaQ.IC	2025-09-13 04:39:08.14545+00	\N		\N		\N			\N	2025-09-13 04:39:08.149496+00	{"provider": "email", "providers": ["email"]}	{"sub": "91d20798-accf-4fe7-b038-b9af34a50aad", "role": "student", "email": "22145218@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:39:08.140317+00	2025-09-13 04:39:08.151134+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	19fd552e-1b8d-4eba-9fd7-7621451f6272	authenticated	authenticated	22145215@gmail.com	$2a$10$IZwloZu.9cRYYfTkKhShXuakMiTMaBhcFgHTLsKx1F11XjxY.08g6	2025-09-13 04:38:38.698542+00	\N		\N		\N			\N	2025-09-13 04:38:38.701436+00	{"provider": "email", "providers": ["email"]}	{"sub": "19fd552e-1b8d-4eba-9fd7-7621451f6272", "role": "student", "email": "22145215@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:38:38.69283+00	2025-09-13 04:38:38.704085+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	dfc3cb8c-7ab1-4891-b54d-e6101aeccf7a	authenticated	authenticated	22145226@gmail.com	$2a$10$1t/6gPN4ineEcpiUHbyBAuQ242Gu/3tQtlLp5jy5XZASaZiQF1iEm	2025-09-13 04:39:43.756992+00	\N		\N		\N			\N	2025-09-13 04:39:43.761408+00	{"provider": "email", "providers": ["email"]}	{"sub": "dfc3cb8c-7ab1-4891-b54d-e6101aeccf7a", "role": "student", "email": "22145226@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:39:43.747283+00	2025-09-13 04:39:43.765047+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	7a9ab239-22d2-4094-9d44-67239a322094	authenticated	authenticated	3122560073@gmail.com	$2a$10$SnradDTtuLoKZ/85/.dJfuBWvv1Tg.b2GGxWCj6xviNcFF.vNKJPa	2025-09-13 05:30:37.559191+00	\N		\N		\N			\N	2025-09-13 05:30:50.432401+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-09-13 05:30:37.523347+00	2025-09-13 05:30:50.442357+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	89800f22-6220-467a-b58d-5f6f22db2647	authenticated	authenticated	22145290@gmail.com	$2a$10$cTTWGzCLWlOMLk0PdULc5.PcgwxINqsfM.s1xogAHlQs8QV2Kg0Hi	2025-09-13 04:41:19.357132+00	\N		\N		\N			\N	2025-09-13 04:41:19.363631+00	{"provider": "email", "providers": ["email"]}	{"sub": "89800f22-6220-467a-b58d-5f6f22db2647", "role": "student", "email": "22145290@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:41:19.326758+00	2025-09-13 04:41:19.36526+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	697fec7b-74d6-4df7-b165-87d112eaf2fc	authenticated	authenticated	22145280@gmail.com	$2a$10$mpj63BqZO2b63imJxofVROllTWH0lcVbeIo5GGMv.R2djqbJ9kKOe	2025-09-13 04:41:06.793423+00	\N		\N		\N			\N	2025-09-13 04:41:06.797558+00	{"provider": "email", "providers": ["email"]}	{"sub": "697fec7b-74d6-4df7-b165-87d112eaf2fc", "role": "student", "email": "22145280@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:41:06.782211+00	2025-09-13 04:41:06.800094+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c608c9e1-9cc8-47c4-a71b-28fe5bcf1635	authenticated	authenticated	22145216@gmail.com	$2a$10$ymQgqzi/zcS0Hb/PLYwMeeNZG085YN9lohbBSGh1henPBfItiv88G	2025-09-13 04:38:51.382251+00	\N		\N		\N			\N	2025-09-13 04:38:51.385004+00	{"provider": "email", "providers": ["email"]}	{"sub": "c608c9e1-9cc8-47c4-a71b-28fe5bcf1635", "role": "student", "email": "22145216@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:38:51.377731+00	2025-09-13 04:38:51.386423+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	d677ddb9-7459-44f3-94f9-fcb42ae3cbf5	authenticated	authenticated	22145220@gmail.com	$2a$10$Kefrx7Fe9ex/yx.sDslx6Oae1tBNCi6Lw/UDvKez9pMG/p9rWojhO	2025-09-13 04:39:31.354709+00	\N		\N		\N			\N	2025-09-13 04:39:31.358298+00	{"provider": "email", "providers": ["email"]}	{"sub": "d677ddb9-7459-44f3-94f9-fcb42ae3cbf5", "role": "student", "email": "22145220@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:39:31.349079+00	2025-09-13 04:39:31.35973+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	1a921e78-7463-4404-b054-bf6302b40c11	authenticated	authenticated	22145230@gmail.com	$2a$10$bpiGGJD6segIqOikX5Iiz.bkA7oGgzPQTgkqt2kHpd1egWa4Nug42	2025-09-13 04:40:51.862859+00	\N		\N		\N			\N	2025-09-13 04:40:51.87527+00	{"provider": "email", "providers": ["email"]}	{"sub": "1a921e78-7463-4404-b054-bf6302b40c11", "role": "student", "email": "22145230@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-13 04:40:51.669632+00	2025-09-13 04:40:51.896892+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--

COPY pgsodium.key (id, status, created, expires, key_type, key_id, key_context, name, associated_data, raw_key, raw_key_nonce, parent_key, comment, user_data) FROM stdin;
\.


--
-- Data for Name: activity_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activity_logs (id, activity_type, details, created_at, updated_at) FROM stdin;
1	ping	Initial setup ping	2025-04-28 04:49:24.159807+00	2025-04-28 04:49:24.159807+00
4	ping	Automatic ping to keep database active	2025-04-28 05:00:46.989998+00	2025-04-28 05:00:46.989998+00
5	ping	Automatic ping to keep database active	2025-04-28 05:29:05.328783+00	2025-04-28 05:29:05.328783+00
6	ping	Automatic ping to keep database active	2025-04-28 05:49:37.148257+00	2025-04-28 05:49:37.148257+00
7	ping	Automatic ping to keep database active	2025-04-28 05:54:22.393663+00	2025-04-28 05:54:22.393663+00
8	ping	Automatic ping to keep database active	2025-04-28 05:58:46.240992+00	2025-04-28 05:58:46.240992+00
9	ping	Automatic ping to keep database active	2025-04-28 06:28:57.566778+00	2025-04-28 06:28:57.566778+00
10	ping	Automatic ping to keep database active	2025-05-05 11:25:16.212138+00	2025-05-05 11:25:16.212138+00
11	ping	Automatic ping to keep database active	2025-05-13 12:22:19.100847+00	2025-05-13 12:22:19.100847+00
12	ping	Automatic ping to keep database active	2025-05-22 10:30:13.723279+00	2025-05-22 10:30:13.723279+00
13	ping	Automatic ping to keep database active	2025-05-22 10:36:14.369202+00	2025-05-22 10:36:14.369202+00
14	ping	Automatic ping to keep database active	2025-05-22 10:36:20.642798+00	2025-05-22 10:36:20.642798+00
15	ping	Automatic ping to keep database active	2025-05-22 10:38:47.672198+00	2025-05-22 10:38:47.672198+00
16	ping	Automatic ping to keep database active	2025-05-22 10:43:52.380667+00	2025-05-22 10:43:52.380667+00
17	ping	Automatic ping to keep database active	2025-05-22 10:48:57.255397+00	2025-05-22 10:48:57.255397+00
18	ping	Automatic ping to keep database active	2025-05-22 22:49:02.426641+00	2025-05-22 22:49:02.426641+00
19	ping	Automatic ping to keep database active	2025-05-23 00:39:02.159082+00	2025-05-23 00:39:02.159082+00
20	ping	Automatic ping to keep database active	2025-05-23 10:49:08.369185+00	2025-05-23 10:49:08.369185+00
21	ping	Automatic ping to keep database active	2025-05-23 22:49:13.772676+00	2025-05-23 22:49:13.772676+00
22	ping	Automatic ping to keep database active	2025-05-24 00:39:02.272406+00	2025-05-24 00:39:02.272406+00
23	ping	Automatic ping to keep database active	2025-05-24 10:49:18.873029+00	2025-05-24 10:49:18.873029+00
24	ping	Automatic ping to keep database active	2025-05-24 22:49:24.545224+00	2025-05-24 22:49:24.545224+00
25	ping	Automatic ping to keep database active	2025-05-25 00:39:02.190136+00	2025-05-25 00:39:02.190136+00
26	ping	Automatic ping to keep database active	2025-05-25 10:49:28.983326+00	2025-05-25 10:49:28.983326+00
27	ping	Automatic ping to keep database active	2025-05-25 22:49:34.843734+00	2025-05-25 22:49:34.843734+00
28	ping	Automatic ping to keep database active	2025-05-26 00:39:02.382667+00	2025-05-26 00:39:02.382667+00
29	ping	Automatic ping to keep database active	2025-05-26 10:49:38.652657+00	2025-05-26 10:49:38.652657+00
30	ping	Automatic ping to keep database active	2025-05-26 22:49:41.189461+00	2025-05-26 22:49:41.189461+00
31	ping	Automatic ping to keep database active	2025-05-27 00:39:02.316937+00	2025-05-27 00:39:02.316937+00
32	ping	Automatic ping to keep database active	2025-05-27 10:49:47.141103+00	2025-05-27 10:49:47.141103+00
33	ping	Automatic ping to keep database active	2025-05-27 22:49:52.13536+00	2025-05-27 22:49:52.13536+00
34	ping	Automatic ping to keep database active	2025-05-28 00:39:02.281997+00	2025-05-28 00:39:02.281997+00
35	ping	Automatic ping to keep database active	2025-05-28 10:49:58.519309+00	2025-05-28 10:49:58.519309+00
36	ping	Automatic ping to keep database active	2025-05-28 22:50:02.902805+00	2025-05-28 22:50:02.902805+00
37	ping	Automatic ping to keep database active	2025-05-29 00:39:02.713479+00	2025-05-29 00:39:02.713479+00
38	ping	Automatic ping to keep database active	2025-05-29 10:50:08.191683+00	2025-05-29 10:50:08.191683+00
39	ping	Automatic ping to keep database active	2025-05-29 22:50:13.282661+00	2025-05-29 22:50:13.282661+00
40	ping	Automatic ping to keep database active	2025-05-30 00:39:02.561996+00	2025-05-30 00:39:02.561996+00
41	ping	Automatic ping to keep database active	2025-05-30 10:50:16.461732+00	2025-05-30 10:50:16.461732+00
42	ping	Automatic ping to keep database active	2025-05-30 22:50:21.266935+00	2025-05-30 22:50:21.266935+00
43	ping	Automatic ping to keep database active	2025-05-31 00:39:02.248637+00	2025-05-31 00:39:02.248637+00
44	ping	Automatic ping to keep database active	2025-05-31 10:50:26.896367+00	2025-05-31 10:50:26.896367+00
45	ping	Automatic ping to keep database active	2025-05-31 22:50:33.349083+00	2025-05-31 22:50:33.349083+00
46	ping	Automatic ping to keep database active	2025-06-01 00:39:02.244059+00	2025-06-01 00:39:02.244059+00
47	ping	Automatic ping to keep database active	2025-06-01 10:50:39.997278+00	2025-06-01 10:50:39.997278+00
48	ping	Automatic ping to keep database active	2025-06-01 22:50:46.701056+00	2025-06-01 22:50:46.701056+00
49	ping	Automatic ping to keep database active	2025-06-02 00:39:02.438844+00	2025-06-02 00:39:02.438844+00
50	ping	Automatic ping to keep database active	2025-06-02 10:50:50.685825+00	2025-06-02 10:50:50.685825+00
51	ping	Automatic ping to keep database active	2025-06-02 22:50:55.018795+00	2025-06-02 22:50:55.018795+00
52	ping	Automatic ping to keep database active	2025-06-03 00:39:02.51425+00	2025-06-03 00:39:02.51425+00
53	ping	Automatic ping to keep database active	2025-06-03 10:51:00.858158+00	2025-06-03 10:51:00.858158+00
54	ping	Automatic ping to keep database active	2025-06-03 22:51:06.455146+00	2025-06-03 22:51:06.455146+00
55	ping	Automatic ping to keep database active	2025-06-04 00:39:02.371172+00	2025-06-04 00:39:02.371172+00
56	ping	Automatic ping to keep database active	2025-06-04 10:51:12.56757+00	2025-06-04 10:51:12.56757+00
57	ping	Automatic ping to keep database active	2025-06-04 22:51:17.441322+00	2025-06-04 22:51:17.441322+00
58	ping	Automatic ping to keep database active	2025-06-05 00:39:02.532258+00	2025-06-05 00:39:02.532258+00
59	ping	Automatic ping to keep database active	2025-06-05 10:51:24.186494+00	2025-06-05 10:51:24.186494+00
60	ping	Automatic ping to keep database active	2025-06-05 22:51:30.937169+00	2025-06-05 22:51:30.937169+00
61	ping	Automatic ping to keep database active	2025-06-06 00:39:02.494438+00	2025-06-06 00:39:02.494438+00
62	ping	Automatic ping to keep database active	2025-06-06 10:51:36.985595+00	2025-06-06 10:51:36.985595+00
63	ping	Automatic ping to keep database active	2025-06-06 22:51:41.672582+00	2025-06-06 22:51:41.672582+00
64	ping	Automatic ping to keep database active	2025-06-07 00:39:02.426682+00	2025-06-07 00:39:02.426682+00
65	ping	Automatic ping to keep database active	2025-06-07 10:51:45.481585+00	2025-06-07 10:51:45.481585+00
66	ping	Automatic ping to keep database active	2025-06-07 22:51:51.041024+00	2025-06-07 22:51:51.041024+00
67	ping	Automatic ping to keep database active	2025-06-08 00:39:02.278973+00	2025-06-08 00:39:02.278973+00
68	ping	Automatic ping to keep database active	2025-06-08 10:51:57.136879+00	2025-06-08 10:51:57.136879+00
69	ping	Automatic ping to keep database active	2025-06-08 22:52:01.508981+00	2025-06-08 22:52:01.508981+00
70	ping	Automatic ping to keep database active	2025-06-09 00:39:02.285862+00	2025-06-09 00:39:02.285862+00
71	ping	Automatic ping to keep database active	2025-06-09 10:52:06.810358+00	2025-06-09 10:52:06.810358+00
72	ping	Automatic ping to keep database active	2025-06-09 22:52:13.59403+00	2025-06-09 22:52:13.59403+00
73	ping	Automatic ping to keep database active	2025-06-10 00:39:02.291049+00	2025-06-10 00:39:02.291049+00
74	ping	Automatic ping to keep database active	2025-06-10 10:52:18.872653+00	2025-06-10 10:52:18.872653+00
75	ping	Automatic ping to keep database active	2025-06-10 22:52:24.552326+00	2025-06-10 22:52:24.552326+00
76	ping	Automatic ping to keep database active	2025-06-11 00:59:30.131364+00	2025-06-11 00:59:30.131364+00
77	ping	Automatic ping to keep database active	2025-06-11 10:52:30.795876+00	2025-06-11 10:52:30.795876+00
78	ping	Automatic ping to keep database active	2025-06-11 22:52:35.412246+00	2025-06-11 22:52:35.412246+00
79	ping	Automatic ping to keep database active	2025-06-12 00:29:01.441874+00	2025-06-12 00:29:01.441874+00
80	ping	Automatic ping to keep database active	2025-06-12 21:15:24.272756+00	2025-06-12 21:15:24.272756+00
81	ping	Automatic ping to keep database active	2025-06-13 00:29:01.434143+00	2025-06-13 00:29:01.434143+00
82	ping	Automatic ping to keep database active	2025-06-13 09:15:30.546766+00	2025-06-13 09:15:30.546766+00
83	ping	Automatic ping to keep database active	2025-06-13 21:15:35.904705+00	2025-06-13 21:15:35.904705+00
84	ping	Automatic ping to keep database active	2025-06-14 00:56:15.202925+00	2025-06-14 00:56:15.202925+00
85	ping	Automatic ping to keep database active	2025-06-14 09:15:42.678368+00	2025-06-14 09:15:42.678368+00
86	ping	Automatic ping to keep database active	2025-06-14 21:15:48.28619+00	2025-06-14 21:15:48.28619+00
87	ping	Automatic ping to keep database active	2025-06-15 00:56:15.248103+00	2025-06-15 00:56:15.248103+00
88	ping	Automatic ping to keep database active	2025-06-15 09:15:52.535947+00	2025-06-15 09:15:52.535947+00
89	ping	Automatic ping to keep database active	2025-06-15 21:15:57.949717+00	2025-06-15 21:15:57.949717+00
90	ping	Automatic ping to keep database active	2025-06-16 00:56:15.172192+00	2025-06-16 00:56:15.172192+00
91	ping	Automatic ping to keep database active	2025-06-16 09:16:03.308436+00	2025-06-16 09:16:03.308436+00
92	ping	Automatic ping to keep database active	2025-06-16 21:16:09.082035+00	2025-06-16 21:16:09.082035+00
93	ping	Automatic ping to keep database active	2025-06-17 00:56:15.386408+00	2025-06-17 00:56:15.386408+00
94	ping	Automatic ping to keep database active	2025-06-17 09:16:12.875588+00	2025-06-17 09:16:12.875588+00
95	ping	Automatic ping to keep database active	2025-06-17 21:16:18.39997+00	2025-06-17 21:16:18.39997+00
96	ping	Automatic ping to keep database active	2025-06-18 00:25:45.298506+00	2025-06-18 00:25:45.298506+00
97	ping	Automatic ping to keep database active	2025-06-18 09:16:23.024032+00	2025-06-18 09:16:23.024032+00
98	ping	Automatic ping to keep database active	2025-06-18 21:16:27.215213+00	2025-06-18 21:16:27.215213+00
99	ping	Automatic ping to keep database active	2025-06-19 00:25:45.305272+00	2025-06-19 00:25:45.305272+00
100	ping	Automatic ping to keep database active	2025-06-19 09:16:33.886407+00	2025-06-19 09:16:33.886407+00
101	ping	Automatic ping to keep database active	2025-06-19 21:16:40.311119+00	2025-06-19 21:16:40.311119+00
102	ping	Automatic ping to keep database active	2025-06-20 00:56:06.261064+00	2025-06-20 00:56:06.261064+00
103	ping	Automatic ping to keep database active	2025-06-20 09:16:45.908792+00	2025-06-20 09:16:45.908792+00
104	ping	Automatic ping to keep database active	2025-06-20 21:16:53.036267+00	2025-06-20 21:16:53.036267+00
105	ping	Automatic ping to keep database active	2025-06-21 00:41:59.362049+00	2025-06-21 00:41:59.362049+00
106	ping	Automatic ping to keep database active	2025-06-21 09:16:58.517705+00	2025-06-21 09:16:58.517705+00
107	ping	Automatic ping to keep database active	2025-06-21 21:17:05.273518+00	2025-06-21 21:17:05.273518+00
108	ping	Automatic ping to keep database active	2025-06-22 00:41:59.286982+00	2025-06-22 00:41:59.286982+00
109	ping	Automatic ping to keep database active	2025-06-22 09:17:09.647126+00	2025-06-22 09:17:09.647126+00
110	ping	Automatic ping to keep database active	2025-06-22 21:17:16.018611+00	2025-06-22 21:17:16.018611+00
111	ping	Automatic ping to keep database active	2025-06-23 00:41:59.293715+00	2025-06-23 00:41:59.293715+00
112	ping	Automatic ping to keep database active	2025-06-23 09:17:20.544816+00	2025-06-23 09:17:20.544816+00
113	ping	Automatic ping to keep database active	2025-06-23 21:17:25.36333+00	2025-06-23 21:17:25.36333+00
114	ping	Automatic ping to keep database active	2025-06-24 00:41:59.240398+00	2025-06-24 00:41:59.240398+00
115	ping	Automatic ping to keep database active	2025-06-24 09:17:30.404783+00	2025-06-24 09:17:30.404783+00
116	ping	Automatic ping to keep database active	2025-06-24 21:17:35.385717+00	2025-06-24 21:17:35.385717+00
117	ping	Automatic ping to keep database active	2025-06-25 00:12:28.373095+00	2025-06-25 00:12:28.373095+00
118	ping	Automatic ping to keep database active	2025-06-25 09:17:41.207715+00	2025-06-25 09:17:41.207715+00
119	ping	Automatic ping to keep database active	2025-06-25 21:17:46.72671+00	2025-06-25 21:17:46.72671+00
120	ping	Automatic ping to keep database active	2025-06-26 00:12:28.322866+00	2025-06-26 00:12:28.322866+00
121	ping	Automatic ping to keep database active	2025-06-26 09:17:53.317144+00	2025-06-26 09:17:53.317144+00
122	ping	Automatic ping to keep database active	2025-06-26 21:17:57.664636+00	2025-06-26 21:17:57.664636+00
123	ping	Automatic ping to keep database active	2025-06-27 00:12:28.276988+00	2025-06-27 00:12:28.276988+00
124	ping	Automatic ping to keep database active	2025-06-27 09:18:02.057366+00	2025-06-27 09:18:02.057366+00
125	ping	Automatic ping to keep database active	2025-06-27 21:18:06.171877+00	2025-06-27 21:18:06.171877+00
126	ping	Automatic ping to keep database active	2025-06-28 00:12:28.219197+00	2025-06-28 00:12:28.219197+00
127	ping	Automatic ping to keep database active	2025-06-28 09:18:11.018376+00	2025-06-28 09:18:11.018376+00
128	ping	Automatic ping to keep database active	2025-06-28 21:18:17.606197+00	2025-06-28 21:18:17.606197+00
129	ping	Automatic ping to keep database active	2025-06-29 00:12:28.214996+00	2025-06-29 00:12:28.214996+00
130	ping	Automatic ping to keep database active	2025-06-29 09:18:21.453277+00	2025-06-29 09:18:21.453277+00
131	ping	Automatic ping to keep database active	2025-06-29 21:18:25.760286+00	2025-06-29 21:18:25.760286+00
132	ping	Automatic ping to keep database active	2025-06-30 00:12:28.266377+00	2025-06-30 00:12:28.266377+00
133	ping	Automatic ping to keep database active	2025-06-30 09:18:30.563919+00	2025-06-30 09:18:30.563919+00
134	ping	Automatic ping to keep database active	2025-06-30 21:18:35.790616+00	2025-06-30 21:18:35.790616+00
135	ping	Automatic ping to keep database active	2025-07-01 00:12:28.266746+00	2025-07-01 00:12:28.266746+00
136	ping	Automatic ping to keep database active	2025-07-01 09:18:41.438051+00	2025-07-01 09:18:41.438051+00
137	ping	Automatic ping to keep database active	2025-07-01 21:18:46.165217+00	2025-07-01 21:18:46.165217+00
138	ping	Automatic ping to keep database active	2025-07-02 00:12:28.141273+00	2025-07-02 00:12:28.141273+00
139	ping	Automatic ping to keep database active	2025-07-02 09:18:52.020212+00	2025-07-02 09:18:52.020212+00
140	ping	Automatic ping to keep database active	2025-07-02 21:18:58.651265+00	2025-07-02 21:18:58.651265+00
141	ping	Automatic ping to keep database active	2025-07-03 00:12:28.162326+00	2025-07-03 00:12:28.162326+00
142	ping	Automatic ping to keep database active	2025-07-03 09:19:03.490043+00	2025-07-03 09:19:03.490043+00
143	ping	Automatic ping to keep database active	2025-07-03 21:19:07.54334+00	2025-07-03 21:19:07.54334+00
144	ping	Automatic ping to keep database active	2025-07-04 00:12:28.252262+00	2025-07-04 00:12:28.252262+00
145	ping	Automatic ping to keep database active	2025-07-04 09:19:12.428318+00	2025-07-04 09:19:12.428318+00
146	ping	Automatic ping to keep database active	2025-07-04 21:19:17.684231+00	2025-07-04 21:19:17.684231+00
147	ping	Automatic ping to keep database active	2025-07-05 00:12:28.203858+00	2025-07-05 00:12:28.203858+00
148	ping	Automatic ping to keep database active	2025-07-05 09:19:22.445382+00	2025-07-05 09:19:22.445382+00
149	ping	Automatic ping to keep database active	2025-07-05 21:19:27.67282+00	2025-07-05 21:19:27.67282+00
150	ping	Automatic ping to keep database active	2025-07-06 00:12:28.218322+00	2025-07-06 00:12:28.218322+00
151	ping	Automatic ping to keep database active	2025-07-06 09:19:32.533676+00	2025-07-06 09:19:32.533676+00
152	ping	Automatic ping to keep database active	2025-07-06 21:19:38.024969+00	2025-07-06 21:19:38.024969+00
153	ping	Automatic ping to keep database active	2025-07-07 00:12:28.259602+00	2025-07-07 00:12:28.259602+00
154	ping	Automatic ping to keep database active	2025-07-07 09:19:44.30611+00	2025-07-07 09:19:44.30611+00
155	ping	Automatic ping to keep database active	2025-07-07 21:19:49.069448+00	2025-07-07 21:19:49.069448+00
156	ping	Automatic ping to keep database active	2025-07-08 00:12:28.378465+00	2025-07-08 00:12:28.378465+00
157	ping	Automatic ping to keep database active	2025-07-08 09:19:54.027228+00	2025-07-08 09:19:54.027228+00
158	ping	Automatic ping to keep database active	2025-07-08 21:20:00.319504+00	2025-07-08 21:20:00.319504+00
159	ping	Automatic ping to keep database active	2025-07-09 00:12:28.329613+00	2025-07-09 00:12:28.329613+00
160	ping	Automatic ping to keep database active	2025-07-09 09:20:05.749938+00	2025-07-09 09:20:05.749938+00
161	ping	Automatic ping to keep database active	2025-07-09 21:20:10.588476+00	2025-07-09 21:20:10.588476+00
162	ping	Automatic ping to keep database active	2025-07-10 00:12:28.256508+00	2025-07-10 00:12:28.256508+00
163	ping	Automatic ping to keep database active	2025-07-10 09:20:15.924927+00	2025-07-10 09:20:15.924927+00
164	ping	Automatic ping to keep database active	2025-07-10 21:20:20.903658+00	2025-07-10 21:20:20.903658+00
165	ping	Automatic ping to keep database active	2025-07-11 00:12:28.215443+00	2025-07-11 00:12:28.215443+00
166	ping	Automatic ping to keep database active	2025-07-11 09:20:25.176698+00	2025-07-11 09:20:25.176698+00
167	ping	Automatic ping to keep database active	2025-07-11 21:20:30.240286+00	2025-07-11 21:20:30.240286+00
168	ping	Automatic ping to keep database active	2025-07-12 00:12:28.26136+00	2025-07-12 00:12:28.26136+00
169	ping	Automatic ping to keep database active	2025-07-12 09:20:36.425361+00	2025-07-12 09:20:36.425361+00
170	ping	Automatic ping to keep database active	2025-07-12 21:20:40.592259+00	2025-07-12 21:20:40.592259+00
171	ping	Automatic ping to keep database active	2025-07-13 00:12:28.217748+00	2025-07-13 00:12:28.217748+00
172	ping	Automatic ping to keep database active	2025-07-13 09:20:45.788751+00	2025-07-13 09:20:45.788751+00
173	ping	Automatic ping to keep database active	2025-07-13 21:20:49.819925+00	2025-07-13 21:20:49.819925+00
174	ping	Automatic ping to keep database active	2025-07-14 00:12:28.249718+00	2025-07-14 00:12:28.249718+00
175	ping	Automatic ping to keep database active	2025-07-14 09:21:00.011196+00	2025-07-14 09:21:00.011196+00
176	ping	Automatic ping to keep database active	2025-07-14 21:21:04.661382+00	2025-07-14 21:21:04.661382+00
177	ping	Automatic ping to keep database active	2025-07-15 00:12:28.16455+00	2025-07-15 00:12:28.16455+00
178	ping	Automatic ping to keep database active	2025-07-15 09:21:10.34054+00	2025-07-15 09:21:10.34054+00
179	ping	Automatic ping to keep database active	2025-07-15 21:21:16.561658+00	2025-07-15 21:21:16.561658+00
180	ping	Automatic ping to keep database active	2025-07-16 00:12:28.169419+00	2025-07-16 00:12:28.169419+00
181	ping	Automatic ping to keep database active	2025-07-16 09:21:22.398168+00	2025-07-16 09:21:22.398168+00
182	ping	Automatic ping to keep database active	2025-07-16 21:21:26.777508+00	2025-07-16 21:21:26.777508+00
183	ping	Automatic ping to keep database active	2025-07-17 00:12:28.395841+00	2025-07-17 00:12:28.395841+00
184	ping	Automatic ping to keep database active	2025-07-17 09:21:33.982856+00	2025-07-17 09:21:33.982856+00
185	ping	Automatic ping to keep database active	2025-07-17 21:21:39.315895+00	2025-07-17 21:21:39.315895+00
186	ping	Automatic ping to keep database active	2025-07-18 00:12:28.179942+00	2025-07-18 00:12:28.179942+00
187	ping	Automatic ping to keep database active	2025-07-18 09:21:43.671124+00	2025-07-18 09:21:43.671124+00
188	ping	Automatic ping to keep database active	2025-07-18 21:21:47.062976+00	2025-07-18 21:21:47.062976+00
189	ping	Automatic ping to keep database active	2025-07-19 00:12:28.215693+00	2025-07-19 00:12:28.215693+00
190	ping	Automatic ping to keep database active	2025-07-19 09:21:51.446941+00	2025-07-19 09:21:51.446941+00
191	ping	Automatic ping to keep database active	2025-07-19 21:21:56.061126+00	2025-07-19 21:21:56.061126+00
192	ping	Automatic ping to keep database active	2025-07-20 00:12:28.272414+00	2025-07-20 00:12:28.272414+00
193	ping	Automatic ping to keep database active	2025-07-20 09:22:02.168118+00	2025-07-20 09:22:02.168118+00
194	ping	Automatic ping to keep database active	2025-07-20 21:22:07.744237+00	2025-07-20 21:22:07.744237+00
195	ping	Automatic ping to keep database active	2025-07-21 00:12:28.392956+00	2025-07-21 00:12:28.392956+00
196	ping	Automatic ping to keep database active	2025-07-21 09:22:12.892853+00	2025-07-21 09:22:12.892853+00
197	ping	Automatic ping to keep database active	2025-07-21 21:22:18.298707+00	2025-07-21 21:22:18.298707+00
198	ping	Automatic ping to keep database active	2025-07-22 00:12:28.113815+00	2025-07-22 00:12:28.113815+00
199	ping	Automatic ping to keep database active	2025-07-22 09:22:22.322181+00	2025-07-22 09:22:22.322181+00
200	ping	Automatic ping to keep database active	2025-07-22 21:22:28.868275+00	2025-07-22 21:22:28.868275+00
201	ping	Automatic ping to keep database active	2025-07-23 00:12:28.278879+00	2025-07-23 00:12:28.278879+00
202	ping	Automatic ping to keep database active	2025-07-23 09:22:34.662869+00	2025-07-23 09:22:34.662869+00
203	ping	Automatic ping to keep database active	2025-07-23 21:22:39.929487+00	2025-07-23 21:22:39.929487+00
204	ping	Automatic ping to keep database active	2025-07-24 00:12:28.192542+00	2025-07-24 00:12:28.192542+00
205	ping	Automatic ping to keep database active	2025-07-24 09:22:44.351261+00	2025-07-24 09:22:44.351261+00
206	ping	Automatic ping to keep database active	2025-07-24 21:22:50.211308+00	2025-07-24 21:22:50.211308+00
207	ping	Automatic ping to keep database active	2025-07-25 00:12:28.156291+00	2025-07-25 00:12:28.156291+00
208	ping	Automatic ping to keep database active	2025-07-25 09:22:55.219913+00	2025-07-25 09:22:55.219913+00
209	ping	Automatic ping to keep database active	2025-07-25 21:23:00.528445+00	2025-07-25 21:23:00.528445+00
210	ping	Automatic ping to keep database active	2025-07-26 00:12:28.186879+00	2025-07-26 00:12:28.186879+00
211	ping	Automatic ping to keep database active	2025-07-26 09:23:04.245687+00	2025-07-26 09:23:04.245687+00
212	ping	Automatic ping to keep database active	2025-07-26 21:23:08.832313+00	2025-07-26 21:23:08.832313+00
213	ping	Automatic ping to keep database active	2025-07-27 00:12:28.09419+00	2025-07-27 00:12:28.09419+00
214	ping	Automatic ping to keep database active	2025-07-27 09:23:14.250313+00	2025-07-27 09:23:14.250313+00
215	ping	Automatic ping to keep database active	2025-07-27 21:23:18.895407+00	2025-07-27 21:23:18.895407+00
216	ping	Automatic ping to keep database active	2025-07-28 00:12:28.186536+00	2025-07-28 00:12:28.186536+00
217	ping	Automatic ping to keep database active	2025-07-28 09:23:24.818404+00	2025-07-28 09:23:24.818404+00
218	ping	Automatic ping to keep database active	2025-07-28 21:23:30.725946+00	2025-07-28 21:23:30.725946+00
219	ping	Automatic ping to keep database active	2025-07-29 00:12:28.209337+00	2025-07-29 00:12:28.209337+00
220	ping	Automatic ping to keep database active	2025-07-29 09:23:36.554832+00	2025-07-29 09:23:36.554832+00
221	ping	Automatic ping to keep database active	2025-07-29 21:23:41.662857+00	2025-07-29 21:23:41.662857+00
222	ping	Automatic ping to keep database active	2025-07-30 00:12:28.23821+00	2025-07-30 00:12:28.23821+00
223	ping	Automatic ping to keep database active	2025-07-30 09:23:47.091872+00	2025-07-30 09:23:47.091872+00
224	ping	Automatic ping to keep database active	2025-07-30 21:23:52.128233+00	2025-07-30 21:23:52.128233+00
225	ping	Automatic ping to keep database active	2025-07-31 00:12:28.482219+00	2025-07-31 00:12:28.482219+00
226	ping	Automatic ping to keep database active	2025-07-31 09:23:55.066441+00	2025-07-31 09:23:55.066441+00
227	ping	Automatic ping to keep database active	2025-07-31 21:24:00.294687+00	2025-07-31 21:24:00.294687+00
228	ping	Automatic ping to keep database active	2025-08-01 00:37:22.249475+00	2025-08-01 00:37:22.249475+00
229	ping	Automatic ping to keep database active	2025-08-01 09:24:05.752604+00	2025-08-01 09:24:05.752604+00
230	ping	Automatic ping to keep database active	2025-08-01 21:24:10.243036+00	2025-08-01 21:24:10.243036+00
231	ping	Automatic ping to keep database active	2025-08-02 00:37:22.117584+00	2025-08-02 00:37:22.117584+00
232	ping	Automatic ping to keep database active	2025-08-02 09:24:16.37986+00	2025-08-02 09:24:16.37986+00
233	ping	Automatic ping to keep database active	2025-08-02 21:24:21.986501+00	2025-08-02 21:24:21.986501+00
234	ping	Automatic ping to keep database active	2025-08-03 00:37:22.264665+00	2025-08-03 00:37:22.264665+00
235	ping	Automatic ping to keep database active	2025-08-03 09:24:27.252195+00	2025-08-03 09:24:27.252195+00
236	ping	Automatic ping to keep database active	2025-08-03 21:24:32.60865+00	2025-08-03 21:24:32.60865+00
237	ping	Automatic ping to keep database active	2025-08-04 00:37:22.156478+00	2025-08-04 00:37:22.156478+00
238	ping	Automatic ping to keep database active	2025-08-04 09:24:38.506037+00	2025-08-04 09:24:38.506037+00
239	ping	Automatic ping to keep database active	2025-08-04 21:24:45.102318+00	2025-08-04 21:24:45.102318+00
240	ping	Automatic ping to keep database active	2025-08-05 00:37:22.429299+00	2025-08-05 00:37:22.429299+00
241	ping	Automatic ping to keep database active	2025-08-05 09:24:50.897944+00	2025-08-05 09:24:50.897944+00
242	ping	Automatic ping to keep database active	2025-08-05 21:24:56.936126+00	2025-08-05 21:24:56.936126+00
243	ping	Automatic ping to keep database active	2025-08-06 00:37:22.223092+00	2025-08-06 00:37:22.223092+00
244	ping	Automatic ping to keep database active	2025-08-06 09:25:03.262155+00	2025-08-06 09:25:03.262155+00
245	ping	Automatic ping to keep database active	2025-08-06 21:25:08.760575+00	2025-08-06 21:25:08.760575+00
246	ping	Automatic ping to keep database active	2025-08-07 00:37:22.376095+00	2025-08-07 00:37:22.376095+00
247	ping	Automatic ping to keep database active	2025-08-07 09:25:15.728837+00	2025-08-07 09:25:15.728837+00
248	ping	Automatic ping to keep database active	2025-08-07 21:25:22.701508+00	2025-08-07 21:25:22.701508+00
249	ping	Automatic ping to keep database active	2025-08-08 00:37:22.302149+00	2025-08-08 00:37:22.302149+00
250	ping	Automatic ping to keep database active	2025-08-08 09:25:28.026512+00	2025-08-08 09:25:28.026512+00
251	ping	Automatic ping to keep database active	2025-08-08 21:25:33.307711+00	2025-08-08 21:25:33.307711+00
252	ping	Automatic ping to keep database active	2025-08-09 00:37:22.223416+00	2025-08-09 00:37:22.223416+00
253	ping	Automatic ping to keep database active	2025-08-09 09:25:38.627002+00	2025-08-09 09:25:38.627002+00
254	ping	Automatic ping to keep database active	2025-08-09 21:25:43.684827+00	2025-08-09 21:25:43.684827+00
255	ping	Automatic ping to keep database active	2025-08-10 00:37:22.163237+00	2025-08-10 00:37:22.163237+00
256	ping	Automatic ping to keep database active	2025-08-10 09:25:49.18835+00	2025-08-10 09:25:49.18835+00
257	ping	Automatic ping to keep database active	2025-08-10 21:25:55.310587+00	2025-08-10 21:25:55.310587+00
258	ping	Automatic ping to keep database active	2025-08-11 00:37:22.24805+00	2025-08-11 00:37:22.24805+00
259	ping	Automatic ping to keep database active	2025-08-11 09:26:02.864496+00	2025-08-11 09:26:02.864496+00
260	ping	Automatic ping to keep database active	2025-08-11 21:26:10.03374+00	2025-08-11 21:26:10.03374+00
261	ping	Automatic ping to keep database active	2025-08-12 00:37:22.377098+00	2025-08-12 00:37:22.377098+00
262	ping	Automatic ping to keep database active	2025-08-12 09:26:16.041685+00	2025-08-12 09:26:16.041685+00
263	ping	Automatic ping to keep database active	2025-08-12 21:26:22.162045+00	2025-08-12 21:26:22.162045+00
264	ping	Automatic ping to keep database active	2025-08-13 00:37:22.147295+00	2025-08-13 00:37:22.147295+00
265	ping	Automatic ping to keep database active	2025-08-13 09:26:27.267748+00	2025-08-13 09:26:27.267748+00
266	ping	Automatic ping to keep database active	2025-08-13 21:26:33.194952+00	2025-08-13 21:26:33.194952+00
267	ping	Automatic ping to keep database active	2025-08-14 00:37:22.185274+00	2025-08-14 00:37:22.185274+00
268	ping	Automatic ping to keep database active	2025-08-14 09:26:38.485365+00	2025-08-14 09:26:38.485365+00
269	ping	Automatic ping to keep database active	2025-08-14 21:26:44.176621+00	2025-08-14 21:26:44.176621+00
270	ping	Automatic ping to keep database active	2025-08-15 00:37:22.358313+00	2025-08-15 00:37:22.358313+00
271	ping	Automatic ping to keep database active	2025-08-15 09:26:49.546694+00	2025-08-15 09:26:49.546694+00
272	ping	Automatic ping to keep database active	2025-08-15 21:26:54.635406+00	2025-08-15 21:26:54.635406+00
273	ping	Automatic ping to keep database active	2025-08-16 00:37:22.23415+00	2025-08-16 00:37:22.23415+00
274	ping	Automatic ping to keep database active	2025-08-16 09:27:01.794074+00	2025-08-16 09:27:01.794074+00
275	ping	Automatic ping to keep database active	2025-08-16 21:27:07.259916+00	2025-08-16 21:27:07.259916+00
276	ping	Automatic ping to keep database active	2025-08-17 00:37:22.203825+00	2025-08-17 00:37:22.203825+00
277	ping	Automatic ping to keep database active	2025-08-17 09:27:13.52971+00	2025-08-17 09:27:13.52971+00
278	ping	Automatic ping to keep database active	2025-08-17 21:27:18.125981+00	2025-08-17 21:27:18.125981+00
279	ping	Automatic ping to keep database active	2025-08-18 00:37:22.149779+00	2025-08-18 00:37:22.149779+00
280	ping	Automatic ping to keep database active	2025-08-18 09:27:22.922625+00	2025-08-18 09:27:22.922625+00
281	ping	Automatic ping to keep database active	2025-08-18 21:27:29.874016+00	2025-08-18 21:27:29.874016+00
282	ping	Automatic ping to keep database active	2025-08-19 00:37:22.148742+00	2025-08-19 00:37:22.148742+00
283	ping	Automatic ping to keep database active	2025-08-19 09:27:36.186248+00	2025-08-19 09:27:36.186248+00
284	ping	Automatic ping to keep database active	2025-08-19 21:27:42.221455+00	2025-08-19 21:27:42.221455+00
285	ping	Automatic ping to keep database active	2025-08-20 00:31:02.991965+00	2025-08-20 00:31:02.991965+00
286	ping	Automatic ping to keep database active	2025-08-20 09:27:48.632287+00	2025-08-20 09:27:48.632287+00
287	ping	Automatic ping to keep database active	2025-08-20 21:27:55.935025+00	2025-08-20 21:27:55.935025+00
288	ping	Automatic ping to keep database active	2025-08-21 00:31:02.849995+00	2025-08-21 00:31:02.849995+00
289	ping	Automatic ping to keep database active	2025-08-21 09:27:59.355165+00	2025-08-21 09:27:59.355165+00
290	ping	Automatic ping to keep database active	2025-08-21 21:28:06.438115+00	2025-08-21 21:28:06.438115+00
291	ping	Automatic ping to keep database active	2025-08-22 00:31:02.866544+00	2025-08-22 00:31:02.866544+00
292	ping	Automatic ping to keep database active	2025-08-22 09:28:11.872082+00	2025-08-22 09:28:11.872082+00
293	ping	Automatic ping to keep database active	2025-08-22 21:28:17.847459+00	2025-08-22 21:28:17.847459+00
294	ping	Automatic ping to keep database active	2025-08-23 00:31:02.871388+00	2025-08-23 00:31:02.871388+00
295	ping	Automatic ping to keep database active	2025-08-23 09:28:24.91147+00	2025-08-23 09:28:24.91147+00
296	ping	Automatic ping to keep database active	2025-08-23 21:28:32.241103+00	2025-08-23 21:28:32.241103+00
297	ping	Automatic ping to keep database active	2025-08-24 00:31:02.73565+00	2025-08-24 00:31:02.73565+00
298	ping	Automatic ping to keep database active	2025-08-24 09:28:37.827093+00	2025-08-24 09:28:37.827093+00
299	ping	Automatic ping to keep database active	2025-08-24 21:28:44.986815+00	2025-08-24 21:28:44.986815+00
300	ping	Automatic ping to keep database active	2025-08-25 00:52:54.837185+00	2025-08-25 00:52:54.837185+00
301	ping	Automatic ping to keep database active	2025-08-25 09:28:50.257723+00	2025-08-25 09:28:50.257723+00
302	ping	Automatic ping to keep database active	2025-08-25 21:28:55.804879+00	2025-08-25 21:28:55.804879+00
303	ping	Automatic ping to keep database active	2025-08-26 00:52:54.860586+00	2025-08-26 00:52:54.860586+00
304	ping	Automatic ping to keep database active	2025-08-26 09:29:01.504458+00	2025-08-26 09:29:01.504458+00
305	ping	Automatic ping to keep database active	2025-08-26 21:29:07.379218+00	2025-08-26 21:29:07.379218+00
306	ping	Automatic ping to keep database active	2025-08-27 00:52:54.856688+00	2025-08-27 00:52:54.856688+00
307	ping	Automatic ping to keep database active	2025-08-27 09:29:11.660157+00	2025-08-27 09:29:11.660157+00
308	ping	Automatic ping to keep database active	2025-08-27 21:29:18.44685+00	2025-08-27 21:29:18.44685+00
309	ping	Automatic ping to keep database active	2025-08-28 00:52:55.019181+00	2025-08-28 00:52:55.019181+00
310	ping	Automatic ping to keep database active	2025-08-28 09:29:23.373107+00	2025-08-28 09:29:23.373107+00
311	ping	Automatic ping to keep database active	2025-08-28 21:29:29.392197+00	2025-08-28 21:29:29.392197+00
312	ping	Automatic ping to keep database active	2025-08-29 00:52:54.840443+00	2025-08-29 00:52:54.840443+00
313	ping	Automatic ping to keep database active	2025-08-29 09:29:34.198125+00	2025-08-29 09:29:34.198125+00
314	ping	Automatic ping to keep database active	2025-08-29 21:29:39.068595+00	2025-08-29 21:29:39.068595+00
315	ping	Automatic ping to keep database active	2025-08-30 00:52:54.808376+00	2025-08-30 00:52:54.808376+00
316	ping	Automatic ping to keep database active	2025-08-30 09:29:45.690612+00	2025-08-30 09:29:45.690612+00
317	ping	Automatic ping to keep database active	2025-08-30 21:29:51.159109+00	2025-08-30 21:29:51.159109+00
318	ping	Automatic ping to keep database active	2025-08-31 00:52:54.774759+00	2025-08-31 00:52:54.774759+00
319	ping	Automatic ping to keep database active	2025-08-31 09:29:56.023792+00	2025-08-31 09:29:56.023792+00
320	ping	Automatic ping to keep database active	2025-08-31 21:30:01.481276+00	2025-08-31 21:30:01.481276+00
321	ping	Automatic ping to keep database active	2025-09-01 00:52:54.681252+00	2025-09-01 00:52:54.681252+00
322	ping	Automatic ping to keep database active	2025-09-01 09:30:07.400942+00	2025-09-01 09:30:07.400942+00
323	ping	Automatic ping to keep database active	2025-09-01 21:30:11.853292+00	2025-09-01 21:30:11.853292+00
324	ping	Automatic ping to keep database active	2025-09-02 00:52:54.790124+00	2025-09-02 00:52:54.790124+00
325	ping	Automatic ping to keep database active	2025-09-02 09:30:19.042918+00	2025-09-02 09:30:19.042918+00
326	ping	Automatic ping to keep database active	2025-09-02 21:30:25.071175+00	2025-09-02 21:30:25.071175+00
327	ping	Automatic ping to keep database active	2025-09-03 00:52:54.345502+00	2025-09-03 00:52:54.345502+00
328	ping	Automatic ping to keep database active	2025-09-03 09:30:30.504744+00	2025-09-03 09:30:30.504744+00
329	ping	Automatic ping to keep database active	2025-09-03 21:30:36.013239+00	2025-09-03 21:30:36.013239+00
330	ping	Automatic ping to keep database active	2025-09-04 00:52:54.720027+00	2025-09-04 00:52:54.720027+00
331	ping	Automatic ping to keep database active	2025-09-04 09:30:42.769718+00	2025-09-04 09:30:42.769718+00
332	ping	Automatic ping to keep database active	2025-09-04 21:30:48.881214+00	2025-09-04 21:30:48.881214+00
333	ping	Automatic ping to keep database active	2025-09-05 00:52:54.860524+00	2025-09-05 00:52:54.860524+00
334	ping	Automatic ping to keep database active	2025-09-05 09:30:56.54711+00	2025-09-05 09:30:56.54711+00
335	ping	Automatic ping to keep database active	2025-09-05 21:31:02.548731+00	2025-09-05 21:31:02.548731+00
336	ping	Automatic ping to keep database active	2025-09-06 00:52:54.78102+00	2025-09-06 00:52:54.78102+00
337	ping	Automatic ping to keep database active	2025-09-06 09:31:06.566812+00	2025-09-06 09:31:06.566812+00
338	ping	Automatic ping to keep database active	2025-09-06 21:31:11.701639+00	2025-09-06 21:31:11.701639+00
339	ping	Automatic ping to keep database active	2025-09-07 00:52:54.845332+00	2025-09-07 00:52:54.845332+00
340	ping	Automatic ping to keep database active	2025-09-07 09:31:17.690851+00	2025-09-07 09:31:17.690851+00
341	ping	Automatic ping to keep database active	2025-09-07 21:31:24.952562+00	2025-09-07 21:31:24.952562+00
342	ping	Automatic ping to keep database active	2025-09-08 00:52:54.733108+00	2025-09-08 00:52:54.733108+00
343	ping	Automatic ping to keep database active	2025-09-08 09:31:31.880747+00	2025-09-08 09:31:31.880747+00
344	ping	Automatic ping to keep database active	2025-09-08 21:31:38.662169+00	2025-09-08 21:31:38.662169+00
345	ping	Automatic ping to keep database active	2025-09-09 00:52:54.683024+00	2025-09-09 00:52:54.683024+00
346	ping	Automatic ping to keep database active	2025-09-09 09:31:47.533436+00	2025-09-09 09:31:47.533436+00
347	ping	Automatic ping to keep database active	2025-09-09 21:31:53.963168+00	2025-09-09 21:31:53.963168+00
348	ping	Automatic ping to keep database active	2025-09-10 00:52:54.746782+00	2025-09-10 00:52:54.746782+00
349	ping	Automatic ping to keep database active	2025-09-10 09:31:59.798878+00	2025-09-10 09:31:59.798878+00
350	ping	Automatic ping to keep database active	2025-09-10 21:32:05.943583+00	2025-09-10 21:32:05.943583+00
351	ping	Automatic ping to keep database active	2025-09-11 00:52:54.689459+00	2025-09-11 00:52:54.689459+00
352	ping	Automatic ping to keep database active	2025-09-11 09:32:12.944693+00	2025-09-11 09:32:12.944693+00
353	ping	Automatic ping to keep database active	2025-09-11 21:32:20.495925+00	2025-09-11 21:32:20.495925+00
354	ping	Automatic ping to keep database active	2025-09-12 00:52:54.870577+00	2025-09-12 00:52:54.870577+00
355	ping	Automatic ping to keep database active	2025-09-12 09:32:25.309103+00	2025-09-12 09:32:25.309103+00
356	ping	Automatic ping to keep database active	2025-09-12 21:32:29.748141+00	2025-09-12 21:32:29.748141+00
357	ping	Automatic ping to keep database active	2025-09-13 00:52:54.796163+00	2025-09-13 00:52:54.796163+00
\.


--
-- Data for Name: assignment_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assignment_questions (id, assignment_id, content, type, points, options, correct_answer, created_at, updated_at) FROM stdin;
4	acf49c50-13c9-401e-8110-da65c9f4c3d7	Câu hỏi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-12 17:46:19.824+00	2025-03-12 17:46:19.824+00
5	acf49c50-13c9-401e-8110-da65c9f4c3d7	Câu hỏi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-12 17:46:19.824+00	2025-03-12 17:46:19.824+00
6	6e6b7624-6fd6-4408-825d-a746e1350169	Câu hỏi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 06:02:53.278+00	2025-03-13 06:02:53.278+00
7	6e6b7624-6fd6-4408-825d-a746e1350169	Câu hỏi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 06:02:53.278+00	2025-03-13 06:02:53.278+00
8	a6c2d509-8657-41d8-a902-6a08cf469475	Câu hỏi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 07:30:13.309+00	2025-03-13 07:30:13.309+00
9	a6c2d509-8657-41d8-a902-6a08cf469475	Câu hỏi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 07:30:13.309+00	2025-03-13 07:30:13.309+00
10	efc5beaf-e8f7-4b99-9903-a33925502c89	Câu hỏi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 07:36:59.469+00	2025-03-13 07:36:59.469+00
11	efc5beaf-e8f7-4b99-9903-a33925502c89	Câu hỏi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 07:36:59.469+00	2025-03-13 07:36:59.469+00
12	ced581ce-dc6b-4b05-8c58-fd811fc0da53	Câu hỏi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 08:00:36.353+00	2025-03-13 08:00:36.353+00
13	ced581ce-dc6b-4b05-8c58-fd811fc0da53	Câu hỏi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 08:00:36.353+00	2025-03-13 08:00:36.353+00
14	fa6c67af-421d-4b01-b9e5-4b951ad7ebc5	Câu hỏi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 08:30:22.47+00	2025-03-13 08:30:22.47+00
15	fa6c67af-421d-4b01-b9e5-4b951ad7ebc5	Câu hỏi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 08:30:22.47+00	2025-03-13 08:30:22.47+00
16	077e6dd7-841d-48e8-b2af-439b3e119050	Câu hỏi mẫu 1?	multiple_choice	10.00	"[\\"Đáp án A\\",\\"Đáp án B\\",\\"Đáp án C\\",\\"Đáp án D\\"]"	A	2025-06-17 04:36:29.92+00	2025-06-17 04:36:29.92+00
17	077e6dd7-841d-48e8-b2af-439b3e119050	Câu hỏi mẫu 2?	multiple_choice	10.00	"[\\"Đáp án A\\",\\"Đáp án B\\",\\"Đáp án C\\",\\"Đáp án D\\"]"	B	2025-06-17 04:36:29.92+00	2025-06-17 04:36:29.92+00
18	3322c10c-88c5-480a-ae24-ce1e78671da8	Câu hỏi mẫu 1?	multiple_choice	10.00	"[\\"Đáp án A\\",\\"Đáp án B\\",\\"Đáp án C\\",\\"Đáp án D\\"]"	A	2025-06-19 14:11:55.681+00	2025-06-19 14:11:55.681+00
19	3322c10c-88c5-480a-ae24-ce1e78671da8	Câu hỏi mẫu 2?	multiple_choice	10.00	"[\\"Đáp án A\\",\\"Đáp án B\\",\\"Đáp án C\\",\\"Đáp án D\\"]"	B	2025-06-19 14:11:55.681+00	2025-06-19 14:11:55.681+00
20	8f148d3d-c949-498e-8b79-c92f5039abc6	Câu hỏi mẫu 1?	multiple_choice	10.00	"[\\"Đáp án A\\",\\"Đáp án B\\",\\"Đáp án C\\",\\"Đáp án D\\"]"	A	2025-06-19 14:24:39.03+00	2025-06-19 14:24:39.03+00
21	8f148d3d-c949-498e-8b79-c92f5039abc6	Câu hỏi mẫu 2?	multiple_choice	10.00	"[\\"Đáp án A\\",\\"Đáp án B\\",\\"Đáp án C\\",\\"Đáp án D\\"]"	B	2025-06-19 14:24:39.03+00	2025-06-19 14:24:39.03+00
\.


--
-- Data for Name: assignment_submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assignment_submissions (id, assignment_id, student_id, content, file_url, score, submitted_at, graded_at, feedback, created_at, updated_at, answers) FROM stdin;
c63b4b27-0e21-45d8-9ff7-92f95f716fc5	a6c2d509-8657-41d8-a902-6a08cf469475	6477eb40-4562-4138-97e1-56d9cea1bd3d	\N	\N	2.00	2025-03-13 07:34:53.869+00	2025-03-13 07:34:53.869+00	\N	2025-03-13 07:34:54.498199+00	2025-03-13 07:34:54.498199+00	{"8": "B. 2", "9": "C. 4"}
a8a8e4c7-78b2-4e30-9153-9b5e5be51bb1	efc5beaf-e8f7-4b99-9903-a33925502c89	6477eb40-4562-4138-97e1-56d9cea1bd3d	\N	\N	2.00	2025-03-13 07:37:18.208+00	2025-03-13 07:37:18.208+00	\N	2025-03-13 07:37:18.844678+00	2025-03-13 07:37:18.844678+00	{"10": "B. 2", "11": "C. 4"}
2b4d8139-6017-4db6-b0be-2a39f0ad0e16	ced581ce-dc6b-4b05-8c58-fd811fc0da53	6477eb40-4562-4138-97e1-56d9cea1bd3d	\N	\N	100.00	2025-03-13 08:28:09.116+00	2025-03-13 08:28:09.116+00	\N	2025-03-13 08:28:09.724562+00	2025-03-13 08:28:09.724562+00	{"12": "B. 2", "13": "C. 4"}
927b46e5-2b31-4139-8ab5-cfd60b38c29b	fa6c67af-421d-4b01-b9e5-4b951ad7ebc5	6477eb40-4562-4138-97e1-56d9cea1bd3d	\N	\N	2.00	2025-03-13 08:30:55.184+00	2025-03-13 08:30:55.184+00	\N	2025-03-13 08:30:55.743573+00	2025-03-13 08:30:55.743573+00	{"14": "B. 2", "15": "C. 4"}
ecf4fc70-9520-4ab9-b8a9-24495205b485	0e1a6189-5a25-494c-bd47-9fc0a83aa5a0	6477eb40-4562-4138-97e1-56d9cea1bd3d	hi	\N	1.00	2025-03-13 08:56:15.548+00	2025-03-13 08:57:52.936+00	1	2025-03-13 08:56:16.099799+00	2025-03-13 08:56:16.099799+00	{}
edcefe1c-c876-43d0-ab06-2fa1c6b1ebe7	6886d5b2-104d-4d57-a585-9ec6a58d5218	6477eb40-4562-4138-97e1-56d9cea1bd3d	hi	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/submissions/assignments/6886d5b2-104d-4d57-a585-9ec6a58d5218/6477eb40-4562-4138-97e1-56d9cea1bd3d/1741857593826.docx	\N	2025-03-13 09:19:54.847+00	\N	\N	2025-03-13 09:19:55.324314+00	2025-03-13 09:19:55.324314+00	{}
2e6dcff0-0dc6-407c-9be3-2303cb10690e	425e42ca-355e-4e94-ac53-d983e38135eb	e368b85d-7038-4211-be16-c959c7931de0	\N	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/submissions/assignments/425e42ca-355e-4e94-ac53-d983e38135eb/e368b85d-7038-4211-be16-c959c7931de0/1750341745264.docx	\N	2025-06-19 14:02:30.736+00	\N	\N	2025-06-19 14:02:32.124065+00	2025-06-19 14:02:32.124065+00	{}
d3738436-9b8d-4d95-b726-510874f07e9d	273488b1-4a2a-4c94-b78a-66192dace7d3	3ada3240-643f-4735-b17d-39fc4ec262a2	abc	\N	\N	2025-08-24 06:57:36.586+00	\N	\N	2025-08-24 06:57:36.746029+00	2025-08-24 06:57:36.746029+00	{}
\.


--
-- Data for Name: assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assignments (id, class_id, title, description, due_date, total_points, file_url, created_at, updated_at, type) FROM stdin;
f5e9d3b8-f2b8-45ee-bf5c-e471fbd234a7	aaf54224-49e8-45a4-93ba-e3f2aae82827	Test	Test	2025-03-13 05:38:00+00	100.00	\N	2025-03-12 17:43:48.499355+00	2025-03-12 17:43:48.499355+00	multiple_choice
3e4eacc5-4625-4b33-a183-7e80398e9f82	aaf54224-49e8-45a4-93ba-e3f2aae82827	Test	Test	2025-03-13 05:38:00+00	100.00	\N	2025-03-12 17:45:34.811882+00	2025-03-12 17:45:34.811882+00	multiple_choice
acf49c50-13c9-401e-8110-da65c9f4c3d7	aaf54224-49e8-45a4-93ba-e3f2aae82827	Test	Test	2025-03-13 05:38:00+00	100.00	\N	2025-03-12 17:46:18.447848+00	2025-03-12 17:46:18.447848+00	multiple_choice
6c16e41b-9a04-4ef3-bbf4-a8896a065a08	aaf54224-49e8-45a4-93ba-e3f2aae82827	KTPM	KTPM	2025-03-13 01:13:00+00	100.00	\N	2025-03-13 00:14:01.392143+00	2025-03-13 00:14:01.392143+00	essay
6e6b7624-6fd6-4408-825d-a746e1350169	aaf54224-49e8-45a4-93ba-e3f2aae82827	SV VINH	SV VINH	2025-03-15 19:02:00+00	100.00	\N	2025-03-13 06:02:53.803133+00	2025-03-13 06:02:53.803133+00	multiple_choice
c6321c40-e8fa-4c40-9682-c721545947cd	aaf54224-49e8-45a4-93ba-e3f2aae82827	Test 1	Test 1	2025-03-13 18:20:00+00	100.00	\N	2025-03-13 07:20:42.564864+00	2025-03-13 07:20:42.564864+00	essay
a6c2d509-8657-41d8-a902-6a08cf469475	aaf54224-49e8-45a4-93ba-e3f2aae82827	Test	Test	2025-03-13 17:38:00+00	100.00	\N	2025-03-13 07:30:13.656132+00	2025-03-13 07:30:13.656132+00	multiple_choice
efc5beaf-e8f7-4b99-9903-a33925502c89	aaf54224-49e8-45a4-93ba-e3f2aae82827	Tester ne cu	Tester ne cu	2025-03-20 19:36:00+00	100.00	\N	2025-03-13 07:36:59.794114+00	2025-03-13 07:36:59.794114+00	multiple_choice
ffb9e992-be1c-4e13-abee-d5565a9cd9a9	aaf54224-49e8-45a4-93ba-e3f2aae82827	CON CHO NGOC TUAN	CON CHO NGOC TUAN	2025-03-13 20:39:00+00	100.00	\N	2025-03-13 07:39:31.448775+00	2025-03-13 07:39:31.448775+00	essay
ced581ce-dc6b-4b05-8c58-fd811fc0da53	aaf54224-49e8-45a4-93ba-e3f2aae82827	Test 2	Test 2	2025-03-13 21:00:00+00	100.00	\N	2025-03-13 08:00:36.630166+00	2025-03-13 08:00:36.630166+00	multiple_choice
fa6c67af-421d-4b01-b9e5-4b951ad7ebc5	aaf54224-49e8-45a4-93ba-e3f2aae82827	Test 3	Test 3	2025-03-22 15:30:00+00	100.00	\N	2025-03-13 08:30:22.744686+00	2025-03-13 08:30:22.744686+00	multiple_choice
0e1a6189-5a25-494c-bd47-9fc0a83aa5a0	aaf54224-49e8-45a4-93ba-e3f2aae82827	Test 3	Test 3	2025-03-22 15:30:00+00	100.00	\N	2025-03-13 08:32:33.612439+00	2025-03-13 08:32:33.612439+00	essay
6886d5b2-104d-4d57-a585-9ec6a58d5218	aaf54224-49e8-45a4-93ba-e3f2aae82827	KTPMKTPM	KTPMKTPM	2025-03-13 23:19:00+00	100.00	\N	2025-03-13 09:19:26.822161+00	2025-03-13 09:19:26.822161+00	essay
a62ae5e5-5edc-469f-89e3-67807eb8e120	5f9c94a6-6bb5-4a65-a0ee-2b9fce239e5e	123	12312	2025-03-20 17:00:00+00	100.00	\N	2025-03-14 10:27:08.764681+00	2025-03-14 10:27:08.764681+00	essay
49005d91-5e39-46de-8acb-c2102180a5c4	5f9c94a6-6bb5-4a65-a0ee-2b9fce239e5e	123	12312	2025-03-20 17:00:00+00	100.00	\N	2025-03-14 10:30:26.112601+00	2025-03-14 10:30:26.112601+00	essay
077e6dd7-841d-48e8-b2af-439b3e119050	aaf54224-49e8-45a4-93ba-e3f2aae82827	Test	Test	2025-06-18 11:36:00+00	100.00	\N	2025-06-17 04:36:29.126819+00	2025-06-17 04:36:29.126819+00	multiple_choice
425e42ca-355e-4e94-ac53-d983e38135eb	aaf54224-49e8-45a4-93ba-e3f2aae82827	RESPONSIVE TESTING	RESPONSIVE TESTING 123	2025-06-21 20:53:00+00	100.00	\N	2025-06-19 13:53:15.941749+00	2025-06-19 13:53:15.941749+00	essay
3322c10c-88c5-480a-ae24-ce1e78671da8	aaf54224-49e8-45a4-93ba-e3f2aae82827	RESPONSIVE TESTING	RESPONSIVE TESTING 123	2025-06-21 21:11:00+00	100.00	\N	2025-06-19 14:11:56.444894+00	2025-06-19 14:11:56.444894+00	multiple_choice
8f148d3d-c949-498e-8b79-c92f5039abc6	aaf54224-49e8-45a4-93ba-e3f2aae82827	RESPONSIVE TESTING 2	RESPONSIVE TESTING 2345	2025-07-04 21:24:00+00	100.00	\N	2025-06-19 14:24:39.800861+00	2025-07-31 15:55:15.874+00	essay
273488b1-4a2a-4c94-b78a-66192dace7d3	a9ba15a7-9166-49b7-aec8-aa12def74b8f	Bài Tập A	abc	2025-09-09 12:00:00+00	100.00	\N	2025-08-24 06:27:18.242077+00	2025-08-24 06:27:18.242077+00	essay
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classes (id, subject_id, teacher_id, code, name, semester, academic_year, status, created_at, updated_at) FROM stdin;
aaf54224-49e8-45a4-93ba-e3f2aae82827	f7bdff59-8976-44ba-910d-52708eb4b387	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	001	KTPM	2	2025-2026	active	2025-02-21 10:38:44.507435+00	2025-02-21 10:38:44.507435+00
5f9c94a6-6bb5-4a65-a0ee-2b9fce239e5e	7d453c44-5359-4087-a27e-5ed40dd80c04	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	002	toán cao cấp	1	2024-2025	active	2025-02-23 07:56:46.187414+00	2025-02-23 07:56:46.187414+00
a9ba15a7-9166-49b7-aec8-aa12def74b8f	92318b53-7293-4783-9999-cc03c143caab	a0740794-4a85-4037-9340-89567cd20f04	123	Lớp A - Thầy Nguyễn Văn A	1	2025	active	2025-08-24 06:22:06.078308+00	2025-08-24 06:22:06.078308+00
0537afe0-7b9d-49de-979a-cc151665eebe	f7bdff59-8976-44ba-910d-52708eb4b387	a0740794-4a85-4037-9340-89567cd20f04	08CLC	TT Hệ thống điện thân xe 08CLC	1	2025 - 2026	active	2025-09-13 03:36:57.300967+00	2025-09-13 03:36:57.300967+00
\.


--
-- Data for Name: enrollments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.enrollments (id, class_id, student_id, status, created_at, updated_at) FROM stdin;
c0dc63ec-734c-4a52-8a8f-45f849651f95	aaf54224-49e8-45a4-93ba-e3f2aae82827	6477eb40-4562-4138-97e1-56d9cea1bd3d	enrolled	2025-03-13 04:47:39.666+00	2025-03-13 04:47:39.666+00
fc358116-8098-41ab-8808-24a7fd351507	aaf54224-49e8-45a4-93ba-e3f2aae82827	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	enrolled	2025-06-10 09:34:08.969+00	2025-06-10 09:34:08.969+00
bdacae8b-6b0b-45f4-aafd-0da34041417e	aaf54224-49e8-45a4-93ba-e3f2aae82827	e368b85d-7038-4211-be16-c959c7931de0	enrolled	2025-06-17 04:01:46.479+00	2025-06-17 04:01:46.479+00
2b3358e7-70c1-47d5-9ad7-d3985832a1d9	5f9c94a6-6bb5-4a65-a0ee-2b9fce239e5e	e368b85d-7038-4211-be16-c959c7931de0	enrolled	2025-06-17 04:01:53.4+00	2025-06-17 04:01:53.4+00
a59d27ec-9e9c-4c8a-80d9-c11039522a73	0537afe0-7b9d-49de-979a-cc151665eebe	ab2f529a-dda7-4dad-8d6f-27572f4871c1	enrolled	2025-09-13 04:30:27.785+00	2025-09-13 04:30:27.785+00
\.


--
-- Data for Name: exam_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exam_questions (id, exam_id, content, type, points, options, correct_answer, created_at, updated_at) FROM stdin;
de6727e3-4994-4b76-b422-0272cdd676fc	d81f5313-5f72-48ca-a50b-8beb332925d2	vinh có đẹp trai không	essay	1.00	\N	không	2025-03-02 01:55:04.328+00	2025-03-02 01:55:04.328+00
8cd896c7-6d8c-4f3e-9058-06eaed8b4b39	36b8bc63-fae9-46a8-8e58-fb8258fd1afe	thịnh ngu 	essay	1.00	\N	sure 8\n	2025-03-02 02:19:37.453+00	2025-03-02 03:18:45.531+00
a8528c2e-a8c2-45b4-846d-fac017996297	36b8bc63-fae9-46a8-8e58-fb8258fd1afe	số bé nhất	multiple_choice	1.00	["1", "2", "3", "4"]	4	2025-03-02 02:15:14.485+00	2025-03-02 03:29:52.007+00
1c88e02b-9a95-4edc-a532-6ca25bccd594	50811f3a-0104-4f9c-881a-671bd78a8a95	Câu hỏi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-12 12:11:47.593+00	2025-03-12 12:11:47.593+00
b0b85e02-be65-4777-9dc3-d8bda65f167b	50811f3a-0104-4f9c-881a-671bd78a8a95	Câu hỏi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-12 12:11:47.593+00	2025-03-12 12:11:47.593+00
77d8cadb-1709-4957-8ee1-bdad787a07f6	1f5a3d60-be45-43fd-a245-723f893097e1	Câu hỏi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 06:54:09.926333+00	2025-03-13 06:54:09.926333+00
b52420bd-9069-4113-8406-02a27d868227	1f5a3d60-be45-43fd-a245-723f893097e1	Câu hỏi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 06:54:10.232158+00	2025-03-13 06:54:10.232158+00
8313bdcf-f003-4647-9550-72b47817f8bc	9a30d932-ab3f-41bf-906b-cd1fcdd6ce86	Câu hỏi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 07:13:36.377011+00	2025-03-13 07:13:36.377011+00
afc202f3-61ba-422a-81dd-918b3c905093	9a30d932-ab3f-41bf-906b-cd1fcdd6ce86	Câu hỏi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 07:13:36.655471+00	2025-03-13 07:13:36.655471+00
186467aa-3278-4b1b-843c-c9ad3e2c1ee7	4533fdb7-af3f-4fff-9a7f-df6f286a36e8	Câu hỏi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 07:16:38.665901+00	2025-03-13 07:16:38.665901+00
04c61995-7bd5-4254-8cba-f80dbfd9c839	4533fdb7-af3f-4fff-9a7f-df6f286a36e8	Câu hỏi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 07:16:38.957732+00	2025-03-13 07:16:38.957732+00
c75abbd4-a4cb-40f7-a72e-2296e3af795e	ab945f25-110f-4119-bdbe-cb339ca2bd9b	Con cho ngoc tuan	essay	1.00	\N	Con cho ngoc tuan	2025-03-13 07:17:48.313+00	2025-03-13 07:17:48.313+00
5cff9703-5d2d-4022-9c4a-2d80a643f44f	3655bf81-20c2-43a1-a6b2-da4d72054b30	Testing	essay	1.00	\N	Testing	2025-03-13 08:35:09.79+00	2025-03-13 08:35:09.79+00
c3b19741-92c3-42ca-ae8f-380939ec2ce3	271dd5c5-1722-47b7-ba91-c820ae14a516	HUHU	essay	1.00	\N	HUHU	2025-03-13 09:00:41.641+00	2025-03-13 09:00:41.641+00
84aad881-753b-4c03-a6df-1c65f8e6aedf	7f142382-b919-416b-9ba4-ba90b5ade693	Câu hỏi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 09:15:45.000405+00	2025-03-13 09:15:45.000405+00
48e68065-8940-4999-93ca-676f705fc6ec	7f142382-b919-416b-9ba4-ba90b5ade693	Câu hỏi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 09:15:45.27192+00	2025-03-13 09:15:45.27192+00
dd774f16-92b5-4fa9-8ab0-cb3491fcfca6	491cc00e-437e-42b9-961e-08416385d196	ASD	essay	1.00	\N	ASD	2025-03-13 09:16:48.186+00	2025-03-13 09:16:48.186+00
a5047063-6e86-4b3a-b02b-c2cd29bdb897	eec01f13-aa8d-4c36-ab2f-9adac08b0aa4	Câu hỏi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 09:18:16.348032+00	2025-03-13 09:18:16.348032+00
4b8dcf28-84ac-4db3-a7cc-ace875fdaf93	eec01f13-aa8d-4c36-ab2f-9adac08b0aa4	Câu hỏi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 09:18:16.610738+00	2025-03-13 09:18:16.610738+00
532059f6-275e-44af-9225-98946b5a6ad1	38a79e56-da62-4128-9570-3bd576b0e891	Câu hỏi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-06-17 04:16:04.302878+00	2025-06-17 04:16:04.302878+00
21f46060-da93-4ebe-88ed-8e952e690a4b	38a79e56-da62-4128-9570-3bd576b0e891	Câu hỏi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-06-17 04:16:04.926668+00	2025-06-17 04:16:04.926668+00
\.


--
-- Data for Name: exam_submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exam_submissions (id, exam_id, student_id, answers, score, submitted_at, graded_at, feedback, created_at, updated_at, file_url, content) FROM stdin;
2288d281-ceb4-44a8-833d-013bc70e5e3b	1f5a3d60-be45-43fd-a245-723f893097e1	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"77d8cadb-1709-4957-8ee1-bdad787a07f6": "B. 2", "b52420bd-9069-4113-8406-02a27d868227": "C. 4"}	\N	2025-03-13 07:04:27.136+00	\N	\N	2025-03-13 07:04:27.847181+00	2025-03-13 07:04:27.847181+00	\N	\N
a6824a27-8725-4066-8f4d-d29162c511c2	9a30d932-ab3f-41bf-906b-cd1fcdd6ce86	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"8313bdcf-f003-4647-9550-72b47817f8bc": "B. 2", "afc202f3-61ba-422a-81dd-918b3c905093": "C. 4"}	2.00	2025-03-13 07:13:51.816+00	2025-03-13 07:13:51.816+00	\N	2025-03-13 07:13:52.531743+00	2025-03-13 07:13:52.531743+00	\N	\N
9071e634-f857-4ce1-8f1e-3664f68373be	ab945f25-110f-4119-bdbe-cb339ca2bd9b	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"c75abbd4-a4cb-40f7-a72e-2296e3af795e": "Con cho ngoc tuan"}	\N	2025-03-13 07:18:44.703+00	\N	\N	2025-03-13 07:18:45.379486+00	2025-03-13 07:18:45.379486+00	\N	\N
d11e5774-29dc-4229-9708-303e17855385	4533fdb7-af3f-4fff-9a7f-df6f286a36e8	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"04c61995-7bd5-4254-8cba-f80dbfd9c839": "C. 4", "186467aa-3278-4b1b-843c-c9ad3e2c1ee7": "B. 2"}	\N	2025-03-13 09:12:51.106+00	\N	\N	2025-03-13 09:12:51.618805+00	2025-03-13 09:12:51.618805+00	\N	\N
2d5e2090-ec7c-477e-a815-db87ce3892ee	7f142382-b919-416b-9ba4-ba90b5ade693	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"48e68065-8940-4999-93ca-676f705fc6ec": "C. 4", "84aad881-753b-4c03-a6df-1c65f8e6aedf": "B. 2"}	2.00	2025-03-13 09:16:17.498+00	2025-03-13 09:16:17.498+00	\N	2025-03-13 09:16:18.024809+00	2025-03-13 09:16:18.024809+00	\N	\N
1d9eeddc-18d9-4f7f-a6bd-de70eab3c866	491cc00e-437e-42b9-961e-08416385d196	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"dd774f16-92b5-4fa9-8ab0-cb3491fcfca6": "ASD"}	0.00	2025-03-13 09:17:06.365+00	2025-03-13 09:17:06.365+00	\N	2025-03-13 09:17:06.839282+00	2025-03-13 09:17:06.839282+00	\N	\N
b86de749-790a-415e-a294-98f5e031b32f	eec01f13-aa8d-4c36-ab2f-9adac08b0aa4	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"4b8dcf28-84ac-4db3-a7cc-ace875fdaf93": "C. 4", "a5047063-6e86-4b3a-b02b-c2cd29bdb897": "B. 2"}	2.00	2025-03-13 09:18:38.384+00	2025-03-13 09:18:38.384+00	\N	2025-03-13 09:18:38.831754+00	2025-03-13 09:18:38.831754+00	\N	\N
189226f8-b076-4b89-8952-3e1278158d94	271dd5c5-1722-47b7-ba91-c820ae14a516	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"c3b19741-92c3-42ca-ae8f-380939ec2ce3": "huhu"}	1.00	2025-03-13 09:01:11.279+00	2025-06-19 06:48:55.567+00	huhu	2025-03-13 09:01:11.753335+00	2025-03-13 09:01:11.753335+00	\N	\N
291a4488-c530-4adc-8ce6-060873171150	38a79e56-da62-4128-9570-3bd576b0e891	e368b85d-7038-4211-be16-c959c7931de0	{"21f46060-da93-4ebe-88ed-8e952e690a4b": "A. 2", "532059f6-275e-44af-9225-98946b5a6ad1": "C. 3"}	0.00	2025-06-19 13:41:31.393+00	2025-06-20 04:37:54.327+00		2025-06-19 13:41:32.452847+00	2025-06-19 13:41:32.452847+00	\N	\N
39b75a5e-49e4-44dc-b123-c72442597c58	3655bf81-20c2-43a1-a6b2-da4d72054b30	e368b85d-7038-4211-be16-c959c7931de0	{"5cff9703-5d2d-4022-9c4a-2d80a643f44f": "cc"}	19.00	2025-03-23 08:31:08.683+00	2025-07-31 15:22:27.155+00		2025-03-23 08:31:12.459865+00	2025-03-23 08:31:12.459865+00	\N	\N
d331b8a8-a576-4fe4-a069-2c25c2f16fac	3655bf81-20c2-43a1-a6b2-da4d72054b30	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"5cff9703-5d2d-4022-9c4a-2d80a643f44f": "Test"}	100.00	2025-03-13 08:42:25.636+00	2025-07-31 15:22:36.779+00		2025-03-13 08:42:26.211347+00	2025-03-13 08:42:26.211347+00	\N	\N
d0b40bfd-878f-4672-a2a9-1e33746a479e	7f142382-b919-416b-9ba4-ba90b5ade693	e368b85d-7038-4211-be16-c959c7931de0	{"48e68065-8940-4999-93ca-676f705fc6ec": "C. 4", "84aad881-753b-4c03-a6df-1c65f8e6aedf": "B. 2"}	10.00	2025-03-23 08:30:50.692+00	2025-07-31 15:36:58.587+00		2025-03-23 08:30:54.9083+00	2025-03-23 08:30:54.9083+00	\N	\N
\.


--
-- Data for Name: exams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exams (id, class_id, title, description, type, duration, total_points, start_time, end_time, status, created_at, updated_at) FROM stdin;
1f5a3d60-be45-43fd-a245-723f893097e1	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing 5	Testing 5	quiz	60	100.00	2025-03-13 13:36:00+00	2025-03-13 19:36:00+00	completed	2025-03-13 06:36:57.734+00	2025-03-13 06:36:57.734+00
26d3662f-889b-420a-a3da-2c50e41c654c	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing 2	Testing 2	quiz	60	100.00	2025-03-13 13:29:00+00	2025-03-13 17:29:00+00	completed	2025-03-13 06:29:33.318+00	2025-03-13 06:29:33.318+00
271dd5c5-1722-47b7-ba91-c820ae14a516	aaf54224-49e8-45a4-93ba-e3f2aae82827	CON CHO NGOC TUAN	CON CHO NGOC TUAN	quiz	60	100.00	2025-03-13 16:00:00+00	2025-03-13 20:00:00+00	completed	2025-03-13 09:00:32.098+00	2025-03-13 09:00:32.098+00
3655bf81-20c2-43a1-a6b2-da4d72054b30	aaf54224-49e8-45a4-93ba-e3f2aae82827	TEST	TEST	quiz	60	100.00	2025-03-13 15:36:00+00	2025-03-29 15:34:00+00	completed	2025-03-13 08:34:59.19+00	2025-03-13 08:34:59.19+00
36776f71-44b9-41e4-becd-189c67b2e916	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing 3	Testing 3	quiz	60	100.00	2025-03-13 05:31:00+00	2025-03-31 08:31:00+00	completed	2025-03-13 06:31:07.829+00	2025-03-13 06:31:07.829+00
36b8bc63-fae9-46a8-8e58-fb8258fd1afe	5f9c94a6-6bb5-4a65-a0ee-2b9fce239e5e	siêu khó	siêu siêu khó	midterm	60	100.00	2025-02-26 15:19:00+00	2025-02-27 15:19:00+00	completed	2025-02-26 08:19:23.235+00	2025-02-26 08:19:23.236+00
4533fdb7-af3f-4fff-9a7f-df6f286a36e8	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing 7	Testing 7	quiz	60	100.00	2025-03-13 14:16:00+00	2025-03-13 19:16:00+00	completed	2025-03-13 07:16:31.849+00	2025-03-13 07:16:31.849+00
491cc00e-437e-42b9-961e-08416385d196	aaf54224-49e8-45a4-93ba-e3f2aae82827	KTPMASD	KTPMASD	quiz	60	100.00	2025-03-13 02:16:00+00	2025-05-31 07:16:00+00	completed	2025-03-13 09:16:40.865+00	2025-03-13 09:16:40.865+00
50811f3a-0104-4f9c-881a-671bd78a8a95	aaf54224-49e8-45a4-93ba-e3f2aae82827	CON CHO VINH	ASDA	quiz	30	100.00	2025-03-13 01:20:00+00	2025-03-13 01:58:00+00	completed	2025-03-12 11:38:13.474+00	2025-03-12 11:38:13.474+00
7f142382-b919-416b-9ba4-ba90b5ade693	aaf54224-49e8-45a4-93ba-e3f2aae82827	Tester 10	Tester 10	quiz	60	100.00	2025-03-13 16:15:00+00	2025-03-29 16:15:00+00	completed	2025-03-13 09:15:40.337+00	2025-03-13 09:15:40.337+00
8209bb19-9fc4-4771-80b1-bd678e6201e3	aaf54224-49e8-45a4-93ba-e3f2aae82827	KTPM	KTPM	final	60	100.00	2025-02-27 09:47:00+00	2025-02-28 09:47:00+00	completed	2025-02-27 02:47:42.193+00	2025-02-27 02:47:42.193+00
928acdd9-d12b-48d3-84ec-3b1c3dbaf798	aaf54224-49e8-45a4-93ba-e3f2aae82827	KTPM	KTPM	quiz	10	100.00	2025-02-27 07:48:00+00	2025-02-27 07:58:00+00	completed	2025-02-27 00:48:46.582+00	2025-02-27 00:48:46.582+00
9a30d932-ab3f-41bf-906b-cd1fcdd6ce86	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing 6	Testing 6	quiz	60	100.00	2025-03-13 13:38:00+00	2025-03-13 16:38:00+00	completed	2025-03-13 06:38:13.511+00	2025-03-13 06:38:13.511+00
ab945f25-110f-4119-bdbe-cb339ca2bd9b	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing 8	Testing 8	quiz	60	100.00	2025-03-13 14:17:00+00	2025-03-13 19:17:00+00	completed	2025-03-13 07:17:39.873+00	2025-03-13 07:17:39.874+00
b76117de-0b65-408d-92fe-3e545606c470	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing 4	Testing 4	quiz	60	100.00	2025-03-13 13:32:00+00	2025-03-13 19:33:00+00	completed	2025-03-13 06:33:03.887+00	2025-03-13 06:33:03.887+00
c942eb00-cc3b-4be7-b23c-d4e2933cdc41	aaf54224-49e8-45a4-93ba-e3f2aae82827	SV VINH	SV VINH	quiz	60	100.00	2025-03-13 13:03:00+00	2025-03-13 21:03:00+00	completed	2025-03-13 06:04:02.156+00	2025-03-13 06:04:02.156+00
d81f5313-5f72-48ca-a50b-8beb332925d2	5f9c94a6-6bb5-4a65-a0ee-2b9fce239e5e	123	12312	quiz	60	100.00	2025-02-24 18:41:00+00	2025-02-25 18:41:00+00	completed	2025-02-24 11:41:40.682+00	2025-02-24 11:41:40.682+00
eec01f13-aa8d-4c36-ab2f-9adac08b0aa4	aaf54224-49e8-45a4-93ba-e3f2aae82827	ADSDASD	ADSDASD	quiz	60	100.00	2025-03-13 02:18:00+00	2025-03-27 07:18:00+00	completed	2025-03-13 09:18:12.722+00	2025-03-13 09:18:12.722+00
f0b94c97-4a5c-4907-8bf1-4259492ff710	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing	Testing	quiz	60	100.00	2025-03-13 13:23:00+00	2025-03-13 20:23:00+00	completed	2025-03-13 06:24:15.845+00	2025-03-13 06:24:15.845+00
38a79e56-da62-4128-9570-3bd576b0e891	aaf54224-49e8-45a4-93ba-e3f2aae82827	TEWST	TEWSTTEWST	final	60	100.00	2025-06-17 11:15:00+00	2025-06-20 11:15:00+00	completed	2025-06-17 04:15:46.338+00	2025-06-17 04:15:46.339+00
\.


--
-- Data for Name: lectures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lectures (id, class_id, title, description, file_url, file_type, file_size, download_count, created_at, updated_at, original_filename) FROM stdin;
82163c1e-64b9-47bf-b3b7-146e00c5312d	aaf54224-49e8-45a4-93ba-e3f2aae82827	Chỉnh sửa tạo bài giảng 2	Chỉnh sửa tạo bài giảng 2	blob:http://localhost:3000/c3bc4b68-a674-46bf-8987-d84db63a1258	application/vnd.openxmlformats-officedocument.wordprocessingml.document	670427	0	2025-03-15 09:48:29.657+00	2025-03-15 09:48:29.657+00	\N
f4aa5a54-3230-47fd-9ab6-41ce774f8867	aaf54224-49e8-45a4-93ba-e3f2aae82827	Link bài 1	Test	https://www.youtube.com/watch?v=q23RCXNfZUM	video	0	0	2025-03-15 09:31:00.5365+00	2025-03-15 09:31:00.5365+00	\N
b58149db-6104-419f-b015-835febe2c11f	aaf54224-49e8-45a4-93ba-e3f2aae82827	Chỉnh sửa tạo bài giảng	Chỉnh sửa tạo bài giảng	blob:http://localhost:3000/49d15b1f-8f2c-4b65-b6ac-73c7ebfb6868	application/vnd.openxmlformats-officedocument.wordprocessingml.document	18884	0	2025-03-15 09:46:09.489+00	2025-03-15 09:46:09.489+00	\N
ef80992a-536a-476e-9b43-64410e10a50c	aaf54224-49e8-45a4-93ba-e3f2aae82827	Chỉnh sửa tạo bài giảng 3	Chỉnh sửa tạo bài giảng 3	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/tkktk6lkly.pdf	application/pdf	98273	0	2025-03-15 09:48:55.25+00	2025-03-15 09:48:55.25+00	\N
67d31394-4287-4b7f-b881-9e61381fe8d0	aaf54224-49e8-45a4-93ba-e3f2aae82827	1	1	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/uxuh8ef3cp.docx|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/anwlne2psws.pdf	application/vnd.openxmlformats-officedocument.wordprocessingml.document|||application/pdf	15824	0	2025-06-10 11:22:34.115739+00	2025-06-10 11:22:34.115739+00	\N
a325b81b-729d-4a2f-adaf-c5fb2d7a9433	aaf54224-49e8-45a4-93ba-e3f2aae82827	TEST	TEST	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/hd7ta3d6jnu.docx|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/0dux16dgpd2.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document|||application/vnd.openxmlformats-officedocument.wordprocessingml.document	3280687	0	2025-06-13 04:25:27.226887+00	2025-06-13 04:25:27.226887+00	\N
1372b476-db45-4e8a-9730-baa04264b4c6	aaf54224-49e8-45a4-93ba-e3f2aae82827	TEST2	TEST2	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/owbbaw0hm6l.docx|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/3566qp5vbqs.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document|||application/vnd.openxmlformats-officedocument.wordprocessingml.document	3280687	0	2025-06-13 04:32:10.341991+00	2025-06-13 04:32:10.341991+00	\N
54a5f087-e494-4f1c-ad09-9866ff841b25	aaf54224-49e8-45a4-93ba-e3f2aae82827	TEST3	TEST3	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/6gwjy7bwe27.docx|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/hxtho25nqvp.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document|||application/vnd.openxmlformats-officedocument.wordprocessingml.document	3280687	0	2025-06-13 04:37:33.070361+00	2025-06-13 04:37:33.070361+00	\N
6a46b5db-e9f4-462a-bc6b-0ce612f49666	aaf54224-49e8-45a4-93ba-e3f2aae82827	TEST4	TEST4	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/d9l2aus8r2v.docx|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/cxy22csnucb.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document|||application/vnd.openxmlformats-officedocument.wordprocessingml.document	3280687	0	2025-06-13 04:38:30.725661+00	2025-06-13 04:38:30.725661+00	NỘI DUNG THI WEB2.docx|||OnTap_LTWebvaUDNC_DHSG.docx
4a952cac-fa8c-4ad8-aea0-782c37f90c99	aaf54224-49e8-45a4-93ba-e3f2aae82827	TEST5	ORIGINAL NAMES	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/sltxhobf66.docx|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/zxwh0jtz2u.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document|||application/vnd.openxmlformats-officedocument.wordprocessingml.document	3381500	1	2025-06-13 04:41:49.620446+00	2025-06-20 02:27:50.877+00	Nhóm 02.docx|||NỘI DUNG THI WEB2.docx
2469a58c-bb25-48e5-9120-4cade0e1f3d6	aaf54224-49e8-45a4-93ba-e3f2aae82827	TEST6	TEST6	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/yajqi6vyfp.docx|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/50o1y6yz2px.pdf	application/vnd.openxmlformats-officedocument.wordprocessingml.document	15824	2	2025-06-13 04:44:44.155297+00	2025-06-20 02:26:46.052+00	c++.docx|||Ai_for_Student_Phien_ban_Tieng_Viet_SIHUB.pdf
831e5a5e-7209-4425-9ffa-01fff2b2059d	aaf54224-49e8-45a4-93ba-e3f2aae82827	1	1	|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/vd30847izob.docx	|||application/vnd.openxmlformats-officedocument.wordprocessingml.document	15824	1	2025-06-20 14:24:21.150853+00	2025-06-20 14:24:28.518+00	|||c++.docx
780bd46d-6306-4554-884c-e1fcac9f01cf	0537afe0-7b9d-49de-979a-cc151665eebe	Tìm hiểu hệ thống hỗ trợ lái xe an toàn ADAS 	Tài liệu về hệ thống ADAS của hãng xe Mazda	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/6pae91r4oih.docx|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/950r8wtfpq.pdf	application/vnd.openxmlformats-officedocument.wordprocessingml.document|||application/pdf	20173621	2	2025-09-13 03:45:18.148839+00	2025-09-13 03:58:52.894+00	AIR BAG SEAT BELT PRE-TENSIONER SYSTEM TWO-STEP DEPLOYMENT CONTROL (1).docx|||AIR BAG SEAT BELT PRE-TENSIONER SYSTEM TWO-STEP DEPLOYMENT CONTROL (2).pdf
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, student_id, full_name, role, class_code, created_at, updated_at, status) FROM stdin;
6f5dacff-4e81-4e42-83e2-1a7cd07bd690	19145225	Ngô Lê Hạnh	student		2025-09-13 04:35:02.120882+00	2025-09-13 04:35:02.123+00	active
641a180f-65a1-45b4-a648-a2df8482e0f4	20145112	Phan Minh Hoàng	student		2025-09-13 04:35:21.009422+00	2025-09-13 04:35:21.154+00	active
2ae0b466-781d-4e52-836e-6511c8155742	22145206	Nguyễn Hữu Nhân	student		2025-09-13 04:35:40.059626+00	2025-09-13 04:35:40.425+00	active
3210fe05-0793-44df-bb7e-a5cb93566759	22145207	Phan Nguyễn Hữu Nhân	student		2025-09-13 04:36:00.013506+00	2025-09-13 04:36:00.019+00	active
bf88a0b8-25bf-4743-bf2e-e06ef356a633	22145210	Nguyễn Bá Phi	student		2025-09-13 04:36:17.268145+00	2025-09-13 04:36:17.261+00	active
09d98c9d-a1a7-4b65-9d6c-ae4e293dbead	22145211	Lê Đình Tuệ Phong	student		2025-09-13 04:36:33.618166+00	2025-09-13 04:36:33.609+00	active
a675dd83-18f6-41c2-ba55-92cd88e14541	22145212	Tăng Hoàng Phong	student		2025-09-13 04:36:45.13345+00	2025-09-13 04:36:45.385+00	active
ed0914b9-f329-4286-b1b9-3cb2a39ff750	22145213	Đoàn Trọng Phú	student		2025-09-13 04:37:54.665301+00	2025-09-13 04:37:55.309+00	active
19fd552e-1b8d-4eba-9fd7-7621451f6272	22145215	Cao Nguyễn Phúc	student		2025-09-13 04:38:38.692468+00	2025-09-13 04:38:38.735+00	active
c608c9e1-9cc8-47c4-a71b-28fe5bcf1635	22145216	Mai Lâm Phúc	student		2025-09-13 04:38:51.37741+00	2025-09-13 04:38:51.366+00	active
91d20798-accf-4fe7-b038-b9af34a50aad	22145218	Nguyễn Phúc	student		2025-09-13 04:39:08.140006+00	2025-09-13 04:39:08.286+00	active
d677ddb9-7459-44f3-94f9-fcb42ae3cbf5	22145220	Nguyễn Hoàng Phúc	student		2025-09-13 04:39:31.348747+00	2025-09-13 04:39:31.344+00	active
dfc3cb8c-7ab1-4891-b54d-e6101aeccf7a	22145226	Phạm Quán Quân	student		2025-09-13 04:39:43.746961+00	2025-09-13 04:39:43.741+00	active
c2d1083d-d480-40cc-947d-cad7294eedc2	22145228	Đặng Thanh \tQuốc	student		2025-09-13 04:39:57.996054+00	2025-09-13 04:39:58.064+00	active
1a921e78-7463-4404-b054-bf6302b40c11	22145230	Đoàn Trường Sinh	student		2025-09-13 04:40:51.658123+00	2025-09-13 04:40:53.717+00	active
697fec7b-74d6-4df7-b165-87d112eaf2fc	22145280	Nguyễn Văn \tTuấn	student		2025-09-13 04:41:06.781808+00	2025-09-13 04:41:06.94+00	active
89800f22-6220-467a-b58d-5f6f22db2647	22145290	Nguyễn Trường \tVũ	student		2025-09-13 04:41:19.325547+00	2025-09-13 04:41:19.363+00	active
557d4ebc-ccbf-4402-ae59-4dd4b357e97c	20145112\t	Phan Minh Hoàng	student	08CLC	2025-02-21 08:15:30.199374+00	2025-09-13 03:30:26.071+00	active
acc521ce-1c0e-4911-8ff2-c168f6a7100f	gv007	gv007	teacher	\N	2025-09-13 05:31:20.674113+00	2025-09-13 05:31:20.674113+00	active
3ada3240-643f-4735-b17d-39fc4ec262a2	1	1	student	1	2025-08-24 06:18:22.600132+00	2025-09-13 04:28:44.052+00	active
8c75fb07-ba4b-4df0-badd-6f7b8a3a8361	2	2	student	2	2025-06-13 04:34:52.264077+00	2025-09-13 04:28:49.875+00	active
e368b85d-7038-4211-be16-c959c7931de0	3	3	student	3	2025-02-21 10:17:00.92684+00	2025-09-13 04:28:55.168+00	active
e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	4	4	student	4	2025-02-21 05:51:53.357839+00	2025-09-13 04:29:02.661+00	active
6477eb40-4562-4138-97e1-56d9cea1bd3d	5	5	student	5	2025-02-21 05:51:03.411747+00	2025-09-13 04:29:08.127+00	active
620de24c-a40a-432a-be36-86852092f3c1	6	6	student	6	2025-02-21 05:37:06.999379+00	2025-09-13 04:29:12.886+00	active
cbe2858c-b62c-4e42-b212-5353934cc62f	22145097	Hà Gia Bảo	student		2025-09-13 04:33:10.992631+00	2025-09-13 04:34:16.955+00	active
a0740794-4a85-4037-9340-89567cd20f04	gv0000	Nguyễn Văn Trãi	teacher		2025-08-24 06:19:32.379682+00	2025-09-13 04:34:21.626+00	active
ab2f529a-dda7-4dad-8d6f-27572f4871c1	22145433	Ngô Minh Phát	student		2025-09-13 04:29:40.392365+00	2025-09-13 04:34:27.004+00	active
695940da-8528-4f2a-a452-6cf9481ae155	22145105	Dương Đỗ Bá	student		2025-09-13 04:34:49.539946+00	2025-09-13 04:34:49.623+00	active
\.


--
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subjects (id, code, name, description, credits, created_at, updated_at) FROM stdin;
7d453c44-5359-4087-a27e-5ed40dd80c04	002	toán cao cấp	rất khó	3	2025-02-23 07:55:51.242+00	2025-02-23 07:55:51.242+00
92318b53-7293-4783-9999-cc03c143caab	003	Môn Học A		3	2025-08-24 06:21:29.657+00	2025-08-24 06:21:29.657+00
f7bdff59-8976-44ba-910d-52708eb4b387	PABE331233	TT Hệ thống điện thân xe 		3	2025-02-21 10:38:23.204+00	2025-09-13 03:35:25.558+00
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-02-14 14:51:42
20211116045059	2025-02-14 14:51:45
20211116050929	2025-02-14 14:51:47
20211116051442	2025-02-14 14:51:48
20211116212300	2025-02-14 14:51:50
20211116213355	2025-02-14 14:51:52
20211116213934	2025-02-14 14:51:54
20211116214523	2025-02-14 14:51:56
20211122062447	2025-02-14 14:51:58
20211124070109	2025-02-14 14:52:00
20211202204204	2025-02-14 14:52:02
20211202204605	2025-02-14 14:52:03
20211210212804	2025-02-14 14:52:09
20211228014915	2025-02-14 14:52:11
20220107221237	2025-02-14 14:52:12
20220228202821	2025-02-14 14:52:14
20220312004840	2025-02-14 14:52:16
20220603231003	2025-02-14 14:52:19
20220603232444	2025-02-14 14:52:21
20220615214548	2025-02-14 14:52:23
20220712093339	2025-02-14 14:52:24
20220908172859	2025-02-14 14:52:26
20220916233421	2025-02-14 14:52:28
20230119133233	2025-02-14 14:52:30
20230128025114	2025-02-14 14:52:32
20230128025212	2025-02-14 14:52:34
20230227211149	2025-02-14 14:52:36
20230228184745	2025-02-14 14:52:38
20230308225145	2025-02-14 14:52:40
20230328144023	2025-02-14 14:52:42
20231018144023	2025-02-14 14:52:44
20231204144023	2025-02-14 14:52:47
20231204144024	2025-02-14 14:52:49
20231204144025	2025-02-14 14:52:51
20240108234812	2025-02-14 14:52:53
20240109165339	2025-02-14 14:52:55
20240227174441	2025-02-14 14:52:58
20240311171622	2025-02-14 14:53:01
20240321100241	2025-02-14 14:53:05
20240401105812	2025-02-14 14:53:10
20240418121054	2025-02-14 14:53:13
20240523004032	2025-02-14 14:53:19
20240618124746	2025-02-14 14:53:21
20240801235015	2025-02-14 14:53:23
20240805133720	2025-02-14 14:53:25
20240827160934	2025-02-14 14:53:27
20240919163303	2025-02-14 14:53:29
20240919163305	2025-02-14 14:53:31
20241019105805	2025-02-14 14:53:33
20241030150047	2025-02-14 14:53:40
20241108114728	2025-02-14 14:53:43
20241121104152	2025-02-14 14:53:45
20241130184212	2025-02-14 14:53:47
20241220035512	2025-02-14 14:53:49
20241220123912	2025-02-14 14:53:51
20241224161212	2025-02-14 14:53:53
20250107150512	2025-02-14 14:53:54
20250110162412	2025-02-14 14:53:56
20250123174212	2025-02-14 14:53:58
20250128220012	2025-02-14 14:54:00
20250506224012	2025-05-22 10:16:13
20250523164012	2025-06-13 04:29:28
20250714121412	2025-09-03 00:40:29
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) FROM stdin;
lectures	lectures	\N	2025-02-24 13:12:32.367753+00	2025-02-24 13:12:32.367753+00	t	f	\N	\N	\N
submissions	submissions	\N	2025-03-13 09:07:11.618526+00	2025-03-13 09:07:11.618526+00	t	f	\N	\N	\N
attachments	attachments	\N	2025-03-13 09:07:11.618526+00	2025-03-13 09:07:11.618526+00	t	f	\N	\N	\N
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-02-14 14:51:37.611411
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-02-14 14:51:37.62481
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-02-14 14:51:37.636691
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-02-14 14:51:37.684487
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-02-14 14:51:37.745916
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-02-14 14:51:37.766132
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-02-14 14:51:37.777156
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-02-14 14:51:37.787988
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-02-14 14:51:37.795865
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-02-14 14:51:37.803746
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-02-14 14:51:37.82309
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-02-14 14:51:37.830878
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-02-14 14:51:37.840329
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-02-14 14:51:37.849367
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-02-14 14:51:37.856175
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-02-14 14:51:37.888145
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-02-14 14:51:37.903001
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-02-14 14:51:37.912147
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-02-14 14:51:37.926387
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-02-14 14:51:37.939841
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-02-14 14:51:37.948392
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-02-14 14:51:37.978436
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-02-14 14:51:38.012878
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-02-14 14:51:38.045112
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-02-14 14:51:38.05406
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-02-14 14:51:38.062932
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
6fd19b1a-3a43-4a90-b347-6347f0ef3343	lectures	lectures/.emptyFolderPlaceholder	\N	2025-02-24 13:31:03.283667+00	2025-02-24 13:31:03.283667+00	2025-02-24 13:31:03.283667+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2025-02-24T13:31:04.000Z", "contentLength": 0, "httpStatusCode": 200}	8c97a90d-a2e8-435a-b4ae-cc111fdb3653	\N	{}
dc494711-cc1a-4719-b9a1-b1551433ec70	lectures	0.5939345145438424.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-02-27 01:14:04.53117+00	2025-02-27 01:14:04.53117+00	2025-02-27 01:14:04.53117+00	{"eTag": "\\"747dc66edebe06635e719469bfab1672\\"", "size": 670427, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-02-27T01:14:05.000Z", "contentLength": 670427, "httpStatusCode": 200}	cc50fc93-9681-46e5-a67e-3519cff69110	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
03432ecb-355d-4066-a95b-5c00012932b1	lectures	lectures/0.45352118830205645.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-02-27 01:20:18.428209+00	2025-02-27 01:20:18.428209+00	2025-02-27 01:20:18.428209+00	{"eTag": "\\"747dc66edebe06635e719469bfab1672\\"", "size": 670427, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-02-27T01:20:19.000Z", "contentLength": 670427, "httpStatusCode": 200}	cba8566f-1e89-4558-ab97-1921d5ecb18f	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
41f3d5d9-8178-4491-a662-c086d9c9e5a6	lectures	lectures/0.48710103603125443.pdf	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-02-28 01:55:37.563192+00	2025-02-28 01:55:37.563192+00	2025-02-28 01:55:37.563192+00	{"eTag": "\\"f0c4c1568d709d5d8628ede5a8dc5033\\"", "size": 771457, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2025-02-28T01:55:38.000Z", "contentLength": 771457, "httpStatusCode": 200}	01543a75-8c60-42ae-a173-24e2d95d6b16	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
be773f5b-eaa5-46db-9426-38d6121ce337	lectures	lectures/0.602822338939019.pdf	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-02-28 01:57:23.240651+00	2025-02-28 01:57:23.240651+00	2025-02-28 01:57:23.240651+00	{"eTag": "\\"872019f2773b461d73e47800068b781c\\"", "size": 356827, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2025-02-28T01:57:24.000Z", "contentLength": 356827, "httpStatusCode": 200}	3f5ec925-818c-4c74-b1f1-40f79d0cff53	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
60ff1e01-4831-4d25-9a77-37b8e1722577	lectures	lectures/0.47220905032547256.pdf	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-02-28 02:00:57.347343+00	2025-02-28 02:00:57.347343+00	2025-02-28 02:00:57.347343+00	{"eTag": "\\"f0c4c1568d709d5d8628ede5a8dc5033\\"", "size": 771457, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2025-02-28T02:00:58.000Z", "contentLength": 771457, "httpStatusCode": 200}	45b33bee-85ae-4844-8b48-f5e54977093b	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
3d946ca5-7749-4d09-ac1c-74c301789392	lectures	lectures/0.8733202141787042.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-02-28 02:44:38.06947+00	2025-02-28 02:44:38.06947+00	2025-02-28 02:44:38.06947+00	{"eTag": "\\"5cbed07a20c9294af3d45c8eeae57078\\"", "size": 17934, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-02-28T02:44:38.000Z", "contentLength": 17934, "httpStatusCode": 200}	16a81104-82a7-475f-89d3-9f36af178ea5	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
fd2bded9-7a8d-446b-a282-956dc5b87dbd	lectures	lectures/0.4915425817234633.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-02-28 03:39:06.008457+00	2025-02-28 03:39:06.008457+00	2025-02-28 03:39:06.008457+00	{"eTag": "\\"5cbed07a20c9294af3d45c8eeae57078\\"", "size": 17934, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-02-28T03:39:06.000Z", "contentLength": 17934, "httpStatusCode": 200}	40a30c9a-dd86-485d-bcce-64c84a9b3f3b	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
12d862c7-db3f-4e42-9ced-cf019a15f840	lectures	lectures/0.8146433656060499.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-03-11 12:41:10.395373+00	2025-03-11 12:41:10.395373+00	2025-03-11 12:41:10.395373+00	{"eTag": "\\"306a172eae2a8c40ebc0116936054daf\\"", "size": 18978, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-03-11T12:41:11.000Z", "contentLength": 18978, "httpStatusCode": 200}	765d63cb-16f6-4717-a357-923abebfe328	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
93b60274-ddf7-4212-a4f1-f0af0494a729	lectures	lectures/0.43643969707262675.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-03-11 12:48:44.800441+00	2025-03-11 12:48:44.800441+00	2025-03-11 12:48:44.800441+00	{"eTag": "\\"306a172eae2a8c40ebc0116936054daf\\"", "size": 18978, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-03-11T12:48:45.000Z", "contentLength": 18978, "httpStatusCode": 200}	5a6bcec1-688c-4621-b7f6-149b8ad18a92	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
0df4e47d-962a-411b-9c45-1273cee4d5fd	lectures	lectures/0.4114465000827612.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-03-11 12:57:55.00079+00	2025-03-11 12:57:55.00079+00	2025-03-11 12:57:55.00079+00	{"eTag": "\\"306a172eae2a8c40ebc0116936054daf\\"", "size": 18978, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-03-11T12:57:55.000Z", "contentLength": 18978, "httpStatusCode": 200}	98c259bf-1dea-4493-9da6-722948cbcee3	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
92e79dd7-dd94-4aea-b0ab-cac432772c33	lectures	lectures/0.15610829578508634.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-03-11 13:02:56.433783+00	2025-03-11 13:02:56.433783+00	2025-03-11 13:02:56.433783+00	{"eTag": "\\"306a172eae2a8c40ebc0116936054daf\\"", "size": 18978, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-03-11T13:02:57.000Z", "contentLength": 18978, "httpStatusCode": 200}	02c1e573-2b6a-42bb-a4c0-8dccb209a9a6	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
e440b0bb-5e09-40a9-aa33-7ff4647e40d6	submissions	assignments/6886d5b2-104d-4d57-a585-9ec6a58d5218/6477eb40-4562-4138-97e1-56d9cea1bd3d/1741857593826.docx	6477eb40-4562-4138-97e1-56d9cea1bd3d	2025-03-13 09:19:54.984836+00	2025-03-13 09:19:54.984836+00	2025-03-13 09:19:54.984836+00	{"eTag": "\\"d74e387f6b51420b529c4bf87638b0ca\\"", "size": 17435, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-03-13T09:19:55.000Z", "contentLength": 17435, "httpStatusCode": 200}	4c660aeb-ec72-413e-b094-ae932ec625fe	6477eb40-4562-4138-97e1-56d9cea1bd3d	{}
e78f6aab-0a2c-46ba-aef7-cf7dce630eff	lectures	lectures/0.940604377414955.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-10 09:47:41.362293+00	2025-06-10 09:47:41.362293+00	2025-06-10 09:47:41.362293+00	{"eTag": "\\"43b54e8b4e564751ae3da749579ea4a8\\"", "size": 15824, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-10T09:47:42.000Z", "contentLength": 15824, "httpStatusCode": 200}	75d0ff79-76c1-4aea-8b44-70170e5350dc	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
6cf3ee56-6f17-4444-a15d-381e52381925	lectures	lectures/0.7458303837786975.pdf	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-10 09:47:45.796835+00	2025-06-10 09:47:45.796835+00	2025-06-10 09:47:45.796835+00	{"eTag": "\\"bba6c4d88664918265f8c348cfb961b0-2\\"", "size": 6890083, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2025-06-10T09:47:46.000Z", "contentLength": 6890083, "httpStatusCode": 200}	a971a8e4-5e58-43d7-a8e6-1ffaadeaabf5	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
30a69f2d-f72a-44a1-a26b-04a237859d7c	lectures	lectures/6qpwb821gn5.pdf	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-10 11:22:30.524506+00	2025-06-10 11:22:30.524506+00	2025-06-10 11:22:30.524506+00	{"eTag": "\\"3a991470f388ad8d429426df7d79b3d6\\"", "size": 98273, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2025-06-10T11:22:31.000Z", "contentLength": 98273, "httpStatusCode": 200}	58876002-e798-4f81-b3dd-53f1e7e27221	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
da56c44b-fdd3-432a-9d00-2384eb9c8ae8	lectures	lectures/anwlne2psws.pdf	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-10 11:22:33.870908+00	2025-06-10 11:22:33.870908+00	2025-06-10 11:22:33.870908+00	{"eTag": "\\"bba6c4d88664918265f8c348cfb961b0-2\\"", "size": 6890083, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2025-06-10T11:22:34.000Z", "contentLength": 6890083, "httpStatusCode": 200}	49e68c32-4b19-4f31-892f-39884034407f	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
de27e3dc-097f-49bb-9fed-07c7b7f66957	lectures	lectures/x5y4zwjgqo.pdf	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-10 11:34:04.505156+00	2025-06-10 11:34:04.505156+00	2025-06-10 11:34:04.505156+00	{"eTag": "\\"3a991470f388ad8d429426df7d79b3d6\\"", "size": 98273, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2025-06-10T11:34:05.000Z", "contentLength": 98273, "httpStatusCode": 200}	d0a00b5a-1ca8-45fb-9b87-9f74108e51e1	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
a1d2e88b-5aa2-4834-a6dd-7b9eb18f0cc2	lectures	lectures/zwyvbl6891.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-10 12:02:05.809959+00	2025-06-10 12:02:05.809959+00	2025-06-10 12:02:05.809959+00	{"eTag": "\\"43b54e8b4e564751ae3da749579ea4a8\\"", "size": 15824, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-10T12:02:06.000Z", "contentLength": 15824, "httpStatusCode": 200}	a82cc3fc-e52b-450d-a7a9-0b7032548c19	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
8cdf48dd-10b2-4083-8d91-33b2f2079257	lectures	lectures/syqypz4y5lc.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-10 12:03:57.35936+00	2025-06-10 12:03:57.35936+00	2025-06-10 12:03:57.35936+00	{"eTag": "\\"43b54e8b4e564751ae3da749579ea4a8\\"", "size": 15824, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-10T12:03:58.000Z", "contentLength": 15824, "httpStatusCode": 200}	9bf82e81-33d3-4878-ba21-769352c0cbbe	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
119fdf4c-ac32-4e9d-8ec5-b16ccf94a6ff	lectures	lectures/tkktk6lkly.pdf	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-10 12:04:34.739713+00	2025-06-10 12:04:34.739713+00	2025-06-10 12:04:34.739713+00	{"eTag": "\\"3a991470f388ad8d429426df7d79b3d6\\"", "size": 98273, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2025-06-10T12:04:35.000Z", "contentLength": 98273, "httpStatusCode": 200}	ca363a5b-9b68-427b-ad64-a3d954788b33	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
931e221d-fa85-4a34-867b-bc6f22473008	lectures	lectures/crz67rk0phf.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-10 12:05:48.300167+00	2025-06-10 12:05:48.300167+00	2025-06-10 12:05:48.300167+00	{"eTag": "\\"43b54e8b4e564751ae3da749579ea4a8\\"", "size": 15824, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-10T12:05:49.000Z", "contentLength": 15824, "httpStatusCode": 200}	be5b86e6-a5ae-46bc-babd-417cac6b5d74	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
50bd2d97-b721-406f-928d-b65d29ff9424	lectures	lectures/rml9hbz4cx.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-10 12:07:11.202945+00	2025-06-10 12:07:11.202945+00	2025-06-10 12:07:11.202945+00	{"eTag": "\\"43b54e8b4e564751ae3da749579ea4a8\\"", "size": 15824, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-10T12:07:12.000Z", "contentLength": 15824, "httpStatusCode": 200}	e7423f06-73e0-4a50-8e9e-d8979f6fb3fe	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
8e45861e-2ee4-4a43-8aa6-3663a0c86067	lectures	lectures/uxuh8ef3cp.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-10 12:09:48.3518+00	2025-06-10 12:09:48.3518+00	2025-06-10 12:09:48.3518+00	{"eTag": "\\"43b54e8b4e564751ae3da749579ea4a8\\"", "size": 15824, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-10T12:09:49.000Z", "contentLength": 15824, "httpStatusCode": 200}	cc73da49-9ff4-42d9-ad19-f27efd3a7def	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
eb6322dc-ccaf-463c-8e79-8b61fb8cb20c	lectures	lectures/hd7ta3d6jnu.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-13 04:25:25.552378+00	2025-06-13 04:25:25.552378+00	2025-06-13 04:25:25.552378+00	{"eTag": "\\"cde60966d6d97f43258eb1d02afbefae\\"", "size": 3044146, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-13T04:25:26.000Z", "contentLength": 3044146, "httpStatusCode": 200}	a62fa237-ee56-4152-a4ba-ac9f8d4ac6b6	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
9658b386-7f8b-4d14-9608-05f385aa39ba	lectures	lectures/0dux16dgpd2.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-13 04:25:26.901986+00	2025-06-13 04:25:26.901986+00	2025-06-13 04:25:26.901986+00	{"eTag": "\\"2d796d4ee432166bb5e4b7fe8b815bf9\\"", "size": 236541, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-13T04:25:27.000Z", "contentLength": 236541, "httpStatusCode": 200}	650944fb-fb6c-49dc-ae19-5ab526f99809	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
d7715799-c0b0-484c-aeab-5833b24aa547	lectures	lectures/owbbaw0hm6l.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-13 04:32:08.544534+00	2025-06-13 04:32:08.544534+00	2025-06-13 04:32:08.544534+00	{"eTag": "\\"cde60966d6d97f43258eb1d02afbefae\\"", "size": 3044146, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-13T04:32:09.000Z", "contentLength": 3044146, "httpStatusCode": 200}	acd8b861-0c43-4760-9580-1ccdaadaa61c	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
b5dfab88-8756-4e92-8452-76af546a99db	lectures	lectures/3566qp5vbqs.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-13 04:32:10.07157+00	2025-06-13 04:32:10.07157+00	2025-06-13 04:32:10.07157+00	{"eTag": "\\"2d796d4ee432166bb5e4b7fe8b815bf9\\"", "size": 236541, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-13T04:32:10.000Z", "contentLength": 236541, "httpStatusCode": 200}	16a18521-19f9-4065-80d7-656ab9ce7f4e	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
938ab350-d99c-4936-b143-3669c8f6cff7	lectures	lectures/6gwjy7bwe27.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-13 04:37:29.154273+00	2025-06-13 04:37:29.154273+00	2025-06-13 04:37:29.154273+00	{"eTag": "\\"2d796d4ee432166bb5e4b7fe8b815bf9\\"", "size": 236541, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-13T04:37:30.000Z", "contentLength": 236541, "httpStatusCode": 200}	47e84108-fef8-43f2-8146-ad542a2c8fdc	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
f85f3885-01e2-4b33-ae8c-7257812f437f	lectures	lectures/hxtho25nqvp.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-13 04:37:32.428496+00	2025-06-13 04:37:32.428496+00	2025-06-13 04:37:32.428496+00	{"eTag": "\\"cde60966d6d97f43258eb1d02afbefae\\"", "size": 3044146, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-13T04:37:33.000Z", "contentLength": 3044146, "httpStatusCode": 200}	f474af7b-6971-4247-9935-d749bd0c89a2	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
2abedb4b-eeb6-46e0-a916-a869c2b59c56	lectures	lectures/d9l2aus8r2v.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-13 04:38:28.814387+00	2025-06-13 04:38:28.814387+00	2025-06-13 04:38:28.814387+00	{"eTag": "\\"cde60966d6d97f43258eb1d02afbefae\\"", "size": 3044146, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-13T04:38:29.000Z", "contentLength": 3044146, "httpStatusCode": 200}	f7b4c607-7118-4ad1-a7e6-ee063f0b93cb	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
7ea59e9e-30fd-4c9a-9404-de693ff1a0bc	lectures	lectures/cxy22csnucb.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-13 04:38:30.393544+00	2025-06-13 04:38:30.393544+00	2025-06-13 04:38:30.393544+00	{"eTag": "\\"2d796d4ee432166bb5e4b7fe8b815bf9\\"", "size": 236541, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-13T04:38:31.000Z", "contentLength": 236541, "httpStatusCode": 200}	9735206b-1959-489c-8881-18cfdcd97b82	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
b67fa6d0-0da1-4528-a09e-d88a47b144e8	lectures	lectures/sltxhobf66.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-13 04:41:45.965825+00	2025-06-13 04:41:45.965825+00	2025-06-13 04:41:45.965825+00	{"eTag": "\\"b8c9d7c96296939a9c16f3d205e12a71\\"", "size": 337354, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-13T04:41:46.000Z", "contentLength": 337354, "httpStatusCode": 200}	862db0e9-9a7c-4a9d-82cb-c8f12d8d95a9	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
b2384937-05af-4d25-b5c2-df5c7fc18a99	lectures	lectures/zxwh0jtz2u.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-13 04:41:48.910778+00	2025-06-13 04:41:48.910778+00	2025-06-13 04:41:48.910778+00	{"eTag": "\\"cde60966d6d97f43258eb1d02afbefae\\"", "size": 3044146, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-13T04:41:49.000Z", "contentLength": 3044146, "httpStatusCode": 200}	30207ea7-18f6-4ab7-9bd7-03a2c624b986	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
c67e7a0d-e90c-43dd-b528-022a6641717a	lectures	lectures/2x6iwdmrmh8.pdf	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-13 04:44:39.881782+00	2025-06-13 04:44:39.881782+00	2025-06-13 04:44:39.881782+00	{"eTag": "\\"7b72f386491741a897aa09421d769517\\"", "size": 870454, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2025-06-13T04:44:40.000Z", "contentLength": 870454, "httpStatusCode": 200}	d17282b4-3f84-41e3-90fc-538350b52e86	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
119787bd-8972-4fad-8c5e-cfeabe542d15	lectures	lectures/zwzqycchgt.pdf	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-13 04:44:43.899662+00	2025-06-13 04:44:43.899662+00	2025-06-13 04:44:43.899662+00	{"eTag": "\\"e4e6ecbf3b2ceb63a169fd366d6d0805-2\\"", "size": 6559412, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2025-06-13T04:44:44.000Z", "contentLength": 6559412, "httpStatusCode": 200}	b90300c7-6e95-46f3-9d6d-1779e3f5e524	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
5c276717-3b06-479b-8c12-a6af3a03a0d3	submissions	assignments/425e42ca-355e-4e94-ac53-d983e38135eb/e368b85d-7038-4211-be16-c959c7931de0/1750341745264.docx	e368b85d-7038-4211-be16-c959c7931de0	2025-06-19 14:02:30.500236+00	2025-06-19 14:02:30.500236+00	2025-06-19 14:02:30.500236+00	{"eTag": "\\"048a43555b3e3d3f9bc48623446ff68e\\"", "size": 163383, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-19T14:02:31.000Z", "contentLength": 163383, "httpStatusCode": 200}	b91fe448-e036-4ff4-b6a9-736b64c02220	e368b85d-7038-4211-be16-c959c7931de0	{}
54cc1f7a-f215-46bb-894b-76b54b1cebcf	lectures	lectures/m51ruhz5bxk.pdf	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-20 14:09:58.671202+00	2025-06-20 14:09:58.671202+00	2025-06-20 14:09:58.671202+00	{"eTag": "\\"bba6c4d88664918265f8c348cfb961b0-2\\"", "size": 6890083, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2025-06-20T14:09:59.000Z", "contentLength": 6890083, "httpStatusCode": 200}	6f82ea26-9c2b-44b1-8314-9ef5b0035bc3	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
88dc0d34-6a0f-4e77-9ef1-f86fa5ebf8fd	lectures	lectures/1xu3of9p9rbi.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-20 14:09:59.474178+00	2025-06-20 14:09:59.474178+00	2025-06-20 14:09:59.474178+00	{"eTag": "\\"43b54e8b4e564751ae3da749579ea4a8\\"", "size": 15824, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-20T14:10:00.000Z", "contentLength": 15824, "httpStatusCode": 200}	f7ade5e3-151f-43ca-a9d6-6f4980ba4b25	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
7527a8db-e583-41df-a7f3-aea3994f2077	lectures	lectures/sju7w6aiv.pdf	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-20 14:11:54.169699+00	2025-06-20 14:11:54.169699+00	2025-06-20 14:11:54.169699+00	{"eTag": "\\"bba6c4d88664918265f8c348cfb961b0-2\\"", "size": 6890083, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2025-06-20T14:11:54.000Z", "contentLength": 6890083, "httpStatusCode": 200}	58d1bfe9-7180-4aff-9388-882b14346101	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
d07e7dec-5efe-46aa-9d87-acd668d19b5d	lectures	lectures/md4tr9og0s.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-20 14:11:54.93489+00	2025-06-20 14:11:54.93489+00	2025-06-20 14:11:54.93489+00	{"eTag": "\\"43b54e8b4e564751ae3da749579ea4a8\\"", "size": 15824, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-20T14:11:55.000Z", "contentLength": 15824, "httpStatusCode": 200}	3f62483d-27b3-41a4-8f6a-5cab1a670687	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
e723e24a-f750-4e6f-bc2a-fd6ab8d27bff	lectures	lectures/yajqi6vyfp.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-20 14:15:10.267051+00	2025-06-20 14:15:10.267051+00	2025-06-20 14:15:10.267051+00	{"eTag": "\\"43b54e8b4e564751ae3da749579ea4a8\\"", "size": 15824, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-20T14:15:11.000Z", "contentLength": 15824, "httpStatusCode": 200}	5dd24c59-8bf3-457f-85ca-03632530f16c	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
05167a7b-4abb-496a-b76c-bb111d328cc0	lectures	lectures/50o1y6yz2px.pdf	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-20 14:15:11.065758+00	2025-06-20 14:15:11.065758+00	2025-06-20 14:15:11.065758+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2025-06-20T14:15:12.000Z", "contentLength": 0, "httpStatusCode": 200}	e61af42b-a86a-418b-acbc-c51140bb6606	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
8b77631b-2b3a-4ea7-9c62-5b804d7f1478	lectures	lectures/vd30847izob.docx	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-20 14:24:20.525649+00	2025-06-20 14:24:20.525649+00	2025-06-20 14:24:20.525649+00	{"eTag": "\\"43b54e8b4e564751ae3da749579ea4a8\\"", "size": 15824, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-06-20T14:24:21.000Z", "contentLength": 15824, "httpStatusCode": 200}	7cd33ab0-d9e3-44a4-b7fa-59cbb456a452	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	{}
054f8c2d-d31d-4ec8-8b42-f37284872143	lectures	lectures/9t84e8666dp.pdf	a0740794-4a85-4037-9340-89567cd20f04	2025-09-13 03:42:55.159764+00	2025-09-13 03:42:55.159764+00	2025-09-13 03:42:55.159764+00	{"eTag": "\\"8f2aca138a4f7bb05e2c201f3fd4260f-2\\"", "size": 10303401, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2025-09-13T03:42:55.000Z", "contentLength": 10303401, "httpStatusCode": 200}	ed8d7ab8-0e6c-4342-9a2d-73e598d17931	a0740794-4a85-4037-9340-89567cd20f04	{}
cd837119-c76e-4da6-9c98-93c7a35771ee	lectures	lectures/c343qqcvun.pdf	a0740794-4a85-4037-9340-89567cd20f04	2025-09-13 03:45:17.62746+00	2025-09-13 03:45:17.62746+00	2025-09-13 03:45:17.62746+00	{"eTag": "\\"8f2aca138a4f7bb05e2c201f3fd4260f-2\\"", "size": 10303401, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2025-09-13T03:45:18.000Z", "contentLength": 10303401, "httpStatusCode": 200}	0c7deb42-8759-4945-b0b0-9e60e4fda876	a0740794-4a85-4037-9340-89567cd20f04	{}
3248e536-a2f2-40b4-a1b6-1c3986b5debc	lectures	lectures/6pae91r4oih.docx	a0740794-4a85-4037-9340-89567cd20f04	2025-09-13 03:56:47.21583+00	2025-09-13 03:56:47.21583+00	2025-09-13 03:56:47.21583+00	{"eTag": "\\"e084f8092612b01b8decfb7ed0c14456-3\\"", "size": 13673156, "mimetype": "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "cacheControl": "max-age=3600", "lastModified": "2025-09-13T03:56:47.000Z", "contentLength": 13673156, "httpStatusCode": 200}	fe94cb5f-5172-4cea-bc69-36a12edc0bea	a0740794-4a85-4037-9340-89567cd20f04	{}
19bd7b6b-ddbe-4987-af6e-3a7d5a2ff3f1	lectures	lectures/950r8wtfpq.pdf	a0740794-4a85-4037-9340-89567cd20f04	2025-09-13 03:57:03.990385+00	2025-09-13 03:57:03.990385+00	2025-09-13 03:57:03.990385+00	{"eTag": "\\"9119da168d25aa1152d63fb5194ec7be-2\\"", "size": 6500465, "mimetype": "application/pdf", "cacheControl": "max-age=3600", "lastModified": "2025-09-13T03:57:04.000Z", "contentLength": 6500465, "httpStatusCode": 200}	d957f918-e6fd-4357-9936-07a1f728cf75	a0740794-4a85-4037-9340-89567cd20f04	{}
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 494, true);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: supabase_admin
--

SELECT pg_catalog.setval('pgsodium.key_key_id_seq', 1, false);


--
-- Name: activity_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activity_logs_id_seq', 357, true);


--
-- Name: assignment_questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.assignment_questions_id_seq', 21, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_client_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_client_id_key UNIQUE (client_id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: activity_logs activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (id);


--
-- Name: assignment_questions assignment_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment_questions
    ADD CONSTRAINT assignment_questions_pkey PRIMARY KEY (id);


--
-- Name: assignment_submissions assignment_submissions_assignment_id_student_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment_submissions
    ADD CONSTRAINT assignment_submissions_assignment_id_student_id_key UNIQUE (assignment_id, student_id);


--
-- Name: assignment_submissions assignment_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment_submissions
    ADD CONSTRAINT assignment_submissions_pkey PRIMARY KEY (id);


--
-- Name: assignments assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: classes classes_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_code_key UNIQUE (code);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: enrollments enrollments_class_id_student_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_class_id_student_id_key UNIQUE (class_id, student_id);


--
-- Name: enrollments enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_pkey PRIMARY KEY (id);


--
-- Name: exam_questions exam_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_questions
    ADD CONSTRAINT exam_questions_pkey PRIMARY KEY (id);


--
-- Name: exam_submissions exam_submissions_exam_id_student_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_submissions
    ADD CONSTRAINT exam_submissions_exam_id_student_id_key UNIQUE (exam_id, student_id);


--
-- Name: exam_submissions exam_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_submissions
    ADD CONSTRAINT exam_submissions_pkey PRIMARY KEY (id);


--
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (id);


--
-- Name: lectures lectures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lectures
    ADD CONSTRAINT lectures_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_student_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_student_id_key UNIQUE (student_id);


--
-- Name: subjects subjects_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_code_key UNIQUE (code);


--
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_clients_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_client_id_idx ON auth.oauth_clients USING btree (client_id);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: activity_logs_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX activity_logs_type_idx ON public.activity_logs USING btree (activity_type);


--
-- Name: activity_logs_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX activity_logs_updated_at_idx ON public.activity_logs USING btree (updated_at);


--
-- Name: idx_assignment_questions_assignment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_assignment_questions_assignment_id ON public.assignment_questions USING btree (assignment_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: assignment_questions assignment_questions_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment_questions
    ADD CONSTRAINT assignment_questions_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.assignments(id) ON DELETE CASCADE;


--
-- Name: assignment_submissions assignment_submissions_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment_submissions
    ADD CONSTRAINT assignment_submissions_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.assignments(id) ON DELETE CASCADE;


--
-- Name: assignment_submissions assignment_submissions_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment_submissions
    ADD CONSTRAINT assignment_submissions_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: assignments assignments_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT assignments_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: classes classes_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- Name: classes classes_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.profiles(id);


--
-- Name: enrollments enrollments_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: enrollments enrollments_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.profiles(id);


--
-- Name: exam_questions exam_questions_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_questions
    ADD CONSTRAINT exam_questions_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id) ON DELETE CASCADE;


--
-- Name: exam_submissions exam_submissions_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_submissions
    ADD CONSTRAINT exam_submissions_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id) ON DELETE CASCADE;


--
-- Name: exam_submissions exam_submissions_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_submissions
    ADD CONSTRAINT exam_submissions_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.profiles(id);


--
-- Name: exams exams_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: lectures lectures_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lectures
    ADD CONSTRAINT lectures_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles Allow public delete access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow public delete access" ON public.profiles FOR DELETE USING (true);


--
-- Name: profiles Allow public insert access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow public insert access" ON public.profiles FOR INSERT WITH CHECK (true);


--
-- Name: profiles Allow public read access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow public read access" ON public.profiles FOR SELECT USING (true);


--
-- Name: activity_logs Allow public to delete from activity_logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow public to delete from activity_logs" ON public.activity_logs FOR DELETE USING (true);


--
-- Name: activity_logs Allow public to insert into activity_logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow public to insert into activity_logs" ON public.activity_logs FOR INSERT WITH CHECK (true);


--
-- Name: activity_logs Allow public to select from activity_logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow public to select from activity_logs" ON public.activity_logs FOR SELECT USING (true);


--
-- Name: activity_logs Allow public to update activity_logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow public to update activity_logs" ON public.activity_logs FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: profiles Allow public update access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow public update access" ON public.profiles FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: subjects Enable delete for authenticated users only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable delete for authenticated users only" ON public.subjects FOR DELETE USING ((auth.role() = 'authenticated'::text));


--
-- Name: enrollments Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users only" ON public.enrollments FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: subjects Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users only" ON public.subjects FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: assignments Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.assignments FOR SELECT USING (true);


--
-- Name: classes Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.classes FOR SELECT USING (true);


--
-- Name: enrollments Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.enrollments FOR SELECT USING (true);


--
-- Name: exams Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.exams FOR SELECT USING (true);


--
-- Name: lectures Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.lectures FOR SELECT USING (true);


--
-- Name: subjects Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.subjects FOR SELECT USING (true);


--
-- Name: subjects Enable update for authenticated users only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable update for authenticated users only" ON public.subjects FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- Name: lectures Giảng viên có thể quản lý bài giảng của mình; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giảng viên có thể quản lý bài giảng của mình" ON public.lectures USING ((EXISTS ( SELECT 1
   FROM public.classes
  WHERE ((classes.id = lectures.class_id) AND (classes.teacher_id = auth.uid())))));


--
-- Name: exams Giảng viên có thể quản lý bài kiểm tra của mình; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giảng viên có thể quản lý bài kiểm tra của mình" ON public.exams USING ((EXISTS ( SELECT 1
   FROM public.classes
  WHERE ((classes.id = exams.class_id) AND (classes.teacher_id = auth.uid())))));


--
-- Name: assignments Giảng viên có thể quản lý bài tập của mình; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giảng viên có thể quản lý bài tập của mình" ON public.assignments USING ((EXISTS ( SELECT 1
   FROM public.classes
  WHERE ((classes.id = assignments.class_id) AND (classes.teacher_id = auth.uid())))));


--
-- Name: exam_questions Giảng viên có thể quản lý câu hỏi kiểm tra của ; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giảng viên có thể quản lý câu hỏi kiểm tra của " ON public.exam_questions USING ((EXISTS ( SELECT 1
   FROM (public.exams
     JOIN public.classes ON ((classes.id = exams.class_id)))
  WHERE ((exams.id = exam_questions.exam_id) AND (classes.teacher_id = auth.uid())))));


--
-- Name: classes Giảng viên có thể quản lý lớp học của mình; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giảng viên có thể quản lý lớp học của mình" ON public.classes USING ((auth.uid() = teacher_id));


--
-- Name: enrollments Giảng viên có thể xem danh sách sinh viên đăng ký l; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giảng viên có thể xem danh sách sinh viên đăng ký l" ON public.enrollments FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.classes
  WHERE ((classes.id = enrollments.class_id) AND (classes.teacher_id = auth.uid())))));


--
-- Name: subjects Giảng viên có thể xem tất cả môn học; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giảng viên có thể xem tất cả môn học" ON public.subjects FOR SELECT USING (true);


--
-- Name: exam_submissions Giảng viên có thể xem và chấm bài kiểm tra; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giảng viên có thể xem và chấm bài kiểm tra" ON public.exam_submissions USING ((EXISTS ( SELECT 1
   FROM (public.exams
     JOIN public.classes ON ((classes.id = exams.class_id)))
  WHERE ((exams.id = exam_submissions.exam_id) AND (classes.teacher_id = auth.uid())))));


--
-- Name: assignment_submissions Giảng viên có thể xem và chấm bài tập; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giảng viên có thể xem và chấm bài tập" ON public.assignment_submissions USING ((EXISTS ( SELECT 1
   FROM (public.assignments
     JOIN public.classes ON ((classes.id = assignments.class_id)))
  WHERE ((assignments.id = assignment_submissions.assignment_id) AND (classes.teacher_id = auth.uid())))));


--
-- Name: profiles Profiles are viewable by users who created them.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Profiles are viewable by users who created them." ON public.profiles FOR SELECT USING ((auth.uid() = id));


--
-- Name: assignment_questions Public can insert into assignment_questions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public can insert into assignment_questions" ON public.assignment_questions FOR INSERT WITH CHECK (true);


--
-- Name: assignment_submissions Public can insert into assignment_submissions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public can insert into assignment_submissions" ON public.assignment_submissions FOR INSERT WITH CHECK (true);


--
-- Name: assignments Public can insert into assignments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public can insert into assignments" ON public.assignments FOR INSERT WITH CHECK (true);


--
-- Name: exam_submissions Public can insert into exam_submissions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public can insert into exam_submissions" ON public.exam_submissions FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: assignment_questions Public can select from assignment_questions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public can select from assignment_questions" ON public.assignment_questions FOR SELECT TO authenticated, anon USING (true);


--
-- Name: assignment_submissions Public can select from assignment_submissions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public can select from assignment_submissions" ON public.assignment_submissions FOR SELECT USING (true);


--
-- Name: exam_questions Public can select from exam_questions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public can select from exam_questions" ON public.exam_questions FOR SELECT USING (true);


--
-- Name: exam_submissions Public can select from exam_submissions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public can select from exam_submissions" ON public.exam_submissions FOR SELECT TO authenticated, anon USING (true);


--
-- Name: profiles Users can insert their own profile.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own profile." ON public.profiles FOR INSERT WITH CHECK ((auth.uid() = id));


--
-- Name: profiles Users can update own profile.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update own profile." ON public.profiles FOR UPDATE USING ((auth.uid() = id));


--
-- Name: activity_logs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: assignment_questions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.assignment_questions ENABLE ROW LEVEL SECURITY;

--
-- Name: assignment_submissions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.assignment_submissions ENABLE ROW LEVEL SECURITY;

--
-- Name: assignments; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: classes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.classes ENABLE ROW LEVEL SECURITY;

--
-- Name: exam_questions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.exam_questions ENABLE ROW LEVEL SECURITY;

--
-- Name: exam_submissions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.exam_submissions ENABLE ROW LEVEL SECURITY;

--
-- Name: exams; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.exams ENABLE ROW LEVEL SECURITY;

--
-- Name: lectures; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.lectures ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: subjects; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: objects Authenticated Upload to Submissions; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Authenticated Upload to Submissions" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'submissions'::text));


--
-- Name: objects Chỉ admin có thể xem video chờ duyệt 1199pmo_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Chỉ admin có thể xem video chờ duyệt 1199pmo_0" ON storage.objects FOR SELECT USING (true);


--
-- Name: objects Chỉ admin có thể xem video chờ duyệt 1199pmo_1; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Chỉ admin có thể xem video chờ duyệt 1199pmo_1" ON storage.objects FOR INSERT WITH CHECK (true);


--
-- Name: objects Chỉ admin có thể xem video chờ duyệt 1199pmo_2; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Chỉ admin có thể xem video chờ duyệt 1199pmo_2" ON storage.objects FOR UPDATE USING (true);


--
-- Name: objects Owner or Teacher Delete from Submissions; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Owner or Teacher Delete from Submissions" ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'submissions'::text) AND (((auth.uid())::text = (storage.foldername(name))[2]) OR (EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.role = 'teacher'::text)))))));


--
-- Name: objects Public Access to Attachments; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Public Access to Attachments" ON storage.objects FOR SELECT USING ((bucket_id = 'attachments'::text));


--
-- Name: objects Public Access to Submissions; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Public Access to Submissions" ON storage.objects FOR SELECT USING ((bucket_id = 'submissions'::text));


--
-- Name: objects Teacher Delete from Attachments; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Teacher Delete from Attachments" ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'attachments'::text) AND (EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.role = 'teacher'::text))))));


--
-- Name: objects Teacher Upload to Attachments; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Teacher Upload to Attachments" ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'attachments'::text) AND (EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.role = 'teacher'::text))))));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: objects lectures r0k52t_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "lectures r0k52t_0" ON storage.objects FOR SELECT USING (((bucket_id = 'lectures'::text) AND (auth.role() = 'authenticated'::text) AND (( SELECT profiles.role
   FROM public.profiles
  WHERE (profiles.id = auth.uid())) = 'teacher'::text)));


--
-- Name: objects lectures r0k52t_1; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "lectures r0k52t_1" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'lectures'::text) AND (auth.role() = 'authenticated'::text) AND (( SELECT profiles.role
   FROM public.profiles
  WHERE (profiles.id = auth.uid())) = 'teacher'::text)));


--
-- Name: objects lectures r0k52t_2; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "lectures r0k52t_2" ON storage.objects FOR UPDATE USING (((bucket_id = 'lectures'::text) AND (auth.role() = 'authenticated'::text) AND (( SELECT profiles.role
   FROM public.profiles
  WHERE (profiles.id = auth.uid())) = 'teacher'::text)));


--
-- Name: objects lectures r0k52t_3; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "lectures r0k52t_3" ON storage.objects FOR DELETE USING (((bucket_id = 'lectures'::text) AND (auth.role() = 'authenticated'::text) AND (( SELECT profiles.role
   FROM public.profiles
  WHERE (profiles.id = auth.uid())) = 'teacher'::text)));


--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;
GRANT ALL ON FUNCTION auth.email() TO postgres;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;
GRANT ALL ON FUNCTION auth.role() TO postgres;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;
GRANT ALL ON FUNCTION auth.uid() TO postgres;


--
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION try_cast_double(inp text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO dashboard_user;


--
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_decode(data text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;


--
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO postgres;


--
-- Name: FUNCTION crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_keygen(); Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() TO service_role;


--
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION can_insert_object(bucketid text, name text, owner uuid, metadata jsonb); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) TO postgres;


--
-- Name: FUNCTION extension(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.extension(name text) TO postgres;


--
-- Name: FUNCTION filename(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.filename(name text) TO postgres;


--
-- Name: FUNCTION foldername(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.foldername(name text) TO postgres;


--
-- Name: FUNCTION get_size_by_bucket(); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.get_size_by_bucket() TO postgres;


--
-- Name: FUNCTION list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) TO postgres;


--
-- Name: FUNCTION list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) TO postgres;


--
-- Name: FUNCTION operation(); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.operation() TO postgres;


--
-- Name: FUNCTION search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) TO postgres;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.update_updated_at_column() TO postgres;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.oauth_clients TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE decrypted_key; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE pgsodium.decrypted_key TO pgsodium_keyholder;


--
-- Name: TABLE masking_rule; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE pgsodium.masking_rule TO pgsodium_keyholder;


--
-- Name: TABLE mask_columns; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE pgsodium.mask_columns TO pgsodium_keyholder;


--
-- Name: TABLE activity_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.activity_logs TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.activity_logs TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.activity_logs TO service_role;


--
-- Name: SEQUENCE activity_logs_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.activity_logs_id_seq TO anon;
GRANT ALL ON SEQUENCE public.activity_logs_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.activity_logs_id_seq TO service_role;


--
-- Name: TABLE assignment_questions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.assignment_questions TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.assignment_questions TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.assignment_questions TO service_role;


--
-- Name: SEQUENCE assignment_questions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.assignment_questions_id_seq TO anon;
GRANT ALL ON SEQUENCE public.assignment_questions_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.assignment_questions_id_seq TO service_role;


--
-- Name: TABLE assignment_submissions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.assignment_submissions TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.assignment_submissions TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.assignment_submissions TO service_role;


--
-- Name: TABLE assignments; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.assignments TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.assignments TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.assignments TO service_role;


--
-- Name: TABLE classes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.classes TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.classes TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.classes TO service_role;


--
-- Name: TABLE enrollments; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.enrollments TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.enrollments TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.enrollments TO service_role;


--
-- Name: TABLE exam_questions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.exam_questions TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.exam_questions TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.exam_questions TO service_role;


--
-- Name: TABLE exam_submissions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.exam_submissions TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.exam_submissions TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.exam_submissions TO service_role;


--
-- Name: TABLE exams; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.exams TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.exams TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.exams TO service_role;


--
-- Name: TABLE lectures; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.lectures TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.lectures TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.lectures TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.profiles TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.profiles TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.profiles TO service_role;


--
-- Name: TABLE subjects; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.subjects TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.subjects TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.subjects TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.messages TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.schema_migrations TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.subscription TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.buckets TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.buckets TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.buckets TO service_role;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.buckets TO postgres;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.objects TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.objects TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.objects TO service_role;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.objects TO postgres;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.s3_multipart_uploads TO postgres;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.s3_multipart_uploads_parts TO postgres;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON SEQUENCES TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON SEQUENCES TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON FUNCTIONS TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

