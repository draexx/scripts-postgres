CREATE OR REPLACE FUNCTION checksumVerhoeff(num numeric)
RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
        d CHAR(100) := '0123456789123406789523401789563401289567401239567859876043216598710432765982104387659321049876543210';
        p CHAR(80) := '01234567891576283094580379614289160435279453126870428657390127938064157046913258';
        inv CHAR(10) := '0432156789';
        c integer := 0;
        len integer;
        m integer;
        i integer := 0;
        n VARCHAR(255);
BEGIN
        /* Start Processing */
        n := REVERSE(num::varchar);
        len := LENGTH(n);

        WHILE (i < len) LOOP
                /* Do the CalcChecksum */
                m := substring(p,(((i+1)%8)*10)+ substring(n,i+1,1)::integer+1,1)::integer;
                c := substring(d,(c*10+m+1),1)::integer;
                i:=i+1;
        END LOOP;

         /* Do the CalcChecksum */
         c := substring(inv,c+1,1)::integer;
   RETURN c;
END
$$;
