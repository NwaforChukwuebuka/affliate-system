# System Design - Affiliate Lead Management System

## 🏗️ Architecture Overview

The Affiliate Lead Management System is a containerized, event-driven automation platform that processes social media leads through AI enrichment and automated outreach campaigns.

### Core Components

```
┌─────────────────────────────────────────────────────────────────┐
│                    Affiliate Lead System                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │   Lead      │    │     AI      │    │  Outreach   │         │
│  │ Generation  │───▶│ Enrichment  │───▶│ Automation  │         │
│  │             │    │             │    │             │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│         │                   │                   │              │
│         ▼                   ▼                   ▼              │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                PostgreSQL Database                          ││
│  │  ┌─────────────┐           ┌─────────────────────────────┐  ││
│  │  │   leads     │           │      enriched_leads        │  ││
│  │  │   table     │◄──────────┤        table              │  ││
│  │  └─────────────┘           └─────────────────────────────┘  ││
│  └─────────────────────────────────────────────────────────────┘│
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                      External Services                          │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │   Twitter   │    │   OpenAI    │    │    SMTP     │         │
│  │     API     │    │     API     │    │   Service   │         │
│  │ (Simulated) │    │             │    │ (Optional)  │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
└─────────────────────────────────────────────────────────────────┘
```

## 🔄 Data Flow

### 1. Lead Collection Phase

```
Twitter API/Simulation ──┐
                         │
                         ▼
                  ┌─────────────┐
                  │   n8n Lead  │
                  │ Generation  │
                  │  Workflow   │
                  └─────────────┘
                         │
                         ▼
                  ┌─────────────┐
                  │   leads     │
                  │   table     │
                  │             │
                  │ - id        │
                  │ - source    │
                  │ - name      │
                  │ - username  │
                  │ - email     │
                  │ - bio       │
                  │ - followers │
                  └─────────────┘
```

**Process Flow:**
1. **Data Source**: Simulated Twitter leads (real API integration ready)
2. **Normalization**: Standardize data format across platforms
3. **Validation**: Ensure required fields are present
4. **Storage**: Insert into PostgreSQL `leads` table
5. **Indexing**: Automatic indexing for performance optimization

### 2. AI Enrichment Phase

```
    ┌─────────────┐         ┌─────────────┐
    │   leads     │────────▶│  OpenAI     │
    │   table     │         │  Analysis   │
    └─────────────┘         └─────────────┘
           │                        │
           │                        ▼
           │                ┌─────────────┐
           │                │ Enrichment  │
           │                │   Data      │
           │                │             │
           │                │ - niche     │
           │                │ - score     │
           │                │ - message   │
           │                │ - compliance│
           │                └─────────────┘
           │                        │
           ▼                        ▼
    ┌─────────────────────────────────────┐
    │        enriched_leads table         │
    │                                     │
    │ - lead_id (FK)                      │
    │ - niche                             │
    │ - score (0-100)                     │
    │ - notes                             │
    │ - message (personalized)            │
    │ - compliant (boolean)               │
    │ - ai_confidence                     │
    └─────────────────────────────────────┘
```

**AI Processing Steps:**
1. **Lead Selection**: Query unenriched leads from database
2. **Prompt Construction**: Create structured prompt with lead data
3. **OpenAI API Call**: Send lead information for analysis
4. **Response Parsing**: Extract JSON response with enrichment data
5. **Validation**: Ensure data quality and compliance
6. **Storage**: Insert enriched data with referential integrity

### 3. Outreach Automation Phase

```
┌─────────────────────────────────┐
│       enriched_leads            │
│   WHERE score >= 70             │
│     AND compliant = true        │
│     AND sent = false            │
└─────────────────────────────────┘
                │
                ▼
        ┌─────────────┐
        │  Email      │
        │ Generation  │
        │             │
        │ - Subject   │
        │ - Body      │
        │ - Personalization│
        └─────────────┘
                │
                ▼
        ┌─────────────┐
        │    SMTP     │
        │   Service   │
        └─────────────┘
                │
                ▼
        ┌─────────────┐
        │   Update    │
        │  Database   │
        │             │
        │ sent = true │
        │contacted=true│
        └─────────────┘
```

**Outreach Workflow:**
1. **Lead Qualification**: Filter high-scoring, compliant leads
2. **Content Generation**: Create personalized email content
3. **Delivery**: Send via SMTP (or simulate for demo)
4. **Tracking**: Update database with delivery status
5. **Compliance**: Include unsubscribe and legal notices

## 🛠️ Technical Architecture

### Container Architecture

```
Docker Host
├── PostgreSQL Container
│   ├── Port: 5432
│   ├── Volume: postgres_data
│   ├── Init Scripts: /sql/*.sql
│   └── Network: affiliate_network
│
├── n8n Container
│   ├── Port: 5678
│   ├── Volume: n8n_data
│   ├── Workflows: /workflows/*.json
│   ├── Database: PostgreSQL
│   └── Network: affiliate_network
│
└── Shared Network: affiliate_network
    └── Internal DNS Resolution
```

### Database Schema Design

#### Entity Relationship Diagram

```
┌─────────────────┐         ┌─────────────────────────┐
│     leads       │         │    enriched_leads       │
├─────────────────┤         ├─────────────────────────┤
│ id (PK)         │◄────────┤ lead_id (FK)            │
│ source          │         │ id (PK)                 │
│ name            │         │ niche                   │
│ username        │         │ score                   │
│ email           │         │ notes                   │
│ profile_url     │         │ message                 │
│ follower_count  │         │ contacted               │
│ bio             │         │ sent                    │
│ verified        │         │ reviewed                │
│ location        │         │ compliant               │
│ created_at      │         │ compliance_notes        │
│ updated_at      │         │ enrichment_version      │
└─────────────────┘         │ ai_confidence           │
                            │ created_at              │
                            │ updated_at              │
                            └─────────────────────────┘
```

### API Integration Points

#### OpenAI Integration
- **Model**: GPT-3.5-turbo
- **Temperature**: 0.3 (focused responses)
- **Max Tokens**: 500
- **Retry Logic**: Exponential backoff
- **Error Handling**: Fallback to default values

#### Email Service Integration
- **Protocol**: SMTP with TLS
- **Authentication**: Username/Password or OAuth2
- **Rate Limiting**: Configurable delays between sends
- **Bounce Handling**: Track delivery failures

## 🔧 Workflow Orchestration

### n8n Workflow Engine

#### Lead Generation Workflow
```
Manual Trigger ──▶ Generate Fake Data ──▶ Database Insert ──▶ Log Results
```

#### Enrichment Workflow
```
Cron Trigger ──▶ Query DB ──▶ Check Data ──▶ OpenAI Call ──▶ Parse Response ──▶ Store Results
```

#### Outreach Workflow
```
Daily Trigger ──▶ Query Qualified Leads ──▶ Generate Emails ──▶ Send/Simulate ──▶ Update Status
```

### Error Handling Strategy

1. **Database Errors**:
   - Connection pooling
   - Transaction rollback
   - Retry mechanisms

2. **API Failures**:
   - Circuit breaker pattern
   - Fallback responses
   - Rate limit compliance

3. **Workflow Errors**:
   - Node-level error handling
   - Workflow-level catch blocks
   - Execution logging

## 📊 Performance Considerations

### Scalability Features

1. **Batch Processing**: Process leads in configurable batches
2. **Rate Limiting**: Respect API quotas and limits
3. **Database Indexing**: Optimized queries with proper indexes
4. **Caching**: Redis integration ready for workflow caching

### Monitoring Points

1. **Lead Processing Rate**: Leads per hour/day
2. **Enrichment Success Rate**: API success vs failures
3. **Email Delivery Rate**: Successful sends vs bounces
4. **Database Performance**: Query execution times

## 🔒 Security and Compliance

### Data Security

1. **Encryption**: All sensitive data encrypted at rest
2. **Access Control**: Role-based access to n8n
3. **API Security**: Secure credential management
4. **Network Security**: Container isolation

### Compliance Features

1. **GDPR Compliance**:
   - Data retention policies
   - Right to deletion
   - Consent tracking

2. **Email Compliance**:
   - Unsubscribe mechanisms
   - CAN-SPAM compliance
   - Bounce handling

3. **Audit Trail**:
   - All operations logged
   - Database triggers for changes
   - Workflow execution history

## 🚀 Future Improvements

### Phase 1 Enhancements
1. **Real Social Media APIs**: Twitter, LinkedIn, Instagram integration
2. **Advanced AI Models**: GPT-4, custom fine-tuned models
3. **A/B Testing**: Email subject and content optimization
4. **Dashboard**: Real-time analytics and monitoring

### Phase 2 Scaling
1. **Multi-tenant Architecture**: Support multiple affiliate programs
2. **Machine Learning**: Predictive lead scoring
3. **Advanced Workflows**: Multi-step nurture campaigns
4. **Integration Platform**: Webhook-based integrations

### Phase 3 Enterprise
1. **Microservices**: Break into smaller, focused services
2. **Event Streaming**: Kafka for real-time processing
3. **Advanced Analytics**: Business intelligence integration
4. **Compliance Automation**: Automated legal review

## 🎯 Success Metrics

### Key Performance Indicators

1. **Lead Quality Score**: Average AI confidence rating
2. **Conversion Rate**: Outreach response percentage
3. **Processing Efficiency**: Time from lead to outreach
4. **System Reliability**: Uptime and error rates

### Business Metrics

1. **Lead Generation Volume**: Leads collected per platform
2. **Enrichment Accuracy**: Manual review validation
3. **Outreach Effectiveness**: Email open and response rates
4. **Affiliate ROI**: Revenue per successful conversion

This system design provides a robust, scalable foundation for automated affiliate lead management with clear separation of concerns, comprehensive error handling, and built-in compliance features. 