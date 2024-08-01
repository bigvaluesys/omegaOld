whenever sqlerror EXIT sql.sqlcode;
SET feed OFF
SET tab OFF
SET verify OFF
SET heading OFF
SET pagesize 0
SET linesize 4000;
ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY HH24:MI:SS';

SELECT
    e.empno
    || ';'
    || e.ename
    || ';'
    || e.job
    || ';'
    || e.mgr
    || ';'
    || e.hiredate
    || ';'
    || e.sal
    || ';'
    || e.comm
    || ';'
    || e.deptno
    || ';'
    || d.dname
    || ';'
    || d.loc
FROM
    rpc.emp  e
    LEFT OUTER JOIN rpc.dept d ON e.deptno = d.deptno;

EXIT;
