FROM tagplus5/php:7-apache

RUN apt-get update && apt-get -yqq --no-install-recommends -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" install \
 curl \
 ntpdate \
 wget \
 git \
 ant \
 unzip \
 php7.0-xml \
 php7.0-intl \
 php7.0-pgsql \
 php7.0-mbstring \
 python \
 python-setuptools \
 && rm -rf /var/lib/apt/lists/*
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN easy_install pip && pip install --upgrade awsebcli

COPY apache/default.conf /etc/apache2/sites-enabled/000-default.conf