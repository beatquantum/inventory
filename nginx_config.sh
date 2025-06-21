#!/bin/bash

source ./helpers.sh

echo -e "\n8. Nginx SSL/TLS Configuration"
echo "------------------------------"
if command_exists nginx; then
    NGINX_CONF_FILES=$(find /etc/nginx/ -name "*.conf" -type f 2>/dev/null)
    [ -n "$NGINX_CONF_FILES" ] || { echo "No Nginx config files found."; exit 0; }
    SSL_PROTOCOLS=$(grep -RhE '^\s*ssl_protocols\s+' /etc/nginx/ 2>/dev/null | sed 's/^\s*ssl_protocols\s*//;s/;\s*$//' | sort -u)
    SSL_CIPHERS=$(grep -RhE '^\s*ssl_ciphers\s+' /etc/nginx/ 2>/dev/null | sed 's/^\s*ssl_ciphers\s*//;s/;\s*$//' | sort -u)
    SSL_CERT_KEYS=$(grep -RhE '^\s*(ssl_certificate|ssl_certificate_key)\s+' /etc/nginx/ 2>/dev/null | sed 's/^\s*ssl_certificate_key\s*//;s/^\s*ssl_certificate\s*//;s/;\s*$//' | sort -u)
    HSTS_HEADERS=$(grep -RhE '^\s*add_header\s+Strict-Transport-Security\s+' /etc/nginx/ 2>/dev/null | sort -u)
    OCSP_STAPLING=$(grep -RhE '^\s*ssl_stapling\s+' /etc/nginx/ 2>/dev/null | sort -u)
    DH_PARAM=$(grep -RhE '^\s*ssl_dhparam\s+' /etc/nginx/ 2>/dev/null | sed 's/^\s*ssl_dhparam\s*//;s/;\s*$//' | sort -u)
    echo "  SSL Protocols: ${SSL_PROTOCOLS:-Default}"
    echo "  SSL Ciphers: ${SSL_CIPHERS:-Default}"
    echo "  HSTS Headers: ${HSTS_HEADERS:-Not found}"
    echo "  OCSP Stapling: ${OCSP_STAPLING:-Not found}"
    echo "  DH Param: ${DH_PARAM:-Not set}"
    echo -e "\n  Certificates and Keys:"
    for path in $SSL_CERT_KEYS; do
        if [[ "$path" =~ \.key$ ]]; then
            get_key_details "$path"
        elif [[ "$path" =~ \.(crt|pem)$ ]]; then
            if openssl pkey -in "$path" -noout 2>/dev/null; then
                get_key_details "$path"
            else
                get_cert_details "$path"
            fi
        fi
    done
    nginx -t 2>/dev/null && echo "  Config test: OK" || echo "  Config test: Failed"
else
    echo "Nginx not installed."
fi
