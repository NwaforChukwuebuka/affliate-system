#!/bin/bash

# Affiliate System Stop Script
echo "🛑 Stopping Affiliate System..."

# Stop all services
docker-compose down

echo "✅ All services stopped."
echo ""
echo "💡 To start again, run: ./scripts/start.sh"
echo "🗑️  To remove all data, run: docker-compose down -v" 