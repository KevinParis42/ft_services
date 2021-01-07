FROM	alpine

RUN		apk update --no-cache

RUN     apk upgrade --no-cache

RUN		apk add --no-cache curl

RUN     apk add grafana --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/

COPY	dashboards/ /usr/share/grafana/dashboards

WORKDIR	/usr/share/grafana/conf

COPY	dashboards.yaml ./provisioning/dashboards/dashboards.yaml
COPY	influxdb.yaml ./provisioning/datasources/influxdb.yaml

ENV		GF_SECURITY_ADMIN_USER=admin
ENV		GF_SECURITY_ADMIN_PASSWORD=admin

EXPOSE	3000

CMD		["grafana-server"]
