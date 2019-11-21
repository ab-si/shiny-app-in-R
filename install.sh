#!/bin/bash

echo ""
echo "Command Line Installer"
echo ""

DESTINATION="$PWD"

# Docker Installation
DOCKER_INSTALL_SCRIPT_PATH="install_docker.sh"
source "$PWD/$DOCKER_INSTALL_SCRIPT_PATH"

# Start docker
systemctl start docker

echo ""
echo "Installation complete."
echo ""

# Exit from the script with success (0)
exit 0