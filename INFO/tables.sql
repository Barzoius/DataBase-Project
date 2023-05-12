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