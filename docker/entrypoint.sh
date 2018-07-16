#!/bin/sh


composer install --ignore-platform-reqs

chmod 777 -R var/

/usr/bin/supervisord