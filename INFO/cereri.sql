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

SELECT a.ID_ANGAJAT, CONCAT(a.NUME, CONCAT(' ', a.PRENUME)) NUME_COMPLET, a.ID_JOB 
FROM (SELECT AVG(SALARIU_MAX) AS SALARIU_MAX_MEDIU FROM JOB) SMD, ANGAJAT a
WHERE a.SALARIU > SMD.SALARIU_MAX_MEDIU;

SELECT LAST_DAY(p.DEADLINE), ROUND(MONTHS_BETWEEN(m.DATA_SFARSIT_FAB, m.DATA_INCEPUT_FAB)) PERIOADA_FAB ,
    p.ID_ECHIPA, CONCAT(m.ID_CONSOLA, CONCAT(' ', m.ID_MODEL)) PROIECT
FROM MODEL m, ECHIPA e, PLAN p
WHERE p.ID_ECHIPA = e.ID_ECHIPA;

SELECT v.NUME_VANZATOR || ' e un magazin electronic' AS E_MAGAZIN
FROM MAGAZIN m, VANZATOR v
WHERE NVL(DECODE(NR_MAGAZINE, 0, -1), 12) = -1
AND m.ID_VANZATOR = v.ID_VANZATOR;

select INITCAP(a.NUME), INITCAP(a.PRENUME), l.COD_POSTAL, l.ORAS, t.NUME_TARA, a.ID_jOB
from ANGAJAT a, ECHIPA e, LOCATIE l, tara t
where a.ID_ECHIPA = e.ID_ECHIPA
and e.ID_LOCATIE = l.ID_LOCATIE
and t.ID_TARA = l.ID_TARA
and SUBSTR(l.COD_POSTAL, -3) = '141';


select INITCAP(NUME), INITCAP(PRENUME), ID_JOB
from ANGAJAT 
where ID_ECHIPA in (select ID_ECHIPA
    					from ECHIPA 
    					where ID_LOCATIE in (select ID_LOCATIE
    										from LOCATIE
    										where SUBSTR(COD_POSTAL, -3) = '141'));
										
										
								
select j.ZILE_DE_LUCRU, SUM(a.SALARIU) as SAL_TOTAL, a.ID_JOB
from ANGAJAT a, JOB j
where a.ID_JOB = j.ID_JOB
group by j.ZILE_DE_LUCRU, a.ID_JOB
having SUM(a.SALARIU)  > (  select avg(j.SALARIU_MAX)
    						from JOB j); !!!!!!!!!!!!!!!!!!!!!	
						
				
select SUM(m.PRET), l.NR_UNITATI, c.DATA_LANSARE
from MODEL m, LOT l, CONSOLA c
where c.ID_CONSOLA = m.ID_CONSOLA
and m.ID_MODEL = l.ID_MODEL
group by l.NR_UNITATI, c.DATA_LANSARE
having SUM(m.PRET)*l.NR_UNITATI > (select avg(l.VENITURI_ASTEPTATE)
    				   from LOT l);		
				   
			
with top_jobs as(
    	select TITLU_JOB, SALARIU_MAX, ID_JOB
    	from JOB
    	where SALARIU_MIN > 2500
    	order by SALARIU_MAX)

select aux.TITLU_JOB, a.NUME, a.PRENUME
from ANGAJAT a, top_jobs aux
where aux.ID_JOB = a.ID_JOB;		


------------------------------------------------(13)-------------------------------------------------------


UPDATE JOB 
SET SALARIU_MAX = 5000
WHERE SALARIU_MIN > (SELECT min(a.SALARIU)
    				FROM ANGAJAT a
    				WHERE a.NATIONALITATE = 'ROMAN');

SELECT *
FROM JOB;
				   
