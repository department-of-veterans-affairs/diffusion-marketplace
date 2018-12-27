FROM ruby:2.5.3

RUN gem install bundler

# Preinstall gems. This will ensure that Gem Cache wont drop on code change
WORKDIR /tmp
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
RUN (bundle check || bundle install --without development test)

ARG S3_BUCKET_NAME
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_REGION

RUN mkdir /app
ADD . /app
WORKDIR /app
RUN (bundle check || bundle install --without development test)

RUN DB_ADAPTER=nulldb RAILS_ENV=production bundle exec rake assets:precompile

CMD bash scripts/start_server.sh