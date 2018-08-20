#!/bin/sh
set -e

sh ./wait-for-db.sh $DB_HOST $DB_PORT

# Prepare wordpress
if [ ! -f "/app/wp-config.php" ]; then
  wp config create --dbhost="$DB_HOST:$DB_PORT" --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --locale=ro_RO
fi


if $(wp core is-installed); then
  wp user update $WP_EMAIL --user_pass=$WP_PASS
fi

if ! $(wp core is-installed); then
  wp core install --url=$WP_HOST --title="$WP_TITLE" --admin_user=$WP_USER --admin_password=$WP_PASS --admin_email=$WP_EMAIL
fi

if [ ! -z "$MIGRATE_FROM" ]; then
  echo "Migrate database $MIGRATE_FROM to $MIGRATE_TO"
  wp search-replace $MIGRATE_FROM $MIGRATE_TO
  if $(wp --url=$MIGRATE_FROM core is-installed --network); then
    wp search-replace --url=$MIGRATE_FROM "$MIGRATE_FROM" "$MIGRATE_TO" --recurse-objects --network --skip-columns=guid --skip-tables=wp_users
  else
    wp search-replace "$MIGRATE_FROM" "$MIGRATE_TO" --recurse-objects --skip-columns=guid --skip-tables=wp_users
  fi
fi

# active plugins
wp plugin activate jetpack wp-super-cache akismet

# run php server
wp server --host=0.0.0.0 --port=8080 --docroot=/app