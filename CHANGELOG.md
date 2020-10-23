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
