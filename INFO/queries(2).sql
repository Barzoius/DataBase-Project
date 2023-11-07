------------------(1)------------------

CREATE OR REPLACE PROCEDURE gestionare_angajati IS 
  --Declarații de tipuri--
  TYPE tuplu IS RECORD (
    tuplu_id_angajat angajat.id_angajat%TYPE,
    tuplu_id_echipa angajat.id_echipa%TYPE
  );

  TYPE tabou_indexat IS TABLE OF tuplu INDEX BY PLS_INTEGER;
  TYPE tabou_imbricat IS TABLE OF NUMBER;
  TYPE vector IS VARRAY(20) OF NUMBER;

  --Declarații de variabile--
  tabou_indexat_echipe tabou_indexat;
  tabou_imbricat_angajati tabou_imbricat := tabou_imbricat();
  vec vector := vector();

  limita_superioara NUMBER;

BEGIN
  SELECT COUNT(*) INTO limita_superioara FROM angajat;

  FOR i IN 1..limita_superioara LOOP
  SELECT id_angajat, id_echipa INTO 
         tabou_indexat_echipe(i).tuplu_id_angajat, tabou_indexat_echipe(i).tuplu_id_echipa 
         FROM angajat WHERE ROWNUM = i;
  END LOOP;
  FOR i IN tabou_indexat_echipe.FIRST .. tabou_indexat_echipe.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(tabou_indexat_echipe(i).tuplu_id_angajat ||' '|| tabou_indexat_echipe(i).tuplu_id_echipa);
  END LOOP;
  
END;
/

BEGIN
  gestionare_angajati;
END;
/
    
select * from angajat;
select * from echipa;
select * from locatie;
select * from tara;


DROP PROCEDURE gestionare_angajati;
