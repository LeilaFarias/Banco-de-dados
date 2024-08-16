
1. SELECT dname,dnumber,mgrssn,mgrstartdate FROM department;
2. SELECT essn,dependent_name,sex,bdate,relationship FROM dependent;
3. SELECT dnumber,dlocation FROM dept_locations;
4. SELECT fname,minit,lname,ssn,bdate,address,sex,salary,superssn,dno FROM employee;
5. SELECT pname,pnumber,plocation,dnum FROM project;
6. SELECT essn,pno,hours FROM works_on;

7. SELECT fname,lname FROM employee WHERE sex = 'M';
8. SELECT fname FROM employee WHERE superssn IS NULL;
9. SELECT b.fname AS funcionario ,e.fname AS supervisor FROM EMPLOYEE AS e INNER JOIN EMPLOYEE AS b ON e.ssn=b.superssn; 
10. SELECT funcionario FROM (SELECT b.fname AS funcionario ,e.fname AS supervisor FROM EMPLOYEE AS e INNER JOIN EMPLOYEE A
S b ON e.ssn=b.superssn) AS func_sup WHERE supervisor = 'Franklin'; 

11. SELECT d.dname, l.dlocation FROM department AS d INNER JOIN dept_locations AS l ON d.dnumber=l.dnumber;
12. SELECT dname FROM (SELECT d.dname, l.dlocation FROM department AS d INNER JOIN dept_locations AS l ON d.dnumber=l.dnumber) AS depar_locat WHERE dlocation LIKE 'S%'; 
