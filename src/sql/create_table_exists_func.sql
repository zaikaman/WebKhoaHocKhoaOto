CREATE OR REPLACE FUNCTION table_exists(schema_name text, table_name text)
RETURNS boolean AS $$
DECLARE
  exists boolean;
BEGIN
  SELECT EXISTS (
    SELECT 1
    FROM information_schema.tables
    WHERE
      tables.table_schema = schema_name
      AND tables.table_name = table_name
  ) INTO exists;
  RETURN exists;
END;
$$ LANGUAGE plpgsql;
