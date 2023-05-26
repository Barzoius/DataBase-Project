select j.id_job, j.titlu_job, e.id_echipa, e.nume_echipa,l.id_locatie, INITCAP(l.oras)	
from job j, echipa e, locatie l
where j.salariu_min > (select a.salariu
    				   from angajat a
    				   where a.id_job = j.id_job
    				   and a.id_echipa = e.id_echipa
    				   and e.id_locatie = l.id_locatie)

----------------(2)----------------

SELECT LOWER(t.NUME_TARA), v.ID_VANZATOR, v.NUME_VANZATOR, m.NR_MAGAZINE,  v.VENIT_TOTAL_ADUS, 
CASE 
	WHEN (m.NR_MAGAZINE/t.PRET_DE_EXPORT) > t.PRET_DE_EXPORT THEN INITCAP('ACEST VANAZATOR NE FACE PROFIT.')
    WHEN (m.NR_MAGAZINE/t.PRET_DE_EXPORT) = t.PRET_DE_EXPORT THEN INITCAP('ar trebui sa consideram si alti factori.')
    ELSE 'Nu este profitabi.'
END AS PROFIT  
FROM TARA t, MAGAZIN m, VANZATOR v
WHERE t.ID_TARA = m.ID_TARA
AND v.ID_VANZATOR = m.ID_VANZATOR 
AND v.VENIT_TOTAL_ADUS >= 1500000
ORDER BY m.NR_MAGAZINE;

----------------(3)----------------

select g.id_generatie, min(m.pret), max(m.pret) 
from model m, generatie g, consola c
where  data_inceput_fab > any(select data_emitere_cerere 
    					   from cerere ce, consola c, procesor pr, producator pro
    					   where ce.id_consola = c.id_consola
    					   and ce.id_procesor = pr.id_procesor
    		               and ce.id_producator = pro.id_producator)
and m.id_consola =  c.id_consola
and c.id_generatie = g.id_generatie
group by g.id_generatie
having max(m.pret) > 99;

----------------(4)----------------

SELECT a.nume, a.prenume, LAST_DAY(p.DEADLINE) dead, ROUND(MONTHS_BETWEEN(m.DATA_SFARSIT_FAB, m.DATA_INCEPUT_FAB)) PERIOADA_FAB ,
    p.ID_ECHIPA, CONCAT(m.ID_CONSOLA, CONCAT(' ', m.ID_MODEL)) PROIECT
FROM MODEL m, ECHIPA e, PLAN p, (select avg(salariu) as sal_avg from angajat) sal_avg_ang, angajat a
WHERE p.ID_ECHIPA = e.ID_ECHIPA
and e.id_echipa = a.id_echipa
and p.id_model = m.id_model
and sal_avg_ang.sal_avg < a.salariu
and last_day(p.deadline) < m.data_inceput_fab;

----------------(5)----------------

SELECT v.NUME_VANZATOR || ' e un magazin electronic' AS E_MAGAZIN
FROM MAGAZIN m, VANZATOR v
WHERE NVL(DECODE(NR_MAGAZINE, 0, -1), 12) = -1
AND m.ID_VANZATOR = v.ID_VANZATOR;
	


------------------------------------------------(13)-------------------------------------------------------


UPDATE JOB 
SET SALARIU_MAX = 5000
WHERE SALARIU_MIN > (SELECT min(a.SALARIU)
    				FROM ANGAJAT a
    				WHERE a.NATIONALITATE = 'ROMAN');

SELECT *
FROM JOB;
				   
