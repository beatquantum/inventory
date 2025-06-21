#!/bin/bash

# Shared helper functions for cryptographic inventory sub-scripts

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

get_cert_details() {
    local cert_file="$1"
    if [ -f "$cert_file" ]; then
        echo "  File: $cert_file"
        echo "    Permissions: $(stat -c '%a' "$cert_file")"
        echo "    Owner: $(stat -c '%U:%G' "$cert_file")"
        openssl x509 -in "$cert_file" -noout -subject -issuer -startdate -enddate -fingerprint -text 2>/dev/null | \
        grep -E 'Subject:|Issuer:|Not Before:|Not After:|Fingerprint|Public Key Algorithm|Signature Algorithm' | \
        sed 's/^\s*/    /'
        key_algo=$(openssl x509 -in "$cert_file" -noout -text 2>/dev/null | grep 'Public Key Algorithm:' | sed 's/.*: //')
        echo "    Key Algorithm: ${key_algo:-unknown}"
        if [[ "$key_algo" == "rsaEncryption" ]]; then
            key_size=$(openssl x509 -in "$cert_file" -noout -text 2>/dev/null | grep 'RSA Public-Key:' | sed 's/.*(\([0-9]\+\) bit).*/\1 bit/')
            echo "    Key Size: ${key_size:-N/A}"
        elif [[ "$key_algo" == "id-ecPublicKey" ]]; then
            curve=$(openssl x509 -in "$cert_file" -noout -text 2>/dev/null | grep 'ASN1 OID:' | sed 's/.*ASN1 OID: //')
            echo "    Curve: ${curve:-N/A}"
        fi
    else
        echo "  Certificate file not found: $cert_file"
    fi
}

get_key_details() {
    local key_file="$1"
    if [ -f "$key_file" ]; then
        echo "  File: $key_file"
        echo "    Permissions: $(stat -c '%a' "$key_file")"
        echo "    Owner: $(stat -c '%U:%G' "$key_file")"
        if openssl rsa -in "$key_file" -check -noout 2>/dev/null; then
            echo "    Type: RSA"
            key_size=$(openssl rsa -in "$key_file" -noout -text 2>/dev/null | grep 'Private-Key: (' | sed 's/.*(\([0-9]\+\) bit).*/\1 bit/')
            echo "    Size: ${key_size:-N/A}"
        elif openssl ec -in "$key_file" -noout -text 2>/dev/null | grep -q 'Private-Key'; then
            echo "    Type: EC"
            curve=$(openssl ec -in "$key_file" -noout -text 2>/dev/null | grep 'ASN1 OID:' | sed 's/.*ASN1 OID: //')
            echo "    Curve: ${curve:-unknown}"
        else
            echo "    Key Algorithm: unknown"
        fi
    else
        echo "  Private key file not found: $key_file"
    fi
}
