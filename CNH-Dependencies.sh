#!/bin/bash

# Define color codes
INFO='\033[0;36m'   # Cyan
BANNER='\033[0;35m' # Magenta
YELLOW='\033[0;33m' # Yellow
RED='\033[0;31m'    # Red
GREEN='\033[0;32m'  # Green
BLUE='\033[0;34m'   # Blue
NC='\033[0m'        # No Color

# Banner
echo -e "${YELLOW}========================================"
echo -e " Script is made by CRYPTONODEHINDI"
echo -e "----------------------------------------${NC}"
echo -e '\e[34m'
cat << "EOF"
 ██████╗██████╗ ██╗   ██╗██████╗ ████████╗ ██████╗     ███╗   ██╗ ██████╗ ██████╗ ███████╗    ██╗  ██╗██╗███╗   ██╗██████╗ ██╗
██╔════╝██╔══██╗╚██╗ ██╔╝██╔══██╗╚══██╔══╝██╔═══██╗    ████╗  ██║██╔═══██╗██╔══██╗██╔════╝    ██║  ██║██║████╗  ██║██╔══██╗██║
██║     ██████╔╝ ╚████╔╝ ██████╔╝   ██║   ██║   ██║    ██╔██╗ ██║██║   ██║██║  ██║█████╗      ███████║██║██╔██╗ ██║██║  ██║██║
██║     ██╔══██╗  ╚██╔╝  ██╔═══╝    ██║   ██║   ██║    ██║╚██╗██║██║   ██║██║  ██║██╔══╝      ██╔══██║██║██║╚██╗██║██║  ██║██║
╚██████╗██║  ██║   ██║   ██║        ██║   ╚██████╔╝    ██║ ╚████║╚██████╔╝██████╔╝███████╗    ██║  ██║██║██║ ╚████║██████╔╝██║
 ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝        ╚═╝    ╚═════╝     ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝     ╚═╝    ╚═╝  ╚═╝╚═╚═╝   ╚═══╝╚═════╝ ╚═╝
EOF
echo -e '\e[0m'
echo -e "======================================================="
echo -e "${YELLOW}Telegram: ${GREEN}https://t.me/cryptonodehindi${NC}"
echo -e "${YELLOW}Twitter: ${GREEN}@CryptonodeHindi${NC}"
echo -e "${YELLOW}YouTube: ${GREEN}https://www.youtube.com/@CryptonodesHindi${NC}"
echo -e "${YELLOW}Medium: ${INFO}https://medium.com/@cryptonodehindi${NC}"
echo -e "======================================================="

# Update system
echo -e "${YELLOW}Updating system packages...${NC}"
sudo apt update -y && sudo apt upgrade -y

# Install Screen
if ! command -v screen &>/dev/null; then
    echo -e "${YELLOW}Installing Screen...${NC}"
    sudo apt install -y screen
else
    echo -e "${YELLOW}Screen already installed.${NC}"
fi

# Install curl
if ! command -v curl &>/dev/null; then
    echo -e "${INFO}Installing curl...${NC}"
    sudo apt install -y curl
else
    echo -e "${INFO}curl already installed.${NC}"
fi

# Install git
if ! command -v git &>/dev/null; then
    echo -e "${INFO}Installing git...${NC}"
    sudo apt install -y git
else
    echo -e "${INFO}git already installed.${NC}"
fi

# Install Docker
if ! command -v docker &>/dev/null; then
    echo -e "${YELLOW}Installing Docker...${NC}"
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common lsb-release gnupg2
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    echo -e "${GREEN}Docker installation completed.${NC}"
else
    echo -e "${YELLOW}Docker already installed.${NC}"
fi

# Install Docker Compose
if ! command -v docker-compose &>/dev/null; then
    echo -e "${YELLOW}Installing Docker Compose...${NC}"
    VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    sudo curl -L "https://github.com/docker/compose/releases/download/$VER/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}Docker Compose installed.${NC}"
else
    echo -e "${YELLOW}Docker Compose already installed.${NC}"
fi

# Add current user to Docker group
if ! groups $USER | grep -q '\bdocker\b'; then
    echo -e "${YELLOW}Adding user to Docker group...${NC}"
    sudo groupadd docker 2>/dev/null
    sudo usermod -aG docker $USER
    echo -e "${GREEN}User added to Docker group. You may need to logout and login again.${NC}"
else
    echo -e "${GREEN}User is already in the Docker group.${NC}"
fi

# Check for existing Node.js installations
EXISTING_NODE=$(which node)
if [ -n "$EXISTING_NODE" ]; then
    show "Existing Node.js found at $EXISTING_NODE. The script will install the latest version system-wide."
fi

# Fetch the latest Node.js version dynamically
show "Fetching latest Node.js version..." "progress"
LATEST_VERSION=$(curl -s https://nodejs.org/dist/latest/ | grep -oP 'node-v\K\d+\.\d+\.\d+' | head -1)
if [ -z "$LATEST_VERSION" ]; then
    show "Failed to fetch latest Node.js version. Please check your internet connection." "error"
    exit 1
fi
show "Latest Node.js version is $LATEST_VERSION"

# Extract the major version for NodeSource setup
MAJOR_VERSION=$(echo $LATEST_VERSION | cut -d. -f1)

# Set up the NodeSource repository for the latest major version
show "Setting up NodeSource repository for Node.js $MAJOR_VERSION.x..." "progress"
curl -sL https://deb.nodesource.com/setup_${MAJOR_VERSION}.x | sudo -E bash -
if [ $? -ne 0 ]; then
    show "Failed to set up NodeSource repository." "error"
    exit 1
fi

# Install Node.js and npm
show "Installing Node.js and npm..." "progress"
sudo apt-get install -y nodejs
if [ $? -ne 0 ]; then
    show "Failed to install Node.js and npm." "error"
    exit 1
fi

# Verify installation and PATH availability
show "Verifying installation..." "progress"
if command -v node &> /dev/null && command -v npm &> /dev/null; then
    NODE_VERSION=$(node -v)
    NPM_VERSION=$(npm -v)
    INSTALLED_NODE=$(which node)
    if [ "$INSTALLED_NODE" = "/usr/bin/node" ]; then
        show "Node.js $NODE_VERSION and npm $NPM_VERSION installed successfully at /usr/bin."
    else
        show "Node.js $NODE_VERSION and npm $NPM_VERSION installed, but another node executable is in PATH at $INSTALLED_NODE."
        show "The system-wide installation is at /usr/bin/node. To prioritize it, ensure /usr/bin is before other paths in your PATH variable."
    fi
else
    show "Installation completed, but node or npm not found in PATH." "error"
    show "This is unusual as /usr/bin should be in PATH. Please ensure /usr/bin is in your PATH variable (e.g., export PATH=/usr/bin:$PATH) and restart your shell."
    exit 1
fi

# Final message
echo -e "${YELLOW}----------------------------------------"
echo -e " Thanks for using the script!"
echo -e "----------------------------------------${NC}"
