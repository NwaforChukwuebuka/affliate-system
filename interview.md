 Affiliate System – AI Automation Engineer Assessment
 Background
We are developing a multi-platform affiliate system that:
Collects leads from Instagram, Facebook, LinkedIn, and Twitter


Enriches leads using OpenAI


Stores and tracks lead activity using PostgreSQL


Orchestrates outreach campaigns with compliance logic


Automates affiliate commission tracking and tiering
All workflows are built in n8n, using PostgreSQL, OpenAI, and external APIs like PhantomBuster or open-source scraping tools, feel free to use other opensource too, you can docker for your setup
You will work closely with our Head of Engineering to automate and scale the system.
 Assessment Tasks
1. Lead Generation Integration
Implement an n8n workflow to collect leads from one social media platform (e.g., Twitter).


You may use PhantomBuster, ScrapingBee, or an open-source alternative.


Normalize and store the leads into a PostgreSQL table with this schema:
CREATE TABLE leads (
  id SERIAL PRIMARY KEY,
  source TEXT,
  name TEXT,
  username TEXT,
  email TEXT,
  profile_url TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
Deliverables:
n8n workflow JSON file


Sample .env or credential placeholders


A few fake leads inserted for demo purposes

2. Lead Enrichment with OpenAI
Take leads from the leads table and enrich them with:


niche relevance


engagement quality


short AI-generated summary
Store in enriched_leads:
CREATE TABLE enriched_leads (
  id SERIAL PRIMARY KEY,
  lead_id INTEGER REFERENCES leads(id),
  niche TEXT,
  score INTEGER,
  notes TEXT,
  message TEXT,
  contacted BOOLEAN DEFAULT FALSE,
  sent BOOLEAN DEFAULT FALSE,
  reviewed BOOLEAN DEFAULT FALSE,
  compliant BOOLEAN,
  compliance_notes TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
Deliverables:
An n8n workflow to fetch, enrich using OpenAI, and insert into enriched_leads


A prompt used for enrichment
4. Outreach Automation
Write an n8n flow to:


Send personalized emails to leads


Mark them as sent in the DB
️ System Design Document (Required)
Please include a short system design with:
Architecture diagram (e.g., draw.io, Lucidchart)
Data flow explanation: how leads are collected, enriched, stored, and sent outreach
🗏️ Submission
Zip file or GitHub repo link to 
All n8n JSON workflows
SQL schema or migration files
Sample .env/secrets placeholders
A short README.md explaining:
Setup instructions
Key decisions or tradeoffs
Improvements you would make next
system-design.pdf or .md