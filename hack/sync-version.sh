#!/bin/bash

set -euox pipefail

cd "$(dirname "${0}")"
SYNC_BRANCH=${1:-"master"}

INPUT_DIR="../config/kustomize/input"

# create a temporary directory and check out external-snapshotter there
TMPDIR=$(mktemp -d)
git clone --depth 1 --branch "${SYNC_BRANCH}" \
	https://github.com/kubernetes-csi/external-snapshotter.git \
	"${TMPDIR}/external-snapshotter"

# drop anything left over from a previous sync, otherwise manifests that were
# removed upstream keep being rendered into the chart
for dir in "${INPUT_DIR}"/crd "${INPUT_DIR}"/snapshot-controller; do
	find "${dir}" -mindepth 1 ! -name ".gitignore" -delete
done

# copy upstream generated release-manifests into origin
cp -v -r "${TMPDIR}/external-snapshotter/client/config/crd" "${INPUT_DIR}/"
cp -v -r "${TMPDIR}/external-snapshotter/deploy/kubernetes/snapshot-controller/" "${INPUT_DIR}/"

rm -rf "${TMPDIR}"
