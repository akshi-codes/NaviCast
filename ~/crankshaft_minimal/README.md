# CrankShaft Minimal - Maps-Only Android Auto for Raspberry Pi

A lightweight implementation of Android Auto for Raspberry Pi, optimized for Google Maps display only.

## Overview

This project creates a minimal Android Auto head unit using a Raspberry Pi 4B and a 5" HDMI display. It focuses exclusively on displaying Google Maps from your phone, with:

- Streamlined interface
- Minimal resource usage
- USB connectivity (for reliable testing)
- Simple setup process

## Hardware Requirements

- Raspberry Pi 4B
- 5" HDMI display
- Power supply for Raspberry Pi
- USB cable for connecting to Android phone
- (Optional) Case for mounting

## Software Setup

### 1. Prepare Raspberry Pi

Start with a fresh installation of Raspberry Pi OS (32-bit with Desktop):
1. Download Raspberry Pi OS from https://www.raspberrypi.org/software/operating-systems/
2. Flash it to an SD card using Raspberry Pi Imager
3. Insert the SD card and boot the Raspberry Pi
4. Complete the initial setup (set username, password, locale, etc.)

### 2. Install CrankShaft Minimal

1. Copy the crankshaft_minimal directory to your Raspberry Pi
2. Open a terminal and navigate to the directory:
   ```
   cd ~/crankshaft_minimal
   ```
3. Make the scripts executable:
   ```
   chmod +x *.sh
   ```
4. Run the setup script:
   ```
   ./setup.sh
   ```
   This will install all necessary dependencies and clone the repositories.

### 3. Build the Software

Run the build script to compile aasdk and openauto:
```
./build.sh
```

### 4. Configure the Software

Run the configuration script:
```
./minimal_config.sh
```

### 5. Set Up USB Rules

Install udev rules to allow USB communication with Android devices:
```
sudo cp 51-android.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
```

### 6. Optimize for Maps-Only

For best performance with Google Maps, run:
```
./customize.sh
```

### 7. Reboot

Reboot your Raspberry Pi:
```
sudo reboot
```

## Usage

After rebooting, the Android Auto app should start automatically. If not:

1. Connect your Android phone to the Raspberry Pi with a USB cable
2. Run the launcher script:
   ```
   ./launcher.sh
   ```
3. On your phone, enable Android Auto when prompted
4. Open Google Maps on your phone or select it from the Android Auto interface

## Troubleshooting

If you encounter issues, run the troubleshooting script:
```
./troubleshoot.sh
```

Common issues:
- Phone not detected: Check USB connection and ensure Android Auto is enabled on your phone
- Black screen: Try running the launcher script manually
- Display issues: Adjust the screen resolution in config.txt

## Customization

You can modify `~/.config/openauto/openauto.ini` to change display settings:
- Adjust screen resolution (VideoWidth, VideoHeight)
- Change display properties (ScreenDPI, VideoFPS)
- Enable/disable features (TurnByTurnEnabled)

## Wireless Setup (Advanced)

The current setup uses USB for reliability. For wireless setup:
1. Edit openauto.ini
2. Set `[TCP]` section's `Enabled=true`
3. Configure your phone to connect via wireless Android Auto

## License

This project uses components from:
- aasdk (GNU GPLv3)
- OpenAuto (GNU GPLv3)
- CrankShaft (GNU GPLv3)

Please respect the licenses of all included components. 