#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# 1. Ensure cabextract is installed (required to unpack the firmware)
dnf install -y cabextract

# 2. Download the official Microsoft driver bundle
URL='http://download.windowsupdate.com/c/msdownload/update/driver/drvs/2017/07/1cd6a87c-623f-4407-a52d-c31be49e925c_e19f60808bdcbfbd3c3df6be3e71ffc52e43261e.cab'
curl -L -o driver.cab "$URL"

# 3. Extract and move the firmware to the system directory
cabextract -F FW_ACC_00U.bin driver.cab
mkdir -p /usr/lib/firmware
mv FW_ACC_00U.bin /usr/lib/firmware/xone_dongle.bin

# 4. Clean up temporary files
rm driver.cab

echo 'This is an example shell script'
echo 'Scripts here will run during build if specified in recipe.yml'
