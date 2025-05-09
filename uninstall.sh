#!/bin/bash

echo
echo "----------------------------"
echo " Seeed Voicecard Uninstaller"
echo "----------------------------"
echo

read -p "⚠️  Are you sure you want to remove the 2-Mic Voicecard driver and all audio configurations? [Y/N] " confirm
if [[ "$confirm" != "Y" && "$confirm" != "y" ]]; then
    echo "Uninstallation aborted."
    exit 0
fi

# STEP 1: Remove kernel modules (manually installed)
echo
echo "🧹 Removing kernel modules..."
KERNEL_DIR="/lib/modules/$(uname -r)/kernel/sound/soc"
sudo rm -f "$KERNEL_DIR/codecs/snd-soc-wm8960.ko"
sudo rm -f "$KERNEL_DIR/bcm/snd-soc-seeed-voicecard.ko"
sudo depmod -a
echo "✓ Kernel modules removed (if they existed)."

# STEP 2: Remove Device Tree Overlay
echo
echo "🧹 Removing Device Tree Overlay..."
sudo rm -f /boot/firmware/overlays/seeed-2mic-voicecard-overlay.dtbo
echo "✓ Overlay file removed."

# STEP 3: Clean dtoverlay from config.txt
CONFIG_FILE="/boot/firmware/config.txt"
echo "🧹 Cleaning overlay reference from $CONFIG_FILE..."
sudo sed -i '/^dtoverlay=seeed-2mic-voicecard-overlay/d' "$CONFIG_FILE"
echo "✓ config.txt cleaned."

# STEP 4: Remove ALSA state file
echo
echo "🧹 Removing saved ALSA mixer configuration..."
if [ -f /var/lib/alsa/asound.state ]; then
    read -p "Do you want to remove /var/lib/alsa/asound.state? [Y/N] " remove_alsa
    if [[ "$remove_alsa" =~ ^[Yy]$ ]]; then
        sudo rm -f /var/lib/alsa/asound.state
        echo "✓ ALSA state file removed."
    else
        echo "ℹ️ ALSA state file kept."
    fi
else
    echo "No ALSA state file found. Skipping."
fi

# STEP 5: Optionally remove PulseAudio default sink config
PA_CONFIG=~/.config/pulse/default.pa
if [ -f "$PA_CONFIG" ]; then
    echo
    read -p "Do you want to remove persistent PulseAudio sink config (~/.config/pulse/default.pa)? [Y/N] " remove_pa
    if [[ "$remove_pa" =~ ^[Yy]$ ]]; then
        rm -f "$PA_CONFIG"
        echo "✓ PulseAudio sink config removed."
    else
        echo "ℹ️ PulseAudio sink config kept."
    fi
fi

# STEP 6: Final message
echo
echo "✅ Uninstallation complete. A reboot is recommended."
read -p "Would you like to reboot now? [Y/N] " reboot_now
if [[ "$reboot_now" =~ ^[Yy]$ ]]; then
    sudo reboot
else
    echo "You can reboot later manually."
fi
