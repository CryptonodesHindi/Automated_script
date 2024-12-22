#!/bin/bash

# Define color codes
INFO='\033[0;36m'    # Cyan
BANNER='\033[0;35m'  # Magenta
YELLOW='\033[0;33m'  # Yellow
RED='\033[0;31m'     # Red
GREEN='\033[0;32m'   # Green
BLUE='\033[0;34m'    # Blue
NC='\033[0m'         # No Color

# Display social details and channel information
echo "========================================"
echo -e "${YELLOW} Script is made by CRYTONODEHINDI ${NC}"
echo "----------------------------------------"

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
echo -e "${YELLOW}Medium: ${BLUE}https://medium.com/@cryptonodehindi${NC}"

echo "============================================"

# Update package lists and upgrade installed packages
echo -e "${YELLOW}Updating and upgrading system packages...${NC}"
sudo apt update -y && sudo apt upgrade -y

# Install Screen if not installed
if command -v screen &> /dev/null; then
    echo -e "${YELLOW}Screen is already installed. Skipping installation.${NC}"
else
    echo -e "${YELLOW}Installing Screen...${NC}"
    sudo apt install -y screen
fi

# Download the INI miner file
echo -e "${YELLOW}Downloading INI miner...${NC}"
wget https://github.com/Project-InitVerse/ini-miner/releases/download/v1.0.0/iniminer-linux-x64

# Grant execute permissions
echo -e "${YELLOW}Setting execute permissions for INI miner...${NC}"
chmod +x iniminer-linux-x64

echo -e "${GREEN}Installation completed successfully.${NC}"

echo "==================================="
echo -e "${BANNER}           CryptonodeHindi        ${NC}"
echo "==================================="
echo -e "${GREEN}    Thanks for using this script! ${NC}"
echo "==================================="
