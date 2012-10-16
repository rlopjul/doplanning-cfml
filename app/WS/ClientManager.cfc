<!---Copyright Era7 Information Technologies 2007-2009

	Date of file creation: 18-11-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 17-07-2009
	
--->
<cfcomponent output="false">

	<cfset component = "ClientManager">
	
	<!--- ----------------------- XML CLIENT -------------------------------- --->
	
	<cffunction name="xmlClient" returntype="string" output="false" access="public">		
		<cfargument name="objectClient" type="struct" required="yes">
		
		<cfset var method = "xmlClient">
		
		<cftry>
		
			<cfprocessingdirective suppresswhitespace="true">
			<cfsavecontent variable="xmlResult">
				<cfoutput>
					<client id="#objectClient.id#"
						 administrator_id="#objectClient.administrator_id#"
						 root_area_id="#objectClient.root_area_id#"
						 number_of_users="#objectClient.number_of_users#"
						<cfif len(objectClient.space) GT 0>
						 space="#objectClient.space#"
						</cfif>
						<cfif len(objectClient.abbreviation) GT 0>
						 abbreviation="#objectClient.abbreviation#"
						</cfif>
						<cfif len(objectClient.creation_date) GT 0>
						 creation_date="#objectClient.creation_date#"
						</cfif>
						<cfif len(objectClient.number_of_sms_used) GT 0>
						 number_of_sms_used="#objectClient.number_of_sms_used#"
						</cfif>
						<cfif len(objectClient.number_of_sms_paid) GT 0>
						 number_of_sms_paid="#objectClient.number_of_sms_paid#"
						</cfif>>
						<name><![CDATA[#objectClient.name#]]></name>
					</client>
				</cfoutput>
			</cfsavecontent>
			</cfprocessingdirective>
			
			<cfreturn xmlResult>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
				<cfreturn null>
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	
	<!--- ----------------------- CLIENT OBJECT -------------------------------- --->
	
	<cffunction name="objectClient" returntype="any" output="false" access="public">	
		
		<cfargument name="xml" type="string" required="no">
		
		<cfargument name="id" type="string" required="no" default="">
		<cfargument name="name" type="string" required="no" default="">		
		<cfargument name="administrator_id" type="string" required="no" default="">		
		<cfargument name="root_area_id" type="string" required="no" default="">
		<cfargument name="number_of_users" type="string" required="no" default="">
		<cfargument name="space" type="string" required="no" default="">
		<cfargument name="abbreviation" type="string" required="no" default="">
		<cfargument name="creation_date" type="string" required="no" default="">
		<cfargument name="number_of_sms_used" type="string" required="no" default="">
		<cfargument name="number_of_sms_paid" type="string" required="no" default="">		
		
		<cfargument name="return_type" type="string" required="no">
		
		<cfset var method = "objectClient">
		
		<cftry>
			
			<cfif isDefined("arguments.xml")>
			
				<cfxml variable="xmlClient">
				<cfoutput>
				#arguments.xml#
				</cfoutput>
				</cfxml>
				
				<cfif isDefined("xmlClient.client.XmlAttributes.id")>
					<cfset id=xmlClient.client.XmlAttributes.id>
				</cfif>		
					
				<cfif isDefined("xmlClient.client.name")>
					<cfset name=xmlClient.client.name.xmlText>
				</cfif>
				
				<cfif isDefined("xmlClient.client.XmlAttributes.administrator_id")>
					<cfset administrator_id=xmlClient.client.XmlAttributes.administrator_id>
				</cfif>
				
				<cfif isDefined("xmlClient.client.XmlAttributes.root_area_id")>
					<cfset root_area_id=xmlClient.client.XmlAttributes.root_area_id>
				</cfif>
				
				<cfif isDefined("xmlClient.client.XmlAttributes.number_of_users")>
					<cfset number_of_users=xmlClient.client.XmlAttributes.number_of_users>
				</cfif>
				
				<cfif isDefined("xmlClient.client.XmlAttributes.space")>
					<cfset space=xmlClient.client.XmlAttributes.space>
				</cfif>
				
				<cfif isDefined("xmlClient.client.XmlAttributes.abbreviation")>
					<cfset abbreviation=xmlClient.client.XmlAttributes.abbreviation>
				</cfif>
				
				<cfif isDefined("xmlClient.client.XmlAttributes.creation_date")>
					<cfset creation_date=xmlClient.client.XmlAttributes.creation_date>
				</cfif>
				
				<cfif isDefined("xmlClient.client.XmlAttributes.number_of_sms_used")>
					<cfset number_of_sms_used=xmlClient.client.XmlAttributes.number_of_sms_used>
				</cfif>
				
				<cfif isDefined("xmlClient.client.XmlAttributes.number_of_sms_paid")>
					<cfset number_of_sms_paid=xmlClient.client.XmlAttributes.number_of_sms_paid>
				</cfif>
			
			<cfelseif NOT isDefined("arguments.id")>
				<cfreturn null>
			</cfif>
			
			<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringDate">
				<cfinvokeargument name="timestamp_date" value="#creation_date#">
			</cfinvoke>
			<cfset creation_date = stringDate>
					
			<cfset object = {
				id="#id#",
				name="#name#",
				administrator_id="#administrator_id#",
				root_area_id="#root_area_id#",
				number_of_users="#number_of_users#",
				space="#space#",
				abbreviation="#abbreviation#",
				creation_date="#creation_date#",
				number_of_sms_used="#number_of_sms_used#",
				number_of_sms_paid="#number_of_sms_paid#"
				}>
				
			
			<cfif isDefined("arguments.return_type") AND arguments.return_type EQ "xml">
				
				<cfinvoke component="ClientManager" method="xmlClient" returnvariable="xmlResult">
					<cfinvokeargument name="objectClient" value="#object#">
				</cfinvoke>
				<cfreturn xmlResult>

			<cfelse>
			
				<cfreturn object>
				
			</cfif>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
				<cfreturn null>
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	
	<!--- ------------------------------ createClient ----------------------------- --->
	
	<cffunction name="createClient" returntype="string" access="public">
		<cfargument name="request" type="string" required="yes">
		<!---<cfargument name="objectClient" type="string" required="yes">--->
		
		<cfset var method = "createClient">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<!---<cfinclude template="includes/checkApplicationAdminAccess.cfm">--->
			
			
			<cfinvoke component="ClientManager" method="objectClient" returnvariable="objectClient">
				<cfinvokeargument name="xml" value="#xmlRequest.request.parameters.client#">
				
				<cfinvokeargument name="return_type" value="object">
			</cfinvoke>
			
			<cfquery name="beginTransaction" datasource="#client_dsn#">
				BEGIN;
			</cfquery>
			
			<cfinvoke component="DateManager" method="getCurrentDateTime" returnvariable="current_date">
			</cfinvoke>
			
			<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringCurrentDate">
				<cfinvokeargument name="timestamp_date" value="#current_date#">
			</cfinvoke>
			
			<!---<cfset client_id = "NULL">
			<cfset name = "NULL">
			<cfset administrator_id = 1>
			<cfset number_of_users = 100>
			<cfset space = 0>
			<cfset abbreviation = "NULL">
			<cfset creation_date = current_date>
			<cfset number_of_sms_used = 0>
			<cfset number_of_sms_paid = 100>--->
			
			<cfset objectClient.administrator_id = 1>
			<cfset objectClient.root_area_id = 1><!--- root area id which will always be 1 --->
			<cfset objectClient.number_of_users = 1>
			<cfset objectClient.space = 0>
			<cfset objectClient.number_of_sms_used = 0>
			<cfset objectClient.creation_date = stringCurrentDate>
			
			<cfset new_client_abb = objectClient.abbreviation>
			
			<!---<cfoutput>
			<cfdump var="#objectClient#">
			<cfdump var="#xmlRequest.request.parameters.user#">
			</cfoutput>--->
			
			<cfquery name="insertClientQuery" datasource="#APPLICATION.dsn#" >							
				INSERT INTO `APP_clients` (`id`, `name`, `administrator_id`, `root_area_id`, `number_of_users`, `space`, `abbreviation`, `creation_date`, `number_of_sms_used`, `number_of_sms_paid`, `email_support`) VALUES 
					(<cfqueryPARAM value="#objectClient.id#" CFSQLType="CF_SQL_varchar">,
					<cfqueryPARAM value="#objectClient.name#" CFSQLType="CF_SQL_varchar">,					
					<cfqueryPARAM value="#objectClient.administrator_id#" CFSQLType = "CF_SQL_varchar">,
					<cfqueryparam value="#objectClient.root_area_id#" cfsqltype="cf_sql_integer">, 
					<cfqueryPARAM value="#objectClient.number_of_users#" CFSQLType = "CF_SQL_integer">,
					<cfqueryPARAM value="#objectClient.space#" CFSQLType = "CF_SQL_integer">,						
					<cfqueryPARAM value="#objectClient.abbreviation#" CFSQLType = "CF_SQL_varchar">,
					<cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">,
					<cfqueryPARAM value="#objectClient.number_of_sms_used#" cfsqltype="cf_sql_integer">,
					<cfqueryPARAM value="#objectClient.number_of_sms_paid#" cfsqltype="cf_sql_integer">,
					<cfqueryPARAM value="support@doplanning.net" cfsqltype="cf_sql_varchar">
					);			
			</cfquery>
			
			<cfset client_datasource = APPLICATION.identifier&"_"&objectClient.abbreviation>
			
			
			<!--- Now we have to create all the tables --->

			
			<cfquery name="createTableAlertMessages" datasource="#client_datasource#">

				CREATE TABLE IF NOT EXISTS `#new_client_abb#_alert_messages` (
				  `id` int(11) NOT NULL auto_increment,
				  `content` text collate utf8_unicode_ci NOT NULL,
				  `creation_date` timestamp NOT NULL default CURRENT_TIMESTAMP,
				  `expiration_date` datetime NOT NULL,
				  PRIMARY KEY  (`id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>
			
			<cfquery name="insertAlertMessage" datasource="#client_datasource#">
				INSERT INTO `#new_client_abb#_alert_messages` (`id`, `content`, `expiration_date`) VALUES
(1, '¡Bienvenido a #APPLICATION.title#!', ADDDATE(<cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">,3));
			</cfquery>
				
			
			<cfquery datasource="#client_datasource#">
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_areas` (
				  `id` int(11) NOT NULL auto_increment,
				  `name` text collate utf8_unicode_ci,
				  `parent_id` int(11) default NULL,
				  `user_in_charge` int(11) NOT NULL,
				  `creation_date` datetime NOT NULL,
				  `description` text collate utf8_unicode_ci,
				  `image_id` int(11) default NULL,
				  `link` varchar(255) collate utf8_unicode_ci default NULL,
				  `space_used` int(10) unsigned NOT NULL default '0',
				  PRIMARY KEY  (`id`),
				  KEY `image_id` (`image_id`),
				  KEY `user_in_charge` (`user_in_charge`),
				  KEY `parent_id` (`parent_id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>
			
			<cfquery datasource="#client_datasource#">	
				INSERT INTO `#new_client_abb#_areas` (`id`, `name`, `parent_id`, `user_in_charge`, `creation_date`, `description`, `image_id`, `link`, `space_used`) VALUES
				(1, 'Organización', NULL, 1, <cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">, NULL, NULL, NULL, 0);
			</cfquery>
				
			<cfquery datasource="#client_datasource#">
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_areas_administrators` (
				  `user_id` int(11) NOT NULL,
				  `area_id` int(11) NOT NULL,
				  PRIMARY KEY  (`user_id`,`area_id`),
				  KEY `area_id` (`area_id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>
				
			<cfquery datasource="#client_datasource#">
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_areas_files` (
				  `area_id` int(11) NOT NULL,
				  `file_id` int(11) NOT NULL,
				  `association_date` datetime NOT NULL,
				  PRIMARY KEY  (`area_id`,`file_id`),
				  KEY `file_id` (`file_id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>
				
			<!---
			Tabla _areas_images anterior
			<cfquery datasource="#client_datasource#">
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_areas_images` (
				  `id` int(11) NOT NULL auto_increment,
				  `physical_name` varchar(200) collate utf8_unicode_ci NOT NULL,
				  `file_size` int(11) NOT NULL,
				  `file_type` varchar(10) collate utf8_unicode_ci NOT NULL,
				  `uploading_date` datetime NOT NULL,
				  `replacement_date` datetime default NULL,
				  `file_name` varchar(255) collate utf8_unicode_ci NOT NULL,
				  `image_background_color` varchar(10) collate utf8_unicode_ci default NULL,
				  `status` varchar(10) collate utf8_unicode_ci NOT NULL,
				  PRIMARY KEY  (`id`),
				  UNIQUE KEY `image_src` (`physical_name`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>--->	
				
				
			<cfquery datasource="#client_datasource#">
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_areas_images` (
				  `id` int(11) NOT NULL auto_increment,
				  `physical_name` varchar(200) collate utf8_unicode_ci default NULL,
				  `file_size` int(11) default NULL,
				  `file_type` varchar(10) collate utf8_unicode_ci default NULL,
				  `uploading_date` datetime NOT NULL,
				  `replacement_date` datetime default NULL,
				  `file_name` varchar(255) collate utf8_unicode_ci default NULL,
				  `image_background_color` varchar(10) collate utf8_unicode_ci default NULL,
				  `status` varchar(10) collate utf8_unicode_ci NOT NULL,
				  `status_replacement` varchar(100) collate utf8_unicode_ci default NULL,
				  PRIMARY KEY  (`id`),
				  UNIQUE KEY `image_src` (`physical_name`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;	
			</cfquery>			
			
			<cfquery datasource="#client_datasource#">	
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_areas_users` (
				  `area_id` int(11) NOT NULL,
				  `user_id` int(11) NOT NULL,
				  PRIMARY KEY  (`area_id`,`user_id`),
				  KEY `user_id` (`user_id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>	
				
			<!---<cfquery datasource="#client_datasource#">
				INSERT INTO `#new_client_abb#_areas_users` (`area_id`, `user_id`) VALUES
				(1, 1);
			</cfquery>--->	
				
			<cfquery datasource="#client_datasource#">	
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_contacts` (
				  `user_id` int(11) NOT NULL,
				  `id` int(11) NOT NULL auto_increment,
				  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
				  `telephone` varchar(255) collate utf8_unicode_ci default NULL,
				  `address` varchar(255) collate utf8_unicode_ci default NULL,
				  `email` varchar(255) collate utf8_unicode_ci default NULL,
				  `family_name` varchar(255) collate utf8_unicode_ci default NULL,
				  `mobile_phone` varchar(255) collate utf8_unicode_ci default NULL,
				  `organization` varchar(255) collate utf8_unicode_ci default NULL,
				  `telephone_ccode` int(11) default NULL,
				  `mobile_phone_ccode` int(11) default NULL,
				  PRIMARY KEY  (`id`),
				  KEY `user_id` (`user_id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>
			
			<cfquery datasource="#client_datasource#">
			     CREATE TABLE IF NOT EXISTS `#new_client_abb#_errors_log` (
				  `id` int(11) NOT NULL auto_increment,
				  `code` int(11) NOT NULL,
				  `method_id` int(11) default NULL,
				  `time` timestamp NOT NULL default CURRENT_TIMESTAMP,
				  `user_id` int(11) default NULL,
				  `content` text collate utf8_unicode_ci,
				  `method` varchar(255) collate utf8_unicode_ci default NULL,
				  `component` varchar(255) collate utf8_unicode_ci default NULL,
				  PRIMARY KEY  (`id`),
				  KEY `user_id` (`user_id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>	
				
			<!---
			Tabla _files anterior
			<cfquery datasource="#client_datasource#">
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_files` (
				  `id` int(11) NOT NULL auto_increment,
				  `physical_name` text collate utf8_unicode_ci,
				  `name` text collate utf8_unicode_ci,
				  `user_in_charge` int(11) NOT NULL,
				  `file_size` int(11) default NULL,
				  `file_type` varchar(255) collate utf8_unicode_ci default NULL,
				  `uploading_date` datetime NOT NULL,
				  `description` text collate utf8_unicode_ci,
				  `replacement_date` datetime default NULL,
				  `file_name` text collate utf8_unicode_ci,
				  `status` varchar(255) collate utf8_unicode_ci default NULL,
				  PRIMARY KEY  (`id`),
				  KEY `user_in_charge` (`user_in_charge`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>--->
			
			<cfquery datasource="#client_datasource#">
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_files` (
				  `id` int(11) NOT NULL auto_increment,
				  `physical_name` text collate utf8_unicode_ci,
				  `name` text collate utf8_unicode_ci,
				  `user_in_charge` int(11) NOT NULL,
				  `file_size` int(11) default NULL,
				  `file_type` varchar(255) collate utf8_unicode_ci default NULL,
				  `uploading_date` datetime NOT NULL,
				  `description` text collate utf8_unicode_ci,
				  `replacement_date` datetime default NULL,
				  `file_name` text collate utf8_unicode_ci,
				  `status` varchar(255) collate utf8_unicode_ci default NULL,
				  `status_replacement` varchar(100) collate utf8_unicode_ci default NULL,
				  PRIMARY KEY  (`id`),
				  KEY `user_in_charge` (`user_in_charge`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>
				
			<cfquery datasource="#client_datasource#">
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_folders` (
				  `id` int(11) NOT NULL auto_increment,
				  `name` text collate utf8_unicode_ci NOT NULL,
				  `creation_date` datetime NOT NULL,
				  `user_in_charge` int(11) NOT NULL,
				  `parent_id` int(11) default NULL,
				  `description` text collate utf8_unicode_ci,
				  PRIMARY KEY  (`id`),
				  KEY `parent_id` (`parent_id`),
				  KEY `user_in_charge` (`user_in_charge`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>	
				
			<!---<cfquery datasource="#client_datasource#">
				INSERT INTO `#new_client_abb#_folders` (`id`, `name`, `creation_date`, `user_in_charge`, `parent_id`, `description`) VALUES
				(1, 'Mis documentos', <cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">, 1, NULL, NULL);
			</cfquery>--->
				
			<cfquery datasource="#client_datasource#">
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_folders_files` (
				  `folder_id` int(11) NOT NULL,
				  `file_id` int(11) NOT NULL,
				  PRIMARY KEY  (`folder_id`,`file_id`),
				  KEY `file_id` (`file_id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>
				
			<cfquery datasource="#client_datasource#">
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_logs` (
				  `id` bigint(20) NOT NULL auto_increment,
				  `user_id` int(11) default NULL,
				  `time` timestamp NOT NULL default CURRENT_TIMESTAMP,
				  `method_id` int(11) default NULL,
				  `request_content` text collate utf8_unicode_ci,
				  `method` varchar(255) collate utf8_unicode_ci default NULL,
				  `component` varchar(255) collate utf8_unicode_ci default NULL,
				  PRIMARY KEY  (`id`),
				  KEY `user_id` (`user_id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>
				
				
			<cfquery datasource="#client_datasource#">	
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_messages` (
				  `id` int(11) NOT NULL auto_increment,
				  `title` text collate utf8_unicode_ci,
				  `description` text collate utf8_unicode_ci,
				  `parent_id` int(11) NOT NULL,
				  `parent_kind` varchar(255) collate utf8_unicode_ci default NULL,
				  `user_in_charge` int(11) NOT NULL,
				  `attached_file_name` varchar(255) collate utf8_unicode_ci default NULL,
				  `attached_file_id` int(11) default NULL,
				  `creation_date` datetime NOT NULL,
				  `message_read` tinyint(1) default NULL,
				  `status` varchar(255) collate utf8_unicode_ci NOT NULL,
				  `area_id` int(11) NOT NULL,
				  PRIMARY KEY  (`id`),
				  KEY `user_in_charge` (`user_in_charge`),
				  KEY `attached_file_id` (`attached_file_id`),
				  KEY `area_id` (`area_id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>	
				
			<cfquery datasource="#client_datasource#">
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_sms` (
				  `id` int(11) NOT NULL auto_increment,
				  `text` varchar(255) collate utf8_unicode_ci NOT NULL,
				  `user_id` int(11) NOT NULL,
				  `recipients` text collate utf8_unicode_ci,
				  `response` varchar(255) collate utf8_unicode_ci default NULL,
				  `msgid` varchar(255) collate utf8_unicode_ci default NULL,
				  `date` datetime NOT NULL,
				  PRIMARY KEY  (`id`),
				  KEY `user_id` (`user_id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>	
				
			<cfquery datasource="#client_datasource#">
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_users` (
				  `id` int(11) NOT NULL auto_increment,
				  `name` varchar(255) collate utf8_unicode_ci default NULL,
				  `telephone` varchar(255) collate utf8_unicode_ci default NULL,
				  `address` varchar(255) collate utf8_unicode_ci default NULL,
				  `password` varchar(255) collate utf8_unicode_ci default NULL,
				  `space_used` int(11) default '0',
				  `number_of_connections` int(11) default '0',
				  `connected` tinyint(1) default '0',
				  `session_id` varchar(255) collate utf8_unicode_ci default NULL,
				  `creation_date` datetime NOT NULL,
				  `internal_user` tinyint(1) default NULL,
				  `root_folder_id` int(11) default NULL,
				  `family_name` varchar(255) collate utf8_unicode_ci default NULL,
				  `sms_allowed` tinyint(1) default '0',
				  `mobile_phone` varchar(255) collate utf8_unicode_ci default NULL,
				  `last_connection` datetime default NULL,
				  `space_downloaded` int(11) default '0',
				  `validated` tinyint(1) default '0',
				  `email` varchar(255) collate utf8_unicode_ci NOT NULL,
				  `image_id` int(11) default NULL,
				  `telephone_ccode` int(11) default NULL,
				  `mobile_phone_ccode` int(11) default NULL,
				  PRIMARY KEY  (`id`),
				  UNIQUE KEY `email` (`email`),
				  KEY `image_id` (`image_id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>
				
			<!---<cfquery datasource="#client_datasource#">
				INSERT INTO `#new_client_abb#_users` (`id`, `name`, `telephone`, `address`, `password`, `space_used`, `number_of_connections`, `connected`, `session_id`, `creation_date`, `internal_user`, `root_folder_id`, `family_name`, `sms_allowed`, `mobile_phone`, `space_downloaded`, `validated`, `email`, `image_id`, `telephone_ccode`, `mobile_phone_ccode`) VALUES
				(1, 'Support', NULL, NULL, '6f2a7325a9966a6a135e0bf5e2126430', 0, 3, 1, '1a3024245e9921e08a2e746c3a35221443c5', '#current_date#', NULL, 1, NULL, 0, NULL, 0, 0, 'support@era7.com', NULL, NULL, NULL);
			</cfquery>--->	
				
			<cfquery datasource="#client_datasource#">	
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_user_images` (
				  `id` int(11) NOT NULL,
				  `image_src` varchar(200) collate utf8_unicode_ci NOT NULL,
				  `image_size` int(11) NOT NULL,
				  PRIMARY KEY  (`id`),
				  UNIQUE KEY `image_src` (`image_src`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>	
				
			<!---<cfquery datasource="#client_datasource#">
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_user_preferences` (
				  `user_id` int(11) NOT NULL,
				  `notify_new_message` tinyint(1) default '1',
				  `notify_new_file` tinyint(1) default '1',
				  `language` varchar(255) collate utf8_unicode_ci default NULL,
				  `notify_replace_file` tinyint(1) default '1',
				  `notify_new_area` tinyint(1) default '1',
				  PRIMARY KEY  (`user_id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>--->	
			
			
			<cfquery datasource="#client_datasource#">
				CREATE TABLE IF NOT EXISTS `#new_client_abb#_incidences` (
				  `id` int(11) NOT NULL auto_increment,
				  `title` varchar(255) collate utf8_unicode_ci NOT NULL,
				  `description` text collate utf8_unicode_ci NOT NULL,
				  `user_in_charge` int(11) NOT NULL,
				  `creation_date` datetime NOT NULL,
				  `type_id` int(11) NOT NULL,
				  `related_to` varchar(255) collate utf8_unicode_ci NOT NULL,
				  `status` varchar(100) collate utf8_unicode_ci NOT NULL,
				  `resolution_date` datetime default NULL,
				  `resolution_description` text collate utf8_unicode_ci,
				  PRIMARY KEY  (`id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>
			
			
			<!---CREATE TABLE IF NOT EXISTS `#new_client_abb#_incidences` (
			  `id` int(11) NOT NULL auto_increment,
			  `title` varchar(255) collate utf8_unicode_ci NOT NULL,
			  `description` text collate utf8_unicode_ci NOT NULL,
			  `user_in_charge` int(11) NOT NULL,
			  `creation_date` datetime NOT NULL,
			  `type_id` int(11) NOT NULL,
			  `related_to` varchar(255) collate utf8_unicode_ci NOT NULL,
			  `status` varchar(100) collate utf8_unicode_ci NOT NULL,
			  `resolution_date` datetime default NULL,
			  `resolution_description` text collate utf8_unicode_ci,
			  PRIMARY KEY  (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;--->
			
				
			<!---<cfquery datasource="#client_datasource#">	
				INSERT INTO `#new_client_abb#_user_preferences` (`user_id`, `notify_new_message`, `notify_new_file`, `language`, `notify_replace_file`) VALUES
				(1, 1, 1, 'es', 1);
			</cfquery>--->
			
			<!---Aquí hay que llamar a un método que ponga como sesion actual la del cliente recien creado,
			para que las siguientes peticiones afecten a ese cliente. Lo que habría que hacer en ese método sería:
			SESSION.client_abb = #new_client_abb#
			Estaría bien que al logearse con un usuario para entrar en esta área de crear clientes,
			no se definiera un #client_abb# o algo parecido, y que solo se definiera para hacer determinadas
			cosas sobre un cliente.--->
			
			
			<!---create AdministratorUser--->
			<!---<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="createRequest" returnvariable="createUserRequest">
				<cfinvokeargument name="request_parameters" value="#xmlRequest.request.parameters.user#">
			</cfinvoke>--->
			
			<!---Esto es provisional--->
			<cfset current_client_abb = SESSION.client_abb>
			<cfset SESSION.client_abb = "#new_client_abb#">
			
			<cfinvoke component="UserManager" method="createUser">
				<cfinvokeargument name="request" value="#xmlRequest#">
			</cfinvoke>
			
			<!---assign User To Root Area--->
			<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="createRequest" returnvariable="assignUserToAreaRequest">
				<cfinvokeargument name="request_parameters" value='<user id="1"/><area id="1"/>'>
			</cfinvoke>
			
			<cfinvoke component="UserManager" method="assignUserToArea">
				<cfinvokeargument name="request" value="#assignUserToAreaRequest#">
			</cfinvoke>
			
			<!---Esto es provisional--->
			<cfset SESSION.client_abb = current_client_abb>
			
			
			<!--- --------------------------------- FOREIGN KEYS -------------------------------- --->
				
			<cfquery datasource="#client_datasource#">	
				ALTER TABLE `#new_client_abb#_areas`
				  ADD CONSTRAINT `#new_client_abb#_areas_ibfk_11` FOREIGN KEY (`image_id`) REFERENCES `#new_client_abb#_areas_images` (`id`),
				  ADD CONSTRAINT `#new_client_abb#_areas_ibfk_10` FOREIGN KEY (`user_in_charge`) REFERENCES `#new_client_abb#_users` (`id`),
				  ADD CONSTRAINT `#new_client_abb#_areas_ibfk_9` FOREIGN KEY (`parent_id`) REFERENCES `#new_client_abb#_areas` (`id`);
			</cfquery>
			
			<cfquery datasource="#client_datasource#">				
				ALTER TABLE `#new_client_abb#_areas_administrators`
				  ADD CONSTRAINT `#new_client_abb#_areas_administrators_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE CASCADE,
				  ADD CONSTRAINT `#new_client_abb#_areas_administrators_ibfk_3` FOREIGN KEY (`area_id`) REFERENCES `#new_client_abb#_areas` (`id`) ON DELETE CASCADE;
			</cfquery>	
				
			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_areas_files`
				  ADD CONSTRAINT `#new_client_abb#_areas_files_ibfk_1` FOREIGN KEY (`area_id`) REFERENCES `#new_client_abb#_areas` (`id`) ON DELETE CASCADE,
				  ADD CONSTRAINT `#new_client_abb#_areas_files_ibfk_2` FOREIGN KEY (`file_id`) REFERENCES `#new_client_abb#_files` (`id`) ON DELETE CASCADE;
			</cfquery>
				
			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_areas_users`
				  ADD CONSTRAINT `#new_client_abb#_areas_users_ibfk_2` FOREIGN KEY (`area_id`) REFERENCES `#new_client_abb#_areas` (`id`) ON DELETE CASCADE,
				  ADD CONSTRAINT `#new_client_abb#_areas_users_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE CASCADE;
			</cfquery>	
				
			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_contacts`
				  ADD CONSTRAINT `#new_client_abb#_contacts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE CASCADE;
			</cfquery>
			
			
			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_files`
				  ADD CONSTRAINT `#new_client_abb#_files_ibfk_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#new_client_abb#_users` (`id`);
			</cfquery>
			
			
			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_folders`
				  ADD CONSTRAINT `#new_client_abb#_folders_ibfk_8` FOREIGN KEY (`parent_id`) REFERENCES `#new_client_abb#_folders` (`id`),
				  ADD CONSTRAINT `#new_client_abb#_folders_ibfk_7` FOREIGN KEY (`user_in_charge`) REFERENCES `#new_client_abb#_users` (`id`);
			</cfquery>
				
			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_folders_files`
				  ADD CONSTRAINT `#new_client_abb#_folders_files_ibfk_1` FOREIGN KEY (`folder_id`) REFERENCES `#new_client_abb#_folders` (`id`),
				  ADD CONSTRAINT `#new_client_abb#_folders_files_ibfk_2` FOREIGN KEY (`file_id`) REFERENCES `#new_client_abb#_files` (`id`) ON DELETE CASCADE;
			</cfquery>
				
			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_messages`
				  ADD CONSTRAINT `#new_client_abb#_messages_ibfk_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#new_client_abb#_users` (`id`),
				  ADD CONSTRAINT `#new_client_abb#_messages_ibfk_2` FOREIGN KEY (`attached_file_id`) REFERENCES `#new_client_abb#_files` (`id`),
				  ADD CONSTRAINT `#new_client_abb#_messages_ibfk_3` FOREIGN KEY (`area_id`) REFERENCES `#new_client_abb#_areas` (`id`);
			</cfquery>
				
			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_sms`
				  ADD CONSTRAINT `#new_client_abb#_sms_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE CASCADE;
			</cfquery>
				
			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_users`
				  ADD CONSTRAINT `#new_client_abb#_users_ibfk_1` FOREIGN KEY (`image_id`) REFERENCES `#new_client_abb#_user_images` (`id`);
			</cfquery>
				
			<!---<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_user_preferences`
				  ADD CONSTRAINT `#new_client_abb#_user_preferences_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE CASCADE;
			</cfquery>--->
			
			<cfquery name="endTransaction" datasource="#client_dsn#">
				COMMIT;
			</cfquery>
			
			
			<!---createClientFolders--->
			<cfinvoke component="ClientManager" method="createClientFolders">
				<cfinvokeargument name="client_abb" value="#new_client_abb#">
			</cfinvoke>	
			
			
			<cfset xmlResponseContent = arguments.request>
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfquery name="endTransaction" datasource="#client_dsn#">
					ROLLBACK;
				</cfquery>
				
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ------------------------------ createClientFolders ----------------------------- --->
	
	<cffunction name="createClientFolders" returntype="string" access="public">
		<cfargument name="client_abb" type="string" required="yes">
		
		<cfset var method = "createClientFolders">
		
		<cfset var dirDelim = "/">
		<cfset var modePer = 777>
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
				<!---<cfset APPLICATION.filesPath = "/home/administrador/doplanning">--->
			
				<cfif server.OS.Name contains "Windows">
					<cfset dirDelim = "\">
				</cfif>
			
				<cfset arrayDir = arrayNew(1)>
				
				<cfset arrayAppend(arrayDir,"#arguments.client_abb#")>
				<cfset arrayAppend(arrayDir,"#arguments.client_abb##dirDelim#files")>
				<cfset arrayAppend(arrayDir,"#arguments.client_abb##dirDelim#areas_images")>
				<cfset arrayAppend(arrayDir,"#arguments.client_abb##dirDelim#users_images")>
				
				<cfloop index="current_directory" array="#arrayDir#">
					
					<cfset full_current_directory = "#APPLICATION.filesPath##dirDelim##current_directory#">
					<cfif NOT directoryExists(full_current_directory)>
						<cfdirectory action="create" directory="#full_current_directory#" mode="#modePer#">
					<cfelse>
						<cfset error_code = 305><!---Client directory already exists--->
				
						<cfthrow errorcode="#error_code#">
					</cfif>
					
				</cfloop>
			
	
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>
		</cftry>
		
	</cffunction>
	
</cfcomponent>