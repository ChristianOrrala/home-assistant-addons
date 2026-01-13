# Changelog

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
