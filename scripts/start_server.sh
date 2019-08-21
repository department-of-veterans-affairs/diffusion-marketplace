#!/usr/bin/env bash
# sleep 999999   # if you need to debug the container before starting server uncomment this line

if [ "$CONTAINER_ROLE" == "bg_worker" ]
then
  bundle exec sidekiq
elif [ "$CONTAINER_ROLE" == "app_server" ]
then
  echo "web start: bundle exec rails db:migrate && bundle exec puma -C config/puma.rb"
  cp -R /app/public /var/www/
  bundle exec rails db:migrate && bundle exec puma -C config/puma.rb
else
  echo "Error: unknown CONTAINER_ROLE"
  exit 125
fi