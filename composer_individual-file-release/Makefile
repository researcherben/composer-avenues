
.PHONY: help
help:
	@echo "make help"
	@echo "      this message"
	@echo "==== Targets outside container ===="
	@echo "make clean"
	@echo "make build_mw"
	@echo "make run_mw"


# outside the container
clean:
	rm -rf ifr

# for IFR
build_mw_with_composer:
	docker build -f Dockerfile.MW_with_composer -t mediawiki_that_has_composer .

# for IFR
run_mw_with_composer: clean build_mw_with_composer
	mkdir -p ifr
	docker run -it -v`pwd`:/scratch -w /scratch --rm mediawiki_that_has_composer:latest /bin/bash


# Initialization of MW to create LocalSettings.php
# for database config, see
# https://github.com/researcherben/mediawiki-in-docker/blob/main/screenshots_of_wiki/installation_20_dbconnect.png
first_compose: 
	rm -rf db images stack_new.yml
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