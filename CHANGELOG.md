# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.3] - 2025-05-08

### Fixed
- Fixed issue with command-line interface not recognizing database configuration options

## [0.2.2] - 2025-05-08

### Fixed
- Fixed issue with database configuration options not being included in the package

## [0.2.1] - 2025-05-08

### Fixed
- Fixed issue with TestPyPI package upload

## [0.2.0] - 2025-05-08

### Added
- Interactive configuration system for database paths
- JSON-based configuration file format (replacing YAML)
- Environment variable detection for PostgreSQL settings
- New command-line arguments for database paths:
  - `--sqlite-path`: Path to the SQLite WordNet database
  - `--postgres-host`: PostgreSQL server hostname
  - `--postgres-port`: PostgreSQL server port
  - `--postgres-db`: PostgreSQL database name
- New `--configure` flag to run the configuration wizard
- First-run detection with automatic configuration prompt
- Configuration confirmation on subsequent runs

### Changed
- Improved security by never storing PostgreSQL credentials in configuration files
- Configuration file format changed from YAML to JSON
- Backward compatibility with legacy YAML configuration files
- Updated help text with new command-line options
- Improved error handling for configuration-related operations

### Deprecated
- YAML configuration format (automatically converted to JSON)

### Fixed
- Fixed potential issues with PostgreSQL credential handling

## [0.1.0] - 2025-05-04

### Added
- Initial release of WordNet Porter
- Command-line interface for migrating WordNet SQLite database to PostgreSQL
- Step-by-step migration process with detailed logging
- Configuration system with YAML-based configuration files
- Support for running specific steps or ranges of steps
- Comprehensive documentation including installation, usage, and development guides
- GitHub Actions workflow for CI/CD
- Test suite for configuration module
- Example script for basic migration

### Changed
- N/A (initial release)

### Deprecated
- N/A (initial release)

### Removed
- N/A (initial release)

### Fixed
- N/A (initial release)

### Security
- N/A (initial release)
