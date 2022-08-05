echo "Upload dm-prod logs"
ssh ec2-user@$PROD_SERVER "sudo docker exec diffusion-marketplace_app_1 ruby scripts/log-rotation.rb"