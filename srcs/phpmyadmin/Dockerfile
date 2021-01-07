FROM	alpine

RUN		apk update

RUN		apk add --no-cache openssl nginx procps php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session phpmyadmin bash

COPY	. .
RUN     rm -rf Dockerfile

RUN		cat nginx.conf > /etc/nginx/nginx.conf
RUN		cat nginx.crt  > /etc/nginx/nginx.crt
RUN		cat nginx.key  > /etc/nginx/nginx.key
COPY	config.inc.php /etc/phpmyadmin/config.inc.php
RUN		cat www.conf > /etc/php7/php-fpm.d/www.conf 

RUN		chmod 777 ./start.sh
RUN		chmod 777 -R /usr/share/webapps/phpmyadmin
RUN		chmod -R 777 /var/log/nginx

RUN		mkdir -p /var/www
RUN		mkdir -p /run/nginx
RUN		mkdir -p /run/php
RUN		mkdir -p /run/phpmyadmin
RUN		mkdir -p /var/run/

RUN		mv /usr/share/webapps/phpmyadmin/* /var/www/.

RUN		echo "PMA INDEX PAGE" > /var/www/index.html

EXPOSE	5000

CMD		["./start.sh"]
