#!/bin/bash

set -euox pipefail

# ${1} is the given application-name from make (csi-external-snapshotter-app)

# As we apply the CRDs via configmap, the file name must be stripped to be RFC 1123
# conform (lower case alphanumeric characters or '-', and must start and end with an
# alphanumeric character). Kustomize writes CRDs as
#   apiextensions.k8s.io_v1_customresourcedefinition_<plural>.<group>.yaml
# and we only keep the <plural> part, so both snapshot.storage.k8s.io and
# groupsnapshot.storage.k8s.io CRDs end up as <plural>.yaml.
find config/kustomize/tmp/ -name "apiextensions.k8s.io_v1_customresourcedefinition_*" | while read -r f; do
	filename=$(basename "${f}")
	crd_name=${filename#apiextensions.k8s.io_v1_customresourcedefinition_}
	mv -v "${f}" "helm/${1}/files/${crd_name%%.*}.yaml"
done

# move everything from current tmp workdir over to helm
mv -v config/kustomize/tmp/* "helm/${1}/templates"
