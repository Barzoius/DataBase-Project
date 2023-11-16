CREATE OR REPLACE PROCEDURE cursoare IS 
  TYPE refcursor IS REF CURSOR;
  CURSOR C1 IS
    SELECT id_echipa, salariu
    FROM angajat;

  CURSOR C2(p_id_echipa angajat.id_echipa%TYPE) IS
    SELECT DISTINCT id_echipa
    FROM angajat
    WHERE id_echipa = p_id_echipa;

  v_echipa angajat.id_echipa%TYPE;
  v_salariu_total NUMBER := 0;
  v_numar_angajati NUMBER := 0;
  salariu_mediu NUMBER := 0;

  TYPE tuplu1 IS RECORD (
    tuplu_id_echipa angajat.id_echipa%TYPE,
    tuplu_salariu_mediu NUMBER := 0
  );

  TYPE vector IS VARRAY(35) OF tuplu1;
  vec vector := vector();

  TYPE contor is  VARRAY(35) of angajat.id_echipa%TYPE;
  vector_contor contor := contor();

   v_flag BOOLEAN := FALSE;

BEGIN
  DBMS_OUTPUT.PUT_LINE('-------------------------------(7)-------------------------------');
  DBMS_OUTPUT.PUT_LINE('CERINTA: Formulați în limbaj natural o problemă pe care să o 
rezolvați folosind un subprogram stocat independent care să 
utilizeze 2 tipuri diferite de cursoare studiate, unul dintre 
acestea fiind cursor parametrizat, dependent de celălalt cursor. 
Apelați subprogramul.');
  DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('PROBLEMA: Sa se afle salriul mediu al fiecarei echipe.');
  DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------');
  FOR i IN C1 LOOP
    v_echipa := i.id_echipa;
    v_salariu_total := 0;
    v_numar_angajati := 0;

    FOR j IN C2(v_echipa) LOOP
      -- j = rezultatul in C2 pentru v_echipa
     -- vector_contor.extend;
     -- vector_contor(vector_contor.count) := j.id_echipa;

      FOR k IN (SELECT salariu FROM angajat WHERE id_echipa = j.id_echipa) LOOP
        v_salariu_total := v_salariu_total + k.salariu;
        v_numar_angajati := v_numar_angajati + 1;
      END LOOP;


      salariu_mediu := v_salariu_total / v_numar_angajati;
      v_flag := FALSE;
      FOR w in vector_contor.FIRST .. vector_contor.LAST LOOP
        IF j.id_echipa = vector_contor(w) THEN 
         v_flag := TRUE;
		 EXIT;
        END IF;
	  END LOOP;

	  IF NOT v_flag THEN

         vector_contor.extend;
		 vector_contor(vector_contor.count) := j.id_echipa;

         vec.extend;
         vec(vec.count) := tuplu1(
           j.id_echipa,
           salariu_mediu
          );
	  END IF;
			
      

	  
    END LOOP;
  END LOOP;
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('----------------------(ECHIPA/SALRIU_MEDIU)----------------------');
   FOR i IN vec.FIRST .. vec.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(vec(i).tuplu_id_echipa ||' '|| vec(i).tuplu_salariu_mediu);
  END LOOP;
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------');
END;
/

    
BEGIN
  cursoare;
END;
/

select * from echipa;
select distinct id_echipa from angajat;
select * from angajat;
select * from job;

drop procedure cursoare;
