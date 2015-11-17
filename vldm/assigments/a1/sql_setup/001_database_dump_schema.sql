DROP TABLE IF EXISTS Event;
DROP TABLE IF EXISTS Person_Position;
DROP TABLE IF EXISTS Aircraft;
DROP TABLE IF EXISTS Airport;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Operator;
DROP TABLE IF EXISTS Position;


CREATE TABLE Aircraft(
	manufacturer VARCHAR(40),
	model VARCHAR(30),
	no_engines INTEGER,

	PRIMARY KEY(manufacturer, model)
);

CREATE TABLE Airport(
	id VARCHAR(16),
	name VARCHAR(50),
	city VARCHAR(40),
	country CHAR(2),

	PRIMARY KEY(id)
);

CREATE TABLE Operator(
	code VARCHAR(4),
	name VARCHAR(50),
	issue_date DATE,
	no_employees INTEGER,

	PRIMARY KEY(code)
);


CREATE TABLE Person(
	id SERIAL,
	first_name VARCHAR(25),
	last_name VARCHAR(25),
	city VARCHAR(40),
	operator_code CHAR(4) REFERENCES Operator(code) ON DELETE CASCADE ON UPDATE CASCADE,

	PRIMARY KEY(id)
);


CREATE TABLE Position(
	id SERIAL,
	description VARCHAR(30),

	PRIMARY KEY(id)
);


CREATE TABLE Person_Position(
	person_id INTEGER REFERENCES Person(id) ON DELETE CASCADE ON UPDATE CASCADE,
	position_id INTEGER REFERENCES Position(id) ON DELETE CASCADE ON UPDATE CASCADE,

	PRIMARY KEY (person_id, position_id)
);


CREATE TABLE Event (
	id SERIAL,
	type CHAR(1),
	date DATE,
	local_time CHAR(5),
	latitude DECIMAL,
	longitude DECIMAL,
	pilot_hours INTEGER,
	aircraft_manufacturer VARCHAR(40),
	aircraft_model VARCHAR(30),
	operator_code VARCHAR(4) REFERENCES Operator(code) ON DELETE CASCADE ON UPDATE CASCADE,
	airport_id VARCHAR(16) REFERENCES Airport(id) ON DELETE SET NULL ON UPDATE CASCADE,

	PRIMARY KEY (id),
	FOREIGN KEY (aircraft_manufacturer, aircraft_model) REFERENCES Aircraft(manufacturer, model) ON DELETE CASCADE ON UPDATE CASCADE

);






		
 
 
