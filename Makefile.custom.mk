##@ App

SHELL := /bin/bash

EXTERNAL_SNAPSHOTTER_VERSION="v5.0.1"

.PHONY: all
all: fetch-upstream-manifest apply-kustomize-patches delete-generated-helm-charts release-manifests ## Builds the manifests to publish with a release (alias to release-manifests)

.PHONY: release-manifests
release-manifests: 
	# move files from workdir over to helm directury structure
	./hack/prepare-helmchart.sh ${APPLICATION}

.PHONY: fetch-upstream-manifest
fetch-upstream-manifest: ## fetch upstream manifest from
	# fetch upstream released manifest yaml
	./hack/sync-version.sh ${EXTERNAL_SNAPSHOTTER_VERSION}

.PHONY: apply-kustomize-patches
apply-kustomize-patches: ## apply giantswarm specific patches
	kubectl kustomize config/kustomize -o config/kustomize/tmp

#.PHONY: delete-generated-helm-charts
delete-generated-helm-charts: # clean workspace and delete manifests
	@rm -rvf ./helm/${APPLICATION}/templates/*.yaml
	@rm -rvf ./helm/${APPLICATION}/files/*.yaml
