#FROM nginx:1.9.2
FROM ubuntu:14.04
MAINTAINER Nick Lian w19900227@gmail.com

ENV PHPMYADMIN_VERSION 4.5.3.1
ENV PHPMYADMIN_LANG all-languages
ENV MAX_UPLOAD "50M"

RUN apt-get update  
RUN apt-get install -y php5 php5-mysql php5-fpm \
	    wget \ 
	    nginx

WORKDIR /home

RUN wget https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-${PHPMYADMIN_LANG}.tar.gz
RUN tar zxvf phpMyAdmin-${PHPMYADMIN_VERSION}-${PHPMYADMIN_LANG}.tar.gz
RUN  rm phpMyAdmin-${PHPMYADMIN_VERSION}-${PHPMYADMIN_LANG}.tar.gz
RUN  mv phpMyAdmin-${PHPMYADMIN_VERSION}-${PHPMYADMIN_LANG} phpmyadmin

#COPY files/default /etc/nginx/sites-enabled/
COPY files/phpmyadmin /etc/nginx/sites-enabled/
#COPY files/phpmyadmin-run /home/
COPY files/phpmyadmin-run /usr/local/bin/

#RUN chmod +x phpmyadmin-run
RUN chmod +x /usr/local/bin/phpmyadmin-run

RUN sed -i "s/http {/http {\n        client_max_body_size $MAX_UPLOAD;/" /etc/nginx/nginx.conf
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = $MAX_UPLOAD/" /etc/php5/fpm/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = $MAX_UPLOAD/" /etc/php5/fpm/php.ini

EXPOSE 8080 80

CMD phpmyadmin-run

