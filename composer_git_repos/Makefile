
.PHONY: help
help:
	@echo "make help"
	@echo "      this message"
	@echo "==== Targets outside container ===="
	@echo "make clean"
	@echo "make build_mw"
	@echo "make run_mw"


build_mw_with_composer:
	docker build -f Dockerfile -t mediawiki_git_wget .

run_mw_without_mariadb:
	docker run -it --rm mediawiki_git_wget:latest /bin/bash

# Initialization of MW to create LocalSettings.php
# for database config, see
# https://github.com/researcherben/mediawiki-in-docker/blob/main/screenshots_of_wiki/installation_20_dbconnect.png
first_compose:
	rm -rf db images stack_new.yml LocalSettings.php
	mkdir db
	mkdir images
	cat stack.yml | sed 's/.*\.\/LocalSettings.php.*//g'  > stack_new.yml
	docker-compose --file stack_new.yml  up --force-recreate


compose:
	docker-compose --file stack.yml  up --force-recreate

enter_mw_container:
	container_id=`docker ps | grep mediawiki | cut -d' ' -f1`
	docker exec -it $(container_id) /bin/bash
	# docker exec -it ${container_id} /bin/bash
