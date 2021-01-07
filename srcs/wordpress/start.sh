#!/bin/bash

php-fpm7

chmod 777 /var/run/php/sock

/usr/sbin/nginx -g "daemon off;"