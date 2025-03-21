#!/bin/bash

set -euo pipefail

if [[ "$#" != "1" ]]; then
    echo "Usage: $0 <device-idx>"
    echo "    Choices: $(ls /dev/rtHST*-0)"
    exit 1
fi

device_idx=$1

tmux new-window "minicom -b 115200 -8 -D /dev/rtHST${device_idx}-0"
tmux split-window -h "minicom -b 115200 -8 -D /dev/rtDBG${device_idx}-0"
tmux split-window -h "minicom -b 115200 -8 -D /dev/rtDBG${device_idx}-1"
tmux rename-window "RT${device_idx} Serial"
tmux select-layout even-horizontal
