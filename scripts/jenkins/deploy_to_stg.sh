ssh ec2-user@$STG_SERVER "cd ~/diffusion-marketplace; sudo docker login -u AWS -p $(sudo aws ecr get-login-password --region us-gov-west-1) 124858472090.dkr.ecr.us-gov-west-1.amazonaws.com; sudo docker pull 124858472090.dkr.ecr.us-gov-west-1.amazonaws.com/diffusion-marketplace:ruby-2.7.5; git checkout master; git pull origin master; git reset --hard origin/master; git rev-parse --verify HEAD | tee REVISION; sudo docker-compose build; ./scripts/start_appcontainer.sh; sudo docker system prune -f;"