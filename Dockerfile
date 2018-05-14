FROM nimmis/alpine-apache-php7:latest

RUN apk update
RUN apk add \
    php7-xml \
    php7-intl \
    php7-pgsql \
    php7-mbstring \
    php7-json \
    php7-phar \
    php7-dom \
    php7-openssl \
    php7-xmlwriter \
    php7-tokenizer \
    php7-pdo \
    php7-pdo_pgsql \
    php7-ctype \
    php7-session \
    php7-simplexml \
    apache-ant \
    openjdk8

#ADD ./apache/default.conf /etc/apache2/conf.d/www.conf

RUN sed -i '/LoadModule rewrite_module/s/^#//g' /etc/apache2/httpd.conf
RUN sed -i '/\/web\/html/s//\/web\/html\/web/g' /etc/apache2/httpd.conf
RUN sed -i 's/memory_limit = .*/memory_limit = '1024M'/' /etc/php7/php.ini

WORKDIR /web/html