#!/bin/bash

source ./helpers.sh

echo -e "\n7. SSL/TLS Certificates and Private Keys"
echo "--------------------------------------"
echo "System CA bundles:"
find /etc/ssl /etc/pki /usr/local/share/ca-certificates -type f \( -name '*.crt' -o -name '*.pem' \) 2>/dev/null | wc -l | xargs echo "Certificates found:"
command_exists update-ca-certificates && { echo "CA package:"; dpkg -l | grep ca-certificates || echo "Not found"; }
echo -e "\nCommon Locations:"
CERT_KEY_DIRS=("/etc/ssl/certs" "/etc/ssl/private" "/etc/nginx/ssl" "/etc/nginx/conf.d" "/etc/nginx/sites-available" "/etc/mariadb/ssl" "/etc/mysql/ssl" "/etc/unbound" "/etc/letsencrypt/live" "/etc/letsencrypt/archive" "/etc/postfix/ssl" "/etc/dovecot/ssl")
declare -A processed
for dir in "${CERT_KEY_DIRS[@]}"; do
    [ -d "$dir" ] || continue
    echo -e "\nScanning: $dir"
    find "$dir" -maxdepth 2 -type f \( -name '*.crt' -o -name '*.pem' -o -name '*.key' -o -name '*.csr' \) -print0 | while IFS= read -r -d $'\0' file; do
        [[ -v processed["$file"] ]] && continue
        if [[ "$file" =~ \.key$ ]]; then
            get_key_details "$file"
        elif [[ "$file" =~ \.pem$ ]]; then
            if openssl pkey -in "$file" -noout 2>/dev/null; then
                get_key_details "$file"
            else
                get_cert_details "$file"
            fi
        elif [[ "$file" =~ \.crt$ ]]; then
            get_cert_details "$file"
        elif [[ "$file" =~ \.csr$ ]]; then
            echo "  File: $file (CSR)"
            stat -c '    Permissions: %a Owner: %U:%G' "$file"
        fi
        processed["$file"]=1
    done
done
