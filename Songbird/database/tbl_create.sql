CREATE TABLE userInfo(
	username VARCHAR(20) PRIMARY KEY,
	password VARCHAR(20)
);

CREATE TABLE sampleInfo (
	sampleid INTEGER PRIMARY KEY,
	format VARCHAR(5),
	deviceid INTEGER,
	added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	latitude FLOAT,
	longitude FLOAT,
	humidity INTEGER,
	temp FLOAT,
	light FLOAT,
	type1 VARCHAR(40),
	per1 FLOAT,
	type2 VARCHAR(40),
	per2 FLOAT,
	type3 VARCHAR(40),
	per3 FLOAT
);

CREATE TABLE uploadInfo(
	uploadid INTEGER PRIMARY KEY,
	format VARCHAR(5),
	username VARCHAR(20),
	added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	latitude FLOAT,
	longitude FLOAT,
	humidity INTEGER,
	temp FLOAT,
	light FLOAT,
	type1 VARCHAR(40),
	per1 FLOAT,
	type2 VARCHAR(40),
	per2 FLOAT,
	type3 VARCHAR(40),
	per3 FLOAT,
	FOREIGN KEY (username) REFERENCES userInfo(username)
);