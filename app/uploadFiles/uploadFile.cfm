<cfprocessingdirective suppresswhitespace="yes">
<cfsilent><!---Copyright Era7 Information Technologies 2007-2009

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 06-07-2009
	
--->
<cftry>	
	<cfset component = "uploadFile">
	<cfset method = "uploadFile">
	
	<!---checkParameters--->
	<cfif NOT isDefined("FORM.user_id") OR NOT isDefined("FORM.client_abb") OR NOT isDefined("FORM.language") OR NOT isDefined("FORM.session_id") OR NOT isDefined("FORM.type") OR NOT isDefined("FORM.file")>
		<cfset error_code = 610>
	
		<cfthrow errorcode="#error_code#">
	</cfif>
	
	<cfset user_id = FORM.user_id>
	<cfset client_abb = FORM.client_abb>
	<cfset user_language = FORM.language>
	<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>

	<cfquery name="getSessionidQuery" datasource="#client_dsn#">
		SELECT session_id 
		FROM #client_abb#_users
		WHERE id=<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;		 
	</cfquery>
	
		
	<cfif getSessionidQuery.recordCount GT 0 AND getSessionidQuery.session_id EQ FORM.session_id>
		
		<cfset type = FORM.type>
		
		<cfxml variable="xmlFile">
			<cfoutput>
			#FORM.file#
			</cfoutput>
		</cfxml>		
		
		<cfswitch expression="#type#"><!---TIPOS DE SUBIDAS DE ARCHIVOS--->
		
			<cfcase value="message_file,item_file_html,item_image_html"><!---Archivo de elemento de área ó Imagen de elemento de área (para mensajes, entradas, noticias, eventos)--->
				
				<cfif type EQ "message_file">
					<cfset itemTypeId = 1>
				<cfelse>
					<cfset itemTypeId = FORM.itemTypeId>
				</cfif>
				
				<cfinclude template="#APPLICATION.componentsPath#/includes/areaItemTypeSwitch.cfm">
				
				<cfxml variable="xmlItem">
					<cfoutput>
					#FORM[itemTypeName]#
					</cfoutput>
				</cfxml>
				
			</cfcase>

			
			<cfcase value="area_image">
				
				<cfxml variable="xmlArea">
					<cfoutput>
					#FORM.area#
					</cfoutput>
				</cfxml>
				
			</cfcase>

		
		</cfswitch>
		
		<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemFile" method="uploadItemFile" returnvariable="objectFile">
			<cfinvokeargument name="type" value="#type#">
			<cfinvokeargument name="user_id" value="#user_id#">
			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="user_language" value="#user_language#">
			<!---<cfinvokeargument name="client_dsn" value="#client_dsn#">--->
			<cfinvokeargument name="xmlFile" value="#xmlFile#">
			<cfif type EQ "item_image_html">
				<cfinvokeargument name="Filedata" value="#FORM.imagedata#">
			<cfelse>
				<cfinvokeargument name="Filedata" value="#FORM.Filedata#">
			</cfif>
			<!---<cfinvokeargument name="FORM" value="#FORM#">--->
			<cfif isDefined("xmlItem") AND isDefined("itemTypeId")>
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
				<cfinvokeargument name="xmlItem" value="#xmlItem#">
			</cfif>
			<cfif isDefined("xmlArea")>
				<cfinvokeargument name="xmlArea" value="#xmlArea#">
			</cfif>
		</cfinvoke>		
		
		<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="xmlFile" returnvariable="xmlResponseContent">
				<cfinvokeargument name="objectFile" value="#objectFile#">
		</cfinvoke>
		
		<cfinclude template="#APPLICATION.componentsPath#/includes/functionEndNoLog.cfm">
		
	
	<cfelse><!---Session finished or incorrect--->
			
		<cfset error_code = 102>
		
		<cfthrow errorcode="#error_code#">
		
	</cfif>	
	
	<cfcatch>
		<cfset xmlResponseContent = "">
		<cfinclude template="#APPLICATION.componentsPath#/includes/errorHandler.cfm">
	</cfcatch>
	
</cftry></cfsilent><cfoutput>#xmlResponse#</cfoutput></cfprocessingdirective>