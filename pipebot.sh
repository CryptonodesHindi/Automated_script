#!/bin/bash

# Define color codes
INFO='\033[0;36m'  # Cyan
BANNER='\033[0;35m' # Magenta
YELLOW='\033[0;33m' # Yellow
RED='\033[0;31m'    # Red
GREEN='\033[0;32m'  # Green
BLUE='\033[0;34m'   # Blue
CYAN='\033[0;36m'   # Cyan
NC='\033[0m'        # No Color

# Display social details and channel information in large letters manually
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

# Use different colors for each link to make them pop out more
echo -e "${YELLOW}Telegram: ${GREEN}https://t.me/cryptonodehindi${NC}"
echo -e "${YELLOW}Twitter: ${GREEN}@CryptonodeHindi${NC}"
echo -e "${YELLOW}YouTube: ${GREEN}https://www.youtube.com/@CryptonodesHindi${NC}"
echo -e "${YELLOW}Medium: ${CYAN}https://medium.com/@cryptonodehindi${NC}"

echo "============================================="

# Request input for URLs
read -p "PIPE-URL: " PIPE_URL
read -p "DCDND-URL: " DCDND_URL

# 1. Create the directory
sudo mkdir -p /opt/dcdn

# 2. Download the Pipe tool binary from the provided URL
if ! sudo curl -L "$PIPE_URL" -o /opt/dcdn/pipe-tool; then
    echo -e "${RED}Error downloading PIPE tool! Exiting...${NC}"
    exit 1
fi

# 3. Download the DCDND binary from the provided URL
if ! sudo curl -L "$DCDND_URL" -o /opt/dcdn/dcdnd; then
    echo -e "${RED}Error downloading DCDND tool! Exiting...${NC}"
    exit 1
fi

# 4. Make the binaries executable
sudo chmod +x /opt/dcdn/pipe-tool
sudo chmod +x /opt/dcdn/dcdnd

# 5. Log in to generate the access token
echo "Please log in to generate an access token. Follow the instructions below:"
/opt/dcdn/pipe-tool login --node-registry-url="https://rpc.pipedev.network"
echo "Login complete. You can now proceed to the next step."

# 6. Generate the registration token
/opt/dcdn/pipe-tool generate-registration-token --node-registry-url="https://rpc.pipedev.network"

# 7. Create the service file
sudo bash -c 'cat > /etc/systemd/system/dcdnd.service << EOF
[Unit]
Description=DCDN Node Service
After=network.target
Wants=network-online.target

[Service]
ExecStart=/opt/dcdn/dcdnd \
                --grpc-server-url=0.0.0.0:8002 \
                --http-server-url=0.0.0.0:8003 \
                --node-registry-url="https://rpc.pipedev.network" \
                --cache-max-capacity-mb=1024 \
                --credentials-dir=/root/.permissionless \
                --allow-origin=*

Restart=always
RestartSec=5

LimitNOFILE=65536
LimitNPROC=4096

StandardOutput=journal
StandardError=journal
SyslogIdentifier=dcdn-node

WorkingDirectory=/opt/dcdn

[Install]
WantedBy=multi-user.target
EOF'

# 8. Open the required ports
if command -v ufw &>/dev/null; then
    sudo ufw allow 8002/tcp
    sudo ufw allow 8003/tcp
else
    echo -e "${RED}ufw is not installed! Firewall configuration skipped.${NC}"
fi

# 9. Start the Node service
sudo systemctl daemon-reload
sudo systemctl enable dcdnd
sudo systemctl start dcdnd

# 10. Generate and register the wallet
echo "Generating and registering the wallet (Made by Cryptonodehindi)..."
/opt/dcdn/pipe-tool generate-wallet --node-registry-url="https://rpc.pipedev.network"
echo "Save your wallet phrase and the keypair.json file for backup (Made by Cryptonodehindi)."
"/opt/dcdn/pipe-tool link-wallet --node-registry-url='https://rpc.pipedev.network'"

# 11. Check if the node is running
echo "Checking the node status (Made by Cryptonodehindi)..."
"/opt/dcdn/pipe-tool list-nodes --node-registry-url='https://rpc.pipedev.network'"

echo "Script completed successfully (Made by Cryptonodehindi)."

# Display thank you message
echo "========================================"
echo -e "${YELLOW} Thanks for using the script${NC}"
echo -e "-------------------------------------"

# Use different colors for each link to make them pop out more
echo -e "${YELLOW}Telegram: ${GREEN}https://t.me/cryptonodehindi${NC}"
echo -e "${YELLOW}Twitter: ${GREEN}@CryptonodeHindi${NC}"
echo -e "${YELLOW}YouTube: ${GREEN}https://www.youtube.com/@CryptonodesHindi${NC}"
echo -e "${YELLOW}Medium: ${CYAN}https://medium.com/@cryptonodehindi${NC}"

echo "============================================="
