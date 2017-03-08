CREATE TABLE sampleInfo (
	sampleid VARCHAR(20) PRIMARY KEY,
	added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	date TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
	samplelength INTEGER,
	format VARCHAR(10),
	latitude VARCHAR(20),
	longitude VARCHAR(20),
	humidity INTEGER,
	temp INTEGER,
	light VARCHAR(10),
	mfcc VARCHAR(255),
	species1 INTEGER,
	species2 INTEGER,
	species3 INTEGER
);