CREATE OR REPLACE FUNCTION table_exists(p_schema_name text, p_table_name text)
RETURNS boolean AS $$
DECLARE
  v_exists boolean;
BEGIN
  SELECT EXISTS (
    SELECT 1
    FROM information_schema.tables
    WHERE
      table_schema = p_schema_name
      AND table_name = p_table_name
  ) INTO v_exists;
  RETURN v_exists;
END;
$$ LANGUAGE plpgsql;
