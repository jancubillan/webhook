.SHELLFLAGS := -eu -o pipefail -c
SHELL := /bin/bash

# Configuration variables (overridable via environment)
IMAGE_NAME  ?= webhook
DOCKER_USER ?=
IMAGE_REPO  ?= $(DOCKER_USER)/$(IMAGE_NAME)
COMMIT_SHA  ?= $(shell git rev-parse HEAD 2>/dev/null || echo "latest")
DOCKERFILE  ?= ./Dockerfile
CONTEXT     ?= .

.PHONY: help login setup-buildx build-push

help: ## Display available targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?##/ {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

login: ## Authenticate with Docker registry
	@if [ -z "$(DOCKER_USER)" ] || [ -z "$(DOCKER_PASS)" ]; then \
		echo "Error: DOCKER_USER and DOCKER_PASS must be set for login"; \
		exit 1; \
	fi
	@echo "$(DOCKER_PASS)" | docker login -u "$(DOCKER_USER)" --password-stdin

setup-buildx: ## Initialize Docker Buildx builder instance
	@docker buildx inspect builder >/dev/null 2>&1 || docker buildx create --name builder --use

build-push: ## Build container image and push latest + SHA tags
	@if [ -z "$(DOCKER_USER)" ]; then \
		echo "Error: DOCKER_USER must be set"; \
		exit 1; \
	fi
	docker buildx build \
		--file $(DOCKERFILE) \
		--tag $(IMAGE_REPO):latest \
		--tag $(IMAGE_REPO):$(COMMIT_SHA) \
		--push \
		$(CONTEXT)
