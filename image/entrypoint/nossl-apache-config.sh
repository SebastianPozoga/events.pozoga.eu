#!/bin/sh
set -e

# Add config file
cat > "/etc/apache2/conf.d/000-host.conf" << EndOfMessage
<VirtualHost *:80>
  DocumentRoot "/app"
  ServerName webproxy
  <Directory "/app">
    AllowOverride All
  </Directory>
</VirtualHost>

EndOfMessage
