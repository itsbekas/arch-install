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
    LOG_PREFIX=$1
    log "Setting up $extra"
    curl -fsSL $BASE_REPO/setup/$extra.sh | tee /tmp/$extra.sh
    source /tmp/$extra.sh
    LOG_PREFIX=""
}

LOG_PREFIX=""

# Logs a message to both terminal and log file
log() {
    local prefix=""
    if [ -n "$LOG_PREFIX" ]; then
        prefix="[$LOG_PREFIX] "
    fi
    gum log --time ansic --level info "${prefix}$@" | tee -a $TERMINAL_FILE >> $LOG_FILE
}

silent() {
    "$@" >> $LOG_FILE 2>&1
}

deactivate_log() {
    exec >> $LOG_FILE 2>&1
}

activate_log() {
    exec > >(tee -a $LOG_FILE) 2>&1
}
