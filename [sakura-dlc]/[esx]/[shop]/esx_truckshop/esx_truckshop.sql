USE `essentialmode`;

CREATE TABLE `truck_categories` (
	`name` varchar(60) NOT NULL,
	`label` varchar(60) NOT NULL,

	PRIMARY KEY (`name`)
);

INSERT INTO `truck_categories` (name, label) VALUES
	('motorrad','Motorad'),
	('quad','Quad')
;

CREATE TABLE `truck` (
	`name` varchar(60) NOT NULL,
	`model` varchar(60) NOT NULL,
	`price` int(11) NOT NULL,
	`category` varchar(60) DEFAULT NULL,

	PRIMARY KEY (`model`)
);

INSERT INTO `truck` (name, model, price, category) VALUES
('Benson', 'benson', 350000, 'truck'),
('Burrito', 'burrito3', 225000, 'truck'),
('Mule', 'mule', 340000, 'truck'),
('Pounder', 'pounder', 780000, 'truck')
;