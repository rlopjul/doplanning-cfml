<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 04-03-2009
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 30-11-2009
	
--->

<cfcomponent output="false">

	<cfset component = "SearchManager">	
	
	<cfset date_format = "%d-%m-%Y"><!---%H:%i:%s---><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset datetime_format = "%d-%m-%Y %H:%i:%s">
	
	<!----------------------------------------- generateSearchText -------------------------------------------------->
	
	<cffunction name="generateSearchText" access="public" output="false" returntype="string">
		<cfargument name="text" type="string" required="yes">
		
		<cfset var method = "generateSearchText">
		
		<cfset var text_re = "">
		
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
		<!---<cfset text_search = replaceList(lCase(text), "a,e,i,o,u", "[aàáäåãæâ],[eèéêë],[iìíîï],[oöôõðòóø],[uüûùú]"))>--->
		
		<cfset text_re = Trim(arguments.text)><!---Remove white space from the beginning and the end--->	
		<cfset text_re = "(#text_re#">
		<!---<cfset text_re = ReplaceNoCase(text_re," ","|","ALL")>--->
		<cfset text_re = ReplaceNoCase(text_re," ",".*","ALL")><!---* --> El caracter que le precede debe aparecer cero, una o más veces--->
		
		<!---<cfset text_re = REReplaceNoCase(text_re,"[aàáäåãæâ]","[aàáäåãæâ]+", "ALL")>--->
		<cfset text_re = REReplaceNoCase(text_re,"[aàáäâ]","[aàáäâ]+", "ALL")>
		<cfset text_re = REReplaceNoCase(text_re,"[eèéêë]","[eèéêë]+", "ALL")>
		<cfset text_re = REReplaceNoCase(text_re,"[iìíîï]","[iìíîï]+", "ALL")>
		<!---<cfset text_re = REReplaceNoCase(text_re,"[oöôõðòóø]","[oöôõðòóø]+", "ALL")>--->
		<cfset text_re = REReplaceNoCase(text_re,"[oöôòó]","[oöôòó]+", "ALL")>
		<cfset text_re = REReplaceNoCase(text_re,"[uüûùú]","[uüûùú]+", "ALL")>
	
		<cfset last_char = Right(text_re,1)>
		<cfif last_char EQ "+">
			<cfset text_len = len(text_re)>
			<cfset text_re = Left(text_re,text_len-1)>		
		</cfif>
		
		<cfset text_re = "#text_re#)">
		
		<cfreturn text_re>
				
	</cffunction>
	
	
	<!--- ----------------------- searchFiles -------------------------------- --->
	
	<!---request: 
	<request>
		<search page="" items_page="">
			<file></file>
		</search>
	</request>
	--->
	
	<!---response:
	<response status="ok/error" method="searchFiles">
		<result>
			<search total="" items_pages="" page="" pages="">
				<files total="" page="" pages="">
					<file />
				</files>
			</search>	
		</result>
	</response>
	--->
	
	<cffunction name="searchFiles" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "searchFiles">
		
		<cfset var xmlResponseContent = "">
		
		<cfset var is_root_user = false>
		
		<cfset var name = "">
		<cfset var file_name = "">
		<cfset var file_type = "">
		<cfset var description = "">
		<cfset var uploading_date_from = "">
		<cfset var uploading_date_to = "">
		<cfset var replacement_date_from = "">
		<cfset var replacement_date_to = "">
		<cfset var association_date_from = "">
		<cfset var association_date_to = "">
		<cfset var user_in_charge = "">	
				
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinclude template="includes/searchFunctionStart.cfm">
			
			<cfxml variable="xmlFile">
				<cfoutput>
				#xmlRequest.request.parameters.search.file#
				</cfoutput>
			</cfxml>
			
			<cfif isDefined("xmlFile.file.name")>
				<cfset name = xmlFile.file.name.xmlText>
				<cfinvoke component="SearchManager" method="generateSearchText" returnvariable="name_re">
					<cfinvokeargument name="text" value="#name#">
				</cfinvoke>
			</cfif>
			<cfif isDefined("xmlFile.file.file_name")>
				<cfset file_name = xmlFile.file.file_name.xmlText>
				<cfinvoke component="SearchManager" method="generateSearchText" returnvariable="file_name_re">
					<cfinvokeargument name="text" value="#file_name#">
				</cfinvoke>
			</cfif>
			<cfif isDefined("xmlFile.file.description")>
				<cfset description = xmlFile.file.description.xmlText>
				<cfinvoke component="SearchManager" method="generateSearchText" returnvariable="description_re">
					<cfinvokeargument name="text" value="#description#">
				</cfinvoke>
			</cfif>
			
			<cfif isDefined("xmlFile.file.uploading_date.xmlAttributes.from")>
				<cfset uploading_date_from = xmlFile.file.uploading_date.xmlAttributes.from>
			</cfif>
			<cfif isDefined("xmlFile.file.uploading_date.xmlAttributes.to")>
				<cfset uploading_date_to = xmlFile.file.uploading_date.xmlAttributes.to>
			</cfif>
			
			<cfif isDefined("xmlFile.file.replacement_date.xmlAttributes.from")>
				<cfset replacement_date_from = xmlFile.file.replacement_date.xmlAttributes.from>
			</cfif>
			<cfif isDefined("xmlFile.file.replacement_date.xmlAttributes.to")>
				<cfset replacement_date_to = xmlFile.file.replacement_date.xmlAttributes.to>
			</cfif>
			
			<cfif isDefined("xmlFile.file.association_date.xmlAttributes.from")>
				<cfset association_date_from = xmlFile.file.association_date.xmlAttributes.from>
			</cfif>
			<cfif isDefined("xmlFile.file.association_date.xmlAttributes.to")>
				<cfset association_date_to = xmlFile.file.association_date.xmlAttributes.to>
			</cfif>
			
			<cfif isDefined("xmlFile.file.xmlAttributes.user_in_charge")>
				<cfset user_in_charge = xmlFile.file.xmlAttributes.user_in_charge>
			</cfif>
			
			<cfif isDefined("xmlFile.file.xmlAttributes.file_type")>
				<cfset file_type = xmlFile.file.xmlAttributes.file_type>
				<cfinvoke component="SearchManager" method="generateSearchText" returnvariable="file_type_re">
					<cfinvokeargument name="text" value="#file_type#">
				</cfinvoke>		
			</cfif>
					
			
			<cfquery datasource="#client_dsn#" name="filesQuery">
				SELECT SQL_CALC_FOUND_ROWS files.id, physical_name, files.user_in_charge, file_size, file_type, association_date, replacement_date, files.name, file_name, files.description, family_name, a.area_id, users.name AS user_name, IF(replacement_date IS NULL,association_date,replacement_date) AS last_version_date
				FROM #client_abb#_areas_files AS a
				INNER JOIN #client_abb#_files AS files ON a.file_id = files.id
				INNER JOIN #client_abb#_users AS users ON files.user_in_charge = users.id
				INNER JOIN #client_abb#_areas AS areas ON a.area_id = areas.id
				WHERE files.status = 'ok'
				<cfif is_root_user IS false>
				AND a.area_id IN (#allUserAreasList#)
				</cfif>
				<cfif len(name)>
				AND files.name REGEXP <cfqueryparam value="#name_re#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif len(file_name)>
				AND files.file_name REGEXP <cfqueryparam value="#file_name_re#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif len(description)>
				AND files.description REGEXP <cfqueryparam value="#description_re#" cfsqltype="cf_sql_varchar">
				</cfif>
								
				<cfif len(uploading_date_from) GT 0 AND isDate(uploading_date_from)>
				AND files.uploading_date >= STR_TO_DATE(<cfqueryparam value="#uploading_date_from#" cfsqltype="cf_sql_varchar">, '#date_format#')
				</cfif>
				<cfif len(uploading_date_to) GT 0 AND isDate(uploading_date_to)>
				AND files.uploading_date <= STR_TO_DATE(<cfqueryparam value="#uploading_date_to# 23:59:59" cfsqltype="cf_sql_varchar">, '#datetime_format#')
				</cfif>
				
				<cfif len(replacement_date_from) GT 0 AND isDate(replacement_date_from)>
				AND files.replacement_date >= STR_TO_DATE(<cfqueryparam value="#replacement_date_from#" cfsqltype="cf_sql_varchar">, '#date_format#')
				</cfif>
				<cfif len(replacement_date_to) GT 0 AND isDate(replacement_date_to)>
				AND files.replacement_date <= STR_TO_DATE(<cfqueryparam value="#replacement_date_to# 23:59:59" cfsqltype="cf_sql_varchar">, '#datetime_format#')
				</cfif>
				
				<cfif len(association_date_from) GT 0 AND isDate(association_date_from)>
				AND a.association_date >= STR_TO_DATE(<cfqueryparam value="#association_date_from#" cfsqltype="cf_sql_varchar">, '#date_format#')
				</cfif>
				<cfif len(association_date_to) GT 0 AND isDate(association_date_to)>
				AND a.association_date <= STR_TO_DATE(<cfqueryparam value="#association_date_to# 23:59:59" cfsqltype="cf_sql_varchar">, '#datetime_format#')
				</cfif>
				
				<cfif len(user_in_charge) GT 0 AND isValid("integer", user_in_charge)>
				AND files.user_in_charge = <cfqueryparam value="#user_in_charge#" cfsqltype="cf_sql_integer">
				</cfif>		
				
				<cfif len(file_type) GT 0>
				AND files.file_type REGEXP <cfqueryparam value="#file_type_re#" cfsqltype="cf_sql_varchar">
				</cfif>		
				ORDER BY last_version_date DESC
				LIMIT #init_item#, #items_page#;
			</cfquery>
			<!---
			REGEXP '#text#'
			REGEXP busca si el patrón suministrado se encuentra en cualquier parte de la cadena en que se busca 
			--->
			
			<cfquery datasource="#client_dsn#" name="getCount">
				SELECT FOUND_ROWS() AS count;
			</cfquery>
			
			<cfset num_items = getCount.count>
			
			<cfset num_pages = ceiling(num_items/items_page)>
			
			<cfset xmlResult = '<search total="#num_items#" pages="#num_pages#" items_pages="#items_page#" page="#current_page#"><files total="#num_items#" pages="#num_pages#" page="#current_page#">'>
			
			<cfloop query="filesQuery">
				<cfinvoke component="FileManager" method="objectFile" returnvariable="xmlFile">
					<cfinvokeargument name="id" value="#filesQuery.id#">
					<cfinvokeargument name="physical_name" value="#filesQuery.physical_name#">		
					<cfinvokeargument name="user_in_charge" value="#filesQuery.user_in_charge#">		
					<cfinvokeargument name="file_size" value="#filesQuery.file_size#">
					<cfinvokeargument name="file_type" value="#filesQuery.file_type#">
					<cfinvokeargument name="association_date" value="#filesQuery.association_date#">
					<cfinvokeargument name="replacement_date" value="#filesQuery.replacement_date#">
					<cfinvokeargument name="name" value="#filesQuery.name#">
					<cfinvokeargument name="file_name" value="#filesQuery.file_name#">
					<cfinvokeargument name="description" value="#filesQuery.description#">
					<cfinvokeargument name="user_full_name" value="#filesQuery.family_name# #filesQuery.user_name#">
					<cfinvokeargument name="area_id" value="#filesQuery.area_id#">
					
					<cfinvokeargument name="return_type" value="xml">
				</cfinvoke>
				
				<cfset xmlResult = xmlResult&xmlFile>
			</cfloop>			
			
			<cfset xmlResponseContent = xmlResult&"</files></search>">
			
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- searchMessages -------------------------------- --->
	
	<!---request: 
	<request>
		<search page="" items_page="">
			<message attached_file="true/false"><![CDATA[]]></message>
		</search>
	</request>
	--->
	
	<!---response:
	<response status="ok/error" method="searchMessages">
		<result>
			<search total="" items_pages="" page="" pages="">
				<messages total="" page="" pages="">
					<message />
				</messages>
			</search>	
		</result>
	</response>
	--->
	
	<cffunction name="searchMessages" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "searchMessages">
		
		<cfset var xmlResponseContent = "">	
		
		<cfset var is_root_user = false>
		
		<cfset var title = "">
		<cfset var description = "">
		<cfset var date_from = "">
		<cfset var date_to = "">
		<cfset var user_in_charge = "">
		<cfset var attached_file = "">
		
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinclude template="includes/searchFunctionStart.cfm">
		
			<cfxml variable="xmlMessage">
				<cfoutput>
				#xmlRequest.request.parameters.search.message#
				</cfoutput>
			</cfxml>
		
			<cfif isDefined("xmlMessage.message.title")>
				<cfset title = xmlMessage.message.title.xmlText>
				<cfinvoke component="#APPLICATION.componentsPath#/SearchManager" method="generateSearchText" returnvariable="title_re">
					<cfinvokeargument name="text" value="#title#">
				</cfinvoke>
			</cfif>
			<cfif isDefined("xmlMessage.message.description")>
				<cfset description = xmlMessage.message.description.xmlText>
				<cfinvoke component="#APPLICATION.componentsPath#/SearchManager" method="generateSearchText" returnvariable="description_re">
					<cfinvokeargument name="text" value="#description#">
				</cfinvoke>
			</cfif>
			<cfif isDefined("xmlRequest.request.parameters.search.creation_date.xmlAttributes.from")>
				<cfset date_from = xmlRequest.request.parameters.search.creation_date.xmlAttributes.from>
			</cfif>
			<cfif isDefined("xmlRequest.request.parameters.search.creation_date.xmlAttributes.to")>
				<cfset date_to = xmlRequest.request.parameters.search.creation_date.xmlAttributes.to>
			</cfif>
			<cfif isDefined("xmlMessage.message.xmlAttributes.user_in_charge") AND isValid("integer",xmlMessage.message.xmlAttributes.user_in_charge)>
				<cfset user_in_charge = xmlMessage.message.xmlAttributes.user_in_charge>
			</cfif>
			<cfif isDefined("xmlMessage.message.xmlAttributes.attached_file")>
				<cfset attached_file = xmlMessage.message.xmlAttributes.attached_file>
			</cfif>
			
			<!---WHERE ((messages.parent_kind = 'area' AND messages.parent_id IN (#allUserAreasList#))
			OR (messages.parent_kind = 'message'))--->		
			<cfquery datasource="#client_dsn#" name="messagesQuery">
				SELECT SQL_CALC_FOUND_ROWS *, users.name AS user_name
				FROM #client_abb#_messages AS messages
				INNER JOIN #client_abb#_users AS users ON messages.user_in_charge = users.id
				WHERE messages.status = 'ok'
				<cfif is_root_user IS false>
				AND messages.area_id IN (#allUserAreasList#)
				</cfif>
				<cfif len(title) GT 0>
				AND messages.title REGEXP <cfqueryparam value="#title_re#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif len(description) GT 0>
				AND messages.description REGEXP <cfqueryparam value=">.*#description_re#.*<" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif len(date_from) GT 0 AND isDate(date_from)>
				AND messages.creation_date >= STR_TO_DATE(<cfqueryparam value="#date_from#" cfsqltype="cf_sql_varchar">, '#date_format#')
				</cfif>
				<cfif len(date_to) GT 0 AND isDate(date_to)>
				AND messages.creation_date <= STR_TO_DATE(<cfqueryparam value="#date_to# 23:59:59" cfsqltype="cf_sql_varchar">, '#datetime_format#')
				</cfif>
				<cfif len(user_in_charge) GT 0 AND isValid("integer", user_in_charge)>
				AND messages.user_in_charge = <cfqueryparam value="#user_in_charge#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif len(attached_file) GT 0>
					<cfif attached_file IS "true">
					AND messages.attached_file_id IS NOT NULL
					<cfelse>
					AND messages.attached_file_id IS NULL
					</cfif>
				</cfif>
				ORDER BY messages.creation_date DESC
				LIMIT #init_item#, #items_page#;
			</cfquery>
			<!--- STR_TO_DATE('01-01-2009 12:12:58', '%d-%m-%Y ' GET_FORMAT(TIME,'ISO'))--->
			<!---
			REGEXP busca si el patrón suministrado se encuentra en cualquier parte de la cadena en que se busca 
			IMPORTANTE: 
			% no funciona igual en REGEXP como en LIKE, ademas de que en muchos casos no es necesario ponerlo en REGEXP
			
			'<%>%#text#%<%>'
			(>)[\r\n\t]*([\w\s&;]+)[\r\n\t]*(<)
			</?\w+(\s*([a-zA-Z]+=”.+”)*)*\s*/?>
			
			</?\w+((\s+\w+(\s*=\s*(?:".*?"|'.*?'|[^'">\s]+))?)+\s*|\s*)/?>
			--->
			<!---AND messages.title LIKE <cfqueryparam value="%#text#%" cfsqltype="cf_sql_varchar">--->
			<cfquery datasource="#client_dsn#" name="getCount">
				SELECT FOUND_ROWS() AS count;
			</cfquery>
			
			<cfset num_items = getCount.count>
			
			<cfset num_pages = ceiling(num_items/items_page)>
			
			<cfset xmlResult = '<search total="#num_items#" pages="#num_pages#" items_pages="#items_page#" page="#current_page#"><messages total="#num_items#" pages="#num_pages#" page="#current_page#">'>
				
			<cfloop query="messagesQuery">
								
				<cfinvoke component="AreaItemManager" method="objectItem" returnvariable="xmlMessage">
					<cfinvokeargument name="id" value="#messagesQuery.id#">
					<cfinvokeargument name="itemTypeId" value="1">
					<cfinvokeargument name="title" value="#messagesQuery.title#">
					<cfinvokeargument name="user_in_charge" value="#messagesQuery.user_in_charge#">
					<cfinvokeargument name="creation_date" value="#messagesQuery.creation_date#">
					<cfinvokeargument name="attached_file_name" value="#messagesQuery.attached_file_name#">
					<cfinvokeargument name="user_full_name" value="#messagesQuery.family_name# #messagesQuery.user_name#">
									
					<cfinvokeargument name="description" value="#messagesQuery.description#">
					<cfinvokeargument name="area_id" value="#messagesQuery.area_id#">
					<!---<cfif format_content EQ "all">
						<cfinvokeargument name="attached_file_id" value="#areaMessagesQuery.attached_file_id#">
						<cfinvokeargument name="message_read" value="#areaMessagesQuery.message_read#">
						<cfinvokeargument name="area_name" value="#areaMessagesQuery.area_name#">
						<cfinvokeargument name="parent_id" value="#areaMessagesQuery.parent_id#">
						<cfinvokeargument name="parent_kind" value="#areaMessagesQuery.parent_kind#">
						<cfinvokeargument name="description" value="#areaMessagesQuery.description#">
					</cfif> 
					<cfif listFormat NEQ "true">
						<cfinvokeargument name="sub_messages" value="#resultSubMessages#">
					</cfif>--->
					
					<cfinvokeargument name="tree_mode" value="true"><!---Esto hace que se pasen los elementos del mensaje como atributos--->
					<cfinvokeargument name="return_type" value="xml">
				</cfinvoke>
				
				<cfset xmlResult = xmlResult&xmlMessage>
					
				
			</cfloop>			
			
			<cfset xmlResponseContent = xmlResult&"</messages></search>">
			
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- searchUsers -------------------------------- --->
	
	<!---request: 
	<request>
		<search page="" items_page="">
			<user/>
		</search>
	</request>
	--->
	
	<!---response:
	<response status="ok/error" method="searchUsers">
		<result>
			<search total="" items_pages="" page="" pages="">
				<users total="" page="" pages="">
					<users />
				</users>	
			</search>
		</result>
	</response>
	--->
	
	<cffunction name="searchUsers" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "searchUsers">
		
		<cfset var xmlResponseContent = "">	
		
		<cfset var is_root_user = false>
		
		<cfset var family_name = "">
		<cfset var name = "">
		<cfset var email = "">
		<cfset var center_id = "">
		<cfset var category_id = "">
		<cfset var service_id = "">
		<cfset var service = "">
		<cfset var other_1 = "">
		<cfset var other_2 = "">
		
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinclude template="includes/searchFunctionStart.cfm">
			
			<cfxml variable="xmlUser">
				<cfoutput>
				#xmlRequest.request.parameters.search.user#
				</cfoutput>
			</cfxml>
			
			<cfif isDefined("xmlUser.user.family_name")>
				<cfset family_name = xmlUser.user.family_name.xmlText>
				<cfinvoke component="#APPLICATION.componentsPath#/SearchManager" method="generateSearchText" returnvariable="family_name_re">
					<cfinvokeargument name="text" value="#family_name#">
				</cfinvoke>
			</cfif>
			<cfif isDefined("xmlUser.user.name")>
				<cfset name = xmlUser.user.name.xmlText>
				<cfinvoke component="#APPLICATION.componentsPath#/SearchManager" method="generateSearchText" returnvariable="name_re">
					<cfinvokeargument name="text" value="#name#">
				</cfinvoke>
			</cfif>
			<cfif isDefined("xmlUser.user.xmlAttributes.email")>
				<cfset email = xmlUser.user.xmlAttributes.email>
				<cfinvoke component="#APPLICATION.componentsPath#/SearchManager" method="generateSearchText" returnvariable="email_re">
					<cfinvokeargument name="text" value="#email#">
				</cfinvoke>
			</cfif>
			
			<cfif isDefined("xmlUser.user.center.xmlAttributes.id")>
				<cfset center_id = xmlUser.user.center.xmlAttributes.id>
			</cfif>
			
			<cfif isDefined("xmlUser.user.category.xmlAttributes.id")>
				<cfset category_id = xmlUser.user.category.xmlAttributes.id>
			</cfif>
			
			<cfif isDefined("xmlUser.user.service.xmlAttributes.id")>
				<cfset service_id = xmlUser.user.service.xmlAttributes.id>
			</cfif>
			
			<cfif isDefined("xmlUser.user.service.xmlText")>
				<cfset service = xmlUser.user.service.xmlText>
				<cfinvoke component="#APPLICATION.componentsPath#/SearchManager" method="generateSearchText" returnvariable="service_re">
					<cfinvokeargument name="text" value="#service#">
				</cfinvoke>
			</cfif>
			
			<cfif isDefined("xmlUser.user.other_1.xmlText")>
				<cfset other_1 = xmlUser.user.other_1.xmlText>
				<cfinvoke component="#APPLICATION.componentsPath#/SearchManager" method="generateSearchText" returnvariable="other_1_re">
					<cfinvokeargument name="text" value="#other_1#">
				</cfinvoke>
			</cfif>
			
			<cfif isDefined("xmlUser.user.other_2.xmlText")>
				<cfset other_2 = xmlUser.user.other_2.xmlText>
				<cfinvoke component="#APPLICATION.componentsPath#/SearchManager" method="generateSearchText" returnvariable="other_2_re">
					<cfinvokeargument name="text" value="#other_2#">
				</cfinvoke>
			</cfif>
			
			<cfquery datasource="#client_dsn#" name="usersQuery">
				SELECT SQL_CALC_FOUND_ROWS users.id, users.email, users.telephone, users.family_name, users.mobile_phone, users.telephone_ccode, users.mobile_phone_ccode, users.name, a.area_id
				FROM #client_abb#_users AS users
				<cfif is_root_user OR SESSION.client_administrator EQ user_id><!---Is root user or an administrator user---><!---Esto hay que hacerlo así para mostrar los usuarios que no están en áreas--->
				LEFT JOIN #client_abb#_areas_users AS a ON a.user_id = users.id
				WHERE users.id != 0
				<cfelse>
				INNER JOIN #client_abb#_areas_users AS a ON a.user_id = users.id
				WHERE a.area_id IN (#allUserAreasList#)
				</cfif>
				<cfif len(name) GT 0>
				AND users.name REGEXP <cfqueryparam value="#name_re#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif len(family_name) GT 0>
				AND users.family_name REGEXP <cfqueryparam value="#family_name_re#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif len(email) GT 0>
				AND users.email REGEXP <cfqueryparam value="#email_re#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif len(center_id) GT 0>
				AND users.center_id = <cfqueryparam value="#center_id#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif len(category_id) GT 0>
				AND users.category_id = <cfqueryparam value="#category_id#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif len(service_id) GT 0>
				AND users.service_id = <cfqueryparam value="#service_id#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif len(service) GT 0>
				AND users.service REGEXP <cfqueryparam value="#service_re#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif len(other_1) GT 0>
				AND users.other_1 REGEXP <cfqueryparam value="#other_1_re#" cfsqltype="cf_sql_varchar">
				</cfif>
				<cfif len(other_2) GT 0>
				AND users.other_2 REGEXP <cfqueryparam value="#other_2_re#" cfsqltype="cf_sql_varchar">
				</cfif>				
				GROUP BY users.id
				ORDER BY users.name ASC
				LIMIT #init_item#, #items_page#;
			</cfquery>
			
			<cfquery datasource="#client_dsn#" name="getCount">
				SELECT FOUND_ROWS() AS count;
			</cfquery>
			
			<cfset num_items = getCount.count>
			
			<cfset num_pages = ceiling(num_items/items_page)>
			
			<cfset xmlResult = '<search total="#num_items#" pages="#num_pages#" items_pages="#items_page#" page="#current_page#"><users total="#num_items#" pages="#num_pages#" page="#current_page#">'>
			
			<cfloop query="usersQuery">
				<cfinvoke component="UserManager" method="objectUser" returnvariable="xmlUser">
						<cfinvokeargument name="id" value="#usersQuery.id#">
						<cfinvokeargument name="email" value="#usersQuery.email#">
						<cfinvokeargument name="telephone" value="#usersQuery.telephone#">
						<cfinvokeargument name="family_name" value="#usersQuery.family_name#">
						<cfinvokeargument name="name" value="#usersQuery.name#">
						<cfinvokeargument name="mobile_phone" value="#usersQuery.mobile_phone#">
						<cfinvokeargument name="telephone_ccode" value="#usersQuery.telephone_ccode#">
						<cfinvokeargument name="mobile_phone_ccode" value="#usersQuery.mobile_phone_ccode#">
						<cfinvokeargument name="area_id" value="#usersQuery.area_id#">
						
						<cfinvokeargument name="return_type" value="xml">
				</cfinvoke>
				
				<cfset xmlResult = xmlResult&xmlUser>
			</cfloop>			
			
			<cfset xmlResponseContent = xmlResult&"</users></search>">
			
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------- searchAreas -------------------------------- --->
	
	<!---No se busca en todas las áreas, solo en las que se tiene acceso---> 
	
	<!---request: 
	<request>
		<search page="" items_page="">
			<text><![CDATA[]]></text>
		</search>
	</request>
	--->
	
	<!---response:
	<response status="ok/error" method="searchAreas">
		<result>
			<search total="" items_pages="" page="" pages="">
				<areas total="" page="" pages="">
					<area />
				</areas>
			</search>	
		</result>
	</response>
	--->
	
	<cffunction name="searchAreas" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "searchAreas">
		
		<cfset var xmlResponseContent = "">	
		
		<cfset var text = "">
		<cfset var text_re = "">
		
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinclude template="includes/searchFunctionStart.cfm">
			
			<cfset text = xmlRequest.request.parameters.search.text.xmlText>
			
			<cfinvoke component="#APPLICATION.componentsPath#/SearchManager" method="generateSearchText" returnvariable="text_re">
				<cfinvokeargument name="text" value="#text#">
			</cfinvoke>
						
			<cfinvoke component="UserManager" method="isInternalUser" returnvariable="internal_user">
				<cfinvokeargument name="get_user_id" value="#user_id#"> 
			</cfinvoke>
			
			<cfif internal_user IS false>
				<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAllUserAreasList" returnvariable="allUserAreasList">
					<cfinvokeargument name="get_user_id" value="#user_id#">
				</cfinvoke>			
			</cfif>
			
			<cfquery datasource="#client_dsn#" name="areasQuery">
				SELECT SQL_CALC_FOUND_ROWS *
				FROM #client_abb#_areas AS areas
				WHERE (areas.name REGEXP <cfqueryparam value="#text_re#" cfsqltype="cf_sql_varchar">
				OR areas.description REGEXP <cfqueryparam value="#text_re#" cfsqltype="cf_sql_varchar">)
				<cfif internal_user IS false>
				AND areas.id IN (#allUserAreasList#)
				</cfif>
				ORDER BY areas.name ASC
				LIMIT #init_item#, #items_page#;
			</cfquery>
			
			<cfquery datasource="#client_dsn#" name="getCount">
				SELECT FOUND_ROWS() AS count;
			</cfquery>
			
			<cfset num_items = getCount.count>
			
			<cfset num_pages = ceiling(num_items/items_page)>
			
			<cfset xmlResult = '<areas total="#num_items#" pages="#num_pages#" page="#current_page#">'>
			
			<cfloop query="areasQuery">
				<cfset xmlArea='<area id="#areasQuery.id#" name="#xmlFormat(areasQuery.name)#" parent_id="#areasQuery.parent_id#" creation_date="#areasQuery.creation_date#" label="#xmlFormat(areasQuery.name)#" user_in_charge="#areasQuery.user_in_charge#" allowed="true" image_id="#image_id#" with_link="false"/>'>
				
				<cfset xmlResult = xmlResult&xmlArea>
			</cfloop>			
			
			<cfset xmlResponseContent = xmlResult&"</areas>">
			
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
		
</cfcomponent>