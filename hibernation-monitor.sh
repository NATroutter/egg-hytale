#!/bin/bash

################################################################################
# Hytale Server Hibernation Monitor
#
# This script monitors player activity and puts the server into hibernation
# mode when no players are online for a specified period of time.
#
# Hibernation saves resources by suspending the Java process (SIGSTOP)
# and waking it up (SIGCONT) when a connection attempt is detected.
################################################################################

# Configuration from environment variables
IDLE_TIMEOUT="${HIBERNATION_TIMEOUT:-300}"  # Default 5 minutes (300 seconds)
CHECK_INTERVAL="${HIBERNATION_CHECK_INTERVAL:-30}"  # Check every 30 seconds
ENABLED="${ENABLE_HIBERNATION:-0}"

# State files
STATE_DIR="/home/container/.hibernation"
HIBERNATE_STATE="$STATE_DIR/hibernated"
LAST_ACTIVITY="$STATE_DIR/last_activity"
PID_FILE="$STATE_DIR/server.pid"

# Log file
LOG_FILE="/home/container/hibernation.log"

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to check if hibernation is enabled
check_enabled() {
    if [ "$ENABLED" != "1" ]; then
        exit 0
    fi
}

# Function to initialize state directory
init_state_dir() {
    mkdir -p "$STATE_DIR"
    touch "$LAST_ACTIVITY"
    echo "$(date +%s)" > "$LAST_ACTIVITY"
}

# Function to get the Java server PID
get_server_pid() {
    pgrep -f "HytaleServer.jar" | head -n 1
}

# Function to save server PID
save_server_pid() {
    local pid=$1
    echo "$pid" > "$PID_FILE"
}

# Function to check if server is hibernated
is_hibernated() {
    [ -f "$HIBERNATE_STATE" ]
}

# Function to check player count from server logs
check_player_count() {
    # Look for player join/leave messages in the latest log
    # This is a heuristic - adjust based on actual Hytale server log format
    local recent_logs=$(tail -n 100 /home/container/logs/latest.log 2>/dev/null || echo "")
    
    # Count unique player sessions in recent logs
    # Adjust these patterns based on actual Hytale server log format
    local joins=$(echo "$recent_logs" | grep -c "joined the game" 2>/dev/null || echo "0")
    local leaves=$(echo "$recent_logs" | grep -c "left the game" 2>/dev/null || echo "0")
    
    # Simple heuristic: if we see recent joins, assume players are online
    if [ "$joins" -gt "$leaves" ] && [ "$joins" -gt 0 ]; then
        return 0  # Players online
    fi
    
    # Alternative: Check for any recent log activity (server is processing)
    local log_age=999999
    if [ -f "/home/container/logs/latest.log" ]; then
        log_age=$(($(date +%s) - $(stat -c %Y /home/container/logs/latest.log 2>/dev/null || echo 0)))
    fi
    
    # If log was modified in last 60 seconds, consider server active
    if [ "$log_age" -lt 60 ]; then
        return 0  # Active
    fi
    
    return 1  # No players
}

# Function to check network activity (connection attempts)
check_network_activity() {
    # Check for established connections on the server port
    local connections=$(netstat -an 2>/dev/null | grep ":${SERVER_PORT:-25565}" | grep -c "ESTABLISHED" || echo "0")
    
    if [ "$connections" -gt 0 ]; then
        return 0  # Active connections
    fi
    
    return 1  # No connections
}

# Function to hibernate the server
hibernate_server() {
    local pid=$(get_server_pid)
    
    if [ -z "$pid" ]; then
        log "ERROR: Cannot find server process to hibernate"
        return 1
    fi
    
    log "Hibernating server (PID: $pid) - No players for ${IDLE_TIMEOUT}s"
    
    # Suspend the Java process
    kill -STOP "$pid" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        touch "$HIBERNATE_STATE"
        save_server_pid "$pid"
        log "✓ Server hibernated successfully - RAM usage reduced"
        return 0
    else
        log "ERROR: Failed to hibernate server"
        return 1
    fi
}

# Function to wake up the server
wake_server() {
    local pid=$(cat "$PID_FILE" 2>/dev/null)
    
    if [ -z "$pid" ]; then
        pid=$(get_server_pid)
    fi
    
    if [ -z "$pid" ]; then
        log "ERROR: Cannot find server process to wake"
        return 1
    fi
    
    log "Waking up server (PID: $pid) - Activity detected"
    
    # Resume the Java process
    kill -CONT "$pid" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        rm -f "$HIBERNATE_STATE"
        echo "$(date +%s)" > "$LAST_ACTIVITY"
        log "✓ Server woken up successfully"
        return 0
    else
        log "ERROR: Failed to wake server"
        return 1
    fi
}

# Function to update last activity timestamp
update_activity() {
    echo "$(date +%s)" > "$LAST_ACTIVITY"
}

# Function to get seconds since last activity
seconds_since_activity() {
    local last=$(cat "$LAST_ACTIVITY" 2>/dev/null || echo "0")
    local now=$(date +%s)
    echo $((now - last))
}

# Main monitoring loop
main() {
    check_enabled
    
    log "Starting hibernation monitor (timeout: ${IDLE_TIMEOUT}s, check: ${CHECK_INTERVAL}s)"
    
    init_state_dir
    
    # Initial wait for server to start
    sleep 30
    
    while true; do
        sleep "$CHECK_INTERVAL"
        
        # Check if server process exists
        local pid=$(get_server_pid)
        if [ -z "$pid" ]; then
            log "Server process not found, exiting monitor"
            exit 0
        fi
        
        if is_hibernated; then
            # Server is hibernated, check for wake conditions
            if check_network_activity || check_player_count; then
                wake_server
            fi
        else
            # Server is active, check for hibernate conditions
            if check_player_count || check_network_activity; then
                # Activity detected
                update_activity
            else
                # No activity, check if timeout reached
                local idle_time=$(seconds_since_activity)
                
                if [ "$idle_time" -ge "$IDLE_TIMEOUT" ]; then
                    hibernate_server
                else
                    local remaining=$((IDLE_TIMEOUT - idle_time))
                    log "No players online - hibernating in ${remaining}s"
                fi
            fi
        fi
    done
}

# Run the monitor
main