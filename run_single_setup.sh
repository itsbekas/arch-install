source ./utils.sh

deactivate_log

# check that setup exists
if [ ! -f "./setup/$1.sh" ]; then
    echo "The setup script for $1 does not exist."
    exit 1
fi

if [ ! -z "$2" ] && [ ! -d "/home/$2" ]; then
    echo "The user $2 does not exist."
    exit 1
fi

username="$2"

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

setup_extra "$1"
