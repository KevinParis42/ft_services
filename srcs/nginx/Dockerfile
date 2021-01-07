FROM	alpine

RUN		apk update

RUN		apk add --no-cache nginx openssl bash

COPY	nginx.conf .
COPY    nginx.crt .
COPY    nginx.key .
COPY    start.sh .

RUN		cat nginx.conf > /etc/nginx/nginx.conf
RUN		cat nginx.crt  > /etc/nginx/nginx.crt
RUN		cat nginx.key  > /etc/nginx/nginx.key

RUN		chmod 777 ./start.sh
RUN		mkdir -p /run/nginx
RUN		echo "NGINX INDEX PAGE" > /var/www/index.html

RUN		chmod -R 777 /var/log/nginx

EXPOSE	80 443

CMD		["./start.sh"]