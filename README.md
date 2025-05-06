# CrankShaft Minimal

A lightweight Android Auto head unit for Raspberry Pi, focusing primarily on Google Maps mirroring.

## Overview

CrankShaft Minimal is a simplified version of Android Auto for Raspberry Pi, designed to be easy to install and configure. It focuses on providing a clean Maps interface with minimal distractions, perfect for DIY car projects.

## Features

- Display Google Maps from your Android phone
- Touchscreen support
- USB connection to your phone
- Optimized for Raspberry Pi 4
- Simple installation and configuration

## Quick Installation

To install on your Raspberry Pi:

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/CrankShaft_NG.git
   cd CrankShaft_NG/scripts
   ```

2. Make scripts executable:
   ```bash
   chmod +x *.sh
   ```

3. Run the setup script:
   ```bash
   ./setup.sh
   ```

4. Follow the remaining steps displayed after setup completes.

## Directory Structure

- `scripts/` - Contains all shell scripts needed for installation and operation
- `docs/` - Documentation including installation guide and troubleshooting
- `configs/` - Configuration files for Android Auto and USB rules

## Requirements

- Raspberry Pi 4 (2GB+ RAM recommended)
- 5V/3A power supply
- Display with HDMI input
- Android phone with Android Auto app installed
- USB cable (data capable, not just charging)

## Documentation

For detailed installation instructions, see the [Installation Guide](docs/install_guide.md).

## Troubleshooting

If you encounter issues, run:
```bash
./troubleshoot.sh
```

Common issues and solutions are documented in the [Installation Guide](docs/install_guide.md#troubleshooting).

## Credits

This project builds upon:
- [OpenAuto](https://github.com/f1xpl/openauto) by f1xpl
- [AASDK](https://github.com/f1xpl/aasdk) by f1xpl

## License

This project is licensed under the MIT License - see the LICENSE file for details. 