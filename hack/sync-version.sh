#!/bin/bash

set -euox pipefail

cd "$(dirname "${0}")"
SYNC_BRANCH=${1:-"master"}

# create a temporary directory and checkout CAPO there
TMPDIR=$(mktemp -d)
pushd "${TMPDIR}"

git clone https://github.com/kubernetes-csi/external-snapshotter.git
pushd external-snapshotter

git checkout -d "${SYNC_BRANCH}"

# cd to tmpdir
popd

# cd to original path
popd

# copy upstream generated release-manifests into origin
cp -v -r "${TMPDIR}/external-snapshotter/client/config/crd" "../config/kustomize/input/"
cp -v -r "${TMPDIR}/external-snapshotter/deploy/kubernetes/snapshot-controller/" "../config/kustomize/input/"
cp -v -r "${TMPDIR}/external-snapshotter/deploy/kubernetes/webhook-example/" "../config/kustomize/input/"
