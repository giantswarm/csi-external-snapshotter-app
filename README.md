[![CircleCI](https://circleci.com/gh/giantswarm/csi-external-snapshotter-app.svg?style=shield)](https://circleci.com/gh/giantswarm/csi-external-snapshotter-app)

# CSI External Snapshotter

To be able to create volume snapshots with Cinder CSI, we need to install CRDs and snapshot controller. See
https://github.com/kubernetes/cloud-provider-openstack/blob/989d067f62c24338d3f41b295fd3510b76182fde/docs/cinder-csi-plugin/features.md#volume-snapshots


The source of the files in this repo
- https://github.com/kubernetes-csi/external-snapshotter/tree/041cd4674149a30cdc53a98a3fd7d343b9fd90eb/client/config/crd 
- https://github.com/kubernetes-csi/external-snapshotter/tree/041cd4674149a30cdc53a98a3fd7d343b9fd90eb/deploy/kubernetes/snapshot-controller
