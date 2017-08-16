CREATE OR REPLACE FUNCTION init_functions()
  RETURNS TABLE(functionname character varying, seq numeric, inittype character varying) AS
$BODY$
declare
var_r record;
begin
 functionname:='<Function Name>'; seq:=1; inittype='func'; return next;
 functionname:='<Function Name>'; seq:=2; inittype='func'; return next;
 functionname:='<Function Name>'; seq:=3; inittype='func'; return next;
 functionname:='<Function Name>'; seq:=4; inittype='func'; return next;

functionname:='<View Name>'; seq:=101; inittype='view'; return next;
functionname:='<View Name>'; seq:=102; inittype='view'; return next;
end;
$BODY$
  LANGUAGE plpgsql ;
