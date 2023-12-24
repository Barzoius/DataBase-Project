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

CREATE OR REPLACE FUNCTION profit(vanz IN VARCHAR2) RETURN VARCHAR2 IS 

v_id_vanzator vanzator.id_vanzator%TYPE := vanz;

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

fara_magazin EXCEPTION;

profit_direct_prea_mic EXCEPTION;

BEGIN    

  SELECT SUM(m.nr_magazine) INTO v_nr_magazine
  FROM VANZATOR v, MAGAZIN m
  WHERE m.ID_VANZATOR = v.id_vanzator
  AND v.id_vanzator = v_id_vanzator;

  	DBMS_OUTPUT.PUT_LINE('----------------------------------(8)---------------------------------');
    DBMS_OUTPUT.PUT_LINE('CERINTA: Formulați în limbaj natural o problemă pe care să o rezolvați 
folosind un subprogram stocat independent de tip funcție care să utilizeze într-o singură 
comandă SQL 3 dintre tabelele definite. Definiți minim 2 excepții proprii. 
Apelați subprogramul astfel încât să evidențiați toate cazurile definite și tratate.');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('PROBLEMA: Afisati tarile in care vanaztorului dat ca parametru functiei
are magazine, numele vanzatorului, numarul de magazine, venitul total adus si daca acel
vanzator aduce profit cu magazinele din tara respectiva. Ca informatiile sa fie afisate,
vanaztorul trebuie sa aiba magazine(sa nu fie magazin online), iar ca venitul total
adus sa fie mai mare ca 1500000 alfel profitul direct al vanzatorului este prea mic.' );
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------');

  IF v_nr_magazine = 0 THEN
    RAISE fara_magazin;
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
    AND v.ID_VANZATOR = v_id_vanzator
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
      RAISE profit_direct_prea_mic;
    END IF;
  END LOOP;

  RETURN NULL;

EXCEPTION 
    WHEN fara_magazin THEN 
    	DBMS_OUTPUT.PUT_LINE('Vanzatorul ' || v_id_vanzator ||' nu are magazine');
		RETURN NULL;

	WHEN profit_direct_prea_mic THEN
        DBMS_OUTPUT.PUT_LINE('Profitul direct este prea mic pentru vanzatorul ' 
                           ||  v_id_vanzator );
	RETURN NULL;

END;
/

DECLARE
    vanz vanzator.id_vanzator%TYPE;
BEGIN 
    --V-02 => fara eroare
    --V-03 => profit direct prea mic
    --V-05 => nu are magazine
    
    vanz := 'V-02';
    DECLARE
        result VARCHAR2(100);
    BEGIN
        result := profit(vanz);
    END;
END;
/

DROP FUNCTION profit;

------------------(4)------------------


CREATE OR REPLACE PROCEDURE cinci_tabele(id_ang IN VARCHAR2, 
    					 min_sal angajat.salariu%TYPE DEFAULT 2700) IS 

v_id_angajat angajat.id_angajat%TYPE := id_ang;

v_salariu_minim angajat.salariu%TYPE := min_sal;

TYPE tuplu IS RECORD (
    t_id_angajat angajat.id_angajat%TYPE,
    t_zile_de_lucru job.zile_de_lucru%TYPE,
    t_salariu angajat.salariu%TYPE,
    t_id_consola model.id_consola%TYPE,
    t_porecla model.porecla%TYPE,
    t_nume_echipa echipa.nume_echipa%TYPE,
	t_oras locatie.oras%TYPE
  );

TYPE tabou_indexat IS TABLE OF tuplu INDEX BY PLS_INTEGER;

tablou_indexat_angajat tabou_indexat;

sub_200_zile_lucru EXCEPTION;

salariu_prea_mic EXCEPTION;

pt_err_nume_angajat angajat.nume%TYPE := 'DAN';
pt_err_id_angajat angajat.id_angajat%TYPE;

BEGIN

--Aceasta bucata este adaugata doar pentru a scote in evidenta
--eroarea too_many_rows. Puneti 'RARES' la pt_err_nume_nagajat
--pentru a da erorare sau 'DAN' pentru a nu da eroarea.

SELECT id_angajat 
INTO pt_err_id_angajat
FROM angajat
WHERE nume = pt_err_nume_angajat;

SELECT a.id_angajat, j.zile_de_lucru, a.salariu, m.id_consola, m.porecla, e.nume_echipa, l.oras
BULK COLLECT INTO tablou_indexat_angajat
FROM ANGAJAT a, JOB j, MODEL m, ECHIPA e, LOCATIE l, plan p
WHERE a.id_echipa = e.id_echipa
AND p.id_echipa = e.id_echipa
AND p.id_model = m.id_model
AND a.id_job = j.id_job    
AND e.id_locatie = l.id_locatie
AND id_angajat = v_id_angajat;    
DBMS_OUTPUT.PUT_LINE('----------------------------------(9)---------------------------------');
DBMS_OUTPUT.PUT_LINE('CERINTA: Formulați în limbaj natural o problemă pe care să o rezolvați 
folosind un subprogram stocat independent de tip procedură care să utilizeze într-o singură 
comandă SQL 5 dintre tabelele definite. Tratați toate excepțiile care pot apărea, incluzând 
excepțiile NO_DATA_FOUND și TOO_MANY_ROWS. 
Apelați subprogramul astfel încât să evidențiați toate cazurile tratate.');
DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------');
DBMS_OUTPUT.PUT_LINE('PROBLEMA: Sa se stocheze intr-un tabel si sa se afiseze din acesta
urmatoarele infromatii relevante despre un angajat: Id-ul acestuia, zilele de lucru,
salariul, consolele si porecla consolelor la care a lucrat, numele echipei in care lucreaza,
si orasul in care se afla echipa lui. Penctru consolele la care angajatul a lucrat nu se
va crea un vreo structura de date ci va exista o inserare specifica ei in tabel.
De asemenea numarul de zile de lucru al angajatului trebuie sa fie mai mare de 200 si
salariul lui mai mare decat limita minimia data ca parametru procedurii.' );
DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------');

DBMS_OUTPUT.PUT_LINE('Id_angajat: ' || v_id_angajat);
DBMS_OUTPUT.PUT_LINE('Salariu_minim: ' || min_sal);

 FOR i IN 1..tablou_indexat_angajat.COUNT LOOP
    IF tablou_indexat_angajat(i).t_zile_de_lucru < 200 THEN
      RAISE sub_200_zile_lucru;
    END IF;

	IF tablou_indexat_angajat(i).t_salariu < v_salariu_minim THEN
        RAISE salariu_prea_mic;
	END IF;

	DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------');
	DBMS_OUTPUT.PUT_LINE(
              'ID_ANGAJAT: ' || tablou_indexat_angajat(i).t_id_angajat ||
              ', ZILE DE LUCRU: ' || tablou_indexat_angajat(i).t_zile_de_lucru ||
              ', SALARIU: ' || tablou_indexat_angajat(i).t_salariu ||
              ', CONSOLA: ' || tablou_indexat_angajat(i).t_id_consola ||
              ', PORECLA MODEL: ' || tablou_indexat_angajat(i).t_porecla ||
              ', NUME_ECHIPA: ' || tablou_indexat_angajat(i).t_nume_echipa ||
        	  ', ORAS: ' || tablou_indexat_angajat(i).t_oras
            );
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------');
     
  END LOOP;

EXCEPTION

    WHEN sub_200_zile_lucru THEN
    	DBMS_OUTPUT.PUT_LINE('Angajatul ' || v_id_angajat || ' are sub 200 de zile de lucru pe an');

	WHEN salariu_prea_mic THEN
        DBMS_OUTPUT.PUT_LINE('Salariul angajatului ' || v_id_angajat || ' este sub ' || v_salariu_minim);

	WHEN NO_DATA_FOUND THEN 
 		--DBMS_OUTPUT.PUT_LINE (' no data found: ' ||SQLCODE || ' - ' || SQLERRM);
		RAISE_APPLICATION_ERROR(-20999, 'Angajatul nu exista');
	WHEN TOO_MANY_ROWS THEN 
 		DBMS_OUTPUT.PUT_LINE (' too many rows: ' ||SQLCODE || ' - '  || SQLERRM);
		DBMS_OUTPUT.PUT_LINE('Ati ales numele RARES, alegeti DAN pentru a nu da aceasta eroare');
	WHEN INVALID_NUMBER THEN 
 		DBMS_OUTPUT.PUT_LINE (' invalid number: ' ||SQLCODE || ' - ' || SQLERRM);
END;
/


--Pentru A-03 si 2800  => eroare de salariu
--Pentru A-02 => eroare de zile de lucru
DECLARE
    
p_id_angajat angajat.id_angajat%TYPE := 'A-101';

p_salariu_minim angajat.salariu%TYPE := 2800;

BEGIN
	cinci_tabele(p_id_angajat, min_sal => p_salariu_minim);
END;
/


DROP procedure cinci_tabele;

select * from angajat;

--------------------------triggere--------------------------
--------View-uri folosite---------
CREATE OR REPLACE VIEW ang_info AS
    SELECT *
    FROM ANGAJAT;

CREATE OR REPLACE VIEW rares_info AS
	SELECT *
	FROM ang_info
	WHERE nume = 'RARES';
------------------------------------
----------------------------(10)---------------------------

CREATE OR REPLACE TRIGGER rares_trigger_com
INSTEAD OF INSERT OR DELETE OR UPDATE ON rares_info

DECLARE

    rares_roman EXCEPTION;

BEGIN
    
IF(:OLD.nationalitate = 'ROMAN') THEN
RAISE rares_roman;
END IF;

EXCEPTION
    WHEN rares_roman THEN
    	DBMS_OUTPUT.PUT_LINE('Nu se pot face modificari pe rares-ul care e roman.');

END;
/

UPDATE rares_info
set salariu = 10000
where nationalitate = 'ROMAN';

drop trigger rares_trigger_com;

----------------------------(11)----------------------------

CREATE OR REPLACE TRIGGER rares_trigger_line
INSTEAD OF INSERT OR DELETE ON rares_info
FOR EACH ROW
    
DECLARE
    rares_nume EXCEPTION;

BEGIN
    
IF INSERTING THEN
	IF :NEW.nume != 'RARES' THEN
        RAISE rares_nume;
	END IF;

	 INSERT INTO ang_info
    VALUES (
        :NEW.id_angajat,
        :NEW.nume,
        :NEW.prenume,
        :NEW.email,
        :NEW.nr_telefon,
        :NEW.sex,
        :NEW.nationalitate,
        :NEW.salariu,
        :NEW.id_echipa,
        :NEW.id_job
    );

ELSIF DELETING THEN
    DELETE  FROM ang_info
    WHERE id_angajat = :OLD.id_angajat;	

END IF;

EXCEPTION
    WHEN rares_nume THEN
    	DBMS_OUTPUT.PUT_LINE('Numele angajatului nou nu este rares deci nu o sa fie inserat
in rares_info dar a fost totusi inserat in ang_info.');
		INSERT INTO ang_info
    	VALUES(:NEW.id_angajat, :NEW.nume, :NEW.prenume, :NEW.email, :NEW.nr_telefon,
    	   	   :NEW.sex, :NEW.nationalitate, :NEW.salariu, :NEW.id_echipa, :NEW.id_job);
		
END;
/

INSERT INTO rares_info VALUES('A-06', 'DANELO', 'MOISEL', 
    'ozy.sdaasd@gmail.com', '083223939','M', 'FRANCEZ', 2300, 'E-01', 'J-01');

INSERT INTO rares_info VALUES('A-08', 'RARES', 'GATO', 
    'gato.sddsssd@gmail.com', '063223939','M', 'ITALIAN', 2600, 'E-02', 'J-03');

DELETE FROM rares_info WHERE id_angajat = 'A-08';

select * from ang_info;
select * from rares_info;

----------------------------(11)----------------------------


CREATE TABLE evenimente_LDD
    (
    	actiune VARCHAR2(100),
    	entitate VARCHAR2(100),
        ziua DATE,
    	ora VARCHAR(10)
    );

drop table evenimente_LDD;


CREATE OR REPLACE TRIGGER rares_trigger_LDD
BEFORE CREATE OR DROP ON SCHEMA

DECLARE
        v_event_H_M VARCHAR2(10);    

BEGIN
    DBMS_OUTPUT.PUT_LINE('ACTIUNEA: '|| SYS.SYSEVENT || ' S-A APLICAT PE ENTITATEA ' ||  SYS.DICTIONARY_OBJ_NAME);	

	v_event_H_M := TO_CHAR(SYSDATE, 'HH24:MI');

	INSERT INTO evenimente_LDD
        VALUES(SYS.SYSEVENT, SYS.DICTIONARY_OBJ_NAME, SYSDATE, v_event_H_M );
END;
/


select * from evenimente_LDD;

drop trigger rares_trigger_LDD;
