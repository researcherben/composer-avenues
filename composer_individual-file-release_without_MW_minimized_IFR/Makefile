
.PHONY: help
help:
	@echo "make help"
	@echo "      this message"
	@echo "==== Targets outside container ===="
	@echo "make first_compose"
	@echo "make addSemantics"


# for IFR
build_mw_with_composer:
	docker build -f Dockerfile -t mw_create_ifr .
	docker run --rm --entrypoint cat mw_create_ifr /opt/ifr_smw.tar > ifr.tar


# Initialization of MediaWiki to create LocalSettings.php
# for database config, see
# https://github.com/researcherben/mediawiki-in-docker/blob/main/screenshots_of_wiki/installation_20_dbconnect.png
first_compose: build_mw_with_composer
	rm -rf db images stack_new.yml
	mkdir db
	mkdir images
	cat stack.yml | sed 's/.*\.\/LocalSettings.php.*//g'  > stack_new.yml
	docker-compose --file stack_new.yml  up --force-recreate -d
	/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome http://localhost:8080


# after configuring MediaWiki and downloading LocalSettings.php, 
# remove stack_new.yml and start (mediaWiki + MariaDB)
after_download_of_localSettings:
	rm stack_new.yml
	docker-compose --file stack.yml  up --force-recreate -d


compose:
	docker-compose --file stack.yml  up --force-recreate


# from https://stackoverflow.com/a/1909390/1164295
extract_ifr_inside_mw_container: after_download_of_localSettings
	$(eval container_id := $(shell docker ps | grep mediawiki | cut -d' ' -f1))
	docker cp ifr.tar $(container_id):/opt/ifr.tar
	docker exec -it $(container_id) /bin/bash -c "tar xvf /opt/ifr.tar --directory=/opt"

# this is the stage where I snap-shotted the container
# docker commit 2e16fbe1ca11 mediawiki_with_ifr_extracted

#set_permissions_on_swm: 
#	$(eval container_id := $(shell docker ps | grep mediawiki | cut -d' ' -f1))
#	docker exec $(container_id) /bin/bash -c "cd /opt/ifr/ && chown www-data:www-data extensions/ -R"

# https://unix.stackexchange.com/questions/248544/mv-move-file-only-if-destination-does-not-exist
move_folders: extract_ifr_inside_mw_container
	$(eval container_id := $(shell docker ps | grep mediawiki | cut -d' ' -f1))
	docker exec $(container_id) /bin/bash -c "cp -r /opt/ifr/extensions/SemanticMediaWiki /var/www/html/extensions/"
	docker exec $(container_id) /bin/bash -c "cp -r /opt/ifr/vendor/* /var/www/html/vendor/"

# now we are here: https://www.semantic-mediawiki.org/wiki/Help:Installation/Using_Tarball_(without_shell_access)#Enable_Semantic_MediaWiki
addSemantics: move_folders
	echo "require_once \"/var/www/html/extensions/SemanticMediaWiki/SemanticMediaWiki.php\";"  >> LocalSettings.php
	echo "enableSemantics('localhost');" >> LocalSettings.php

#php maintenance/generateLocalAutoload.php

# fails:
# php maintenance/update.php


enter_running_container:
	$(eval container_id := $(shell docker ps | grep mediawiki | cut -d' ' -f1))
	docker exec -it $(container_id) /bin/bash

# container_id=`docker ps | grep mediawiki | cut -d' ' -f1`
# docker exec -it ${container_id} /bin/bash

kill_container:
	$(eval container_id := $(shell docker ps | grep mediawiki_with_smw | cut -d' ' -f1))
	docker kill $(container_id)
	$(eval container_id := $(shell docker ps | grep mariadb | cut -d' ' -f1))
	docker kill $(container_id)

