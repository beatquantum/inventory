#!/bin/bash

# Check if helpers.sh exists before sourcing
if [ -f "./helpers.sh" ]; then
    source ./helpers.sh
else
    echo "Error: helpers.sh not found in current directory"
    exit 1
fi

echo -e "\n4. Cryptographic Kernel Modules and Hardware Acceleration"
echo "---------------------------------------------------"
echo "Kernel Modules:"
lsmod | grep -E 'crypto|aes|sha|cbc|ccm|gcm|xts|cmac|ghash|cryptd' || echo "No common crypto modules found"
echo -e "\nCryptographic Algorithms:"
cat /proc/crypto 2>/dev/null || echo "Cannot access /proc/crypto"
echo -e "\nHardware Acceleration (AES-NI):"
grep -q aes /proc/cpuinfo && echo "AES-NI support detected." || echo "AES-NI not detected."
[ -c /dev/hwrng ] && echo "/dev/hwrng found." || echo "/dev/hwrng not found."
echo -e "\nTPM/HSM Detection:"
if ls -l /dev/tpm* 2>/dev/null | grep -q "tpm"; then
    echo "TPM device(s):"
    ls -l /dev/tpm*
    if command_exists tpm_version; then
        echo "TPM version:"
        tpm_version 2>/dev/null || echo "Failed to get version."
    fi
else
    echo "No TPM detected."
fi
dpkg -l | grep -E "libtpm2-pkcs11|opensc" 2>/dev/null && echo "PKCS#11 libraries detected." || echo "No PKCS#11 libraries."
if command_exists pkcs11-tool; then
    echo "PKCS#11 slots:"
    pkcs11-tool --list-slots 2>/dev/null || echo "Failed to list slots."
fi

exit 0
