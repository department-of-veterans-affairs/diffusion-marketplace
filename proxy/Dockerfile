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
ENV PROXY_ROOT /var/www
# Set our working directory inside the image
WORKDIR $PROXY_ROOT
# create log directory
RUN mkdir log

RUN mkdir /home/nginx && \
    mkdir /home/nginx/log && \
    touch /home/nginx/log/error.log && \
    touch /home/nginx/log/access.log && \
    chown -R nginx:nginx /home/nginx

# copy over static assets
COPY public public/
# Copy Nginx config template
#COPY proxy/nginx.conf /tmp/docker.nginx
COPY proxy/nginx.conf /etc/nginx/nginx.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

RUN chown -R nginx:nginx /var/www && chmod -R 755 /var/www && \
        chown -R nginx:nginx /var/cache/nginx && \
        chown -R nginx:nginx /var/log/nginx && \
        chown -R nginx:nginx /etc/nginx/conf.d
RUN touch /var/run/web-nginx.pid && \
        chown -R nginx:nginx /var/run/web-nginx.pid && \
        touch /var/log/nginx/web-nginx-error.log && \
        chown nginx:nginx /var/log/nginx/web-nginx-error.log

RUN ls -la /var/log/nginx

EXPOSE 8080

USER nginx
STOPSIGNAL SIGTERM
RUN nginx -V
CMD ["nginx", "-e", "/home/nginx/log/error.log", "-g","daemon off;"]