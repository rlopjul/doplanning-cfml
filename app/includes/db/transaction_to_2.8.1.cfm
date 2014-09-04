<cfif checkVersion IS true>
	
	<cfquery datasource="#client_datasource#" name="isDbDp281">
		SHOW TABLES LIKE '#new_client_abb#_items_sub_types';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp281.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión 2.8.1.<br/><br/>
	</cfoutput>
	
<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión 2.8.1<br/>
	</cfoutput>

	<!---Modificaciones de la base de datos--->
	<cftransaction>
		
		<cfquery datasource="#client_datasource#">	
			CREATE TABLE `dp_#new_client_abb#`.`#new_client_abb#_items_sub_types` (
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

		<cfquery datasource="#client_datasource#">
			INSERT INTO `#new_client_abb#_items_sub_types` (`sub_type_id`,`sub_type_name`,`enabled`,`sub_type_title_es`,`sub_type_title_en`,`item_type_id`,`position`) VALUES 
 				(1,'pubmed',1,'PubMed','PubMed',8,1),
 				(2,'journal',1,'Revista','Journal',8,2);
 		</cfquery>

		<cfquery datasource="#client_datasource#">	
			ALTER TABLE `dp_#new_client_abb#`.`#new_client_abb#_pubmeds` 
				ADD COLUMN `sub_type_id` INT(10) unsigned NOT NULL DEFAULT 1 AFTER `price`;
		</cfquery>

		<cfquery datasource="#client_datasource#">	
			ALTER TABLE `dp_#new_client_abb#`.`#new_client_abb#_pubmeds` ADD CONSTRAINT `FK_#new_client_abb#_pubmeds_6` FOREIGN KEY `FK_#new_client_abb#_pubmeds_6` (`sub_type_id`)
    			REFERENCES `#new_client_abb#_items_sub_types` (`sub_type_id`)
    				ON DELETE RESTRICT
   					ON UPDATE RESTRICT;
		</cfquery>
			
	</cftransaction>

	<cfoutput>
		#new_client_abb# migrado a versión 2.8.1<br/><br/>
	</cfoutput>

</cfif>



