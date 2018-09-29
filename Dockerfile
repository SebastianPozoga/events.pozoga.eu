FROM wordpress:cli-2
EXPOSE 80 443
USER 0

# install wordpress
RUN cd ~ && \
  wget https://pl.wordpress.org/wordpress-4.9.6-pl_PL.zip && \
  unzip wordpress-4.9.6-pl_PL.zip && \
  mv wordpress /app && \
  rm wordpress-4.9.6-pl_PL.zip && \
  rm -rf wordpress

WORKDIR /app

# install plugins
RUN wget https://downloads.wordpress.org/plugin/jetpack.6.5.zip && \
  unzip jetpack.6.5.zip && \
  mkdir -p /app/wp-content/plugins && \
  mv jetpack /app/wp-content/plugins/jetpack && \
  rm jetpack.6.5.zip

RUN wget https://downloads.wordpress.org/plugin/wp-super-cache.1.6.4.zip && \
  unzip wp-super-cache.1.6.4.zip -d /app/wp-content/plugins && \
  rm -f wp-super-cache.1.6.4.zip

RUN wget https://downloads.wordpress.org/plugin/insert-headers-and-footers.1.4.3.zip && \
  unzip insert-headers-and-footers.1.4.3.zip -d /app/wp-content/plugins && \
  rm -f insert-headers-and-footers.1.4.3.zip

RUN wget https://downloads.wordpress.org/plugin/akismet.4.0.8.zip && \
  rm -rf /app/wp-content/plugins/akismet && \
  unzip akismet.4.0.8.zip -d /app/wp-content/plugins && \
  rm -f akismet.4.0.8.zip

# add static files
ADD image /root/image
RUN \
  find /root/image -type f -name '*.sh' -exec sed -i -e 's/\r//' {} \; && \
  cp -r /root/image/* / && \
  rm -rf /root/image

# Add main packages
RUN apk update && apk upgrade && apk add \
  bash apache2  apache2-ssl php7 php7-apache2 curl ca-certificates openssl openssh tzdata openntpd

# Install php extensions
RUN apk add \
  php7-phar \
  php7-json \
  php7-iconv \
  php7-openssl \
	php7-ftp \
	php7-xdebug \
	php7-mcrypt \
	php7-mbstring \
	php7-soap \
	php7-gmp \
	php7-pdo_odbc \
	php7-dom \
	php7-pdo \
	php7-zip \
	php7-mysqli \
	php7-sqlite3 \
	php7-pdo_pgsql \
	php7-bcmath \
	php7-gd \
	php7-odbc \
	php7-pdo_mysql \
	php7-pdo_sqlite \
	php7-gettext \
	php7-xmlreader \
	php7-xmlwriter \
	php7-tokenizer \
	php7-xmlrpc \
	php7-bz2 \
	php7-pdo_dblib \
	php7-curl \
	php7-ctype \
	php7-session \
	php7-redis \
	php7-exif

# configure apache2
RUN sed -i 's#^DocumentRoot ".*#DocumentRoot "/app"#g' /etc/apache2/httpd.conf && \
  sed -i 's#AllowOverride [Nn]one#AllowOverride All#' /etc/apache2/httpd.conf && \
  sed -i 's/^#ServerName.*/ServerName webproxy/' /etc/apache2/httpd.conf && \
  sed -i 's#/var/www/localhost/htdocs#/app#g' /etc/apache2/httpd.conf && \
  sed -i 's/^User.*/User www-data/' /etc/apache2/httpd.conf && \
  sed -i 's/^Group.*/Group www-data/' /etc/apache2/httpd.conf && \
  sed -i 's#/var/log/apache2/#/dev/stdout#g' /etc/apache2/httpd.conf && \
  sed -i 's/#LoadModule rewrite_module/LoadModule rewrite_module/g' /etc/apache2/httpd.conf

RUN sed -i 's#^DocumentRoot ".*#DocumentRoot "/app"#g' /etc/apache2/conf.d/ssl.conf && \
  sed -i 's/#LoadModule rewrite_module/LoadModule rewrite_module/g' /etc/apache2/conf.d/ssl.conf 

# configure apache2
RUN mkdir -p /run/apache2/ && \
  rm -rf /var/cache/apk/*

# install system packages
RUN apk add sudo

# permissions
RUN chmod +x /entrypoint/custom-entrypoint.sh
RUN chown -R www-data:www-data /app

# entrypoint
ENTRYPOINT ["/bin/sh"]
CMD ["/entrypoint/custom-entrypoint.sh"]
