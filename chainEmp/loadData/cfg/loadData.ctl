load data
infile '../in/emp.csv'
into table emp
fields terminated by ";"
( empno, ename, job, mgr, hiredate "to_date(:hiredate,'DD/MM/RR HH24:MI:SS')", sal, comm, deptno  )
