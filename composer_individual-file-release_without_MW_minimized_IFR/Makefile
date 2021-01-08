
.PHONY: help
help:
	@echo "make help"
	@echo "      this message"
	@echo "==== Targets outside container ===="
	@echo "make build_mw_with_composer"
	@echo "make first_compose"
	@echo "make after_download_of_localSettings"


# for IFR
build_mw_with_composer:
	docker build -f Dockerfile.create_ifr -t mw_create_ifr .
	docker run --rm --entrypoint cat mw_create_ifr /opt/ifr_smw.tar > ifr.tar


# Initialization of MediaWiki to create LocalSettings.php
# for database config, see
# https://github.com/researcherben/mediawiki-in-docker/blob/main/screenshots_of_wiki/installation_20_dbconnect.png
first_compose: 
	rm -rf db images stack_new.yml
	mkdir db
	mkdir images
	cat stack.yml | sed 's/.*\.\/LocalSettings.php.*//g'  > stack_temp.yml
	cat stack_temp.yml | sed 's/.*ifr.*//g'  > stack_new.yml
	rm stack_temp.yml
	docker-compose --file stack_new.yml  up --force-recreate


# after configuring MediaWiki and downloading LocalSettings.php, 
# remove stack_new.yml and start (mediaWiki + MariaDB)
after_download_of_localSettings:
	rm stack_new.yml
	docker-compose --file stack.yml  up --force-recreate


compose:
	docker-compose --file stack.yml  up --force-recreate


# from https://stackoverflow.com/a/1909390/1164295
extract_ifr_inside_mw_container:
	$(eval TMP := $(shell docker ps | grep mediawiki | cut -d' ' -f1))
	docker exec -it $(TMP) /bin/bash -c "tar xvf /opt/ifr.tar --directory=/opt"

set_permissions_on_swm:
	$(eval TMP := $(shell docker ps | grep mediawiki | cut -d' ' -f1))
	docker exec $(TMP) /bin/bash -c "cd /opt/ifr/ && chown www-data:www-data extensions/ -R"

# https://unix.stackexchange.com/questions/248544/mv-move-file-only-if-destination-does-not-exist
move_folders:
	$(eval TMP := $(shell docker ps | grep mediawiki | cut -d' ' -f1))
	docker exec $(TMP) /bin/bash -c "mv /opt/ifr/extensions/SemanticMediaWiki /var/www/html/extensions/"
	docker exec $(TMP) /bin/bash -c "mv -vn /opt/ifr/vendor/* /var/www/html/vendor/"

# now we are here: https://www.semantic-mediawiki.org/wiki/Help:Installation/Using_Tarball_(without_shell_access)#Enable_Semantic_MediaWiki
addSemantics:
	echo "require_once \"\$IP/extensions/SemanticMediaWiki/SemanticMediaWiki.php\";"  >> LocalSettings.php
	echo "enableSemantics('localhost');" >> LocalSettings.php

#php maintenance/generateLocalAutoload.php

# fails:
# php maintenance/update.php


enter_running_container:
	$(eval TMP := $(shell docker ps | grep mediawiki | cut -d' ' -f1))
	docker exec -it $(TMP) /bin/bash

# container_id=`docker ps | grep mediawiki | cut -d' ' -f1`
# docker exec -it ${container_id} /bin/bash

