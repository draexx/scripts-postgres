CREATE OR REPLACE FUNCTION public.update_sequence()
  RETURNS numeric AS
$BODY$
DECLARE
	PKList RECORD;
	SequenceName VARCHAR;
	Command VARCHAR;
	nMax INTEGER;
	n INTEGER;
BEGIN
	n := 0;
	FOR PKList IN	SELECT	information_schema.table_constraints.table_schema, information_schema.table_constraints.table_name, information_schema.constraint_column_usage.column_name
			FROM	information_schema.table_constraints 
				INNER JOIN information_schema.constraint_column_usage ON information_schema.table_constraints.constraint_schema = information_schema.constraint_column_usage.constraint_schema AND information_schema.table_constraints.constraint_name = information_schema.constraint_column_usage.constraint_name
			WHERE	information_schema.table_constraints.constraint_type = 'PRIMARY KEY' 
	LOOP
		RAISE NOTICE '% % %', PKList.table_schema, PKList.table_name, PKList.column_name;
		-- Get sequence name
		Command := 'SELECT pg_get_serial_sequence(' || quote_literal(PKList.table_schema || '.' || PKList.table_name) || ',' || quote_literal(PKList.column_name) || ')';
		EXECUTE Command INTO SequenceName;
		
		-- Update Sequence
		IF SequenceName <> '<NULL>' THEN
			n := n  + 1;
			-- Get Max (General)
			Command := 'SELECT MAX(' || PKList.column_name || ') FROM ' || PKList.table_schema || '.' || PKList.table_name;
			EXECUTE Command INTO nMax;
			nMax := COALESCE(nMax, 0);
			-- Set Sequence Value
			Command := 'SELECT setval(' || quote_literal(SequenceName) || ', ' || (nMax+1)::text || ', false)';
			EXECUTE Command;
		END IF;		
	END LOOP;
	RETURN n;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.update_sequence()
  OWNER TO postgres;
