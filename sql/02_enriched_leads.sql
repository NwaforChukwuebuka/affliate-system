-- Enriched leads table for storing AI-enhanced lead information
CREATE TABLE IF NOT EXISTS enriched_leads (
    id SERIAL PRIMARY KEY,
    lead_id INTEGER NOT NULL REFERENCES leads(id) ON DELETE CASCADE,
    niche TEXT,
    score INTEGER CHECK (score >= 0 AND score <= 100),
    notes TEXT,
    message TEXT,
    contacted BOOLEAN DEFAULT FALSE,
    sent BOOLEAN DEFAULT FALSE,
    reviewed BOOLEAN DEFAULT FALSE,
    compliant BOOLEAN,
    compliance_notes TEXT,
    enrichment_version TEXT DEFAULT '1.0',
    ai_confidence DECIMAL(3,2) DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    -- Ensure one enrichment per lead (can be updated)
    CONSTRAINT unique_lead_enrichment UNIQUE(lead_id)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_enriched_leads_lead_id ON enriched_leads(lead_id);
CREATE INDEX IF NOT EXISTS idx_enriched_leads_score ON enriched_leads(score);
CREATE INDEX IF NOT EXISTS idx_enriched_leads_niche ON enriched_leads(niche);
CREATE INDEX IF NOT EXISTS idx_enriched_leads_contacted ON enriched_leads(contacted);
CREATE INDEX IF NOT EXISTS idx_enriched_leads_sent ON enriched_leads(sent);
CREATE INDEX IF NOT EXISTS idx_enriched_leads_compliant ON enriched_leads(compliant);

-- Create trigger to update updated_at timestamp
CREATE TRIGGER update_enriched_leads_updated_at 
    BEFORE UPDATE ON enriched_leads 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column(); 