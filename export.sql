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

    split_part(new.email, '@', 1), -- Lß║Ñy m├ú sß╗æ tß╗½ phß║ºn ─æß║ºu cß╗ºa email

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
      PERFORM pg_notify(
          'realtime:system',
          jsonb_build_object(
              'error', SQLERRM,
              'function', 'realtime.send',
              'event', event,
              'topic', topic,
              'private', private
          )::text
      );
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

COMMENT ON COLUMN public.exam_submissions.file_url IS 'URL cß╗ºa file ─æ├¡nh k├¿m b├ái nß╗Öp';


--
-- Name: COLUMN exam_submissions.content; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.exam_submissions.content IS 'Nß╗Öi dung b├ái l├ám dß║íng text';


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

COMMENT ON COLUMN public.lectures.original_filename IS 'T├¬n file gß╗æc khi upload';


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
e93edc03-b75b-4abf-bb7e-c96fd1b4a725	2025-06-11 02:34:01.113495+00	2025-06-11 02:34:01.113495+00	password	db2f309f-05ef-4408-bc81-a702e702eb44
4b50521e-d51c-448a-a241-b9129fa8f1f7	2025-06-13 03:53:39.90971+00	2025-06-13 03:53:39.90971+00	password	29a95c67-45e4-43c6-a41c-59f8638dd8d3
8d944f98-cb27-4164-9f73-ff88350caf5a	2025-06-13 04:08:47.71497+00	2025-06-13 04:08:47.71497+00	password	c5a97a16-5597-4666-90e4-4a717081ab08
6d84216c-747c-4ee2-b6df-193cebf636d5	2025-06-13 04:34:52.306312+00	2025-06-13 04:34:52.306312+00	password	55644f29-b0d4-4959-bb81-2100193697bc
453d65f7-f757-4598-832f-d8223e2f4d66	2025-06-13 04:35:08.453572+00	2025-06-13 04:35:08.453572+00	password	f1020d8a-a93c-4ce3-bba7-ccd1a18a3a61
dd8de348-cd7d-4908-bed0-2e48dfdf8d79	2025-06-13 04:45:18.147104+00	2025-06-13 04:45:18.147104+00	password	ac31d041-0914-4751-a510-ab10e4cff547
d569edf6-fd5d-43fc-9eac-eb02b96e6d2e	2025-06-13 04:50:56.470828+00	2025-06-13 04:50:56.470828+00	password	73ccdeae-60ab-492f-b612-ba2254f1555e
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
00000000-0000-0000-0000-000000000000	334	6ieon7goljek	e368b85d-7038-4211-be16-c959c7931de0	f	2025-06-11 02:34:01.111052+00	2025-06-11 02:34:01.111052+00	\N	e93edc03-b75b-4abf-bb7e-c96fd1b4a725
00000000-0000-0000-0000-000000000000	336	v4mqyhxexbts	e368b85d-7038-4211-be16-c959c7931de0	f	2025-06-13 03:53:39.908487+00	2025-06-13 03:53:39.908487+00	\N	4b50521e-d51c-448a-a241-b9129fa8f1f7
00000000-0000-0000-0000-000000000000	337	3vamvzuprfdq	e368b85d-7038-4211-be16-c959c7931de0	f	2025-06-13 04:08:47.712296+00	2025-06-13 04:08:47.712296+00	\N	8d944f98-cb27-4164-9f73-ff88350caf5a
00000000-0000-0000-0000-000000000000	340	i4xu6coc7qkk	8c75fb07-ba4b-4df0-badd-6f7b8a3a8361	f	2025-06-13 04:34:52.301936+00	2025-06-13 04:34:52.301936+00	\N	6d84216c-747c-4ee2-b6df-193cebf636d5
00000000-0000-0000-0000-000000000000	341	pra6ingwshb2	8c75fb07-ba4b-4df0-badd-6f7b8a3a8361	f	2025-06-13 04:35:08.452399+00	2025-06-13 04:35:08.452399+00	\N	453d65f7-f757-4598-832f-d8223e2f4d66
00000000-0000-0000-0000-000000000000	343	qzfy5h55gvz7	6477eb40-4562-4138-97e1-56d9cea1bd3d	f	2025-06-13 04:45:18.143787+00	2025-06-13 04:45:18.143787+00	\N	dd8de348-cd7d-4908-bed0-2e48dfdf8d79
00000000-0000-0000-0000-000000000000	344	67l5hmg4grke	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	f	2025-06-13 04:50:56.468031+00	2025-06-13 04:50:56.468031+00	\N	d569edf6-fd5d-43fc-9eac-eb02b96e6d2e
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
e93edc03-b75b-4abf-bb7e-c96fd1b4a725	e368b85d-7038-4211-be16-c959c7931de0	2025-06-11 02:34:01.108946+00	2025-06-11 02:34:01.108946+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36	14.191.121.217	\N
4b50521e-d51c-448a-a241-b9129fa8f1f7	e368b85d-7038-4211-be16-c959c7931de0	2025-06-13 03:53:39.907188+00	2025-06-13 03:53:39.907188+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	118.70.234.100	\N
8d944f98-cb27-4164-9f73-ff88350caf5a	e368b85d-7038-4211-be16-c959c7931de0	2025-06-13 04:08:47.711102+00	2025-06-13 04:08:47.711102+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1	42.119.230.60	\N
6d84216c-747c-4ee2-b6df-193cebf636d5	8c75fb07-ba4b-4df0-badd-6f7b8a3a8361	2025-06-13 04:34:52.299165+00	2025-06-13 04:34:52.299165+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36 Edg/137.0.0.0	42.119.230.60	\N
453d65f7-f757-4598-832f-d8223e2f4d66	8c75fb07-ba4b-4df0-badd-6f7b8a3a8361	2025-06-13 04:35:08.451686+00	2025-06-13 04:35:08.451686+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36 Edg/137.0.0.0	42.119.230.60	\N
dd8de348-cd7d-4908-bed0-2e48dfdf8d79	6477eb40-4562-4138-97e1-56d9cea1bd3d	2025-06-13 04:45:18.142394+00	2025-06-13 04:45:18.142394+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	171.252.153.8	\N
d569edf6-fd5d-43fc-9eac-eb02b96e6d2e	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-06-13 04:50:56.465137+00	2025-06-13 04:50:56.465137+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36	171.252.153.8	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
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
00000000-0000-0000-0000-000000000000	6477eb40-4562-4138-97e1-56d9cea1bd3d	authenticated	authenticated	3122560072@gmail.com	$2a$10$PNOpGoZhRRcOI24PvQgFQOV/cCkreWdE4ZukoE8XhBvLFQm92H29S	2025-02-21 05:51:03.423192+00	\N		\N		\N			\N	2025-06-13 04:45:18.142331+00	{"provider": "email", "providers": ["email"]}	{"sub": "6477eb40-4562-4138-97e1-56d9cea1bd3d", "role": "student", "email": "3122560072@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 05:51:03.412102+00	2025-06-13 04:45:18.146539+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	authenticated	authenticated	gv001@gmail.com	$2a$10$HuDproFlUhxw.If2V3toY.hJRjBbWToO7Pu8VgprWUMycxgbNYx/q	2025-02-21 05:51:53.363042+00	\N		\N		\N			\N	2025-06-13 04:50:56.465061+00	{"provider": "email", "providers": ["email"]}	{"sub": "e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0", "role": "teacher", "email": "gv001@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 05:51:53.358174+00	2025-06-13 04:50:56.470213+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e368b85d-7038-4211-be16-c959c7931de0	authenticated	authenticated	3122410449@gmail.com	$2a$10$Uy/CoRS/8ExltTwchGAayObrIGQ2y.NlPAkKsgLObop8CXcaVt/7e	2025-02-21 10:17:00.938163+00	\N		\N		\N			\N	2025-06-13 04:08:47.711024+00	{"provider": "email", "providers": ["email"]}	{"sub": "e368b85d-7038-4211-be16-c959c7931de0", "role": "student", "email": "3122410449@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 10:17:00.927194+00	2025-06-13 04:08:47.714397+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	8c75fb07-ba4b-4df0-badd-6f7b8a3a8361	authenticated	authenticated	gv003@gmail.com	$2a$10$MI9Uu3K0NL/Z.hsRZ34I0.y/YDdpF5FuhJMvzhTehLBTznKx/7K0e	2025-06-13 04:34:52.289591+00	\N		\N		\N			\N	2025-06-13 04:35:08.451606+00	{"provider": "email", "providers": ["email"]}	{"sub": "8c75fb07-ba4b-4df0-badd-6f7b8a3a8361", "role": "teacher", "email": "gv003@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-06-13 04:34:52.264403+00	2025-06-13 04:35:08.453271+00	\N	\N			\N		0	\N		\N	f	\N	f
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
\.


--
-- Data for Name: assignment_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assignment_questions (id, assignment_id, content, type, points, options, correct_answer, created_at, updated_at) FROM stdin;
4	acf49c50-13c9-401e-8110-da65c9f4c3d7	C├óu hß╗Åi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-12 17:46:19.824+00	2025-03-12 17:46:19.824+00
5	acf49c50-13c9-401e-8110-da65c9f4c3d7	C├óu hß╗Åi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-12 17:46:19.824+00	2025-03-12 17:46:19.824+00
6	6e6b7624-6fd6-4408-825d-a746e1350169	C├óu hß╗Åi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 06:02:53.278+00	2025-03-13 06:02:53.278+00
7	6e6b7624-6fd6-4408-825d-a746e1350169	C├óu hß╗Åi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 06:02:53.278+00	2025-03-13 06:02:53.278+00
8	a6c2d509-8657-41d8-a902-6a08cf469475	C├óu hß╗Åi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 07:30:13.309+00	2025-03-13 07:30:13.309+00
9	a6c2d509-8657-41d8-a902-6a08cf469475	C├óu hß╗Åi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 07:30:13.309+00	2025-03-13 07:30:13.309+00
10	efc5beaf-e8f7-4b99-9903-a33925502c89	C├óu hß╗Åi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 07:36:59.469+00	2025-03-13 07:36:59.469+00
11	efc5beaf-e8f7-4b99-9903-a33925502c89	C├óu hß╗Åi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 07:36:59.469+00	2025-03-13 07:36:59.469+00
12	ced581ce-dc6b-4b05-8c58-fd811fc0da53	C├óu hß╗Åi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 08:00:36.353+00	2025-03-13 08:00:36.353+00
13	ced581ce-dc6b-4b05-8c58-fd811fc0da53	C├óu hß╗Åi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 08:00:36.353+00	2025-03-13 08:00:36.353+00
14	fa6c67af-421d-4b01-b9e5-4b951ad7ebc5	C├óu hß╗Åi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 08:30:22.47+00	2025-03-13 08:30:22.47+00
15	fa6c67af-421d-4b01-b9e5-4b951ad7ebc5	C├óu hß╗Åi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 08:30:22.47+00	2025-03-13 08:30:22.47+00
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
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classes (id, subject_id, teacher_id, code, name, semester, academic_year, status, created_at, updated_at) FROM stdin;
aaf54224-49e8-45a4-93ba-e3f2aae82827	f7bdff59-8976-44ba-910d-52708eb4b387	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	001	KTPM	2	2025-2026	active	2025-02-21 10:38:44.507435+00	2025-02-21 10:38:44.507435+00
5f9c94a6-6bb5-4a65-a0ee-2b9fce239e5e	7d453c44-5359-4087-a27e-5ed40dd80c04	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	002	to├ín cao cß║Ñp	1	2024-2025	active	2025-02-23 07:56:46.187414+00	2025-02-23 07:56:46.187414+00
\.


--
-- Data for Name: enrollments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.enrollments (id, class_id, student_id, status, created_at, updated_at) FROM stdin;
c0dc63ec-734c-4a52-8a8f-45f849651f95	aaf54224-49e8-45a4-93ba-e3f2aae82827	6477eb40-4562-4138-97e1-56d9cea1bd3d	enrolled	2025-03-13 04:47:39.666+00	2025-03-13 04:47:39.666+00
fc358116-8098-41ab-8808-24a7fd351507	aaf54224-49e8-45a4-93ba-e3f2aae82827	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	enrolled	2025-06-10 09:34:08.969+00	2025-06-10 09:34:08.969+00
baf14799-fb83-4d90-96f6-9328fcfefac2	aaf54224-49e8-45a4-93ba-e3f2aae82827	e368b85d-7038-4211-be16-c959c7931de0	enrolled	2025-06-10 09:49:27.899+00	2025-06-10 09:49:27.899+00
\.


--
-- Data for Name: exam_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exam_questions (id, exam_id, content, type, points, options, correct_answer, created_at, updated_at) FROM stdin;
de6727e3-4994-4b76-b422-0272cdd676fc	d81f5313-5f72-48ca-a50b-8beb332925d2	vinh c├│ ─æß║╣p trai kh├┤ng	essay	1.00	\N	kh├┤ng	2025-03-02 01:55:04.328+00	2025-03-02 01:55:04.328+00
8cd896c7-6d8c-4f3e-9058-06eaed8b4b39	36b8bc63-fae9-46a8-8e58-fb8258fd1afe	thß╗ïnh ngu 	essay	1.00	\N	sure 8\n	2025-03-02 02:19:37.453+00	2025-03-02 03:18:45.531+00
a8528c2e-a8c2-45b4-846d-fac017996297	36b8bc63-fae9-46a8-8e58-fb8258fd1afe	sß╗æ b├⌐ nhß║Ñt	multiple_choice	1.00	["1", "2", "3", "4"]	4	2025-03-02 02:15:14.485+00	2025-03-02 03:29:52.007+00
1c88e02b-9a95-4edc-a532-6ca25bccd594	50811f3a-0104-4f9c-881a-671bd78a8a95	C├óu hß╗Åi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-12 12:11:47.593+00	2025-03-12 12:11:47.593+00
b0b85e02-be65-4777-9dc3-d8bda65f167b	50811f3a-0104-4f9c-881a-671bd78a8a95	C├óu hß╗Åi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-12 12:11:47.593+00	2025-03-12 12:11:47.593+00
77d8cadb-1709-4957-8ee1-bdad787a07f6	1f5a3d60-be45-43fd-a245-723f893097e1	C├óu hß╗Åi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 06:54:09.926333+00	2025-03-13 06:54:09.926333+00
b52420bd-9069-4113-8406-02a27d868227	1f5a3d60-be45-43fd-a245-723f893097e1	C├óu hß╗Åi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 06:54:10.232158+00	2025-03-13 06:54:10.232158+00
8313bdcf-f003-4647-9550-72b47817f8bc	9a30d932-ab3f-41bf-906b-cd1fcdd6ce86	C├óu hß╗Åi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 07:13:36.377011+00	2025-03-13 07:13:36.377011+00
afc202f3-61ba-422a-81dd-918b3c905093	9a30d932-ab3f-41bf-906b-cd1fcdd6ce86	C├óu hß╗Åi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 07:13:36.655471+00	2025-03-13 07:13:36.655471+00
186467aa-3278-4b1b-843c-c9ad3e2c1ee7	4533fdb7-af3f-4fff-9a7f-df6f286a36e8	C├óu hß╗Åi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 07:16:38.665901+00	2025-03-13 07:16:38.665901+00
04c61995-7bd5-4254-8cba-f80dbfd9c839	4533fdb7-af3f-4fff-9a7f-df6f286a36e8	C├óu hß╗Åi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 07:16:38.957732+00	2025-03-13 07:16:38.957732+00
c75abbd4-a4cb-40f7-a72e-2296e3af795e	ab945f25-110f-4119-bdbe-cb339ca2bd9b	Con cho ngoc tuan	essay	1.00	\N	Con cho ngoc tuan	2025-03-13 07:17:48.313+00	2025-03-13 07:17:48.313+00
5cff9703-5d2d-4022-9c4a-2d80a643f44f	3655bf81-20c2-43a1-a6b2-da4d72054b30	Testing	essay	1.00	\N	Testing	2025-03-13 08:35:09.79+00	2025-03-13 08:35:09.79+00
c3b19741-92c3-42ca-ae8f-380939ec2ce3	271dd5c5-1722-47b7-ba91-c820ae14a516	HUHU	essay	1.00	\N	HUHU	2025-03-13 09:00:41.641+00	2025-03-13 09:00:41.641+00
84aad881-753b-4c03-a6df-1c65f8e6aedf	7f142382-b919-416b-9ba4-ba90b5ade693	C├óu hß╗Åi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 09:15:45.000405+00	2025-03-13 09:15:45.000405+00
48e68065-8940-4999-93ca-676f705fc6ec	7f142382-b919-416b-9ba4-ba90b5ade693	C├óu hß╗Åi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 09:15:45.27192+00	2025-03-13 09:15:45.27192+00
dd774f16-92b5-4fa9-8ab0-cb3491fcfca6	491cc00e-437e-42b9-961e-08416385d196	ASD	essay	1.00	\N	ASD	2025-03-13 09:16:48.186+00	2025-03-13 09:16:48.186+00
a5047063-6e86-4b3a-b02b-c2cd29bdb897	eec01f13-aa8d-4c36-ab2f-9adac08b0aa4	C├óu hß╗Åi: 1 + 1 = ?	multiple_choice	1.00	"[\\"A. 1\\",\\"B. 2\\",\\"C. 3\\",\\"D. 4\\"]"	B. 2	2025-03-13 09:18:16.348032+00	2025-03-13 09:18:16.348032+00
4b8dcf28-84ac-4db3-a7cc-ace875fdaf93	eec01f13-aa8d-4c36-ab2f-9adac08b0aa4	C├óu hß╗Åi: 2 x 2 = ?	multiple_choice	1.00	"[\\"A. 2\\",\\"B. 3\\",\\"C. 4\\",\\"D. 5\\"]"	C. 4	2025-03-13 09:18:16.610738+00	2025-03-13 09:18:16.610738+00
\.


--
-- Data for Name: exam_submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exam_submissions (id, exam_id, student_id, answers, score, submitted_at, graded_at, feedback, created_at, updated_at, file_url, content) FROM stdin;
2288d281-ceb4-44a8-833d-013bc70e5e3b	1f5a3d60-be45-43fd-a245-723f893097e1	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"77d8cadb-1709-4957-8ee1-bdad787a07f6": "B. 2", "b52420bd-9069-4113-8406-02a27d868227": "C. 4"}	\N	2025-03-13 07:04:27.136+00	\N	\N	2025-03-13 07:04:27.847181+00	2025-03-13 07:04:27.847181+00	\N	\N
a6824a27-8725-4066-8f4d-d29162c511c2	9a30d932-ab3f-41bf-906b-cd1fcdd6ce86	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"8313bdcf-f003-4647-9550-72b47817f8bc": "B. 2", "afc202f3-61ba-422a-81dd-918b3c905093": "C. 4"}	2.00	2025-03-13 07:13:51.816+00	2025-03-13 07:13:51.816+00	\N	2025-03-13 07:13:52.531743+00	2025-03-13 07:13:52.531743+00	\N	\N
9071e634-f857-4ce1-8f1e-3664f68373be	ab945f25-110f-4119-bdbe-cb339ca2bd9b	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"c75abbd4-a4cb-40f7-a72e-2296e3af795e": "Con cho ngoc tuan"}	\N	2025-03-13 07:18:44.703+00	\N	\N	2025-03-13 07:18:45.379486+00	2025-03-13 07:18:45.379486+00	\N	\N
d331b8a8-a576-4fe4-a069-2c25c2f16fac	3655bf81-20c2-43a1-a6b2-da4d72054b30	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"5cff9703-5d2d-4022-9c4a-2d80a643f44f": "Test"}	\N	2025-03-13 08:42:25.636+00	\N	\N	2025-03-13 08:42:26.211347+00	2025-03-13 08:42:26.211347+00	\N	\N
189226f8-b076-4b89-8952-3e1278158d94	271dd5c5-1722-47b7-ba91-c820ae14a516	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"c3b19741-92c3-42ca-ae8f-380939ec2ce3": "huhu"}	\N	2025-03-13 09:01:11.279+00	\N	\N	2025-03-13 09:01:11.753335+00	2025-03-13 09:01:11.753335+00	\N	\N
d11e5774-29dc-4229-9708-303e17855385	4533fdb7-af3f-4fff-9a7f-df6f286a36e8	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"04c61995-7bd5-4254-8cba-f80dbfd9c839": "C. 4", "186467aa-3278-4b1b-843c-c9ad3e2c1ee7": "B. 2"}	\N	2025-03-13 09:12:51.106+00	\N	\N	2025-03-13 09:12:51.618805+00	2025-03-13 09:12:51.618805+00	\N	\N
2d5e2090-ec7c-477e-a815-db87ce3892ee	7f142382-b919-416b-9ba4-ba90b5ade693	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"48e68065-8940-4999-93ca-676f705fc6ec": "C. 4", "84aad881-753b-4c03-a6df-1c65f8e6aedf": "B. 2"}	2.00	2025-03-13 09:16:17.498+00	2025-03-13 09:16:17.498+00	\N	2025-03-13 09:16:18.024809+00	2025-03-13 09:16:18.024809+00	\N	\N
1d9eeddc-18d9-4f7f-a6bd-de70eab3c866	491cc00e-437e-42b9-961e-08416385d196	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"dd774f16-92b5-4fa9-8ab0-cb3491fcfca6": "ASD"}	0.00	2025-03-13 09:17:06.365+00	2025-03-13 09:17:06.365+00	\N	2025-03-13 09:17:06.839282+00	2025-03-13 09:17:06.839282+00	\N	\N
b86de749-790a-415e-a294-98f5e031b32f	eec01f13-aa8d-4c36-ab2f-9adac08b0aa4	6477eb40-4562-4138-97e1-56d9cea1bd3d	{"4b8dcf28-84ac-4db3-a7cc-ace875fdaf93": "C. 4", "a5047063-6e86-4b3a-b02b-c2cd29bdb897": "B. 2"}	2.00	2025-03-13 09:18:38.384+00	2025-03-13 09:18:38.384+00	\N	2025-03-13 09:18:38.831754+00	2025-03-13 09:18:38.831754+00	\N	\N
d0b40bfd-878f-4672-a2a9-1e33746a479e	7f142382-b919-416b-9ba4-ba90b5ade693	e368b85d-7038-4211-be16-c959c7931de0	{"48e68065-8940-4999-93ca-676f705fc6ec": "C. 4", "84aad881-753b-4c03-a6df-1c65f8e6aedf": "B. 2"}	2.00	2025-03-23 08:30:50.692+00	2025-03-23 08:30:50.692+00	\N	2025-03-23 08:30:54.9083+00	2025-03-23 08:30:54.9083+00	\N	\N
39b75a5e-49e4-44dc-b123-c72442597c58	3655bf81-20c2-43a1-a6b2-da4d72054b30	e368b85d-7038-4211-be16-c959c7931de0	{"5cff9703-5d2d-4022-9c4a-2d80a643f44f": "cc"}	\N	2025-03-23 08:31:08.683+00	\N	\N	2025-03-23 08:31:12.459865+00	2025-03-23 08:31:12.459865+00	\N	\N
\.


--
-- Data for Name: exams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exams (id, class_id, title, description, type, duration, total_points, start_time, end_time, status, created_at, updated_at) FROM stdin;
d81f5313-5f72-48ca-a50b-8beb332925d2	5f9c94a6-6bb5-4a65-a0ee-2b9fce239e5e	123	<p>12312</p>	quiz	60	100.00	2025-02-24 18:41:00+00	2025-02-25 18:41:00+00	completed	2025-02-24 11:41:40.682+00	2025-02-24 11:41:40.682+00
36b8bc63-fae9-46a8-8e58-fb8258fd1afe	5f9c94a6-6bb5-4a65-a0ee-2b9fce239e5e	si├¬u kh├│	<p>si├¬u si├¬u kh├│</p>	midterm	60	100.00	2025-02-26 15:19:00+00	2025-02-27 15:19:00+00	completed	2025-02-26 08:19:23.235+00	2025-02-26 08:19:23.236+00
c942eb00-cc3b-4be7-b23c-d4e2933cdc41	aaf54224-49e8-45a4-93ba-e3f2aae82827	SV VINH	<p>SV VINH</p>	quiz	60	100.00	2025-03-13 13:03:00+00	2025-03-13 21:03:00+00	completed	2025-03-13 06:04:02.156+00	2025-03-13 06:04:02.156+00
26d3662f-889b-420a-a3da-2c50e41c654c	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing 2	<p>Testing 2</p>	quiz	60	100.00	2025-03-13 13:29:00+00	2025-03-13 17:29:00+00	completed	2025-03-13 06:29:33.318+00	2025-03-13 06:29:33.318+00
928acdd9-d12b-48d3-84ec-3b1c3dbaf798	aaf54224-49e8-45a4-93ba-e3f2aae82827	KTPM	<p>KTPM</p>	quiz	10	100.00	2025-02-27 07:48:00+00	2025-02-27 07:58:00+00	completed	2025-02-27 00:48:46.582+00	2025-02-27 00:48:46.582+00
8209bb19-9fc4-4771-80b1-bd678e6201e3	aaf54224-49e8-45a4-93ba-e3f2aae82827	KTPM	<p>KTPM</p>	final	60	100.00	2025-02-27 09:47:00+00	2025-02-28 09:47:00+00	completed	2025-02-27 02:47:42.193+00	2025-02-27 02:47:42.193+00
b76117de-0b65-408d-92fe-3e545606c470	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing 4	<p>Testing 4</p>	quiz	60	100.00	2025-03-13 13:32:00+00	2025-03-13 19:33:00+00	completed	2025-03-13 06:33:03.887+00	2025-03-13 06:33:03.887+00
50811f3a-0104-4f9c-881a-671bd78a8a95	aaf54224-49e8-45a4-93ba-e3f2aae82827	CON CHO VINH	<p>ASDA</p>	quiz	30	100.00	2025-03-13 01:20:00+00	2025-03-13 01:58:00+00	completed	2025-03-12 11:38:13.474+00	2025-03-12 11:38:13.474+00
ab945f25-110f-4119-bdbe-cb339ca2bd9b	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing 8	<p>Testing 8</p>	quiz	60	100.00	2025-03-13 14:17:00+00	2025-03-13 19:17:00+00	completed	2025-03-13 07:17:39.873+00	2025-03-13 07:17:39.874+00
9a30d932-ab3f-41bf-906b-cd1fcdd6ce86	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing 6	<p>Testing 6</p>	quiz	60	100.00	2025-03-13 13:38:00+00	2025-03-13 16:38:00+00	completed	2025-03-13 06:38:13.511+00	2025-03-13 06:38:13.511+00
271dd5c5-1722-47b7-ba91-c820ae14a516	aaf54224-49e8-45a4-93ba-e3f2aae82827	CON CHO NGOC TUAN	<p>CON CHO NGOC TUAN</p>	quiz	60	100.00	2025-03-13 16:00:00+00	2025-03-13 20:00:00+00	completed	2025-03-13 09:00:32.098+00	2025-03-13 09:00:32.098+00
f0b94c97-4a5c-4907-8bf1-4259492ff710	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing	<p>Testing</p>	quiz	60	100.00	2025-03-13 13:23:00+00	2025-03-13 20:23:00+00	completed	2025-03-13 06:24:15.845+00	2025-03-13 06:24:15.845+00
1f5a3d60-be45-43fd-a245-723f893097e1	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing 5	<p>Testing 5</p>	quiz	60	100.00	2025-03-13 13:36:00+00	2025-03-13 19:36:00+00	completed	2025-03-13 06:36:57.734+00	2025-03-13 06:36:57.734+00
4533fdb7-af3f-4fff-9a7f-df6f286a36e8	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing 7	<p>Testing 7</p>	quiz	60	100.00	2025-03-13 14:16:00+00	2025-03-13 19:16:00+00	completed	2025-03-13 07:16:31.849+00	2025-03-13 07:16:31.849+00
7f142382-b919-416b-9ba4-ba90b5ade693	aaf54224-49e8-45a4-93ba-e3f2aae82827	Tester 10	<p>Tester 10</p>	quiz	60	100.00	2025-03-13 16:15:00+00	2025-03-29 16:15:00+00	completed	2025-03-13 09:15:40.337+00	2025-03-13 09:15:40.337+00
3655bf81-20c2-43a1-a6b2-da4d72054b30	aaf54224-49e8-45a4-93ba-e3f2aae82827	TEST	<p>TEST</p>	quiz	60	100.00	2025-03-13 15:36:00+00	2025-03-29 15:34:00+00	completed	2025-03-13 08:34:59.19+00	2025-03-13 08:34:59.19+00
36776f71-44b9-41e4-becd-189c67b2e916	aaf54224-49e8-45a4-93ba-e3f2aae82827	Testing 3	<p>Testing 3</p>	quiz	60	100.00	2025-03-13 05:31:00+00	2025-03-31 08:31:00+00	completed	2025-03-13 06:31:07.829+00	2025-03-13 06:31:07.829+00
eec01f13-aa8d-4c36-ab2f-9adac08b0aa4	aaf54224-49e8-45a4-93ba-e3f2aae82827	ADSDASD	<p>ADSDASD</p>	quiz	60	100.00	2025-03-13 02:18:00+00	2025-03-27 07:18:00+00	completed	2025-03-13 09:18:12.722+00	2025-03-13 09:18:12.722+00
491cc00e-437e-42b9-961e-08416385d196	aaf54224-49e8-45a4-93ba-e3f2aae82827	KTPMASD	<p>KTPMASD</p>	quiz	60	100.00	2025-03-13 02:16:00+00	2025-05-31 07:16:00+00	completed	2025-03-13 09:16:40.865+00	2025-03-13 09:16:40.865+00
\.


--
-- Data for Name: lectures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lectures (id, class_id, title, description, file_url, file_type, file_size, download_count, created_at, updated_at, original_filename) FROM stdin;
0528f4ef-8fa0-4661-be6d-bcfcf1777553	aaf54224-49e8-45a4-93ba-e3f2aae82827	Ch╞░╞íng 2	B├ái 2	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/0.602822338939019.pdf	application/pdf	356827	0	2025-02-28 01:57:23.848999+00	2025-02-28 01:57:23.848999+00	\N
82163c1e-64b9-47bf-b3b7-146e00c5312d	aaf54224-49e8-45a4-93ba-e3f2aae82827	Chß╗ënh sß╗¡a tß║ío b├ái giß║úng 2	Chß╗ënh sß╗¡a tß║ío b├ái giß║úng 2	blob:http://localhost:3000/c3bc4b68-a674-46bf-8987-d84db63a1258	application/vnd.openxmlformats-officedocument.wordprocessingml.document	670427	0	2025-03-15 09:48:29.657+00	2025-03-15 09:48:29.657+00	\N
f4aa5a54-3230-47fd-9ab6-41ce774f8867	aaf54224-49e8-45a4-93ba-e3f2aae82827	Link b├ái 1	Test	https://www.youtube.com/watch?v=q23RCXNfZUM	video	0	0	2025-03-15 09:31:00.5365+00	2025-03-15 09:31:00.5365+00	\N
b58149db-6104-419f-b015-835febe2c11f	aaf54224-49e8-45a4-93ba-e3f2aae82827	Chß╗ënh sß╗¡a tß║ío b├ái giß║úng	Chß╗ënh sß╗¡a tß║ío b├ái giß║úng	blob:http://localhost:3000/49d15b1f-8f2c-4b65-b6ac-73c7ebfb6868	application/vnd.openxmlformats-officedocument.wordprocessingml.document	18884	0	2025-03-15 09:46:09.489+00	2025-03-15 09:46:09.489+00	\N
ef80992a-536a-476e-9b43-64410e10a50c	aaf54224-49e8-45a4-93ba-e3f2aae82827	Chß╗ënh sß╗¡a tß║ío b├ái giß║úng 3	Chß╗ënh sß╗¡a tß║ío b├ái giß║úng 3	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/tkktk6lkly.pdf	application/pdf	98273	0	2025-03-15 09:48:55.25+00	2025-03-15 09:48:55.25+00	\N
67d31394-4287-4b7f-b881-9e61381fe8d0	aaf54224-49e8-45a4-93ba-e3f2aae82827	1	1	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/uxuh8ef3cp.docx|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/anwlne2psws.pdf	application/vnd.openxmlformats-officedocument.wordprocessingml.document|||application/pdf	15824	0	2025-06-10 11:22:34.115739+00	2025-06-10 11:22:34.115739+00	\N
a325b81b-729d-4a2f-adaf-c5fb2d7a9433	aaf54224-49e8-45a4-93ba-e3f2aae82827	TEST	TEST	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/hd7ta3d6jnu.docx|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/0dux16dgpd2.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document|||application/vnd.openxmlformats-officedocument.wordprocessingml.document	3280687	0	2025-06-13 04:25:27.226887+00	2025-06-13 04:25:27.226887+00	\N
1372b476-db45-4e8a-9730-baa04264b4c6	aaf54224-49e8-45a4-93ba-e3f2aae82827	TEST2	TEST2	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/owbbaw0hm6l.docx|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/3566qp5vbqs.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document|||application/vnd.openxmlformats-officedocument.wordprocessingml.document	3280687	0	2025-06-13 04:32:10.341991+00	2025-06-13 04:32:10.341991+00	\N
54a5f087-e494-4f1c-ad09-9866ff841b25	aaf54224-49e8-45a4-93ba-e3f2aae82827	TEST3	TEST3	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/6gwjy7bwe27.docx|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/hxtho25nqvp.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document|||application/vnd.openxmlformats-officedocument.wordprocessingml.document	3280687	0	2025-06-13 04:37:33.070361+00	2025-06-13 04:37:33.070361+00	\N
6a46b5db-e9f4-462a-bc6b-0ce612f49666	aaf54224-49e8-45a4-93ba-e3f2aae82827	TEST4	TEST4	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/d9l2aus8r2v.docx|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/cxy22csnucb.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document|||application/vnd.openxmlformats-officedocument.wordprocessingml.document	3280687	0	2025-06-13 04:38:30.725661+00	2025-06-13 04:38:30.725661+00	Nß╗ÿI DUNG THI WEB2.docx|||OnTap_LTWebvaUDNC_DHSG.docx
4a952cac-fa8c-4ad8-aea0-782c37f90c99	aaf54224-49e8-45a4-93ba-e3f2aae82827	TEST5	ORIGINAL NAMES	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/sltxhobf66.docx|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/zxwh0jtz2u.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document|||application/vnd.openxmlformats-officedocument.wordprocessingml.document	3381500	0	2025-06-13 04:41:49.620446+00	2025-06-13 04:41:49.620446+00	Nh├│m 02.docx|||Nß╗ÿI DUNG THI WEB2.docx
2469a58c-bb25-48e5-9120-4cade0e1f3d6	aaf54224-49e8-45a4-93ba-e3f2aae82827	TEST6	TEST6	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/2x6iwdmrmh8.pdf|||https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/zwzqycchgt.pdf	application/pdf|||application/pdf	7429866	0	2025-06-13 04:44:44.155297+00	2025-06-13 04:44:44.155297+00	KHMT-Huong dan trinh bay do an (1).pdf|||Ai_for_Student_Phien_ban_Tieng_Viet_SIHUB.pdf
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, student_id, full_name, role, class_code, created_at, updated_at, status) FROM stdin;
620de24c-a40a-432a-be36-86852092f3c1	3122569172	Thinh Dinh	student	CNT01	2025-02-21 05:37:06.999379+00	2025-02-21 05:37:07.281+00	active
6477eb40-4562-4138-97e1-56d9cea1bd3d	3122560072	Thinh Dinh	student	CNT01	2025-02-21 05:51:03.411747+00	2025-02-21 05:51:03.734+00	active
e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	gv001	Ng├┤ Thß╗ï Kim V╞░╞íng	teacher		2025-02-21 05:51:53.357839+00	2025-02-21 05:51:53.67+00	active
e368b85d-7038-4211-be16-c959c7931de0	3122410449	Nguyß╗àn Ngß╗ìc Tuß║Ñn	student	DCT1225	2025-02-21 10:17:00.92684+00	2025-02-21 10:17:00.127+00	active
557d4ebc-ccbf-4402-ae59-4dd4b357e97c	3122410471	─æß║╖ng thß║┐ vinh	teacher	12a8	2025-02-21 08:15:30.199374+00	2025-04-28 06:00:18.683+00	active
8c75fb07-ba4b-4df0-badd-6f7b8a3a8361	gv003	B├ánh Thß╗ï B├⌐l	teacher	DCT1226	2025-06-13 04:34:52.264077+00	2025-06-13 04:34:52.449+00	active
\.


--
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subjects (id, code, name, description, credits, created_at, updated_at) FROM stdin;
f7bdff59-8976-44ba-910d-52708eb4b387	001	KTPM	Kiß╗âm thß╗¡ phß║ºn mß╗üm	4	2025-02-21 10:38:23.204+00	2025-02-21 10:38:23.204+00
7d453c44-5359-4087-a27e-5ed40dd80c04	002	to├ín cao cß║Ñp	rß║Ñt kh├│	3	2025-02-23 07:55:51.242+00	2025-02-23 07:55:51.242+00
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

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 344, true);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: supabase_admin
--

SELECT pg_catalog.setval('pgsodium.key_key_id_seq', 1, false);


--
-- Name: activity_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activity_logs_id_seq', 81, true);


--
-- Name: assignment_questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.assignment_questions_id_seq', 15, true);


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
    ADD CONSTRAINT assignment_submissions_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.profiles(id);


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
-- Name: lectures Giß║úng vi├¬n c├│ thß╗â quß║ún l├╜ b├ái giß║úng cß╗ºa m├¼nh; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giß║úng vi├¬n c├│ thß╗â quß║ún l├╜ b├ái giß║úng cß╗ºa m├¼nh" ON public.lectures USING ((EXISTS ( SELECT 1
   FROM public.classes
  WHERE ((classes.id = lectures.class_id) AND (classes.teacher_id = auth.uid())))));


--
-- Name: exams Giß║úng vi├¬n c├│ thß╗â quß║ún l├╜ b├ái kiß╗âm tra cß╗ºa m├¼nh; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giß║úng vi├¬n c├│ thß╗â quß║ún l├╜ b├ái kiß╗âm tra cß╗ºa m├¼nh" ON public.exams USING ((EXISTS ( SELECT 1
   FROM public.classes
  WHERE ((classes.id = exams.class_id) AND (classes.teacher_id = auth.uid())))));


--
-- Name: assignments Giß║úng vi├¬n c├│ thß╗â quß║ún l├╜ b├ái tß║¡p cß╗ºa m├¼nh; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giß║úng vi├¬n c├│ thß╗â quß║ún l├╜ b├ái tß║¡p cß╗ºa m├¼nh" ON public.assignments USING ((EXISTS ( SELECT 1
   FROM public.classes
  WHERE ((classes.id = assignments.class_id) AND (classes.teacher_id = auth.uid())))));


--
-- Name: exam_questions Giß║úng vi├¬n c├│ thß╗â quß║ún l├╜ c├óu hß╗Åi kiß╗âm tra cß╗ºa ; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giß║úng vi├¬n c├│ thß╗â quß║ún l├╜ c├óu hß╗Åi kiß╗âm tra cß╗ºa " ON public.exam_questions USING ((EXISTS ( SELECT 1
   FROM (public.exams
     JOIN public.classes ON ((classes.id = exams.class_id)))
  WHERE ((exams.id = exam_questions.exam_id) AND (classes.teacher_id = auth.uid())))));


--
-- Name: classes Giß║úng vi├¬n c├│ thß╗â quß║ún l├╜ lß╗¢p hß╗ìc cß╗ºa m├¼nh; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giß║úng vi├¬n c├│ thß╗â quß║ún l├╜ lß╗¢p hß╗ìc cß╗ºa m├¼nh" ON public.classes USING ((auth.uid() = teacher_id));


--
-- Name: enrollments Giß║úng vi├¬n c├│ thß╗â xem danh s├ích sinh vi├¬n ─æ─âng k├╜ l; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giß║úng vi├¬n c├│ thß╗â xem danh s├ích sinh vi├¬n ─æ─âng k├╜ l" ON public.enrollments FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.classes
  WHERE ((classes.id = enrollments.class_id) AND (classes.teacher_id = auth.uid())))));


--
-- Name: subjects Giß║úng vi├¬n c├│ thß╗â xem tß║Ñt cß║ú m├┤n hß╗ìc; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giß║úng vi├¬n c├│ thß╗â xem tß║Ñt cß║ú m├┤n hß╗ìc" ON public.subjects FOR SELECT USING (true);


--
-- Name: exam_submissions Giß║úng vi├¬n c├│ thß╗â xem v├á chß║Ñm b├ái kiß╗âm tra; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giß║úng vi├¬n c├│ thß╗â xem v├á chß║Ñm b├ái kiß╗âm tra" ON public.exam_submissions USING ((EXISTS ( SELECT 1
   FROM (public.exams
     JOIN public.classes ON ((classes.id = exams.class_id)))
  WHERE ((exams.id = exam_submissions.exam_id) AND (classes.teacher_id = auth.uid())))));


--
-- Name: assignment_submissions Giß║úng vi├¬n c├│ thß╗â xem v├á chß║Ñm b├ái tß║¡p; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Giß║úng vi├¬n c├│ thß╗â xem v├á chß║Ñm b├ái tß║¡p" ON public.assignment_submissions USING ((EXISTS ( SELECT 1
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
-- Name: objects Chß╗ë admin c├│ thß╗â xem video chß╗¥ duyß╗çt 1199pmo_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Chß╗ë admin c├│ thß╗â xem video chß╗¥ duyß╗çt 1199pmo_0" ON storage.objects FOR SELECT USING (true);


--
-- Name: objects Chß╗ë admin c├│ thß╗â xem video chß╗¥ duyß╗çt 1199pmo_1; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Chß╗ë admin c├│ thß╗â xem video chß╗¥ duyß╗çt 1199pmo_1" ON storage.objects FOR INSERT WITH CHECK (true);


--
-- Name: objects Chß╗ë admin c├│ thß╗â xem video chß╗¥ duyß╗çt 1199pmo_2; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Chß╗ë admin c├│ thß╗â xem video chß╗¥ duyß╗çt 1199pmo_2" ON storage.objects FOR UPDATE USING (true);


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

