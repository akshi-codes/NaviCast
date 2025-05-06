#!/bin/bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get parent directory (project root)
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

# Create build directories
mkdir -p "${PROJECT_ROOT}/aasdk/build"
mkdir -p "${PROJECT_ROOT}/openauto/build"

# Clone repositories if they don't exist
if [ ! -d "${PROJECT_ROOT}/aasdk" ]; then
  echo "Cloning AASDK repository..."
  cd "${PROJECT_ROOT}"
  git clone https://github.com/f1xpl/aasdk.git
fi

if [ ! -d "${PROJECT_ROOT}/openauto" ]; then
  echo "Cloning OpenAuto repository..."
  cd "${PROJECT_ROOT}"
  git clone https://github.com/f1xpl/openauto.git
fi

# Build aasdk
cd "${PROJECT_ROOT}/aasdk/build"
echo "Building aasdk..."
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc)
sudo make install
sudo ldconfig

# Build openauto
cd "${PROJECT_ROOT}/openauto/build"
echo "Building openauto..."
cmake -DCMAKE_BUILD_TYPE=Release -DRPI_BUILD=TRUE -DAASDK_INCLUDE_DIRS=/usr/local/include -DAASDK_LIBRARIES=/usr/local/lib/libaasdk.so ..
make -j$(nproc)
sudo make install

echo "Build completed successfully!"
echo "Next steps:"
echo "1. Run: ./minimal_config.sh"
echo "2. Run: ./create_usb_rules.sh"
echo "3. Run: sudo cp 51-android.rules /etc/udev/rules.d/"
echo "4. Run: sudo udevadm control --reload-rules"
echo "5. Reboot: sudo reboot" 