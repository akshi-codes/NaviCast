#!/bin/bash

echo "===== CrankShaft Minimal Setup ====="
echo "This will set up a minimal Android Auto head unit focused on Maps mirroring."
echo "Installing dependencies..."

# Install required packages
sudo apt-get update
sudo apt-get install -y libboost-all-dev libusb-1.0-0-dev libssl-dev cmake \
  libqt5multimedia5 libqt5multimedia5-plugins libqt5multimediawidgets5 \
  qtmultimedia5-dev libqt5bluetooth5 libqt5bluetooth5-bin qtconnectivity5-dev \
  pulseaudio librtaudio-dev libprotobuf-dev protobuf-compiler libpulse-dev

echo "Installing Qt5..."
sudo apt-get install -y qtbase5-dev qtdeclarative5-dev qtquickcontrols2-5-dev \
  libqt5svg5-dev qttools5-dev

echo "Cloning repositories..."
# Delete existing directories if they exist
if [ -d "aasdk" ]; then
  echo "Removing existing aasdk directory..."
  rm -rf aasdk
fi

if [ -d "openauto" ]; then
  echo "Removing existing openauto directory..."
  rm -rf openauto
fi

# Clone repositories
git clone https://github.com/f1xpl/aasdk.git
git clone https://github.com/f1xpl/openauto.git

# Create build script
cat > build.sh << 'EOL'
#!/bin/bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create build directories
mkdir -p "${SCRIPT_DIR}/aasdk/build"
mkdir -p "${SCRIPT_DIR}/openauto/build"

# Build aasdk
cd "${SCRIPT_DIR}/aasdk/build"
echo "Building aasdk..."
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc)
sudo make install
sudo ldconfig

# Build openauto
cd "${SCRIPT_DIR}/openauto/build"
echo "Building openauto..."
cmake -DCMAKE_BUILD_TYPE=Release -DRPI_BUILD=TRUE -DAASDK_INCLUDE_DIRS=/usr/local/include -DAASDK_LIBRARIES=/usr/local/lib/libaasdk.so ..
make -j$(nproc)
sudo make install

echo "Build completed successfully!"
EOL

# Create minimal configuration script
cat > minimal_config.sh << 'EOL'
#!/bin/bash

CONFIG_DIR="$HOME/.config/openauto"
mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_DIR/openauto.ini" << 'EOF'
[General]
OMXLayerIndex=0
VideoMarginWidth=0
VideoMarginHeight=0
VideoFPS=30
ScreenDPI=100
RtAudioBuffer=800
DisplayNight=true
TabletMode=false
MaximumScreenScale=false
TouchscreenEnabled=true
Brightness=100
AlphaTrans=64
[Features]
Media=false
Bluetooth=false
GoogleAssistant=false
Navigation=true
EOF

echo "Created minimal configuration optimized for maps display."
EOL

# Create USB rules script
cat > create_usb_rules.sh << 'EOL'
#!/bin/bash

cat > 51-android.rules << 'EOF'
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="2d00", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="2d01", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="2d02", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="2d03", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="2d04", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="2d05", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee1", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee2", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee3", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee4", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee5", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee6", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee7", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee8", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee9", MODE="0660", GROUP="plugdev"
EOF

echo "Created USB rules file 51-android.rules"
echo "To install, run:"
echo "sudo cp 51-android.rules /etc/udev/rules.d/"
echo "sudo udevadm control --reload-rules"
EOL

# Create launcher script
cat > launcher.sh << 'EOL'
#!/bin/bash

# Kill any running instances
pkill -f openauto || true

# Launch openauto
openauto
EOL

# Create troubleshoot script
cat > troubleshoot.sh << 'EOL'
#!/bin/bash

echo "===== CrankShaft Troubleshooting ====="
echo "Checking for USB devices..."
lsusb

echo -e "\nChecking Android Auto service..."
systemctl status openauto 2>/dev/null || echo "Service not running"

echo -e "\nChecking logs..."
journalctl -n 20 | grep -i "openauto\|aasdk" || echo "No recent logs found"

echo -e "\nSystem temperature:"
vcgencmd measure_temp

echo -e "\nMemory usage:"
free -h

echo -e "\nDisk space:"
df -h /

echo -e "\nUSB debugging info:"
dmesg | grep -i "usb\|android" | tail -20
EOL

# Make all scripts executable
chmod +x build.sh
chmod +x minimal_config.sh
chmod +x create_usb_rules.sh
chmod +x launcher.sh
chmod +x troubleshoot.sh

echo "Setup script completed. Follow these steps:"
echo "1. Run: ./build.sh"
echo "2. Run: ./minimal_config.sh"
echo "3. Run: ./create_usb_rules.sh"
echo "4. Run: sudo cp 51-android.rules /etc/udev/rules.d/"
echo "5. Run: sudo udevadm control --reload-rules"
echo "6. Reboot with: sudo reboot"
echo "7. After reboot, connect your phone and run: ./launcher.sh" 