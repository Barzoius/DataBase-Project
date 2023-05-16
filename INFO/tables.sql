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
    ( ID_PRODUCATOR  VARCHAR(10) CONSTRAINT  ID_PRODUCATOR_nn NOT NULL  
    , NUME_PRODUCATOR VARCHAR(35)
    , DURATA_PARTENERIAT  NUMBER
    );

CREATE UNIQUE INDEX ID_PRODUCATOR_pk 
ON PRODUCATOR (ID_PRODUCATOR);

ALTER TABLE PRODUCATOR
ADD (CONSTRAINT ID_PRODUCATOR_pk
    		PRIMARY KEY(ID_PRODUCATOR));

INSERT INTO PRODUCATOR VALUES('PR-01', 'SONY', 17);
INSERT INTO PRODUCATOR VALUES('PR-02', 'AMD', 4);
INSERT INTO PRODUCATOR VALUES('PR-03', 'INTEL', 10);
INSERT INTO PRODUCATOR VALUES('PR-04', 'RAZER', 8);
INSERT INTO PRODUCATOR VALUES('PR-05', 'SONY.JP', 18);
    
--------------------------------(PROCESOR)--------------------------------
    
CREATE TABLE PROCESOR
    ( ID_PROCESOR  VARCHAR(10) CONSTRAINT  ID_PROCESOR_nn NOT NULL  
    , NUME_PROCESOR VARCHAR(35)
    );

CREATE UNIQUE INDEX ID_PROCESOR_pk 
ON PROCESOR (ID_PROCESOR);

ALTER TABLE PROCESOR
ADD (CONSTRAINT ID_PROCESOR_pk
    		PRIMARY KEY(ID_PROCESOR));

INSERT INTO PROCESOR VALUES('P-01', 'GP-45');
INSERT INTO PROCESOR VALUES('P-02', 'RT-90');
INSERT INTO PROCESOR VALUES('P-03', 'XK-10');
INSERT INTO PROCESOR VALUES('P-04', 'FS-33');
INSERT INTO PROCESOR VALUES('P-05', 'RT-76');
INSERT INTO PROCESOR VALUES('P-06', 'JH-76');

--------------------------------(MODEL)--------------------------------

CREATE TABLE MODEL
    ( ID_MODEL   VARCHAR(25) 
       CONSTRAINT  ID_MODEL_nn NOT NULL  
    , PORECLA VARCHAR(50)
    , DATA_INCEPUT_FAB    DATE
    , DATA_SFARSIT_FAB    DATE
    , PRET   FLOAT
    , ID_CONSOLA VARCHAR(25),
    CONSTRAINT FK_MODEL FOREIGN KEY(ID_CONSOLA) REFERENCES CONSOLA(ID_CONSOLA));

CREATE UNIQUE INDEX ID_MODEL_pk 
ON MODEL (ID_MODEL);

ALTER TABLE MODEL
ADD (CONSTRAINT ID_MODEL_pk
    		PRIMARY KEY(ID_MODEL));


ALTER TABLE MODEL
ADD CONSTRAINT logica_fab CHECK (DATA_INCEPUT_FAB < DATA_SFARSIT_FAB);

INSERT INTO MODEL VALUES ('SCH-1001', 'SLIM', TO_DATE('14-07-2002','DD-MM-YYYY'), TO_DATE('15-03-2005','DD-MM-YYYY'), 99, 'PLAYSTATION_1');
INSERT INTO MODEL VALUES ('SCH-2020', 'SLIM', TO_DATE('11-11-2004','DD-MM-YYYY'), TO_DATE('11-03-2009','DD-MM-YYYY'), 99.99, 'PLAYSTATION_2');
INSERT INTO MODEL VALUES ('SCH-3012', 'FAT', TO_DATE('14-07-2010','DD-MM-YYYY'), TO_DATE('15-03-2015','DD-MM-YYYY'), 99, 'PLAYSTATION_3');
INSERT INTO MODEL VALUES ('SCH-3019', 'SUPER_SLIM', TO_DATE('01-12-2011','DD-MM-YYYY'), TO_DATE('15-03-2015','DD-MM-YYYY'), 199.99, 'PLAYSTATION_3');
INSERT INTO MODEL VALUES ('SCH-4005', 'SLIM', TO_DATE('14-07-2016','DD-MM-YYYY'), TO_DATE('15-03-2020','DD-MM-YYYY'), 99, 'PLAYSTATION_4');
INSERT INTO MODEL VALUES ('SCH-1000', 'X', TO_DATE('28-01-1998','DD-MM-YYYY'), TO_DATE('25-03-2003','DD-MM-YYYY'), 100, 'PLAYSTATION_1');

--------------------------------(LOT)--------------------------------

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

INSERT INTO LOT VALUES(1, 1500, 1000000, 'SCH-4005');
INSERT INTO LOT VALUES(2, 2500, 1300000, 'SCH-4005');
INSERT INTO LOT VALUES(3, 3000, 2500000, 'SCH-2020');
INSERT INTO LOT VALUES(4, 1000, 500000, 'SCH-1001');
INSERT INTO LOT VALUES(5, 2500, 150000, 'SCH-3012');
INSERT INTO LOT VALUES(6, 1200, 1600000, 'SCH-1000');

--------------------------------(VANZATOR)--------------------------------

CREATE TABLE VANZATOR
    ( ID_VANZATOR   VARCHAR(10) 
       CONSTRAINT  ID_VANZATOR_nn NOT NULL  
    , NUME_VANZATOR VARCHAR(50) UNIQUE
    , VENIT_TOTAL_ADUS   FLOAT);

CREATE UNIQUE INDEX ID_VANZATOR_pk 
ON VANZATOR (ID_VANZATOR);

ALTER TABLE VANZATOR
ADD (CONSTRAINT ID_VANZATOR_pk
    		PRIMARY KEY(ID_VANZATOR));

INSERT INTO VANZATOR VALUES ('V-01', 'EMAG', 1750000);
INSERT INTO VANZATOR VALUES ('V-02', 'AMAZON', 20000000);
INSERT INTO VANZATOR VALUES ('V-03', 'GAME-STOP', 1300000);
INSERT INTO VANZATOR VALUES ('V-04', 'ALTEX', 300000);
INSERT INTO VANZATOR VALUES ('V-05', 'EVO', 400000);

--------------------------------(TARA)--------------------------------

CREATE TABLE TARA
	(ID_TARA VARCHAR(10)
    	CONSTRAINT ID_TARA_nn NOT NULL
    , NUME_TARA VARCHAR(50) UNIQUE
    , PRET_DE_EXPORT FLOAT);

CREATE UNIQUE INDEX ID_TARA_pk
ON TARA(ID_TARA);

ALTER TABLE TARA
ADD (CONSTRAINT ID_TARA_pk PRIMARY KEY(ID_TARA));

INSERT INTO TARA VALUES ('EU-01', 'ROMANIA', 10.20);
INSERT INTO TARA VALUES ('EU-02', 'ITALIA', 15.00);
INSERT INTO TARA VALUES ('AS-01', 'CHINA', 5.00);
INSERT INTO TARA VALUES ('AF-01', 'EGIPT', 3.00);
INSERT INTO TARA VALUES ('AMN-01', 'CANADA', 23.05);
INSERT INTO TARA VALUES ('AMS-01', 'BRAZILIA', 11.05);

--------------------------------(LOCATIE)--------------------------------

CREATE TABLE LOCATIE
	(ID_LOCATIE VARCHAR(10) CONSTRAINT ID_LOCATIE_nn NOT NULL
     , ORAS VARCHAR(35)
     , COD_POSTAL VARCHAR(25) UNIQUE
     , ID_TARA VARCHAR(10),
       CONSTRAINT FK_LOCATIE FOREIGN KEY(ID_TARA) REFERENCES TARA(ID_TARA));

CREATE UNIQUE INDEX ID_LOCATIE_pk
ON LOCATIE(ID_LOCATIE);

ALTER TABLE LOCATIE
ADD (CONSTRAINT ID_LOCATIE_pk PRIMARY KEY(ID_LOCATIE));

INSERT INTO LOCATIE VALUES ('L-01', 'BUCURESTI', '020141','EU-01');
INSERT INTO LOCATIE VALUES ('L-02', 'VENETIA', '121141','EU-02');
INSERT INTO LOCATIE VALUES ('L-03', 'HONG-KONG', '012333','AS-01');
INSERT INTO LOCATIE VALUES ('L-04', 'AKHMIN', '323021','AF-01');
INSERT INTO LOCATIE VALUES ('L-05', 'CHARLOTTETOWN', '330123','AMN-01');
INSERT INTO LOCATIE VALUES ('L-06', 'RECIFE', '121030','AMS-01');

--------------------------------(ECHIPA)--------------------------------

CREATE TABLE ECHIPA
	(ID_ECHIPA VARCHAR(10) CONSTRAINT ID_ECHIPA_nn NOT NULL
    ,NUME_ECHIPA VARCHAR(50) UNIQUE
    ,ID_LOCATIE VARCHAR(10),
     CONSTRAINT FK_ECHIPA FOREIGN KEY(ID_LOCATIE) REFERENCES LOCATIE(ID_LOCATIE));

CREATE UNIQUE INDEX ID_ECHIPA_pk
ON ECHIPA(ID_ECHIPA);

ALTER TABLE ECHIPA
ADD (CONSTRAINT ID_ECHIPA_pk PRIMARY KEY(ID_ECHIPA));

INSERT INTO ECHIPA VALUES ('E-01', 'BLAZE_SOFT', 'L-02' );
INSERT INTO ECHIPA VALUES ('E-02', 'STONE_WARE', 'L-01' );
INSERT INTO ECHIPA VALUES ('E-03', 'CONFIG_DESIGN', 'L-03' );
INSERT INTO ECHIPA VALUES ('E-04', 'BREW_PROS', 'L-04' );
INSERT INTO ECHIPA VALUES ('E-05', 'MINIMAL_DESIGN', 'L-06' );
INSERT INTO ECHIPA VALUES ('E-06', 'GOURMETS', 'L-05' );

--------------------------------(JOB)--------------------------------

CREATE TABLE JOB
	(ID_JOB VARCHAR(10) CONSTRAINT ID_JOB_nn NOT NULL
    ,TITLU_JOB VARCHAR(50) UNIQUE
    ,SALARIU_MIN FLOAT
    ,SALARIU_MAX FLOAT
    ,ZILE_DE_LUCRU NUMBER);

CREATE UNIQUE INDEX ID_JOB_pk
ON JOB(ID_JOB);

ALTER TABLE JOB
ADD (CONSTRAINT ID_JOB_pk PRIMARY KEY(ID_JOB));

INSERT INTO JOB VALUES ('J-01', 'HARDWARE_ENG', 5000, 2500, 200);
INSERT INTO JOB VALUES ('J-02', 'SOFTWARE_ENG', 7500, 3500, 170);
INSERT INTO JOB VALUES ('J-03', 'WEB_DESIGN', 4500, 2500, 305);
INSERT INTO JOB VALUES ('J-04', 'FRONT_END', 3000, 2500, 200);
INSERT INTO JOB VALUES ('J-05', 'BACK_END', 4000, 3000, 200);
INSERT INTO JOB VALUES ('J-06', 'HARDWARE_DESIGN', 2000, 1000, 150);

--------------------------------(ANGAJAT)--------------------------------

CREATE TABLE ANGAJAT
	(ID_ANGAJAT VARCHAR(10) CONSTRAINT ID_ANGAJAT_nn NOT NULL
    ,NUME VARCHAR(50) 
    ,PRENUME VARCHAR(50) 
    ,EMAIL VARCHAR(35) UNIQUE
    ,NR_TELEFON VARCHAR(10) UNIQUE
    ,SEX VARCHAR(3) CONSTRAINT SEX_const NOT NULL
    ,NATIONALITATE VARCHAR(25) CONSTRAINT NATIONALITATE_const NOT NULL
    ,SALARIU FLOAT CONSTRAINT SALARIU_const NOT NULL
    ,ID_ECHIPA VARCHAR(10),
     CONSTRAINT FK_ANGAJAT FOREIGN KEY(ID_ECHIPA) REFERENCES ECHIPA(ID_ECHIPA)
    ,ID_JOB VARCHAR(10),
     CONSTRAINT FK2_ANGAJAT FOREIGN KEY(ID_JOB) REFERENCES JOB(ID_JOB));

CREATE UNIQUE INDEX ID_ANGAJAT_pk
ON ANGAJAT(ID_ANGAJAT);

ALTER TABLE ANGAJAT
ADD (CONSTRAINT ID_ANGAJAT_pk PRIMARY KEY(ID_ANGAJAT));

INSERT INTO ANGAJAT VALUES ('A-01', 'RARES', 'MOISEL','mecca.rares@gmail.com', '0799835735', 'M', 'ROMAN', 2750.75, 'E-01', 'J-02');
INSERT INTO ANGAJAT VALUES ('A-02', 'OZY', 'BARZI','ozy.bazri@gmail.com', '0334835735', 'M', 'ROMAN', 3750.75, 'E-01', 'J-01');
INSERT INTO ANGAJAT VALUES ('A-03', 'DAN', 'DANIEL','dan.daniel@gmail.com', '0499835735', 'M', 'ITALIAN', 2550.00, 'E-03', 'J-03');
INSERT INTO ANGAJAT VALUES ('A-04', 'DANA', 'DANIELA','dana.daniela@gmail.com', '0293835735', 'F', 'SPANIOLA', 2850.15, 'E-04', 'J-05');
INSERT INTO ANGAJAT VALUES ('A-05', 'RARES', 'MOISEL','moisel.rares@gmail.com', '0699825725', 'M', 'ENGLEZ', 2070.65, 'E-01', 'J-04');

--------------------------------(CERERE)--------------------------------[RELATIA DE TIP 3]---------------------------------

CREATE TABLE CERERE
	(ID_CONSOLA VARCHAR(25) CONSTRAINT  ID_C_CONSOLA_pk REFERENCES CONSOLA(ID_CONSOLA)
    ,ID_PROCESOR VARCHAR(10) CONSTRAINT ID_C_PROCESOR_pk REFERENCES PROCESOR(ID_PROCESOR)
    ,ID_PRODUCATOR VARCHAR(10) CONSTRAINT ID_C_PRODUCATOR_pk REFERENCES PRODUCATOR(ID_PRODUCATOR)
    ,DATA_EMITERE_CERERE DATE CONSTRAINT data_emt NOT NULL
    ,NR_PROCESOARE NUMBER CONSTRAINT nr_proc NOT NULL
    ,CONSTRAINT CER_C_pk PRIMARY KEY(ID_CONSOLA, ID_PROCESOR, ID_PRODUCATOR));

INSERT INTO CERERE VALUES (UPPER('Playstation_1'), 'P-01', 'PR-02', TO_DATE('01-11-2001','dd-mm-yyyy'), 15000);
INSERT INTO CERERE VALUES (UPPER('Playstation_2'), 'P-02', 'PR-02', TO_DATE('01-07-2005','dd-mm-yyyy'), 25000);
INSERT INTO CERERE VALUES ('PLAYSTATION_vita', 'P-01', 'PR-02', TO_DATE('28-07-2017','dd-mm-yyyy'), 4000);
INSERT INTO CERERE VALUES (UPPER('Playstation_3'), 'P-01', 'PR-03', TO_DATE('01-12-2010','dd-mm-yyyy'), 1500);
INSERT INTO CERERE VALUES (UPPER('Playstation_1'), 'P-04', 'PR-02', TO_DATE('10-01-2002','dd-mm-yyyy'), 30000);
INSERT INTO CERERE VALUES (UPPER('Playstation_3'), 'P-02', 'PR-01', TO_DATE('11-11-2011','dd-mm-yyyy'), 55000);
INSERT INTO CERERE VALUES (UPPER('Playstation_4'), 'P-01', 'PR-02', TO_DATE('15-03-2018','dd-mm-yyyy'), 5400);
INSERT INTO CERERE VALUES (UPPER('Playstation_street'), 'P-05', 'PR-02', TO_DATE('01-11-2001','dd-mm-yyyy'), 400);
INSERT INTO CERERE VALUES (UPPER('Playstation_2'), 'P-06', 'PR-01', TO_DATE('08-30-2007','dd-mm-yyyy'), 67000);
INSERT INTO CERERE VALUES (UPPER('Playstation_2'), 'P-06', 'PR-02', TO_DATE('01-11-2007','dd-mm-yyyy'), 2300);

--------------------------------------(PLAN)--------------------------------------

CREATE TABLE PLAN
	(ID_MODEL VARCHAR(25) CONSTRAINT  ID_C_MODEL_pk REFERENCES MODEL(ID_MODEL)
    ,ID_ECHIPA VARCHAR(10) CONSTRAINT ID_C_ECHIPA_pk REFERENCES ECHIPA(ID_ECHIPA)
    ,DEADLINE DATE CONSTRAINT deadline NOT NULL
    ,CONSTRAINT PLAN_C_pk PRIMARY KEY(ID_MODEL, ID_ECHIPA));

INSERT INTO PLAN VALUES (UPPER('sch-1001'), UPPER('e-01'), TO_DATE('30-12-2001','dd-mm-yyyy'));
INSERT INTO PLAN VALUES (UPPER('sch-1001'), UPPER('e-02'), TO_DATE('30-12-2001','dd-mm-yyyy'));
INSERT INTO PLAN VALUES (UPPER('sch-1001'), UPPER('e-03'), TO_DATE('30-12-2001','dd-mm-yyyy'));
INSERT INTO PLAN VALUES (UPPER('sch-4005'), UPPER('E-01'), TO_DATE('20-12-2016','dd-mm-yyyy'));
INSERT INTO PLAN VALUES (UPPER('sch-2020'), UPPER('e-02'), TO_DATE('20-11-2004','dd-mm-yyyy'));
INSERT INTO PLAN VALUES (UPPER('sch-3012'), UPPER('e-06'), TO_DATE('11-08-2010','dd-mm-yyyy'));
INSERT INTO PLAN VALUES (UPPER('sch-3019'), UPPER('e-01'), TO_DATE('15-01-2012','dd-mm-yyyy'));
INSERT INTO PLAN VALUES (UPPER('sch-1000'), UPPER('e-03'), TO_DATE('10-01-1997','dd-mm-yyyy'));
INSERT INTO PLAN VALUES (UPPER('sch-1000'), UPPER('e-02'), TO_DATE('10-01-1997','dd-mm-yyyy'));
INSERT INTO PLAN VALUES (UPPER('sch-4005'), UPPER('e-05'), TO_DATE('30-12-2001','dd-mm-yyyy'));

--------------------------------------(MAGAZIN)--------------------------------------

CREATE TABLE MAGAZIN
	(ID_VANZATOR VARCHAR(10) CONSTRAINT  ID_C_VANZATOR_pk REFERENCES VANZATOR(ID_VANZATOR)
    ,ID_TARA VARCHAR(10) CONSTRAINT ID_C_TARA_pk REFERENCES TARA(ID_TARA)
    ,NR_MAGAZINE NUMBER 
    ,CONSTRAINT MAG_C_pk PRIMARY KEY(ID_VANZATOR, ID_TARA));

INSERT INTO MAGAZIN VALUES (UPPER('V-01'), UPPER('eu-02'), 140);
INSERT INTO MAGAZIN VALUES (UPPER('V-01'), UPPER('eu-01'), 50);
INSERT INTO MAGAZIN VALUES (UPPER('V-02'), UPPER('eu-02'), 260);
INSERT INTO MAGAZIN VALUES (UPPER('V-02'), UPPER('as-01'), 240);
INSERT INTO MAGAZIN VALUES (UPPER('V-02'), UPPER('af-01'), 28);
INSERT INTO MAGAZIN VALUES (UPPER('V-02'), UPPER('ams-01'), 73);
INSERT INTO MAGAZIN VALUES (UPPER('V-02'), UPPER('amn-01'), 1030);
INSERT INTO MAGAZIN VALUES (UPPER('V-05'), UPPER('eu-02'), 0);
INSERT INTO MAGAZIN VALUES (UPPER('V-03'), UPPER('amn-01'), 360);
INSERT INTO MAGAZIN VALUES (UPPER('V-04'), UPPER('eu-01'), 53);
