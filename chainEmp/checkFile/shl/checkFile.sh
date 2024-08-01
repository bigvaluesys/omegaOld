#!/bin/bash

#Chargement de la configuration
. ../cfg/checkFile.cfg

#Declaration des variables
FILE="checkFile"
LOG_LOCATION="../log"
DATE=`date '+%Y%m%d%H%M%S'`
LOG_FILE=${LOG_LOCATION}/${FILE}_${DATE}".log"
#LOCAL_DIR="../data"
#SFTP_DIR="data"

#Declaration de fonctions
function connexion_sftp {
	ServerSFTP=$1
	UserSFTP=$2
	echo "COMMAND : sftp -o Port=$PORT $UserSFTP@$ServerSFTP"
	sftp -o Port=$PORT $UserSFTP@$ServerSFTP << FIN | tee -a $LOG_FILE
cd $SFTP_DIR
ls -lrt
quit
FIN
}

function getfiles {
	 ServerSFTP=$1
         UserSFTP=$2
	 echo "COMMAND : sftp -o Port=$PORT $UserSFTP@$ServerSFTP"
	 sftp -o Port=$PORT $UserSFTP@$ServerSFTP << FIN | tee -a $LOG_FILE
cd $SFTP_DIR
lcd $LOCAL_DIR
get *.csv
quit
FIN
}

echo "$(date '+%d-%m-%Y %H:%M:%S') > checkFile [INFO] : ######### Demarrage de traitement ###########" | tee -a $LOG_FILE

case $MACHINE in
	oracleDev)
	#	user="adm1"
		MACHINE_SFTP="linuxDev" ;;
	oraclePrd)
        #       user="adm1"
                MACHINE_SFTP="linuxPrd" ;;
	*)
		echo "Impossible de determiner la machine distante"
		exit 1
esac

#Check de renseignement de la machine cliente
if [ "x$MACHINE_SFTP" = "x" ] 
then
	echo "$(date '+%d-%m-%Y %H:%M:%S') > ERROR : la machine distant n a  pas ete renseigne. " | tee -a $LOG_FILE
	exit 1
fi

#Check de la disponibilite de la machine cliente
NBR_RETRY_EFFECTIF=1
code_retour=""

while [ $NBR_RETRY_EFFECTIF -le $FORCE_NBR_RETRY ] && [ "$code_retour" != "0" ]
do
	sftp -o Port=$PORT $USER@$MACHINE_SFTP << FIN > /dev/null 2>&1
quit
FIN
code_retour=$?

if [ $code_retour -ne 0 ]
then
	echo "Connexion SFTP KO - Nouvelle tentative de connexion apres un TIMER : $TIMER_RETRY secondes" | tee -a $LOG_FILE
	sleep $TIMER_RETRY
fi
NBR_RETRY_EFFECTIF=$((NBR_RETRY_EFFECTIF+1))
done

if [ $code_retour -ne 0 ]
then
	echo "ERROR : la machine distante est injoignable." | tee -a $LOG_FILE
	echo "$(date '+%d-%m-%Y %H:%M:%S') > ERROR : la machine distante est injoignable. " | tee -a $LOG_FILE
	exit 1
fi

#Test de presence de fichiers sur la machine distante
file_number=$(connexion_sftp $MACHINE_SFTP $USER | grep .csv | wc -l)

if [ $file_number == 0 ]
then
	echo "Le repertoire data de la machine cliente n existe pas ou ne contient aucun fichier csv" | tee -a $LOG_FILE
	exit 0
fi

#Recuperation des fichiers depuis la machine cliente
connexion_sftp $MACHINE_SFTP $USER
getfiles $MACHINE_SFTP $USER

#Configurartion serveur SMTP
MESSAGE_MAIL=".HEAD_Message"
FIN_MESSAGE_MAIL=".FIN_Message"
email="bvs@gmail.com"

#echo "Message mail" | mail -s "Test envoi mail" bvs@gmail.com
echo $MESSAGE_MAIL | mail -s $FIN_MESSAGE_MAIL $email

if [ $? == 0 ]
then
	echo "Mail envoyé a $email"
else
	echo "Erreur lors d'envie de mail"
fi

