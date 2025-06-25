# Affiliate System - AI Automation Engineer Assessment

A complete multi-platform affiliate system that collects leads from social media, enriches them using **FREE Mistral AI** (via OpenRouter), and automates personalized outreach campaigns.

## 🏗️ Architecture Overview

This system consists of:
- **Lead Generation**: Collects leads from Twitter (simulated data for demo)
- **AI Enrichment**: Uses **FREE Mistral AI** via OpenRouter (no costs!) to analyze leads and generate personalized content
- **Outreach Automation**: Sends personalized emails and tracks engagement
- **PostgreSQL Database**: Stores leads and enrichment data
- **n8n Workflows**: Orchestrates all automation processes

## 📋 Prerequisites

- Docker and Docker Compose
- **OpenRouter API key** (FREE - no credit card required!)
- SMTP email account (for outreach - optional for demo)

## 🚀 Quick Start (100% FREE Setup!)

### 1. Clone and Setup

```bash
git clone <repository-url>
cd Affiliate-system

# Copy environment file and configure
cp .env.example .env
```

### 2. Get FREE OpenRouter API Key

1. **Visit**: [https://openrouter.ai/](https://openrouter.ai/)
2. **Sign up** for a completely free account (no credit card needed!)
3. **Go to "Keys"** section in your dashboard
4. **Create a new API key**
5. **Copy the key** - you'll need it for the next step

### 3. Configure Environment Variables

Edit the `.env` file with your credentials:

```bash
# Required: FREE OpenRouter API Key (replaces expensive OpenAI!)
OPENROUTER_API_KEY=sk-or-v1-your-free-api-key-here

# Optional: OpenAI (only if you prefer paid option)
# OPENAI_API_KEY=your_openai_api_key_here

# Optional: Email configuration for real outreach
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_app_password
FROM_EMAIL=your_email@gmail.com

# Database and n8n credentials (defaults work for demo)
POSTGRES_PASSWORD=affiliate_pass
N8N_PASSWORD=admin123
```

### 4. Start the System

```bash
# Start all services
docker-compose up -d

# Check service status
docker-compose ps
```

### 5. Access the Applications

- **n8n Interface**: http://localhost:5678
  - Username: `admin`
  - Password: `admin123` (or your custom password)
- **PostgreSQL**: localhost:5432
  - Database: `affiliate_system`
  - Username: `affiliate_user`
  - Password: `affiliate_pass`

## 🔧 System Configuration

### Database Setup

The database will be automatically initialized with:
- `leads` table for storing collected leads
- `enriched_leads` table for AI-enriched data
- Sample data for testing

### n8n Workflow Setup

1. **Access n8n**: Navigate to http://localhost:5678
2. **Login** with credentials from your `.env` file
3. **Configure Credentials**:

#### PostgreSQL Credential
- Go to Settings > Credentials
- Add new credential: "PostgreSQL"
- Name: `PostgreSQL Affiliate DB`
- Host: `postgres`
- Database: `affiliate_system`
- User: `affiliate_user`
- Password: `affiliate_pass`
- Port: `5432`

#### OpenRouter Credential (Free Mistral API)
- Add new credential: "HTTP Header Auth"
- Name: `OpenRouter API`
- Header Name: `Authorization`
- Header Value: `Bearer YOUR_OPENROUTER_API_KEY`

**Getting a Free OpenRouter API Key:**
1. Visit [OpenRouter.ai](https://openrouter.ai/)
2. Sign up for a free account
3. Go to "Keys" section in your dashboard
4. Create a new API key
5. Copy the key and add it to your `.env` file as `OPENROUTER_API_KEY=your_key_here`
6. The free tier includes access to Mistral 7B Instruct model

#### OpenAI Credential (Optional - if you prefer paid OpenAI)
- Add new credential: "OpenAI"
- Name: `OpenAI API`
- API Key: Your OpenAI API key from `.env`

#### SMTP Credential (Optional)
- Add new credential: "SMTP"
- Name: `SMTP Email Account`
- Host: `smtp.gmail.com`
- Port: `587`
- Secure: `false`
- User: Your email
- Password: Your app password

#### PhantomBuster Credential (For Real Twitter Scraping)
- Add new credential: "HTTP Header Auth"
- Name: `PhantomBuster API`
- Header Name: `X-Phantombuster-Key`
- Header Value: Your PhantomBuster API key from `.env`

### Import Workflows

1. **Import Lead Generation Workflow**:
   - Go to Workflows
   - Click "Import from file"
   - Select `workflows/lead_generation.json`

2. **Import PhantomBuster Lead Generation** (For Real Twitter Scraping):
   - Import `workflows/lead_generation_phantombuster.json`
   - **Note**: Requires PhantomBuster API key and setup (see `phantombuster-setup-guide.md`)

3. **Import Lead Enrichment Workflow (Mistral - FREE)**:
   - Import `workflows/lead_enrichment.json`
   - **Note**: Uses free Mistral model via OpenRouter - no costs!

4. **Import Outreach Automation**:
   - Import `workflows/outreach_automation.json`

## 📊 Usage

### Option A: Generate Sample Leads (Demo)

1. Open the "Lead Generation - Twitter" workflow
2. Click "Execute Workflow"
3. This will insert 5 fake Twitter leads into the database

### Option B: Real Twitter Lead Generation with PhantomBuster

1. **Setup PhantomBuster** (see `phantombuster-setup-guide.md`):
   - Create PhantomBuster account
   - Add API key to `.env` file
   - Configure required phantoms
   
2. **Run Real Lead Generation**:
   - Open "Lead Generation - PhantomBuster Twitter" workflow
   - Update phantom IDs in the configuration node
   - Click "Execute Workflow"
   - This will scrape real Twitter profiles and extract lead data

### 2. Enrich Leads with AI

1. Open the "Lead Enrichment - OpenAI" workflow
2. Click "Execute Workflow"
3. The workflow will:
   - Find unenriched leads
   - Send them to OpenAI for analysis
   - Store enriched data (niche, score, personalized messages)

### 3. Run Outreach Campaign

1. Open the "Outreach Automation" workflow
2. Click "Execute Workflow"
3. The workflow will:
   - Find high-scoring, compliant leads
   - Generate personalized emails
   - Send emails (or simulate for demo)
   - Mark leads as contacted

## 🔍 Monitoring and Logs

### View Database Data

Connect to PostgreSQL to view results:

```bash
# Connect to database
docker exec -it affiliate_postgres psql -U affiliate_user -d affiliate_system

# View leads
SELECT * FROM leads LIMIT 10;

# View enriched leads
SELECT l.name, el.niche, el.score, el.notes 
FROM leads l 
JOIN enriched_leads el ON l.id = el.lead_id 
ORDER BY el.score DESC;

# View outreach status
SELECT l.name, l.email, el.sent, el.contacted 
FROM leads l 
JOIN enriched_leads el ON l.id = el.lead_id 
WHERE el.score >= 70;
```

### View n8n Execution Logs

1. Go to n8n interface
2. Navigate to Executions
3. Click on any execution to see detailed logs

### Docker Logs

```bash
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs n8n
docker-compose logs postgres
```

## 📈 Workflow Automation

### Scheduled Execution

The workflows are configured with the following schedules:

- **Lead Enrichment**: Every 30 minutes
- **Outreach Automation**: Daily at 9 AM (Monday-Friday)

To enable automatic execution:
1. Open each workflow in n8n
2. Toggle the "Active" switch in the top-right corner

### Manual Execution

All workflows can be triggered manually for testing:
1. Open the workflow
2. Click "Execute Workflow"
3. Monitor the execution in real-time

## 🛠️ Customization

### Modifying Lead Sources

To add new social media platforms:
1. Edit `sql/01_leads.sql` to add new source types
2. Update the lead generation workflow
3. Modify the OpenAI prompt in the enrichment workflow

### Adjusting AI Prompts

Edit the OpenAI prompt in the "Prepare OpenAI Prompt" function node:
- Located in `workflows/lead_enrichment.json`
- Modify the prompt string to change analysis criteria
- Adjust the JSON response format as needed

### Email Templates

Customize outreach emails in the "Prepare Email Content" function node:
- Located in `workflows/outreach_automation.json`
- Modify subject line templates
- Update email body content
- Add new personalization variables

## 🔒 Security and Compliance

### Data Protection

- All sensitive data is stored in PostgreSQL with proper indexing
- API keys are managed through environment variables
- n8n credentials are encrypted and secured

### Email Compliance

The system includes:
- Unsubscribe links in all emails
- Compliance checking before sending
- Rate limiting and batch processing
- GDPR-friendly data handling

### Production Considerations

Before deploying to production:

1. **Use strong passwords** for all services
2. **Enable SSL/TLS** for n8n and database connections
3. **Set up proper backup procedures** for PostgreSQL
4. **Configure email authentication** (SPF, DKIM, DMARC)
5. **Implement monitoring and alerting**
6. **Review and update compliance settings**

## 🧪 Testing

### Manual Testing

1. **Test Lead Generation**:
   ```bash
   # Check if leads are created
   docker exec -it affiliate_postgres psql -U affiliate_user -d affiliate_system -c "SELECT COUNT(*) FROM leads;"
   ```

2. **Test AI Enrichment**:
   ```bash
   # Check enriched leads
   docker exec -it affiliate_postgres psql -U affiliate_user -d affiliate_system -c "SELECT COUNT(*) FROM enriched_leads;"
   ```

3. **Test Outreach**:
   - Check n8n execution logs
   - Verify email delivery (if SMTP configured)
   - Check database updates

### Automated Testing

The workflows include error handling and logging:
- Failed enrichments fall back to default values
- Email sending errors are logged and tracked
- Database operations include transaction safety

## 🔧 Troubleshooting

### Common Issues

1. **n8n Connection Failed**:
   - Check if containers are running: `docker-compose ps`
   - Verify port 5678 is not blocked
   - Check Docker logs: `docker-compose logs n8n`

2. **Database Connection Issues**:
   - Ensure PostgreSQL container is healthy
   - Verify credentials in n8n match `.env` file
   - Check network connectivity between containers

3. **OpenAI API Errors**:
   - Verify API key is correct and has credits
   - Check rate limits and usage quotas
   - Review OpenAI response in n8n execution logs

4. **Email Sending Issues**:
   - Verify SMTP credentials and settings
   - Check if Gmail App Passwords are enabled
   - Review email service provider restrictions

### Docker Issues

```bash
# Restart services
docker-compose restart

# Rebuild containers
docker-compose down
docker-compose up --build -d

# Clean reset
docker-compose down -v
docker-compose up -d
```

## 📚 Additional Resources

- [n8n Documentation](https://docs.n8n.io/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [OpenAI API Documentation](https://platform.openai.com/docs/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 🤝 Support

For technical support or questions:
1. Check the troubleshooting section above
2. Review Docker and n8n logs
3. Verify all credentials and configurations
4. Test individual workflow components

## 📄 License

This project is created for assessment purposes. Please review and comply with all applicable terms of service for external APIs and services used. 