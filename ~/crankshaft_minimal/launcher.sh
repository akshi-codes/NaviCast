#!/bin/bash

# Simple launcher for CrankShaft Minimal
# This script can be run manually to start Android Auto

# Kill any existing autoapp instances
killall -q autoapp || true

# Set display settings
export QT_QPA_EGLFS_PHYSICAL_WIDTH=120
export QT_QPA_EGLFS_PHYSICAL_HEIGHT=68

# Path to autoapp executable
AUTOAPP_PATH=~/crankshaft_minimal/openauto/build/autoapp

echo "Starting Android Auto..."
echo "Connect your phone via USB to begin."
echo "Your phone should prompt to enable Android Auto."

# Launch autoapp
$AUTOAPP_PATH 