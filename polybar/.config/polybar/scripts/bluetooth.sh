#!/usr/bin/env bash

# Check if bluetooth is powered on
if ! bluetoothctl show | grep -q "Powered: yes"; then
    echo "Off"
    exit 0
fi

# Get connected devices
devices_connected=$(bluetoothctl devices Connected | wc -l)

if [ "$devices_connected" -eq 0 ]; then
    echo "On"
else
    # Get the name of the first connected device
    device_name=$(bluetoothctl devices Connected | head -n1 | cut -d' ' -f3-)
    if [ "$devices_connected" -eq 1 ]; then
        echo "$device_name"
    else
        echo "$device_name +$((devices_connected - 1))"
    fi
fi
