<!---Esto está añadido al DP del HCS--->
CREATE TABLE `hcs_items_sub_types` (
  `sub_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sub_type_name` varchar(45) NOT NULL,
  `sub_type_title_es` varchar(100) NOT NULL,
  `sub_type_title_en` varchar(100) NOT NULL,
  `item_type_id` int(10) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `position` int(10) NOT NULL,
  PRIMARY KEY (`sub_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


INSERT INTO `dp_hcs`.`hcs_items_sub_types` (`sub_type_id`,`sub_type_name`,`enabled`,`sub_type_title_es`,`sub_type_title_en`,`item_type_id`,`position`) VALUES 
        (1,'pubmed',1,'PubMed','PubMed',8,1),
        (2,'journal',1,'Revista','Journal',8,2);

ALTER TABLE `dp_hcs`.`hcs_pubmeds` 
ADD COLUMN `sub_type_id` INT(10) unsigned NOT NULL DEFAULT 1 AFTER `price`;

ALTER TABLE `dp_hcs`.`hcs_pubmeds` ADD CONSTRAINT `FK_hcs_pubmeds_6` FOREIGN KEY `FK_hcs_pubmeds_6` (`sub_type_id`)
    REFERENCES `hcs_items_sub_types` (`sub_type_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;
