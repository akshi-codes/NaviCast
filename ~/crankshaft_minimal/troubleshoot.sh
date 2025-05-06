#!/bin/bash

# Troubleshooting script for CrankShaft Minimal
# Helps diagnose common issues

echo "===== CrankShaft Minimal Troubleshooter ====="

# Check if the necessary services and processes are running
echo "Checking system status..."

# Check if autoapp is running
if pgrep -x "autoapp" > /dev/null; then
    echo "[✓] AutoApp is running"
else
    echo "[✗] AutoApp is NOT running"
    echo "    Try running: ~/crankshaft_minimal/launcher.sh"
fi

# Check USB devices
echo -e "\nChecking USB devices..."
USB_DEVICES=$(lsusb)
echo "$USB_DEVICES"

# Look for Android devices
if echo "$USB_DEVICES" | grep -q "18d1"; then
    echo "[✓] Android device detected"
else
    echo "[✗] No Android device detected"
    echo "    Make sure your phone is connected and Android Auto is enabled"
fi

# Check if udev rules are installed
if [ -f /etc/udev/rules.d/51-android.rules ]; then
    echo "[✓] Android udev rules are installed"
else
    echo "[✗] Android udev rules are NOT installed"
    echo "    Run: sudo cp ~/crankshaft_minimal/51-android.rules /etc/udev/rules.d/"
    echo "    Then: sudo udevadm control --reload-rules"
fi

# Check libraries
echo -e "\nChecking required libraries..."
if ldconfig -p | grep -q "libaasdk"; then
    echo "[✓] AASDK library found"
else
    echo "[✗] AASDK library NOT found"
    echo "    Try rebuilding with: cd ~/crankshaft_minimal && ./build.sh"
fi

# Check for log files
echo -e "\nChecking log files..."
if [ -f ~/.config/openauto/openauto.log ]; then
    echo "[✓] Log file exists"
    echo "Last 5 log entries:"
    tail -5 ~/.config/openauto/openauto.log
else
    echo "[✗] No log file found"
fi

# Check display resolution
echo -e "\nCurrent display settings:"
fbset -s | grep "geometry"

echo -e "\nTroubleshooting complete. If issues persist, try:"
echo "1. Disconnect and reconnect your phone"
echo "2. Restart the OpenAuto app: ~/crankshaft_minimal/launcher.sh"
echo "3. Reboot your Raspberry Pi: sudo reboot"
echo "4. Ensure you've run all setup scripts in order" 