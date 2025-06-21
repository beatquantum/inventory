#!/bin/bash

# Check if helpers.sh exists before sourcing
if [ -f "./helpers.sh" ]; then
    source ./helpers.sh
else
    echo "Error: helpers.sh not found in current directory"
    exit 1
fi

echo -e "\n11. PHP 8.4-fpm Cryptographic Extensions and Settings"
echo "---------------------------------------------------"
if command_exists php; then
    echo "  Crypto modules:"
    php -m | grep -E 'openssl|sodium|mcrypt|hash' || echo "    None found"
    echo -e "\n  OpenSSL:"
    php -i | grep -q "OpenSSL support => enabled" && { echo "    Enabled"; php -i | grep -E "openssl.cafile|openssl.capath" || echo "    openssl.cafile/capath not set"; } || echo "    Not enabled"
    echo -e "\n  Sodium:"
    php -m | grep -q "sodium" && echo "    Enabled" || echo "    Not enabled"
    echo -e "\n  PHP-FPM Status:"
    systemctl is-active --quiet php8.4-fpm && echo "    Running" || echo "    Not running"
    echo -e "\n  PHP.ini:"
    php --ini | grep -E 'Loaded|Scan'
else
    echo "PHP not installed"
fi

exit 0
