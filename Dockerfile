FROM nimmis/alpine-apache-php7:latest

RUN apk update
RUN apk add \
    php7-xml \
    php7-intl \
    php7-pgsql \
    php7-mbstring \
    php7-json \
    php7-phar \
    php7-apcu \
    php7-dom \
    php7-openssl \
    php7-xmlwriter \
    php7-tokenizer \
    php7-common \
    php7-calendar \
    php7-pdo \
    php7-pdo_pgsql \
    php7-ctype \
    php7-session \
    php7-iconv \
    php7-posix \
    php7-simplexml \
    php7-xdebug \
    php7-opcache \
    bind-tools \
    apache-ant \
    openjdk8 \
    git

# Define custom config for apache
RUN sed -i '/LoadModule rewrite_module/s/^#//g' /etc/apache2/httpd.conf
RUN sed -i '/\/web\/html/s//\/web\/html\/web/g' /etc/apache2/httpd.conf

# Define custom config for php
RUN sed -i 's/memory_limit = .*/memory_limit = -1/' /etc/php7/php.ini
RUN sed -i 's/max_execution_time = .*/max_execution_time = 0/' /etc/php7/php.ini
RUN sed -i 's/max_input_time = .*/max_input_time = -1/' /etc/php7/php.ini
RUN sed -i 's/realpath_cache_size = .*/realpath_cache_size = 4096k/' /etc/php7/php.ini
RUN echo -e "\napc.enabled=1\napc.shm_size=64M" >> /etc/php7/conf.d/apcu.ini

COPY php/xdebug.ini /etc/php7/conf.d/xdebug.ini
COPY apache/run /etc/service/apache2/run
COPY apache/profile /root/.profile

RUN chmod 777 /root/.profile

RUN chmod 777 /etc/service/apache2/run

ENTRYPOINT ["/bin/sh", "-l", "-c"]

CMD ["/boot.sh"]

WORKDIR /web/html
