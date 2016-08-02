# Scalable & Secure WordPress
When is the last time you leveraged a CDN?

- Nginx
- PHP-FPM
- Static Files mount uses a cloud CDN.
- Mount an external volume and map it to the container for persistence.
- Wordpress install is on a separate, persistent, storage device.
- Send emails using SSMTP & Free Email Service [mailgun.com](https://mailgun.com)

## Customizable content root
Most docker images will overwrite or remove all content (such as wordpress images) when
the image is booted up. This will remove any files if you mount your own volume.

This image provides the webserver, php-fpm and a default configuration that loads 
site content from a volume mounted which you specify at run time. You can change
your "content" directory (the volume mounted) without having to rebuild the docker
image.

This is known as "persistent storage" when using load-balanced or immutable containers.

## Building the Docker Image

```dockerfile
git clone https://github.com/mateothegreat/docker-centos-nginx-wordpress-cdn.git
cd docker-centos-nginx-wordpress-cdn
docker build --force-rm -t docker-centos-nginx-wordpress-cdn .
```

## Running in a container

Change "<yourpath>" to the root of the directory you want to mount. This becomes the "document root"
that nginx will serve your content.

To see how this is mapped in the nginx configuration file see [conf/nginx/default.conf](conf/nginx/default.conf)

```dockerfile
docker run -d --name test -p 8082:80 -v <yourpath>:/var/www/wordpress docker-centos-nginx-wordpress-cdn
```

### Configuration specific to Email
 
```dockerfile
RUN rpm -ivh https://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm 
RUN yum -y install ssmtp && yum clean all ADD ssmtp.conf /etc/ssmtp.conf  # apache needs to be in mail group so fpm can send emails 
RUN usermod -G mail apache  # fpm needs to be aware that we are using ssmtp 
RUN sed -i '/^sendmail_path = /csendmail_path = /usr/sbin/ssmtp -t' /opt/rh/php54/root/etc/php.ini 
```
