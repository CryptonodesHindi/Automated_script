#!/bin/bash

# Define color codes
INFO='\033[0;36m'  # Cyan
BANNER='\033[0;35m' # Magenta
YELLOW='\033[0;33m' # Yellow
RED='\033[0;31m'    # Red
GREEN='\033[0;32m'  # Green
BLUE='\033[0;34m'   # Blue
WARNING='\033[0;33m'
ERROR='\033[0;31m'
SUCCESS='\033[0;32m'
NC='\033[0m' # No Color

# Display social details and channel information in large letters manually
echo "========================================"
echo -e "${GREEN} Script is made by CRYTONODEHINDI${NC}"
echo -e "-------------------------------------"

# Large ASCII Text with BANNER color
echo -e "${YELLOW}  CCCCC  RRRRR   Y   Y  PPPP   TTTTT  OOO      N   N   OOO   DDDD  EEEEE      H   H  III  N   N  DDDD   III${NC}"
echo -e "${YELLOW} C       R    R    Y Y   P P     T   O   O     NN  N  O   O  D   D E          H   H   I   NN  N  D   D   I ${NC}"
echo -e "${YELLOW} C       RRRRR     Y    PPPP     T   O   O     N N N  O   O  D   D EEEE       HHHHH   I   N N N  D   D   I ${NC}"
echo -e "${YELLOW} C       R   R     Y     P       T   O   O     N  NN  O   O  D   D E          H   H   I   N  NN  D   D   I ${NC}"
echo -e "${YELLOW}  CCCCC  R    R    Y     P       T    OOO      N   N   OOO   DDDD  EEEEE      H   H  III  N   N  DDDD   III${NC}"

echo -e "${YELLOW}==============================================Alliance Game==================================================${NC}"

echo "========================================="

# Use different colors for each link to make them pop out more
echo -e "${YELLOW}Telegram: ${GREEN}https://t.me/cryptonodehindi${NC}"
echo -e "${YELLOW}Twitter: ${GREEN}@CryptonodeHindi${NC}"
echo -e "${YELLOW}YouTube: ${GREEN}https://www.youtube.com/@CryptonodesHindi${NC}"
echo -e "${YELLOW}Medium: ${CYAN}https://medium.com/@cryptonodehindi${NC}"

echo "============================================="


# Check if Docker is installed, if not, install Docker
if ! command -v docker &> /dev/null; then
    echo -e "${WARNING}Docker not found. Installing Docker...${NC}"
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    echo -e "${SUCCESS}Docker installed successfully.${NC}"
else
    echo -e "${SUCCESS}Docker is already installed.${NC}"
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${INFO}Installing Docker Compose...${NC}"
    VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    sudo curl -L "https://github.com/docker/compose/releases/download/$VER/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo -e "${SUCCESS}Docker Compose installed successfully. Version: $(docker-compose --version)${NC}"
else
    echo -e "${SUCCESS}Docker Compose is already installed.${NC}"
fi

# Function to ensure a non-empty value
get_non_empty_input() {
    local prompt="$1"
    local input=""
    while [ -z "$input" ]; do
        read -p "$prompt" input
        if [ -z "$input" ]; then
            echo -e "${ERROR}Error: This field cannot be empty(Reach out to me,over the Telegram).${NC}"
        fi
    done
    echo "$input"
}

# Function to generate a random MAC address
generate_mac_address() {
    echo "02:$(od -An -N5 -tx1 /dev/urandom | tr ' ' ':' | cut -c2-)"
}

# Function to generate a new UUID for the fake product_uuid
generate_uuid() {
    uuid=$(cat /proc/sys/kernel/random/uuid)
    echo $uuid
}

# Get the parameters with validation
device_name=$(get_non_empty_input "Enter device_name: ")

# Create a directory for this device's configuration
device_dir="./$device_name"
if [ ! -d "$device_dir" ]; then
    mkdir "$device_dir"
    echo -e "${INFO}Created directory for $device_name at $device_dir${NC}"
fi

echo -e "${YELLOW}This is your Ip,Please use the Proxies to avoid the Sybil/ban.(Made by CryptonodeHindi)${NC}"
curl https://api.ipify.org


# Proxy configuration
read -p "Do you want to use a proxy? (Y/N): " use_proxy

if [[ "$use_proxy" == "Y" || "$use_proxy" == "y" ]]; then
    proxy_type=$(get_non_empty_input "Enter proxy type (http/socks5): ")
    proxy_ip=$(get_non_empty_input "Enter proxy IP: ")
    proxy_port=$(get_non_empty_input "Enter proxy port: ")
    read -p "Enter proxy username : " proxy_username
    read -p "Enter proxy password : " proxy_password

    if [[ "$proxy_type" == "http" ]]; then
        proxy_type="http-connect"
    fi
else
    echo -e "${ERROR}Proxy details are mandatory. Exiting.${NC}"
    exit 1
fi

# Step 1: Create the Dockerfile
echo -e "${INFO}Creating the Dockerfile...${NC}"
cat << 'EOL' > "$device_dir/Dockerfile"
FROM ubuntu:latest
WORKDIR /app
RUN apt-get update && apt-get install -y bash curl jq make gcc bzip2 lbzip2 vim git lz4 telnet build-essential net-tools wget tcpdump systemd dbus redsocks iptables iproute2 nano
RUN curl -L https://github.com/Impa-Ventures/coa-launch-binaries/raw/main/linux/amd64/compute/launcher -o launcher && \
    curl -L https://github.com/Impa-Ventures/coa-launch-binaries/raw/main/linux/amd64/compute/worker -o worker
RUN chmod +x ./launcher && chmod +x ./worker
EOL

cat <<EOL >> "$device_dir/Dockerfile"
COPY redsocks.conf /etc/redsocks.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash", "-c", "exec /bin/bash"]
EOL

# Create redsocks.conf
cat <<EOL > "$device_dir/redsocks.conf"
base {
    log_debug = off;
    log_info = on;
    log = "file:/var/log/redsocks.log";
    daemon = on;
    redirector = iptables;
}

redsocks {
    local_ip = 127.0.0.1;
    local_port = 12345;
    ip = $proxy_ip;
    port = $proxy_port;
    type = $proxy_type;
EOL

if [[ -n "$proxy_username" ]]; then
    cat <<EOL >> "$device_dir/redsocks.conf"
    login = "$proxy_username";
EOL
fi

if [[ -n "$proxy_password" ]]; then
    cat <<EOL >> "$device_dir/redsocks.conf"
    password = "$proxy_password";
EOL
fi

cat <<EOL >> "$device_dir/redsocks.conf"
}
EOL

# Create entrypoint.sh
cat <<EOL > "$device_dir/entrypoint.sh"
#!/bin/sh

echo "Starting redsocks..."
redsocks -c /etc/redsocks.conf &
echo "Redsocks started."

sleep 5
echo "Configuring iptables..."
iptables -t nat -A OUTPUT -p tcp --dport 80 -j REDIRECT --to-ports 12345
iptables -t nat -A OUTPUT -p tcp --dport 443 -j REDIRECT --to-ports 12345
echo "Iptables configured."

# Display the proxy IP
echo -e "\033[0;33mBelow is your Proxy IP. Ensure it doesn't match your VPS IP (CryptonodeHindi):\033[0m"
curl https://api.ipify.org
echo

echo "Executing user command..."
exec "\$@"

echo -e "\033[0;33mBelow is your Proxy IP (Made by CryptonodeHindi):\033[0m"
curl https://api.ipify.org
EOL

chmod +x "$device_dir/entrypoint.sh"

# Generate UUID and MAC address
fake_product_uuid_file="$device_dir/fake_uuid.txt"
if [ ! -f "$fake_product_uuid_file" ]; then
    echo "$(generate_uuid)" > "$fake_product_uuid_file"
fi

mac_address=$(generate_mac_address)
echo -e "${INFO}Generated MAC address: $mac_address${NC}"

# Build Docker image
device_name_lower=$(echo "$device_name" | tr '[:upper:]' '[:lower:]')
docker build -t "alliance_games_docker_$device_name_lower" "$device_dir"

echo -e "${SUCCESS}Congratulations! The Docker container '${device_name}' has been successfully set up.${NC}"
echo -e "${WARNING}Now copy the 3rd command from AG dashboard and exucute it here(Creted by CryptonodeHindi)...${NC}"

# Run Docker container
docker run -it --cap-add=NET_ADMIN --mac-address="$mac_address" \
    -v "$fake_product_uuid_file:/sys/class/dmi/id/product_uuid" \
    --name="$device_name" "alliance_games_docker_$device_name_lower"

# Display thank you message
echo "========================================"
echo -e "${GREEN} Thanks for using the script${NC}"
echo -e "-------------------------------------"

# Large ASCII Text with BANNER color
echo -e "${YELLOW}  CCCCC  RRRRR   Y   Y  PPPP   TTTTT  OOO      N   N   OOO   DDDD  EEEEE      H   H  III  N   N  DDDD   III${NC}"
echo -e "${YELLOW} C       R    R    Y Y   P P     T   O   O     NN  N  O   O  D   D E          H   H   I   NN  N  D   D   I ${NC}"
echo -e "${YELLOW} C       RRRRR     Y    PPPP     T   O   O     N N N  O   O  D   D EEEE       HHHHH   I   N N N  D   D   I ${NC}"
echo -e "${YELLOW} C       R   R     Y     P       T   O   O     N  NN  O   O  D   D E          H   H   I   N  NN  D   D   I ${NC}"
echo -e "${YELLOW}  CCCCC  R    R    Y     P       T    OOO      N   N   OOO   DDDD  EEEEE      H   H  III  N   N  DDDD   III${NC}"

echo "============================================"

# Use different colors for each link to make them pop out more
echo -e "${YELLOW}Telegram: ${GREEN}https://t.me/cryptonodehindi${NC}"
echo -e "${YELLOW}Twitter: ${GREEN}@CryptonodeHindi${NC}"
echo -e "${YELLOW}YouTube: ${GREEN}https://www.youtube.com/@CryptonodesHindi${NC}"
echo -e "${YELLOW}Medium: ${GREEN}https://medium.com/@cryptonodehindi${NC}"

echo "============================================="
