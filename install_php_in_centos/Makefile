
.PHONY: help
help:
	@echo "make help"
	@echo "      this message"
	@echo "==== Targets outside container ===="
	@echo "make clean"
	@echo "make build_mw"
	@echo "make run_mw"


build_php:
	docker build -t php_composer .

run_php: build_php
	docker run -it -v`pwd`:/scratch -w /scratch --rm php_composer:latest /bin/bash

