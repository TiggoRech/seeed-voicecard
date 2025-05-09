#!/bin/bash

# -------------------------------
# Seeed 2-Mic Voicecard Installer
# -------------------------------

function abort_installation {
    echo "Installation aborted."
    exit 1
}

echo "Have you checked your kernel version (command: uname -r) to ensure your Raspberry Pi 5 is running '6.12.25+rpt-rpi-2712'? [Y/N]"
read -r kernel_confirm
if [[ "$kernel_confirm" != "Y" && "$kernel_confirm" != "y" ]]; then
    abort_installation
fi

echo
echo "We recommend backing up your data in case anything goes wrong."
echo "If you haven't done so but still want to continue, you acknowledge this is at your own risk and we are not responsible for lost data."
echo "Do you agree to proceed? [Y/N]"
read -r backup_confirm
if [[ "$backup_confirm" != "Y" && "$backup_confirm" != "y" ]]; then
    abort_installation
fi

echo
echo "[1/3] Compiling driver source files..."
make
if [ $? -ne 0 ]; then
    echo "Compilation failed. Check for errors above."
    exit 1
fi

echo
echo "[2/3] Installing compiled modules..."
sudo cp snd-soc-wm8960.ko /lib/modules/$(uname -r)/kernel/sound/soc/codecs/
sudo cp snd-soc-seeed-voicecard.ko /lib/modules/$(uname -r)/kernel/sound/soc/bcm/
sudo depmod -a
if [ $? -ne 0 ]; then
    echo "Module installation failed."
    exit 1
fi

echo
echo "[3/3] Running post-installation steps..."
./post_install.sh
