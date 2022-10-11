# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
