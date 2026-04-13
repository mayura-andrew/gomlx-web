# GoMLX documentation site — Makefile
# Usage: make <target>

HUGO        := hugo
BRANCH      := main
SYNC_SCRIPT := scripts/sync-docs.sh

.PHONY: help dev build sync sync-tag clean

help:
	@echo ""
	@echo "  GoMLX docs site commands:"
	@echo ""
	@echo "  make dev        — start local Hugo dev server (hot reload)"
	@echo "  make build      — build production site to ./public/"
	@echo "  make sync       — pull latest docs from gomlx/gomlx main branch"
	@echo "  make sync-tag   — pull docs from a specific tag: make sync-tag TAG=v0.17.0"
	@echo "  make clean      — remove ./public/ build output"
	@echo ""

dev:
	$(HUGO) server --disableFastRender --buildDrafts

build:
	$(HUGO) --minify

sync:
	@chmod +x $(SYNC_SCRIPT)
	@$(SYNC_SCRIPT) $(BRANCH)

sync-tag:
	@if [ -z "$(TAG)" ]; then echo "Usage: make sync-tag TAG=v0.17.0"; exit 1; fi
	@chmod +x $(SYNC_SCRIPT)
	@$(SYNC_SCRIPT) $(TAG)

clean:
	rm -rf public/

# Full workflow: build
all: build
