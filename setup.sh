#!/bin/bash

# Setup script for Household AI Assistant System
# This script initializes the project environment and starts services

set -e

echo "=========================================="
echo "Household AI Assistant - Setup Script"
echo "=========================================="

# Check if .env exists
if [ ! -f .env ]; then
    echo ""
    echo "ERROR: .env file not found!"
    echo "Please copy .env.example to .env and fill in your credentials:"
    echo "  cp .env.example .env"
    echo "  nano .env"
    exit 1
fi

echo ""
echo "✓ .env file exists"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed. Please install Docker and try again."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "ERROR: Docker Compose is not installed. Please install Docker Compose and try again."
    exit 1
fi

echo "✓ Docker and Docker Compose installed"

# Create necessary directories
echo ""
echo "Creating directory structure..."

mkdir -p memory/household
mkdir -p memory/systems
mkdir -p memory/library
mkdir -p memory/food
mkdir -p memory/vehicles
mkdir -p memory/audit

mkdir -p config
mkdir -p agents
mkdir -p skills
mkdir -p services/household-api

echo "✓ Directory structure created"

# Build and start services
echo ""
echo "Building and starting services..."
echo ""

docker-compose build --no-cache
docker-compose up -d

# Wait for services to be healthy
echo ""
echo "Waiting for services to become healthy..."

max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if curl -sf http://localhost:8000/health > /dev/null 2>&1; then
        echo "✓ All services are healthy"
        break
    fi
    
    attempt=$((attempt + 1))
    echo "  Waiting... ($attempt/$max_attempts)"
    sleep 2
done

if [ $attempt -eq $max_attempts ]; then
    echo "⚠ Services took too long to start. Checking logs..."
    docker-compose logs
    exit 1
fi

# Verify database initialization
echo ""
echo "Verifying database..."

docker-compose exec -T postgres psql -U household_ai -d household_ai -c "SELECT 1" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Database is ready"
else
    echo "⚠ Database check failed. You may need to run migrations manually."
fi

# Test basic API endpoints
echo ""
echo "Testing API endpoints..."

echo "  Testing /health..."
curl -sf http://localhost:8000/health > /dev/null && echo "    ✓ /health" || echo "    ✗ /health"

echo "  Testing /integrations/home-assistant/entities..."
curl -sf http://localhost:8000/integrations/home-assistant/entities > /dev/null && echo "    ✓ /integrations/home-assistant/entities" || echo "    ✗ /integrations/home-assistant/entities (may require valid credentials)"

# Print summary
echo ""
echo "=========================================="
echo "✓ Setup Complete!"
echo "=========================================="
echo ""
echo "Services running:"
echo "  • household-api     http://localhost:8000"
echo "  • Postgres          localhost:5432"
echo "  • Redis             localhost:6379"
echo ""
echo "Next steps:"
echo "  1. Verify all services are running:"
echo "     docker-compose ps"
echo ""
echo "  2. Check logs:"
echo "     docker-compose logs -f household-api"
echo ""
echo "  3. Register agents and skills with OpenClaw"
echo "     (Process depends on your OpenClaw setup)"
echo ""
echo "  4. Test by invoking an agent:"
echo "     openclaw invoke agent=household-chief-of-staff ..."
echo ""
echo "  5. View audit logs:"
echo "     docker-compose exec postgres psql -U household_ai -d household_ai -c 'SELECT * FROM audit_logs LIMIT 10;'"
echo ""
echo "For troubleshooting, see README.md"
