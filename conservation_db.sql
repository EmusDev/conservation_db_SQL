-- Active: 1747412228310@@127.0.0.1@5432@conservation_db

CREATE DATABASE conservation_db; 

CREATE Table rangers (
    ranger_id INT PRIMARY key UNIQUE,
    name VARCHAR(30) NOT NULL,
    region VARCHAR (30)   
    );

    select * FROM rangers;

    INSERT INTO rangers (ranger_id,name,region) VALUES
    (1,'Alice Green ','Northern Hills'),
    (2,'Bob White ','River Delta'),
    (3,'Carol King ','Mountain Range');

 CREATE Table species (
    species_id INT PRIMARY KEY UNIQUE,
    common_name VARCHAR (30),
    scientific_name VARCHAR (30),
    discovery_date DATE,
    conservation_status VARCHAR (30)  
        
);

    SELECT * FROM species;

INSERT INTO  species (species_id,common_name,scientific_name,discovery_date,conservation_status)VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Vulnerable'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

SELECT * FROM species;

 CREATE TABLE sightings (
    sighting_id INT PRIMARY KEY,
    species_id INT, 
    ranger_id INT,
    location VARCHAR(50),
    sighting_time DATE DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (species_id) REFERENCES species(species_id),
    FOREIGN KEY (ranger_id) REFERENCES rangers(ranger_id)
);

SELECT *  FROM sightings;

INSERT INTO sightings (sighting_id,species_id,ranger_id,location,sighting_time,notes) VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


            --  problem solving 
-- 01/Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'

INSERT INTO rangers (ranger_id,name,region) VALUES
(4,'Derek Fox','Coastal Plains');

SELECT * FROM rangers;


-- 2️/ Count unique species ever sighted.

SELECT * FROM species;

-- SELECT count(*) AS uniuque_species_count FROM  species;
 

SELECT COUNT(DISTINCT sp.species_id) AS unique_species_count
FROM species AS sp
INNER JOIN sightings AS st 
ON sp.species_id = st.species_id;


-- 03/ Find all sightings where the location includes "Pass"

SELECT * FROM sightings 
WHERE location LIKE '%Pass%';


-- 04 /List each ranger's name and their total number of sightings.


SELECT r.name, COUNT(s.sighting_id) AS total_sightings
FROM rangers AS r
LEFT JOIN sightings AS s 
ON r.ranger_id = s.ranger_id
GROUP BY r.name; 



-- 05/ List species that have never been sighted.

SELECT sp.common_name
FROM species AS sp
WHERE sp.species_id
NOT IN (SELECT species_id FROM sightings);



-- 06/Show the most recent 2 sightings

SELECT sp.common_name, st.sighting_time, r.name
FROM sightings AS st
JOIN species AS sp
ON st.species_id = sp.species_id
JOIN rangers AS r
ON st.ranger_id = r.ranger_id
ORDER BY st.sighting_time DESC
LIMIT 2;



--7/ Update all species discovered before year 1800 to have status 'Historic'.

UPDATE species
SET conservation_status = 'Historic'
WHERE EXTRACT(YEAR FROM discovery_date) < 1800;
 

SELECT * FROM species; 


-- 08/Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening' 

SELECT  sighting_id,sighting_time,
  CASE 
    WHEN TIME(sighting_time) < '12:00:00' THEN 'Morning'
    WHEN TIME(sighting_time) >= '12:00:00'
    AND TIME(sighting_time) <= '17:00:00' THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day
FROM sightings;

-- I don not know,if it will work or not, but I will try hard. 8 no probolem



-- 9/Delete rangers who have never sighted any species

 DELETE FROM rangers
WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id FROM sightings
);

SELECT * FROM  rangers;