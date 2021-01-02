FROM mediawiki:latest

RUN apt-get update && apt-get install -y \
    vim unzip libzip-dev

RUN docker-php-ext-install zip


# https://gerrit.wikimedia.org/r/admin/repos/mediawiki/extensions/SemanticDrilldown
WORKDIR /var/www/html/extensions/
RUN git clone "https://gerrit.wikimedia.org/r/mediawiki/extensions/SemanticDrilldown" \
     /var/www/html/extensions/SemanticDrilldown

# https://github.com/SemanticMediaWiki/SemanticCite
RUN git clone "https://github.com/SemanticMediaWiki/SemanticCite.git" \
     /var/www/html/extensions/SemanticCite

# https://github.com/SemanticMediaWiki/SemanticMediaWiki
RUN git clone "https://github.com/SemanticMediaWiki/SemanticMediaWiki.git" \
     /var/www/html/extensions/SemanticMediaWiki

