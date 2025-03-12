#!/bin/bash

# Define color codes
INFO='\033[0;36m'  # Cyan
BANNER='\033[0;35m' # Magenta
YELLOW='\033[0;33m' # Yellow
RED='\033[0;31m'    # Red
GREEN='\033[0;32m'  # Green
BLUE='\033[0;34m'   # Blue
NC='\033[0m'        # No Color

# Display script banner
echo "========================================"
echo -e "${YELLOW} Script is made by CRYPTONODEHINDI${NC}"
echo -e "-------------------------------------"

echo -e '\e[34m'
echo " ██████╗██████╗ ██╗   ██╗██████╗ ████████╗ ██████╗     ███╗   ██╗ ██████╗ ██████╗ ███████╗    ██╗  ██╗██╗███╗   ██╗██████╗ ██╗"
echo "██╔════╝██╔══██╗╚██╗ ██╔╝██╔══██╗╚══██╔══╝██╔═══██╗    ████╗  ██║██╔═══██╗██╔══██╗██╔════╝    ██║  ██║██║████╗  ██║██╔══██╗██║"
echo "██║     ██████╔╝ ╚████╔╝ ██████╔╝   ██║   ██║   ██║    ██╔██╗ ██║██║   ██║██║  ██║█████╗      ███████║██║██╔██╗ ██║██║  ██║██║"
echo "██║     ██╔══██╗  ╚██╔╝  ██╔═══╝    ██║   ██║   ██║    ██║╚██╗██║██║   ██║██║  ██║██╔══╝      ██╔══██║██║██║╚██╗██║██║  ██║██║"
echo "╚██████╗██║  ██║   ██║   ██║        ██║   ╚██████╔╝    ██║ ╚████║╚██████╔╝██████╔╝███████╗    ██║  ██║██║██║ ╚████║██████╔╝██║"
echo " ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝        ╚═╝    ╚═════╝     ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝     ╚═╝    ╚═╝  ╚═╝╚═╚═╝   ╚═══╝╚═════╝ ╚═╝"
echo -e '\e[0m'
echo "======================================================="

echo -e "${YELLOW}Telegram: ${GREEN}https://t.me/cryptonodehindi${NC}"
echo -e "${YELLOW}Twitter: ${GREEN}@CryptonodeHindi${NC}"
echo -e "${YELLOW}YouTube: ${GREEN}https://www.youtube.com/@CryptonodesHindi${NC}"
echo -e "${YELLOW}Medium: ${CYAN}https://medium.com/@cryptonodehindi${NC}"
echo "======================================================="

# Update package lists and upgrade installed packages
echo -e "${YELLOW}Updating and upgrading system packages...${NC}"
sudo apt update -y

# Install Screen if not installed
if ! command -v screen &> /dev/null; then
    echo -e "${YELLOW}Installing Screen...${NC}"
    sudo apt install -y screen
else
    echo -e "${YELLOW}Screen is already installed, skipping installation.${NC}"
fi

# Install Git if not installed
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}Installing Git...${NC}"
    sudo apt install -y git
else
    echo -e "${YELLOW}Git is already installed, skipping installation.${NC}"
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Installing Docker and dependencies...${NC}"
    sudo apt install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        lsb-release \
        gnupg2

    echo -e "${YELLOW}Adding Docker's official GPG key...${NC}"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo -e "${YELLOW}Adding Docker repository...${NC}"
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Docker installation failed!${NC}"
        exit 1
    else
        echo -e "${GREEN}Docker successfully installed!${NC}"
    fi
else
    echo -e "${YELLOW}Docker is already installed, skipping installation.${NC}"
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Installing Docker Compose...${NC}"
    VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    curl -L "https://github.com/docker/compose/releases/download/$VER/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}Docker Compose installed!${NC}"
else
    echo -e "${YELLOW}Docker Compose is already installed, skipping installation.${NC}"
fi

# Add current user to Docker group
if ! groups $USER | grep -q '\bdocker\b'; then
    echo -e "${YELLOW}Adding user to Docker group...${NC}"
    sudo groupadd docker
    sudo usermod -aG docker $USER
    echo -e "${GREEN}Please log out and log back in for changes to take effect.${NC}"
else
    echo -e "${YELLOW}User is already in the Docker group.${NC}"
fi

# Clone the 0g Labs Git repo
echo -e "${YELLOW}Cloning 0g Labs repository...${NC}"
git clone https://github.com/0glabs/0g-da-client.git

# Go to DA-Client directory
cd 0g-da-client || { echo -e "${RED}Failed to enter the repository directory.${NC}"; exit 1; }

# Build Docker image
echo -e "${YELLOW}Building Docker image...${NC}"
docker build -t 0g-da-client -f combined.Dockerfile .

# Prompt for private key securely
echo -e "${YELLOW}Enter your private key:${NC}"
read -s YOUR_PRIVATE_KEY
echo -e "${GREEN}Private key received.${NC}"

# Download environment file
echo -e "${YELLOW}Downloading environment file...${NC}"
wget -q https://raw.githubusercontent.com/CryptonodesHindi/Automated_script/refs/heads/main/0genvfile.env

# Inject private key into the environment file
sed -i "s|COMBINED_SERVER_PRIVATE_KEY=YOUR_PRIVATE_KEY|COMBINED_SERVER_PRIVATE_KEY=$YOUR_PRIVATE_KEY|" 0genvfile.env

# Display completion message
echo "========================================"
echo -e "${YELLOW}Thanks for using the script!${NC}"
echo "========================================"
