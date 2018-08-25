#!/bin/sh
set -e

# wait for database container
sh /entrypoint/wait-for-db.sh $DB_HOST $DB_PORT

# prepare database & wordpress app
sudo -u www-data -- sh -x /entrypoint/prepare-www.sh

# run php server
# httpd -D FOREGROUND
#-f /etc/apache2/httpd.conf
/usr/sbin/httpd -DFOREGROUND -f /etc/apache2/httpd.conf -e debug
