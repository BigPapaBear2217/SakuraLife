USE `essentialmode`;

CREATE TABLE `bike_categories` (
	`name` varchar(60) NOT NULL,
	`label` varchar(60) NOT NULL,

	PRIMARY KEY (`name`)
);

INSERT INTO `bike_categories` (name, label) VALUES
	('motorrad','Motorad'),
	('quad','Quad')
;

CREATE TABLE `aircrafts` (
	`name` varchar(60) NOT NULL,
	`model` varchar(60) NOT NULL,
	`price` int(11) NOT NULL,
	`category` varchar(60) DEFAULT NULL,

	PRIMARY KEY (`model`)
);

INSERT INTO `motorrad` (name, model, price, category) VALUES
    ('Akuma', 'akuma', 75000, 'motorrad'),
    ('Bati 808', 'bati', 100000, 'motorrad'),
    ('BF400', 'bf400', 60000, 'motorrad'),
    ('Double', 'double', 65000, 'motorrad'),
    ('Hakuchou', 'hakuchou', 125000, 'motorrad'),
    ('Lectro', 'lectro', 130000, 'motorrad'),
    ('Bagger', 'bagger', 70000, 'motorrad'),
;