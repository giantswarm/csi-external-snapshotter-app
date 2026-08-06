#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# root dir of the git repository
REPO_DIR=$(git rev-parse --show-toplevel) ; readonly REPO_DIR

# name of the app / helm chart
CHART_NAME="csi-external-snapshotter-app" ; readonly CHART_NAME

# name of the CRD dependency chart
CRD_CHART_NAME="csi-external-snapshotter-crds" ; readonly CRD_CHART_NAME

# root dir of the generated helm chart
CHART_DIR="${REPO_DIR}/helm/${CHART_NAME}" ; readonly CHART_DIR

# root dir of the CRD dependency chart
CRD_CHART_DIR="${CHART_DIR}/charts/${CRD_CHART_NAME}" ; readonly CRD_CHART_DIR

# root dir of the vendir synced upstream manifests
VENDIR_SYNC_DIR="${REPO_DIR}/vendor/external-snapshotter" ; readonly VENDIR_SYNC_DIR

# upstream version being synced, e.g. "v8.6.0". Read from the single pin in
# vendir.yml so no patch script has to hardcode it.
UPSTREAM_VERSION=$(yq -r '.directories[0].contents[0].git.ref' "${REPO_DIR}/vendir.yml")
readonly UPSTREAM_VERSION

# In-place sed that works with both GNU and BSD sed. BSD sed (macOS) requires an
# argument to -i, GNU sed requires that there is none, so neither spelling is
# portable; write to a temp file and move it back instead.
sedi() {
	local expr="${1}" ; shift
	local f
	for f in "$@"; do
		sed -E "${expr}" "${f}" >"${f}.sedtmp"
		mv "${f}.sedtmp" "${f}"
	done
}
