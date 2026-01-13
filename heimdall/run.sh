#!/usr/bin/with-contenv bash
# ==============================================================================
# Home Assistant Add-on: Heimdall Dashboard
# Starts Heimdall Dashboard with configuration from Home Assistant
# ==============================================================================

set -e

# Load bashio library
source /usr/lib/bashio/bashio.sh

bashio::log.info "Starting Heimdall Dashboard Add-on..."

# ==============================================================================
# Read configuration from Home Assistant
# ==============================================================================
CONFIG_PATH="/data/options.json"

# Read configuration values
PUID=$(bashio::config 'PUID')
PGID=$(bashio::config 'PGID')
TZ=$(bashio::config 'TZ')
ALLOW_INTERNAL_REQUESTS=$(bashio::config 'ALLOW_INTERNAL_REQUESTS')
APP_NAME=$(bashio::config 'APP_NAME')
HTTP_PORT=$(bashio::config 'http_port')
HTTPS_PORT=$(bashio::config 'https_port')

bashio::log.info "Configuration loaded:"
bashio::log.info "  PUID: ${PUID}"
bashio::log.info "  PGID: ${PGID}"
bashio::log.info "  Timezone: ${TZ}"
bashio::log.info "  Allow Internal Requests: ${ALLOW_INTERNAL_REQUESTS}"
bashio::log.info "  App Name: ${APP_NAME}"
bashio::log.info "  HTTP Port: ${HTTP_PORT}"
bashio::log.info "  HTTPS Port: ${HTTPS_PORT}"

# ==============================================================================
# Setup persistent data directory
# ==============================================================================
DATA_DIR="/addon_configs/heimdall"

if [ ! -d "${DATA_DIR}" ]; then
    bashio::log.info "Creating data directory: ${DATA_DIR}"
    mkdir -p "${DATA_DIR}"
fi

# Create symlink from Heimdall's default config location to our persistent storage
if [ ! -L "/config" ] || [ "$(readlink /config)" != "${DATA_DIR}" ]; then
    bashio::log.info "Linking /config to ${DATA_DIR}"
    rm -rf /config 2>/dev/null || true
    ln -sf "${DATA_DIR}" /config
fi

# Ensure proper permissions
chown -R "${PUID}:${PGID}" "${DATA_DIR}" 2>/dev/null || true

# ==============================================================================
# Export environment variables for Heimdall
# ==============================================================================
export PUID="${PUID}"
export PGID="${PGID}"
export TZ="${TZ}"
export APP_NAME="${APP_NAME}"

# Convert boolean to string for Heimdall
if [ "${ALLOW_INTERNAL_REQUESTS}" = "true" ]; then
    export ALLOW_INTERNAL_REQUESTS="true"
else
    export ALLOW_INTERNAL_REQUESTS="false"
fi

# ==============================================================================
# Update Nginx port configuration if needed
# ==============================================================================
NGINX_CONF="/etc/nginx/nginx.conf"
if [ -f "${NGINX_CONF}" ]; then
    bashio::log.info "Configuring Nginx ports..."
    sed -i "s/listen 80;/listen ${HTTP_PORT};/g" "${NGINX_CONF}" 2>/dev/null || true
    sed -i "s/listen 443/listen ${HTTPS_PORT}/g" "${NGINX_CONF}" 2>/dev/null || true
fi

# ==============================================================================
# Start Heimdall
# ==============================================================================
bashio::log.info "Starting Heimdall Dashboard..."
bashio::log.info "Access the dashboard at: http://homeassistant.local:${HTTP_PORT}"

# Execute the original LinuxServer.io init system
exec /init
