#!/bin/bash

# CrankShaft Minimal - Setup Script
# For Raspberry Pi 4B with focus on Maps mirroring only

set -e  # Exit on error

echo "===== CrankShaft Minimal Setup ====="
echo "This will set up a minimal Android Auto head unit focused on Maps mirroring."

# Create directory structure
mkdir -p ~/crankshaft_minimal/{aasdk,openauto,build}

# Install dependencies
echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install -y libboost-all-dev libusb-1.0-0-dev libssl-dev cmake libqt5multimedia5 libqt5multimedia5-plugins libqt5multimediawidgets5 qtmultimedia5-dev libqt5bluetooth5 libqt5bluetooth5-bin qtconnectivity5-dev pulseaudio librtaudio-dev libprotobuf-dev protobuf-compiler libpulse-dev

# Install Qt
echo "Installing Qt5..."
sudo apt-get install -y qtbase5-dev qtdeclarative5-dev qtquickcontrols2-5-dev libqt5svg5-dev qttools5-dev

# Clone repositories
echo "Cloning repositories..."
cd ~/crankshaft_minimal
git clone --recursive https://github.com/opencardev/aasdk.git
git clone --recursive https://github.com/opencardev/openauto.git

# Create simple build script
cat > ~/crankshaft_minimal/build.sh << 'EOL'
#!/bin/bash
set -e

# Build aasdk
echo "Building aasdk..."
cd ~/crankshaft_minimal/aasdk
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j4
sudo make install
sudo ldconfig

# Build openauto minimal
echo "Building openauto minimal..."
cd ~/crankshaft_minimal/openauto
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DRPI_BUILD=TRUE -DAASDK_INCLUDE_DIRS=/usr/local/include -DAASDK_LIBRARIES=/usr/local/lib/libaasdk.so -DAASDK_PROTO_INCLUDE_DIRS=/usr/local/include -DAASDK_PROTO_LIBRARIES=/usr/local/lib/libaasdk_proto.so ..
make -j4
EOL

# Create minimal configuration script
cat > ~/crankshaft_minimal/minimal_config.sh << 'EOL'
#!/bin/bash
set -e

# Create minimal configuration
mkdir -p ~/.config/openauto
cat > ~/.config/openauto/openauto.ini << 'EOF'
[General]
OMXLayerIndex=2
MainWindowFrameless=false
BlackScreenEnabled=false
VideoMarginHeight=0
EnableAudioFocus=false
AudioDeviceId=
VideoFPS=60
ScreenDPI=140
OMXCropVideo=false
DPI600x1024=false
TurnByTurnEnabled=false
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
Enabled=false
Port=5000
EOF

# Create autostart script
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/openauto.desktop << 'EOF'
[Desktop Entry]
Type=Application
Exec=/bin/bash -c "sleep 5 && ~/crankshaft_minimal/openauto/build/autoapp"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=OpenAuto
Comment=Android Auto Headunit
EOF

echo "Configuration completed"
EOL

# Make scripts executable
chmod +x ~/crankshaft_minimal/build.sh
chmod +x ~/crankshaft_minimal/minimal_config.sh

# Create USB udev rules for Android Auto
cat > ~/crankshaft_minimal/51-android.rules << 'EOL'
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="2d00", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="2d01", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="2d05", MODE="0660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="2d04", MODE="0660", GROUP="plugdev"
EOL

echo "Setup script completed."
echo "Copy this directory to your Raspberry Pi and run the following commands:"
echo "1. chmod +x setup.sh"
echo "2. ./setup.sh"
echo "3. ./build.sh"
echo "4. ./minimal_config.sh"
echo "5. sudo cp 51-android.rules /etc/udev/rules.d/"
echo "6. sudo udevadm control --reload-rules"
echo "7. sudo reboot" 