# Affiliate System - AI Lead Enrichment

Complete affiliate system that collects leads from social media and enriches them using FREE Mistral AI via OpenRouter.

## Prerequisites

- Docker and Docker Compose
- FREE OpenRouter API key from [https://openrouter.ai/](https://openrouter.ai/)

## Quick Start

### 1. Environment Setup

```bash
git clone <repository-url>
cd Affiliate-system
cp .env.example .env
```

Edit `.env` with your credentials:
```bash
# Required: FREE OpenRouter API Key
OPENROUTER_API_KEY=sk-or-v1-your-free-api-key-here

# Optional: PhantomBuster API Key for real Twitter scraping
PHANTOMBUSTER_API_KEY=your_phantombuster_api_key_here

# Optional: Email configuration for outreach
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_app_password
FROM_EMAIL=your_email@gmail.com

# Database credentials (defaults work)
POSTGRES_PASSWORD=affiliate_pass
N8N_PASSWORD=admin123
```

### 2. Start the System

```bash
docker-compose up -d
docker-compose ps  # Check status
```

### 3. Configure n8n Credentials

Access n8n at http://localhost:5678 (admin/admin123)

**Add PostgreSQL Credential:**
- Settings > Credentials > Add "PostgreSQL"
- Name: `PostgreSQL Affiliate DB`
- Host: `postgres`, Database: `affiliate_system`
- User: `affiliate_user`, Password: `affiliate_pass`, Port: `5432`

**Add OpenRouter API Credential:**
- Add "HTTP Header Auth" credential
- Name: `OpenRouter API`
- Header Name: `Authorization`
- Header Value: `Bearer YOUR_OPENROUTER_API_KEY`

**Add SMTP Credential (Optional):**
- Add "SMTP" credential
- Name: `SMTP account`
- Host: `smtp.gmail.com`, Port: `587`, Secure: `false`
- User: Your email, Password: Your app password

**Add PhantomBuster Credential (Optional):**
- Add "HTTP Header Auth" credential
- Name: `PhantomBuster API`
- Header Name: `X-Phantombuster-Key`
- Header Value: Your PhantomBuster API key

### 4. Import and Run Workflows

1. Import workflows from `workflows/` folder
2. Execute "Lead Generation" to create sample leads
3. Execute "Lead Enrichment" to enrich with Mistral AI
4. Execute "Outreach Automation" for email campaigns

## Database Access

```bash
docker exec -it affiliate_postgres psql -U affiliate_user -d affiliate_system
SELECT * FROM leads LIMIT 5;
SELECT * FROM enriched_leads LIMIT 5;
```

## Key Decisions or Tradeoffs

### Technology Choices
- **FREE Mistral AI via OpenRouter**: Chose this over OpenAI to eliminate API costs while maintaining quality AI enrichment capabilities
- **Docker Compose**: Simplified deployment and environment consistency across different systems
- **PostgreSQL**: Robust relational database with excellent JSON support for flexible lead data storage
- **n8n**: Visual workflow builder that makes automation accessible to non-developers and easy to modify

### Architecture Decisions
- **Batch Processing**: Designed workflows to process leads in batches rather than real-time to optimize API usage and costs
- **Modular Workflows**: Separated lead generation, enrichment, and outreach into distinct workflows for better maintainability
- **Database Schema**: Used separate tables (`leads` and `enriched_leads`) to maintain data integrity and allow for multiple enrichment attempts
- **Credential Management**: Centralized API credentials in n8n for security and easy rotation

### Performance vs. Cost Tradeoffs
- **Sample Data Approach**: Used generated sample leads instead of real scraping to avoid API costs during development
- **Free AI Model**: Accepts slightly longer response times in exchange for zero AI costs
- **Local Database**: Docker PostgreSQL for development simplicity over managed cloud databases



### Feature Improvements
- **Multi-Platform Support**: Extend to LinkedIn, Instagram, and Facebook lead generation
- **Advanced AI**: Implement conversation threads, sentiment analysis, and lead scoring models
- **Real-time Processing**: WebSocket-based real-time lead updates and notifications
- **Analytics Dashboard**: Business intelligence dashboard for campaign performance tracking

## Support

Check Docker logs: `docker-compose logs -f` 