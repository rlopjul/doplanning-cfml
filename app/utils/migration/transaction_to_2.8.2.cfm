<cfquery datasource="#client_dsn#" name="isDbDp281">
	SHOW TABLES LIKE '#client_abb#_items_sub_types';
</cfquery>

<cfif isDbDp281.recordCount GT 0>

	<cfoutput>
		Cliente #client_abb# ya migrado anteriormente.<br/><br/>
	</cfoutput>
	
<cfelse>

	<cfoutput>
		Migrar #client_abb#<br/>
	</cfoutput>

	<!---Modificaciones de la base de datos--->
	<cftransaction>
		
		<cfquery datasource="#client_dsn#">	
			CREATE TABLE `dp_#client_abb#`.`#client_abb#_items_sub_types` (
			  `sub_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
			  `sub_type_name` varchar(45) NOT NULL,
			  `sub_type_title_es` varchar(100) NOT NULL,
			  `sub_type_title_en` varchar(100) NOT NULL,
			  `item_type_id` int(10) NOT NULL,
			  `enabled` tinyint(1) NOT NULL DEFAULT '1',
			  `position` int(10) NOT NULL,
			  PRIMARY KEY (`sub_type_id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>

		<cfquery datasource="#client_dsn#">
			INSERT INTO `#client_abb#_items_sub_types` (`sub_type_id`,`sub_type_name`,`enabled`,`sub_type_title_es`,`sub_type_title_en`,`item_type_id`,`position`) VALUES 
 				(1,'pubmed',1,'PubMed','PubMed',8,1),
 				(2,'journal',1,'Revista','Journal',8,2);
 		</cfquery>

		<cfquery datasource="#client_dsn#">	
			ALTER TABLE `dp_#client_abb#`.`#client_abb#_pubmeds` 
				ADD COLUMN `sub_type_id` INT(10) unsigned NOT NULL DEFAULT 1 AFTER `price`;
		</cfquery>

		<cfquery datasource="#client_dsn#">	
			ALTER TABLE `dp_#client_abb#`.`#client_abb#_pubmeds` ADD CONSTRAINT `FK_#client_abb#_pubmeds_6` FOREIGN KEY `FK_#client_abb#_pubmeds_6` (`sub_type_id`)
    			REFERENCES `#client_abb#_items_sub_types` (`sub_type_id`)
    				ON DELETE RESTRICT
   					ON UPDATE RESTRICT;
		</cfquery>
			
	</cftransaction>

	<cfoutput>
		#client_abb# migrado<br/><br/>
	</cfoutput>

</cfif>



