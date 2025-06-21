#!/bin/bash

echo -e "\n1. System Information"
echo "-------------------"
uname -a
lsb_release -a 2>/dev/null || echo "lsb_release not found"
echo "Kernel: $(cat /proc/version)"
