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
    apache-ant \
    openjdk8 \
    git

# Define custom config for apache
RUN sed -i '/LoadModule rewrite_module/s/^#//g' /etc/apache2/httpd.conf
RUN sed -i '/\/web\/html/s//\/web\/html\/web/g' /etc/apache2/httpd.conf

# Define custom config for php
RUN sed -i 's/memory_limit = .*/memory_limit = -1/' /etc/php7/php.ini
RUN sed -i 's/max_execution_time = .*/max_execution_time = 0/' /etc/php7/php.ini
RUN sed -i 's/xdebug.coverage_enable = .*/xdebug.coverage_enable = 1/' /etc/php7/php.ini
#RUN sed -i 's/xdebug.profiler_enable = .*/xdebug.profiler_enable = 1/' /etc/php7/php.ini
RUN echo -e "zend_extension=xdebug.so
             xdebug.profiler_output_dir="/dev/shm/trace"
             xdebug.profiler_append=On
             xdebug.profiler_enable_trigger=On
             xdebug.profiler_output_name="%R-%u.trace"
             xdebug.trace_options=1
             xdebug.collect_params=4
             xdebug.collect_return=1
             xdebug.collect_vars=0

             xdebug.profiler_enable=0
             xdebug.auto_trace=Off" > /etc/php7/conf.d/xdebug.ini


RUN echo -e "\napc.enabled=1\napc.shm_size=64M" >> /etc/php7/conf.d/apcu.ini

# Add env variable to apache2
RUN sed -i 's/set -e/set -e\nsource \/etc\/envvars\n/' /etc/service/apache2/run

WORKDIR /web/html
