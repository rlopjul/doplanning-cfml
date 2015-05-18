

/* Tabla elementos eliminados */

ALTER TABLE `dp_bioinformatics7`.`bioinformatics7_items_deleted` 
DROP FOREIGN KEY `FK_bioinformatics7_items_deleted_1`,
DROP FOREIGN KEY `FK_bioinformatics7_items_deleted_2`;
ALTER TABLE `dp_bioinformatics7`.`bioinformatics7_items_deleted` 
CHANGE COLUMN `delete_area_id` `delete_area_id` INT(11) NULL ;
ALTER TABLE `dp_bioinformatics7`.`bioinformatics7_items_deleted` 
ADD CONSTRAINT `FK_bioinformatics7_items_deleted_1`
  FOREIGN KEY (`delete_area_id`)
  REFERENCES `dp_bioinformatics7`.`bioinformatics7_areas` (`id`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION,
ADD CONSTRAINT `FK_bioinformatics7_items_deleted_2`
  FOREIGN KEY (`delete_user_id`)
  REFERENCES `dp_bioinformatics7`.`bioinformatics7_users` (`id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION;
