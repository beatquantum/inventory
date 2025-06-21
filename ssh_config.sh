#!/bin/bash

echo -e "\n6. SSH Configuration"
echo "------------------"
echo "SSH Server (/etc/ssh/sshd_config):"
if [ -f /etc/ssh/sshd_config ]; then
    for param in Ciphers KexAlgorithms MACs Protocol PasswordAuthentication PermitRootLogin UsePAM; do
        echo "  $param:"
        grep -i "$param" /etc/ssh/sshd_config | grep -v '^#' || echo "    Not set (default)."
    done
    echo -e "\nSSH Server Status:"
    systemctl is-active --quiet ssh && { echo "  Running."; ssh -V 2>&1 | head -n 1; } || echo "  Not running."
    echo -e "\nSSH Host Keys:"
    [ -d /etc/ssh ] && find /etc/ssh -type f -name 'ssh_host_*_key*' -exec bash -c 'echo "  File: {}"; stat -c "    Permissions: %a\n    Owner: %U:%G" "{}"; ssh-keygen -lf "{}" 2>/dev/null | awk "{print \"    Type/Size: \" \$1 \" \" \$3}"' \;
else
    echo "SSH config not found."
fi
echo -e "\nSSH Client Keys:"
for user_home in /root /home/*; do
    [ -d "${user_home}/.ssh" ] || continue
    echo "  User: $(basename "$user_home")"
    echo "    .ssh: $(stat -c '%a %U:%G' "${user_home}/.ssh")"
    find "${user_home}/.ssh" -maxdepth 1 -type f \( -name 'id_*' -o -name 'authorized_keys' \) -print0 | while IFS= read -r -d $'\0' key_file; do
        echo "    File: $(basename "$key_file")"
        echo "      $(stat -c 'Permissions: %a Owner: %U:%G' "$key_file")"
        if [[ "$key_file" =~ \.pub$ || "$key_file" =~ id_.*$ ]]; then
            ssh-keygen -lf "$key_file" 2>/dev/null | awk '{print "      Type/Size: " $1 " " $3}'
        elif [[ "$(basename "$key_file")" == "authorized_keys" ]]; then
            echo "      Keys: $(grep -v '^#' "$key_file" | wc -l)"
        fi
    done
done
