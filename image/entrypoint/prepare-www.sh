#!/bin/sh
set -e
cd /app

# Prepare wordpress
if [ ! -f "/app/wp-config.php" ]; then
  wp config create --dbhost="$DB_HOST:$DB_PORT" --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --locale=pl_PL
fi

if [ ! -z "$DB_SNAPSHOT" ] && [ ! -f "$DB_SNAPSHOT" ]; then
  echo "Load $DB_SNAPSHOT snapshot... skiped" 1>&2
  echo "Path $DB_SNAPSHOT is not a file" 1>&2
fi

if [ ! -z "$DB_SNAPSHOT" ] && [ -f "$DB_SNAPSHOT" ]; then
  echo "Load $DB_SNAPSHOT snapshot"
  wp db drop --yes  ||:
  wp db create
  wp db import $DB_SNAPSHOT
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
wp plugin activate wp-super-cache akismet
wp theme activate events.pozoga.eu
