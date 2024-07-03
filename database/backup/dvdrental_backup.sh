#!/bin/bash
 # Backup quotidien
# su -c "pg_dump -F c -v -f "/backup/database/postgresql/backup_data_$(date +"%Y%m%d_%H%M%S").dump" dvdrental" postgres
 pg_dump -F c -v -f "/backup/database/postgresql/backup_data_$(date +"%Y%m%d_%H%M%S").dump" dvdrental
 # Suppression des backups de plus de 10 jours
 #su -c "find /backup/database/postgresql/ -type f -mtime +10 -delete" postgres
 find /backup/database/postgresql/ -type f -mtime +10 -delete

