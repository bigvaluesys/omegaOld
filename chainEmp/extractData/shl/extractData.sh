#!/bin/bash

USER_NAME="rpc"
PASSWORD="rpc"
ORACLESID="orcl"
SQL_DIR="../sql"
SQL_NAME="extractData.sql"
SCRIPT=${SQL_DIR}/${SQL_NAME}
FILE="extractData"
LOG_LOCATION="../log"
DATE=`date '+%Y%m%d%H%M%S'`
LOG_FILE=${LOG_LOCATION}/${FILE}_${DATE}".log"
EXTRACT_SQL_NAME="extract_emp.sql"
EXTRACT_EMP=${SQL_DIR}/${EXTRACT_SQL_NAME}
CSV_FILE_DIR="../out"
CSV_FILE_NAME="emp_${DATE}.csv"
CSV_FILE=${CSV_FILE_DIR}/${CSV_FILE_NAME}
DATABASE=${USER_NAME}/${PASSWORD}@${ORACLESID}

#Ecriture entete fichier csv
echo "EMPNO;ENAME;JOB;MGR;HIREDATE;SAL;COMM;DNAME;LOC" >> ${CSV_FILE}

#Extraction de la table emp dans le  fichier csv

sqlplus -s ${DATABASE} << FIN >> ${CSV_FILE} | tee -a ${LOG_FILE}
@"${SCRIPT}"
quit
FIN
