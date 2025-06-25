#!/bin/bash

# Affiliate System Startup Script
echo "🚀 Starting Affiliate System..."

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Copying from .env.example..."
    cp .env.example .env
    echo "📝 Please edit .env file with your credentials before continuing."
    echo "   Required: OPENAI_API_KEY"
    exit 1
fi

# Create directories if they don't exist
mkdir -p sql workflows

# Start the services
echo "🐳 Starting Docker services..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 10

# Check service status
echo "📊 Service Status:"
docker-compose ps

# Check if PostgreSQL is ready
echo "🗄️  Checking database connection..."
until docker exec affiliate_postgres pg_isready -U affiliate_user; do
    echo "Waiting for PostgreSQL..."
    sleep 2
done

echo "✅ PostgreSQL is ready!"

# Check if n8n is ready
echo "🔧 Checking n8n service..."
until curl -s http://localhost:5678 >/dev/null; do
    echo "Waiting for n8n..."
    sleep 2
done

echo "✅ n8n is ready!"

echo ""
echo "🎉 Affiliate System is now running!"
echo ""
echo "📍 Access points:"
echo "   • n8n Interface: http://localhost:5678"
echo "     Username: admin"
echo "     Password: admin123 (or check your .env file)"
echo ""
echo "   • PostgreSQL: localhost:5432"
echo "     Database: affiliate_system"
echo "     Username: affiliate_user"
echo "     Password: affiliate_pass (or check your .env file)"
echo ""
echo "📚 Next steps:"
echo "   1. Go to http://localhost:5678 and login"
echo "   2. Set up credentials (PostgreSQL, OpenAI, SMTP)"
echo "   3. Import workflows from the workflows/ directory"
echo "   4. Run the Lead Generation workflow to create sample data"
echo "   5. Run the Lead Enrichment workflow to test OpenAI integration"
echo ""
echo "📖 For detailed instructions, see README.md" 