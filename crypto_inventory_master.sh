#!/bin/bash

# Master script for cryptographic inventory

# Source helpers.sh
if [ -f "/home/inventory/helpers.sh" ]; then
    source /home/inventory/helpers.sh
else
    echo "Error: helpers.sh not found in /home/inventory/" >&2
    exit 1
fi

# Output file
output_file="/var/log/inventory.txt"
> "$output_file"

# List of sub-scripts to run
scripts=(
    "system_info.sh"
    "crypto_policy.sh"
    "crypto_libraries.sh"
    "kernel_modules.sh"
    "ciphers_algorithms.sh"
    "ssh_config.sh"
    "ssl_certs.sh"
    "nginx_config.sh"
    "mariadb_config.sh"
    "unbound_config.sh"
    "php_config.sh"
    "crypto_tools.sh"
    "disk_encryption.sh"
    "random_number.sh"
    "firewall_network.sh"
)

# Run each sub-script and append output to inventory file
for script in "${scripts[@]}"; do
    echo "Running $script..." >&2
    if [ -f "/home/inventory/$script" ]; then
        bash "/home/inventory/$script" >> "$output_file" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "$script completed successfully" >&2
        else
            echo "Error running $script" >&2
        fi
    else
        echo "Error: $script not found" >&2
    fi
    echo "" >> "$output_file"
done

echo "Inventory complete. Output saved to $output_file" >&2
echo "======================================" >> "$output_file"
echo "Inventory complete. Output saved to $output_file" >> "$output_file"
