#!/bin/bash
set -e

# Prepare wordpress
wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --locale=ro_RO
if $(wp core is-installed); then
  wp user update $WP_EMAIL --user_pass=$WP_PASS
fi
if ! $(wp core is-installed); then
  wp core install --url=events.pozoga.eu --title="Poznań Events" --admin_user=$WP_USER --admin_password=$WP_PASS --admin_email=$WP_EMAIL
fi

# active plugins
wp plugin activate jetpack wp-super-cache akismet

# run base entrypoint
sh -x "/usr/local/bin/docker-entrypoint.sh"
