<!---Copyright Era7 Information Technologies 2007-2014

	Date of file creation: 16-05-2012
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	
	15-11-2012 alucena: cambiado tamaño máximo de las imágenes
	24-06-2013 alucena: areaItemTypeSwitch.cfm cambiado de directorio
	
--->
<cfcomponent output="false">

	<cfset component = "AreaItemFile">	
	
	
	<!---uploadItemFile--->
	
	<cffunction name="uploadItemFile" access="public" returntype="struct">
		<cfargument name="type" type="string" required="yes">
		<cfargument name="user_id" type="string" required="yes">
		<cfargument name="Filedata" type="string" required="false">
		<cfargument name="files[]" type="string" required="false">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="file_physical_name" type="numeric" required="false">
		<cfargument name="itemTypeId" type="numeric" required="no">
		<cfargument name="item_id" type="numeric" required="false"/>
		<cfargument name="area_id" type="numeric" required="false"/>

		<cfargument name="client_abb" type="string" required="true">
		<!---<cfargument name="client_dsn" type="string" required="yes">--->

		<cfargument name="flash_version" required="false" default="false"><!---Provisional para detectar las subidas de archivos desde la versión Flash de la administración--->
				
		<cfset var method = "uploadItemFile">		
		
		<cfset var client_dsn = APPLICATION.identifier&"_"&client_abb>
		
		<cfset var files_table = "">
		<cfset var files_directory = "">
		
		<cfswitch expression="#type#"><!---TIPOS DE SUBIDAS DE ARCHIVOS--->
		
			
			<cfcase value="message_file,item_file_html,item_image_html"><!---Archivo de elemento de área ó Imagen de elemento de área (para entradas, noticias, eventos)--->
			
				<cfset files_table = "files">
				<cfset files_directory = "files">
				
				<cfif type EQ "item_image_html">
					<cfset required_width = 2048>
					<cfset required_height = 2048>
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
				<cfset required_width = 2048>
				<cfset required_height = 2048>
				
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
			WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer"> 
			<cfif arguments.type NEQ "area_image">
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
		
		<cftry>		
			
			<!---<cfset file_field = "Filedata">--->
			
			<cfif type EQ "item_image_html">
				<cffile action="upload" filefield="#arguments.Filedata#" destination="#destination#" nameconflict="overwrite" result="uploadedFile" accept="image/gif,image/jpeg,image/png,image/pjpeg"><!---image/pjpeg para IE8 que tiene un bug--->
			<cfelseif type EQ "area_image" AND arguments.flash_version IS false>
				<cffile action="upload" filefield="files[]" destination="#destination#" nameconflict="overwrite" result="uploadedFile">
			<cfelse>
				<cffile action="upload" filefield="#arguments.Filedata#" destination="#destination#" nameconflict="overwrite" result="uploadedFile">
			</cfif>
			
			<cfset temp_file="#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#">
			
			<cfset objectFile.file_name = uploadedFile.clientFileName&"."&uploadedFile.clientFileExt>
			<cfset objectFile.file_type = lCase("."&uploadedFile.clientFileExt)>
			
			<cfif type EQ "item_image_html" OR type EQ "area_image"><!---OR type EQ "user_image"--->
				
				<!---<cfif objectFile.file_type EQ ".jpg">--->
				
				<cfif NOT FileExists("#destination##temp_file#")><!---The physical file does not exist--->
					<cfset error_code = 608>
	
					<cfthrow errorcode="#error_code#">
				</cfif>

				<cfif arguments.type EQ "area_image"><!---AREA_IMAGE--->
					
					<cfquery name="selectAreaImageQuery" datasource="#client_dsn#">
						SELECT * 
						FROM #client_abb#_areas AS areas 
						LEFT JOIN #client_abb#_areas_images AS images ON areas.image_id = images.id
						WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<cfif selectAreaImageQuery.recordCount GT 0>
					
						<cfif isNumeric(selectAreaImageQuery.image_id)><!---El area tiene imagen--->
						
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

				<!--- MODULE ANTI VIRUS --->
				<cfif APPLICATION.moduleAntiVirus IS true>

					<cfinvoke component="AntiVirusManager" method="checkForVirus" returnvariable="checkForVirusResponse">
						<cfinvokeargument name="path" value="#destination#">
						<cfinvokeargument name="filename" value="#temp_file#">
					</cfinvoke>

					<cfif checkForVirusResponse.result IS false><!--- Delete infected file --->

						<!--- delete image --->
						<cffile action="delete" file="#destination##temp_file#">

						<!---saveVirusLog--->
						<cfinvoke component="AntiVirusManager" method="saveVirusLog">
							<cfinvokeargument name="user_id" value="#arguments.user_id#">
							<cfinvokeargument name="file_name" value="#objectFile.file_name#"/>
							<cfinvokeargument name="anti_virus_result" value="#checkForVirusResponse.message#">

							<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>
						
						<cfset anti_virus_check_message = trim(listlast(checkForVirusResponse.message, ":"))>
						
						<cfthrow type="virus" message="Archivo #objectFile.file_name# no válido por ser identificado como virus: #anti_virus_check_message#">

					</cfif>

				</cfif>

				<cftry>
					
					<cfimage action="info" source="#destination##temp_file#" structname="image_info">

					<cfcatch>

						<!--- If it fails convert to RGB and Strip Information with ImageMagick --->
						<!--- REQUIRES ImageMagick installed on the server --->
						<cfexecute name="convert" arguments="#destination##temp_file# -strip -colorspace rgb -quality 100 #destination##temp_file#" timeout="35" variable="msg" />

						<cfimage action="info" source="#destination##temp_file#" structname="image_info">

					</cfcatch>
				</cftry>
				
				<!---
				Esto estaba antes así y no daba problemas
				<cfif image_info.width GT required_width>
					<cfimage action="resize" width="#required_width#" source="#destination##temp_file#" destination="#destination##temp_file#" overwrite="yes" name="image_resized">
					
					<cfif image_resized.height GT required_height>
						
						<cfimage action="resize" height="#required_height#" source="#destination##temp_file#" destination="#destination##temp_file#" overwrite="yes" name="image_resized">
						
					</cfif>
				
				<cfelseif image_info.height GT required_height>
				
					<cfimage action="resize" height="#required_height#" source="#destination##temp_file#" destination="#destination##temp_file#" overwrite="yes" name="image_resized">
					
				</cfif>
				--->

				<cfif image_info.width GT required_width OR image_info.height GT required_height>
					
					<cfimage source="#destination##temp_file#" name="imageToScale">			
					<cfset ImageScaleToFit(imageToScale, required_width, required_height, "highQuality")>
					<cfimage action="write" source="#imageToScale#" destination="#destination##temp_file#" quality="0.85" overwrite="yes">

				<!---
				<cfelseif objectFile.file_type EQ ".jpg" OR objectFile.file_type EQ ".jpeg">
					
					<!---IMPORTANTE: se ajusta la calidad de todas las imágenes JPG adjuntas que se suben para disminuir su peso--->
					<!---Esto se quita porque los resultados de cambiar la calidad de la imagen no son buenos (disminuye notablemente el tamaño de la imagen pero también se pierde calidad que afecta a determinados colores), por lo que no se debe hacer por defecto--->
					<cfimage action="write" source="#destination##temp_file#" destination="#destination##temp_file#" quality="0.85" overwrite="yes"> --->

				</cfif>
					
				<!---</cfif>--->
				
			</cfif>


			<!---Move file to final destination--->
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
						item_id = <cfqueryparam value="#item_id#" cfsqltype="cf_sql_integer">,
						item_type_id = <cfqueryparam value="#itemTypeId#" cfsqltype="cf_sql_integer">,
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
			
			<cfcatch type="virus">

				<cfif isDefined("objectFile.id")>

					<cfif arguments.type NEQ "area_image" OR NOT isNumeric(selectAreaImageQuery.image_id)><!---Si el nuevo archivo no era para reemplazar una imagen de área--->
						
						<cfquery datasource="#client_dsn#" name="changeFileStatus">
							UPDATE #client_abb#_#files_table#
							SET status = 'virus'
							WHERE id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">;
						</cfquery>

					</cfif>

				</cfif>

				<cfrethrow/>

			</cfcatch>

			<cfcatch><!---The upload fail--->

				<cfif isDefined("objectFile.id")>
					<cfquery datasource="#client_dsn#" name="changeFileStatus">
						UPDATE #client_abb#_#files_table#
						SET status = 'error'
						WHERE id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">;
					</cfquery>
				</cfif>
				
				<!---<cfset error_code = 604>--->
		
				<cfrethrow/>
			
			</cfcatch>
			
		</cftry>		
		
		
		
	</cffunction>
	
  
</cfcomponent>