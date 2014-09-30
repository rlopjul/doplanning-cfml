<!--- Copyright Era7 Information Technologies 2007-2014 --->

<cfcomponent output="false">

	<cfset component = "AntiVirusManager">

	<cffunction name="checkFile" access="public" returntype="struct">
		<cfargument name="file_id" type="numeric" required="true"/>
		<cfargument name="fileTypeId" type="numeric" required="true"/>
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">

		<cfset var method = "checkFile">

		<cfset var destination = "">

		<cfset var response = structNew()>

		<cftry>
			
			<cfset var client_dsn = APPLICATION.identifier&"_"&arguments.client_abb>

			<!--- getFile --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
				<cfif arguments.fileTypeId IS NOT 1>
					<cfinvokeargument name="with_lock" value="true">
				</cfif>
				<cfinvokeargument name="parse_dates" value="false">		

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileQuery.recordCount GT 0>

				<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

				<cfset destination = "#APPLICATION.filesPath#/#arguments.client_abb#/">
				<cfset destination = destination&"#fileTypeDirectory#/">

				<cfinvoke component="AntiVirusManager" method="checkForVirus" returnvariable="response">
					<cfinvokeargument name="path" value="#destination#">
					<cfinvokeargument name="filename" value="#fileQuery.physical_name#">
				</cfinvoke>

				<cfset anti_virus_check_message = trim(listlast(response.message, ":"))>

				<cfquery name="updateFileQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_#fileTypeTable#
					SET anti_virus_check = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
					anti_virus_check_result = <cfqueryparam value="#anti_virus_check_message#" cfsqltype="cf_sql_varchar">
					<!---<cfif response.result IS false>
					, status = <cfqueryparam value="virus" cfsqltype="cf_sql_varchar">
					</cfif>--->
					WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfif response.result IS false>
					
					<!--- saveVirusLog --->
					<cfinvoke component="AntiVirusManager" method="saveVirusLog">
						<cfinvokeargument name="user_id" value="#arguments.user_id#">
						<cfinvokeargument name="file_id" value="#arguments.file_id#">
						<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
						<cfinvokeargument name="file_name" value="#fileQuery.file_name#">
						<cfinvokeargument name="anti_virus_result" value="#response.message#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				</cfif>

				<cfset response.message = anti_virus_check_message>

				
			<cfelse>

				<cfset response = {result=false, message="Archivo no encontrado al analizarlo en busca de virus"}>

			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">						
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- checkForVirus --->

	<cffunction name="checkForVirus" access="public" returntype="struct" hint="check a file for a virus">
		<cfargument name="path" type="string" required="true" />
		<cfargument name="filename" type="string" required="true" />
		<cfargument name="timeout" type="numeric" required="false" default="55">
		<cfargument name="saveVirusLog" type="boolean" required="false" default="false">

		<cfset var method = "checkForVirus">

		<cfset var response = structNew()>
		<cfset var message = "">

		<cfset var result = "">
		<cfset var clamavOptions = "--infected --no-summary">
		<cfset var filePath = arguments.path&arguments.filename>
		<cfset var fileCheck = '#clamavOptions# "#filePath#"'><!---Importante: que la ruta del archivo vaya entre comillas por si el nombre del archivo (que puede no ser el nombre definitivo) incluye espacios--->

		<cfset var command = "clamdscan"><!--- clamscan / clamdscan --->
		<!--- 
		-clamscan: no requiere ningún proceso en ejecución para analizar un archivo, cada vez que se ejecuta este proceso se carga la base de datos del antivirus y se realiza el análisis. En analizar un archivo muy pequeño no tarda menos de 25 segundos.
		-clamdscan: requiere cland iniciado para poder funcionar. Tarda mucho menos tiempo en realizar un análisis de archivo que clamscan: el tiempo que tarda en analizar varía dependiendo del archivo y la carga del servidor, no suele tardar más de 1 segundo pero puede llegar a tardar 10 segundos o más. Se está ejecutando siempre por lo que consume recursos de forma constante, unos 300 megas de RAM.
		--->

		<cfexecute name="#command#" arguments="#fileCheck#" timeout="#arguments.timeout#" variable="result" />

		<cfset message = trim(result) />

		<cfif len(message) GT 2>
			<!---<cfset res = "File "<i>#uploadFile#</i>": #trim(listlast(result, ":"))#." />--->
			<cfset response = {result=false, message=message}>
		<cfelse>
			<!---<cfset res = "File "<i>#uploadFile#</i>": CLEAN." />--->
			<cfset response = {result=true, message=message}>
		</cfif>

		<cfreturn response>
	</cffunction>


	<!--- saveVirusLog --->
	<cffunction name="saveVirusLog" access="public" returntype="void">
		<cfargument name="user_id" type="numeric" required="true"/>
		<cfargument name="file_id" type="numeric" required="false"/>
		<cfargument name="fileTypeId" type="numeric" required="false"/>
		<cfargument name="file_name" type="string" required="false"/>
		<cfargument name="anti_virus_result" type="string" required="true"/>

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

			<cfquery name="saveVirusLog" datasource="#client_dsn#">	
				INSERT INTO #client_abb#_virus_logs 
				SET user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer"> ,
				anti_virus_result = <cfqueryparam value="#arguments.anti_virus_result#" cfsqltype="cf_sql_varchar">
				<cfif isDefined("arguments.file_id")>
					, file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif isDefined("arguments.fileTypeId")>
					, file_type_id = <cfqueryparam value="#arguments.fileTypeId#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif isDefined("arguments.file_name")>
					, file_name = <cfqueryparam value="#arguments.file_name#" cfsqltype="cf_sql_varchar">
				</cfif>
				;
			</cfquery>

	</cffunction>


</cfcomponent>