##@ App

SHELL := /bin/bash

.PHONY: sync
sync: ## Sync the upstream manifests pinned in vendir.yml into the helm chart
	./sync/sync.sh
