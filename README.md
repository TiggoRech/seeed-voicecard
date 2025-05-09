# seeed-voicecard

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![Raspberry Pi](https://img.shields.io/badge/Raspberry%20Pi-A22846?style=for-the-badge&logo=Raspberry%20Pi&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![C](https://img.shields.io/badge/c-%2300599C.svg?style=for-the-badge&logo=c&logoColor=white)
![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![ALSA](https://img.shields.io/badge/ALSA-Audio-brightgreen?style=for-the-badge)
![ReSpeaker](https://img.shields.io/badge/ReSpeaker-Compatible-blue?style=for-the-badge)
![Debian](https://img.shields.io/badge/Debian-D70A53?style=for-the-badge&logo=debian&logoColor=white)
![ARM](https://img.shields.io/badge/ARM-0091BD?style=for-the-badge&logo=arm&logoColor=white)
![I2C](https://img.shields.io/badge/I2C-Enabled-yellowgreen?style=for-the-badge)
![SPI](https://img.shields.io/badge/SPI-Enabled-orange?style=for-the-badge)
![Kernel Module](https://img.shields.io/badge/Kernel-Module-lightgrey?style=for-the-badge)
![DKMS](https://img.shields.io/badge/DKMS-Supported-yellow?style=for-the-badge)
![Pi 4](https://img.shields.io/badge/Raspberry%20Pi%204-Supported-success?style=for-the-badge)
![Pi 5](https://img.shields.io/badge/Raspberry%20Pi%205-Supported-success?style=for-the-badge)

THE CODE HAS NOT BEEN UPDATED YET — FOR NOW, IT IS STILL WARTEM'S ORIGINAL VERSION, BASED ON KERNEL 6.6.

## Overview

This project provides extended drivers for ReSpeaker audio devices, specifically targeting Raspberry Pi 5. It's a fork of Wartem's fork from the official ReSpeaker drivers, with the goal of adding support for newer Raspberry Pi 5 models and implementing diagnostics and tests.

## Current Status - Experimental

- **Compatibility**: Optimized for Raspberry Pi 5 (May work on Pi 4 - Not tested)
- **Testing**: Successfully tested basic I/O audio on Raspberry Pi 5 with ReSpeaker 2-Mics Pi HAT
- **Environment**: 
  - Debian GNU/Linux 12 (bookworm) - Latest version as of 2024-10-01
  - Linux kernel: 6.6.51+rpt-rpi-2712 #1 SMP PREEMPT Debian 1:6.6.51-1+rpt2 (2024-10-01) aarch64 GNU/Linux
- **Functionality**: Supports audio recording and playback using ALSA

### Supported Devices

- [ReSpeaker 2-Mics Pi HAT](https://www.keyestudio.com/keyestudio-5v-respeaker-2-mic-pi-hat-v10-expansion-board-for-raspberry-pi-zero-zero-w-b-p0342.html)

## Features

- Extended support for Raspberry Pi 5 (Not tested on Pi 4)
- Utilizes default ALSA drivers for audio functionality
- Maintains compatibility with Seeed 2-mic voice card (ReSpeaker HAT)
- Includes 2 scripts: config_audio.sh to restore default settings and unistall.sh.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/TiggoRech/seeed-voicecard
   ```
2. Navigate to the project directory:
   ```bash
   cd seeed-voicecard
   ```
3. Run the install.sh script:
   ```bash
   sudo bash expanded_menu.sh
   ```
4. Follow the on-screen instructions to install or uninstall.

## Known Issues

- Clock configuration warning for WM8960 codec (does not affect basic functionality)
- LEDs are currently non-functional

## Troubleshooting

If you encounter any issues, run config_audio.sh to restore the initial installation settings.

## Uninstallation

Uninstallation can be performed using the uninstall.sh script. Please note that this feature has not been fully tested yet, so I cannot guarantee it is working perfectly — but in principle, it should function correctly.

## Disclaimer

This project is a work in progress and is considered experimental. While initial testing has shown promising results, we cannot guarantee full functionality or stability at this stage. We strongly recommend thorough testing before using this in any production environment.

## Acknowledgments

This project is based on the work of the original developers of the Respeaker driver and the fork by HinTak and Wartem. We deeply appreciate their foundational contributions.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.  
