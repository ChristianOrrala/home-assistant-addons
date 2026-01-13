#!/usr/bin/env bash
# ==============================================================================
# Home Assistant Add-on: Heimdall Dashboard
# Configures environment variables from Home Assistant options
# ==============================================================================

# Load bashio library
source /usr/lib/bashio/bashio.sh

bashio::log.info "Configuring Heimdall Dashboard from Home Assistant options..."

# ==============================================================================
# Read configuration from Home Assistant
# ==============================================================================
CONFIG_PATH="/data/options.json"

if [ -f "${CONFIG_PATH}" ]; then
    # Read configuration values
    PUID=$(bashio::config 'PUID')
    PGID=$(bashio::config 'PGID')
    TZ=$(bashio::config 'TZ')
    ALLOW_INTERNAL_REQUESTS=$(bashio::config 'ALLOW_INTERNAL_REQUESTS')
    APP_NAME=$(bashio::config 'APP_NAME')

    bashio::log.info "Configuration loaded:"
    bashio::log.info "  PUID: ${PUID}"
    bashio::log.info "  PGID: ${PGID}"
    bashio::log.info "  Timezone: ${TZ}"
    bashio::log.info "  Allow Internal Requests: ${ALLOW_INTERNAL_REQUESTS}"
    bashio::log.info "  App Name: ${APP_NAME}"

    # Export environment variables for Heimdall
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

    # Write environment to s6 container environment
    mkdir -p /run/s6/container_environment
    echo "${PUID}" > /run/s6/container_environment/PUID
    echo "${PGID}" > /run/s6/container_environment/PGID
    echo "${TZ}" > /run/s6/container_environment/TZ
    echo "${APP_NAME}" > /run/s6/container_environment/APP_NAME
    echo "${ALLOW_INTERNAL_REQUESTS}" > /run/s6/container_environment/ALLOW_INTERNAL_REQUESTS
else
    bashio::log.warning "No configuration file found at ${CONFIG_PATH}, using defaults"
fi

# ==============================================================================
# Setup persistent data directory
# ==============================================================================
DATA_DIR="/data/heimdall"

if [ ! -d "${DATA_DIR}" ]; then
    bashio::log.info "Creating data directory: ${DATA_DIR}"
    mkdir -p "${DATA_DIR}"
fi

# Link Heimdall config to persistent storage
if [ -d "/config" ] && [ ! -L "/config" ]; then
    bashio::log.info "Moving existing config to ${DATA_DIR}"
    cp -rn /config/* "${DATA_DIR}/" 2>/dev/null || true
    rm -rf /config
fi

if [ ! -L "/config" ]; then
    bashio::log.info "Linking /config to ${DATA_DIR}"
    ln -sf "${DATA_DIR}" /config
fi

bashio::log.info "Heimdall Dashboard configuration complete!"
