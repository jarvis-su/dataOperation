SELECT i.* FROM (
SELECT * FROM attendance a WHERE a.attendance_status_id = 3 AND a.trx_type_id IN (100,101,111,110,121,300,310)) i,
(SELECT * FROM attendance a WHERE a.attendance_status_id = 3 AND a.trx_type_id IN (200,210,201,211,400,410)) o
WHERE i.matched_attendance_id = o.attendance_id
AND TRUNC(i.trx_date) < TRUNC(o.trx_date)
AND to_char(i.trx_date,'YYYY-MM') <> to_char(o.trx_date,'YYYY-MM');

SELECT * FROM attendance a WHERE a.attendance_id ='19471';


DECLARE
  benefit_id NUMBER;
  v_row attendance%rowtype; 
  cursor v_cur is (SELECT i.* FROM (SELECT * FROM attendance a WHERE a.attendance_status_id = 3 AND a.trx_type_id IN (100,101,111,110,121,300,310)) i, (SELECT * FROM attendance a WHERE a.attendance_status_id = 3 AND a.trx_type_id IN (200,210,201,211,400,410)) o WHERE i.matched_attendance_id = o.attendance_id
AND TRUNC(i.trx_date) < TRUNC(o.trx_date) AND to_char(i.trx_date,'YYYY-MM') <> to_char(o.trx_date,'YYYY-MM')) ;
begin
  open v_cur;
  loop
    fetch v_cur into v_row;
    exit when v_cur%notfound; 
    dbms_output.put_line('ATTENDANCE_ID = '||v_row.ATTENDANCE_ID||'  MATCHED_ATTENDANCE_ID = '||v_row.MATCHED_ATTENDANCE_ID);
  end loop;
  close v_cur;
exception
  when others then dbms_output.put_line('throw exception: others');
end;




DECLARE
  benefit_id NUMBER;
  v_row attendance%rowtype; 
  cursor v_cur is (SELECT i.* FROM (SELECT * FROM attendance a WHERE a.attendance_status_id = 3 AND a.trx_type_id IN (100,101,111,110,121,300,310)) i, (SELECT * FROM attendance a WHERE a.attendance_status_id = 3 AND a.trx_type_id IN (200,210,201,211,400,410)) o WHERE i.matched_attendance_id = o.attendance_id
AND TRUNC(i.trx_date) < TRUNC(o.trx_date) AND to_char(i.trx_date,'YYYY-MM') <> to_char(o.trx_date,'YYYY-MM')) ;
begin
  open v_cur;
  loop
    fetch v_cur into v_row;
    exit when v_cur%notfound; 
    dbms_output.put_line('ATTENDANCE_ID = '||v_row.ATTENDANCE_ID||'  MATCHED_ATTENDANCE_ID = '||v_row.MATCHED_ATTENDANCE_ID);
  end loop;
  close v_cur;
exception
  when others then dbms_output.put_line('throw exception: others');
end;
