# Scalable & Secure WordPress
When is the last time you leveraged a CDN?

---

- Nginx
- PHP-FPM
- Static Files mount uses a cloud CDN.
- Mount an external volume and map it to the container for persistence.
- Wordpress install is on a separate, persistent, storage device.
- Send emails using SSMTP & Free Email Service [mailgun.com](https://mailgun.com)

## Building the Docker Image

```dockerfile
docker build --force-rm -t docker-centos-nginx-wordpress-cdn .
docker run -d --name test -p 8082:80 -v /home/lenixx/workspace/volume-wordpress:/var/www/wordpress docker-centos-nginx-wordpress-cdn
```

### Configuration specific to Email
 
```dockerfile
RUN rpm -ivh https://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm 
RUN yum -y install ssmtp && yum clean all ADD ssmtp.conf /etc/ssmtp.conf  # apache needs to be in mail group so fpm can send emails 
RUN usermod -G mail apache  # fpm needs to be aware that we are using ssmtp 
RUN sed -i '/^sendmail_path = /csendmail_path = /usr/sbin/ssmtp -t' /opt/rh/php54/root/etc/php.ini 
```
