#!/bin/bash

set -euo pipefail

if [[ "$#" != "2" ]]; then
    SILICON_LABS_IDS=$(ls /dev/serial/by-id/usb-Silicon_Labs_CP2105_Dual_USB_to_UART_Bridge_Controller_*if00* | sort | uniq | sed -E 's/.*([0-9A-F]{8}).*/\1/' | tr '\n' ' ')
    ZEPHYR_IDS=$(ls /dev/serial/by-id/usb-ZEPHYR_LNQ3195_* | sed -E 's/.*([0-9A-F]{16}).*/\1/' | sort | uniq | tr '\n' ' ')

    echo "Usage: $0 <zephyr-id> <silicon-labs-id>"
    echo "    Zephyr IDs: ${ZEPHYR_IDS}"
    echo "    Silicon Labs IDs: ${SILICON_LABS_IDS}"
    exit 1
fi

ZEPHYR_ID=$1
SILICON_LABS_ID=$2

tmux new-window "tio -b 115200 /dev/serial/by-id/usb-ZEPHYR_LNQ3195_${ZEPHYR_ID}-if00"
tmux split-window -h "tio -b 115200 /dev/serial/by-id/usb-Silicon_Labs_CP2105_Dual_USB_to_UART_Bridge_Controller_${SILICON_LABS_ID}-if00-port0"
tmux split-window -h "tio -b 115200 /dev/serial/by-id/usb-Silicon_Labs_CP2105_Dual_USB_to_UART_Bridge_Controller_${SILICON_LABS_ID}-if01-port0"
tmux select-layout even-horizontal
