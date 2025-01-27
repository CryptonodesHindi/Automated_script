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
echo -e "${YELLOW} Script is made by CRYTONODEHINDI${NC}"
echo -e "-------------------------------------"

# Large ASCII Text with BANNER color
echo -e "${BANNER}  CCCCC  RRRRR   Y   Y  PPPP   TTTTT  OOO      N   N   OOO   DDDD  EEEEE      H   H  III  N   N  DDDD   III${NC}"
echo -e "${BANNER} C       R   R    Y Y   P  P     T   O   O     NN  N  O   O  D   D E          H   H   I   NN  N  D   D   I ${NC}"
echo -e "${BANNER} C       RRRRR     Y    PPPP     T   O   O     N N N  O   O  D   D EEEE       HHHHH   I   N N N  D   D   I ${NC}"
echo -e "${BANNER} C       R   R     Y    P        T   O   O     N  NN  O   O  D   D E          H   H   I   N  NN  D   D   I ${NC}"
echo -e "${BANNER}  CCCCC  R    R    Y    P        T    OOO      N   N   OOO   DDDD  EEEEE      H   H  III  N   N  DDDD   III${NC}"

echo "============================================"

# Use different colors for each link to make them pop out more
echo -e "${YELLOW}Telegram: ${GREEN}https://t.me/cryptonodehindi${NC}"
echo -e "${YELLOW}Twitter: ${GREEN}@CryptonodeHindi${NC}"
echo -e "${YELLOW}YouTube: ${GREEN}https://www.youtube.com/@CryptonodesHindi${NC}"
echo -e "${YELLOW}Medium: ${CYAN}https://medium.com/@cryptonodehindi${NC}"

echo "============================================="
# Step 1: Update and Upgrade the system
echo -e "${GREEN}Updating and upgrading the system...${NC}"
sudo apt update -y

# Step 2: Check if 'screen' is installed, and install if not
if ! command -v screen &> /dev/null
then
    echo -e "${RED}Screen is not installed. Installing Screen...${NC}"
    sudo apt install screen -y
else
    echo -e "${GREEN}Screen is already installed. Skipping Screen installation.${NC}"
fi

# Step 3: Check if Go is installed, and install if not
if ! command -v go &> /dev/null
then
    echo -e "${RED}Go is not installed. Installing Go...${NC}"
    sudo apt install golang-go -y
else
    echo -e "${GREEN}Go is already installed. Skipping Go installation.${NC}"
fi

# Step 4: Check the architecture of the system
ARCHITECTURE=$(dpkg --print-architecture)
echo -e "${INFO}System architecture: $ARCHITECTURE${NC}"

# Step 5: Download the appropriate tarball based on architecture
if [ "$ARCHITECTURE" == "amd64" ]; then
    echo -e "${GREEN}Downloading amd64 tar file...${NC}"
    wget -q https://github.com/hemilabs/heminetwork/releases/download/v0.11.1/heminetwork_v0.11.1_linux_amd64.tar.gz
elif [ "$ARCHITECTURE" == "arm64" ]; then
    echo -e "${GREEN}Downloading arm64 tar file...${NC}"
    wget -q https://github.com/hemilabs/heminetwork/releases/download/v0.11.1/heminetwork_v0.11.1_linux_arm64.tar.gz
else
    echo -e "${RED}Unsupported architecture: $ARCHITECTURE${NC}"
    exit 1
fi

# Step 6: Extract the downloaded tar file
if [ "$ARCHITECTURE" == "amd64" ]; then
    echo -e "${GREEN}Extracting amd64 tar file...${NC}"
    tar xvf heminetwork_v0.11.1_linux_amd64.tar.gz
elif [ "$ARCHITECTURE" == "arm64" ]; then
    echo -e "${GREEN}Extracting arm64 tar file...${NC}"
    tar xvf heminetwork_v0.11.1_linux_arm64.tar.gz
fi

# Step 7: Remove the downloaded tar.gz files
echo -e "${YELLOW}Removing tar.gz files...${NC}"
rm -f heminetwork_v0.11.1_linux_*.tar.gz

echo -e "${GREEN}Script execution completed successfully.${NC}"

# Display thank you message
echo "==================================="
echo -e "${YELLOW}           CryptonodeHindi       ${NC}"
echo "==================================="
echo "========================================"
echo -e "${YELLOW} Thanks for using the script${NC}"
echo -e "-------------------------------------"
