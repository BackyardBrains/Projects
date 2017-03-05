CREATE TABLE sampleInfo (
	sampleid VARCHAR(20) PRIMARY KEY,
	date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	samplelength INTEGER,
	format VARCHAR(10),
	latitude VARCHAR(20),
	longitude VARCHAR(20),
	humidity INTEGER,
	temp INTEGER
);