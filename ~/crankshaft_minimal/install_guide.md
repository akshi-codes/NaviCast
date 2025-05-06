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

1. Open a terminal window on your Raspberry Pi
2. Create a directory for the project and navigate to it:
   ```bash
   mkdir -p ~/crankshaft_minimal
   cd ~/crankshaft_minimal
   ```

3. Create the necessary files:

   **Method A: Manual creation**
   - Create setup.sh, launcher.sh, customize.sh, troubleshoot.sh
   - Use a text editor to paste the contents from this guide

   **Method B: Download from repository**
   ```bash
   git clone https://github.com/yourusername/crankshaft_minimal.git .
   ```
   (Replace with actual repository URL if available)

4. Make the scripts executable:
   ```bash
   chmod +x *.sh
   ```

5. Run the setup script:
   ```bash
   ./setup.sh
   ```
   This will:
   - Install required dependencies
   - Clone the aasdk and openauto repositories
   - Create build and configuration scripts

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

3. For the best performance, run the customization script:
   ```bash
   ./customize.sh
   ```

4. Set up USB rules:
   ```bash
   sudo cp 51-android.rules /etc/udev/rules.d/
   sudo udevadm control --reload-rules
   ```

5. Reboot your Raspberry Pi:
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
   ~/crankshaft_minimal/launcher.sh
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

For wireless Android Auto (experimental):

1. Run the wireless setup script:
   ```bash
   ./wifi_setup.sh
   ```

2. After rebooting, your Raspberry Pi will create a Wi-Fi network:
   - SSID: AndroidAuto-Pi
   - Password: autoberry

3. On your Android phone:
   - Connect to the "AndroidAuto-Pi" Wi-Fi network
   - Open Android Auto settings
   - Add new wireless connection

4. To check if wireless is working:
   ```bash
   ./check_wireless.sh
   ```

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
   - Try running build script with `--verbose` for more details
   - Ensure you have sufficient disk space

5. **Poor performance**
   - Run the customize script to optimize performance
   - Close any unnecessary applications
   - Consider overclocking your Raspberry Pi (advanced) 