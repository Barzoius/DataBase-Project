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

      FOR k IN (SELECT salariu FROM angajat WHERE id_echipa = j.id_echipa) LOOP
        v_salariu_total := v_salariu_total + k.salariu;
        v_numar_angajati := v_numar_angajati + 1;
      END LOOP;


      salariu_mediu := v_salariu_total / v_numar_angajati;
      vec.extend;
      vec(vec.count) := tuplu1(
           j.id_echipa,
           salariu_mediu
          );
	  
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

------------------(3)------------------

CREATE OR REPLACE PROCEDURE profit IS 

v_id_vanzator vanzator.id_vanzator%TYPE := 'V-05';

TYPE tuplu IS RECORD (
    t_nume_tara tara.nume_tara%TYPE,
    t_id_vanzator vanzator.id_vanzator%TYPE,
    t_nume_vanzator vanzator.nume_vanzator%TYPE,
    t_nr_magazine magazin.nr_magazine%TYPE,
    t_venit_total_adus vanzator.venit_total_adus%TYPE,
    t_profit VARCHAR2(100)
  );

TYPE tabou_indexat IS TABLE OF tuplu INDEX BY PLS_INTEGER;

tabou_indexat_pentru_profit tabou_indexat;

v_nr_magazine magazin.nr_magazine%TYPE;

BEGIN    

  SELECT SUM(m.nr_magazine) INTO v_nr_magazine
  FROM VANZATOR v, MAGAZIN m
  WHERE m.ID_VANZATOR = v.id_vanzator
  AND v.id_vanzator = v_id_vanzator;

  IF v_nr_magazine = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Vanzatorul nu are magazine');
    RETURN;
  END IF;

    SELECT LOWER(t.NUME_TARA), v.ID_VANZATOR, v.NUME_VANZATOR, m.NR_MAGAZINE,  v.VENIT_TOTAL_ADUS, 
    CASE 
    	WHEN (m.NR_MAGAZINE/t.PRET_DE_EXPORT) > t.PRET_DE_EXPORT THEN INITCAP('Este profitabil.')
        WHEN (m.NR_MAGAZINE/t.PRET_DE_EXPORT) = t.PRET_DE_EXPORT THEN INITCAP('ar trebui sa consideram si alti factori.')
        ELSE 'Nu este profitabi.'
    END AS PROFIT   
    BULK COLLECT INTO tabou_indexat_pentru_profit
    FROM TARA t, MAGAZIN m, VANZATOR v
    WHERE t.ID_TARA = m.ID_TARA
    AND v.ID_VANZATOR = m.ID_VANZATOR 
    -- AND v.ID_VANZATOR = v_id_vanzator
    -- AND v.VENIT_TOTAL_ADUS >= 1500000
    ORDER BY m.NR_MAGAZINE;
	DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------');
	FOR i IN 1..tabou_indexat_pentru_profit.COUNT LOOP
        IF tabou_indexat_pentru_profit(i).t_venit_total_adus > 1500000 THEN    
            DBMS_OUTPUT.PUT_LINE(
              'Tara: ' || tabou_indexat_pentru_profit(i).t_nume_tara ||
              ', ID Vanzator: ' || tabou_indexat_pentru_profit(i).t_id_vanzator ||
              ', Nume Vanzator: ' || tabou_indexat_pentru_profit(i).t_nume_vanzator ||
              ', Nr Magazine: ' || tabou_indexat_pentru_profit(i).t_nr_magazine ||
              ', Venit Total Adus: ' || tabou_indexat_pentru_profit(i).t_venit_total_adus ||
              ', Profit: ' || tabou_indexat_pentru_profit(i).t_profit
            );
        	DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------');
		END IF;
  END LOOP;

  FOR i IN 1..tabou_indexat_pentru_profit.COUNT LOOP
    IF tabou_indexat_pentru_profit(i).t_venit_total_adus < 1500000 THEN
      DBMS_OUTPUT.PUT_LINE('Profitul direct este prea mic pentru vanzatorul ' 
                           ||  tabou_indexat_pentru_profit(i).t_id_vanzator );
    END IF;
  END LOOP;

END;
/

BEGIN 
    profit;
END;
/

DROP PROCEDURE profit;  

SELECT SUM(m.nr_magazine) as TOTAl
  FROM VANZATOR v, MAGAZIN m
  WHERE m.ID_VANZATOR = v.id_vanzator
  AND v.id_vanzator = 'V-01'
    

select * from vanzator;
select * from magazin;

INSERT INTO VANZATOR VALUES ('V-06', '---', 200000);
INSERT INTO MAGAZIN VALUES (UPPER('V-06'), UPPER('eu-02'), 0);
