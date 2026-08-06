#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) ; readonly dir
cd "${dir}/.."

# test if requirements are installed
PROGRAMS=("vendir" "yq" "kustomize")
for program in "${PROGRAMS[@]}"; do
	if ! command -v "${program}" &>/dev/null; then
		echo "${program} not installed; aborting."
		exit 1
	fi
done

set -x
# fetch the upstream manifests pinned in vendir.yml
vendir sync
{ set +x; } 2>/dev/null

# patches
./sync/patches/chart/patch.sh
./sync/patches/values/patch.sh
./sync/patches/controller/patch.sh
./sync/patches/templates/patch.sh

# crds should always be last: it resolves CRD_VERSION_PLACEHOLDER in the chart's
# Chart.yaml, which the chart patch has to have written first, and it detects
# CRD changes by diffing the working tree against HEAD.
./sync/patches/crds/patch.sh

if ! git diff --quiet --exit-code helm/ ; then
	echo -e "\n---------- PRINTING GIT DIFF ----------\n"
	git diff helm/
fi
