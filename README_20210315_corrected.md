# Updating SMW on an Offline Server



## Components:

* 1 x Offline Wiki Server
* 1 x Wiki Server with Web Access (Composer-enabled)


## Process:

### Step 0

If MediaWiki previous was set up, remove all instances by running

    rm -rf db images LocalSettings.php
    docker-compose -f stack.yml rm

### Step 1

Set up an offline MediaWiki server

First set the password, then create a .yml file for docker-compose

    mkdir offline_server
    cd offline_server
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

    docker-compose --file stackoffline.yml  up --force-recreate

_Caveat_: wait until MariaDB has settled before attempting to set up MediaWiki

Access "http://localhost:8080" in a browser

Create LocalSettings.php, download, uncomment the line in stackoffline.yml

Do not restart yet

### Step 2

The Offline Server is running two docker containers: a MediaWiki PHP server and the MariaDB server.

### Step 3

From this point, we are creating a separate server, one that has internet access.

### Step 4


On the server with web access, we download mediawiki and then we install said wiki using Composer. In this step, we set up a mediawiki similar to the one set up for the Offline wiki, with the same requisite components. We may use identical containers as the Offline wiki, but they can not be shared between the two wikis, as we are maintaining separation. The following procedure assumes a setup web server for the wiki.

    mkdir online_server
    cd online_sever
    cat << EOF > Dockerfile
    FROM mediawiki::1.31.1
    RUN apt-get update && apt-get install -y \
        vim unzip libzip-dev
    RUN docker-php-ext-install zip

    # install PHP package manager "Compose"
    # requires v1 instead of v2 for compatibility with SMW
    RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.16
    #RUN mv composer.phar /usr/local/bin/composer

    # once Compose is installed, create a file the specifies the desired packages
    # update mediawiki extensions via composer
    # CAVEAT: This isn't necessary on the online server; it merely shows how an online server can have SMW installed
    RUN echo "{\n\"require\": {\n\"mediawiki/semantic-media-wiki\": \"~3.2\"\n}\n}" > /var/www/html/composer.local.json
    # then run Composer to get the package
    RUN composer update --no-dev
    EOF

Using that Dockerfile, create an image that includes SWM

    docker build -t mw_with_smw .

and then use that image in `docker-compose`

    echo "MYSQL_PW=example" > .env

    cat << EOF > stackonline.yml
    # MediaWiki with MariaDB
    version: '3'
    services:
      mediawiki_with_smw:
        image: mw_with_smw
        depends_on:
          - database
        restart: unless-stopped
        ports:
          - 8080:80
        links:
          - database
        volumes:
          - ./images:/var/www/html/images
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

    docker-compose --file stackonline.yml  up --force-recreate

_Caveat_: wait until MariaDB has settled before attempting to set up MediaWiki


### Step 5


run the update and maintenance scripts, which load the extensions into the file structure.



    php composer.phar update –no-dev //may need to run this command twice
    php maintenance/update.php //may need a –skip-external-dependencies flag



In "LocalSettings.php":



Add:

    require_once "$IP/extensions/SemanticMediaWiki/SemanticMediaWiki.php";
    enableSemantics( 'localhost');

as a call at the end of the file, replacing the domain name as needed.

Check and verify installation in the online wiki.

This addition enables SMW on the wiki.



Rerun the update + maintenance scripts, and run a database refresh:

    php extensions/SemanticMediaWiki/maintenance/rebuildData.php -d 50 -v

### Step 6

Now having a fully updated online SMW installation, we create an individual file release to gain a copy of the extensions. This script then has it's permissions modified for user access only before activation.

Download IndividualFileRelease.sh from https://raw.githubusercontent.com/SemanticMediaWiki/IndividualFileRelease/master/IndividualFileRelease.sh


    cd /opt
    curl https://raw.githubusercontent.com/SemanticMediaWiki/IndividualFileRelease/master/IndividualFileRelease.sh > IndividualFileRelease.sh
    chmod 700 IndividualFileRelease.sh
    ./IndividualFileRelease.sh
    cd /var/tmp/mediawiki/
    tar czvf mw.tar.gz *

The resultant files from this (74MB tar.gz file) are then moved to the OFFLINE server.

### Step 7

We swap back to working on the Offline server, transferring the files produced by the IFR in /var/tmp/mediawiki to the offline server.

### Step 8

Having moved the files from the IFR to the offline server (it isn't in a tarball or compressed format, unless you manually made one), the files are copied into the base directory of the MediaWiki installation.

    /var/www/html/mediawiki

Modify the offline installation's LocalSettings.php file, adding:

    require_once "$IP/extensions/SemanticMediaWiki/SemanticMediaWiki.php";
    enableSemantics( 'localhost');



In addition to optional settings, as requested.

Afterwards, run:

    php maintenance/update.php

on the offline server from the base directory.

Alternatively, as an wiki admin, goto "Special:SMWAdmin" and:

1. Click on "initialize or upgrade tables" in Database installation and upgrade.
1. Click on "Start updating data"

### Step 9

Verify extension installation for the offline wiki.
