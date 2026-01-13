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
    RESTORE_BACKUP=$(bashio::config 'restore_backup' '')

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

    # ==============================================================================
    # Restore backup if specified
    # ==============================================================================
    if [ -n "${RESTORE_BACKUP}" ] && [ "${RESTORE_BACKUP}" != "null" ]; then
        bashio::log.info "Backup restore requested: ${RESTORE_BACKUP}"
        
        # Check if file exists (could be in /share or absolute path)
        BACKUP_FILE=""
        if [ -f "${RESTORE_BACKUP}" ]; then
            BACKUP_FILE="${RESTORE_BACKUP}"
        elif [ -f "/share/${RESTORE_BACKUP}" ]; then
            BACKUP_FILE="/share/${RESTORE_BACKUP}"
        elif [ -f "/share/${RESTORE_BACKUP}.zip" ]; then
            BACKUP_FILE="/share/${RESTORE_BACKUP}.zip"
        fi

        if [ -n "${BACKUP_FILE}" ]; then
            bashio::log.info "Found backup file: ${BACKUP_FILE}"
            
            # Check if it's a zip file
            if [[ "${BACKUP_FILE}" == *.zip ]]; then
                bashio::log.info "Extracting backup to /config..."
                
                # Create backup of current config
                if [ -d "/config/www" ] || [ -f "/config/app.sqlite" ]; then
                    bashio::log.info "Backing up current configuration..."
                    BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
                    mkdir -p "/config/backups"
                    tar -czf "/config/backups/pre_restore_${BACKUP_DATE}.tar.gz" \
                        -C /config \
                        --exclude='backups' \
                        --exclude='keys' \
                        --exclude='nginx' \
                        --exclude='log' \
                        --exclude='php' \
                        . 2>/dev/null || true
                    bashio::log.info "Current config backed up to /config/backups/pre_restore_${BACKUP_DATE}.tar.gz"
                fi
                
                # Extract the backup
                unzip -o "${BACKUP_FILE}" -d /config/ 2>&1 | head -20
                
                bashio::log.success "Backup restored successfully!"
                bashio::log.warning "IMPORTANT: Clear the 'restore_backup' option after restart to prevent re-extraction"
            else
                bashio::log.error "Backup file must be a .zip file"
            fi
        else
            bashio::log.error "Backup file not found: ${RESTORE_BACKUP}"
            bashio::log.info "Place your backup.zip file in the /share folder and use just the filename"
            bashio::log.info "Example: restore_backup: 'heimdall_backup.zip'"
        fi
    fi

else
    bashio::log.warning "No configuration file found at ${CONFIG_PATH}, using defaults"
fi

bashio::log.info "Heimdall Dashboard configuration complete!"
