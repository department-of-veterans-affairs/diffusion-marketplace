FROM agilesix/centos:7.6

MAINTAINER Agile Six Applications, Inc. <contact@agile6.com>

ENV nginxversion="1.17.3-1" \
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
# copy over static assets
COPY public public/
# Copy Nginx config template
#COPY proxy/nginx.conf /tmp/docker.nginx
COPY proxy/nginx.conf /etc/nginx/nginx.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

STOPSIGNAL SIGTERM
RUN nginx -V
CMD ["nginx","-g","daemon off;"]