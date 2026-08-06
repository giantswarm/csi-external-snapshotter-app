#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) ; readonly SCRIPT_DIR
source "${SCRIPT_DIR}"/../../_helpers.sh

echo "Updating values.yaml and values.schema.json"

# Upstream ships no values file, so these are ours wholesale rather than a patch
# on top of an upstream one.
cp "${SCRIPT_DIR}/manifests/values.yaml" "${CHART_DIR}/values.yaml"
cp "${SCRIPT_DIR}/manifests/values.schema.json" "${CHART_DIR}/values.schema.json"

# the controller image tag follows the upstream pin in vendir.yml
sedi "s|IMAGE_TAG|${UPSTREAM_VERSION}|g" "${CHART_DIR}/values.yaml"
