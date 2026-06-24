#!/usr/bin/env bash
# Household AI with Traefik - Quick Start Guide
# This script helps you get started with the Traefik-enabled deployment

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "🏠 Household AI with Traefik - Setup"
echo "===================================="
echo ""

# Step 1: Generate SSL certificates
echo "📜 Step 1: Generating SSL Certificates..."
if [ ! -f "./traefik/certs/server.key" ]; then
    if [ -f "./setup-ssl-certs.sh" ]; then
        bash ./setup-ssl-certs.sh
    else
        echo "⚠️  setup-ssl-certs.sh not found"
        exit 1
    fi
else
    echo "✅ SSL certificates already exist"
fi
echo ""

# Step 2: Check for .env file
echo "🔐 Step 2: Environment Configuration..."
if [ ! -f ".env" ]; then
    if [ -f ".env.traefik.example" ]; then
        cp .env.traefik.example .env
        echo "📝 Created .env from .env.traefik.example"
        echo "⚠️  IMPORTANT: Edit .env with your credentials before starting!"
        echo ""
        echo "Required variables to configure:"
        echo "  - OPENAI_API_KEY (or set MOCK_INTEGRATIONS=true)"
        echo "  - HOME_ASSISTANT_TOKEN"
        echo "  - POSTGRES_PASSWORD"
        echo "  - Other service credentials..."
        echo ""
        exit 1
    else
        echo "⚠️  .env.traefik.example not found"
        exit 1
    fi
else
    echo "✅ .env file exists"
fi
echo ""

# Step 3: Configure hosts file
echo "🌐 Step 3: Hosts File Configuration..."
echo "Add these entries to your /etc/hosts (Linux/macOS) or C:\\Windows\\System32\\drivers\\etc\\hosts (Windows):"
echo ""
echo "127.0.0.1   api.lthome.us"
echo "127.0.0.1   api-ai.lthome.us"
echo "127.0.0.1   traefik-ai.lthome.us"
echo ""
if grep -q "api.lthome.us" /etc/hosts 2>/dev/null; then
    echo "✅ Hosts file entries already configured"
else
    echo "⚠️  Hosts file not configured. Please add the entries above manually."
fi
echo ""

# Step 4: Start services
echo "🚀 Step 4: Starting Services..."
echo "Run the following command:"
echo ""
echo "  docker-compose -f docker-compose.traefik.yml up -d"
echo ""
echo "Then check status with:"
echo "  docker-compose -f docker-compose.traefik.yml ps"
echo ""

# Step 5: Access services
echo "🔗 Step 5: Access Services"
echo "Once all services are healthy, access them at:"
echo ""
echo "  🎛️  Traefik Dashboard: https://traefik-ai.lthome.us"
echo "  🤖 OpenClaw API: https://api.lthome.us"
echo "  🏠 Household API: https://api-ai.lthome.us"
echo ""
echo "Note: You'll see SSL certificate warnings (self-signed). This is normal."
echo "Trust the certificate in your OS to remove warnings (see traefik/README.md)."
echo ""

echo "✅ Setup complete! Follow the steps above to start the system."
