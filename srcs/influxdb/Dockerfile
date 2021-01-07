FROM	alpine

RUN		apk update

RUN		apk add --no-cache influxdb 

EXPOSE	8086

CMD		["influxd", "run"]