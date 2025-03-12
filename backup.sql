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
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
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


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: postgres
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
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
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


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: postgres
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
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: postgres
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO postgres;

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
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
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
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
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
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);


ALTER TABLE public.exam_submissions OWNER TO postgres;

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
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);


ALTER TABLE public.lectures OWNER TO postgres;

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
-- Name: decrypted_secrets; Type: VIEW; Schema: vault; Owner: supabase_admin
--

CREATE VIEW vault.decrypted_secrets AS
 SELECT secrets.id,
    secrets.name,
    secrets.description,
    secrets.secret,
        CASE
            WHEN (secrets.secret IS NULL) THEN NULL::text
            ELSE
            CASE
                WHEN (secrets.key_id IS NULL) THEN NULL::text
                ELSE convert_from(pgsodium.crypto_aead_det_decrypt(decode(secrets.secret, 'base64'::text), convert_to(((((secrets.id)::text || secrets.description) || (secrets.created_at)::text) || (secrets.updated_at)::text), 'utf8'::name), secrets.key_id, secrets.nonce), 'utf8'::name)
            END
        END AS decrypted_secret,
    secrets.key_id,
    secrets.nonce,
    secrets.created_at,
    secrets.updated_at
   FROM vault.secrets;


ALTER VIEW vault.decrypted_secrets OWNER TO supabase_admin;

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
7f2d9202-c457-4934-9ab8-597d28bf64de	2025-02-24 10:04:00.380817+00	2025-02-24 10:04:00.380817+00	password	a3e176b1-21fb-4eb6-9e68-e7223a20a1ff
48c63613-68b7-457a-bdc9-0be84e80355e	2025-02-26 08:11:12.510075+00	2025-02-26 08:11:12.510075+00	password	d03ebbe8-f5aa-4312-a5fe-4d6d61183a9f
9b60c2f1-2c1d-4eab-ba82-04bb983f8f43	2025-02-26 08:18:36.054904+00	2025-02-26 08:18:36.054904+00	password	fa227453-7a9e-4570-a175-3f03995d2573
b2a1c144-a6a1-448b-8455-fd8324727a91	2025-02-26 10:08:05.852314+00	2025-02-26 10:08:05.852314+00	password	1cd4f39d-4cac-4ec8-8e3e-45f4d6d50da2
87e1d4e1-a14a-4ac1-aa49-e76b2ccbd51a	2025-02-27 02:10:32.630474+00	2025-02-27 02:10:32.630474+00	password	60c9f4ca-934c-4bbb-9f73-97d0f5734942
4f357219-b631-4e2b-8ac0-550c6a92f189	2025-02-21 05:32:45.756468+00	2025-02-21 05:32:45.756468+00	password	d8bce818-321c-4ef5-a143-7e89f42f6ced
04f08f9a-ece0-4c06-822b-35535d3d6fee	2025-02-21 05:34:02.95416+00	2025-02-21 05:34:02.95416+00	password	53514688-70d5-431b-80e3-0bd2b0563c61
f6c6c137-5078-4754-95c7-8fbfc1942ac0	2025-03-01 10:37:41.008984+00	2025-03-01 10:37:41.008984+00	password	5b838963-b6ed-4750-a9a4-ad65408bed4a
c9b80a15-e3f0-4fb3-9d6f-98716fae7e44	2025-02-21 05:51:03.432657+00	2025-02-21 05:51:03.432657+00	password	d85f22b7-e4cd-45fd-8b4f-141786e104b1
fba4752b-d6f7-4a8b-865b-c92fdcd9a9be	2025-03-02 01:34:48.154075+00	2025-03-02 01:34:48.154075+00	password	39df7a61-48c2-41a9-b5d3-fa051a464832
8856798f-3515-4789-839d-7ad2b7b31857	2025-03-02 03:42:14.145705+00	2025-03-02 03:42:14.145705+00	password	dd901471-31d5-4821-adf8-244eda79446c
8f33c327-36d9-4cee-b027-51310aecede2	2025-03-09 03:14:30.504395+00	2025-03-09 03:14:30.504395+00	password	8169396b-4459-43d3-a7e7-3fc78868906b
3f025bb6-1dfc-4bd0-93f6-b1e32c992607	2025-03-11 12:47:41.337405+00	2025-03-11 12:47:41.337405+00	password	5a833436-2c47-47f2-898c-01a3c3c86886
d0249604-7968-46c7-8219-52fab74833d8	2025-03-12 11:37:25.528119+00	2025-03-12 11:37:25.528119+00	password	56978d1d-9e59-41a8-9de7-6fb3ec31ff0d
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
00000000-0000-0000-0000-000000000000	161	jqy60qlULacfuJnQxwol2Q	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	t	2025-02-26 10:08:05.841643+00	2025-03-01 10:37:40.122006+00	\N	b2a1c144-a6a1-448b-8455-fd8324727a91
00000000-0000-0000-0000-000000000000	179	Vx7HuzAnPLssqKjDjUe5wQ	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	f	2025-03-01 10:37:40.133052+00	2025-03-01 10:37:40.133052+00	jqy60qlULacfuJnQxwol2Q	b2a1c144-a6a1-448b-8455-fd8324727a91
00000000-0000-0000-0000-000000000000	180	TpHlUVDwTTbm6IKwhtSrqg	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	t	2025-03-01 10:37:41.004377+00	2025-03-01 11:36:22.942295+00	\N	f6c6c137-5078-4754-95c7-8fbfc1942ac0
00000000-0000-0000-0000-000000000000	181	H38Z-gF1ZAl_IbzVIPxteg	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	t	2025-03-01 11:36:22.944611+00	2025-03-02 01:34:47.096864+00	TpHlUVDwTTbm6IKwhtSrqg	f6c6c137-5078-4754-95c7-8fbfc1942ac0
00000000-0000-0000-0000-000000000000	186	8Bbzjf2oYpYBwJ-b5AhFUQ	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	f	2025-03-02 01:34:47.105246+00	2025-03-02 01:34:47.105246+00	H38Z-gF1ZAl_IbzVIPxteg	f6c6c137-5078-4754-95c7-8fbfc1942ac0
00000000-0000-0000-0000-000000000000	187	qOijRmrMCosQWTI90jfc6g	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	t	2025-03-02 01:34:48.152244+00	2025-03-02 02:33:05.002409+00	\N	fba4752b-d6f7-4a8b-865b-c92fdcd9a9be
00000000-0000-0000-0000-000000000000	188	xB0MuvfNGzC2HooYARxpDA	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	t	2025-03-02 02:33:05.005266+00	2025-03-02 03:32:08.107415+00	qOijRmrMCosQWTI90jfc6g	fba4752b-d6f7-4a8b-865b-c92fdcd9a9be
00000000-0000-0000-0000-000000000000	189	bLUjIX3mg15br6m9PSL15Q	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	f	2025-03-02 03:32:08.109677+00	2025-03-02 03:32:08.109677+00	xB0MuvfNGzC2HooYARxpDA	fba4752b-d6f7-4a8b-865b-c92fdcd9a9be
00000000-0000-0000-0000-000000000000	135	Gg5NCCjAf5RIv8lOl9IoLQ	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	t	2025-02-24 10:04:00.378228+00	2025-02-24 11:09:02.565799+00	\N	7f2d9202-c457-4934-9ab8-597d28bf64de
00000000-0000-0000-0000-000000000000	44	Oag97LI6nqXMECm8PP6qDQ	dc743d86-49ee-43d6-a8c7-eb7a8b032a93	f	2025-02-21 05:32:45.754755+00	2025-02-21 05:32:45.754755+00	\N	4f357219-b631-4e2b-8ac0-550c6a92f189
00000000-0000-0000-0000-000000000000	45	JNs5EHzrajVQCVCnobUwCQ	0af601e2-d596-49c7-9b53-12d86ecb6d12	f	2025-02-21 05:34:02.952481+00	2025-02-21 05:34:02.952481+00	\N	04f08f9a-ece0-4c06-822b-35535d3d6fee
00000000-0000-0000-0000-000000000000	48	Jn16hgUlp-f1Qn3e6EhJIg	6477eb40-4562-4138-97e1-56d9cea1bd3d	f	2025-02-21 05:51:03.42891+00	2025-02-21 05:51:03.42891+00	\N	c9b80a15-e3f0-4fb3-9d6f-98716fae7e44
00000000-0000-0000-0000-000000000000	146	hUwDsHnghLUcdOQsDA_lyQ	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	t	2025-02-24 11:09:02.567508+00	2025-02-26 08:11:10.390432+00	Gg5NCCjAf5RIv8lOl9IoLQ	7f2d9202-c457-4934-9ab8-597d28bf64de
00000000-0000-0000-0000-000000000000	157	JqdCHfcK59xqrZnz1MFNlw	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	f	2025-02-26 08:11:10.401217+00	2025-02-26 08:11:10.401217+00	hUwDsHnghLUcdOQsDA_lyQ	7f2d9202-c457-4934-9ab8-597d28bf64de
00000000-0000-0000-0000-000000000000	158	Xe8R0G4qCpus0aCCyC6a-w	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	f	2025-02-26 08:11:12.507772+00	2025-02-26 08:11:12.507772+00	\N	48c63613-68b7-457a-bdc9-0be84e80355e
00000000-0000-0000-0000-000000000000	159	ZO6-kQ5MmhunYxKREjEzug	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	t	2025-02-26 08:18:36.048673+00	2025-02-26 09:18:33.729326+00	\N	9b60c2f1-2c1d-4eab-ba82-04bb983f8f43
00000000-0000-0000-0000-000000000000	160	jx8_aTy5FTC_oHWpSGvNxQ	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	f	2025-02-26 09:18:33.732765+00	2025-02-26 09:18:33.732765+00	ZO6-kQ5MmhunYxKREjEzug	9b60c2f1-2c1d-4eab-ba82-04bb983f8f43
00000000-0000-0000-0000-000000000000	167	Jdb1aolYxXIFbp7q875Zow	620de24c-a40a-432a-be36-86852092f3c1	f	2025-02-27 02:10:32.624477+00	2025-02-27 02:10:32.624477+00	\N	87e1d4e1-a14a-4ac1-aa49-e76b2ccbd51a
00000000-0000-0000-0000-000000000000	190	r2Qz53_4UAGmi9HN5NPgdA	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	t	2025-03-02 03:42:14.140926+00	2025-03-09 03:14:30.438388+00	\N	8856798f-3515-4789-839d-7ad2b7b31857
00000000-0000-0000-0000-000000000000	191	RcmyAaM3aOqOuHwZaLuGVw	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	f	2025-03-09 03:14:30.442089+00	2025-03-09 03:14:30.442089+00	r2Qz53_4UAGmi9HN5NPgdA	8856798f-3515-4789-839d-7ad2b7b31857
00000000-0000-0000-0000-000000000000	192	GG6CjfRPpyd6hjnJKwnQBw	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	f	2025-03-09 03:14:30.503241+00	2025-03-09 03:14:30.503241+00	\N	8f33c327-36d9-4cee-b027-51310aecede2
00000000-0000-0000-0000-000000000000	195	LwAtVtD-SErWYAy5y0A-WA	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	f	2025-03-11 12:47:41.330972+00	2025-03-11 12:47:41.330972+00	\N	3f025bb6-1dfc-4bd0-93f6-b1e32c992607
00000000-0000-0000-0000-000000000000	196	i0RlK6QnJv87nuPkphZ0Ig	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	f	2025-03-12 11:37:25.516346+00	2025-03-12 11:37:25.516346+00	\N	d0249604-7968-46c7-8219-52fab74833d8
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
b2a1c144-a6a1-448b-8455-fd8324727a91	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	2025-02-26 10:08:05.836844+00	2025-03-01 10:37:40.14421+00	\N	aal1	\N	2025-03-01 10:37:40.144133	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	171.233.235.197	\N
7f2d9202-c457-4934-9ab8-597d28bf64de	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	2025-02-24 10:04:00.376312+00	2025-02-26 08:11:10.420564+00	\N	aal1	\N	2025-02-26 08:11:10.420491	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	171.233.235.197	\N
48c63613-68b7-457a-bdc9-0be84e80355e	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	2025-02-26 08:11:12.491718+00	2025-02-26 08:11:12.491718+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	171.233.235.197	\N
fba4752b-d6f7-4a8b-865b-c92fdcd9a9be	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	2025-03-02 01:34:48.143524+00	2025-03-02 03:32:08.115549+00	\N	aal1	\N	2025-03-02 03:32:08.11546	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	171.233.235.197	\N
4f357219-b631-4e2b-8ac0-550c6a92f189	dc743d86-49ee-43d6-a8c7-eb7a8b032a93	2025-02-21 05:32:45.753778+00	2025-02-21 05:32:45.753778+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	171.252.154.193	\N
04f08f9a-ece0-4c06-822b-35535d3d6fee	0af601e2-d596-49c7-9b53-12d86ecb6d12	2025-02-21 05:34:02.951482+00	2025-02-21 05:34:02.951482+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	171.252.154.193	\N
c9b80a15-e3f0-4fb3-9d6f-98716fae7e44	6477eb40-4562-4138-97e1-56d9cea1bd3d	2025-02-21 05:51:03.427165+00	2025-02-21 05:51:03.427165+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	171.252.154.193	\N
9b60c2f1-2c1d-4eab-ba82-04bb983f8f43	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	2025-02-26 08:18:36.043451+00	2025-02-26 09:18:33.735816+00	\N	aal1	\N	2025-02-26 09:18:33.735742	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	171.233.235.197	\N
87e1d4e1-a14a-4ac1-aa49-e76b2ccbd51a	620de24c-a40a-432a-be36-86852092f3c1	2025-02-27 02:10:32.620458+00	2025-02-27 02:10:32.620458+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	113.161.85.113	\N
f6c6c137-5078-4754-95c7-8fbfc1942ac0	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	2025-03-01 10:37:40.99683+00	2025-03-02 01:34:47.112548+00	\N	aal1	\N	2025-03-02 01:34:47.112478	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	171.233.235.197	\N
8856798f-3515-4789-839d-7ad2b7b31857	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	2025-03-02 03:42:14.135579+00	2025-03-09 03:14:30.450097+00	\N	aal1	\N	2025-03-09 03:14:30.450024	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	118.71.199.102	\N
8f33c327-36d9-4cee-b027-51310aecede2	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	2025-03-09 03:14:30.501655+00	2025-03-09 03:14:30.501655+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	118.71.199.102	\N
3f025bb6-1dfc-4bd0-93f6-b1e32c992607	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-03-11 12:47:41.328728+00	2025-03-11 12:47:41.328728+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0	58.187.187.170	\N
d0249604-7968-46c7-8219-52fab74833d8	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	2025-03-12 11:37:25.509658+00	2025-03-12 11:37:25.509658+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36	171.252.188.245	\N
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
00000000-0000-0000-0000-000000000000	6477eb40-4562-4138-97e1-56d9cea1bd3d	authenticated	authenticated	3122560072@gmail.com	$2a$10$d737uMSIZcwsVyQfrCcxbO2pKsRYhIJ18hdrPi6LJSw1CenJBycMq	2025-02-21 05:51:03.423192+00	\N		\N		\N			\N	2025-02-21 05:51:03.427096+00	{"provider": "email", "providers": ["email"]}	{"sub": "6477eb40-4562-4138-97e1-56d9cea1bd3d", "role": "student", "email": "3122560072@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 05:51:03.412102+00	2025-02-21 05:51:03.432228+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	dc743d86-49ee-43d6-a8c7-eb7a8b032a93	authenticated	authenticated	3122560572@gmail.com	$2a$10$J2yofg3zaPFwvtG/kcFIO.Zcu/soZGLfy8L9HsjM94SykU2gs8Jb6	2025-02-21 05:32:45.750152+00	\N		\N		\N			\N	2025-02-21 05:32:45.753712+00	{"provider": "email", "providers": ["email"]}	{"sub": "dc743d86-49ee-43d6-a8c7-eb7a8b032a93", "role": "student", "email": "3122560572@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 05:32:45.742462+00	2025-02-21 05:32:45.756075+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	2956b155-1d48-4058-acdb-c1151fa5c9fd	authenticated	authenticated	gv002@gmail.com	$2a$10$XeB9HZXUKle57cZzsi.EJu.MTXwFXpmg2Dq0a4I9liN9qnBAV7v/2	2025-02-21 10:44:50.448086+00	\N		\N		\N			\N	2025-02-21 10:45:04.106359+00	{"provider": "email", "providers": ["email"]}	{"sub": "2956b155-1d48-4058-acdb-c1151fa5c9fd", "role": "teacher", "email": "gv002@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 10:44:50.439267+00	2025-02-21 10:45:04.107966+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e368b85d-7038-4211-be16-c959c7931de0	authenticated	authenticated	3122410449@gmail.com	$2a$10$Uy/CoRS/8ExltTwchGAayObrIGQ2y.NlPAkKsgLObop8CXcaVt/7e	2025-02-21 10:17:00.938163+00	\N		\N		\N			\N	2025-02-24 12:32:33.762045+00	{"provider": "email", "providers": ["email"]}	{"sub": "e368b85d-7038-4211-be16-c959c7931de0", "role": "student", "email": "3122410449@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 10:17:00.927194+00	2025-02-24 12:32:33.772321+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	0af601e2-d596-49c7-9b53-12d86ecb6d12	authenticated	authenticated	3122569072@gmail.com	$2a$10$j37/bi/eL88IFmGn3USRbO6hAKCA0ULwghVqTJHYHu3mUaJJvyO9O	2025-02-21 05:34:02.946716+00	\N		\N		\N			\N	2025-02-21 05:34:02.951408+00	{"provider": "email", "providers": ["email"]}	{"sub": "0af601e2-d596-49c7-9b53-12d86ecb6d12", "role": "student", "email": "3122569072@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 05:34:02.939525+00	2025-02-21 05:34:02.953723+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	620de24c-a40a-432a-be36-86852092f3c1	authenticated	authenticated	3122569172@gmail.com	$2a$10$tw4Apk0t.Uh8uuuf5Ma8JOtYHkG0GBmwqYOrOV1usNsPHiwRnhybm	2025-02-21 05:37:07.007255+00	\N		\N		\N			\N	2025-02-27 02:10:32.620378+00	{"provider": "email", "providers": ["email"]}	{"sub": "620de24c-a40a-432a-be36-86852092f3c1", "role": "student", "email": "3122569172@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 05:37:06.999745+00	2025-02-27 02:10:32.629909+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	557d4ebc-ccbf-4402-ae59-4dd4b357e97c	authenticated	authenticated	3122410471@gmail.com	$2a$10$FDdnwzr3TF9sv91voKkklO5Ph27Reoax4Al3wC1orKeswQ8279AYa	2025-02-21 08:15:30.226186+00	\N		\N		\N			\N	2025-03-09 03:14:30.50158+00	{"provider": "email", "providers": ["email"]}	{"sub": "557d4ebc-ccbf-4402-ae59-4dd4b357e97c", "role": "teacher", "email": "3122410471@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 08:15:30.199727+00	2025-03-09 03:14:30.5041+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	authenticated	authenticated	gv001@gmail.com	$2a$10$3s0W1bOVVPUWEgmcYb7tgulu4pV.7VRya0fzoB/oPjaVsDzaF.IoK	2025-02-21 05:51:53.363042+00	\N		\N		\N			\N	2025-03-12 11:37:25.508469+00	{"provider": "email", "providers": ["email"]}	{"sub": "e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0", "role": "teacher", "email": "gv001@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-02-21 05:51:53.358174+00	2025-03-12 11:37:25.526111+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--

COPY pgsodium.key (id, status, created, expires, key_type, key_id, key_context, name, associated_data, raw_key, raw_key_nonce, parent_key, comment, user_data) FROM stdin;
\.


--
-- Data for Name: assignment_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assignment_questions (id, assignment_id, content, type, points, options, correct_answer, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: assignment_submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assignment_submissions (id, assignment_id, student_id, content, file_url, score, submitted_at, graded_at, feedback, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assignments (id, class_id, title, description, due_date, total_points, file_url, created_at, updated_at) FROM stdin;
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
a658b604-c432-42b7-94e8-4b4d4717e156	aaf54224-49e8-45a4-93ba-e3f2aae82827	e368b85d-7038-4211-be16-c959c7931de0	enrolled	2025-02-28 01:46:55.383+00	2025-02-28 01:46:55.384+00
\.


--
-- Data for Name: exam_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exam_questions (id, exam_id, content, type, points, options, correct_answer, created_at, updated_at) FROM stdin;
1a4a7e8c-cf16-4ff6-904f-80816fffa5de	2ab42746-f136-4c70-8ac3-efa2d1841dbf	Kh├╣ng	multiple_choice	1.00	["A", "B", "C", "D"]	\N	2025-03-01 13:23:22.793006+00	2025-03-01 13:23:22.793006+00
de6727e3-4994-4b76-b422-0272cdd676fc	d81f5313-5f72-48ca-a50b-8beb332925d2	vinh c├│ ─æß║╣p trai kh├┤ng	essay	1.00	\N	kh├┤ng	2025-03-02 01:55:04.328+00	2025-03-02 01:55:04.328+00
8cd896c7-6d8c-4f3e-9058-06eaed8b4b39	36b8bc63-fae9-46a8-8e58-fb8258fd1afe	thß╗ïnh ngu 	essay	1.00	\N	sure 8\n	2025-03-02 02:19:37.453+00	2025-03-02 03:18:45.531+00
a8528c2e-a8c2-45b4-846d-fac017996297	36b8bc63-fae9-46a8-8e58-fb8258fd1afe	sß╗æ b├⌐ nhß║Ñt	multiple_choice	1.00	["1", "2", "3", "4"]	4	2025-03-02 02:15:14.485+00	2025-03-02 03:29:52.007+00
\.


--
-- Data for Name: exam_submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exam_submissions (id, exam_id, student_id, answers, score, submitted_at, graded_at, feedback, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: exams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exams (id, class_id, title, description, type, duration, total_points, start_time, end_time, status, created_at, updated_at) FROM stdin;
d81f5313-5f72-48ca-a50b-8beb332925d2	5f9c94a6-6bb5-4a65-a0ee-2b9fce239e5e	123	<p>12312</p>	quiz	60	100.00	2025-02-24 18:41:00+00	2025-02-25 18:41:00+00	upcoming	2025-02-24 11:41:40.682+00	2025-02-24 11:41:40.682+00
36b8bc63-fae9-46a8-8e58-fb8258fd1afe	5f9c94a6-6bb5-4a65-a0ee-2b9fce239e5e	si├¬u kh├│	<p>si├¬u si├¬u kh├│</p>	midterm	60	100.00	2025-02-26 15:19:00+00	2025-02-27 15:19:00+00	upcoming	2025-02-26 08:19:23.235+00	2025-02-26 08:19:23.236+00
928acdd9-d12b-48d3-84ec-3b1c3dbaf798	aaf54224-49e8-45a4-93ba-e3f2aae82827	KTPM	<p>KTPM</p>	quiz	10	100.00	2025-02-27 07:48:00+00	2025-02-27 07:58:00+00	upcoming	2025-02-27 00:48:46.582+00	2025-02-27 00:48:46.582+00
8209bb19-9fc4-4771-80b1-bd678e6201e3	aaf54224-49e8-45a4-93ba-e3f2aae82827	KTPM	<p>KTPM</p>	final	60	100.00	2025-02-27 09:47:00+00	2025-02-28 09:47:00+00	upcoming	2025-02-27 02:47:42.193+00	2025-02-27 02:47:42.193+00
2ab42746-f136-4c70-8ac3-efa2d1841dbf	aaf54224-49e8-45a4-93ba-e3f2aae82827	KTPM	<p>KTPM</p>	quiz	60	100.00	2025-03-01 20:09:00+00	2025-03-01 22:11:00+00	upcoming	2025-03-01 13:09:23.65+00	2025-03-01 13:09:23.65+00
50811f3a-0104-4f9c-881a-671bd78a8a95	aaf54224-49e8-45a4-93ba-e3f2aae82827	Test	<p>ASDA</p>	quiz	60	100.00	2025-03-12 18:38:00+00	2025-03-12 12:38:00+00	upcoming	2025-03-12 11:38:13.474+00	2025-03-12 11:38:13.474+00
\.


--
-- Data for Name: lectures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lectures (id, class_id, title, description, file_url, file_type, file_size, download_count, created_at, updated_at) FROM stdin;
0528f4ef-8fa0-4661-be6d-bcfcf1777553	aaf54224-49e8-45a4-93ba-e3f2aae82827	Ch╞░╞íng 2	B├ái 2	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/0.602822338939019.pdf	application/pdf	356827	0	2025-02-28 01:57:23.848999+00	2025-02-28 01:57:23.848999+00
2d9ec2b9-0788-40b0-94bc-3edbc75a99d2	aaf54224-49e8-45a4-93ba-e3f2aae82827	KTPM	KTPM	https://lrnlbvdgqpazzwbsxhqc.supabase.co/storage/v1/object/public/lectures/lectures/0.10943812805361008.docx	application/vnd.openxmlformats-officedocument.wordprocessingml.document	670427	0	2025-02-27 01:20:18.769561+00	2025-02-27 01:20:18.769561+00
fbcaab62-983e-4dc8-8400-9cc168dd6b32	aaf54224-49e8-45a4-93ba-e3f2aae82827	Link b├ái 1	Link b├ái 1	https://www.youtube.com/watch?v=q23RCXNfZUM	video	0	0	2025-03-11 13:12:37.074373+00	2025-03-11 13:12:37.074373+00
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, student_id, full_name, role, class_code, created_at, updated_at, status) FROM stdin;
620de24c-a40a-432a-be36-86852092f3c1	3122569172	Thinh Dinh	student	CNT01	2025-02-21 05:37:06.999379+00	2025-02-21 05:37:07.281+00	active
6477eb40-4562-4138-97e1-56d9cea1bd3d	3122560072	Thinh Dinh	student	CNT01	2025-02-21 05:51:03.411747+00	2025-02-21 05:51:03.734+00	active
e3f47bb2-dc17-4a26-b445-a2f6b6d6dad0	gv001	Ng├┤ Thß╗ï Kim V╞░╞íng	teacher		2025-02-21 05:51:53.357839+00	2025-02-21 05:51:53.67+00	active
557d4ebc-ccbf-4402-ae59-4dd4b357e97c	3122410471	─æß║╖ng thß║┐ vinh	teacher	12a7	2025-02-21 08:15:30.199374+00	2025-02-21 08:15:29.057+00	active
e368b85d-7038-4211-be16-c959c7931de0	3122410449	Nguyß╗àn Ngß╗ìc Tuß║Ñn	student	DCT1225	2025-02-21 10:17:00.92684+00	2025-02-21 10:17:00.127+00	active
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
25	custom-metadata	67eb93b7e8d401cafcdc97f9ac779e71a79bfe03	2025-02-14 14:51:38.062932
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

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 196, true);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: supabase_admin
--

SELECT pg_catalog.setval('pgsodium.key_key_id_seq', 1, false);


--
-- Name: assignment_questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.assignment_questions_id_seq', 1, false);


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
-- Name: profiles Users can insert their own profile.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own profile." ON public.profiles FOR INSERT WITH CHECK ((auth.uid() = id));


--
-- Name: profiles Users can update own profile.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update own profile." ON public.profiles FOR UPDATE USING ((auth.uid() = id));


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
GRANT ALL ON SCHEMA auth TO postgres;


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

GRANT ALL ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


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
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM postgres;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM postgres;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO postgres WITH GRANT OPTION;
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
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: postgres
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


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
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.schema_migrations TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.schema_migrations TO postgres;
GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


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
-- Name: TABLE migrations; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.migrations TO anon;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.migrations TO authenticated;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.migrations TO service_role;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storage.migrations TO postgres;


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
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO postgres;

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

