FROM wordpress:cli-2
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
RUN wget https://downloads.wordpress.org/plugin/jetpack.6.4.2.zip && \
  unzip jetpack.6.4.2.zip && \
  mkdir -p /app/wp-content/plugins && \
  mv jetpack /app/wp-content/plugins/jetpack && \
  rm jetpack.6.4.2.zip

RUN wget https://downloads.wordpress.org/plugin/wp-super-cache.1.6.3.zip && \
  unzip wp-super-cache.1.6.3.zip -d /app/wp-content/plugins && \
  rm -f wp-super-cache.1.6.3.zip

# add static files
ADD image /root/image
RUN \
  find /root/image -type f -name '*.sh' -exec sed -i -e 's/\r//' {} \; && \
  cp -r /root/image/* / && \
  rm -rf /root/image

# permissions
RUN chmod +x /app/custom-entrypoint.sh
RUN chown -R www-data:www-data /app

# entrypoint
USER www-data
ENTRYPOINT ["/bin/sh"]
CMD ["/app/custom-entrypoint.sh"]
