# Changelog

## [1.1.1] - 2026-01-12

### Fixed
- Improved backup file search - now checks multiple locations automatically
- Extracts filename from full path if user enters complete path
- Better error messages with instructions when backup not found
- Lists /share folder contents to help troubleshoot

## [1.1.0] - 2026-01-12

### Added
- **Backup restore feature**: New `restore_backup` configuration option to restore Heimdall data from a .zip backup file
- Mapped `/share` folder for easy backup file access
- Automatic backup of current config before restore
- User-friendly error messages for backup restore

### Changed
- Version bump to 1.1.0 (minor version for new feature)

## [1.0.3] - 2026-01-12

### Fixed
- Fixed port mapping - Heimdall uses ports 80/443 internally, now correctly mapped to 8080/8443 externally
- Fixed ingress port configuration

## [1.0.2] - 2026-01-12

### Fixed
- Fixed /config directory conflict - no longer tries to modify linuxserver's config mount
- Changed to cont-init.d script approach for proper s6-overlay integration
- Environment variables now set before any services start
- Added default values for configuration options

## [1.0.1] - 2026-01-12

### Fixed
- Fixed s6-overlay integration for proper container startup
- Changed entrypoint to use s6 service system instead of replacing init
- Environment variables now properly passed to s6 container environment

## [1.0.0] - 2026-01-12

### Added
- Initial release
- Heimdall Dashboard integration with Home Assistant
- Configurable HTTP/HTTPS ports
- Environment variables: PUID, PGID, TZ, ALLOW_INTERNAL_REQUESTS, APP_NAME
- Spanish and English translations
- Ingress support for Home Assistant sidebar access
