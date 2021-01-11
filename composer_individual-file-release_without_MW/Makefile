
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
	docker run --rm --entrypoint cat mediawiki_that_has_composer /opt/ifr.tar > ifr.tar

# for IFR
run_mw_with_composer: clean build_mw_with_composer
	docker run -it -v`pwd`:/scratch -w /scratch --rm mediawiki_that_has_composer:latest /bin/bash


