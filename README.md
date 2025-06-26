# Affiliate System - AI Automation Engineer Assessment

A complete multi-platform affiliate system that collects leads from social media, enriches them using **FREE Mistral AI** (via OpenRouter API), and automates personalized outreach campaigns.

## 🏗️ Architecture Overview

This system consists of:
- **Lead Generation**: Collects leads from Twitter (simulated data for demo)
- **AI Enrichment**: Uses **FREE Mistral AI** via OpenRouter (no costs!) to analyze leads and generate personalized content
- **Outreach Automation**: Sends personalized emails and tracks engagement
- **PostgreSQL Database**: Stores leads and enrichment data
- **n8n Workflows**: Orchestrates all automation processes with integrated Mistral API calls

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
# Required: FREE OpenRouter API Key for Mistral AI
OPENROUTER_API_KEY=sk-or-v1-your-free-api-key-here

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

#### OpenRouter API Credential (Free Mistral AI)
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
6. The free tier includes access to Mistral 7B Instruct model with generous usage limits

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
   - **Note**: Uses free Mistral model via OpenRouter with integrated n8n MCP server - no costs!
   - **Features**: 
     - Direct Mistral API integration through n8n HTTP request node
     - Robust error handling and fallback responses
     - Optimized prompts for lead analysis and scoring
     - Compliance checking and personalized message generation

4. **Import Outreach Automation**:
   - Import `workflows/outreach_automation.json`

## 🤖 Mistral AI Integration Details

### n8n MCP Server Configuration

The lead enrichment workflow now includes a dedicated "Call Mistral API" node that:

- **Endpoint**: Uses OpenRouter's Mistral API endpoint (`https://openrouter.ai/api/v1/chat/completions`)
- **Model**: `mistralai/mistral-7b-instruct:free` (completely free!)
- **Authentication**: Secure HTTP Header authentication with your OpenRouter API key
- **Request Format**: Optimized ChatML format with structured prompts
- **Response Handling**: Robust parsing with multiple fallback strategies

### AI Enrichment Features

The Mistral integration provides:

1. **Lead Analysis**: 
   - Niche identification based on bio and follower patterns
   - Quality scoring (0-100) for engagement potential
   - Compliance assessment for outreach regulations

2. **Personalized Content**:
   - Custom outreach messages (50-80 words)
   - Industry-specific talking points
   - Tone matching based on lead profile

3. **Data Validation**:
   - Required field checking
   - Score normalization and bounds checking
   - Confidence scoring for AI assessments

### Error Handling

The system includes comprehensive error handling:
- API rate limit management
- Fallback responses for API failures
- Structured error logging
- Graceful degradation with manual review flags

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

### 2. Enrich Leads with Mistral AI

1. Open the "Lead Enrichment" workflow
2. Click "Execute Workflow"
3. The workflow will:
   - Find unenriched leads in the database
   - Send them to Mistral AI via OpenRouter for analysis
   - Parse the AI response and validate data
   - Store enriched data (niche, score, personalized messages, compliance status)
   - Handle errors gracefully with fallback responses

### 3. Run Outreach Campaign

1. Open the "Outreach Automation" workflow
2. Click "Execute Workflow"
3. The workflow will:
   - Find high-scoring, compliant leads
   - Generate personalized emails using AI-generated content
   - Send emails (or simulate for demo)
   - Mark leads as contacted and track engagement

## 🔍 Monitoring and Logs

### View Database Data

Connect to PostgreSQL to view results:

```bash
# Connect to database
docker exec -it affiliate_postgres psql -U affiliate_user -d affiliate_system

# View leads
SELECT * FROM leads LIMIT 10;

# View enriched leads with AI analysis
SELECT 
  l.name, 
  l.username,
  l.follower_count,
  el.niche, 
  el.score, 
  el.ai_confidence,
  el.notes,
  SUBSTRING(el.message, 1, 50) as message_preview
FROM leads l 
JOIN enriched_leads el ON l.id = el.lead_id 
ORDER BY el.score DESC, el.ai_confidence DESC;

# View high-quality leads ready for outreach
SELECT 
  l.name, 
  l.email, 
  el.score,
  el.compliant,
  el.compliance_notes
FROM leads l 
JOIN enriched_leads el ON l.id = el.lead_id 
WHERE el.score >= 70 AND el.compliant = true
ORDER BY el.score DESC;
```

### View n8n Execution Logs

1. Go to n8n interface
2. Navigate to Executions
3. Click on any execution to see detailed logs
4. Check the "Call Mistral API" node for AI response details
5. Review "Parse Enrichment Data" for processing results

### Mistral API Monitoring

Monitor your OpenRouter usage:
1. Visit your OpenRouter dashboard
2. Check API usage and remaining free credits
3. Review request/response logs for debugging
4. Monitor rate limits and performance metrics

### Docker Logs

```bash
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs n8n
docker-compose logs postgres

# Follow logs in real-time
docker-compose logs -f n8n
```

## 📈 Workflow Automation

### Scheduled Execution

The workflows are configured with the following schedules:

- **Lead Enrichment (Mistral AI)**: Every 30 minutes
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
3. Modify the Mistral prompt in the enrichment workflow

### Adjusting AI Prompts

Edit the Mistral prompt in the "Prepare Mistral Prompt" function node:
- Located in `workflows/lead_enrichment.json`
- Modify the prompt string to change analysis criteria
- Adjust the JSON response format as needed
- Fine-tune temperature and other model parameters in the "Call Mistral API" node

Example prompt customization:
```javascript
const prompt = `Analyze this ${lead.source} lead for ${specific_industry}:

Lead Information:
- Name: ${lead.name}
- Bio: ${lead.bio}
- Followers: ${lead.follower_count}

Focus on:
- Industry relevance for ${your_business_type}
- Engagement potential
- Decision-maker likelihood

Respond with JSON only...`;
```

### Mistral Model Configuration

The "Call Mistral API" node can be customized:
- **Model**: Switch between different Mistral variants (7B, 8x7B, etc.)
- **Temperature**: Adjust creativity (0.1-1.0, default: 0.3)
- **Max Tokens**: Control response length (default: 1000)
- **Top-p**: Fine-tune response diversity (default: 1.0)

### Email Templates

Customize outreach emails in the "Prepare Email Content" function node:
- Located in `workflows/outreach_automation.json`
- Modify subject line templates
- Update email body content using Mistral-generated personalized messages
- Add new personalization variables from AI analysis

## 🔒 Security and Compliance

### Data Protection

- All sensitive data is stored in PostgreSQL with proper indexing
- API keys are managed through environment variables
- n8n credentials are encrypted and secured
- Mistral API calls use HTTPS with proper authentication

### Email Compliance

The system includes:
- Unsubscribe links in all emails
- AI-powered compliance checking before sending
- Rate limiting and batch processing
- GDPR-friendly data handling
- Automated compliance assessment in Mistral enrichment

### Production Considerations

Before deploying to production:

1. **Use strong passwords** for all services
2. **Enable SSL/TLS** for n8n and database connections
3. **Set up proper backup procedures** for PostgreSQL
4. **Configure email authentication** (SPF, DKIM, DMARC)
5. **Implement monitoring and alerting** for Mistral API usage
6. **Review and update compliance settings** in AI prompts
7. **Set up rate limiting** for OpenRouter API calls
8. **Monitor AI confidence scores** and manual review flags

## 🧪 Testing

### Manual Testing

1. **Test Lead Generation**:
   ```bash
   # Check if leads are created
   docker exec -it affiliate_postgres psql -U affiliate_user -d affiliate_system -c "SELECT COUNT(*) FROM leads;"
   ```

2. **Test Mistral AI Enrichment**:
   ```bash
   # Check enriched leads
   docker exec -it affiliate_postgres psql -U affiliate_user -d affiliate_system -c "SELECT COUNT(*) FROM enriched_leads;"
   
   # Check AI confidence and scores
   docker exec -it affiliate_postgres psql -U affiliate_user -d affiliate_system -c "SELECT AVG(score), AVG(ai_confidence), COUNT(*) FROM enriched_leads WHERE ai_confidence > 0.5;"
   ```

3. **Test API Integration**:
   - Check n8n execution logs for "Call Mistral API" node
   - Verify OpenRouter API usage in dashboard
   - Test different lead profiles for consistent AI responses

4. **Test Outreach**:
   - Check n8n execution logs
   - Verify email delivery (if SMTP configured)
   - Check database updates for contacted leads

### Automated Testing

The workflows include comprehensive error handling and logging:
- Failed Mistral API calls fall back to default enrichment values
- Email sending errors are logged and tracked
- Database operations include transaction safety
- AI response parsing includes multiple fallback strategies

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

3. **Mistral API Errors**:
   - Verify OpenRouter API key is correct and active
   - Check rate limits and usage quotas in OpenRouter dashboard
   - Review Mistral response in n8n execution logs
   - Test API key with curl:
     ```bash
     curl -X POST "https://openrouter.ai/api/v1/chat/completions" \
       -H "Authorization: Bearer YOUR_API_KEY" \
       -H "Content-Type: application/json" \
       -d '{"model": "mistralai/mistral-7b-instruct:free", "messages": [{"role": "user", "content": "Hello"}]}'
     ```

4. **AI Response Parsing Issues**:
   - Check "Parse Enrichment Data" node logs for JSON parsing errors
   - Verify Mistral is returning properly formatted JSON
   - Review fallback handling in the parsing logic
   - Adjust prompt if responses are inconsistent

5. **Email Sending Issues**:
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

### Mistral-Specific Debugging

```bash
# Check Mistral API node execution details
docker-compose logs n8n | grep -i mistral

# Monitor OpenRouter API usage
curl -H "Authorization: Bearer YOUR_API_KEY" \
  "https://openrouter.ai/api/v1/generation" | jq

# Test individual workflow nodes
# Go to n8n interface > Workflow > Click on "Call Mistral API" node > "Execute Node"
```

## 📚 Additional Resources

- [n8n Documentation](https://docs.n8n.io/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [OpenRouter API Documentation](https://openrouter.ai/docs)
- [Mistral AI Documentation](https://docs.mistral.ai/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 🚀 Advanced Features

### Multi-Model AI Support

The system can be extended to use multiple AI models:
- Modify the "Call Mistral API" node to rotate between models
- Add model-specific prompt optimization
- Implement consensus scoring across multiple AI responses

### Real-time Lead Scoring

Implement webhook-based real-time enrichment:
- Set up n8n webhook triggers
- Process leads immediately upon addition
- Integrate with CRM systems for instant scoring

### A/B Testing for AI Prompts

Test different prompt strategies:
- Create multiple enrichment workflows with different prompts
- Track conversion rates and AI confidence scores
- Optimize prompts based on outreach success metrics

## 🤝 Support

For technical support or questions:
1. Check the troubleshooting section above
2. Review Docker and n8n logs
3. Verify all credentials and configurations
4. Test individual workflow components
5. Check OpenRouter API status and usage limits
6. Review Mistral API documentation for latest updates

## 📄 License

This project is created for assessment purposes. Please review and comply with all applicable terms of service for external APIs and services used, including OpenRouter and Mistral AI usage policies. 