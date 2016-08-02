############################################################
# Dockerfile to build CentOS,Nginx installed  Container
# Based on CentOS
############################################################

# Set the base image to Ubuntu
FROM centos:latest

# File Author / Maintainer
MAINTAINER Matthew Davis <matthew@appsoa.io>

# Add the ngix and PHP dependent repository
ADD conf/yum/nginx.repo /etc/yum.repos.d/nginx.repo

# Installing nginx 
RUN yum -y install nginx wget

# Installing PHP
RUN yum -y --enablerepo=remi,remi-php56 install nginx php-fpm php-common php-mysql php-gd

# Installing supervisor
RUN yum install -y python-setuptools
RUN easy_install pip
RUN pip install supervisor


# Adding the configuration file of the nginx
ADD conf/nginx/nginx.conf /etc/nginx/nginx.conf
ADD conf/nginx/default.conf /etc/nginx/conf.d/default.conf
ADD conf/php-fpm/php-fpm.conf /etc/php-fpm.conf 
ADD conf/php-fpm/www.conf /etc/php-fpm.d/www.conf

# Adding the configuration file of the Supervisor
ADD conf/supervisord.conf /etc/

# Adding the default file
# ADD index.php /var/www/index.php

# Set the port to 80 
EXPOSE 80

# Executing supervisord
CMD ["supervisord", "-n"]
