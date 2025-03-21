#!/bin/bash

if [[ $# != 1 ]]; then
	echo "Usage: $0 <device-idx>"
    exit 1
fi

device_idx=$1

usb_count=$(ls /dev/serial/by-id/usb-ZEPHYR_LNQ3195_*if00* | wc -l)
uart_count=$(ls /dev/serial/by-id/usb-Silicon_Labs_CP2105_Dual_USB_to_UART_Bridge_Controller_*if00* | wc -l)

if [[ ${usb_count} != "1" || ${uart_count} != "1" ]]; then
    echo "Please ensure only ONE radio is plugged in and turned on - there are currently ${uart_count} plugged in".
    exit 1
fi

host0_path=$(udevadm info /dev/serial/by-id/usb-ZEPHYR_LNQ3195_*if00* | grep "ID_PATH=" | sed s/E:\ ID_PATH=//g)
host1_path=$(udevadm info /dev/serial/by-id/usb-ZEPHYR_LNQ3195_*if03* | grep "ID_PATH=" | sed s/E:\ ID_PATH=//g)
debug0_path=$(udevadm info /dev/serial/by-id/usb-Silicon_Labs_CP2105_Dual_USB_to_UART_Bridge_Controller_*if00* | grep "ID_PATH=" | sed s/E:\ ID_PATH=//g)
debug1_path=$(udevadm info /dev/serial/by-id/usb-Silicon_Labs_CP2105_Dual_USB_to_UART_Bridge_Controller_*if01* | grep "ID_PATH=" | sed s/E:\ ID_PATH=//g)

echo SUBSYSTEM==\"tty\",ENV{ID_PATH}==\"${host0_path}\",SYMLINK+=\"rtHST${device_idx}-0\"
echo SUBSYSTEM==\"tty\",ENV{ID_PATH}==\"${host1_path}\",SYMLINK+=\"rtHST${device_idx}-1\"

echo SUBSYSTEM==\"tty\",ENV{ID_PATH}==\"${debug0_path}\",SYMLINK+=\"rtDBG${device_idx}-0\"
echo SUBSYSTEM==\"tty\",ENV{ID_PATH}==\"${debug1_path}\",SYMLINK+=\"rtDBG${device_idx}-1\"
