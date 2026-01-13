# Changelog

## [1.1.3] - 2026-01-12

### Fixed
- Fixed "Read-only file system" error during backup restore
- Now extracts to temp folder first, then copies only essential files
- Restores: database (app.sqlite), storage folder (backgrounds/icons), .env file

## [1.1.2] - 2026-01-12

### Added
- Added `/homeassistant/` folder mapping for backup file access
- Backup can now be placed directly in the Home Assistant config folder

### Changed
- `/homeassistant/<filename>` is now checked first when searching for backups

## [1.1.1] - 2026-01-12

### Fixed
- Improved backup file search - now checks multiple locations automatically
- Extracts filename from full path if user enters complete path
- Better error messages with instructions when backup not found

## [1.1.0] - 2026-01-12

### Added
- **Backup restore feature**: New `restore_backup` configuration option
- Mapped `/share` folder for easy backup file access
- Automatic backup of current config before restore

## [1.0.3] - 2026-01-12

### Fixed
- Fixed port mapping (80/443 internal → 8080/8443 external)

## [1.0.2] - 2026-01-12

### Fixed
- Fixed s6-overlay cont-init.d integration

## [1.0.1] - 2026-01-12

### Fixed
- Fixed s6-overlay startup issues

## [1.0.0] - 2026-01-12

### Added
- Initial release with Heimdall Dashboard integration
