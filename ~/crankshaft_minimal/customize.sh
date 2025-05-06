#!/bin/bash

# Customization script for Raspberry Pi - Maps-focused setup
# This disables unnecessary services and optimizes for Maps display

set -e  # Exit on error

echo "===== CrankShaft Minimal Customization ====="
echo "This will optimize your Pi for Maps-only display"

# Disable unnecessary services
echo "Disabling unnecessary services..."
sudo systemctl disable bluetooth.service
sudo systemctl disable avahi-daemon.service
sudo systemctl disable triggerhappy.service
sudo systemctl disable cups.service

# Update OpenAuto config for Maps focus
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
Enabled=false
Port=5000
EOF

# Create fullscreen launcher
echo "Setting up autostart in fullscreen..."
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/openauto_fullscreen.desktop << 'EOF'
[Desktop Entry]
Type=Application
Exec=/bin/bash -c "sleep 5 && ~/crankshaft_minimal/launcher.sh"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=OpenAuto Fullscreen
Comment=Android Auto Headunit
EOF

# Performance optimizations
echo "Applying performance optimizations..."

# Create CPU performance settings
sudo tee /etc/rc.local > /dev/null << 'EOF'
#!/bin/sh -e
# RC.local for CrankShaft Minimal

# Set CPU to performance mode
echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Disable HDMI CEC to save resources
/usr/bin/tvservice -o

exit 0
EOF

sudo chmod +x /etc/rc.local

# Add GPU memory split configuration
sudo tee -a /boot/config.txt > /dev/null << 'EOF'

# CrankShaft Minimal optimizations
gpu_mem=128
disable_splash=1
dtoverlay=vc4-fkms-v3d
boot_delay=0
initial_turbo=30
disable_audio=1
EOF

echo "Customization completed. Reboot recommended." 