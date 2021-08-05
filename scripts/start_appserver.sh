#!/usr/bin/env bash

# this will start all docker-compose services in the background, including nginx.
# however, diffusion-marketplace will be sleeping infinitely (see docker-compose.yml),
# waiting for the next commands
echo "start services; diffusion-marketplace will sleep: docker-compose up -d"
sudo docker-compose up -d

# change the owner of the log directory within the container to the app user, nginx
echo "change the owner of the log directory within the container to the app user, nginx"
sudo docker exec -u 0:0 diffusion-marketplace_app_1 chown nginx:nginx -R /home/nginx/app/log

# change the owner of the app directory within the container to the web server user, nginx
# this is from another volume, which docker makes "root" the owner
echo "change the owner of the app directory within the container to the web server user, nginx"
sudo docker exec -u 0:0 diffusion-marketplace_app_1 chown nginx:nginx -R /home/nginx/www

# copy over the newly created assets
echo "copy over the newly created assets"
sudo docker exec diffusion-marketplace_app_1 cp -R /home/nginx/app/public /home/nginx/www

# run things as normal to start the app server:
# run the migrations
echo "run the migrations"
sudo docker-compose exec app bundle exec rails db:migrate

# run the app server, puma
echo "run the app server, puma"
sudo docker-compose exec -d app bundle exec puma -C config/puma.rb
