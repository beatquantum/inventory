#!/bin/bash

# Check if helpers.sh exists before sourcing
if [ -f "./helpers.sh" ]; then
    source ./helpers.sh
else
    echo "Error: helpers.sh not found in current directory"
    exit 1
fi

echo -e "\n10. Unbound DNSSEC and DoT Configuration"
echo "-----------------------------------------------------"
if command_exists unbound; then
    UNBOUND_CONF_FILE="/etc/unbound/unbound.conf"
    if [ -f "$UNBOUND_CONF_FILE" ]; then
        DNSSEC_VALIDATION=$(grep -E '^\s*auto-trust-anchor-file:' "$UNBOUND_CONF_FILE" 2>/dev/null)
        DoT_FORWARDING=$(grep -E '^\s*(forward-tls-upstream|tls-cert-bundle):' "$UNBOUND_CONF_FILE" 2>/dev/null)
        echo "  DNSSEC Anchor: ${DNSSEC_VALIDATION:-Not configured}"
        echo "  DoT Config: ${DoT_FORWARDING:-Not configured}"
        if command_exists dig; then
            if dig dnssec-failed.org +dnssec @127.0.0.1 | grep -q "SERVFAIL"; then
                echo "  DNSSEC validation: Working"
            else
                echo "  DNSSEC validation: Check configuration"
            fi
        else
            echo "  dig command not found, cannot test DNSSEC validation"
        fi
        if command_exists unbound-checkconf; then
            unbound-checkconf "$UNBOUND_CONF_FILE" 2>/dev/null || echo "  Config has errors"
        else
            echo "  unbound-checkconf not found"
        fi
    else
        echo "Unbound config not found at $UNBOUND_CONF_FILE"
    fi
else
    echo "Unbound not installed"
fi

exit 0
