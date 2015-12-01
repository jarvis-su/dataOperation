SET SERVEROUTPUT ON;
DECLARE
  B_ID      NUMBER;
  T_DATE    DATE;
  COUNT_TRX NUMBER;
  V_ROW     ATTENDANCE%ROWTYPE;
  C_ID      NUMBER;
  CURSOR V_CUR IS(
    SELECT I.*
    FROM   (SELECT *
            FROM   ATTENDANCE A
            WHERE  A.ATTENDANCE_STATUS_ID = 3
            AND    A.TRX_TYPE_ID IN (100, 101, 111, 110, 121, 300, 310)) I,
           (SELECT *
            FROM   ATTENDANCE A
            WHERE  A.ATTENDANCE_STATUS_ID = 3
            AND    A.TRX_TYPE_ID IN (200, 210, 201, 211, 400, 410)) O
    WHERE  I.MATCHED_ATTENDANCE_ID = O.ATTENDANCE_ID
    AND    TRUNC(I.TRX_DATE + 1) = TRUNC(O.TRX_DATE)
    AND    TO_CHAR(I.TRX_DATE, 'YYYY-MM') <> TO_CHAR(O.TRX_DATE, 'YYYY-MM'));
BEGIN
  COUNT_TRX := 0;
  C_ID      := 0;
  OPEN V_CUR;
  LOOP
    FETCH V_CUR
      INTO V_ROW;
    EXIT WHEN V_CUR%NOTFOUND;
    B_ID   := V_ROW.BENEFIT_ID;
    T_DATE := V_ROW.TRX_DATE;
    --- dbms_output.put_line('ATTENDANCE_ID = '||v_row.ATTENDANCE_ID||'  MATCHED_ATTENDANCE_ID = '||v_row.MATCHED_ATTENDANCE_ID||' trx_date = ' || to_char(t_date, 'YYYY-MM-DD HH24:MI:SS'));
    SELECT B.CHILD_ID INTO C_ID FROM BENEFIT B WHERE B.BENEFIT_ID = B_ID;
    SELECT COUNT(*)
    INTO   COUNT_TRX
    FROM   ATTENDANCE A, BENEFIT B, CHILD C
    WHERE  A.BENEFIT_ID = B.BENEFIT_ID
    AND    B.CHILD_ID = C.CHILD_ID
    AND    C.CHILD_ID = C_ID
    AND    A.ATTENDANCE_STATUS_ID = 3
    AND    A.TRX_DATE > T_DATE
    AND    A.TRX_TYPE_ID IN (100, 101, 111, 110, 121, 300, 310);
    IF (COUNT_TRX = 0) THEN
      DBMS_OUTPUT.PUT_LINE('benefit_id = ' || B_ID || ' count_trx = ' ||
                           COUNT_TRX || ' child_id = ' || C_ID);
    END IF;
  END LOOP;
  CLOSE V_CUR;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('throw exception: others');
END;
