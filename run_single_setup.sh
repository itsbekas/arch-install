source ./utils.sh

deactivate_log

# check that setup exists
if [ ! -f "./setup/$1.sh" ]; then
    echo "The setup script for $1 does not exist."
    exit 1
fi

setup_extra "$1"
