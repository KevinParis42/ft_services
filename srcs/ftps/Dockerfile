FROM	alpine

RUN		apk update \
		&& apk add --no-cache vsftpd openssl bash

COPY	start.sh .

COPY	vsftpd.conf /etc/vsftpd.conf
RUN		mkdir /etc/certs
COPY	vsftpd.pem /vsftpd.pem

RUN		chmod 777 start.sh 
EXPOSE	20 21 20010 20011

CMD		["./start.sh"]
