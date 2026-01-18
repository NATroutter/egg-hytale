#!/bin/bash
source "/egg-hytale/lib/utilities.sh"
source "/egg-hytale/lib/authentication.sh"
source "/egg-hytale/lib/system.sh"
source "/egg-hytale/lib/downloader.sh"
source "/egg-hytale/lib/plugins.sh"

DOWNLOAD_URL="https://downloader.hytale.com/hytale-downloader.zip"
DOWNLOAD_FILE="hytale-downloader.zip"
DOWNLOADER_DIR="/egg-hytale/downloader"
DOWNLOAD_CRED_FILE=".hytale-downloader-credentials.json"
AUTH_CACHE_FILE=".hytale-auth-tokens.json"
VERSION_FILE="version.txt"
MODS_FOLDER="mods"

java -version
echo " "

# Initialize system
detect_architecture
setup_environment

# Copy start.sh template to /home/container
logger info "Copying start.sh template to /home/container..."
cp -f /usr/local/bin/start.sh start.sh
chmod 755 start.sh

setup_backup_directory
ensure_downloader

# Create version file
if [ ! -f "$VERSION_FILE" ]; then
    logger info "Creating version check file..."
    touch $VERSION_FILE
fi

#Fix system permissions
if [ -f "$VERSION_FILE" ] && { [ ! -r "$VERSION_FILE" ] || [ ! -w "$VERSION_FILE" ]; }; then
    logger warn "Fixing permissions on $VERSION_FILE..."
    chmod 644 "$VERSION_FILE"
fi
if [ -f "$DOWNLOAD_CRED_FILE" ] && { [ ! -r "$DOWNLOAD_CRED_FILE" ] || [ ! -w "$DOWNLOAD_CRED_FILE" ]; }; then
    logger warn "Fixing permissions on $DOWNLOAD_CRED_FILE..."
    chmod 644 "$DOWNLOAD_CRED_FILE"
fi
if [ -f "$AUTH_CACHE_FILE" ] && { [ ! -r "$AUTH_CACHE_FILE" ] || [ ! -w "$AUTH_CACHE_FILE" ]; }; then
    logger warn "Fixing permissions on $AUTH_CACHE_FILE..."
    chmod 644 "$AUTH_CACHE_FILE"
fi

run_update_process
validate_server_files
install_sourcequery


# Check if GSP mode (tokens provided externally)
if [ -n "$OVERRIDE_SESSION_TOKEN" ] && [ -n "$OVERRIDE_IDENTITY_TOKEN" ]; then
    logger info "Using provided session and identity tokens..."
    SESSION_TOKEN="$OVERRIDE_SESSION_TOKEN"
    IDENTITY_TOKEN="$OVERRIDE_IDENTITY_TOKEN"
else
    if [ "$USE_PERSISTENT_AUTHENTICATION" = "ENABLED" ]; then
        # Standard mode: perform authentication
        if check_cached_tokens && load_cached_tokens; then
            logger info "Using cached authentication..."
            if refresh_access_token; then
                # Update cache in case refresh token rotated
                save_auth_tokens
                # Create fresh game session
                if ! create_game_session; then
                    exit 1
                fi
            else
                # Refresh failed, need full re-auth
                logger info "Refresh token expired, re-authenticating..."
                rm -f "$AUTH_CACHE_FILE"
                perform_authentication
            fi
        else
            # Perform full authentication if no valid cache exists
            perform_authentication
        fi
    fi
fi

# Export the session tokens so they're available to start.sh
export SESSION_TOKEN
export IDENTITY_TOKEN

# Enforce file and folder permissions if enabled
enforce_permissions

logger info "Starting Hytale server..."

# Convert startup variables to from {{VARIABLE}} to ${VARIABLE} for the evaluating
PARSED=$(echo "$STARTUP" | sed -e 's/{{/${/g' -e 's/}}/}/g')
eval "$PARSED"