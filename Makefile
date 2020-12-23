
.PHONY: help
help:
	@echo "make help"
	@echo "      this message"
	@echo "==== Targets outside container ===="
	@echo "make build_mw"
	@echo "make run_mw"


# outside the container
build_mw:
	docker build -t mediawiki_composer .

run_mw: build_mw
	docker run -it -v`pwd`:/scratch -w /scratch --rm mediawiki_composer:latest /bin/bash

