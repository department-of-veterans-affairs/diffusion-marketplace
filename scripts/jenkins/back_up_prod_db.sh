echo "Install postgresql 12 server in container to match postgres instance"
ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 apt-get update && sudo docker exec -u 0:0 diffusion-marketplace_app_1 apt-get install -y gnupg"
ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -"
ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 echo 'deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main' | sudo tee /etc/apt/sources.list.d/pgdg.list"
ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 apt-get update && apt-get install -y postgresql-12 postgresql-client-12 postgresql-contrib-12"

# Set the file name
DB_FILENAME="vadm_"$(date +"%Y-%m-%d")
DB_BACKUP_S3_BUCKET_NAME="vadm-db-backups"

PROD_POSTGRES_USER=$(ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_USER")
PROD_POSTGRES_PASSWORD=$(ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_PASSWORD")
PROD_POSTGRES_DB=$(ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_DB")
PROD_POSTGRES_HOST=$(ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 printenv POSTGRES_HOST")

echo "Back up PROD DB: ${DB_FILENAME}"
ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 echo POSTGRES_USER: ${PROD_POSTGRES_USER}"
ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 bash -c \"PGPASSWORD=${PROD_POSTGRES_PASSWORD} pg_dump -O -U ${PROD_POSTGRES_USER} -h ${PROD_POSTGRES_HOST} ${PROD_POSTGRES_DB} | gzip -c > ${DB_FILENAME}.sql.gz\""

echo "Upload PROD DB backup file to AWS S3 bucket"
ssh ec2-user@$PROD_SERVER "sudo docker exec -u 0:0 diffusion-marketplace_app_1 rails runner \"s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION']); obj = s3.bucket('${DB_BACKUP_S3_BUCKET_NAME}').object('${DB_FILENAME}.sql.gz'); obj.upload_file(%Q(#{Rails.root}/${DB_FILENAME}.sql.gz));\""

echo "Restart the container"
ssh ec2-user@$PROD_SERVER "cd ~/diffusion-marketplace; sudo docker-compose down; ./scripts/start_appcontainer.sh"