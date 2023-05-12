------------------------------(GENERATIE)-------------------------------

CREATE TABLE GENERATIE 
    ( ID_GENERATIE   NUMBER  
       CONSTRAINT  ID_GENERATIE_nn NOT NULL  
    , AN_INCEPUT    NUMBER UNIQUE
    , AN_SFARSIT    NUMBER
    , NR_CONSOLE    NUMBER
    );

CREATE UNIQUE INDEX ID_GENERATIE_pk 
ON GENERATIE (ID_GENERATIE);

ALTER TABLE GENERATIE
ADD (CONSTRAINT ID_GENERATIE_pk
    		PRIMARY KEY(ID_GENERATIE));

ALTER TABLE GENERATIE
ADD CONSTRAINT logica_anilor CHECK (AN_INCEPUT < AN_SFARSIT);

INSERT INTO GENERATIE VALUES ( 1, 1997, 2000, 2);
INSERT INTO GENERATIE VALUES ( 2, 2001, 2007, 6);
INSERT INTO GENERATIE VALUES ( 3, 2005 , 2012, 5);
INSERT INTO GENERATIE VALUES ( 4, 2016 , 2021, 9);
INSERT INTO GENERATIE VALUES ( 5, 2017 , 2020, 9);
INSERT INTO GENERATIE VALUES ( 6, 2021 , 2030, 3);

-------------------------------(CONSOLA)-------------------------------

CREATE TABLE CONSOLA( ID_CONSOLA VARCHAR(25) CONSTRAINT ID_CONSOLA_nn NOT NULL, 
    					DATA_LANSARE VARCHAR(15),
    					ID_GENERATIE NUMBER,
    					CONSTRAINT FK_CONSOLA FOREIGN KEY(ID_GENERATIE) REFERENCES GENERATIE(ID_GENERATIE));

CREATE UNIQUE INDEX ID_CONSOLA_pk 
ON CONSOLA (ID_CONSOLA);

ALTER TABLE CONSOLA
ADD (CONSTRAINT ID_CONSOLA_pk
    		PRIMARY KEY(ID_CONSOLA));

INSERT INTO CONSOLA VALUES('PLAYSTATION_1', '15/02/1996', 1);
INSERT INTO CONSOLA VALUES('PLAYSTATION_2', '23/11/2002', 2);
INSERT INTO CONSOLA VALUES('PLAYSTATION_3', '15/02/2008', 3);
INSERT INTO CONSOLA VALUES('PLAYSTATION_STREET', '01/07/2010', 4);
INSERT INTO CONSOLA VALUES('PLAYSTATION_4', '15/12/2017', 5);
INSERT INTO CONSOLA VALUES('PLAYSTATION_vita', '13/03/2018', 5);

-------------------------------(PRODUCATOR)-------------------------------

CREATE TABLE PRODUCATOR 
    ( ID_PRODUCATOR   NUMBER CONSTRAINT  ID_PRODUCATOR_nn NOT NULL  
    , NUME_PRODUCATOR VARCHAR(35)
    , DURATA_PARTENERIAT  NUMBER
    );

CREATE UNIQUE INDEX ID_PRODUCATOR_pk 
ON PRODUCATOR (ID_PRODUCATOR);

ALTER TABLE PRODUCATOR
ADD (CONSTRAINT ID_PRODUCATOR_pk
    		PRIMARY KEY(ID_PRODUCATOR));

INSERT INTO PRODUCATOR VALUES(1, 'SONY', 17);
INSERT INTO PRODUCATOR VALUES(2, 'AMD', 4);
INSERT INTO PRODUCATOR VALUES(3, 'INTEL', 10);
INSERT INTO PRODUCATOR VALUES(4, 'RAZER', 8);
INSERT INTO PRODUCATOR VALUES(5, 'SONY.JP', 18);
    
--------------------------------(PROCESOR)--------------------------------
    
CREATE TABLE PROCESOR
    ( ID_PROCESOR  NUMBER CONSTRAINT  ID_PROCESOR_nn NOT NULL  
    , NUME_PROCESOR VARCHAR(35)
    );

CREATE UNIQUE INDEX ID_PROCESOR_pk 
ON PROCESOR (ID_PROCESOR);

ALTER TABLE PROCESOR
ADD (CONSTRAINT ID_PROCESOR_pk
    		PRIMARY KEY(ID_PROCESOR));

INSERT INTO PROCESOR VALUES(1, 'GP-45');
INSERT INTO PROCESOR VALUES(2, 'RT-90');
INSERT INTO PROCESOR VALUES(3, 'XK-10');
INSERT INTO PROCESOR VALUES(4, 'FS-33');
INSERT INTO PROCESOR VALUES(5, 'RT-76');
INSERT INTO PROCESOR VALUES(6, 'JH-76');

---------------------------------(MODEL)---------------------------------

CREATE TABLE MODEL
    ( ID_MODEL   VARCHAR(25) 
       CONSTRAINT  ID_MODEL_nn NOT NULL  
    , PORECLA VARCHAR(50)
    , DATA_INCEPUT_FAB    DATE
    , DATA_SFARSIT_FAB    DATE
    , PRET    FLOAT
    );

CREATE UNIQUE INDEX ID_MODEL_pk 
ON MODEL (ID_MODEL);

ALTER TABLE MODEL
ADD (CONSTRAINT ID_MODEL_pk
    		PRIMARY KEY(ID_MODEL));

ALTER TABLE MODEL
ADD CONSTRAINT logica_fab CHECK (DATA_INCEPUT_FAB < DATA_SFARSIT_FAB);

----------------------------------(LOT)----------------------------------

CREATE TABLE LOT
    ( ID_LOT  NUMBER CONSTRAINT  ID_LOT_nn NOT NULL  
    , NR_UNITATI NUMBER
    , VENITURI_ASTEPTATE NUMBER
    ,ID_MODEL VARCHAR(25) );

CREATE UNIQUE INDEX ID_LOT_pk 
ON LOT (ID_LOT);

ALTER TABLE LOT
ADD (CONSTRAINT ID_LOT_pk
    		PRIMARY KEY(ID_LOT)
    ,CONSTRAINT ID_LOT_fk
    		FOREIGN KEY(ID_MODEL)
    		REFERENCES MODEL(ID_MODEL));

INSERT INTO LOT VALUES(1, 1500, 1000000, 'SCH-1221');
INSERT INTO LOT VALUES(2, 3000, 2500000, 'SCH-1329');
INSERT INTO LOT VALUES(3, 1000, 500000, 'SCH-1001');
INSERT INTO LOT VALUES(4, 2500, 150000, 'SCH-1223');
INSERT INTO LOT VALUES(5, 1200, 1600000, 'SCH-1491');

----------------------------------(VANZATOR)----------------------------------

