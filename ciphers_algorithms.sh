#!/bin/bash

echo -e "\n5. Available Ciphers and Algorithms"
echo "--------------------------------"
command -v openssl >/dev/null && { echo "OpenSSL ciphers:"; openssl ciphers -v | sort; echo -e "\nOpenSSL digests:"; openssl list -digest-algorithms; } || echo "OpenSSL not available"
