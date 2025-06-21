#!/bin/bash

# Check if helpers.sh exists before sourcing
if [ -f "./helpers.sh" ]; then
    source ./helpers.sh
else
    echo "Error: helpers.sh not found in current directory"
    exit 1
fi

echo -e "\n3. Installed Cryptographic Libraries"
echo "----------------------------------"
echo "OpenSSL:"
if command_exists openssl; then
    openssl version
    dpkg -l | grep openssl 2>/dev/null || echo "OpenSSL package info not found"
else
    echo "OpenSSL not installed"
fi
echo -e "\nGnuTLS:"
dpkg -l | grep gnutls 2>/dev/null || echo "GnuTLS not installed"
echo -e "\nLibreSSL:"
dpkg -l | grep libressl 2>/dev/null || echo "LibreSSL not installed"

exit 0
