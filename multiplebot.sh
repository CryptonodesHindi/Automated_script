#!/bin/bash  

# Define color codes
INFO='\033[0;36m'  # Cyan
BANNER='\033[0;35m' # Magenta
YELLOW='\033[0;33m' # Yellow
RED='\033[0;31m'    # Red
GREEN='\033[0;32m'  # Green
BLUE='\033[0;34m'   # Blue
NC='\033[0m'        # No Color

# Display script details
echo "========================================"
echo -e "${YELLOW} Script is made by CRYTONODEHINDI${NC}"
echo -e "-------------------------------------"

# Large ASCII Text with BANNER color
echo -e "${BANNER}  CCCCC  RRRRR   Y   Y  PPPP   TTTTT  OOO      N   N   OOO   DDDD  EEEEE      H   H  III  N   N  DDDD   III${NC}"
echo -e "${BANNER} C       R   R    Y Y   P  P     T   O   O     NN  N  O   O  D   D E          H   H   I   NN  N  D   D   I ${NC}"
echo -e "${BANNER} C       RRRRR     Y    PPPP     T   O   O     N N N  O   O  D   D EEEE       HHHHH   I   N N N  D   D   I ${NC}"
echo -e "${BANNER} C       R   R     Y     P       T   O   O     N  NN  O   O  D   D E          H   H   I   N  NN  D   D   I ${NC}"
echo -e "${BANNER}  CCCCC  R    R    Y     P       T    OOO      N   N   OOO   DDDD  EEEEE      H   H  III  N   N  DDDD   III${NC}"
echo "============================================"

# Check Linux architecture
ARCH=$(dpkg --print-architecture)
if [[ "$ARCH" == "amd64" ]]; then
    CLIENT_URL="https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar"
elif [[ "$ARCH" == "arm64" ]]; then
    CLIENT_URL="https://cdn.app.multiple.cc/client/linux/arm64/multipleforlinux.tar"
else
    echo -e "${RED}Unsupported architecture: $ARCH${NC}"
    exit 1
fi

# Download the tar file
echo -e "${GREEN}Downloading the Tar files from $CLIENT_URL...${NC}"
wget $CLIENT_URL -O multipleforlinux.tar
if [[ $? -ne 0 ]]; then
    echo -e "${RED}Failed to download the file. Please check your network connection.${NC}"
    exit 1
fi

# Extract the tar file
echo -e "${GREEN}Extracting the tar files...${NC}"
tar -xvf multipleforlinux.tar
if [[ $? -ne 0 ]]; then
    echo -e "${RED}Failed to extract the tar file. Exiting...${NC}"
    exit 1
fi

# Clean up the tar file after extraction
rm -f multipleforlinux.tar

# Navigate into the extracted directory
cd multipleforlinux || { echo -e "${RED}Failed to enter directory multipleforlinux. Exiting...${NC}"; exit 1; }

# Set file permissions
echo -e "${GREEN}Giving permission to the files...${NC}"
chmod +x multiple-cli
chmod +x multiple-node

# Set permissions for the Tracks directory
echo -e "${GREEN}Setting permissions for the Tracks directory...${NC}"
sudo chmod -R 755 /root/multipleforlinux/Tracks
sudo chown -R root:root /root/multipleforlinux/Tracks

# Add to PATH
echo -e "${GREEN}Configuring PATH...${NC}"
echo "PATH=\$PATH:$(pwd)" >> ~/.bashrc
source ~/.bashrc

# Set permissions for the directory
echo -e "${GREEN}Setting permissions for the directory...${NC}"
chmod -R 777 .

# Prompt for IDENTIFIER and PIN
while [[ -z "$IDENTIFIER" ]]; do
    read -p "Enter your IDENTIFIER: " IDENTIFIER
    IDENTIFIER=$(echo "$IDENTIFIER" | xargs) # Sanitize input
done

while [[ -z "$PIN" ]]; do
    read -p "Enter your PIN: " PIN
    PIN=$(echo "$PIN" | xargs) # Sanitize input
done

# Start the node
echo -e "${GREEN}Starting the Node...${NC}"
nohup ./multiple-node > output.log 2>&1 &
if [[ $? -ne 0 ]]; then
    echo -e "${RED}Failed to start the node. Check output.log for details.${NC}"
    exit 1
fi

# Bind unique account identifier
echo -e "${GREEN}Binding your account with identifier and PIN...${NC}"
BIND_OUTPUT=$(./multiple-cli bind --bandwidth-download 100 --identifier "$IDENTIFIER" --pin "$PIN" --storage 200 --bandwidth-upload 100)
if [[ $? -ne 0 ]]; then
    echo -e "${RED}Binding failed. Check the details below:${NC}"
    echo "$BIND_OUTPUT"
    exit 1
fi

echo -e "${GREEN}Binding successful!${NC}"
echo "$BIND_OUTPUT"

# Display thank you message
echo "========================================"
echo -e "${YELLOW} Thanks for using the script${NC}"
echo -e "-------------------------------------"

# Large ASCII Text with BANNER color
echo -e "${BANNER}  CCCCC  RRRRR   Y   Y  PPPP   TTTTT  OOO      N   N   OOO   DDDD  EEEEE      H   H  III  N   N  DDDD   III${NC}"
echo -e "${BANNER} C       R   R    Y Y   P  P     T   O   O     NN  N  O   O  D   D E          H   H   I   NN  N  D   D   I ${NC}"
echo -e "${BANNER} C       RRRRR     Y    PPPP     T   O   O     N N N  O   O  D   D EEEE       HHHHH   I   N N N  D   D   I ${NC}"
echo -e "${BANNER} C       R   R     Y     P       T   O   O     N  NN  O   O  D   D E          H   H   I   N  NN  D   D   I ${NC}"
echo -e "${BANNER}  CCCCC  R    R    Y     P       T    OOO      N   N   OOO   DDDD  EEEEE      H   H  III  N   N  DDDD   III${NC}"
echo "============================================"

# Display social links
echo -e "${YELLOW}Telegram: ${GREEN}https://t.me/cryptonodehindi${NC}"
echo -e "${YELLOW}Twitter: ${GREEN}@CryptonodeHindi${NC}"
echo -e "${YELLOW}YouTube: ${GREEN}https://www.youtube.com/@CryptonodesHindi${NC}"
echo -e "${YELLOW}Medium: ${CYAN}https://medium.com/@cryptonodehindi${NC}"

echo "============================================="
