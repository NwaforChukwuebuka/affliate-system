-- Sample leads data for testing
INSERT INTO leads (source, name, username, email, profile_url, follower_count, bio, verified, location) VALUES
('twitter', 'John Doe', 'johndoe_crypto', 'john.doe@email.com', 'https://twitter.com/johndoe_crypto', 15420, 'Crypto enthusiast | NFT collector | Building the future', false, 'San Francisco, CA'),
('twitter', 'Sarah Chen', 'sarahtech', 'sarah.chen@techmail.com', 'https://twitter.com/sarahtech', 8760, 'Tech entrepreneur | AI researcher | Startup founder', true, 'Austin, TX'),
('twitter', 'Mike Rodriguez', 'mikefit', 'mike.rodriguez@fitness.com', 'https://twitter.com/mikefit', 23100, 'Fitness coach | Nutrition expert | Helping people transform their lives', false, 'Miami, FL'),
('twitter', 'Emma Thompson', 'emmawrites', 'emma.thompson@writer.com', 'https://twitter.com/emmawrites', 5430, 'Content creator | Digital marketer | Helping brands tell their story', false, 'New York, NY'),
('twitter', 'David Kim', 'davidinvests', 'david.kim@finance.com', 'https://twitter.com/davidinvests', 34200, 'Investment advisor | Financial planner | Market analyst', true, 'Chicago, IL'),
('twitter', 'Lisa Wang', 'lisaecom', 'lisa.wang@ecommerce.com', 'https://twitter.com/lisaecom', 12800, 'E-commerce expert | Dropshipping specialist | Online business mentor', false, 'Seattle, WA'),
('twitter', 'Alex Brown', 'alexcodes', 'alex.brown@developer.com', 'https://twitter.com/alexcodes', 9850, 'Full-stack developer | Open source contributor | Tech blogger', false, 'Remote'),
('twitter', 'Rachel Green', 'racheldesigns', 'rachel.green@design.com', 'https://twitter.com/racheldesigns', 7200, 'UX/UI designer | Creative director | Design systems enthusiast', false, 'Los Angeles, CA'),
('twitter', 'Tom Wilson', 'tomtravels', 'tom.wilson@travel.com', 'https://twitter.com/tomtravels', 18900, 'Travel blogger | Adventure seeker | Helping people explore the world', false, 'Denver, CO'),
('twitter', 'Jennifer Lee', 'jencoaches', 'jennifer.lee@coach.com', 'https://twitter.com/jencoaches', 11400, 'Life coach | Mindset mentor | Empowering women entrepreneurs', false, 'Portland, OR');

-- Log the insertion
DO $$
BEGIN
    RAISE NOTICE 'Sample data inserted: % leads', (SELECT COUNT(*) FROM leads);
END
$$; 