---
description: How to version Home Assistant add-ons following semantic versioning
---

# Versioning Rules for Home Assistant Add-ons

## Semantic Versioning (1.X.X)

Every change to an add-on MUST increment the version number following these rules:

### Version Format: `MAJOR.MINOR.PATCH`

- **MAJOR (1.x.x)**: Breaking changes that require user action or reconfiguration
- **MINOR (x.1.x)**: New features, significant improvements (backwards compatible)
- **PATCH (x.x.1)**: Bug fixes, small improvements, documentation updates

## Files to Update on Version Change

When changing the version, update ALL of these files:

1. **`config.yaml`** - Line: `version: "X.X.X"`
2. **`Dockerfile`** - Label: `io.hass.version="X.X.X"`
3. **`CHANGELOG.md`** - Add new section at top with date and changes

## Changelog Format

```markdown
## [X.X.X] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes to existing functionality

### Fixed
- Bug fixes

### Removed
- Removed features
```

## Example Workflow

// turbo-all

1. Make your code changes
2. Determine version increment (PATCH for fixes, MINOR for features)
3. Update version in `config.yaml`
4. Update version label in `Dockerfile`
5. Add changelog entry in `CHANGELOG.md`
6. Commit with message: `chore: bump version to X.X.X`
