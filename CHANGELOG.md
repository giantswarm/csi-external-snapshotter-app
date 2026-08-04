# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Add team label in resources.
- Add toleration for new control-plane taint.
- Add `VolumeGroupSnapshot` CRDs (`groupsnapshot.storage.k8s.io`), which are part of upstream
  since `v8.0.0` and GA (`v1`) since `v8.6.0`.
- Add `seccompProfile`, `runAsNonRoot`, dropped capabilities and
  `allowPrivilegeEscalation: false` to the `crd-install` job, replacing the removed
  PodSecurityPolicy.
- Add resource requests and limits for `snapshot-controller`, configurable via
  `snapshotController.resources`.
- Add a pod and container `securityContext` to `snapshot-controller` (`runAsNonRoot`,
  uid/gid 65532, read-only root filesystem, dropped capabilities, `RuntimeDefault`
  seccomp profile), and soft pod anti-affinity across nodes for its two replicas.
- Add `ttlSecondsAfterFinished` to the `crd-install` job.

### Changed

- Change registry to `registry.k8s.io`.
- **Update upstream manifests to `v8.6.0`** (from `v5.0.1`). This requires Kubernetes 1.25 or
  newer.
- Restore the CircleCI config so tagged releases are packaged and pushed to
  `giantswarm-catalog` again. It was dropped after `v0.3.0`, meaning no release since then
  produced a chart.
- Bump `docker-kubectl` used by the `crd-install` job to `1.33.4`.
- Sync upstream manifests with a shallow clone and wipe `config/kustomize/input/` before
  copying, so manifests removed upstream no longer linger in the chart.
- Strip the API group from CRD file names for every group, not just
  `snapshot.storage.k8s.io`. Without this the `VolumeGroupSnapshot` CRDs ended up without a
  `.yaml` extension and were silently skipped by the `crd-install` job.

### Removed

- Remove the snapshot validation webhook (`Deployment`, `Service`,
  `ValidatingWebhookConfiguration`) along with its cert-manager `Issuer` and `Certificate`.
  Upstream deprecated it in `v8.0.0` and removed it in `v8.2.0`; its checks are now CEL
  validation rules in the CRDs. This also removes the cert-manager prerequisite and the
  `validationWebhook` values.
- Remove the `PodSecurityPolicy` from the `crd-install` hook and the `policy` API group from
  its RBAC. PSPs are gone since Kubernetes 1.25.

### Upgrade notes

- Upstream changed the `snapshot-controller` Deployment selector from `app` to
  `app.kubernetes.io/name`. `spec.selector` is immutable, so an in-place upgrade from
  `v0.3.0` fails with `field is immutable`; delete the existing `snapshot-controller`
  Deployment before upgrading.

## [0.3.0] - 2022-10-11

### Changed
- Fix `crd-install` job by using right folder name.
- Add new configuration interface to create default `VolumeSnapshotClass`.

## [0.2.0] - 2022-05-23

### Added

- Add validating webhook.
  
### Changed

- Update manifests with upstream `v5.0.1`.
- Use `kustomize` for templating upstream manifests without manual editing.

## [0.1.0] - 2022-04-25

- Initial implementation.

[Unreleased]: https://github.com/giantswarm/csi-external-snapshotter-app/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/giantswarm/csi-external-snapshotter-app/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/giantswarm/csi-external-snapshotter-app/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/giantswarm/csi-external-snapshotter-app/releases/tag/v0.1.0
