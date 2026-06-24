#!/bin/bash
# setup-ssl-certs.sh
# Generates self-signed SSL certificates for Traefik and household AI services

set -e

CERT_DIR="./traefik/certs"
DOMAINS="lthome.us api.lthome.us api-ai.lthome.us traefik-ai.lthome.us"
DAYS_VALID=365

echo "Creating certificate directory..."
mkdir -p "$CERT_DIR"

echo "Generating self-signed certificate for: $DOMAINS"

# Generate private key
openssl genrsa -out "$CERT_DIR/server.key" 2048

# Generate certificate signing request
openssl req -new \
  -key "$CERT_DIR/server.key" \
  -out "$CERT_DIR/server.csr" \
  -subj "/CN=lthome.us/O=Household AI/C=US" \
  -addext "subjectAltName=DNS:lthome.us,DNS:api.lthome.us,DNS:api-ai.lthome.us,DNS:traefik-ai.lthome.us,DNS:*.lthome.us"

# Generate self-signed certificate
openssl x509 -req \
  -days "$DAYS_VALID" \
  -in "$CERT_DIR/server.csr" \
  -signkey "$CERT_DIR/server.key" \
  -out "$CERT_DIR/server.crt" \
  -extfile <(printf "subjectAltName=DNS:lthome.us,DNS:api.lthome.us,DNS:api-ai.lthome.us,DNS:traefik-ai.lthome.us,DNS:*.lthome.us")

# Create combined PEM file (optional, for some use cases)
cat "$CERT_DIR/server.crt" "$CERT_DIR/server.key" > "$CERT_DIR/server.pem"

# Set proper permissions
chmod 600 "$CERT_DIR/server.key" "$CERT_DIR/server.pem"
chmod 644 "$CERT_DIR/server.crt" "$CERT_DIR/server.csr"

echo "✅ Self-signed certificates generated successfully!"
echo ""
echo "Certificate details:"
echo "  Private key: $CERT_DIR/server.key"
echo "  Certificate: $CERT_DIR/server.crt"
echo "  CSR: $CERT_DIR/server.csr"
echo "  Combined PEM: $CERT_DIR/server.pem"
echo "  Valid for: $DAYS_VALID days"
echo ""
echo "Domains covered:"
for domain in $DOMAINS; do
  echo "  - $domain"
done
echo ""
echo "To verify certificate:"
echo "  openssl x509 -in $CERT_DIR/server.crt -text -noout"
echo ""
echo "To use in your system, add this certificate to your OS trusted store"
echo "(on macOS: sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain $CERT_DIR/server.crt)"
