#!/usr/bin/with-contenv bash
# ==============================================================================
# Home Assistant Add-on: Heimdall Dashboard
# Configures environment variables from Home Assistant options
# This runs as a cont-init.d script BEFORE services start
# ==============================================================================

# Load bashio library
source /usr/lib/bashio/bashio.sh

bashio::log.info "Configuring Heimdall Dashboard from Home Assistant options..."

# ==============================================================================
# Read configuration from Home Assistant
# ==============================================================================
CONFIG_PATH="/data/options.json"

if [ -f "${CONFIG_PATH}" ]; then
    # Read configuration values with defaults
    PUID=$(bashio::config 'PUID' '1000')
    PGID=$(bashio::config 'PGID' '1000')
    TZ=$(bashio::config 'TZ' 'America/Chicago')
    ALLOW_INTERNAL_REQUESTS=$(bashio::config 'ALLOW_INTERNAL_REQUESTS' 'true')
    APP_NAME=$(bashio::config 'APP_NAME' 'Heimdall')

    bashio::log.info "Configuration loaded:"
    bashio::log.info "  PUID: ${PUID}"
    bashio::log.info "  PGID: ${PGID}"
    bashio::log.info "  Timezone: ${TZ}"
    bashio::log.info "  Allow Internal Requests: ${ALLOW_INTERNAL_REQUESTS}"
    bashio::log.info "  App Name: ${APP_NAME}"

    # Write environment to s6 container environment (for services to pick up)
    printf "%s" "${PUID}" > /run/s6/container_environment/PUID
    printf "%s" "${PGID}" > /run/s6/container_environment/PGID
    printf "%s" "${TZ}" > /run/s6/container_environment/TZ
    printf "%s" "${APP_NAME}" > /run/s6/container_environment/APP_NAME
    
    if [ "${ALLOW_INTERNAL_REQUESTS}" = "true" ]; then
        printf "true" > /run/s6/container_environment/ALLOW_INTERNAL_REQUESTS
    else
        printf "false" > /run/s6/container_environment/ALLOW_INTERNAL_REQUESTS
    fi

else
    bashio::log.warning "No configuration file found at ${CONFIG_PATH}, using defaults"
fi

bashio::log.info "Heimdall Dashboard configuration complete!"
