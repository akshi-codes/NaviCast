#!/bin/bash

# Wireless Android Auto Setup Script
# This is an advanced feature and may not work with all phones

set -e  # Exit on error

echo "===== CrankShaft Minimal Wireless Setup ====="
echo "This will configure wireless Android Auto capabilities"
echo "WARNING: This is experimental and may not work with all phones"
echo

# Check if user wants to continue
read -p "Continue? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup cancelled."
    exit 1
fi

# Install dependencies
echo "Installing additional dependencies..."
sudo apt-get update
sudo apt-get install -y hostapd dnsmasq

# Configure hostapd (Wi-Fi Access Point)
echo "Configuring hostapd..."
sudo tee /etc/hostapd/hostapd.conf > /dev/null << 'EOF'
interface=wlan0
driver=nl80211
ssid=AndroidAuto-Pi
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=autoberry
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF

# Configure hostapd to use this config
sudo sed -i 's|#DAEMON_CONF=""|DAEMON_CONF="/etc/hostapd/hostapd.conf"|g' /etc/default/hostapd

# Configure dnsmasq (DHCP server)
echo "Configuring dnsmasq..."
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
sudo tee /etc/dnsmasq.conf > /dev/null << 'EOF'
interface=wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
EOF

# Configure static IP for wlan0
echo "Configuring static IP..."
sudo tee -a /etc/dhcpcd.conf > /dev/null << 'EOF'

# Android Auto WiFi configuration
interface wlan0
static ip_address=192.168.4.1/24
nohook wpa_supplicant
EOF

# Enable IP forwarding
echo "Enabling IP forwarding..."
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

# Configure OpenAuto for TCP
echo "Configuring OpenAuto for TCP..."
cat > ~/.config/openauto/openauto.ini << 'EOF'
[General]
OMXLayerIndex=2
MainWindowFrameless=true
BlackScreenEnabled=false
VideoMarginHeight=0
EnableAudioFocus=false
AudioDeviceId=
VideoFPS=30
ScreenDPI=140
OMXCropVideo=false
DPI600x1024=false
TurnByTurnEnabled=true
VideoWidth=800
VideoHeight=480
OperationMode=0
FrameMarginWidth=0
BluetoothAdapterName=
AndroidStatus="[]"
BluetoothAdapterAddress=

[TouchEvents]
Enabled=false
OMXTouchEnabled=false

[Bluetooth]
Enabled=false
DeviceName=RPi
DeviceAdapterType=BCM

[TCP]
Enabled=true
Port=5000
EOF

# Create service to start WiFi AP on boot
echo "Creating startup service..."
sudo tee /etc/systemd/system/androidauto-wifi.service > /dev/null << 'EOF'
[Unit]
Description=Android Auto WiFi AP
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c "systemctl start hostapd && systemctl start dnsmasq"
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Enable services
echo "Enabling services..."
sudo systemctl daemon-reload
sudo systemctl enable hostapd
sudo systemctl enable dnsmasq
sudo systemctl enable androidauto-wifi

# Create a script for checking if wireless is working
cat > ~/crankshaft_minimal/check_wireless.sh << 'EOF'
#!/bin/bash
echo "Checking wireless Android Auto setup..."
echo "WiFi AP Status: $(systemctl is-active hostapd)"
echo "IP Address: $(hostname -I)"
echo "TCP Port 5000 Status: $(netstat -tuln | grep 5000 || echo 'Not running')"
echo "To connect:"
echo "1. Connect to WiFi network 'AndroidAuto-Pi' with password 'autoberry'"
echo "2. On your phone, go to Android Auto settings"
echo "3. Add new car -> Wireless connection"
echo "4. Your phone should detect the Raspberry Pi"
EOF
chmod +x ~/crankshaft_minimal/check_wireless.sh

echo
echo "Wireless setup complete!"
echo "SSID: AndroidAuto-Pi"
echo "Password: autoberry"
echo "IP: 192.168.4.1"
echo "Port: 5000"
echo
echo "After rebooting, run ./check_wireless.sh to verify the setup."
echo "Reboot required to apply changes. Reboot now? (y/n)"
read -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo reboot
fi 