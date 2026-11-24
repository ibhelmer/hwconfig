#!/usr/bin/env bash
# Copyright 2026 Ib Helmer Nielsen
# SPDX-License-Identifier: Apache-2.0
# Licensed under the Apache License, Version 2.0.
# http://www.apache.org/licenses/LICENSE-2.0
# Distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND.

set -u
export LC_ALL=C

section() { printf '\n===== %s =====\n' "$1"; }
run() {
    local cmd=$1
    if command -v "$cmd" >/dev/null 2>&1; then
        "$@" || printf 'Command failed: %s\n' "$cmd" >&2
    else
        printf 'Optional command not installed: %s\n' "$cmd"
    fi
}

case "${1:-}" in
    -h|--help) echo "Usage: $0 [--help]"; exit 0 ;;
    "") ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
esac

section "SYSTEM"
run hostnamectl
run uname -srmo
run systemd-detect-virt

section "CPU"
run lscpu

section "MEMORY"
run free -h

section "MOTHERBOARD AND BIOS"
for field in sys_vendor product_name board_vendor board_name bios_vendor bios_version bios_date; do
    file="/sys/class/dmi/id/$field"
    if [[ -r "$file" ]]; then
        printf '%-18s %s\n' "$field" "$(cat "$file")"
    fi
done

section "STORAGE DEVICES"
run lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL,TRAN,ROTA
section "FILESYSTEM USAGE"
run df -hT

section "PCI DEVICES (including GPU and network controllers)"
run lspci -nnk
section "USB DEVICES"
run lsusb

section "NETWORK INTERFACES"
run ip -br link
run ip -br address

section "DETAILED HARDWARE INVENTORY"
if (( EUID == 0 )); then
    run lshw -sanitize -short
    section "PHYSICAL MEMORY MODULES"
    if command -v dmidecode >/dev/null 2>&1; then
        dmidecode -t memory | grep -E '^[[:space:]]*(Size|Type|Speed|Configured Memory Speed|Locator|Manufacturer|Part Number):' || true
    else
        echo "Optional command not installed: dmidecode"
    fi
else
    echo "Run with sudo for detailed hardware inventory and physical RAM modules."
fi

section "TEMPERATURE SENSORS"
run sensors
printf '\nReport complete.\n'
