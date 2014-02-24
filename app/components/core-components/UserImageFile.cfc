<!---Copyright Era7 Information Technologies 2007-2012

	Date of file creation: 20-12-2012
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 28-12-2012
		
--->
<cfcomponent output="false">

	<cfset component = "UserImageFile">	
	
	<cfset files_directory = "users_images">
	
	<cfset small_sufix = "_small">
	<cfset medium_sufix = "_medium">
	
	
	<!---uploadUserImage--->
	
	<cffunction name="uploadUserImage" access="public" returntype="void">
		<cfargument name="files" type="array" required="true">
		<cfargument name="user_id" type="numeric" required="yes">
		<cfargument name="client_abb" type="string" required="yes">
				
		<cfset var method = "uploadUserImage">		
		
		<cfset var client_dsn = APPLICATION.identifier&"_"&client_abb>
						
		<cfset var small_width = 32>
		<cfset var small_height = 32>
		
		<cfset var medium_width = 400>
		<cfset var medium_height = 400>
		
		<cfset var destination = "#APPLICATION.filesPath#/#arguments.client_abb#/#files_directory#/">
			
			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="objectFile" returnvariable="objectFile">			
				<cfinvokeargument name="return_type" value="object">
			</cfinvoke>	
			
			<!---<cfset objectFile.user_in_charge = user_id>--->
			
			<cffile action="upload" filefield="files[]" destination="#destination#" nameconflict="overwrite" result="uploadedFile" accept="image/jpg,image/jpeg,image/gif,image/png,image/pjpeg "><!---image/pjpeg para IE8 que tiene un bug--->
			
			<cfset temp_file = "#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#">
			
			<cfset objectFile.file_name = uploadedFile.clientFileName&"."&uploadedFile.clientFileExt>
			<cfset objectFile.file_type = lCase("."&uploadedFile.clientFileExt)>
			<cfset objectFile.physical_name = arguments.user_id>
				
			<cfif NOT FileExists("#destination##temp_file#")><!---The physical file does not exist--->
				<cfset error_code = 608>

				<cfthrow errorcode="#error_code#">
			</cfif>
			
			<cffile action="rename" source="#destination##temp_file#" destination="#destination##objectFile.physical_name#">
			
			<cfimage action="info" source="#destination##objectFile.physical_name#" structname="image_info">
			
			
			<cfset image_small_path = "#destination##objectFile.physical_name##small_sufix#">
			<cfset image_medium_path = "#destination##objectFile.physical_name##medium_sufix#">
			
			
			<!---small resize--->
			<cfif image_info.width GT small_width>
			
				<cfimage action="resize" width="#small_width#" source="#destination##objectFile.physical_name#" destination="#image_small_path#" overwrite="yes" name="image_resized">
				
				<cfif image_resized.height GT small_height>
					
					<cfimage action="resize" height="#small_height#" source="#image_small_path#" destination="#image_small_path#" overwrite="yes" name="image_resized">
					
				</cfif>
			
			<cfelseif image_info.height GT small_height>
			
				<cfimage action="resize" height="#small_height#" source="#destination##objectFile.physical_name#" destination="#image_small_path#" overwrite="yes" name="image_resized">
				
			<cfelse>
			
				<cffile action="copy" source="#destination##objectFile.physical_name#" destination="#image_small_path#">
				
			</cfif>
			
			
			<!---medium resize--->
			<cfif image_info.width GT medium_width>
			
				<cfimage action="resize" width="#medium_width#" source="#destination##objectFile.physical_name#" destination="#image_medium_path#" overwrite="yes" name="image_medium_resized">
				
				<cfif image_medium_resized.height GT medium_height>
					
					<cfimage action="resize" height="#medium_height#" source="#image_medium_path#" destination="#image_medium_path#" overwrite="yes" name="image_resized">
					
				</cfif>
			
			<cfelseif image_info.height GT medium_height>
				
				<cfimage action="resize" height="#medium_height#" source="#destination##objectFile.physical_name#" destination="#image_medium_path#" overwrite="yes" name="image_medium_resized">
				
			<cfelse>
			
				<cffile action="copy" source="#destination##objectFile.physical_name#" destination="#image_medium_path#">
				
			</cfif>
			
			<!---delete original file--->
			<cffile action="delete" file="#destination##objectFile.physical_name#">
			
			<cfquery datasource="#client_dsn#" name="addFileToUser">
				UPDATE #client_abb#_users
				SET <!---image_id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">--->
				image_file = <cfqueryparam value="#objectFile.physical_name#" cfsqltype="cf_sql_varchar">,
				image_type = <cfqueryparam value="#objectFile.file_type#" cfsqltype="cf_sql_varchar">
				<!---, space_used = space_used+<cfqueryparam value="#uploadedFile.fileSize#" cfsqltype="cf_sql_integer">--->
				WHERE id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>		
		
		
	</cffunction>
	
	
	
	
	<!---deleteUserImage--->
	
	<cffunction name="deleteUserImage" access="public" returntype="void">
		<cfargument name="user_id" type="numeric" required="yes">
		<cfargument name="client_abb" type="string" required="yes">
		
		<cfset var method = "deleteUserImage">		
		
		<cfset var client_dsn = APPLICATION.identifier&"_"&client_abb>
		
		<cfset var destination = "#APPLICATION.filesPath#/#arguments.client_abb#/#files_directory#/">
		
		<cffile action="delete" file="#destination##arguments.user_id##small_sufix#">
		<cffile action="delete" file="#destination##arguments.user_id##medium_sufix#">
		
		<cfquery datasource="#client_dsn#" name="deleteFileFromUser">
			UPDATE #client_abb#_users
			SET
			image_file = <cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
			image_type = <cfqueryparam cfsqltype="cf_sql_varchar" null="yes">
			<!---, space_used = space_used-<cfqueryparam value="#uploadedFile.fileSize#" cfsqltype="cf_sql_integer">--->
			WHERE id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">;
		</cfquery>		
		
		
	</cffunction>
	
  
</cfcomponent>