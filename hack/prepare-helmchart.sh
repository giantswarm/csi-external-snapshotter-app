#!/bin/bash

set -x 

# ${1} is the given application-name from make (csi-external-snapshotter-app)

# as we apply the crd via configmap, name must be stripped to be RFC 1123 conform
# (lower case alphanumeric characters or '-', and must start and end with an alphanumeric character)
find config/kustomize/tmp/ -regex ".*apiextensions.k8s.io_v1_customresourcedefinition.*" | while read f; do
	filename=$(basename ${f})
	mv -v config/kustomize/tmp/${filename} helm/${1}/files/${filename/apiextensions.k8s.io_v1_customresourcedefinition_/}
done

find helm/${1}/files/ -regex ".*snapshot.storage.k8s.io.yaml" | while read f; do
    mv -v ${f} ${f/snapshot.storage.k8s.io./}
done

# move everything from current tmp workdir over to helm
mv -v config/kustomize/tmp/* helm/${1}/templates
