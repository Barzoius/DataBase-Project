------------------(1)------------------
CREATE OR REPLACE PROCEDURE gestionare_angajati IS 
  --Declarații de tipuri--
  TYPE tuplu1 IS RECORD (
    tuplu_id_angajat angajat.id_angajat%TYPE,
    tuplu_id_echipa angajat.id_echipa%TYPE
  );

  TYPE tuplu2 IS RECORD (
    tuplu_id_locatie echipa.id_locatie%TYPE,
    tuplu_id_echipa echipa.id_echipa%TYPE
  );

  TYPE tuplu3 IS RECORD(
    tuplu_id_angajat angajat.id_angajat%TYPE,
    tuplu_id_locatie echipa.id_locatie%TYPE
  );  

  TYPE tabou_indexat IS TABLE OF tuplu1 INDEX BY PLS_INTEGER;
  TYPE tabou_imbricat IS TABLE OF tuplu2;
  TYPE vector IS VARRAY(35) OF tuplu3;

  --Declarații de variabile--
  tabou_indexat_echipe tabou_indexat;
  tabou_imbricat_locatie tabou_imbricat := tabou_imbricat();
  vec vector := vector();

  limita_superioara NUMBER;
  limita_superioara_2 NUMBER;

BEGIN
  SELECT COUNT(*) INTO limita_superioara FROM angajat;
  SELECT COUNT(*) INTO limita_superioara_2 FROM echipa;
  DBMS_OUTPUT.PUT_LINE('-------------------------------(6)-------------------------------');
  DBMS_OUTPUT.PUT_LINE('CERINTA: Formulați în limbaj natural o problemă pe care să o 
rezolvați folosind un subprogram stocat independent care să 
utilizeze toate cele 3 tipuri de colecții studiate. 
Apelați subprogramul');
  DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('PROBLEMA: Sa se creeze 3 tipuri diferite de colectii, una care sa
contina id-urile angajatilor si id-urile echipelor in care 
lucreaza, alta care sa contina id-urile echipelor si id-urile
locatiilor in care se afla, iar ultima sa fie creata din primele
doua si sa contina id-urile angajatilor cat si id-urile 
locatiilor in care se afla echipele lor.');
  DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------');
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.NEW_LINE;
  -- DBMS_OUTPUT.PUT_LINE();
  DBMS_OUTPUT.PUT_LINE('');
  ----TABLOUL INDEXAT----
  SELECT id_angajat, id_echipa
  BULK COLLECT INTO tabou_indexat_echipe
  FROM angajat;

  DBMS_OUTPUT.PUT_LINE('--------------------------TABLOU_INDEXAT-------------------------');
  FOR i IN tabou_indexat_echipe.FIRST .. tabou_indexat_echipe.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(tabou_indexat_echipe(i).tuplu_id_angajat ||' '|| tabou_indexat_echipe(i).tuplu_id_echipa);
  END LOOP;

  ----TABLOUL IMBRICAT----
  SELECT id_locatie, id_echipa
  BULK COLLECT INTO tabou_imbricat_locatie
  FROM echipa;        
					  
  DBMS_OUTPUT.PUT_LINE('-------------------------TABLOU_IMBRICAT-------------------------');
  FOR i IN tabou_imbricat_locatie.FIRST .. tabou_imbricat_locatie.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(tabou_imbricat_locatie(i).tuplu_id_locatie ||' '|| tabou_imbricat_locatie(i).tuplu_id_echipa);
  END LOOP;

  ----VECTOR----
  FOR i in 1..limita_superioara LOOP
  vec.extend;
  FOR j in 1..limita_superioara_2 LOOP
       IF tabou_indexat_echipe(i).tuplu_id_echipa = tabou_imbricat_locatie(j).tuplu_id_echipa THEN
       --vec.extend;
          vec(vec.count) := tuplu3(
           tabou_indexat_echipe(i).tuplu_id_angajat,
           tabou_imbricat_locatie(j).tuplu_id_locatie
          );
       -- EXIT;
       END IF;  
  END LOOP;
  END LOOP;    

  DBMS_OUTPUT.PUT_LINE('-----------------------------VECTOR------------------------------');
  FOR i IN vec.FIRST .. vec.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(vec(i).tuplu_id_angajat ||' '|| vec(i).tuplu_id_locatie);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------');
END;
/

BEGIN
  gestionare_angajati;
END;
/

-- select * from angajat;
-- select * from echipa;
-- select * from locatie;
-- select * from tara;

-- select count(*) from angajat;

DROP PROCEDURE gestionare_angajati;

------------------(2)------------------

-- Problema: Să se calculeze suma totală a salariilor angajaților dintr-o companie, împărțită pe departamente, 
--     iar apoi să se actualizeze salariul mediu al fiecărui departament cu o creștere procentuală specifică.


CREATE OR REPLACE PROCEDURE cursoare IS 

  TYPE refcursor IS REF CURSOR;
  CURSOR C1 IS
    SELECT id_echipa, salariu
    FROM angajat;

  CURSOR C2(p_C1 refcursor) IS
    SELECT DISTINCT id_echipa
    FROM angajat;

  v_echipa angajat.id_echipa%TYPE;
  v_salariu_total NUMBER := 0;
  v_numar_angajati NUMBER := 0;
BEGIN

    FOR i IN C2(C1) LOOP
     v_echipa := i.id_echipa;
     v_salariu_total := 0;
     v_numar_angajati := 0;

    FOR j IN (SELECT salariu FROM angajat WHERE id_echipa = v_echipa) LOOP
      v_salariu_total := v_salariu_total + j.salariu;
      v_numar_angajati := v_numar_angajati + 1;
    END LOOP;

   UPDATE echipa SET salariu_mediu = v_salariu_total / v_numar_angajati * 1.1 WHERE id_echipa = v_echipa;
   END LOOP;

END;
/
