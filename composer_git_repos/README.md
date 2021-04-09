# step 0: if you're starting over

    docker-compose -f stackoffline.yml rm
    docker rmi smw_dependencies
    rm -rf Dockerfile stackoffline.yml packages/ db/ images/ .env

# step 1: generate list of extension dependencies

Set up MediaWiki with Composer inside a Docker image

    cat << EOF > Dockerfile
    FROM mediawiki:1.31.1
    RUN apt-get update && apt-get install -y \
        vim unzip libzip-dev wget
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

The "progress=plain" is to show the full output data since Docker buildkit hides the data

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

# step 3: `wget` the git repo for each of the above

Use `wget` inside that same container. Mount `/scratch` on the host so the files we `wget` do not end up inside the container

    mkdir packages
    cd packages
    docker run -it --rm -v`pwd`:/scratch smw_dependencies /bin/bash

Inside the container, 

    cd /scratch

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

To save you time, here's all the wget commands and their corresponding packagist URL

    # https://packagist.org/packages/composer/installers
    wget https://github.com/composer/installers/archive/refs/tags/v1.10.0.zip
    unzip v1.10.0.zip
    rm v1.10.0.zip

    # https://packagist.org/packages/justinrainbow/json-schema#5.2.10
    wget https://github.com/justinrainbow/json-schema/archive/refs/tags/5.2.10.zip
    unzip 5.2.10.zip
    rm 5.2.10.zip
    
    # https://packagist.org/packages/seld/jsonlint#1.8.3
    wget https://github.com/Seldaek/jsonlint/archive/refs/tags/1.8.3.zip
    unzip 1.8.3.zip
    rm 1.8.3.zip
    
    # https://packagist.org/packages/react/promise#v2.8.0
    wget https://github.com/reactphp/promise/archive/refs/tags/v2.8.0.zip
    unzip v2.8.0.zip
    rm v2.8.0.zip
    
    # https://packagist.org/packages/guzzlehttp/streams#3.0.0
    wget https://github.com/guzzle/streams/archive/refs/tags/3.0.0.zip
    unzip 3.0.0.zip
    rm 3.0.0.zip
    
    # https://packagist.org/packages/guzzlehttp/ringphp#1.1.1
    wget https://github.com/guzzle/RingPHP/archive/refs/tags/1.1.1.zip
    unzip 1.1.1.zip
    rm 1.1.1.zip
    
    # https://packagist.org/packages/elasticsearch/elasticsearch#v6.7.2
    wget https://github.com/elastic/elasticsearch-php/archive/refs/tags/v6.7.2.zip
    unzip v6.7.2.zip
    rm v6.7.2.zip
    
    # https://packagist.org/packages/symfony/css-selector#v3.4.47
    wget https://github.com/symfony/css-selector/archive/refs/tags/v3.4.47.zip
    unzip v3.4.47.zip
    rm v3.4.47.zip
    
    # https://packagist.org/packages/onoi/shared-resources#0.4.3
    wget https://github.com/onoi/shared-resources/archive/refs/tags/0.4.3.zip
    unzip 0.4.3.zip
    rm 0.4.3.zip
    
    # https://packagist.org/packages/wikimedia/textcat#1.3.0
    wget https://github.com/wikimedia/textcat/archive/refs/tags/1.3.0.zip
    unzip 1.3.0.zip
    rm 1.3.0.zip
    
    # https://packagist.org/packages/onoi/tesa#0.1.0
    wget https://github.com/onoi/tesa/archive/refs/tags/0.1.0.zip
    unzip 0.1.0.zip
    rm 0.1.0.zip
    
    # https://packagist.org/packages/onoi/callback-container#2.0.0
    wget https://github.com/onoi/callback-container/archive/refs/tags/2.0.0.zip
    unzip 2.0.0.zip
    rm 2.0.0.zip
    
    # https://packagist.org/packages/onoi/cache#1.2.0
    wget https://github.com/onoi/cache/archive/refs/tags/1.2.0.zip
    unzip 1.2.0.zip
    rm 1.2.0.zip
    
    # https://packagist.org/packages/onoi/http-request#1.3.1
    wget https://github.com/onoi/http-request/archive/refs/tags/1.3.0.zip
    unzip 1.3.0.zip
    rm 1.3.0.zip
    
    # https://packagist.org/packages/onoi/blob-store#1.2.1
    wget https://github.com/onoi/blob-store/archive/refs/tags/1.2.0.zip
    unzip 1.2.0.zip
    rm 1.2.0.zip
    
    # https://packagist.org/packages/onoi/event-dispatcher#1.1.0
    wget https://github.com/onoi/event-dispatcher/archive/refs/tags/1.1.0.zip
    unzip 1.1.0.zip
    rm 1.1.0.zip
    
    # https://packagist.org/packages/onoi/message-reporter#1.4.1
    wget https://github.com/onoi/message-reporter/archive/refs/tags/1.4.1.zip
    unzip 1.4.1.zip
    rm 1.4.1.zip
    
    # https://packagist.org/packages/serialization/serialization#4.0.0
    wget https://github.com/wmde/Serialization/archive/refs/tags/4.0.0.zip
    unzip 4.0.0.zip
    rm 4.0.0.zip
    
    # https://packagist.org/packages/data-values/interfaces#1.0.0
    wget https://github.com/DataValues/Interfaces/archive/refs/tags/1.0.0.zip
    unzip 1.0.0.zip
    rm 1.0.0.zip
    
    # https://packagist.org/packages/data-values/data-values#3.0.0
    wget https://github.com/DataValues/DataValues/archive/refs/tags/3.0.0.zip
    unzip 3.0.0.zip
    rm 3.0.0.zip
    
    # https://packagist.org/packages/data-values/validators#1.0.0
    wget https://github.com/DataValues/Validators/archive/refs/tags/1.0.0.zip
    unzip 1.0.0.zip
    rm 1.0.0.zip
    
    # https://packagist.org/packages/data-values/common#1.0.0
    wget https://github.com/DataValues/Common/archive/refs/tags/1.0.0.zip
    unzip 1.0.0.zip
    rm 1.0.0.zip

    # https://packagist.org/packages/param-processor/param-processor#1.11.0
    wget https://github.com/JeroenDeDauw/ParamProcessor/archive/refs/tags/1.11.0.zip
    unzip 1.11.0.zip
    rm 1.11.0.zip
        
    # https://packagist.org/packages/mediawiki/parser-hooks#1.6.1
    wget https://github.com/JeroenDeDauw/ParserHooks/archive/refs/tags/1.6.1.zip
    unzip 1.6.1.zip
    rm 1.6.1.zip
    
    # https://packagist.org/packages/mediawiki/semantic-media-wiki#3.2.2
    wget https://github.com/SemanticMediaWiki/SemanticMediaWiki/archive/refs/tags/3.2.2.zip
    unzip 3.2.2.zip
    rm 3.2.2.zip

# step 4: wget composer

While still inside the container,

    # downloaded from https://github.com/composer/composer/releases/tag/1.10.19
    wget https://github.com/composer/composer/releases/download/1.10.19/composer.phar
    mv composer.phar composer_1.phar

Exit the container

    exit

# step 5: run the offline mediawiki server in Docker

On the host, create a docker-compose YAML file

    echo "MYSQL_PW=example" > .env
    
    cat << EOF > stackoffline.yml
    # MediaWiki with MariaDB
    version: '3'
    services:
      mediawiki_no_smw:
        image: mediawiki:1.31.1
        depends_on:
          - database
        restart: unless-stopped
        ports:
          - 8080:80
        links:
          - database
        volumes:
          - ./images:/var/www/html/images
          - ./packages:/packages
          # After initial setup, download LocalSettings.php to the same directory as
          # this yaml and uncomment the following line and use compose to restart
          # the mediawiki service
          #- ./LocalSettings.php:/var/www/html/LocalSettings.php
      database:
        image: mariadb
        restart: unless-stopped
        expose:
          - "3306"
        environment:
          MYSQL_DATABASE: my_wiki
          MYSQL_USER: wikiuser
          # ${MYSQL_WD} comes from the .env file
          MYSQL_PASSWORD: ${MYSQL_PW}
          # You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD and MYSQL_RANDOM_ROOT_PASSWORD
          #MYSQL_ROOT_PASSWORD: mysecret
          MYSQL_RANDOM_ROOT_PASSWORD: 'yes'
        volumes:
          - ./db:/var/lib/mysql
    EOF
    
Run the images
    
    docker-compose --file stackoffline.yml  up --force-recreate

_Caveat_: wait until MariaDB has settled before attempting to set up MediaWiki

Access "http://localhost:8080" in a browser

Database host = database

database username = wikiuser

database password = example

download LocalSettings.php

Uncomment the line in stackoffline.yml

    - ./LocalSettings.php:/var/www/html/LocalSettings.php

# step 6: stop containers, enable LocalSettings in YAML

Stop the docker-compose, enable LocalSettings.php mapping inside stackoffline.yml

# step 7: create composer.json that references locally-available files

Based on 
https://getcomposer.org/doc/05-repositories.md#disabling-packagist-org
disable reference to packagist and use the locally-available /packages/ 

On the host, create a file `packages/composer.json` that contains

    {"minimum-stability": "dev",
      "repositories": [
        {"packagist.org": false
        },{"type": "path",
           "url": "/packages/SemanticMediaWiki-3.2.2"
          },{"type": "path",
             "url": "/packages/installers-1.10.0"
          },{"type": "path",
             "url": "/packages/ParserHooks-1.6.1"
          },{"type": "path",
             "url": "/packages/Validators-1.0.0"
          },{"type": "path",
             "url": "/packages/callback-container-2.0.0"
          },{"type": "path",
             "url": "/packages/elasticsearch-php-6.7.2"
          },{"type": "path",
             "url": "/packages/ParamProcessor-1.11.0"
          },{"type": "path",
             "url": "/packages/json-schema-5.2.10"
          },{"type": "path",
             "url": "/packages/RingPHP-1.1.1"
          },{"type": "path",
             "url": "/packages/Common-1.0.0"
          },{"type": "path",
             "url": "/packages/DataValues-3.0.0"
          },{"type": "path",
             "url": "/packages/Interfaces-1.0.0"
          }
      ],
      "require": {
        "mediawiki/semantic-media-wiki": "^3.2"
      }
    }
    
# step 8: use composer to install from local folders

    docker exec -it `docker ps | grep mediawiki | cut -d' ' -f1` /bin/bash

Inside that container, 

    cd /packages
    php /packages/composer_1.phar validate composer.json
    
    php /packages/composer_1.phar install

# step xx

    enableSemantics('localhost');

step xx+1

    php maintenance/update.php


When I use "artifact" and .zip files, I get the error message "version not found"
