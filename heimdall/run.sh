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
    if [ -n "${RESTORE_BACKUP}" ] && [ "${RESTORE_BACKUP}" != "null" ] && [ "${RESTORE_BACKUP}" != "" ]; then
        bashio::log.info "Backup restore requested: ${RESTORE_BACKUP}"
        
        # Extract just the filename if a full path was provided
        BACKUP_FILENAME=$(basename "${RESTORE_BACKUP}")
        
        # Check multiple possible locations
        BACKUP_FILE=""
        SEARCH_PATHS=(
            "/homeassistant/${BACKUP_FILENAME}"
            "/homeassistant/${RESTORE_BACKUP}"
            "/share/${BACKUP_FILENAME}"
            "/share/${RESTORE_BACKUP}"
            "${RESTORE_BACKUP}"
            "/homeassistant/shared/${BACKUP_FILENAME}"
            "/config/${BACKUP_FILENAME}"
            "/addon_configs/${BACKUP_FILENAME}"
        )
        
        bashio::log.info "Searching for backup file..."
        for path in "${SEARCH_PATHS[@]}"; do
            bashio::log.debug "  Checking: ${path}"
            if [ -f "${path}" ]; then
                BACKUP_FILE="${path}"
                bashio::log.info "  Found at: ${path}"
                break
            fi
        done

        if [ -n "${BACKUP_FILE}" ]; then
            bashio::log.info "Using backup file: ${BACKUP_FILE}"
            
            # Check if it's a zip file
            if [[ "${BACKUP_FILE}" == *.zip ]]; then
                bashio::log.info "Extracting backup..."
                
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
                
                # Extract to temporary directory first
                TEMP_DIR="/tmp/heimdall_restore_$$"
                mkdir -p "${TEMP_DIR}"
                bashio::log.info "Extracting to temporary directory..."
                unzip -o "${BACKUP_FILE}" -d "${TEMP_DIR}/" 2>&1 | head -10
                
                # Copy important files (database and storage)
                bashio::log.info "Restoring database and settings..."
                
                # Restore database if exists
                if [ -f "${TEMP_DIR}/www/app.sqlite" ]; then
                    cp -f "${TEMP_DIR}/www/app.sqlite" /config/www/app.sqlite 2>/dev/null || true
                    bashio::log.info "  ✓ Database restored"
                elif [ -f "${TEMP_DIR}/app.sqlite" ]; then
                    cp -f "${TEMP_DIR}/app.sqlite" /config/www/app.sqlite 2>/dev/null || true
                    bashio::log.info "  ✓ Database restored"
                fi
                
                # Restore storage folder (backgrounds, icons)
                if [ -d "${TEMP_DIR}/www/storage" ]; then
                    cp -rf "${TEMP_DIR}/www/storage/"* /config/www/storage/ 2>/dev/null || true
                    bashio::log.info "  ✓ Storage folder restored"
                elif [ -d "${TEMP_DIR}/storage" ]; then
                    cp -rf "${TEMP_DIR}/storage/"* /config/www/storage/ 2>/dev/null || true
                    bashio::log.info "  ✓ Storage folder restored"
                fi
                
                # Restore .env if exists (optional)
                if [ -f "${TEMP_DIR}/www/.env" ]; then
                    cp -f "${TEMP_DIR}/www/.env" /config/www/.env 2>/dev/null || true
                    bashio::log.info "  ✓ Environment file restored"
                fi
                
                # Cleanup temp directory
                rm -rf "${TEMP_DIR}"
                
                bashio::log.success "Backup restored successfully!"
                bashio::log.warning "IMPORTANT: Clear the 'restore_backup' option and restart to prevent re-extraction"
            else
                bashio::log.error "Backup file must be a .zip file"
            fi
        else
            bashio::log.error "Backup file not found!"
            bashio::log.info "Searched in: /share/, /config/, /addon_configs/"
            bashio::log.info ""
            bashio::log.info "To restore a backup:"
            bashio::log.info "  1. Upload your .zip file to the 'share' folder via File Editor or Samba"
            bashio::log.info "  2. In restore_backup, enter ONLY the filename: heimdall.zip"
            bashio::log.info "  3. Restart the add-on"
            bashio::log.info ""
            bashio::log.info "Listing /share folder contents:"
            ls -la /share/ 2>/dev/null || bashio::log.warning "/share folder not accessible"
        fi
    fi

else
    bashio::log.warning "No configuration file found at ${CONFIG_PATH}, using defaults"
fi

bashio::log.info "Heimdall Dashboard configuration complete!"
