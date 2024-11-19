#!/bin/bash

# Define color variables
GREEN="\033[0;32m"     # Green
YELLOW="\033[1;33m"    # Bright Yellow
RED="\033[0;31m"       # Red
BLUE="\033[0;34m"      # Blue
NC="\033[0m"           # No Color

# Display social details and channel information
echo "==================================="
echo -e "${YELLOW}           CryptonodeHindi       ${NC}"
echo "==================================="
echo -e "${YELLOW}Telegram: https://t.me/cryptonodehindi${NC}"
echo -e "${YELLOW}Twitter: @CryptonodeHindi${NC}"
echo -e "${YELLOW}YouTube: https://www.youtube.com/@CryptonodesHindi${NC}"
echo -e "${YELLOW}Medium: https://medium.com/@cryptonodehindi${NC}"
echo "==================================="

# Update and upgrade the system
echo -e "${YELLOW}Updating and upgrading the system...${NC}"
sudo apt update -y && sudo apt upgrade -y
if [ $? -eq 0 ]; then
    echo -e "${GREEN}System updated and upgraded successfully!${NC}"
else
    echo -e "${RED}Error during system update and upgrade. Please check your system logs.${NC}"
    exit 1
fi

# Function to install packages
install_package() {
    local package=$1
    if ! command -v $package &> /dev/null; then
        echo -e "${YELLOW}$package not found, installing...${NC}"
        sudo apt install $package -y
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}$package installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install $package. Please check your network connection or package availability.${NC}"
            exit 1
        fi
    else
        echo -e "${YELLOW}$package is already installed.${NC}"
    fi
}

# Check and install necessary packages
install_package screen
install_package python3
install_package pip3

# Install necessary Python packages
echo -e "${YELLOW}Installing required Python packages...${NC}"
pip3 install loguru websockets==12.0 websockets_proxy
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Python packages installed successfully!${NC}"
else
    echo -e "${RED}Error installing Python packages. Please check your pip configuration.${NC}"
    exit 1
fi

# Download the grassbot script
echo -e "${YELLOW}Downloading the grassbot script...${NC}"
wget -q https://raw.githubusercontent.com/CryptonodesHindi/Automated_script/refs/heads/main/CryptonodeHindiGRASSBOT.py
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to download the script. Please check your network connection.${NC}"
    exit 1
fi
echo -e "${GREEN}Grassbot script downloaded successfully!${NC}"

# Create proxy.txt file
echo -e "${YELLOW}Creating proxy.txt file...${NC}"
echo -e "${BLUE}Ensure proxies are in the following format:${NC}"
echo -e "${BLUE}username:password@hostname:port${NC}"
echo -e "${BLUE}Example: socks5://2l4243pE33seQ4tQ:mf7rrfMnddHjd5S0@66.168.255.400:32209${NC}"

sleep 7
if command -v nano &> /dev/null; then
    nano proxy.txt
    echo -e "${GREEN}proxy.txt file created and edited successfully!${NC}"
else
    echo -e "${RED}Nano is not installed. Please install nano or edit proxy.txt manually.${NC}"
    touch proxy.txt
    echo -e "${GREEN}proxy.txt file created successfully! Please edit it manually.${NC}"
fi

# Prompt for user ID
echo -e "${YELLOW}Enter your USER_ID:${NC}"
read -r USER_ID
sed -i "s/_user_id = \"[^\"]*\"/_user_id = \"$USER_ID\"/" CryptonodeHindiGRASSBOT.py
if [ $? -eq 0 ]; then
    echo -e "${GREEN}USER_ID updated successfully!${NC}"
else
    echo -e "${RED}Failed to update USER_ID in the script. Please check the file.${NC}"
    exit 1
fi

# Prompt for proxies quantity
echo -e "${YELLOW}Enter the number of proxies to use:${NC}"
read -r PROXIES
sed -i "s/active_proxies = random.sample(all_proxies, 1)/active_proxies = random.sample(all_proxies, $PROXIES)/" CryptonodeHindiGRASSBOT.py
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Proxy quantity updated successfully!${NC}"
else
    echo -e "${RED}Failed to update proxy quantity in the script. Please check the file.${NC}"
    exit 1
fi

echo -e "${GREEN}Setup complete!${NC}"
echo ""

# Thank you message
echo "==================================="
echo -e "${YELLOW}           CryptonodeHindi       ${NC}"
echo "==================================="
echo -e "${GREEN}    Thanks for using this script!${NC}"
echo "==================================="
echo -e "${YELLOW}Twitter: @CryptonodeHindi${NC}"
echo -e "${YELLOW}YouTube: https://www.youtube.com/@CryptonodesHindi${NC}"
echo -e "${YELLOW}Medium: https://medium.com/@cryptonodehindi${NC}"
echo -e "${YELLOW}Join our Telegram for support: https://t.me/cryptonodehindi${NC}"
echo "======================================================================"
