CREATE TABLE `aircraft_categories` (
	`name` varchar(60) NOT NULL,
	`label` varchar(60) NOT NULL,

	PRIMARY KEY (`name`)
);

INSERT INTO `aircraft_categories` (name, label) VALUES
	('muscle','Helikopter')
;

CREATE TABLE `aircrafts` (
	`name` varchar(60) NOT NULL,
	`model` varchar(60) NOT NULL,
	`price` int(11) NOT NULL,
	`category` varchar(60) DEFAULT NULL,

	PRIMARY KEY (`model`)
);

INSERT INTO `aircrafts` (name, model, price, category) VALUES('Maverick','maverick',500000,'muscle');
INSERT INTO `aircrafts` (name, model, price, category) VALUES('Buzzard','buzzard2',500000,'muscle');
