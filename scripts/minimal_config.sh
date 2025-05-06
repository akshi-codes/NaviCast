#!/bin/bash

CONFIG_DIR="$HOME/.config/openauto"
mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_DIR/openauto.ini" << 'EOF'
[General]
OMXLayerIndex=0
VideoMarginWidth=0
VideoMarginHeight=0
VideoFPS=30
ScreenDPI=100
RtAudioBuffer=800
DisplayNight=true
TabletMode=false
MaximumScreenScale=false
TouchscreenEnabled=true
Brightness=100
AlphaTrans=64
[Features]
Media=false
Bluetooth=false
GoogleAssistant=false
Navigation=true
EOF

echo "Created minimal configuration optimized for maps display." 