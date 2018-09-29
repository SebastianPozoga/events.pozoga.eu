#!/bin/sh
set -e

# wait for database container
sh /entrypoint/wait-for-db.sh $DB_HOST $DB_PORT

# prepare database & wordpress app
sudo -E -u www-data -- sh -x /entrypoint/prepare-www.sh

if [ $MODE = "SSL" ]; then
  # init ssl apache2 config
  sh -x /entrypoint/ssl-apache-config.sh
else
  # init no-ssl apache2 config
  sh -x /entrypoint/nossl-apache-config.sh
fi

# run php server
# httpd -D FOREGROUND
#-f /etc/apache2/httpd.conf
/usr/sbin/httpd -DFOREGROUND -f /etc/apache2/httpd.conf -e debug
