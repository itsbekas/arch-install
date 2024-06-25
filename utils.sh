# BASE REPO
BASE_REPO="https://raw.githubusercontent.com/itsbekas/arch-install/master"
# TERMINAL FILE
TERMINAL_FILE="/dev/tty"

# Function to download config file
download_config() {
    local repo_path=$1
    local device_path=$2
    log "Downloading $repo_path to $device_path"
    mkdir -p "$(dirname "$device_path")"
    curl "$BASE_REPO/$repo_path" -o "$device_path"
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
