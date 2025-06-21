#!/bin/bash

# Check if helpers.sh exists before sourcing
if [ -f "./helpers.sh" ]; then
    source ./helpers.sh
else
    echo "Error: helpers.sh not found in current directory"
    exit 1
fi

echo -e "\n12. Cryptographic Tools"
echo "--------------------"
tools=(
    "gpg:gpg --version"
    "cryptsetup:cryptsetup --version"
    "keytool:keytool -version"
    "srm:srm --version"
    "shred:shred --version"
    "ssleay:ssleay version"
    "cfssl:cfssl version"
    "certutil:certutil --version"
    "openssl:openssl version"
    "ssh-keygen:ssh -V"
)
for tool in "${tools[@]}"; do
    name="${tool%%:*}"
    cmd="${tool#*:}"
    if command_exists "$name"; then
        output=$(${cmd} 2>&1 | head -n 1 || echo "Version command failed")
        echo "$name: ${output}"
    else
        echo "$name: Not installed"
    fi
done

exit 0
