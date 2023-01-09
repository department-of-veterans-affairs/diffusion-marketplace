# Note: Uncomment this to run docker locally
# FROM agilesix/ruby:2.7.5
# Note: Comment out the next line to run docker locally
FROM 124858472090.dkr.ecr.us-gov-west-1.amazonaws.com/diffusion-marketplace:ruby-2.7.5

RUN useradd -rm -d /home/nginx -s /bin/bash -g root -G wheel -u 1443 nginx
RUN groupadd -g 1443 nginx
RUN usermod -a -G nginx nginx

ARG S3_BUCKET_NAME
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_REGION

RUN git config --global http.sslVerify false


#COPY DeptOfVA_TreasuryChain.cer /etc/pki/ca-trust/source/anchors/DeptOfVA_TreasuryChain.cer
#COPY EntrustCASHA384.cer /etc/pki/ca-trust/source/anchors/EntrustCASHA384.cer
#COPY EntrustDerivedCredSSP.cer /etc/pki/ca-trust/source/anchors/EntrustDerivedCredSSP.cer
#COPY EntrustDerivedCredSSP.cer /etc/pki/ca-trust/source/anchors/EntrustDerivedCredSSP.cer
#COPY EntrustServicesRootCA_BridgeCert.cer /etc/pki/ca-trust/source/anchors/EntrustServicesRootCA_BridgeCert.cer
#COPY TreasuryCASHA384.cer /etc/pki/ca-trust/source/anchors/TreasuryCASHA384.cer

#COPY VA-Internal-S2-ICA1-v1.cer /etc/pki/ca-trust/source/anchors/VA-Internal-S2-ICA1-v1.cer
#COPY VA-Internal-S2-ICA2-v1.cer /etc/pki/ca-trust/source/anchors/VA-Internal-S2-ICA2-v1.cer
#COPY VA-Internal-S2-ICA3-v1.cer /etc/pki/ca-trust/source/anchors/VA-Internal-S2-ICA3-v1.cer
#COPY VA-Internal-S2-ICA4.cer /etc/pki/ca-trust/source/anchors/VA-Internal-S2-ICA4.cer
#COPY VA-Internal-S2-ICA5.cer /etc/pki/ca-trust/source/anchors/VA-Internal-S2-ICA5.cer
#COPY VA-Internal-S2-ICA6.cer /etc/pki/ca-trust/source/anchors/VA-Internal-S2-ICA6.cer
#COPY VA-Internal-S2-ICA7.cer /etc/pki/ca-trust/source/anchors/VA-Internal-S2-ICA7.cer
#COPY VA-Internal-S2-ICA8.cer /etc/pki/ca-trust/source/anchors/VA-Internal-S2-ICA8.cer
#COPY VA-Internal-S2-ICA9.cer /etc/pki/ca-trust/source/anchors/VA-Internal-S2-ICA9.cer

COPY VA-Internal-S2-RCA1-v1.cer /etc/pki/ca-trust/source/anchors/VA-Internal-S2-RCA1-v1.cer
COPY va-dc.crt /etc/pki/ca-trust/source/anchors/va-dc.crt

#COPY VerizonA2SHA384.cer /etc/pki/ca-trust/source/anchors/VerizonA2SHA384.cer
#COPY VeteransAffairsCAB3.cer /etc/pki/ca-trust/source/anchors/VeteransAffairsCAB3.cer
#COPY Veterans_Affairs_User_CA_B1.cer /etc/pki/ca-trust/source/anchors/Veterans_Affairs_User_CA_B1.cer

RUN update-ca-trust extract

RUN gem install bundler --force
RUN bundle config build.pg --with-pg-config=/usr/pgsql-12/bin/pg_config

ENV RAILS_ROOT /home/nginx/app
ENV PROXY_ROOT /home/nginx/www
RUN mkdir -p $RAILS_ROOT && \
    mkdir -p $PROXY_ROOT && \
    mkdir -p $PROXY_ROOT/log && \
    chown -R nginx:nginx /home/nginx

RUN chmod g+rwx $RAILS_ROOT && chmod g+rwx /home/nginx/www
# Set working directory
WORKDIR $RAILS_ROOT
# Setting env up
ENV RAILS_ENV='production'
ENV RACK_ENV='production'
# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle config set without 'development test'
RUN bundle install --retry 3 --jobs 20

USER nginx
COPY --chown=nginx . .

RUN rm -rf config/credentials.yml.enc
RUN rm -rf config/master.key
RUN EDITOR="vim --wait" bundle exec rails credentials:edit > /dev/null 2>&1

RUN DB_ADAPTER=nulldb RAILS_ENV=production SES_SMTP_USERNAME=diffusion_marketplace SES_SMTP_PASSWORD=diffusion_marketplace bundle exec rails assets:precompile HOSTNAME=diffusion-marketplace.va.gov
EXPOSE 3000

CMD bash scripts/start_server.sh
