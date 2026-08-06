#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) ; readonly SCRIPT_DIR
source "${SCRIPT_DIR}"/../../_helpers.sh

echo "Updating Chart.yaml"

# The chart version is owned by the release tooling, not by this sync: preserve
# whatever is currently committed. `.abs/main.yaml` sets
# replace-chart-version-with-git, so the value here only matters for local
# `helm template`/`helm lint` runs -- but it has to be valid semver for those to
# work at all.
CURRENT_CHART_VERSION=$(yq -r '.version // "0.0.0"' "${CHART_DIR}/Chart.yaml" 2>/dev/null || echo "0.0.0")
case "${CURRENT_CHART_VERSION}" in
	"" | "null" | *"[["*) CURRENT_CHART_VERSION="0.0.0" ;;
esac

cp "${SCRIPT_DIR}/manifests/Chart.yaml" "${CHART_DIR}/Chart.yaml"

sedi "s|APP_VERSION_PLACEHOLDER|${UPSTREAM_VERSION}|g" "${CHART_DIR}/Chart.yaml"
sedi "s|CHART_VERSION_PLACEHOLDER|${CURRENT_CHART_VERSION}|g" "${CHART_DIR}/Chart.yaml"
