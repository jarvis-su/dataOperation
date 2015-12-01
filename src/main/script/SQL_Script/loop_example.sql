declare
  v_count       number;
  v_alt         person.alt_identification%type;
  v_firstname   person.firstname%type;
  v_lastname    person.lastname%type;
  v_p_alt       person.alt_identification%type;
  v_p_firstname person.firstname%type;
  v_p_lastname  person.lastname%type;
  cursor v_cur is
    SELECT c.case_nbr,
           ch.insert_date cardholder_insert_date,
           p.alt_identification,
           p.person_id,
           p.lastname,
           p.minitial,
           p.firstname,
           ch.cardholder_id,
           rank() over(partition by c.case_nbr, p.alt_identification,p.firstname,p.lastname order by ch.insert_date desc) r
      FROM person p,
           cardholder ch,
           program_access pa,
           case c,
           (SELECT p.alt_identification, c.case_id,p.firstname,p.lastname, count(1)
              FROM person p, cardholder ch, program_access pa, case c
             where p.person_id = ch.person_id
               and ch.cardholder_id = pa.cardholder_id
               and pa.case_id = c.case_id
               and trim(p.alt_identification) is not null
               and pa.access_status_id = 101
             group by p.alt_identification, c.case_id,p.firstname,p.lastname
            having count(1) > 1) dup
     where p.person_id = ch.person_id
       and ch.cardholder_id = pa.cardholder_id
       and pa.case_id = c.case_id
       and p.alt_identification = dup.alt_identification
       and c.case_id = dup.case_id
       and pa.access_status_id = 101;

begin
  v_count := 0;
  for cur in v_cur loop
    v_count     := v_count + 1;
    v_alt       := cur.alt_identification;
    v_firstname := cur.firstname;
    v_lastname  := cur.lastname;
    if v_alt = v_p_alt then
      if v_firstname <> v_p_firstname and v_lastname <> v_p_lastname then
        dbms_output.put_line(v_alt);
      end if;
    end if;
    v_p_alt       := v_alt;
    v_p_firstname := v_firstname;
    v_p_lastname  := v_lastname;
  end loop;
  dbms_output.put_line(v_count);
exception
  when others then
    ROLLBACK;
    dbms_output.put_line('throw exception: others');
    dbms_output.put_line(DBMS_UTILITY.format_error_stack);
    dbms_output.put_line(DBMS_UTILITY.format_error_backtrace);
end;
