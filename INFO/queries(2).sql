------------------(1)------------------

CREATE TABLE specific_angajat AS SELECT id_angajat, nume, prenume, email, nr_telefon, sex, nationalitate 
                                 FROM angajat;

CREATE OR REPLACE TYPE alergi is TABLE of VARCHAR(20);
/
ALTER TABLE specific_angajat
ADD (alergie alergi) 
NESTED TABLE alergie STORE AS lista_de_alergi;

INSERT INTO specific_angajat
VALUES ('A-25', 'NU_DAN', 'NU_DANIEL','nu.dan.daniel@gmail.com',
        '085556664', 'M', 'AMERICAN', alergi('Nuci', 'Masline', 'Polen'));

UPDATE specific_angajat
SET alergie = alergi('Alune', 'Polen')
WHERE id_angajat = 'A-01';


    
DECLARE 
 TYPE tabou_indexat IS TABLE OF specific_angajat INDEX BY PLS_INTEGER;
-- TYPE tabou_imbricat IS TABLE OF NUMBER;
 TYPE vector is VARRAY(20) OF NUMBER;

 tab_echipe tablou_indexat;
 tab_angajati tablou_imbricat := tablou_imbricat();
 vec vector := vector();

BEGIN


END;
/

    
select * from angajat;
select * from echipa;
select * from specific_angajat;

SELECT a.id_angajat, b.*
FROM specific_angajat a, TABLE (a.alergie) b;

DROP TABLE specific_angajat;;
DROP TYPE alergi;
