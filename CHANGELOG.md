# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Major update of the app and giant swarm CI tooling around it.
- Update upstream manifests to v8.6.0.
- Pin the upstream version with `vendir` (`vendir.yml` / `vendir.lock.yml`) and generate the chart
  through `sync/sync.sh` (`make sync`), following the same layout as `giantswarm/whereabouts`.
  `appVersion`, the upstream-chart-version annotation and `snapshotController.tag` are now derived
  from the single `ref` in `vendir.yml`.

### Changed

- **Breaking:** the CRDs are now installed as the `csi-external-snapshotter-crds` dependency chart
  instead of by a `kubectl apply` hook job, so Helm renders, diffs and upgrades them like any other
  resource. They are annotated `helm.sh/resource-policy: keep` and so still survive `helm uninstall`.
  Existing clusters have CRDs without Helm ownership metadata, which would make `helm upgrade` fail
  with `invalid ownership metadata`; the new `crd-adopt` pre-install/pre-upgrade hook fixes that
  automatically. It is a no-op on a fresh install and can be removed once every cluster has been
  through a 0.4.0 or later release.
- **Breaking:** `crds.resources` moved to `crds.adopt.resources`, and now sizes the much smaller
  adoption hook rather than the removed CRD-install job.
- Chart moved to `apiVersion: v2` (required to declare the CRD chart as a dependency) and its
  `version` is a real semver value rather than `[[ .Version ]]`, so `helm lint` and `helm template`
  work against the repo. The published version is still set at build time by app-build-suite.

### Removed

- The `crd-install` hook job, its per-CRD ConfigMaps, ServiceAccount, ClusterRole/Binding and
  NetworkPolicy, along with `helm/csi-external-snapshotter-app/files/`.
- `config/kustomize/input/` (replaced by `vendir`), `hack/sync-version.sh` and
  `hack/prepare-helmchart.sh`. The `all`, `fetch-upstream-manifest`, `apply-kustomize-patches`,
  `delete-generated-helm-charts` and `release-manifests` make targets are replaced by `make sync`.
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
