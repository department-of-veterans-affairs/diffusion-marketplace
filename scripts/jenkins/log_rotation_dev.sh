echo "Upload dm-dev logs"
ssh ec2-user@$DEV_SERVER "sudo docker exec diffusion-marketplace_app_1 ruby scripts/log-rotation.rb"