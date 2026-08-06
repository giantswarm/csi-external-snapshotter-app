#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) ; readonly SCRIPT_DIR
source "${SCRIPT_DIR}"/../../_helpers.sh

echo "Copying the hand-written Giant Swarm templates into the chart"

# These are ours, not upstream's. They live under sync/ so that the generated
# chart has a single source of truth, and in subdirectories of templates/ so the
# controller patch's top-level wipe does not remove them.
rm -rf "${CHART_DIR}/templates/gs" "${CHART_DIR}/templates/crd-adopt"
cp -R "${SCRIPT_DIR}/manifests/." "${CHART_DIR}/templates/"
