<cfset version_id = "2.9">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp29">
		SHOW TABLES LIKE '#new_client_abb#_dp_documents_locks';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp29.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>
	
<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<cfquery datasource="#client_datasource#" name="hasLinkTable">
			SHOW TABLES LIKE '#new_client_abb#_links';
		</cfquery>
		
		<!---Modificaciones de la base de datos--->
		<cftransaction>
			
			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_webs` 
				ADD COLUMN `news_area_id` INT(11) NULL AFTER `language`,
				ADD COLUMN `events_area_id` INT(11) NULL AFTER `news_area_id`,
				ADD COLUMN `publications_area_id` INT(11) NULL AFTER `events_area_id`,
				ADD INDEX `FK_#new_client_abb#_webs_areas_news_idx` (`news_area_id` ASC),
				ADD INDEX `FK_#new_client_abb#_webs_areas_events_idx` (`events_area_id` ASC),
				ADD INDEX `FK_#new_client_abb#_webs_areas_publications_idx` (`publications_area_id` ASC);
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_webs` 
				ADD CONSTRAINT `FK_#new_client_abb#_webs_areas`
				  FOREIGN KEY (`area_id`)
				  REFERENCES `#new_client_abb#_areas` (`id`)
				  ON DELETE RESTRICT
				  ON UPDATE NO ACTION,
				ADD CONSTRAINT `FK_#new_client_abb#_webs_areas_news`
				  FOREIGN KEY (`news_area_id`)
				  REFERENCES `#new_client_abb#_areas` (`id`)
				  ON DELETE RESTRICT
				  ON UPDATE NO ACTION,
				ADD CONSTRAINT `FK_#new_client_abb#_webs_areas_events`
				  FOREIGN KEY (`events_area_id`)
				  REFERENCES `#new_client_abb#_areas` (`id`)
				  ON DELETE RESTRICT
				  ON UPDATE NO ACTION,
				ADD CONSTRAINT `FK_#new_client_abb#_webs_areas_publications`
				  FOREIGN KEY (`publications_area_id`)
				  REFERENCES `#new_client_abb#_areas` (`id`)
				  ON DELETE RESTRICT
				  ON UPDATE NO ACTION;
			</cfquery>


			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_entries` 
				ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
				ADD INDEX `FK_#new_client_abb#_entries_7_idx` (`last_update_user_id` ASC);
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_entries` 
				ADD CONSTRAINT `FK_#new_client_abb#_entries_7`
				  FOREIGN KEY (`last_update_user_id`)
				  REFERENCES `#new_client_abb#_users` (`id`)
				  ON DELETE SET NULL
				  ON UPDATE NO ACTION;
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_events` 
				ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
				ADD INDEX `FK_#new_client_abb#_events_6_idx` (`last_update_user_id` ASC);
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_events` 
				ADD CONSTRAINT `FK_#new_client_abb#_events_6`
				  FOREIGN KEY (`last_update_user_id`)
				  REFERENCES `#new_client_abb#_users` (`id`)
				  ON DELETE SET NULL
				  ON UPDATE NO ACTION;
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_news` 
				ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
				ADD INDEX `FK_#new_client_abb#_news_6_idx` (`last_update_user_id` ASC);
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_news` 
				ADD CONSTRAINT `FK_#new_client_abb#_news_6`
				  FOREIGN KEY (`last_update_user_id`)
				  REFERENCES `#new_client_abb#_users` (`id`)
				  ON DELETE SET NULL
				  ON UPDATE NO ACTION;
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_images` 
				ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
				ADD INDEX `FK_#new_client_abb#_images_6_idx` (`last_update_user_id` ASC);
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_images` 
				ADD CONSTRAINT `FK_#new_client_abb#_images_6`
				  FOREIGN KEY (`last_update_user_id`)
				  REFERENCES `#new_client_abb#_users` (`id`)
				  ON DELETE SET NULL
				  ON UPDATE NO ACTION;
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_lists` 
				ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
				ADD INDEX `FK_#new_client_abb#_lists_6_idx` (`last_update_user_id` ASC);
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_lists` 
				ADD CONSTRAINT `FK_#new_client_abb#_lists_6`
				  FOREIGN KEY (`last_update_user_id`)
				  REFERENCES `#new_client_abb#_users` (`id`)
				  ON DELETE SET NULL
				  ON UPDATE NO ACTION;
			</cfquery>


			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_forms` 
				ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
				ADD INDEX `FK_#new_client_abb#_forms_6_idx` (`last_update_user_id` ASC);
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_forms` 
				ADD CONSTRAINT `FK_#new_client_abb#_forms_6`
				  FOREIGN KEY (`last_update_user_id`)
				  REFERENCES `#new_client_abb#_users` (`id`)
				  ON DELETE SET NULL
				  ON UPDATE NO ACTION;
			</cfquery>


			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_tasks` 
				ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `last_update_date`,
				ADD INDEX `FK_#new_client_abb#_tasks_6_idx` (`last_update_user_id` ASC);
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_tasks` 
				ADD CONSTRAINT `FK_#new_client_abb#_tasks_6`
				  FOREIGN KEY (`last_update_user_id`)
				  REFERENCES `#new_client_abb#_users` (`id`)
				  ON DELETE SET NULL
				  ON UPDATE NO ACTION;
			</cfquery>


			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_pubmeds` 
				ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
				ADD INDEX `FK_#new_client_abb#_pubmeds_7_idx` (`last_update_user_id` ASC);
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_pubmeds` 
				ADD CONSTRAINT `FK_#new_client_abb#_pubmeds_7`
				  FOREIGN KEY (`last_update_user_id`)
				  REFERENCES `#new_client_abb#_users` (`id`)
				  ON DELETE SET NULL
				  ON UPDATE NO ACTION;
			</cfquery>


			<cfif hasLinkTable.recordCount GT 0>
				
				<cfquery datasource="#client_datasource#">
					<!--- Comprobar si existe esta tabla --->
					ALTER TABLE `#new_client_abb#_links` 
					ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `position`,
					ADD INDEX `FK_#new_client_abb#_links_5_idx` (`last_update_user_id` ASC);
				</cfquery>

				<cfquery datasource="#client_datasource#">
					ALTER TABLE `#new_client_abb#_links` 
					ADD CONSTRAINT `FK_#new_client_abb#_links_5`
					  FOREIGN KEY (`last_update_user_id`)
					  REFERENCES `#new_client_abb#_users` (`id`)
					  ON DELETE SET NULL
					  ON UPDATE NO ACTION;
				</cfquery>

			</cfif>


			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_lists_views` 
				ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
				ADD INDEX `FK_#new_client_abb#_lists_views_4_idx` (`last_update_user_id` ASC);
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_lists_views` 
				ADD CONSTRAINT `FK_#new_client_abb#_lists_views_4`
				  FOREIGN KEY (`last_update_user_id`)
				  REFERENCES `#new_client_abb#_users` (`id`)
				  ON DELETE SET NULL
				  ON UPDATE NO ACTION;
			</cfquery>


			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_forms_views` 
				ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
				ADD INDEX `FK_#new_client_abb#_forms_views_4_idx` (`last_update_user_id` ASC);
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_forms_views` 
				ADD CONSTRAINT `FK_#new_client_abb#_forms_views_4`
				  FOREIGN KEY (`last_update_user_id`)
				  REFERENCES `#new_client_abb#_users` (`id`)
				  ON DELETE SET NULL
				  ON UPDATE NO ACTION;
			</cfquery>


			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_typologies` 
				ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `general`,
				ADD INDEX `FK_#new_client_abb#_typologies_5_idx` (`last_update_user_id` ASC);
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_typologies` 
				ADD CONSTRAINT `FK_#new_client_abb#_typologies_5`
				  FOREIGN KEY (`last_update_user_id`)
				  REFERENCES `#new_client_abb#_users` (`id`)
				  ON DELETE SET NULL
				  ON UPDATE NO ACTION;
			</cfquery>


			<!--- Cache --->
			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_areas_tree_cache` 
				CHANGE COLUMN `cache_content` `cache_content` LONGTEXT CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL;
			</cfquery>

			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_areas_tree_cache` 
				ADD COLUMN `areas_with_access` TEXT NULL AFTER `cache_content`;
			</cfquery>


			<!--- DP Documents --->
			<cfquery datasource="#client_datasource#">
				CREATE TABLE `#new_client_abb#_dp_documents` (
				  `id` int(11) NOT NULL AUTO_INCREMENT,
				  `title` text COLLATE utf8_unicode_ci NOT NULL,
				  `description` text COLLATE utf8_unicode_ci NOT NULL,
				  `parent_id` int(11) NOT NULL,
				  `parent_kind` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
				  `user_in_charge` int(11) NOT NULL,
				  `attached_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
				  `attached_file_id` int(11) DEFAULT NULL,
				  `creation_date` datetime NOT NULL,
				  `status` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
				  `area_id` int(11) NOT NULL,
				  `attached_image_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
				  `attached_image_id` int(11) DEFAULT NULL,
				  `link` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
				  `link_target` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
				  `last_update_date` datetime DEFAULT NULL,
				  `position` int(10) unsigned DEFAULT NULL,
				  `display_type_id` int(10) unsigned DEFAULT '1',
				  `iframe_url` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
				  `iframe_display_type_id` int(10) unsigned DEFAULT '1',
				  `publication_date` datetime DEFAULT NULL,
				  `publication_validated` tinyint(1) DEFAULT NULL,
				  `publication_validated_user` int(11) DEFAULT NULL,
				  `publication_validated_date` datetime DEFAULT NULL,
				  `area_editable` tinyint(1) DEFAULT '0',
				  `locked` tinyint(1) DEFAULT '0',
				  `last_update_user_id` int(11) DEFAULT NULL,
				  PRIMARY KEY (`id`),
				  KEY `user_in_charge` (`user_in_charge`),
				  KEY `attached_file_id` (`attached_file_id`),
				  KEY `area_id` (`area_id`),
				  KEY `FK_#new_client_abb#_dp_documents_4` (`attached_image_id`),
				  KEY `FK_#new_client_abb#_dp_documents_5` (`iframe_display_type_id`),
				  KEY `FK_#new_client_abb#_dp_documents_6` (`display_type_id`),
				  KEY `FK_#new_client_abb#_dp_documents_7_idx` (`last_update_user_id`),
				  CONSTRAINT `FK_#new_client_abb#_dp_documents_7` FOREIGN KEY (`last_update_user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
				  CONSTRAINT `FK_#new_client_abb#_dp_documents_4` FOREIGN KEY (`attached_image_id`) REFERENCES `#new_client_abb#_files` (`id`),
				  CONSTRAINT `FK_#new_client_abb#_dp_documents_5` FOREIGN KEY (`iframe_display_type_id`) REFERENCES `#new_client_abb#_iframes_display_types` (`iframe_display_type_id`),
				  CONSTRAINT `FK_#new_client_abb#_dp_documents_6` FOREIGN KEY (`display_type_id`) REFERENCES `#new_client_abb#_display_types` (`display_type_id`),
				  CONSTRAINT `#new_client_abb#_dp_documents_ibfk_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#new_client_abb#_users` (`id`),
				  CONSTRAINT `#new_client_abb#_dp_documents_ibfk_2` FOREIGN KEY (`attached_file_id`) REFERENCES `#new_client_abb#_files` (`id`),
				  CONSTRAINT `#new_client_abb#_dp_documents_ibfk_3` FOREIGN KEY (`area_id`) REFERENCES `#new_client_abb#_areas` (`id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>

			<cfquery datasource="#client_datasource#">
				CREATE TABLE `#new_client_abb#_dp_documents_locks` (
				  `item_id` int(11) NOT NULL,
				  `user_id` int(11) NOT NULL,
				  `lock_date` datetime NOT NULL,
				  `lock` tinyint(1) NOT NULL,
				  PRIMARY KEY (`item_id`,`user_id`,`lock_date`),
				  KEY `FK_#new_client_abb#_dp_documents_locks_2` (`user_id`),
				  CONSTRAINT `FK_#new_client_abb#_dp_documents_locks_1` FOREIGN KEY (`item_id`) REFERENCES `#new_client_abb#_dp_documents` (`id`) ON DELETE CASCADE,
				  CONSTRAINT `FK_#new_client_abb#_dp_documents_locks_2` FOREIGN KEY (`user_id`) REFERENCES `#new_client_abb#_users` (`id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8;
			</cfquery>

		</cftransaction>


		<cfoutput>
			#new_client_abb# migrado a versión #version_id#<br/><br/>
		</cfoutput>

		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput> 
		</cfcatch>

	</cftry>


</cfif>