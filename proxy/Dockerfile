FROM agilesix/centos:7.6

MAINTAINER Agile Six Applications, Inc. <contact@agile6.com>

ENV nginxversion="1.21.1-1" \
    elversion="7"

RUN yum install -y yum-plugin-ovl

RUN yum install -y wget openssl sed gettext &&\
    yum -y autoremove &&\
    yum clean all &&\
    wget http://nginx.org/packages/mainline/centos/7/x86_64/RPMS/nginx-$nginxversion.el$elversion.ngx.x86_64.rpm &&\
    rpm -iv nginx-$nginxversion.el$elversion.ngx.x86_64.rpm

# establish where Nginx should look for files
ENV RAILS_ROOT /home/nginx/app
ENV PROXY_ROOT /home/nginx/www
RUN mkdir -p $RAILS_ROOT && \
    mkdir -p $PROXY_ROOT && \
    mkdir -p $PROXY_ROOT/log

RUN chmod g+rwx $RAILS_ROOT && chmod g+rwx $PROXY_ROOT

RUN mkdir /home/nginx/log && \
    touch /home/nginx/log/error.log && \
    touch /home/nginx/log/access.log && \
    chown -R nginx:nginx /home/nginx

# Set our working directory inside the image
WORKDIR $PROXY_ROOT

## copy over static assets
COPY --chown=nginx public $PROXY_ROOT/public/

# Copy Nginx config template
#COPY proxy/nginx.conf /tmp/docker.nginx
COPY proxy/nginx.conf /etc/nginx/nginx.conf

#RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
#    ln -sf /dev/stderr /var/log/nginx/error.log

RUN chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    chown -R nginx:nginx /etc/nginx/nginx.conf

RUN touch /var/run/web-nginx.pid && \
        chown -R nginx:nginx /var/run/web-nginx.pid && \
        touch /var/log/nginx/web-nginx-error.log && \
        chown nginx:nginx /var/log/nginx/web-nginx-error.log

EXPOSE 8080

USER nginx
STOPSIGNAL SIGTERM
RUN nginx -V
CMD ["nginx", "-e", "/home/nginx/log/error.log", "-g","daemon off;"]