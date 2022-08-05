echo "Upload dm-stg logs"
ssh ec2-user@$STG_SERVER "sudo docker exec diffusion-marketplace_app_1 ruby scripts/log-rotation.rb"