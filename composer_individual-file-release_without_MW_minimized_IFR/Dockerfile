FROM mediawiki:latest

RUN apt-get update && apt-get install -y \
    vim unzip libzip-dev wget

RUN docker-php-ext-install zip

# install PHP package manager "Compose"
# requires v1 instead of v2 for compatibility with SMW
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.16
#RUN mv composer.phar /usr/local/bin/composer

WORKDIR /opt
RUN wget https://github.com/composer/composer/releases/download/1.10.19/composer.phar

RUN mkdir -p /opt/ifr

RUN echo "{\n\"require\": {\n\"mediawiki/semantic-media-wiki\":\"^3.2\"\n},\n\"config\":{\n\"preferred-install\":\"source\",\n\"optimize-autoloader\": true\n}\n}" > composer.json

RUN php /opt/composer.phar update --verbose --no-dev --prefer-source

#RUN tar -cvf ifr_smw.tar mediawiki
