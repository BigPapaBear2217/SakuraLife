

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_fahrschule', 'Fahrschule', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_fahrschule', 'Fahrschule', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_fahrschule', 'Fahrschule', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('fahrschule','Fahrschule')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('fahrschule',0,'recruit','Anfänger',0,'{}','{}'),
	('fahrschule',1,'officer','Security',0,'{}','{}'),
	('fahrschule',2,'sergeant','Sekretär',0,'{}','{}'),
	('fahrschule',3,'sergeant','Azubi',0,'{}','{}'),
	('fahrschule',4,'lieutenant','Fahrschullehrer',0,'{}','{}'),
	('fahrschule',5,'boss','Geschäftsleiter',0,'{}','{}')
;

