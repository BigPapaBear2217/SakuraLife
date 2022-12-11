CREATE TABLE IF NOT EXISTS `jobs_data` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`job_name` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`type` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`coords` VARCHAR(300) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`min_grade` SMALLINT(6) NOT NULL DEFAULT '0',
	`data` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`blip_id` INT(11) NULL DEFAULT NULL,
	`blip_color` INT(11) NULL DEFAULT '0',
	`blip_scale` FLOAT(12) NULL DEFAULT '1',
	`label` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`marker_type` INT(11) NULL DEFAULT '1',
	`marker_scale_x` FLOAT(12) NULL DEFAULT '1.5',
	`marker_scale_y` FLOAT(12) NULL DEFAULT '1.5',
	`marker_scale_z` FLOAT(12) NULL DEFAULT '0.5',
	`marker_color_red` INT(3) NULL DEFAULT '150',
	`marker_color_green` INT(3) NULL DEFAULT '150',
	`marker_color_blue` INT(3) NULL DEFAULT '0',
	`marker_color_alpha` INT(3) NULL DEFAULT '50',
	`ped` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`ped_heading` FLOAT(12) NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `id` (`id`) USING BTREE
);

CREATE TABLE IF NOT EXISTS `jobs_armories` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`weapon` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`components` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`ammo` INT(10) UNSIGNED NOT NULL,
	`tint` INT(11) NOT NULL,
	`marker_id` INT(11) NOT NULL,
	`identifier` VARCHAR(80) NOT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `id` (`id`, `marker_id`, `identifier`) USING BTREE
);

CREATE TABLE IF NOT EXISTS `jobs_garages` (
	`vehicle_id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_general_ci',
	`marker_id` INT(11) NOT NULL,
	`vehicle` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`vehicle_props` LONGTEXT NOT NULL COLLATE 'utf8mb4_bin',
	`plate` VARCHAR(10) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`vehicle_id`) USING BTREE,
	INDEX `identifier` (`identifier`, `marker_id`) USING BTREE
);

CREATE TABLE IF NOT EXISTS `jobs_shops` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`marker_id` INT(11) NOT NULL,
	`item_name` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`item_type` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`item_quantity` INT(11) NOT NULL,
	`price` INT(11) NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `marker_id` (`marker_id`) USING BTREE,
	INDEX `id` (`id`) USING BTREE
);

CREATE TABLE IF NOT EXISTS `jobs_wardrobes` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_general_ci',
	`label` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`outfit` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `identifier` (`identifier`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=INNODB;

ALTER TABLE jobs ADD COLUMN IF NOT EXISTS enable_billing INT(1) DEFAULT 0;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS can_rob INT(1) DEFAULT 0;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS can_handcuff INT(1) DEFAULT 0;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS whitelisted INT(1) DEFAULT 0;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS can_lockpick_cars INT(1) DEFAULT 0;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS can_wash_vehicles INT(1) DEFAULT 0;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS can_repair_vehicles INT(1) DEFAULT 0;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS can_impound_vehicles INT(1) DEFAULT 0;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS can_check_identity INT(1) DEFAULT 0;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS can_check_vehicle_owner INT(1) DEFAULT 0;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS can_check_driving_license INT(1) DEFAULT 0;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS can_check_weapon_license INT(1) DEFAULT 0;

ALTER TABLE jobs_data ADD COLUMN IF NOT EXISTS `blip_id` INT(11) NULL DEFAULT NULL;
ALTER TABLE jobs_data ADD COLUMN IF NOT EXISTS `blip_color` INT(11) NULL DEFAULT '0';
ALTER TABLE jobs_data ADD COLUMN IF NOT EXISTS `blip_scale` FLOAT(12) NULL DEFAULT '1';
ALTER TABLE jobs_data ADD COLUMN IF NOT EXISTS `label` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci';
ALTER TABLE jobs_data ADD COLUMN IF NOT EXISTS `marker_type` INT(11) NULL DEFAULT '1';
ALTER TABLE jobs_data ADD COLUMN IF NOT EXISTS `marker_scale_x` FLOAT(12) NULL DEFAULT '1.5';
ALTER TABLE jobs_data ADD COLUMN IF NOT EXISTS `marker_scale_y` FLOAT(12) NULL DEFAULT '1.5';
ALTER TABLE jobs_data ADD COLUMN IF NOT EXISTS `marker_scale_z` FLOAT(12) NULL DEFAULT '0.5';
ALTER TABLE jobs_data ADD COLUMN IF NOT EXISTS `marker_color_red` INT(3) NULL DEFAULT '150';
ALTER TABLE jobs_data ADD COLUMN IF NOT EXISTS `marker_color_green` INT(3) NULL DEFAULT '150';
ALTER TABLE jobs_data ADD COLUMN IF NOT EXISTS `marker_color_blue` INT(3) NULL DEFAULT '0';
ALTER TABLE jobs_data ADD COLUMN IF NOT EXISTS `marker_color_alpha` INT(3) NULL DEFAULT '50';
ALTER TABLE jobs_data ADD COLUMN IF NOT EXISTS `ped` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci';
ALTER TABLE jobs_data ADD COLUMN IF NOT EXISTS `ped_heading` FLOAT(12) NULL DEFAULT NULL;