#!/bin/bash

#Declaration de variables
FILE="scanfs"
LOG_LOCATION="../log"
DATE=`date '+%Y%m%d_%H%M%S'`
LOG_FILE=${LOG_LOCATION}/${FILE}_${DATE}".log"

#Date execution
echo "Date exécution > $DATE" | tee -a $LOG_FILE

#Liste des FS sans entete
df -h | sed '1 d' > dfhfile.txt

#Initialiser un compteur
flag=0

#Debut du traitement
for diskuse in $(cat dfhfile.txt | awk '{print $5}'| sed "s/%//g")
do
	let "flag=$flag+1"
	disk=$(cat dfhfile.txt | awk '{print $6}' | head -n $flag | tail -n 1)
	if [ "$disk" == "/home" ] || [ "$disk" == "/var" ]
	then
		if [ "$diskuse" -ge "90" ] && [ "$disk" == "/home" ]
		then
			echo "$disk > 90" >> dsklistfile.txt
		else
		#	if [ "$diskuse" -ge "80" ] && [ "$disk" == "/var" ]
			if [ "$diskuse" -ge "10" ] && [ "$disk" == "/var" ]
			then
				echo "$disk > 10" >> dsklistfile.txt
			fi
		fi
	fi
done

#Verification des FS a traiter

if [ -f dsklistfile.txt ]
then
	echo "Liste de FS a traiter `cat dsklistfile.txt`" | tee -a $LOG_FILE
else
	echo "Pas de FS a traiter" | tee -a $LOG_FILE
fi

#Purge de liste FS

if [ -f dfhfile.txt ]
then
	rm -rf dfhfile.txt
fi

#Purge de la liste de FS a traiter

if [ -f dsklistfile.txt ]
then
        rm -rf dsklistfile.txt
fi

