FROM	alpine

COPY	telegraf.conf .

RUN		wget \
		https://dl.influxdata.com/telegraf/releases/telegraf-1.14.0-static_linux_amd64.tar.gz 

RUN		tar -C . -xvf telegraf-1.14.0-static_linux_amd64.tar.gz \
		&& chmod +x telegraf/* && cp telegraf/telegraf /usr/bin/ 

RUN		mkdir /etc/telegraf		

EXPOSE	8125

CMD		["/usr/bin/telegraf", "--config", "telegraf.conf"]
