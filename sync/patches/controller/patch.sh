#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) ; readonly SCRIPT_DIR
source "${SCRIPT_DIR}"/../../_helpers.sh

echo "Rendering the snapshot-controller manifests into the chart"

cd "${REPO_DIR}"

# Upstream ships plain manifests rather than a chart, so a kustomize overlay does
# the Helm-ification: it injects `{{ .Release.Namespace }}` and the
# `{{ .Values.snapshotController.* }}` references, applies the Giant Swarm
# securityContext/affinity/resources patch, and splits the two upstream files
# into one template per resource.
#
# Only files at the top level of templates/ are generated -- everything
# hand-written lives in a subdirectory (see sync/patches/templates) so this wipe
# cannot eat it.
find "${CHART_DIR}/templates" -maxdepth 1 -type f -name "*.yaml" -delete

kustomize build "${REPO_DIR}/sync/kustomize" -o "${CHART_DIR}/templates"
