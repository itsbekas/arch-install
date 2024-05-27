# BASE REPO
BASE_REPO="https://raw.githubusercontent.com/itsbekas/arch-install/master"

# Function to download config file
download_config() {
    local repo_path=$1
    local device_path=$2
    mkdir -p "$(dirname "$device_path")"
    curl "$BASE_REPO/$repo_path" -o "$device_path"
    chown $username:$username "$device_path"
}

# Executes a setup script from github
setup_extra() {
    local extra=$1
    bash <(curl -fsSL "$BASE_REPO/setup/$extra.sh")
}
