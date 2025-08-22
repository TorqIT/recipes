#!/usr/bin/env bash

echo Configuring Composer...
runuser -u www-data -- mkdir -p /var/www/.config/composer && mkdir -p /var/www/.cache/composer
chown -R /var/www

echo Installing Composer packages...
cd /var/www/html && runuser -u www-data -- php -d memory_limit=-1 -d xdebug.remote_enable=0 /usr/local/bin/composer install --prefer-dist --no-scripts