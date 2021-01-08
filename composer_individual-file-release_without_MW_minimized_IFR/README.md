https://github.com/SemanticMediaWiki/SemanticMediaWiki/releases/tag/2.5.5



See also <https://www.semantic-mediawiki.org/wiki/Help:Installation/Using_Tarball_(without_shell_access)>

# step 1

Build the container that has composer

    make run_mw_with_composer

# step 2

Inside the container, run the IFR script to gather the SMW dependencies

    cd /scratch
    ./individual_file_release.sh

Output should be ifr.tar

# step 3

Exit the container. On the host, configure a fresh MW container

    make first_compose

Visit http://localhost:8080/ and create LocalSettings.php

# step 4

Stop the MW compose.

    rm stack_new.yaml
    mkdir ifr
    mv ifr.tar ifr

# step 5

Restart the MW compose with the ifr directory mounted

    docker-compose --file stack.yml  up --force-recreate

# step 6

In a separate shell, enter the running MW container

    docker exec -it ${container_id} /bin/bash

By default,
 * folders in /var/www/html/ have group and owner root:root
 * folders in /var/www/html/extensions have group and owner www-data:www-data
 * folders in /var/www/html/vendor have group and owner root:root

# step 7

Inside the container,

    cd /ifr
    tar xvf ifr.tar
    cd /ifr/ifr
    chown www-data:www-data -R extensions/
    cd /ifr/ifr/extensions
    mv SemanticMediaWiki/ /var/www/html/extensions/
    cd /ifr/ifr/vendor
    #cp -r * /var/www/html/vendor/

    cp -r bin/ /var/www/html/vendor/
    cp -r data-values/ /var/www/html/vendor/
    cp -r elasticsearch/ /var/www/html/vendor/
    cp -r justinrainbow/ /var/www/html/vendor/
    cp -r mediawiki/ /var/www/html/vendor/
    cp -r onoi/ /var/www/html/vendor/
    cp -r param-processor/ /var/www/html/vendor/
    cp -r react/ /var/www/html/vendor/
    cp -r seld/ /var/www/html/vendor/
    cp -r serialization/ /var/www/html/vendor/

# step 8

On the host, add

    require_once "$IP/extensions/SemanticMediaWiki/SemanticMediaWiki.php";
    enableSemantics( 'localhost' );

to LocalSettings.php

# step 9

Inside the container,

    cd /var/www/html
    php maintenance/update.php

as per <https://www.semantic-mediawiki.org/wiki/Help:Installation/Using_Tarball_(without_shell_access)>
