# Makefile — shiki-pddl
# Semver release helpers: tag inspection, patch bump, npm publish.

SHELL := /bin/bash
.DEFAULT_GOAL := help

PKG_NAME := $(shell node -p "require('./package.json').name")

# Latest semver tag (vX.Y.Z). Empty if none.
LATEST_TAG := $(shell git tag --list 'v[0-9]*.[0-9]*.[0-9]*' --sort=-v:refname | head -n1)

# Next patch = LATEST_TAG with Z+1. Fallback v0.0.1 if no tag.
NEXT_PATCH_TAG := $(shell \
	if [ -z "$(LATEST_TAG)" ]; then \
		echo "v0.0.1"; \
	else \
		echo "$(LATEST_TAG)" | awk -F. -v OFS=. '{ sub(/^v/,"",$$1); $$3+=1; print "v"$$0 }'; \
	fi)

NEXT_VERSION := $(patsubst v%,%,$(NEXT_PATCH_TAG))

.PHONY: help latest-tag next-patch tag-patch build publish release clean

help: ## Show targets
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk -F':.*?## ' '{printf "  %-16s %s\n", $$1, $$2}'

latest-tag: ## Print latest semver git tag
	@echo "$(LATEST_TAG)"

next-patch: ## Print next patch tag (no write)
	@echo "$(NEXT_PATCH_TAG)"

tag-patch: ## Bump package.json + git tag + push
	@if [ -n "$$(git status --porcelain)" ]; then \
		echo "Working tree dirty. Commit/stash first."; exit 1; \
	fi
	npm version $(NEXT_VERSION) -m "chore(release): %s"
	git push
	git push --tags

build: ## Build dist/
	npm run build

publish: build ## Publish to npm (public access)
	npm publish --access public

release: tag-patch publish ## Full flow: bump tag, push, publish

clean: ## Remove build artifacts
	rm -rf dist
