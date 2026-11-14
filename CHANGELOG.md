# Changelog

## [1.0.1](https://github.com/MapColonies/geoserver/compare/v1.0.0...v1.0.1) (2026-11-14)


### Bug Fixes

* **ci:** build docker image with index.mjs ([#10](https://github.com/MapColonies/geoserver/issues/10)) ([3fa3f5e](https://github.com/MapColonies/geoserver/commit/3fa3f5e949bdb3a5e3a10fac64ab71fbcd3c831f))

## [1.0.0](https://github.com/MapColonies/geoserver/compare/v1.0.0...v1.0.0) (2026-11-14)


### ⚠ BREAKING CHANGES

* GeoServer 3.0 moves to Java 21 and Tomcat 11 (Jakarta EE). The data_dir migration is one-way -- once 3.0.1 rewrites the catalog, 2.27 may not be able to read it back. Back up the data dir before deploying.

### Features

* add project labels and annotations convention([#5](https://github.com/MapColonies/geoserver/issues/5)) ([ff7dbca](https://github.com/MapColonies/geoserver/commit/ff7dbcab73fa07a5562c036e57b64c636de86a96))
* update geoserver ([#4](https://github.com/MapColonies/geoserver/issues/4)) ([a701bd9](https://github.com/MapColonies/geoserver/commit/a701bd947a66db879517b00a2843ccbe9dbe9be9))
* upgrade geoserver to 3.0.1 ([109acde](https://github.com/MapColonies/geoserver/commit/109acde5eed85bd130e6f4102cac5f1e8de118ba))
* upgrade geoserver to 3.0.1 ([b306b2d](https://github.com/MapColonies/geoserver/commit/b306b2dd3f0041db1443cb6ca155742af317633b))
* upgraded to 2.26 geoserver version ([#1](https://github.com/MapColonies/geoserver/issues/1)) ([7690d10](https://github.com/MapColonies/geoserver/commit/7690d101f381a5a11f6c0f90881edbb3238e046e))


### Bug Fixes

* point chart at vector/geoserver-os (MAPCO-9312) ([39293a1](https://github.com/MapColonies/geoserver/commit/39293a1a8398967f9059a387f13b19dbe61cf296))
