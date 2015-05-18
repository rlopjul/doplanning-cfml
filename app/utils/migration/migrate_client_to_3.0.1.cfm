

ALTER TABLE `dp_hcs`.`hcs_files` 
ADD COLUMN `public` TINYINT(1) NOT NULL DEFAULT 0 AFTER `anti_virus_check_result`;

ALTER TABLE `dp_hcs`.`hcs_files` 
ADD COLUMN `file_public_id` VARCHAR(100) NULL AFTER `public`;

ALTER TABLE `dp_hcs`.`hcs_files` 
ADD UNIQUE INDEX `file_public_id_UNIQUE` (`file_public_id` ASC);


ALTER TABLE `dp_bioinformatics7`.`bioinformatics7_dp_documents` 
CHANGE COLUMN `description` `description` LONGTEXT CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL ;

