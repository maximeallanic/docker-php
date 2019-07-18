FROM nimmis/alpine-micro:latest

RUN apk update
RUN apk add \
    nginx \
    curl \
    php7-xml \
    php7-intl \
    php7-pgsql \
    php7-mbstring \
    php7-json \
    php7-phar \
    php7-apcu \
    php7-dom \
    php7-openssl \
    php7-fpm \
    php7-xmlwriter \
    php7-tokenizer \
    php7-common \
    php7-calendar \
    php7-pdo \
    php7-fileinfo \
    php7-pdo_pgsql \
    php7-ctype \
    php7-session \
    php7-iconv \
    php7-posix \
    php7-simplexml \
    php7-xdebug \
    php7-opcache \
    php7-zip \
    php7-pcntl \
    bind-tools \
    apache-ant \
    openjdk8 \
    git


# Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Define custom config for apache
#RUN sed -i '/LoadModule rewrite_module/s/^#//g' /etc/apache2/httpd.conf
#RUN sed -i '/\/web\/html/s//\/web\/html\/web/g' /etc/apache2/httpd.conf
COPY conf/nginx/nginx.conf /etc/nginx/nginx.conf
RUN rm /etc/nginx/conf.d/default.conf
RUN mkdir /etc/service/nginx
COPY conf/nginx/run /etc/service/nginx/run
RUN chmod 777 /etc/service/nginx/run

# Define custom config for php
RUN sed -i 's/memory_limit = .*/memory_limit = -1/' /etc/php7/php.ini
RUN sed -i 's/max_execution_time = .*/max_execution_time = 0/' /etc/php7/php.ini
RUN sed -i 's/max_input_time = .*/max_input_time = -1/' /etc/php7/php.ini
RUN sed -i 's/realpath_cache_size = .*/realpath_cache_size = 20M/' /etc/php7/php.ini
RUN sed -i 's/realpath_cache_ttl = .*/realpath_cache_ttl = 7200/' /etc/php7/php.ini
RUN echo -e "\napc.enabled=1\napc.shm_size=64M\napc.enable_cli=1" >> /etc/php7/conf.d/apcu.ini
RUN echo -e '\nshort_open_tag = Off\nlog_errors = On\nerror_reporting = E_ALL\ndisplay_errors = On\nerror_log = /proc/self/fd/2\nopcache.max_accelerated_files = 20000\nrealpath_cache_size = 4096K\nrealpath_cache_ttl = 600' >> /etc/php7/php.ini

COPY conf/php-fpm/xdebug.ini /etc/php7/conf.d/xdebug.ini.disabled
COPY conf/php-fpm/*.conf /etc/php7/php-fpm.d/
RUN mkdir /etc/service/php-fpm
COPY conf/php-fpm/run /etc/service/php-fpm/run
RUN chmod 777 /etc/service/php-fpm/run

COPY conf/profile /root/.profile
RUN chmod 777 /root/.profile

RUN mkdir -p /run/nginx
RUN mkdir -p /web/logs
RUN mkdir -p /web/run
RUN mkdir -p /dev/shm/cache
RUN chmod -R 777 /run
RUN chmod -R 777 /web
RUN chmod -R 777 /var/log

ENTRYPOINT ["/bin/sh", "-l", "-c"]

CMD ["/boot.sh"]

WORKDIR /web/html
