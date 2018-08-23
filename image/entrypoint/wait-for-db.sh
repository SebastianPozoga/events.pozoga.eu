#!/bin/bash
set -e

host="$1"
port="$2"

#while ! mysqladmin ping -h"$host" --silent; do
until nc -z -v -w30 $host $port ; do
  >&2 echo "Database $host:$port is unavailable - sleeping"
  sleep 1
done

>&2 echo "Database is up - start"
