FROM	alpine

RUN		apk update

RUN		apk add --no-cache bash nginx php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session

COPY	. .
RUN		rm -rf Dockerfile

RUN		cat nginx.conf > /etc/nginx/nginx.conf
COPY	www.conf /etc/php7/php-fpm.d/www.conf 

RUN		chmod -R 777 /var/log/nginx
RUN		chmod 777 start.sh

RUN		mkdir -p /var/www
RUN		mkdir -p /run/nginx
RUN		mkdir -p /run/php
RUN		mkdir -p /run/wordpress
RUN		mkdir -p /var/run

RUN		wget https://wordpress.org/latest.tar.gz \
			&& tar -xvf latest.tar.gz \
			&& rm -rf latest.tar.gz \
			&& chmod 777 -R /wordpress

RUN		cat wp-config.php > /wordpress/wp-config.php

RUN		mv /wordpress/* /var/www/.

RUN		echo "WP INDEX PAGE" > /var/www/index.html

EXPOSE	5050

CMD		["./start.sh"]