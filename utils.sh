# BASE REPO
BASE_REPO="https://raw.githubusercontent.com/itsbekas/arch-install/${branch}"
# TERMINAL FILE
TERMINAL_FILE="/dev/tty"

# Function to download config file
download_config() {
    local repo_path=$1
    local device_path=$2
    log "Downloading $repo_path to $device_path"
    mkdir -p "$(dirname "$device_path")"
    curl "$BASE_REPO/config/$repo_path" -o "$device_path"
    chown $username:$username "$device_path"
}

# Executes a setup script from github
setup_extra() {
    local extra=$1
    log "Setting up $extra"
    curl -fsSL $BASE_REPO/setup/$extra.sh | tee /tmp/$extra.sh
    source /tmp/$extra.sh
}

# Logs a message to the console
log() {
    timestamp=$(date +"%Y-%m-%d %T")
    echo "$timestamp | $@" | tee -a $TERMINAL_FILE >> $LOG_FILE
}

activate_log () {
    exec &> $LOG_FILE
}

deactivate_log () {
    exec &> $TERMINAL_FILE
}


# run_alternate_terminal(command)
# Runs a command in a separate screen session to isolate output from user terminal
# Returns to original terminal when complete
run_alternate_terminal() {
    local cmd=$1
    local session_name="alternate_terminal_$$"  # Use PID to avoid conflicts
    
    # Create a detached screen session that will exit when the command completes
    # The trick is to run screen with the command directly, which exits when done
    screen -dmS "$session_name" bash -c "$cmd"
    
    # Attach to the screen session
    # User will see the command output
    screen -r "$session_name"
    echo -en '\e[A\e[K' # Remove [screen is terminating] message
    
    # Clean up (session should already be gone, but just in case)
    screen -S "$session_name" -X quit 2>/dev/null || true
}

selection_menu() {
    local header=$1
    local options=("${@:2}")
    echo $header
    for option in "${options[@]}"; do
        echo $option
    done
    read -p "Select an option: " selected_item
    return $selected_item
}

run_selection_menu() {
    # create a string that sources utils.sh and calls selection_menu
    local script="source $(realpath ${BASH_SOURCE[0]}); selection_menu \"$1\" \"${@:2}\""
    run_alternate_terminal "$script"
}
