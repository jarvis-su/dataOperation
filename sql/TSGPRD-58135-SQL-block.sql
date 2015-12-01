declare
  v_row               cardholder%rowtype;
  v_person_id         cardholder.person_id%type;
  v_cardholder_id     cardholder.cardholder_id%type;
  v_alt_id            person.alt_identification%type;
  v_case_id           program_access.case_id%type;
  v_case_count        number;
  v_case_count_before number;
  v_person_count      number;
  str_truncate_temp   varchar2(100);
  str_insert_temp     varchar2(100);
  cursor v_cur is
    SELECT ch.*
      FROM cardholder ch, program_access pa
     where ch.cardholder_id = pa.cardholder_id
       and pa.access_type_id = 2
       and ch.insert_date >=
           to_date('2013-06-26 21:00:00', 'YYYY-MM-DD HH24:MI:SS')
       and ch.insert_date <
           to_date('2013-07-19 18:30:52', 'YYYY-MM-DD HH24:MI:SS');
begin
  --str_truncate_temp := 'truncate table ch_temp';
  str_truncate_temp := 'delete from ch_temp';
  str_insert_temp   := 'insert into ch_temp values (:1)';  
  
  /* clear the temp table*/
  execute IMMEDIATE str_truncate_temp;

  open v_cur;
  loop
    fetch v_cur into v_row;
    exit when v_cur%notfound;    
    v_person_id         := v_row.person_id;
    v_cardholder_id     := v_row.cardholder_id;
    v_case_count        := 0;
    v_case_count_before := 0;
    v_person_count      := 0;
  
    select p.alt_identification
      into v_alt_id
      from person p
     where p.person_id = v_person_id;
      
    select count(distinct case_id)
      into v_case_count
      from (SELECT pa.case_id FROM person_0705 p, cardholder_0705 ch, program_access_0705 pa
             where p.person_id = ch.person_id
               and ch.cardholder_id = pa.cardholder_id
               and p.person_id = v_person_id
               and ch.insert_date <= to_date('2013-06-26 21:00:00', 'YYYY-MM-DD HH24:MI:SS')
            union
            SELECT pa.case_id FROM program_access pa where pa.cardholder_id = v_cardholder_id);
  
    SELECT count(distinct pa.case_id)
      into v_case_count_before
      FROM person_0705 p, cardholder_0705 ch, program_access_0705 pa
     where p.person_id = ch.person_id
       and ch.cardholder_id = pa.cardholder_id
       and p.person_id = v_person_id
       and ch.insert_date <= to_date('2013-06-26 21:00:00', 'YYYY-MM-DD HH24:MI:SS');
  
    if v_case_count_before > 0 and (v_case_count - v_case_count_before) > 0 then
      SELECT count(*) into v_person_count FROM (SELECT distinct p.lastname, p.firstname, p.minitial, p.dob FROM person p
               where p.insert_date <= to_date('2013-07-19 18:30:52', 'YYYY-MM-DD HH24:MI:SS')
                 and p.alt_identification = v_alt_id);
      if v_person_count > 1 then
        dbms_output.put_line('v_alt_id = ' || v_alt_id || ' , v_person_id= ' || v_person_id ||' , v_cardholder_id= ' || v_cardholder_id);
        /*Store the cardholder_id to the temp table*/
        execute IMMEDIATE str_insert_temp USING v_cardholder_id;
      end if;
    end if;
  end loop;
  COMMIT;
  close v_cur;
exception
  when others then
    ROLLBACK;
    dbms_output.put_line('throw exception: others');
    dbms_output.put_line(DBMS_UTILITY.format_error_stack);
    dbms_output.put_line(DBMS_UTILITY.format_error_backtrace);
end;
