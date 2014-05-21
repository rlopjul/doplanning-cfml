<!---Copyright Era7 Information Technologies 2007-2012

	Date of file creation: 16-05-2012
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 15-11-2012
	
	15-11-2012 alucena: cambiado tamaño máximo de las imágenes
	24-06-2013 alucena: areaItemTypeSwitch.cfm cambiado de directorio
	
--->
<cfcomponent output="false">

	<cfset component = "AreaItemFile">	
	
	
	<!---uploadItemFile--->
	
	<cffunction name="uploadItemFile" access="public" returntype="struct">
		<cfargument name="type" type="string" required="yes">
		<cfargument name="user_id" type="string" required="yes">
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="user_language" type="string" required="yes">
		<!---<cfargument name="client_dsn" type="string" required="yes">--->
		<cfargument name="Filedata" type="string" required="yes">
		<!---<cfargument name="xmlFile" type="xml" required="yes">--->
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="file_physical_name" type="numeric" required="false">
		<cfargument name="itemTypeId" type="numeric" required="no">
		<!---<cfargument name="xmlItem" type="xml" required="no">
		<cfargument name="xmlArea" type="xml" required="no">--->
		<cfargument name="item_id" type="numeric" required="false"/>
		<cfargument name="area_id" type="numeric" required="false"/>
				
		<cfset var method = "uploadItemFile">		
		
		<cfset var client_dsn = APPLICATION.identifier&"_"&client_abb>
		
		
		<cfswitch expression="#type#"><!---TIPOS DE SUBIDAS DE ARCHIVOS--->
		
			
			<cfcase value="message_file,item_file_html,item_image_html"><!---Archivo de elemento de área ó Imagen de elemento de área (para entradas, noticias, eventos)--->
			
				<cfset files_table = "files">
				<cfset files_directory = "files">
				
				<cfif type EQ "item_image_html">
					<cfset required_width = 1100>
					<cfset required_height = 1000>
				</cfif>
				
				<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">
				
				<cfif NOT isDefined("arguments.item_id")>
					<cfset error_code = 610>
	
					<cfthrow errorcode="#error_code#">
				</cfif>
				
				<!---<cfset item_id = xmlItem[itemTypeName].xmlAttributes.id>--->
				
			</cfcase>
			
			
			<cfcase value="area_image">
				<cfset files_table = "areas_images">
				<cfset files_directory = "areas_images">
								
				<!---
				Ya no se requiere ningún tamaño concreto para las imágenes de las áreas,
				solo se limita a un tamaño máximo
				<cfset required_width = 468>
				<cfset required_height = 60>--->
				<cfset required_width = 2000>
				<cfset required_height = 2000>
				
				<!---<cfif NOT isDefined("arguments.xmlArea")>--->
				<cfif NOT isDefined("arguments.area_id")>
					<cfset error_code = 610>
	
					<cfthrow errorcode="#error_code#">
				</cfif>
				
				<!--- <cfset area_id = xmlArea.area.xmlAttributes.id> --->
				
			</cfcase>
			
			<!---<cfcase value="user_image">
				<cfset files_table = "users_images">
				<cfset files_directory = "users_images">
				
				<cfset required_width = 468>
				<cfset required_height = 60>
				
				<cfxml variable="xmlUser">
					<cfoutput>
					#FORM.user#
					</cfoutput>
				</cfxml>
				
				<cfset image_user_id = xmlUser.user.xmlAttributes.id>
								
			</cfcase>--->
		
		</cfswitch>
		
		<cfset var destination = '#APPLICATION.filesPath#/#client_abb#/#files_directory#/'>

		<!---<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="objectFile" returnvariable="objectFile">
			<cfinvokeargument name="xml" value="#xmlFile#">
			
			<cfinvokeargument name="return_type" value="object">
		</cfinvoke>--->
		
		<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="objectFile" returnvariable="objectFile">
			<cfinvokeargument name="id" value="#arguments.file_id#">
			<cfif isDefined("arguments.file_physical_name")>
				<cfinvokeargument name="physical_name" value="#arguments.file_physical_name#"/>
			</cfif>
			
			<cfinvokeargument name="return_type" value="object">
		</cfinvoke>

		<cfset objectFile.user_in_charge = user_id>
		
		<cfquery datasource="#client_dsn#" name="getFile">
			SELECT *
			FROM #client_abb#_#files_table#
			WHERE id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer"> 
			<cfif type NEQ "area_image">
			AND user_in_charge = <cfqueryparam value="#objectFile.user_in_charge#" cfsqltype="cf_sql_integer">
			</cfif>;
		</cfquery>
		
		<cfif getFile.recordCount IS 0><!---File passed to upload is incorrect--->
		
			<cfset error_code = 603>
	
			<cfthrow errorcode="#error_code#">
			
		<cfelseif getFile.status EQ 'canceled'>
		
			<cfset error_code = 611>
	
			<cfthrow errorcode="#error_code#">
			
		</cfif>
			
		<cfif type EQ "area_image">
		
			<!---AREA_IMAGE--->
			
			<cfquery name="selectAreaImageQuery" datasource="#client_dsn#">
				SELECT * 
				FROM #client_abb#_areas AS areas LEFT JOIN #client_abb#_areas_images AS images ON areas.image_id = images.id
				WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif selectAreaImageQuery.recordCount GT 0>
			
				<cfif isValid("integer", selectAreaImageQuery.image_id)><!---El area tiene imagen--->
				
					<cfquery name="updateSpaceUsed" datasource="#client_dsn#">
						UPDATE #client_abb#_areas
						SET space_used = space_used-#selectAreaImageQuery.file_size#
						WHERE id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<cfset objectFile.physical_name = selectAreaImageQuery.physical_name>
				
				<cfelse><!---El area no tiene imagen ya subida--->
					
					<cfset objectFile.physical_name = objectFile.id>
														
				</cfif>
			
			<cfelse><!---The area does not exist--->
			
				<cfset error_code = 301>
				
				<cfthrow errorcode="#error_code#">
			
			</cfif>	
			
		</cfif>
		
		<cftry>		
			
			<!---<cfset file_field = "Filedata">--->
			
			<cfif type EQ "item_image_html">
				<cffile action="upload" filefield="#arguments.Filedata#" destination="#destination#" nameconflict="overwrite" result="uploadedFile" accept="image/gif,image/jpeg,image/png,image/pjpeg"><!---image/pjpeg para IE8 que tiene un bug--->
			<cfelse>
				<cffile action="upload" filefield="#arguments.Filedata#" destination="#destination#" nameconflict="overwrite" result="uploadedFile">
			</cfif>
			
			<cfset temp_file="#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#">
			
			<cfset objectFile.file_name = uploadedFile.clientFileName&"."&uploadedFile.clientFileExt>
			<cfset objectFile.file_type = lCase("."&uploadedFile.clientFileExt)>
			
			<cfif type EQ "item_image_html" OR type EQ "area_image" OR type EQ "user_image">
				
				<!---<cfif objectFile.file_type EQ ".jpg">--->
				
					<cfif NOT FileExists("#destination##temp_file#")><!---The physical file does not exist--->
						<cfset error_code = 608>
		
						<cfthrow errorcode="#error_code#">
					</cfif>
					
					<cftry>
						
						<cfimage action="info" source="#destination##temp_file#" structname="image_info">

						<cfcatch>

							<!--- If it fails convert to RGB and Strip Information with ImageMagick --->
							<!--- REQUIRES ImageMagick installed on the server --->
							<cfexecute name="convert" arguments="#destination##temp_file# -strip -colorspace rgb -quality 100 #destination##temp_file#" timeout="30" variable="msg" />

							<cfimage action="info" source="#destination##temp_file#" structname="image_info">

						</cfcatch>
					</cftry>
					
					<cfif image_info.width GT required_width>
						<cfimage action="resize" width="#required_width#" source="#destination##temp_file#" destination="#destination##temp_file#" overwrite="yes" name="image_resized">
						
						<cfif image_resized.height GT required_height>
							
							<cfimage action="resize" height="#required_height#" source="#destination##temp_file#" destination="#destination##temp_file#" overwrite="yes" name="image_resized">
							
						</cfif>
					
					<cfelseif image_info.height GT required_height>
					
						<cfimage action="resize" height="#required_height#" source="#destination##temp_file#" destination="#destination##temp_file#" overwrite="yes" name="image_resized">
						
					</cfif>
					
				<!---</cfif>--->
				
			</cfif>
			
			<cffile action="rename" source="#destination##temp_file#" destination="#destination##objectFile.physical_name#">
						
			<cftransaction>
			
			<cfswitch expression="#type#">
				
				<!---message_file--->
				<cfcase value="message_file">
				
					<cfquery datasource="#client_dsn#" name="addFileToMessage">
						UPDATE #client_abb#_messages
						SET attached_file_id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">,
						attached_file_name = <cfqueryparam value="#objectFile.file_name#" cfsqltype="cf_sql_varchar">,
						status = 'uploaded'
						WHERE id = <cfqueryparam value="#item_id#" cfsqltype="cf_sql_integer">
					</cfquery>
					
					<!---set the status to ok--->
					<!---<cfquery datasource="#client_dsn#" name="updateFile">
						UPDATE #client_abb#_#files_table#
						SET status = 'ok'
						WHERE id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">;
					</cfquery>--->
					<cfquery datasource="#client_dsn#" name="updateFile">
						UPDATE #client_abb#_#files_table#
						SET status = 'uploaded'
						WHERE id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<cfquery name="updateSpaceUsed" datasource="#client_dsn#">
						UPDATE #client_abb#_users
						SET space_used = space_used+<cfqueryparam value="#uploadedFile.fileSize#" cfsqltype="cf_sql_integer">
						WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
				</cfcase>
				
				<!---message_file_html, item_file_html, item_image_html--->
				<cfcase value="item_file_html,item_image_html">
					
					<!---<cfif type EQ "message_file_html">
						
						<cfquery datasource="#client_dsn#" name="addFileToMessage">
							UPDATE #client_abb#_messages
							SET attached_file_id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">,
							attached_file_name = <cfqueryparam value="#objectFile.file_name#" cfsqltype="cf_sql_varchar">,						
							status = 'uploaded'
							WHERE id = <cfqueryparam value="#message_id#" cfsqltype="cf_sql_integer">
						</cfquery>--->
						
					<cfif type EQ "item_file_html">
						<cfquery datasource="#client_dsn#" name="addFileToMessage">
							UPDATE #client_abb#_#itemTypeTable#
							SET attached_file_id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">,
							attached_file_name = <cfqueryparam value="#objectFile.file_name#" cfsqltype="cf_sql_varchar">,						
							status = 'uploaded'
							WHERE id = <cfqueryparam value="#item_id#" cfsqltype="cf_sql_integer">
						</cfquery>
					
					<cfelseif type EQ "item_image_html">
						<cfquery datasource="#client_dsn#" name="addFileToMessage">
							UPDATE #client_abb#_#itemTypeTable#
							SET attached_image_id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">,
							attached_image_name = <cfqueryparam value="#objectFile.file_name#" cfsqltype="cf_sql_varchar">,						
							status = 'uploaded'
							WHERE id = <cfqueryparam value="#item_id#" cfsqltype="cf_sql_integer">
						</cfquery>
						
					</cfif>
					
					
					<cfquery datasource="#client_dsn#" name="updateFile">
						UPDATE #client_abb#_#files_table#
						SET file_size = <cfqueryparam value="#uploadedFile.fileSize#" cfsqltype="cf_sql_integer">, 
						file_type = <cfqueryparam value="#objectFile.file_type#" cfsqltype="cf_sql_varchar">,
						file_name = <cfqueryparam value="#objectFile.file_name#" cfsqltype="cf_sql_varchar">,
						status = 'uploaded'
						WHERE id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<cfquery name="updateSpaceUsed" datasource="#client_dsn#">
						UPDATE #client_abb#_users
						SET space_used = space_used+<cfqueryparam value="#uploadedFile.fileSize#" cfsqltype="cf_sql_integer">
						WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
				</cfcase>
				
				
				
				<!---area_image--->
				<cfcase value="area_image">
					
					<cfquery datasource="#client_dsn#" name="updateFile">
						UPDATE #client_abb#_#files_table#
						SET file_size = <cfqueryparam value="#uploadedFile.fileSize#" cfsqltype="cf_sql_integer">,
						physical_name = <cfqueryparam value="#objectFile.physical_name#" cfsqltype="cf_sql_integer">, 
						file_type = <cfqueryparam value="#objectFile.file_type#" cfsqltype="cf_sql_varchar">,
						file_name = <cfqueryparam value="#objectFile.file_name#" cfsqltype="cf_sql_varchar">,
						status = 'ok',
						status_replacement = 'ok'
						WHERE id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<cfquery datasource="#client_dsn#" name="addFileToArea">
						UPDATE #client_abb#_areas
						SET image_id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">
						WHERE id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<cfquery name="updateSpaceUsed" datasource="#client_dsn#">
						UPDATE #client_abb#_areas
						SET space_used = space_used+<cfqueryparam value="#uploadedFile.fileSize#" cfsqltype="cf_sql_integer">
						WHERE id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
				</cfcase>
				
				<!---user_image--->
				<!---<cfcase value="user_image">
				
					<!---Esto no está actualizado, y debe estar como esté el de area_image--->
					<cfquery datasource="#client_dsn#" name="addFileToUser">
						UPDATE #client_abb#_users
						SET image_id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">
						WHERE id = <cfqueryparam value="#image_user_id#" cfsqltype="cf_sql_integer">
					</cfquery>
					
					<cfquery name="updateSpaceUsed" datasource="#client_dsn#">
						UPDATE #client_abb#_users
						SET space_used = space_used+<cfqueryparam value="#uploadedFile.fileSize#" cfsqltype="cf_sql_integer">
						WHERE id = <cfqueryparam value="#image_user_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
				</cfcase>--->
			
			</cfswitch>
			
			
			</cftransaction>
			
			<!---<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="xmlFile" returnvariable="xmlResponseContent">
				<cfinvokeargument name="objectFile" value="#objectFile#">
			</cfinvoke>
			
			<!---<cfset xmlResult = FORM.file>--->
			
			
			<cfinclude template="#APPLICATION.componentsPath#/includes/functionEndNoLog.cfm">--->
			
			
			<cfreturn objectFile>
			
			
		<cfcatch><!---The upload fail--->
			<cfif isDefined("objectFile.id")>
				<cfquery datasource="#client_dsn#" name="changeFileStatus">
					UPDATE #client_abb#_#files_table#
					SET status = 'error'
					WHERE id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			
			<!---<cfset error_code = 604>--->
	
			<cfthrow object="#cfcatch#">
		
		</cfcatch>
			
		</cftry>
		
		
		
		
		
		
	</cffunction>
	
  
</cfcomponent>