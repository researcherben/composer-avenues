FROM mediawiki:latest

RUN apt-get update && apt-get install -y \
    vim unzip libzip-dev git

#RUN docker-php-ext-install zip

WORKDIR /opt/

# downloaded from https://github.com/composer/composer/releases/tag/1.10.19
RUN wget https://github.com/composer/composer/releases/download/1.10.19/composer.phar

WORKDIR /var/www/html/extension

# https://packagist.org/packages/mediawiki/semantic-media-wiki
# links to https://github.com/SemanticMediaWiki/SemanticMediaWiki/releases/tag/3.2.2
RUN wget https://github.com/SemanticMediaWiki/SemanticMediaWiki/archive/3.2.2.zip


# alternative is to git HEAD
#    # https://gerrit.wikimedia.org/r/admin/repos/mediawiki/extensions/SemanticDrilldown
#    WORKDIR /var/www/html/extensions/
#    RUN git clone "https://gerrit.wikimedia.org/r/mediawiki/extensions/SemanticDrilldown" \
#         /var/www/html/extensions/SemanticDrilldown

#    # https://github.com/SemanticMediaWiki/SemanticCite
#    RUN git clone "https://github.com/SemanticMediaWiki/SemanticCite.git" \
#         /var/www/html/extensions/SemanticCite

#    # https://github.com/SemanticMediaWiki/SemanticMediaWiki
#    RUN git clone "https://github.com/SemanticMediaWiki/SemanticMediaWiki.git" \
#         /var/www/html/extensions/SemanticMediaWiki

WORKDIR /var/www/html/vendor

# https://github.com/JeroenDeDauw/ParamProcessor/releases/tag/1.3.2
RUN wget https://github.com/JeroenDeDauw/ParamProcessor/archive/1.3.2.zip

# https://packagist.org/packages/onoi/http-request
# https://github.com/onoi/http-request/releases/tag/1.3.0
RUN wget https://github.com/onoi/http-request/archive/1.3.0.zip

# https://packagist.org/packages/onoi/event-dispatcher
# https://github.com/onoi/event-dispatcher/releases/tag/1.1.0
RUN wget https://github.com/onoi/event-dispatcher/archive/1.1.0.zip

# https://packagist.org/packages/onoi/callback-container
# https://github.com/onoi/callback-container/releases/tag/2.0.0
RUN wget https://github.com/onoi/callback-container/archive/2.0.0.zip

# https://packagist.org/packages/mediawiki/parser-hooks
# https://github.com/JeroenDeDauw/ParserHooks/releases/tag/1.6.1
RUN wget https://github.com/JeroenDeDauw/ParserHooks/archive/1.6.1.zip

# https://packagist.org/packages/justinrainbow/json-schema
# https://github.com/justinrainbow/json-schema/releases/tag/5.2.10
RUN wget https://github.com/justinrainbow/json-schema/archive/5.2.10.zip

# https://packagist.org/packages/elasticsearch/elasticsearch
# https://github.com/elastic/elasticsearch-php/releases/tag/v7.10.0
RUN wget https://github.com/elastic/elasticsearch-php/archive/v7.10.0.zip
