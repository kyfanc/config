#!/bin/bash

# Configuration
CONFIG_DIR="./macos-config"
mkdir -p "$CONFIG_DIR"

# Domains to handle
HITOOLBOX="com.apple.HIToolbox"         # Keyboard Languages
HOTKEYS="com.apple.symbolichotkeys"     # Shortcuts
TRACKPAD="com.apple.AppleMultitouchTrackpad"
BT_TRACKPAD="com.apple.driver.AppleBluetoothMultitouch.trackpad"

export_settings() {
    echo "--- Exporting macOS Settings to $CONFIG_DIR ---"

    # 1. Export Complex Plists (Languages & Shortcuts)
    defaults export $HITOOLBOX "$CONFIG_DIR/languages.plist"
    defaults export $HOTKEYS "$CONFIG_DIR/shortcuts.plist"
    
    # 2. Export Three-Finger Drag (Read current state)
    TFD=$(defaults read $TRACKPAD TrackpadThreeFingerDrag 2>/dev/null || echo "0")
    echo "$TFD" > "$CONFIG_DIR/three_finger_drag.txt"

    echo "Export Complete. see $CONFIG_DIR."
}

import_settings() {
    echo "--- Importing macOS Settings ---"

    # 1. Import Complex Plists
    if [ -f "$CONFIG_DIR/languages.plist" ]; then
        defaults import $HITOOLBOX "$CONFIG_DIR/languages.plist"
        echo "✓ Keyboard languages imported."
    fi

    if [ -f "$CONFIG_DIR/shortcuts.plist" ]; then
        defaults import $HOTKEYS "$CONFIG_DIR/shortcuts.plist"
        echo "✓ Shortcuts imported."
    fi

    # 2. Apply Three-Finger Drag
    if [ -f "$CONFIG_DIR/three_finger_drag.txt" ]; then
        VAL=$(cat "$CONFIG_DIR/three_finger_drag.txt")
        BOOL_VAL="false"; [ "$VAL" -eq 1 ] && BOOL_VAL="true"
        
        defaults write $TRACKPAD TrackpadThreeFingerDrag -bool $BOOL_VAL
        defaults write $BT_TRACKPAD TrackpadThreeFingerDrag -bool $BOOL_VAL
        echo "✓ Three-finger drag set to $BOOL_VAL."
    fi

    # 3. Mandatory UI Refresh
    echo "--- Finalizing ---"
    echo "Restarting Dock and SystemUIServer to apply changes..."
    killall Dock 2>/dev/null
    killall SystemUIServer 2>/dev/null
    
    echo "Note: Some changes (Shortcuts/Languages) may require a Logout/Login to take effect."
}

case "$1" in
    export) export_settings ;;
    import) import_settings ;;
    *) echo "Usage: $0 {export|import}" ;;
esac
