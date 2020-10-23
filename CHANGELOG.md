# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.3] - 2020-10-23

### Fixed

- Fix terraform 0.13 error regarding destroy-time provisioners referencing attributes
  other than self. Root modules upgrading from 0.12 to 0.13 and beyond will have to perform
  a `terraform state rm module.<name>` in order reconcile this issue.

### Changed

- Remove install template as a trigger for destroying and installing swagger since there
  is no need to reinstall swagger if only the install template changed

## [1.0.2] - 2020-08-08

### Changed

- Update README for clarification

## [1.0.1] - 2020-06-11

### Fixed

- Fix installation with Linux by replacing CRLF with LF for every file

## [1.0.0] - 2020-01-04

### Added

- Initial release. Add functionality to install swagger ui to an AWS S3 bucket

[unreleased]: https://github.com/whitebread-cloud/terraform-aws-s3-swagger-ui/compare/v1.0.0...HEAD
[1.0.3]: https://github.com/whitebread-cloud/terraform-aws-s3-swagger-ui/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/whitebread-cloud/terraform-aws-s3-swagger-ui/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/whitebread-cloud/terraform-aws-s3-swagger-ui/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/whitebread-cloud/terraform-aws-s3-swagger-ui/releases/tag/v1.0.0
