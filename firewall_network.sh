#!/bin/bash

echo -e "\n15. Firewall and Network Security"
echo "-------------------------------"
command -v ufw >/dev/null && { echo "UFW status:"; ufw status verbose 2>/dev/null || echo "  Not active"; } || command -v iptables >/dev/null && { echo "iptables rules:"; iptables -L -v -n 2>/dev/null; }
