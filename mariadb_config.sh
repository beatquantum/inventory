#!/bin/bash

source ./helpers.sh

echo -e "\n9. MariaDB SSL/TLS and TDE Configuration"
echo "----------------------------------------"
if command_exists mysql; then
    MARIADB_CONFIG_FILES=$(find /etc/mysql/ /etc/mariadb/ -name "*.cnf" -type f 2>/dev/null)
    [ -n "$MARIADB_CONFIG_FILES" ] || { echo "No MariaDB config files found."; exit 0; }
    SSL_CA=$(grep -RhE '^\s*ssl_ca\s*=' "$MARIADB_CONFIG_FILES" 2>/dev/null | sed 's/^\s*ssl_ca\s*=\s*//' | sort -u)
    SSL_CERT=$(grep -RhE '^\s*ssl_cert\s*=' "$MARIADB_CONFIG_FILES" 2>/dev/null | sed 's/^\s*ssl_cert\s*=\s*//' | sort -u)
    SSL_KEY=$(grep -RhE '^\s*ssl_key\s*=' "$MARIADB_CONFIG_FILES" 2>/dev/null | sed 's/^\s*ssl_key\s*=\s*//' | sort -u)
    TLS_VERSION=$(grep -RhE '^\s*tls_version\s*=' "$MARIADB_CONFIG_FILES" 2>/dev/null | sed 's/^\s*tls_version\s*=\s*//' | sort -u)
    REQUIRE_SECURE=$(grep -RhE '^\s*require_secure_transport' "$MARIADB_CONFIG_FILES" 2>/dev/null | sort -u)
    echo "  SSL_CA: ${SSL_CA:-Not configured}"
    echo "  SSL_CERT: ${SSL_CERT:-Not configured}"
    echo "  SSL_KEY: ${SSL_KEY:-Not configured}"
    echo "  TLS_VERSION: ${TLS_VERSION:-Not configured}"
    echo "  Require Secure Transport: ${REQUIRE_SECURE:-Not configured}"
    [ -n "$SSL_CA" ] && get_cert_details "$SSL_CA"
    [ -n "$SSL_CERT" ] && get_cert_details "$SSL_CERT"
    [ -n "$SSL_KEY" ] && get_key_details "$SSL_KEY"
    echo -e "\n  TLS/SSL Status:"
    mysql -e "SHOW GLOBAL VARIABLES LIKE 'have_ssl';" 2>/dev/null | grep -q 'YES' && { echo "    Enabled"; mysql -e "SHOW GLOBAL VARIABLES LIKE 'ssl_%';"; } || echo "    Not enabled"
    echo -e "\n  TDE Status:"
    mysql -e "SELECT SCHEMA_NAME, DEFAULT_ENCRYPTION FROM INFORMATION_SCHEMA.SCHEMATA WHERE DEFAULT_ENCRYPTION = 'YES';" 2>/dev/null | grep -q . && echo "    Encrypted schemas found." || echo "    No encrypted schemas."
    mysql -e "SELECT TABLE_SCHEMA, TABLE_NAME, ENCRYPTION FROM INFORMATION_SCHEMA.TABLES WHERE ENCRYPTION = 'YES';" 2>/dev/null | grep -q . && echo "    Encrypted tables found." || echo "    No encrypted tables."
else
    echo "MariaDB/MySQL not installed."
fi
