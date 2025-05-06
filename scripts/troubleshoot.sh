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