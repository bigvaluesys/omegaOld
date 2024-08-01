#!/bin/bash

#Declaration des variables
CHECK_FILE_LOCATION="../../checkFile/shl"
CHECK_FILE_NAME="checkFile.sh"
LOAD_DATA_LOCATION="../../loadData/shl/"
LOAD_DATA_NAME="loadData.sh"
EXTRACT_DATA_LOCATION="../../extractData/shl/"
EXTRACT_DATA_NAME="extractData.sh"
FILE="chainEmp"
LOG_LOCATION="../log"
DATE=`date '+%Y%m%d%H%M%S'`
LOG_FILE=${LOG_LOCATION}/${FILE}_${DATE}".log"

#Recuperation des fichiers csv de la machine distante
cd $CHECK_FILE_LOCATION
$CHECK_FILE_LOCATION/$CHECK_FILE_NAME
code_retour=$?

if [ $code_retour -ne 0 ]
then
        echo "ERROR : La recuperation des fichiers de la machine distante a echoué"
        echo "$(date '+%d-%m-%Y %H:%M:%S') > ERROR : La recuperation des fichiers de la machine distante a echoué " | tee -a ${LOG_FILE}
exit 1
fi
