#!/bin/bash

echo -e "\n13. Disk Encryption"
echo "-------------------"
command -v lsblk >/dev/null && { echo "Block devices:"; lsblk -f; }
[ -f /etc/crypttab ] && { echo -e "\nCrypttab:"; cat /etc/crypttab | grep -v '^#'; }
command -v cryptsetup >/dev/null && { echo -e "\nEncrypted partitions:"; cryptsetup status ALL 2>/dev/null || echo "  No mappings found"; }
