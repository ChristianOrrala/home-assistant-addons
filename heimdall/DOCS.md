# Heimdall Dashboard

## Configuration

### PUID / PGID

These values are used for file permission management. Set them to match the user/group IDs on your system. Default is `1000` for both.

To find your IDs, run `id` in a terminal.

### TZ (Timezone)

Set your local timezone. Examples:
- `America/New_York`
- `Europe/London`
- `Asia/Tokyo`
- `Etc/UTC` (default)

See [timezone list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for all options.

### ALLOW_INTERNAL_REQUESTS

When set to `true`, Heimdall can make requests to internal/private IP addresses. This is required for:
- Accessing other containers on your network
- Checking status of local services
- Using internal URLs in application cards

### APP_NAME

The name displayed in the browser tab and header. Default is "Heimdall".

### HTTP Port / HTTPS Port

Configure which ports Heimdall uses:
- **http_port**: Default `8080`
- **https_port**: Default `8443`

Make sure these ports are not used by other services.

## Data Storage

All configuration is stored in `/addon_configs/heimdall`:
- Database (SQLite)
- Application icons
- Background images
- User settings

This data persists across add-on restarts and updates.
