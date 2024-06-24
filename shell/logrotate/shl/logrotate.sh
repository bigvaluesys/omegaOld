#!/bin/bash

###########################################################
# Script: Rotation de logs
###########################################################

#*** CONFIG ***


#Chargement de la configuration

source initLogrotate.sh

#Traitement en utilisant le fichier de configuration fourni

# Demarrage de traitement

echo "$(date '+%d-%m-%Y %H:%M:%S') > logrotate [INFO] : ######### Demarrage de traitement ###########" | tee -a $FIC_LOG

while read ligne
do
# on saute les lignes vides ou commentées
 	echo "$ligne" | grep -E "^$" > /dev/null && continue
    	echo "$ligne" | grep -E "^#" > /dev/null && continue
# Pour chaque consigne on parse afin d'obtenir les infos sur les champs
REP=$(echo "$ligne" | cut -d";" -f1)
FIC_PATTERN=$(echo "$ligne" | cut -d";" -f2)
RETENTION=$(echo "$ligne" | cut -d";" -f3)
PROFONDEUR=$(echo "$ligne" | cut -d";" -f4)

#Vérification 4 eme parametre
if [ "x$PROFONDEUR" = "x" ]
then
	PROFONDEUR=1
fi

#Check de Repertoire
if test ! -d "$REP" -o -z "$REP"
then
	echo "[WARNING] $REP n'existe pas. Merci de corriger $FIC_PARAM" | tee -a $FIC_LOG
        continue
fi

# Affichage de la configuration pour la ligne de paramétrage

    # on purge
    # on peut tomber sur une erreur si la liste de fichier à supprimer est trop grande à cause du ls
    # dans ce cas, supprimer ceci de la commande find : -exec ls -1td "{}" +

    find $REP -name "$FIC_PATTERN" -mtime "+$RETENTION" -maxdepth "$PROFONDEUR" -exec ls -1td "{}" + | while read findLine
    do
	    #Obtenir la taille du fichier qu'on va supprimer
        taille=$(wc -c $findLine | awk '{print $1}')
        # On supprime le fichier
        #if  rm -f $findLine
        if  [ -f $findLine ]
        then   echo  "$findLine $taille SUPPRIME" >> $LIST_FIC;echo  "$findLine $taille SUPPRIME" | tee -a $FIC_LOG
        else   echo  "$findLine $taille ERROR" >> $LIST_FIC;echo  "$findLine $taille ERROR" | tee -a $FIC_LOG
        fi
done
done < $FIC_PARAM

echo "$(date '+%d-%m-%Y %H:%M:%S') > logrotate [INFO] : ######### Fin de traitement ###########" | tee -a $FIC_LOG
