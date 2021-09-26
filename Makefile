MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c

DOCKER := docker
DOCKER_COMPOSE := docker-compose

-include .env
-include docker/.env
-include docker/.env.local
export

export PUID ?= $(shell id -u)
export PGID ?= $(shell id -g)

all: help
.PHONY: all

help:
	@echo -e "\033[0;32m Usage: make [target] "
	@echo
	@echo -e "\033[1m targets:\033[0m"
	@egrep '^(.+):*\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'
.PHONY: help

build: ## Builds the development service
	$(DOCKER) build -t certbot-wildcard-ionos .
.PHONY: build

dry-run:
	$(DOCKER) run -i --rm -v $(PWD)/certs:/etc/letsencrypt -e "API_KEY=$(API_KEY)" certbot-wildcard-ionos certonly --dry-run --keep-until-expiring --preferred-challenges dns --non-interactive --agree-tos -m post@nkante.de --manual --manual-auth-hook /tmp/scripts/authenticate.sh --manual-cleanup-hook /tmp/scripts/cleanup.sh -d *.$(DOMAIN)
.PHONY: dry-run
run: ## build certs for *.$(DOMAIN)
	$(DOCKER) run -i --rm -v $(PWD)/certs:/etc/letsencrypt -e "API_KEY=$(API_KEY)" certbot-wildcard-ionos certonly --keep-until-expiring --preferred-challenges dns --non-interactive --agree-tos -m post@nkante.de --manual --manual-auth-hook /tmp/scripts/authenticate.sh --manual-cleanup-hook /tmp/scripts/cleanup.sh -d *.$(DOMAIN)
.PHONY: run-nkante-me