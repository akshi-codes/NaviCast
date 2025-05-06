# CrankShaft Minimal - Installation Guide

This guide provides detailed steps to install and configure the lightweight Android Auto head unit focused on Google Maps display.

## Table of Contents
1. [System Requirements](#system-requirements)
2. [Preparation](#preparation)
3. [Raspberry Pi OS Installation](#raspberry-pi-os-installation)
4. [CrankShaft Minimal Installation](#crankshaft-minimal-installation)
5. [Building the Software](#building-the-software)
6. [Configuration](#configuration)
7. [USB Connection Setup](#usb-connection-setup)
8. [Testing and Usage](#testing-and-usage)
9. [Advanced: Wireless Setup](#advanced-wireless-setup)
10. [Troubleshooting](#troubleshooting)

## System Requirements

- Raspberry Pi 4B (2GB RAM or more recommended)
- 16GB or larger microSD card (Class 10 recommended)
- 5-inch HDMI display
- Power supply for Raspberry Pi (5V/3A recommended)
- USB cable to connect your Android phone
- Keyboard and mouse for initial setup
- Internet connection for installation

## Preparation

1. Download the necessary software:
   - [Raspberry Pi Imager](https://www.raspberrypi.org/software/)
   - [Raspberry Pi OS](https://www.raspberrypi.org/software/operating-systems/) (32-bit with desktop)

2. Ensure your Android phone has:
   - Android Auto app installed
   - Developer settings enabled
   - USB debugging enabled (optional but helpful for troubleshooting)

## Raspberry Pi OS Installation

1. Insert the microSD card into your computer
2. Open Raspberry Pi Imager
3. Click "CHOOSE OS" → "Raspberry Pi OS (32-bit)"
4. Click "CHOOSE STORAGE" and select your microSD card
5. Click the gear icon (⚙️) to access advanced options:
   - Set hostname (e.g., "autoberry")
   - Enable SSH
   - Set username and password
   - Configure Wi-Fi if needed
6. Click "WRITE" and wait for the process to complete
7. Insert the microSD card into your Raspberry Pi
8. Connect the display, keyboard, mouse, and power
9. Boot the Raspberry Pi and complete the initial setup

## CrankShaft Minimal Installation

1. Download the project files to your computer
2. Copy the files to your Raspberry Pi or clone from the repository:
   ```bash
   git clone https://github.com/yourusername/crankshaft_minimal.git
   cd crankshaft_minimal
   ```

3. Make the scripts executable:
   ```bash
   chmod +x *.sh
   ```

4. Run the setup script:
   ```bash
   ./setup.sh
   ```
   This will:
   - Install required dependencies
   - Clone the aasdk and openauto repositories
   - Create additional scripts needed for the project

## Building the Software

1. Run the build script:
   ```bash
   ./build.sh
   ```

2. Wait for the compilation to complete. This may take 20-30 minutes on a Raspberry Pi 4.

3. After successful compilation, the libraries will be installed and ready to use.

## Configuration

1. Run the configuration script:
   ```bash
   ./minimal_config.sh
   ```

2. This will create a configuration file optimized for maps display.

3. Set up USB rules:
   ```bash
   ./create_usb_rules.sh
   sudo cp 51-android.rules /etc/udev/rules.d/
   sudo udevadm control --reload-rules
   ```

4. Reboot your Raspberry Pi:
   ```bash
   sudo reboot
   ```

## USB Connection Setup

1. After the Raspberry Pi reboots, wait for the system to fully start
2. Connect your Android phone to the Raspberry Pi using a USB cable
3. On your phone, you should see a prompt to allow Android Auto
4. Accept the prompt and follow any on-screen instructions
5. If Android Auto doesn't start automatically, run:
   ```bash
   ./launcher.sh
   ```

## Testing and Usage

1. Android Auto should launch and show the main interface
2. Navigate to Google Maps within the Android Auto interface
3. Test if maps are displaying correctly and updating with phone movements
4. If Maps doesn't open automatically, select it from the Android Auto app drawer

**Adjusting Screen Settings:**
If the display doesn't look correct:
1. Edit the configuration:
   ```bash
   nano ~/.config/openauto/openauto.ini
   ```
2. Adjust `VideoWidth` and `VideoHeight` to match your display
3. Adjust `ScreenDPI` if text/icons are too large or small
4. Save and restart the launcher

## Advanced: Wireless Setup

Wireless Android Auto is not fully implemented in this minimal version. Check the official OpenAuto project for wireless capabilities.

## Troubleshooting

If you encounter issues, run the troubleshooting script:
```bash
./troubleshoot.sh
```

Common issues and solutions:

1. **Phone not detected**
   - Make sure your phone is connected properly
   - Check USB cable (some cables only support charging, not data)
   - On your phone, select "File Transfer" mode when prompted for USB connection type
   - Check if Android Auto is enabled on your phone

2. **Black screen or no display**
   - Try running the launcher script manually: `./launcher.sh`
   - Check that display resolution matches your screen in openauto.ini
   - Try different HDMI cable or port

3. **System freezes or crashes**
   - Check power supply is providing enough current (use 5V/3A)
   - Run `dmesg` to check for system errors
   - Check temperature with `vcgencmd measure_temp`

4. **Build failures**
   - Make sure all dependencies were installed correctly
   - Check the output of the setup script for errors
   - Ensure you have sufficient disk space 