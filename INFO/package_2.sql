CREATE OR REPLACE PACKAGE pachet_14 AS

    -- Cerinta orice informatie posibila despre o consola
   CURSOR loturi_cur(v_id_model model.id_model%TYPE);

    TYPE tuplu_info_modele IS RECORD
    (
        t_id_generatie consola.id_generatie%TYPE,
        t_id_consola model.id_consola%TYPE,
        t_id_model model.id_model%TYPE,
        t_porecla model.porecla%TYPE
    );

    TYPE tabel_indexat_info_modele IS TABLE OF tuplu_info_modele INDEX BY PLS_INTEGER;

    TYPE tuplu_echi_model IS RECORD
    (
        t_id_echipa echipa.id_echipa%TYPE;
        t_id_model model.id_model%TYPE
    );

    TYPE vector IS VARRAY(50) OF tuplu_echi_model;

    PROCEDURE inset_info_modele;

	PROCEDURE afisare(v_id_model model.id_model%TYPE);

    FUNCTION echipe_modele(v_id_model model.id_model%TYPE) RETURN vector;

    FUNCTION nr_angajati(v_id_model model.id_model%TYPE) RETURN NUMBER;

END pachet_14;
/

CREATE OR REPLACE PACKAGE BODY pachet_14 AS

    tabel_info_model tabel_indexat_info_modele;
    vec vector := vector();

    -- CURSOR
    CURSOR loturi_cur(v_id_model model.id_model%TYPE) IS
        SELECT m.id_model, l.id_lot
        FROM model m, lot l
        WHERE l.id_model = v_id_model

    -- PROCEDURE 1
    PROCEDURE inset_info_modele IS
    BEGIN
        SELECT c.id_generatie, m.id_consola, m.id_model, m.porecla
        BULK COLLECT INTO tabel_info_model
        FROM MODEL m, CONSOLA c
		WHERE c.id_consola = m.id_consola;
    END inset_info_modele;



    -- FUNCTION 1
    FUNCTION echipe_modele(v_id_model model.id_model%TYPE) RETURN vector IS
    BEGIN
        FOR i IN (
            SELECT e.id_echipa, m.id_model
            FROM echipa e, model m, plan p
            WHERE e.id_echipa = p.id_echipa
            AND m.id_model = p.id_model
            AND m.id_model = v_id_model
        ) LOOP
            vec.extend;
            vec(vec.LAST) := tuplu_echi_model(i.id_echipa, i.id_model);
        END LOOP;
        RETURN vec;
    END echipe_modele;

    -- FUNCTION 2
    FUNCTION nr_angajati(v_id_model model.id_model%TYPE, vec_f2 vector) RETURN NUMBER IS
        nr_ang NUMBER;
		nr_final_ang NUMBER := 0;
    BEGIN
        FOR i IN vec_f2.FIRST .. vec_f2.LAST LOOP
        	IF i.id_model = v_id_model THEN
        		SELECT COUNT(*)
        		INTO nr_ang
        		FROM angajat
        	    where id_echipa = i.id_echipa;

				nr_final_ang := nr_final_ang + nr_ang;
        	END IF;
      	END LOOP;

        RETURN nr_final_ang;

    END nr_angajati;

	-- PROCEDURE 2
	PROCEDURE afisare(v_id_model model.id_model%TYPE) IS
        
		nr_ang_pe_model NUMBER;
        nr_loturi NUMBER;
		
        BEGIN
            
			FOR i_cursor IN loturi_cur(v_id_model) LOOP
            	nr_loturi := nr_loturi + 1;
			END LOOP;

			nr_ang_pe_model := nr_angajati(v_id_model, echipe_modele(v_id_model))

            FOR i in tabel_info_model.FIRST .. tabel_info_model.LAST LOOP

                IF(tabel_info_model(i).id_model = v_id_model) THEN
                DBMS_OUTPUT.PUT_LINE('MODEL: ' || tabel_info_model(i).id_model ||
                					 'PORECLA: ' || tabel_info_model(i).porecla ||
                					 'CONSOLA: ' || tabel_info_model(i).id_consola ||
                					 'GENERATIE: ' || tabel_info_model(i).id_generatie||
                					 'NUMAR ANGAJATI CARE AU LUCRAT LA MODEL: ' || nr_ang_pe_model ||
                					 'LOTURI DISTRIBUITE PENTRU ACEST MODEL: '|| nr_loturi);
				END IF;
            END LOOP
        END afisare;

END pachet_14;
/


 DECLARE
    v_model_id model.id_model%TYPE := 'SCH-4005' ; -- Replace with the desired model ID
BEGIN
    pachet_14.afisare(v_model_id);
END;
/

select * from model;
select * from consola;
select * from cerere;
select * from generatie;
select * from echipa;
select * from angajat;
select * from plan;
select * from lot;

