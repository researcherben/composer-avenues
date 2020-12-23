
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
	rm -rf mediawiki

build_mw:
	docker build -t mediawiki_composer .

run_mw: clean build_mw
	mkdir mediawiki
	cp composer.json mediawiki
	docker run -it -v`pwd`:/scratch -w /scratch --rm mediawiki_composer:latest /bin/bash

