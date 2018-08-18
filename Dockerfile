FROM wordpress:cli-2
USER 0
WORKDIR /var/www/html

# install wordpress
RUN cd ~ && \
  wget https://pl.wordpress.org/wordpress-4.9.6-pl_PL.zip && \
  unzip wordpress-4.9.6-pl_PL.zip && \
  cp -a wordpress/. /var/www/html/
  #&& \
  #rm  wordpress-4.9.6-pl_PL.zip && \
  #rm  -rf wordpress


# install plugins
RUN mkdir -p /var/www/html/wp-content/plugins

RUN wget https://downloads.wordpress.org/plugin/jetpack.6.4.2.zip && \
  unzip jetpack.6.4.2.zip -d /var/www/html/wp-content/plugins && \
  rm -f jetpack.6.4.2.zip

RUN wget https://downloads.wordpress.org/plugin/wp-super-cache.1.6.3.zip && \
  unzip wp-super-cache.1.6.3.zip -d /var/www/html/wp-content/plugins&& \
  rm -f wp-super-cache.1.6.3.zip

RUN wget https://downloads.wordpress.org/plugin/akismet.4.0.8.zip && \
  unzip akismet.4.0.8.zip -d /var/www/html/wp-content/plugins && \
  rm -f akismet.4.0.8.zip

# add static files
COPY ex /var/www/html/ex
COPY slides /var/www/html/slides
COPY wp-content/plugins /var/www/html/wp-content/plugins
COPY wp-content/wp-cache-config.php /var/www/html/wp-content/wp-cache-config.php
COPY custom-entrypoint.sh /usr/local/bin/

# permissions
RUN chown -R www-data:www-data /var/www/html

# entrypoint
#USER www-data
ENTRYPOINT ["custom-entrypoint.sh"]
CMD []
