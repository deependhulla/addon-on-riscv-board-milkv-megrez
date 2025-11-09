#/!bin/bash

# Script: 02-all-eswin-es-sdk-pacakges-setup.sh
# Purpose: Installs the necessary Eswin ES-SDK packages and libraries on the
#          MilkV Megrez board for NPU (Neural Processing Unit) development and testing.

## 1. Eswin ES-SDK Installation
############################################################

# Install all packages related to the Eswin ES-SDK from the configured RockOS repositories.
# These packages contain libraries, tools, and headers required for compiling and running
# NPU applications and sample code (e.g., samd samples, computer vision models).
# The wildcard ('*') ensures all relevant 'es-sdk' components are installed.


apt-get -y install es-sdk-*


## 2. External SDK Development Note (For Host PC)
############################################################

# NOTE for Cross-Development:
# If you are developing and building the SDK on an **x86 (Intel/AMD) Linux PC**
# (not directly on the Milkv Megrez board), you are suggested to download all
# necessary files from the Eswin SDK public mirror:
#
# Eswin SDK Release Files:
# https://fast-mirror.isrc.ac.cn/rockos/nn_tools/EIC7x_Release_20250130/

# For working specifically on **computer vision models** (like YOLOv3) using the NPU,
# refer to the official development guide for detailed steps and configuration:
#
# Computer Vision Model Guide (YOLOv3 Example):
# https://milkv.io/docs/megrez/development-guide/ENNP-SDK/yolov3

echo "---------------------------------------------------------------------------"
echo "SDK package setup finished. Ready for NPU development."
echo "---------------------------------------------------------------------------"

