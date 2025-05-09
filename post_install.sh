#!/bin/bash

echo
echo "[+] Compiling Device Tree Overlay (.dts -> .dtbo)..."
if [ -f "seeed-2mic-voicecard-overlay.dts" ]; then
    dtc -@ -I dts -O dtb -o seeed-2mic-voicecard-overlay.dtbo seeed-2mic-voicecard-overlay.dts
    echo "✓ Compilation successful: seeed-2mic-voicecard-overlay.dtbo"
else
    echo "❌ Source file seeed-2mic-voicecard-overlay.dts not found!"
    exit 1
fi

echo
echo "[+] Installing Device Tree Overlay to /boot/firmware/overlays/..."
sudo cp seeed-2mic-voicecard-overlay.dtbo /boot/firmware/overlays/
echo "✓ Overlay copied to /boot/firmware/overlays/"

echo
echo "[+] Updating /boot/firmware/config.txt..."
CONFIG_FILE="/boot/firmware/config.txt"

# Add dtoverlay
if ! grep -q "^dtoverlay=seeed-2mic-voicecard-overlay" "$CONFIG_FILE"; then
    echo "dtoverlay=seeed-2mic-voicecard-overlay" | sudo tee -a "$CONFIG_FILE" > /dev/null
    echo "✓ dtoverlay added to config.txt"
else
    echo "✓ dtoverlay already present in config.txt."
fi

# Handle i2c_arm=on
if grep -q "^#dtparam=i2c_arm=on" "$CONFIG_FILE"; then
    sudo sed -i 's/^#dtparam=i2c_arm=on/dtparam=i2c_arm=on/' "$CONFIG_FILE"
    echo "✓ Uncommented existing i2c_arm=on in config.txt"
elif ! grep -q "^dtparam=i2c_arm=on" "$CONFIG_FILE"; then
    echo "# Enable I2C for Seeed WM8960 control" | sudo tee -a "$CONFIG_FILE" > /dev/null
    echo "dtparam=i2c_arm=on" | sudo tee -a "$CONFIG_FILE" > /dev/null
    echo "✓ Added i2c_arm=on to config.txt"
else
    echo "✓ i2c_arm=on already active in config.txt"
fi

# Handle i2s=on
if grep -q "^#dtparam=i2s=on" "$CONFIG_FILE"; then
    sudo sed -i 's/^#dtparam=i2s=on/dtparam=i2s=on/' "$CONFIG_FILE"
    echo "✓ Uncommented existing i2s=on in config.txt"
elif ! grep -q "^dtparam=i2s=on" "$CONFIG_FILE"; then
    echo "# Enable I2S for digital audio communication" | sudo tee -a "$CONFIG_FILE" > /dev/null
    echo "dtparam=i2s=on" | sudo tee -a "$CONFIG_FILE" > /dev/null
    echo "✓ Added i2s=on to config.txt"
else
    echo "✓ i2s=on already active in config.txt"
fi

echo
echo "[+] Preparing ALSA mixer configuration..."
if [ -f asound.state ]; then
    echo "✓ Found asound.state"
    echo "📁 Copying to /var/lib/alsa/asound.state"
    sudo cp asound.state /var/lib/alsa/asound.state
    echo "✓ ALSA mixer state file is in place and will be applied at next boot."
else
    echo "⚠️ asound.state not found. Skipping mixer setup."
fi

echo
echo "[ℹ️] To adjust or save new mixer settings later, use:"
echo "    alsamixer  (to adjust)"
echo "    sudo alsactl store  (to save)"

echo
echo "To complete installation, a reboot is required."
read -p "Would you like to reboot now? [Y/N] " reboot_now
if [[ "$reboot_now" == "Y" || "$reboot_now" == "y" ]]; then
    echo "Rebooting..."
    sudo reboot
else
    echo "Reboot skipped. Run './config_audio.sh' manually after reboot."
    read -p "Press Enter to finish..."
fi
