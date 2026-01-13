# Heimdall Dashboard Add-on for Home Assistant

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Maintainer](https://img.shields.io/badge/Maintainer-Christian%20Orrala-green.svg)](https://github.com/ChristianOrrala)

A Home Assistant add-on by **Christian Orrala** that provides [Heimdall Dashboard](https://github.com/linuxserver/Heimdall) - an elegant application dashboard and launcher.

## Features

- 🔄 **Auto-Update**: Always pulls the latest Heimdall version on startup
- 💾 **Persistent Storage**: Configuration saved in `/addon_configs/heimdall`
- ⚙️ **Configurable Ports**: Customize HTTP/HTTPS ports
- 🌐 **Multi-Architecture**: Supports amd64, aarch64, armv7, i386
- 🏠 **Ingress Support**: Access directly from Home Assistant sidebar

## Installation

1. Add this repository to Home Assistant:
   - Go to **Settings** → **Add-ons** → **Add-on Store**
   - Click ⋮ (menu) → **Repositories**
   - Add: `https://github.com/ChristianOrrala/home-assistant-addons`

2. Find and install **Heimdall Dashboard**

3. Configure options as needed

4. Start the add-on

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| `PUID` | 1000 | User ID for file permissions |
| `PGID` | 1000 | Group ID for file permissions |
| `TZ` | America/Chicago | Timezone ([list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)) |
| `ALLOW_INTERNAL_REQUESTS` | true | Allow requests to internal/private IPs |
| `APP_NAME` | Heimdall | Application name shown in browser |
| `http_port` | 8080 | HTTP port |
| `https_port` | 8443 | HTTPS port |

## Access

After starting the add-on, access Heimdall at:

- **HTTP**: `http://<your-ha-ip>:8080`
- **HTTPS**: `https://<your-ha-ip>:8443`
- **Ingress**: Via Home Assistant sidebar

## Data Persistence

All data is stored in `/addon_configs/heimdall`:
- SQLite database
- Application icons
- Background images
- User settings

Data persists across add-on restarts and updates.

## Support

- [Heimdall GitHub](https://github.com/linuxserver/Heimdall)
- [LinuxServer.io Documentation](https://docs.linuxserver.io/images/docker-heimdall)

## Author

**Christian Orrala** - [@ChristianOrrala](https://github.com/ChristianOrrala)

## License

MIT License - Copyright (c) 2026 Christian Orrala
