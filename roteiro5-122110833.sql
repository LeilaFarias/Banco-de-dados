1. SELECT COUNT(fname) FROM employee WHERE sex = 'F';
2. SELECT AVG(salary) FROM employee WHERE address LIKE '%TX' AND sex = 'M';
3. SELECT e.superssn AS ssn_supervisor, 
        COUNT(e.fname) AS qtd_supervisionados 
    FROM 
        employee AS e 
    LEFT JOIN 
        employee AS b 
    ON 
        b.ssn=e.superssn 
    GROUP BY   
        (e.superssn) 
    ORDER BY   
        (COUNT(e.fname));

4. SELECT e.fname, COUNT(b.fname) FROM employee AS e INNER JOIN employee AS b ON e.ssn=b.superssn GROUP BY(e.fname) ORDER BY (COUNT(b.fname));

5. SELECT e.fname, COUNT(b.fname) FROM employee AS e RIGHT JOIN employee AS b ON e.ssn=b.superssn
 GROUP BY(e.fname);

6. SELECT MIN(qtd) AS qtd FROM (SELECT COUNT(DISTINCT essn) AS qtd FROM works_on GROUP BY (pno)) AS projetoCount;

7. SELECT pno AS num_projeto, COUNT(DISTINCT essn) AS qtd_funcionarios FROM works_on GROUP BY (pno);

8. SELECT w.pno, AVG(e.salary) FROM works_on AS w INNER JOIN employee AS e ON w.essn=e.ssn GROUP BY (w.pno);

9. SELECT w.pno AS proj_num, p.pname AS proj_nome, AVG(e.salary) AS media_sal FROM works_on AS w INNER JOIN employee AS e ON w.essn=e.ssn INNER JOIN project AS p ON w.pno=p.pnumber GROUP BY (w.pno, p.pname);

10. SELECT e.fname, e.salary FROM employee AS e INNER JOIN (SELECT MAX(e.salary) FROM employee AS e INNER JOIN works_on AS w ON e.ssn=w.essn AND w.pno=92) AS maxSalary92 ON e.salary > maxSalary92.max;

11. SELECT e.ssn, COUNT(w.pno) AS qtd_proj FROM employee AS e LEFT JOIN works_on AS w ON e.ssn=w.essn GROUP BY (e.ssn) ORDER BY (COUNT(w.pno));

12. SELECT w.pno, COUNT(e.fname) FROM employee AS e LEFT JOIN works_on AS w ON w.essn=e.ssn GROUP BY (w.pno) HAVING COUNT(e.fname) < 5 ORDER BY (COUNT(e.fname));

13. SELECT e.fname FROM employee AS e WHERE e.ssn IN (SELECT w.essn FROM works_on AS w WHERE w.pno IN (SELECT p.pnumber FROM project AS p WHERE p.Plocation = 'Sugarland')) AND e.ssn IN (SELECT d.essn FROM dependent AS d);

14. SELECT d.dname FROM department AS d WHERE NOT EXISTS (SELECT 1 FROM project AS p WHERE p.Dnum = d.Dnumber);

15. SELECT e.fname, e.lname FROM employee AS e WHERE NOT EXISTS (SELECT pno FROM works_on WHERE essn='123456789' AND pno NOT IN (SELECT pno FROM works_on AS w WHERE w.essn=e.ssn AND w.essn <>'123456789'));
