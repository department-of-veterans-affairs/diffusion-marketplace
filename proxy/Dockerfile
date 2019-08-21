FROM agilesix/centos:7.6

MAINTAINER Agile Six Applications, Inc. <contact@agile6.com>

ENV nginxversion="1.17.3-1" \
    os="centos" \
    osversion="7" \
    elversion="7"

RUN yum install -y wget openssl sed &&\
    yum -y autoremove &&\
    yum clean all &&\
    wget http://nginx.org/packages/mainline/centos/7/x86_64/RPMS/nginx-1.17.3-1.el7.ngx.x86_64.rpm &&\
    rpm -iv nginx-$nginxversion.el$elversion.ngx.x86_64.rpm

COPY proxy/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

STOPSIGNAL SIGTERM
RUN nginx -V
CMD ["nginx","-g","daemon off;"]