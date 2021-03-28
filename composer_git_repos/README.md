# step 1: generate list of extension dependencies

set up MediaWiki with Composer inside a Docker image

    cat << EOF > Dockerfile
    FROM mediawiki:1.31.1
    RUN apt-get update && apt-get install -y \
    vim unzip libzip-dev
    RUN docker-php-ext-install zip

    # install PHP package manager "Composer"
    # https://github.com/composer/composer/releases/tag/1.10.19
    # requires v1 instead of v2 for compatibility with SMW
    RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.16
    #RUN mv composer.phar /usr/local/bin/composer

    # once Compose is installed, create a file the specifies the desired packages
    # update mediawiki extensions via composer
    RUN echo "{\n\"require\": {\n\"mediawiki/semantic-media-wiki\": \"~3.2\"\n}\n}" > /var/www/html/composer.local.json
    # then run Composer to get the package
    RUN composer update --no-dev
    EOF

and build the image

    docker build -t smw_dependencies . --no-cache --progress=plain

# step 2: get list of extension dependencies

The list should be something like

    Package operations: 25 installs, 3 updates, 3 removals
    Removing wikimedia/testing-access-wrapper (1.0.0)
    Removing pear/net_socket (v1.2.1)
    Removing pear/net_smtp (1.7.3)
    Installing composer/installers (v1.10.0)
    Updating pear/pear_exception (v1.0.0 => v1.0.2)
    Updating pear/console_getopt (v1.4.1 => v1.4.3)
    Updating pear/pear-core-minimal (v1.10.3 => v1.10.10)
    Installing justinrainbow/json-schema (5.2.10)
    Installing seld/jsonlint (1.8.3)
    Installing react/promise (v2.8.0)
    Installing guzzlehttp/streams (3.0.0)
    Installing guzzlehttp/ringphp (1.1.1)
    Installing elasticsearch/elasticsearch (v6.7.2)
    Installing symfony/css-selector (v3.4.47)
    Installing onoi/shared-resources (0.4.3)
    Installing wikimedia/textcat (1.3.0)
    Installing onoi/tesa (0.1.0)
    Installing onoi/callback-container (2.0.0)
    Installing onoi/cache (1.2.0)
    Installing onoi/http-request (1.3.1)
    Installing onoi/blob-store (1.2.1)
    Installing onoi/event-dispatcher (1.1.0)
    Installing onoi/message-reporter (1.4.1)
    Installing serialization/serialization (4.0.0)
    Installing data-values/interfaces (1.0.0)
    Installing data-values/data-values (3.0.0)
    Installing data-values/validators (1.0.0)
    Installing data-values/common (1.0.0)
    Installing param-processor/param-processor (1.11.0)
    Installing mediawiki/parser-hooks (1.6.1)
    Installing mediawiki/semantic-media-wiki (3.2.2)

# step 3: manually get each of those git repos

In the above log output, the line

    Installing mediawiki/semantic-media-wiki (3.2.2)
    
corresponds to the page https://packagist.org/packages/mediawiki/semantic-media-wiki#3.2.2
which points to the source code release https://github.com/SemanticMediaWiki/SemanticMediaWiki/releases/tag/3.2.2

    wget https://github.com/SemanticMediaWiki/SemanticMediaWiki/archive/refs/tags/3.2.2.zip

Similarly, the line

    Installing mediawiki/parser-hooks (1.6.1)

corresponds to the page https://packagist.org/packages/mediawiki/parser-hooks#1.6.1
which points to the source code release https://github.com/JeroenDeDauw/ParserHooks/releases/tag/1.6.1

    wget https://github.com/JeroenDeDauw/ParserHooks/archive/refs/tags/1.6.1.zip

As one more example,

    Installing param-processor/param-processor (1.11.0)
    
corresponds to the page https://packagist.org/packages/param-processor/param-processor#1.11.0
which points to the source code release https://github.com/JeroenDeDauw/ParamProcessor/releases/tag/1.11.0

    wget https://github.com/JeroenDeDauw/ParamProcessor/archive/refs/tags/1.11.0.zip




https://getcomposer.org/doc/05-repositories.md#disabling-packagist-org

step xx

    enableSemantics('localhost');

step xx+1

    php maintenance/update.php


When I use "artifact" and .zip files, I get the error message "version not found"
