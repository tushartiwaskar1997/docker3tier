TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="/mnt/mysql-data/backup-${TIMESTAMP}.sql"

/usr/bin/docker exec mysql /usr/bin/mysqldump -u root -proot users_db > $BACKUP_FILE

if [ $? -eq 0 ]; then
            /usr/bin/aws s3 cp $BACKUP_FILE s3://my-mysql-backup-prod/
                echo "🟢  Backup completed: $BACKUP_FILE"
        else
                    echo "❌  Backup failed"
fi
~