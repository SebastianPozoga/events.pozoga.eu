#!/bin/sh
set -e

sh ./wait-for-db.sh $DB_HOST $DB_PORT

# Prepare wordpress
wp config create --dbhost="$DB_HOST:$DB_PORT" --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --locale=ro_RO
if $(wp core is-installed); then
  wp user update $WP_EMAIL --user_pass=$WP_PASS
fi
if ! $(wp core is-installed); then
  wp core install --url=$WP_HOST --title="$WP_TITLE" --admin_user=$WP_USER --admin_password=$WP_PASS --admin_email=$WP_EMAIL
fi

# active plugins
wp plugin activate jetpack wp-super-cache akismet

# run php server
wp server --host=0.0.0.0 --port=8080 --docroot=/app
