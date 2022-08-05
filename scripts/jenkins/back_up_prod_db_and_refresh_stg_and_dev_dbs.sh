AWS_REGION=us-gov-west-1

echo "Install postgresql 12 server in containers to match postgres instance"

# Need to install this in order to have llvm-toolset-7-clang for postgresql12
ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 yum install -y centos-release-scl-rh"
ssh ec2-user@$STG_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 yum install -y centos-release-scl-rh"
ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 yum install -y centos-release-scl-rh"
ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm -y; sudo docker exec -u 0:0 diffusion-marketplace_app_1 yum install postgresql12-server postgresql12-contrib postgresql12-devel -y"
ssh ec2-user@$STG_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm -y; sudo docker exec -u 0:0 diffusion-marketplace_app_1 yum install postgresql12-server postgresql12-contrib postgresql12-devel -y"
ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm -y; sudo docker exec -u 0:0 diffusion-marketplace_app_1 yum install postgresql12-server postgresql12-contrib postgresql12-devel -y"

# Set the file name
DB_FILENAME="vadm_"$(date +"%Y-%m-%d-%H%M-%Z")
DB_BACKUP_S3_BUCKET_NAME="vadm-db-backups"

PROD_POSTGRES_USER=$(ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_USER")
PROD_POSTGRES_PASSWORD=$(ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_PASSWORD")
PROD_POSTGRES_DB=$(ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_DB")
PROD_POSTGRES_HOST=$(ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_HOST")

DEV_POSTGRES_USER=$(ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_USER")

DEV_POSTGRES_PASSWORD=$(ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_PASSWORD")
DEV_POSTGRES_DB=$(ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_DB")
DEV_POSTGRES_HOST=$(ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_HOST")

STG_POSTGRES_USER=$(ssh ec2-user@$STG_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_USER")
STG_POSTGRES_PASSWORD=$(ssh ec2-user@$STG_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_PASSWORD")
STG_POSTGRES_DB=$(ssh ec2-user@$STG_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_DB")
STG_POSTGRES_HOST=$(ssh ec2-user@$STG_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_HOST")

echo "Back up PROD DB: ${DB_FILENAME}"
ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 bash -c \"PGPASSWORD=${PROD_POSTGRES_PASSWORD} /usr/pgsql-12/bin/pg_dump -O -U ${PROD_POSTGRES_USER} -h ${PROD_POSTGRES_HOST} ${PROD_POSTGRES_DB} | gzip -c > ${DB_FILENAME}.sql.gz\""

echo "Upload PROD DB backup file to AWS S3 bucket"
ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 rails runner \"s3 = Aws::S3::Resource.new(region: '${AWS_REGION}'); obj = s3.bucket('${DB_BACKUP_S3_BUCKET_NAME}').object('${DB_FILENAME}.sql.gz'); obj.upload_file(%Q(#{Rails.root}/${DB_FILENAME}.sql.gz));\""

#----- concludes PROD DB Backup

#----- starts the database restore on staging and dev servers

echo "Download DB backup file to server container (STG/DEV)"
ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 rails runner \"s3 = Aws::S3::Client.new(region: '${AWS_REGION}'); s3.get_object({ bucket: '${DB_BACKUP_S3_BUCKET_NAME}', key: '${DB_FILENAME}.sql.gz'}, target: %Q(#{Rails.root}/${DB_FILENAME}.sql.gz))\""
ssh ec2-user@$STG_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 rails runner \"s3 = Aws::S3::Client.new(region: '${AWS_REGION}'); s3.get_object({ bucket: '${DB_BACKUP_S3_BUCKET_NAME}', key: '${DB_FILENAME}.sql.gz'}, target: %Q(#{Rails.root}/${DB_FILENAME}.sql.gz))\""

echo "Unzip DB backup file (STG/DEV)"
# the -d flag deletes the .gz file
ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 gzip -d ${DB_FILENAME}.sql.gz"
ssh ec2-user@$STG_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 gzip -d ${DB_FILENAME}.sql.gz"

echo "DROP STAGING/DEV DB"

# Stop the connections to the DBs so that the DBs can be dropped

# TODO: if the tasks fails, it'll probably be here: either there is a syntax error in the sql command (right below) or there are db connections and we can't drop the DB

# Ways to fix:

# 1. tell whoever is browsing to close the site

# 2. try to restart the app

# 3. EXTREME: go into aws rds and restart db instance

#ssh ec2-user@${DEV_SERVER} `sudo docker exec -u 0:0 diffusion-marketplace_app_1 bash -c "PGPASSWORD=${DEV_POSTGRES_PASSWORD} /usr/pgsql-9.6/bin/psql -U ${DEV_POSTGRES_USER} -h ${DEV_POSTGRES_HOST} -c \"SELECT pg_terminate_backend\(pg_stat_activity.pid\) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${DEV_POSTGRES_DB}' AND pid <> pg_backend_pid\(\);\" -d ${DEV_POSTGRES_DB}"`\"SELECT pg_terminate_backend\(pg_stat_activity.pid\) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${STG_POSTGRES_DB}' AND pid <> pg_backend_pid\(\);\" -d ${STG_POSTGRES_DB}"`

echo "Reboot STAGING/DEV RDS DB"
ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 rails runner \"client = Aws::RDS::Client.new(region: '${AWS_REGION}'); client.reboot_db_instance({db_instance_identifier: 'vaecdiffusionmarketplacedevenc'})\""
ssh ec2-user@$STG_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 rails runner \"client = Aws::RDS::Client.new(region: '${AWS_REGION}'); client.reboot_db_instance({db_instance_identifier: 'diffusionmarketplacestaging'})\""

# Add sleep here so that the DB has time to reboot, but hopefully not too much time as to allow for connections to be formed
sleep 15
# Now we can drop the DB
# ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 bash -c \"PGPASSWORD=${DEV_POSTGRES_PASSWORD} /usr/pgsql-12/bin/dropdb -U ${DEV_POSTGRES_USER} -h ${DEV_POSTGRES_HOST} ${DEV_POSTGRES_DB}\""
ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 bash -c \"PGPASSWORD=${DEV_POSTGRES_PASSWORD} /usr/pgsql-12/bin/dropdb -U ${DEV_POSTGRES_USER} -h ${DEV_POSTGRES_HOST} ${DEV_POSTGRES_DB}\""
ssh ec2-user@$STG_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 bash -c \"PGPASSWORD=${STG_POSTGRES_PASSWORD} /usr/pgsql-12/bin/dropdb -U ${STG_POSTGRES_USER} -h ${STG_POSTGRES_HOST} ${STG_POSTGRES_DB}\""

echo "CREATE STAGING/DEV DB"
# ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 bash -c \"PGPASSWORD=${DEV_POSTGRES_PASSWORD} /usr/pgsql-12/bin/createdb -U ${DEV_POSTGRES_USER} -h ${DEV_POSTGRES_HOST} ${DEV_POSTGRES_DB}\""
ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 bash -c \"PGPASSWORD=${DEV_POSTGRES_PASSWORD} /usr/pgsql-12/bin/createdb -U ${DEV_POSTGRES_USER} -h ${DEV_POSTGRES_HOST} ${DEV_POSTGRES_DB}\""
ssh ec2-user@$STG_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 bash -c \"PGPASSWORD=${STG_POSTGRES_PASSWORD} /usr/pgsql-12/bin/createdb -U ${STG_POSTGRES_USER} -h ${STG_POSTGRES_HOST} ${STG_POSTGRES_DB}\""

echo "RESTORE STAGING/DEV DB"
# ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 bash -c \"PGPASSWORD=${DEV_POSTGRES_PASSWORD} /usr/pgsql-12/bin/psql -U ${DEV_POSTGRES_USER} -h ${DEV_POSTGRES_HOST} ${DEV_POSTGRES_DB} < ${DB_FILENAME}.sql\""
ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 bash -c \"PGPASSWORD=${DEV_POSTGRES_PASSWORD} /usr/pgsql-12/bin/psql -U ${DEV_POSTGRES_USER} -h ${DEV_POSTGRES_HOST} ${DEV_POSTGRES_DB} < ${DB_FILENAME}.sql\""
ssh ec2-user@$STG_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 bash -c \"PGPASSWORD=${STG_POSTGRES_PASSWORD} /usr/pgsql-12/bin/psql -U ${STG_POSTGRES_USER} -h ${STG_POSTGRES_HOST} ${STG_POSTGRES_DB} < ${DB_FILENAME}.sql\""

# TODO: might not need this because of container restart
echo "Delete DB backup file from server containers"
ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 rm -rf ${DB_FILENAME}.sql"
ssh ec2-user@$STG_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 rm -rf ${DB_FILENAME}.sql"

echo "Clear Rails Cache on STAGING/DEV"
ssh ec2-user@$DEV_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 rails runner \"Rails.cache.clear\""
ssh ec2-user@$STG_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 rails runner \"Rails.cache.clear\""

echo "Sync PRODUCTION AWS S3 bucket down to STAGING/DEV AWS S3 buckets"

# aws s3 sync s3://prod-dm s3://dev-dm --delete
sudo /usr/local/bin/aws s3 sync s3://prod-dm s3://dev-dm --delete
aws s3 sync s3://prod-dm s3://stg-dm --delete

echo "Restart STAGING/DEV Servers"
REFRESHED_DB_WITH="Refreshed DB with ${DB_FILENAME} at $(date +"%Y-%m-%d-%H%M-%Z")"
ssh ec2-user@$DEV_SERVER "cd ~/diffusion-marketplace; git rev-parse --verify HEAD | tee REVISION; echo ${REFRESHED_DB_WITH} | tee REFRESHED_DB_WITH; sudo docker-compose build app; sudo docker-compose down; ./scripts/start_appcontainer.sh; sudo docker system prune -f;"
ssh ec2-user@$STG_SERVER "cd ~/diffusion-marketplace; git rev-parse --verify HEAD | tee REVISION; echo ${REFRESHED_DB_WITH} | tee REFRESHED_DB_WITH; sudo docker-compose build app; sudo docker-compose down; ./scripts/start_appcontainer.sh; sudo docker system prune -f;"