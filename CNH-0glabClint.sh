#!/bin/bash

# Define color codes
INFO='\033[0;36m'  # Cyan
BANNER='\033[0;35m' # Magenta
YELLOW='\033[0;33m' # Yellow
RED='\033[0;31m'    # Red
GREEN='\033[0;32m'  # Green
BLUE='\033[0;34m'   # Blue
NC='\033[0m'        # No Color

# Display social details and channel information in large letters manually
echo "========================================"
echo -e "${YELLOW} Script is made by CRYPTONODEHINDI${NC}"
echo -e "-------------------------------------"

echo -e ""
echo -e ""
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
if command -v screen &> /dev/null; then
    echo -e "${YELLOW}Screen is already installed, skipping installation.${NC}"
else
    echo -e "${YELLOW}Screen is not installed. Installing Screen...${NC}"
    sudo apt install -y screen
fi

#Install git if not installed

if command -v git &> /dev/null; then
    echo -e "${YELLOW}Git is already installed, skiping git installation.${NC}"
else 
    echo -e "${YELLOW}Git is not installed.Installing git.${NC}"
    sudo apt install git -y
fi

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker is already installed, skipping Docker installation.${NC}"
else
    # Install dependencies for Docker installation
    echo -e "${YELLOW}Installing required dependencies for Docker...${NC}"
    sudo apt install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common \
      lsb-release \
      gnupg2

    # Add Docker's official GPG key
    echo -e "${YELLOW}Adding Docker's official GPG key...${NC}"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Add Docker repository
    echo -e "${YELLOW}Adding Docker repository...${NC}"
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update package lists to include Docker's repository
    echo -e "${YELLOW}Updating package lists...${NC}"
    sudo apt update -y

    # Install Docker
    echo -e "${YELLOW}Installing Docker...${NC}"
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    # Check if Docker is installed successfully
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Docker installation failed!${NC}"
        exit 1
    else
        echo -e "${YELLOW}Docker is successfully installed!${NC}"
    fi
fi

# Check if Docker Compose is already installed
if command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Docker Compose is already installed, skipping Docker Compose installation.${NC}"
else
    echo -e "${YELLOW}Docker Compose not found. Installing Docker Compose...${NC}"
    VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    curl -L "https://github.com/docker/compose/releases/download/$VER/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo -e "${YELLOW}Docker Compose has been installed!${NC}"
fi

# Add current user to Docker group
if ! groups $USER | grep -q '\bdocker\b'; then
    echo "Adding user to Docker group..."
    sudo groupadd docker
    sudo usermod -aG docker $USER
else
    echo "User is already in the Docker group."
fi

#Cloneing the 0g Lab git repo.
git clone https://github.com/0glabs/0g-da-client.git

# Go to DA-Client directory
cd 0g-da-client

# Build Docker image
echo "Building Docker image..."
docker build -t 0g-da-client -f combined.Dockerfile .

# Prompt for private key securely
echo -e "${YELLOW}Enter your private key:${NC}"
read -s YOUR_PRIVATE_KEY
echo -e "${GREEN}Private key received.${NC}"


# Create envfile.env for configuration
echo "Creating envfile.env..."
cat <<EOF > envfile.env
COMBINED_SERVER_CHAIN_RPC=https://evmrpc-testnet.0g.ai
COMBINED_SERVER_PRIVATE_KEY=$YOUR_PRIVATE_KEY
ENTRANCE_CONTRACT_ADDR=0x857C0A28A8634614BB2C96039Cf4a20AFF709Aa9

COMBINED_SERVER_RECEIPT_POLLING_ROUNDS=180
COMBINED_SERVER_RECEIPT_POLLING_INTERVAL=1s
COMBINED_SERVER_TX_GAS_LIMIT=2000000
COMBINED_SERVER_USE_MEMORY_DB=true
COMBINED_SERVER_KV_DB_PATH=/runtime/
COMBINED_SERVER_TimeToExpire=2592000
DISPERSER_SERVER_GRPC_PORT=51001
BATCHER_DASIGNERS_CONTRACT_ADDRESS=0x0000000000000000000000000000000000001000
BATCHER_FINALIZER_INTERVAL=20s
BATCHER_CONFIRMER_NUM=3
BATCHER_MAX_NUM_RETRIES_PER_BLOB=3
BATCHER_FINALIZED_BLOCK_COUNT=50
BATCHER_BATCH_SIZE_LIMIT=500
BATCHER_ENCODING_INTERVAL=3s
BATCHER_ENCODING_REQUEST_QUEUE_SIZE=1
BATCHER_PULL_INTERVAL=10s
BATCHER_SIGNING_INTERVAL=3s
BATCHER_SIGNED_PULL_INTERVAL=20s
BATCHER_EXPIRATION_POLL_INTERVAL=3600
BATCHER_ENCODER_ADDRESS=DA_ENCODER_SERVER
BATCHER_ENCODING_TIMEOUT=300s
BATCHER_SIGNING_TIMEOUT=60s
BATCHER_CHAIN_READ_TIMEOUT=12s
BATCHER_CHAIN_WRITE_TIMEOUT=13s
EOF


# Display thank you message
echo "========================================"
echo -e "${YELLOW} Thanks for using the script${NC}"
echo -e "-------------------------------------"
