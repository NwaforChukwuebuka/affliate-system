#!/bin/bash

# Affiliate System Reset Script
echo "🔄 Resetting Affiliate System..."
echo "⚠️  This will delete all data!"

read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Reset cancelled."
    exit 1
fi

# Stop and remove all containers and volumes
echo "🗑️  Removing containers and volumes..."
docker-compose down -v

# Remove any orphaned volumes
echo "🧹 Cleaning up Docker volumes..."
docker volume prune -f

# Restart the system
echo "🚀 Starting fresh system..."
./scripts/start.sh 