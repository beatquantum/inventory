#!/bin/bash

# Check if helpers.sh exists before sourcing
if [ -f "./helpers.sh" ]; then
    source ./helpers.sh
else
    echo "Error: helpers.sh not found in current directory"
    exit 1
fi

echo -e "\n14. Random Number Generation"
echo "----------------------------"
if [ -f /proc/sys/kernel/random/entropy_avail ]; then
    echo "Entropy: $(cat /proc/sys/kernel/random/entropy_avail)"
    echo "Pool size: $(cat /proc/sys/kernel/random/poolsize)"
else
    echo "Random number generator stats not available"
fi
if command_exists rngd; then
    echo "rng-tools:"
    systemctl is-active --quiet rngd && echo "  Running" || echo "  Not running"
    dpkg -l | grep rng-tools 2>/dev/null || echo "  rng-tools package info not found"
else
    echo "rng-tools not installed"
fi

exit 0
