CREATE TABLE sampleInfo (
	sampleid VARCHAR(20) PRIMARY KEY,
	deviceid VARCHAR(20),
	added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	latitude DECIMAL,
	longitude DECIMAL,
	humidity INTEGER,
	temp DECIMAL,
	light DECIMAL,
	type1 VARCHAR(20),
	per1 DECIMAL,
	type2 VARCHAR(20),
	per2 DECIMAL,
	type3 VARCHAR(20),
	per3 DECIMAL
);