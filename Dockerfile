FROM agilesix/ruby:2.6.3-centos7.6

ARG S3_BUCKET_NAME
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_REGION

RUN git config --global http.sslVerify false

RUN gem install bundler --force

ENV RAILS_ROOT /app
RUN mkdir -p $RAILS_ROOT
# Set working directory
WORKDIR $RAILS_ROOT
# Setting env up
ENV RAILS_ENV='production'
ENV RACK_ENV='production'
# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs 20 --retry 5 --without development test
COPY . .

RUN rm -rf config/credentials.yml.enc
RUN rm -rf config/master.key
RUN EDITOR="vim --wait" bundle exec rails credentials:edit > /dev/null 2>&1

RUN DB_ADAPTER=nulldb RAILS_ENV=production SES_SMTP_USERNAME=diffusion_marketplace SES_SMTP_PASSWORD=diffusion_marketplace bundle exec rails assets:precompile HOSTNAME=diffusion-marketplace.va.gov
EXPOSE 3000
CMD bash scripts/start_server.sh