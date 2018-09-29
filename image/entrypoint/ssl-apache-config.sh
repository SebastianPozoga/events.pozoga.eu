#!/bin/sh
set -e

# Add config file
cat > "/etc/apache2/conf.d/000-host.conf" << EndOfMessage
<VirtualHost *:80>
  Redirect permanent / https://$DOMAIN/
</VirtualHost>

<VirtualHost *:443>
  DocumentRoot /app
  <Directory "/app">
    AllowOverride All
  </Directory>

  SSLEngine On
  SSLCertificateFile /certs/cert.pem
  SSLCertificateKeyFile /certs/privkey.pem
  SSLCertificateChainFile /certs/chain.pem

  Header always set Strict-Transport-Security "max-age=15768000"

  RequestHeader append "X-Forwarded-Proto" "https"
  RequestHeader set "X-Forwarded-Ssl" "on"
</VirtualHost>

SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1
SSLCipherSuite ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS
SSLHonorCipherOrder on
#SSLCompression off
SSLSessionTickets off

SSLUseStapling on
SSLStaplingResponderTimeout 5
SSLStaplingReturnResponderErrors off
SSLStaplingCache shmcb:/var/run/ocsp(128000)

EndOfMessage
