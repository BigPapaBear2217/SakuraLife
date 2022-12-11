USE `essentialmode`;

CREATE TABLE `motor_categories` (
	`name` varchar(60) NOT NULL,
	`label` varchar(60) NOT NULL,

	PRIMARY KEY (`name`)
);

INSERT INTO `motor_categories` (name, label) VALUES
	('muscle','Muscle')
;

CREATE TABLE `motors` (
	`name` varchar(60) NOT NULL,
	`model` varchar(60) NOT NULL,
	`price` int(11) NOT NULL,
	`category` varchar(60) DEFAULT NULL,

	PRIMARY KEY (`model`)
);

INSERT INTO `motors` (name, model, price, category) VALUES
	('Blade','blade',15000,'muscle'),
;
