# docker build -f Dockerfile -t mediawiki_git .
# docker run -it -v `pwd`:/scratch --rm mediawiki_git:latest /bin/bash

FROM mediawiki:latest

RUN apt-get update && apt-get install -y \
    vim unzip libzip-dev git wget

RUN docker-php-ext-install zip

WORKDIR /opt

# downloaded from https://github.com/composer/composer/releases/tag/1.10.19
RUN wget https://github.com/composer/composer/releases/download/1.10.19/composer.phar && \
    mv composer.phar composer_1.phar
RUN wget https://github.com/composer/composer/releases/download/2.0.8/composer.phar && \
    mv composer.phar composer_2.phar

#RUN php /opt/composer.phar config -g repo.packagist false

# https://stackoverflow.com/a/39802804/1164295
# https://getcomposer.org/doc/05-repositories.md#path
COPY composer.json /opt

WORKDIR /var/www/html/extensions

# https://github.com/SemanticMediaWiki/SemanticMediaWiki
RUN git clone https://github.com/SemanticMediaWiki/SemanticMediaWiki.git


WORKDIR /var/www/html/vendor
RUN git clone https://github.com/JeroenDeDauw/ParamProcessor.git
RUN git clone https://github.com/DataValues/Common.git
RUN git clone https://github.com/DataValues/Validators.git
RUN git clone https://github.com/onoi/callback-container.git
RUN git clone https://github.com/php-fig/log.git
RUN git clone https://github.com/DataValues/DataValues.git
RUN git clone https://github.com/DataValues/Interfaces.git
RUN git clone https://github.com/justinrainbow/json-schema.git
RUN git clone https://github.com/elastic/elasticsearch-php.git
RUN git clone https://github.com/composer/installers.git
#RUN cd installers && git branch -m master
RUN git clone https://github.com/JeroenDeDauw/ParserHooks.git
