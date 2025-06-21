#!/bin/bash

# Check if helpers.sh exists before sourcing
if [ -f "./helpers.sh" ]; then
    source ./helpers.sh
else
    echo "Error: helpers.sh not found in current directory"
    exit 1
fi

echo -e "\n2. System-wide Cryptographic Policy"
echo "-----------------------------------"
if [ -f "/etc/crypto-policies/config" ]; then
    echo "Active policy: $(cat /etc/crypto-policies/config)"
    if command_exists update-crypto-policies; then
        echo "update-crypto-policies command found"
    else
        echo "update-crypto-policies command not found"
    fi
else
    echo "No system-wide crypto policy found at /etc/crypto-policies/config"
fi

exit 0
