/*
 * Script Purpose:
 * ===============
 * This script loads data from the theme-park-industries database
 * into the dwh_tpi bronze layer using simple bulk INSERT with dblink.
 *
 * Prerequisites:
 * ==============
 * 1. The bronze schema and tables must be created (run create-database.sql and bronze.sql first)
 * 2. Both databases must exist on the same PostgreSQL instance
 */

-- Create dblink extension
CREATE EXTENSION IF NOT EXISTS dblink;

-- Load City data
INSERT INTO bronze.city
SELECT * FROM dblink('dbname=theme-park-industries', 'SELECT id, name, country, difficulty, surface, available_surface, population, park_capacity, park_population, price_by_meter, max_height, created_on, updated_on FROM city')
AS t(id INT, name VARCHAR(255), country VARCHAR(255), difficulty VARCHAR(255), surface INT, available_surface INT, population INT, park_capacity INT, park_population INT, price_by_meter INT, max_height INT, created_on timestamp, updated_on timestamp);

-- Load Player data
INSERT INTO bronze.player
SELECT * FROM dblink('dbname=theme-park-industries', 'SELECT id, name, created_on, updated_on FROM player')
AS t(id BIGINT, name VARCHAR(255), created_on timestamp, updated_on timestamp);

-- Load PlayerData data
INSERT INTO bronze.player_data
SELECT * FROM dblink('dbname=theme-park-industries', 'SELECT id, money, level, experience, created_on, updated_on, player_id FROM player_data')
AS t(id BIGINT, money INT, level INT, experience INT, created_on timestamp, updated_on timestamp, player_id BIGINT);

-- Load Park data
INSERT INTO bronze.park
SELECT * FROM dblink('dbname=theme-park-industries', 'SELECT id, name, player_id, city_id, created_on, updated_on FROM park')
AS t(id BIGINT, name VARCHAR(255), player_id BIGINT, city_id INT, created_on timestamp, updated_on timestamp);

-- Load Ride data
INSERT INTO bronze.ride
SELECT * FROM dblink('dbname=theme-park-industries', 'SELECT id, type, max_capacity_by_hour, hype, name, brand, price, surface, created_on, updated_on FROM ride')
AS t(id BIGINT, type VARCHAR(255), max_capacity_by_hour INT, hype INT, name VARCHAR(255), brand VARCHAR(255), price BIGINT, surface BIGINT, created_on timestamp, updated_on timestamp);

-- Load Parks_Rides junction data
INSERT INTO bronze.parks_rides
SELECT * FROM dblink('dbname=theme-park-industries', 'SELECT park_id, ride_id FROM parks_rides')
AS t(park_id BIGINT, ride_id BIGINT);

-- Load DashboardActivity data
INSERT INTO bronze.dashboard_activity
SELECT * FROM dblink('dbname=theme-park-industries', 'SELECT id, category, posted, type, text, player_id, city_id, actor_park_id, victim_park_id, ride_id, amount, created_on, updated_on FROM dashboard_activity')
AS t(id BIGINT, category VARCHAR(255), posted timestamp, type VARCHAR(255), text VARCHAR(255), player_id BIGINT, city_id INT, actor_park_id BIGINT, victim_park_id BIGINT, ride_id BIGINT, amount BIGINT, created_on timestamp, updated_on timestamp);

-- Verify import
SELECT 'City' as table_name, COUNT(*) as count FROM bronze.city
UNION ALL
SELECT 'Player', COUNT(*) FROM bronze.player
UNION ALL
SELECT 'PlayerData', COUNT(*) FROM bronze.player_data
UNION ALL
SELECT 'Park', COUNT(*) FROM bronze.park
UNION ALL
SELECT 'Ride', COUNT(*) FROM bronze.ride
UNION ALL
SELECT 'ParksRides', COUNT(*) FROM bronze.parks_rides
UNION ALL
SELECT 'DashboardActivity', COUNT(*) FROM bronze.dashboard_activity;
