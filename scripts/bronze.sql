-- Drop all tables in reverse dependency order
DROP TABLE IF EXISTS bronze.dashboard_activity CASCADE;
DROP TABLE IF EXISTS bronze.parks_rides CASCADE;
DROP TABLE IF EXISTS bronze.park CASCADE;
DROP TABLE IF EXISTS bronze.player_data CASCADE;
DROP TABLE IF EXISTS bronze.ride CASCADE;
DROP TABLE IF EXISTS bronze.player CASCADE;
DROP TABLE IF EXISTS bronze.city CASCADE;

-- City table
create table bronze.city (
	id INT not null,
	name VARCHAR(255) not null,
	country VARCHAR(255) not null,
	difficulty VARCHAR(255) not null,
	surface INT not null,
	available_surface INT not null,
	population INT not null,
	park_capacity INT not null,
	park_population INT not null,
	price_by_meter INT not null,
	max_height INT not null,
	created_on timestamp not null,
	updated_on timestamp not null,
    CONSTRAINT pk_city PRIMARY KEY (id)
);

-- Player table
create table bronze.player (
	id BIGINT not null,
	name VARCHAR(255) not null,
	created_on timestamp not null,
	updated_on timestamp not null,
	CONSTRAINT pk_player PRIMARY KEY (id)
);

-- PlayerData table (linked to Player)
create table bronze.player_data (
	id BIGINT not null,
	money INT not null,
	level INT not null,
	experience INT not null,
	created_on timestamp not null,
	updated_on timestamp not null,
	player_id BIGINT not null,
	CONSTRAINT pk_player_data PRIMARY KEY (id),
    CONSTRAINT fk_player FOREIGN KEY (player_id) REFERENCES bronze.player(id)
);

-- Park table (linked to Player and City)
create table bronze.park (
	id BIGINT not null,
	name VARCHAR(255) not null,
	player_id BIGINT not null,
	city_id INT not null,
	created_on timestamp not null,
	updated_on timestamp not null,
	CONSTRAINT pk_park PRIMARY KEY (id),
    CONSTRAINT fk_player FOREIGN KEY (player_id) REFERENCES bronze.player(id),
    CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES bronze.city(id)
);

-- Ride table
create table bronze.ride (
	id BIGINT not null,
	type VARCHAR(255) not null,
	max_capacity_by_hour INT not null,
	hype INT not null,
	name VARCHAR(255) not null,
	brand VARCHAR(255) not null,
	price BIGINT not null,
	surface BIGINT not null,
	created_on timestamp not null,
	updated_on timestamp not null,
	CONSTRAINT pk_ride PRIMARY KEY (id)
);

-- Parks_Rides junction table (Many-to-Many relationship)
create table bronze.parks_rides (
	park_id BIGINT not null,
	ride_id BIGINT not null,
	CONSTRAINT pk_parks_rides PRIMARY KEY (park_id, ride_id),
    CONSTRAINT fk_park FOREIGN KEY (park_id) REFERENCES bronze.park(id),
    CONSTRAINT fk_ride FOREIGN KEY (ride_id) REFERENCES bronze.ride(id)
);

-- DashboardActivity table (linked to Player, City, Park, and Ride)
create table bronze.dashboard_activity (
	id BIGINT not null,
	category VARCHAR(255) not null,
	posted timestamp not null,
	type VARCHAR(255) not null,
	text VARCHAR(255) not null,
	player_id BIGINT,
	city_id INT,
	actor_park_id BIGINT,
	victim_park_id BIGINT,
	ride_id BIGINT,
	amount BIGINT,
	created_on timestamp not null,
	updated_on timestamp not null,
	CONSTRAINT pk_dashboard_activity PRIMARY KEY (id),
    CONSTRAINT fk_player FOREIGN KEY (player_id) REFERENCES bronze.player(id),
    CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES bronze.city(id),
    CONSTRAINT fk_actor_park FOREIGN KEY (actor_park_id) REFERENCES bronze.park(id),
    CONSTRAINT fk_victim_park FOREIGN KEY (victim_park_id) REFERENCES bronze.park(id),
    CONSTRAINT fk_ride FOREIGN KEY (ride_id) REFERENCES bronze.ride(id)
);