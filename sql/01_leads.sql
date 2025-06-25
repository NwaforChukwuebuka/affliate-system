-- Leads table for storing collected leads from social media platforms
CREATE TABLE IF NOT EXISTS leads (
    id SERIAL PRIMARY KEY,
    source TEXT NOT NULL CHECK (source IN ('twitter', 'facebook', 'instagram', 'linkedin')),
    name TEXT,
    username TEXT NOT NULL,
    email TEXT,
    profile_url TEXT,
    follower_count INTEGER DEFAULT 0,
    bio TEXT,
    verified BOOLEAN DEFAULT FALSE,
    location TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_leads_source ON leads(source);
CREATE INDEX IF NOT EXISTS idx_leads_username ON leads(username);
CREATE INDEX IF NOT EXISTS idx_leads_created_at ON leads(created_at);

-- Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_leads_updated_at 
    BEFORE UPDATE ON leads 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column(); 