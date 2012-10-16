<!---Copyright Era7 Information Technologies 2007-2012

	Date of file creation: 02-10-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 25-07-2012
	
--->
<cfcomponent output="true">

	<cfset component = "Item">
	<cfset request_component = "AreaItemManager">
	
	
	<!---<cfscript>
	
		function insertBR(str) 
		{
		
			str = replace(str,chr(13),"<br />","ALL");
			return str;	
		}
	
	</cfscript>--->	
	
	<cffunction name="selectItem" returntype="xml" access="public">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		
		<cfset var method = "selectItem">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<cftry>
			
			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<#itemTypeName# id="#arguments.item_id#"/>
				</cfoutput>
			</cfsavecontent>
			
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#itemTypeNameU#Manager">
				<cfinvokeargument name="request_method" value="select#itemTypeNameU#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
    
    
	<!--- -------------------------------createItemRemote-------------------------------------- --->
	
    <cffunction name="createItemRemote" returntype="void" access="remote">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="link" type="string" required="false" default="">
        <cfargument name="description" type="string" required="false" default="">
        <cfargument name="parent_id" type="numeric" required="true">
        <cfargument name="parent_kind" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
        <cfargument name="Filedata" type="any" required="false" default="">
		<cfargument name="imagedata" type="any" required="false" default="">
		<cfargument name="notify_by_sms" type="boolean" required="no">
		<cfargument name="post_to_twitter" type="boolean" required="no">
		<cfargument name="start_date" type="string" required="no">
		<cfargument name="end_date" type="string" required="no">
		<cfargument name="start_hour" type="numeric" required="no">
		<cfargument name="start_minute" type="numeric" required="no">
		<cfargument name="end_hour" type="numeric" required="no">
		<cfargument name="end_minute" type="numeric" required="no">
		<cfargument name="place" type="string" required="no">
		<cfargument name="recipient_user" type="numeric" required="no">
		<cfargument name="estimated_value" type="numeric" required="no">
		<cfargument name="real_value" type="numeric" required="no">
		<cfargument name="done" type="boolean" required="no">
		<cfargument name="position" type="numeric" required="no">
		<cfargument name="display_type" type="numeric" required="no">
		<cfargument name="iframe_url" type="string" required="no">
		<cfargument name="iframe_display_type" type="numeric" required="no">
		<cfargument name="return_path" type="string" required="yes">
		
		<cfset var method = "createItemRemote">
		
		<cftry>
		
			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<cfinvoke component="AreaItem" method="createItem" returnvariable="createItemResult">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="title" value="#arguments.title#">
				<cfinvokeargument name="link" value="#arguments.link#">
				<cfinvokeargument name="description" value="#arguments.description#">
				<cfinvokeargument name="parent_id" value="#arguments.parent_id#">
				<cfinvokeargument name="parent_kind" value="#arguments.parent_kind#">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="Filedata" value="#arguments.Filedata#">
				<cfinvokeargument name="imagedata" value="#arguments.imagedata#">
				<cfif isDefined("arguments.notify_by_sms")>
					<cfinvokeargument name="notify_by_sms" value="#arguments.notify_by_sms#">
				</cfif>
				<cfif isDefined("arguments.post_to_twitter")>
					<cfinvokeargument name="post_to_twitter" value="#arguments.post_to_twitter#">
				</cfif>
				<cfif isDefined("arguments.start_date")>
					<cfinvokeargument name="start_date" value="#arguments.start_date#">
				</cfif>
				<cfif isDefined("arguments.end_date")>
					<cfinvokeargument name="end_date" value="#arguments.end_date#">
				</cfif>
				<cfif isDefined("arguments.start_hour") AND isDefined("arguments.start_minute")>
					<cfinvokeargument name="start_hour" value="#arguments.start_hour#">
					<cfinvokeargument name="start_minute" value="#arguments.start_minute#">
				</cfif>
				<cfif isDefined("arguments.end_hour") AND isDefined("arguments.end_minute")>
					<cfinvokeargument name="end_hour" value="#arguments.end_hour#">
					<cfinvokeargument name="end_minute" value="#arguments.end_minute#">
				</cfif>
				<cfif isDefined("arguments.place")>
					<cfinvokeargument name="place" value="#arguments.place#">
				</cfif>
				<cfif isDefined("arguments.recipient_user")>
					<cfinvokeargument name="recipient_user" value="#arguments.recipient_user#">
				</cfif>
				<cfif isDefined("arguments.estimated_value")>
					<cfinvokeargument name="estimated_value" value="#arguments.estimated_value#">
				</cfif>
				<cfif isDefined("arguments.real_value")>
					<cfinvokeargument name="real_value" value="#arguments.real_value#">
				</cfif>
				<cfif isDefined("arguments.done")>
					<cfinvokeargument name="done" value="#arguments.done#">
				</cfif>
				<cfif isDefined("arguments.position")>
					<cfinvokeargument name="position" value="#arguments.position#">
				</cfif>
				<cfif isDefined("arguments.display_type")>
					<cfinvokeargument name="display_type" value="#arguments.display_type#">
				</cfif>
				<cfif isDefined("arguments.iframe_url")>
					<cfinvokeargument name="iframe_url" value="#arguments.iframe_url#">
				</cfif>
				<cfif isDefined("arguments.iframe_display_type")>
					<cfinvokeargument name="iframe_display_type" value="#arguments.iframe_display_type#">
				</cfif>
			</cfinvoke>
			
			<cfset msg = URLEncodedFormat(createItemResult.message)>
			<cflocation url="#arguments.return_path##itemTypeNameP#.cfm?area=#arguments.area_id#&msg=#msg#&res=#createItemResult.result#" addtoken="no">			
            
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	
	<!--- -------------------------------createItem-------------------------------------- --->
	
	<cffunction name="createItem" returntype="struct" access="public">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="link" type="string" required="true">
        <cfargument name="description" type="string" required="false" default="">
        <cfargument name="parent_id" type="numeric" required="true">
        <cfargument name="parent_kind" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
        <cfargument name="Filedata" type="any" required="false" default="">
		<cfargument name="imagedata" type="any" required="false" default="">
		<cfargument name="notify_by_sms" type="boolean" required="no">
		<cfargument name="post_to_twitter" type="boolean" required="no">
		<cfargument name="start_date" type="string" required="no">
		<cfargument name="end_date" type="string" required="no">
		<cfargument name="start_hour" type="numeric" required="no">
		<cfargument name="start_minute" type="numeric" required="no">
		<cfargument name="end_hour" type="numeric" required="no">
		<cfargument name="end_minute" type="numeric" required="no">
		<cfargument name="place" type="string" required="no">
		<cfargument name="recipient_user" type="numeric" required="no">
		<cfargument name="estimated_value" type="numeric" required="no">
		<cfargument name="real_value" type="numeric" required="no">
		<cfargument name="done" type="boolean" required="no" default="false">
		<cfargument name="position" type="numeric" required="no">
		<cfargument name="display_type" type="numeric" required="no">
		<cfargument name="iframe_url" type="string" required="no">
		<cfargument name="iframe_display_type" type="numeric" required="no">
		
		<cfset var method = "createItem">
		
		<cfset var request_parameters = "">
		
		<cfset var with_attached = false>
		<cfset var with_image = false>
		
		<cfset var createdItemId = "">
		
		<cfset var file_id = "">
		<cfset var file_physical_name = "">
		
		<cfset var image_id = "">
		<cfset var image_physical_name = "">
		
		<cfset var response_message = "">
		
			
			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<cfif len(arguments.Filedata) GT 0>
				<cfset with_attached = true>
			</cfif>
            
			<cfif len(arguments.imagedata) GT 0>
				<cfset with_image = true>
			</cfif>
						
            <cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="objectItem" returnvariable="xmlResultItem">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
                <cfinvokeargument name="title" value="#arguments.title#">
				<cfinvokeargument name="link" value="#arguments.link#">
                <cfinvokeargument name="description" value="#arguments.description#">
                <cfinvokeargument name="user_in_charge" value="#SESSION.user_id#">
                <cfinvokeargument name="parent_id" value="#arguments.parent_id#">
                <cfinvokeargument name="parent_kind" value="#arguments.parent_kind#">
				<cfif with_attached IS false>
                	<cfinvokeargument name="attached_file_id" value="-1">
                    <cfinvokeargument name="attached_file_name" value="NULL">
         		<cfelse>
                 	<cfinvokeargument name="attached_file_id" value="NULL">
                    <cfinvokeargument name="attached_file_name" value="(Pendiente de subir el archivo)">
                </cfif>
				<cfif with_image IS false>
					<cfinvokeargument name="attached_image_id" value="-1">
					<cfinvokeargument name="attached_image_name" value="NULL">
				<cfelse>
					<cfinvokeargument name="attached_image_id" value="NULL">
                    <cfinvokeargument name="attached_image_name" value="(Pendiente de subir el archivo)">
				</cfif>
                <cfif isDefined("arguments.notify_by_sms")>
					<cfinvokeargument name="notify_by_sms" value="#arguments.notify_by_sms#">
				</cfif>
				<cfif isDefined("arguments.post_to_twitter")>
					<cfinvokeargument name="post_to_twitter" value="#arguments.post_to_twitter#">
				</cfif>
				<cfif isDefined("arguments.start_date")>
					<cfinvokeargument name="start_date" value="#arguments.start_date#">
				</cfif>
				<cfif isDefined("arguments.end_date")>
					<cfinvokeargument name="end_date" value="#arguments.end_date#">
				</cfif>
				<cfif isDefined("arguments.start_hour") AND isDefined("arguments.start_minute")>
					<cfinvokeargument name="start_time" value="#arguments.start_hour#:#arguments.start_minute#">
				</cfif>
				<cfif isDefined("arguments.end_hour") AND isDefined("arguments.end_minute")>
					<cfinvokeargument name="end_time" value="#arguments.end_hour#:#arguments.end_minute#">
				</cfif>
				<cfif isDefined("arguments.place")>
					<cfinvokeargument name="place" value="#arguments.place#">
				</cfif>
				<cfif isDefined("arguments.recipient_user")>
					<cfinvokeargument name="recipient_user" value="#arguments.recipient_user#">
				</cfif>
				<cfif isDefined("arguments.estimated_value")>
					<cfinvokeargument name="estimated_value" value="#arguments.estimated_value#">
				</cfif>
				<cfif isDefined("arguments.real_value")>
					<cfinvokeargument name="real_value" value="#arguments.real_value#">
				</cfif>
				<cfinvokeargument name="done" value="#arguments.done#">
				<cfif isDefined("arguments.position")>
					<cfinvokeargument name="position" value="#arguments.position#">
				</cfif>
				<cfif isDefined("arguments.display_type")>
					<cfinvokeargument name="display_type" value="#arguments.display_type#">
				</cfif>
				<cfif isDefined("arguments.iframe_url")>
					<cfinvokeargument name="iframe_url" value="#arguments.iframe_url#">
				</cfif>
				<cfif isDefined("arguments.iframe_display_type")>
					<cfinvokeargument name="iframe_display_type" value="#arguments.iframe_display_type#">
				</cfif>
				                                
                <cfinvokeargument name="return_type" value="xml">
            </cfinvoke>
          
		  
         	<cfif with_attached IS true>
            	<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="objectFile" returnvariable="objectFile">		
					<cfinvokeargument name="user_in_charge" value="#SESSION.user_id#">		
					<cfinvokeargument name="file_name" value="(Pendiente de subir el archivo)">
					<cfinvokeargument name="file_type" value="pending">
					<cfinvokeargument name="name" value=" ">
					<cfinvokeargument name="description" value=" ">
					
					<cfinvokeargument name="return_type" value="object">
				</cfinvoke>
				
				<cfset objectFile.file_size = "0">
				
				<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="xmlFile" returnvariable="xmlFileResult">		
						<cfinvokeargument name="objectFile" value="#objectFile#">
				</cfinvoke>
            </cfif>
            
			<cfsavecontent variable="request_parameters">
				<cfoutput>
					#xmlResultItem#
                    <cfif with_attached IS true>
                    #xmlFileResult#
                    </cfif>
				</cfoutput>
			</cfsavecontent>
			
            <cfif with_attached IS false><!---No hay archivo para subir--->
			
				<!---Aunque haya imagen el elemento se crea llamando a este método, porque en el contenido del elemento se incluye que hay una imagen, lo que hace que al crearse el elemento este se marque como pendiente de subir.--->
                <cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
                    <cfinvokeargument name="request_component" value="#itemTypeNameU#Manager">
                    <cfinvokeargument name="request_method" value="create#itemTypeNameU#">
                    <cfinvokeargument name="request_parameters" value="#request_parameters#">
                </cfinvoke>
				
				<cfset createdItemId = xmlResponse.response.result[#itemTypeName#].xmlAttributes.id>
				
				<cfif itemTypeGender EQ "male">
					<cfset response_message = "#itemTypeNameEs# insertado.">
				<cfelse>
					<cfset response_message = "#itemTypeNameEs# insertada.">
				</cfif>
				
			<cfelse><!---Hay archivo para subir--->
			
            	<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
                    <cfinvokeargument name="request_component" value="#itemTypeNameU#Manager">
                    <cfinvokeargument name="request_method" value="create#itemTypeNameU#WithAttachedFile">
                    <cfinvokeargument name="request_parameters" value="#request_parameters#">
                </cfinvoke>
				
				<cfset createdItemId = xmlResponse.response.result[#itemTypeName#].xmlAttributes.id>
				<cfset file_id = xmlResponse.response.result.file.xmlAttributes.id>
				<cfset file_physical_name = xmlResponse.response.result.file.xmlAttributes.physical_name>
				
				<!---Aquí el archivo se sube, pero no se marca como que se ha completado (eso se hace después en la llamada a getItemFileStatus--->
				<cfinvoke component="AreaItemFile" method="uploadItemFile">
                    <cfinvokeargument name="item_id" value="#createdItemId#">
                    <cfinvokeargument name="itemTypeId" value="#itemTypeId#">
                    <cfinvokeargument name="itemTypeName" value="#itemTypeName#">
					<cfinvokeargument name="file_type" value="item_file_html">
					<cfinvokeargument name="file_id" value="#file_id#">
					<cfinvokeargument name="file_physical_name" value="#file_physical_name#">
					<cfinvokeargument name="Filedata" value="#arguments.Filedata#">
                </cfinvoke>
				
					
			</cfif>
			
			<!---Subida de IMAGEN--->
			<cfif with_image IS true>
				<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="objectFile" returnvariable="xmlImageFile">		
					<cfinvokeargument name="user_in_charge" value="#SESSION.user_id#">		
					<cfinvokeargument name="file_name" value="(Pendiente de subir la imagen)">
					<cfinvokeargument name="file_type" value="pending">
					<cfinvokeargument name="name" value=" ">
					<cfinvokeargument name="description" value=" ">
					<cfinvokeargument name="file_size" value="0">
					
					<cfinvokeargument name="return_type" value="xml">
				</cfinvoke>
				
				
				<cfsavecontent variable="xmlRequest">
					<request>
						<parameters>
						<cfoutput>
							#xmlImageFile#
						</cfoutput>
						</parameters>
					</request>
				</cfsavecontent>
				
				<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="createFile" returnvariable="resultFile">
					<cfinvokeargument name="request" value="#xmlRequest#">
					<cfinvokeargument name="status" value="pending">
				</cfinvoke>
					
				<cfxml variable="xmlResultFile">
					<cfoutput>
						#resultFile#
					</cfoutput>					
				</cfxml>
				
				
				<cfif xmlResultFile.response.xmlAttributes.status EQ "ok">
			
					<cfset image_id = xmlResultFile.response.result.file.xmlAttributes.id>
					<cfset image_physical_name = xmlResultFile.response.result.file.xmlAttributes.physical_name>
					
					<cftry>
					
						<!---Aquí la imagen se sube, pero no se marca como que se ha completado el proceso de creación del elemento (eso se hace después en la llamada a getItemFileStatus--->
						<cfinvoke component="AreaItemFile" method="uploadItemFile">
							<cfinvokeargument name="item_id" value="#createdItemId#">
							<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
							<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
							<cfinvokeargument name="file_type" value="item_image_html">
							<cfinvokeargument name="file_id" value="#image_id#">
							<cfinvokeargument name="file_physical_name" value="#image_physical_name#">
							<cfinvokeargument name="Filedata" value="#arguments.imagedata#">
						</cfinvoke>
						
						<cfcatch><!---Este catch se utiliza para cuando un archivo no es una imagen--->
						
							<cfset response = {result="false", message=#cfcatch.Message#}>	
							<cfreturn response>
						
						</cfcatch>
						
					</cftry>
					
					<!---<cfif xmlGetFileResponse.response.result.file.xmlAttributes.status NEQ "ok">
						
						<cfset response_message = "Error al subir la imagen">
						<cfset response_message = URLEncodedFormat(response_message)>
						<cflocation url="#arguments.return_path##itemTypeNameP#.cfm?area=#arguments.area_id#&msg=#response_message#&res=0" addtoken="no">
						
					</cfif>--->
					
				<cfelse>
				
					<cfset response_message = "Error al crear la imagen">
					<!---<cfset response_message = URLEncodedFormat(response_message)>
					<cflocation url="#arguments.return_path##itemTypeNameP#.cfm?area=#arguments.area_id#&response_message=#response_message#&res=0" addtoken="no">--->
					<cfset response = {result="false", message=#response_message#}>	
					<cfreturn response>
					
				</cfif>
			
			</cfif>
			
			
			<!---Ahora se marca que el archivo y/o la imagen se han subido--->		
			<cfif with_attached IS true>
				<!---Obtiene el status de la subida del archivo para comprobar que se ha subido correctamente. Si se ha completado la subida, se marca el archivo y el elemento que lo lleva adjunto como subido.--->
				<cfinvoke component="Request" method="doRequest" returnvariable="xmlGetFileResponse">
					<cfinvokeargument name="request_component" value="#itemTypeNameU#Manager">
					<cfinvokeargument name="request_method" value="get#itemTypeNameU#FileStatus">
					<cfinvokeargument name="request_parameters" value='<file id="#file_id#"/>'>
				</cfinvoke>
				
				<cfif xmlGetFileResponse.response.result.file.xmlAttributes.status EQ "ok">
					
					<cfif itemTypeGender EQ "male">
						<cfset response_message = "#itemTypeNameEs# con adjunto enviado.">
					<cfelse>
						<cfset response_message = "#itemTypeNameEs# con adjunto enviada.">
					</cfif>
				
				<cfelse>
					<!---IMPORTANTE: aquí da error si la sesión ha caducado--->
					<cfset response_message = "Ha ocurrido un error al subir el archivo adjunto.">
					<!---<cfset response_message = URLEncodedFormat(response_message)>
					<cflocation url="#arguments.return_path##itemTypeNameP#.cfm?area=#arguments.area_id#&response_message=#response_message#&res=0" addtoken="no">--->
					<cfset response = {result="false", message=#response_message#}>	
					<cfreturn response>
					
				</cfif>
			</cfif>
			
			<cfif with_image IS true>
				
				<cftry>
				
					<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getAreaItemFileStatus" returnvariable="xmlGetImageResponseContent">
						<cfinvokeargument name="file_id" value="#image_id#">
						<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
						<cfinvokeargument name="file_type" value="image">
						<cfif with_attached IS true><!---Esto es para que no se envíen 2 notificaciones--->
							<cfinvokeargument name="send_alert" value="false">
						<cfelse>
							<cfinvokeargument name="send_alert" value="true">
						</cfif>
					</cfinvoke>
					
						
					<cfif itemTypeGender EQ "male">
						<cfset response_message = "#itemTypeNameEs# con imagen enviado.">
					<cfelse>
						<cfset response_message = "#itemTypeNameEs# con imagen enviada.">
					</cfif>
					
					<cfcatch>
						
						<cfset response_message = "Ha ocurrido un error al subir la imagen.">
						<!---<cfset response_message = URLEncodedFormat(response_message)>
						<cflocation url="#arguments.return_path##itemTypeNameP#.cfm?area=#arguments.area_id#&response_message=#response_message#&res=0" addtoken="no">--->
						<cfset response = {result="false", message=#response_message#}>	
						<cfreturn response>
					
					</cfcatch>
				
				</cftry>
				
				
			</cfif>
			
			
			<!---<cfset response_message = URLEncodedFormat(response_message)>
			<cflocation url="#arguments.return_path##itemTypeNameP#.cfm?area=#arguments.area_id#&response_message=#response_message#&res=1" addtoken="no">--->
			
			<cfset response = {result="true", message=#response_message#, item_id=#createdItemId#}>
			<cfreturn response>
		
	</cffunction>
	
	
 	<cffunction name="updateItemRemote" returntype="void" access="remote">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="link" type="string" required="false" default="">
        <cfargument name="description" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
        <cfargument name="Filedata" type="any" required="false" default="">
		<cfargument name="imagedata" type="any" required="false" default="">
		<cfargument name="notify_by_sms" type="string" required="no">
		<cfargument name="post_to_twitter" type="boolean" required="no">
		<cfargument name="return_path" type="string" required="yes">
		<cfargument name="start_date" type="string" required="no">
		<cfargument name="end_date" type="string" required="no">
		<cfargument name="start_hour" type="string" required="no">
		<cfargument name="start_minute" type="string" required="no">
		<cfargument name="end_hour" type="string" required="no">
		<cfargument name="end_minute" type="string" required="no">
		<cfargument name="place" type="string" required="no">
		<cfargument name="recipient_user" type="numeric" required="no">
		<cfargument name="estimated_value" type="numeric" required="no">
		<cfargument name="real_value" type="numeric" required="no">
		<cfargument name="done" type="boolean" required="no" default="false">
		<cfargument name="position" type="numeric" required="no">
		<cfargument name="display_type" type="numeric" required="no">
		<cfargument name="iframe_url" type="string" required="no">
		<cfargument name="iframe_display_type" type="numeric" required="no">
		
		<cfset var method = "updateItem">
		
		<cfset var request_parameters = "">
		
		<cfset var with_attached = false>
		<cfset var with_image = false>
				
		<cfset var file_id = "">
		<cfset var file_physical_name = "">
		
		<cfset var image_id = "">
		<cfset var image_physical_name = "">
		
		<cfset var response_message = "">
		
		<cftry>
			
			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<cfif len(arguments.Filedata) GT 0>
				<cfset with_attached = true>
			</cfif>
			
			<cfif len(arguments.imagedata) GT 0>
				<cfset with_image = true>
			</cfif>
            
			
			<!---<cfset description_html = insertBR(arguments.description)>--->
			
            <cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="objectItem" returnvariable="xmlResultItem">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="id" value="#arguments.item_id#">
                <cfinvokeargument name="title" value="#arguments.title#">
				<cfinvokeargument name="link" value="#arguments.link#">
                <cfinvokeargument name="description" value="#arguments.description#">
                <cfinvokeargument name="user_in_charge" value="#SESSION.user_id#">
				<cfif with_attached IS false>
                	<cfinvokeargument name="attached_file_id" value="-1">
                    <cfinvokeargument name="attached_file_name" value="NULL">
         		<cfelse>
                 	<cfinvokeargument name="attached_file_id" value="NULL">
                    <cfinvokeargument name="attached_file_name" value="(Pendiente de subir el archivo)">
                </cfif>
				<cfif with_image IS false>
					<cfinvokeargument name="attached_image_id" value="-1">
					<cfinvokeargument name="attached_image_name" value="NULL">
				<cfelse>
					<cfinvokeargument name="attached_image_id" value="NULL">
                    <cfinvokeargument name="attached_image_name" value="(Pendiente de subir el archivo)">
				</cfif>
                <cfif isDefined("arguments.notify_by_sms")>
					<cfinvokeargument name="notify_by_sms" value="#arguments.notify_by_sms#">
				</cfif>
				<cfif isDefined("arguments.post_to_twitter")>
					<cfinvokeargument name="post_to_twitter" value="#arguments.post_to_twitter#">
				</cfif>
				<cfif isDefined("arguments.start_date")>
					<cfinvokeargument name="start_date" value="#arguments.start_date#">
				</cfif>
				<cfif isDefined("arguments.end_date")>
					<cfinvokeargument name="end_date" value="#arguments.end_date#">
				</cfif>
				<cfif isDefined("arguments.start_hour") AND isDefined("arguments.start_minute")>
					<cfinvokeargument name="start_time" value="#arguments.start_hour#:#arguments.start_minute#">
				</cfif>
				<cfif isDefined("arguments.end_hour") AND isDefined("arguments.end_minute")>
					<cfinvokeargument name="end_time" value="#arguments.end_hour#:#arguments.end_minute#">
				</cfif>
				<cfif isDefined("arguments.start_hour") AND isDefined("arguments.start_minute")>
					<cfinvokeargument name="start_hour" value="#arguments.start_hour#">
					<cfinvokeargument name="start_minute" value="#arguments.start_minute#">
				</cfif>
				<cfif isDefined("arguments.end_hour") AND isDefined("arguments.end_minute")>
					<cfinvokeargument name="end_hour" value="#arguments.end_hour#">
					<cfinvokeargument name="end_minute" value="#arguments.end_minute#">
				</cfif>
				<cfif isDefined("arguments.place")>
					<cfinvokeargument name="place" value="#arguments.place#">
				</cfif>
				<cfif isDefined("arguments.recipient_user")>
					<cfinvokeargument name="recipient_user" value="#arguments.recipient_user#">
				</cfif>
				<cfif isDefined("arguments.estimated_value")>
					<cfinvokeargument name="estimated_value" value="#arguments.estimated_value#">
				</cfif>
				<cfif isDefined("arguments.real_value")>
					<cfinvokeargument name="real_value" value="#arguments.real_value#">
				</cfif>
				<cfinvokeargument name="done" value="#arguments.done#">
				<cfif isDefined("arguments.position")>
					<cfinvokeargument name="position" value="#arguments.position#">
				</cfif>       
				<cfif isDefined("arguments.display_type")>
					<cfinvokeargument name="display_type" value="#arguments.display_type#">
				</cfif> 
				<cfif isDefined("arguments.iframe_url")>
					<cfinvokeargument name="iframe_url" value="#arguments.iframe_url#">
				</cfif>
				<cfif isDefined("arguments.iframe_display_type")>
					<cfinvokeargument name="iframe_display_type" value="#arguments.iframe_display_type#">
				</cfif>
					                            
                <cfinvokeargument name="return_type" value="xml">
            </cfinvoke>
          
		  
         	<cfif with_attached IS true>
            	<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="objectFile" returnvariable="objectFile">		
					<cfinvokeargument name="user_in_charge" value="#SESSION.user_id#">		
					<!---<cfinvokeargument name="file_name" value="#Filedata#">--->
					<cfinvokeargument name="file_name" value="(Pendiente de subir el archivo)"><!---Este nombre sale en la notificación--->
					<cfinvokeargument name="file_type" value="pending">
					<cfinvokeargument name="name" value=" ">
					<cfinvokeargument name="description" value=" ">
					
					<cfinvokeargument name="return_type" value="object">
				</cfinvoke>
				
				<cfset objectFile.file_size = "0">
				
				<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="xmlFile" returnvariable="xmlFileResult">		
					<cfinvokeargument name="objectFile" value="#objectFile#">
				</cfinvoke>
            </cfif>
            
			<cfsavecontent variable="request_parameters">
				<cfoutput>
					#xmlResultItem#
                    <cfif with_attached IS true>
                    #xmlFileResult#
                    </cfif>
				</cfoutput>
			</cfsavecontent>
			
            <cfif with_attached IS false>
			
				<!---Aunque haya imagen el elemento se crea llamando a este método, porque en el contenido del elemento se incluye que hay una imagen, lo que hace que al crearse el elemento este se marque como pendiente de subir.--->			
                <cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
                    <cfinvokeargument name="request_component" value="#itemTypeNameU#Manager">
                    <cfinvokeargument name="request_method" value="update#itemTypeNameU#">
                    <cfinvokeargument name="request_parameters" value="#request_parameters#">
                </cfinvoke>
				
				<cfif itemTypeGender EQ "male">
					<cfset msg = "#itemTypeNameEs# modificado.">
				<cfelse>
					<cfset msg = "#itemTypeNameEs# modificada.">
				</cfif>
				<cfset response_message = URLEncodedFormat(msg)>
				
				<!---<cflocation url="#arguments.return_path##itemTypeNameP#.cfm?area=#arguments.area_id#&message=#msg#" addtoken="no">--->
				
			<cfelse><!---Hay archivo para subir--->
			
				<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
                    <cfinvokeargument name="request_component" value="#itemTypeNameU#Manager">
                    <cfinvokeargument name="request_method" value="update#itemTypeNameU#WithAttachedFile">
                    <cfinvokeargument name="request_parameters" value="#request_parameters#">
                </cfinvoke>
				
				<!---<cfset updatedItemId = xmlResponse.response.result[#itemTypeName#].xmlAttributes.id>--->
				<cfset file_id = xmlResponse.response.result.file.xmlAttributes.id>
				<cfset file_physical_name = xmlResponse.response.result.file.xmlAttributes.physical_name>
				
				<!---Aquí el archivo se sube, pero no se marca como que se ha completado (eso se hace después en la llamada a getItemFileStatus--->
				<cfinvoke component="AreaItemFile" method="uploadItemFile">
                    <cfinvokeargument name="item_id" value="#arguments.item_id#">
                    <cfinvokeargument name="itemTypeId" value="#itemTypeId#">
                    <cfinvokeargument name="itemTypeName" value="#itemTypeName#">
					<cfinvokeargument name="file_type" value="item_file_html">
					<cfinvokeargument name="file_id" value="#file_id#">
					<cfinvokeargument name="file_physical_name" value="#file_physical_name#">
					<cfinvokeargument name="Filedata" value="#arguments.Filedata#">
                </cfinvoke>
					
			</cfif>
			
			
			
			<!---Subida de IMAGEN--->
			<cfif with_image IS true>
				<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="objectFile" returnvariable="xmlImageFile">		
					<cfinvokeargument name="user_in_charge" value="#SESSION.user_id#">		
					<cfinvokeargument name="file_name" value="(Pendiente de subir la imagen)">
					<cfinvokeargument name="file_type" value="pending">
					<cfinvokeargument name="name" value=" ">
					<cfinvokeargument name="description" value=" ">
					<cfinvokeargument name="file_size" value="0">
					
					<cfinvokeargument name="return_type" value="xml">
				</cfinvoke>
				
				
				<cfsavecontent variable="xmlRequest">
					<request>
						<parameters>
						<cfoutput>
							#xmlImageFile#
						</cfoutput>
						</parameters>
					</request>
				</cfsavecontent>
				
				<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="createFile" returnvariable="resultFile">
					<cfinvokeargument name="request" value="#xmlRequest#">
					<cfinvokeargument name="status" value="pending">
				</cfinvoke>
					
				<cfxml variable="xmlResultFile">
					<cfoutput>
						#resultFile#
					</cfoutput>					
				</cfxml>
				
				
				<cfif xmlResultFile.response.xmlAttributes.status EQ "ok">
			
					<cfset image_id = xmlResultFile.response.result.file.xmlAttributes.id>
					<cfset image_physical_name = xmlResultFile.response.result.file.xmlAttributes.physical_name>
					
					<cftry>
					
						<!---Aquí la imagen se sube, pero no se marca como que se ha completado el proceso de creación del elemento (eso se hace después en la llamada a getItemFileStatus--->
						<cfinvoke component="AreaItemFile" method="uploadItemFile">
							<cfinvokeargument name="item_id" value="#arguments.item_id#">
							<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
							<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
							<cfinvokeargument name="file_type" value="item_image_html">
							<cfinvokeargument name="file_id" value="#image_id#">
							<cfinvokeargument name="file_physical_name" value="#image_physical_name#">
							<cfinvokeargument name="Filedata" value="#arguments.imagedata#">
						</cfinvoke>
						
						<cfcatch><!---Este catch se utiliza para cuando un archivo no es una imagen--->
						
							<cfset response = {result="false", message=#cfcatch.Message#}>	
							<cfreturn response>
						
						</cfcatch>
						
					</cftry>
					
					<!---<cfif xmlGetFileResponse.response.result.file.xmlAttributes.status NEQ "ok">
						
						<cfset response_message = "Error al subir la imagen">
						<cfset response_message = URLEncodedFormat(response_message)>
						<cflocation url="#arguments.return_path##itemTypeNameP#.cfm?area=#arguments.area_id#&msg=#response_message#&res=0" addtoken="no">
						
					</cfif>--->
					
				<cfelse>
				
					<cfset response_message = "Error al crear la imagen">
					<!---<cfset response_message = URLEncodedFormat(response_message)>
					<cflocation url="#arguments.return_path##itemTypeNameP#.cfm?area=#arguments.area_id#&response_message=#response_message#&res=0" addtoken="no">--->
					<cfset response = {result="false", message=#response_message#}>	
					<cfreturn response>
					
				</cfif>
			
			</cfif>
			
			
			
			<!---Ahora se marca que el archivo y/o la imagen se han subido--->		
			<cfif with_attached IS true>
				<!---Obtiene el status de la subida del archivo para comprobar que se ha subido correctamente. Si se ha completado la subida, se marca el archivo y el elemento que lo lleva adjunto como subido.--->
				
				<cftry>
				
					<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getAreaItemFileStatus" returnvariable="xmlGetFileResponseContent">
						<cfinvokeargument name="file_id" value="#file_id#">
						<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
						<cfinvokeargument name="file_type" value="file">
						<cfinvokeargument name="send_alert" value="true">
						<cfinvokeargument name="action" value="modify">
					</cfinvoke>
					
						
					<cfif itemTypeGender EQ "male">
						<cfset response_message = "#itemTypeNameEs# con adjunto modificado.">
					<cfelse>
						<cfset response_message = "#itemTypeNameEs# con adjunto modificada.">
					</cfif>
					
					<cfcatch>
						<!---IMPORTANTE: aquí da error si la sesión ha caducado--->
						<cfset response_message = "Ha ocurrido un error al subir el archivo.">
						<cfset response_message = URLEncodedFormat(response_message)>
						<cflocation url="#arguments.return_path##itemTypeNameP#.cfm?area=#arguments.area_id#&msg=#response_message#&res=0" addtoken="no">
						<!---<cfset response = {result="false", message=#response_message#}>	
						<cfreturn response>--->
					
					</cfcatch>
				
				</cftry>
				
			</cfif>
			
			
			<cfif with_image IS true>
				<!---Obtiene el status de la subida de la imagen para comprobar que se ha subido correctamente. Si se ha completado la subida, se marca el archivo y el elemento que lo lleva adjunto como subido.--->
				
				<!---<cfinvoke component="Request" method="doRequest" returnvariable="xmlGetImageResponse">
					<cfinvokeargument name="request_component" value="#itemTypeNameU#Manager">
					<cfinvokeargument name="request_method" value="get#itemTypeNameU#ImageStatus">
					<cfinvokeargument name="request_parameters" value='<file id="#image_id#"/>'>
				</cfinvoke>--->
				
				<cftry>
				
					<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getAreaItemFileStatus" returnvariable="xmlGetImageResponseContent">
						<cfinvokeargument name="file_id" value="#image_id#">
						<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
						<cfinvokeargument name="file_type" value="image">
						<cfif with_attached IS true><!---Esto es para que no se envíen 2 notificaciones--->
							<cfinvokeargument name="send_alert" value="false">
						<cfelse>
							<cfinvokeargument name="send_alert" value="true">
						</cfif>
						<cfinvokeargument name="action" value="modify">
					</cfinvoke>
					
						
					<cfif itemTypeGender EQ "male">
						<cfset response_message = "#itemTypeNameEs# con imagen modificado.">
					<cfelse>
						<cfset response_message = "#itemTypeNameEs# con imagen modificada.">
					</cfif>
					
					<cfcatch>
						
						<cfset response_message = "Ha ocurrido un error al subir la imagen.">
						<cfset response_message = URLEncodedFormat(response_message)>
						<cflocation url="#arguments.return_path##itemTypeNameP#.cfm?area=#arguments.area_id#&msg=#response_message#&res=0" addtoken="no">
						<!---<cfset response = {result="false", message=#response_message#}>	
						<cfreturn response>--->
					
					</cfcatch>
				
				</cftry>
				
			</cfif>
			
			
			<cfset response_message = URLEncodedFormat(response_message)>
			<cflocation url="#arguments.return_path##itemTypeNameP#.cfm?area=#arguments.area_id#&msg=#response_message#&res=1" addtoken="no">
			
            
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	<!--- ---------------------------------copyItemToAreas------------------------------- --->
	
	<cffunction name="copyItemToAreas" returntype="struct" access="public">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="link" type="string" required="false" default="">
        <cfargument name="description" type="string" required="false" default="">
        <cfargument name="Filedata" type="any" required="false" default="">
		<cfargument name="imagedata" type="any" required="false" default="">
		<cfargument name="notify_by_sms" type="boolean" required="no">
		<cfargument name="post_to_twitter" type="boolean" required="no">
		<cfargument name="copy_attached_file_id" type="numeric" required="no">
		<cfargument name="copy_attached_image_id" type="numeric" required="no">				
		<cfargument name="areas_ids" type="array" required="true">
		<cfargument name="start_date" type="string" required="no">
		<cfargument name="end_date" type="string" required="no">
		<cfargument name="start_hour" type="string" required="no">
		<cfargument name="start_minute" type="string" required="no">
		<cfargument name="end_hour" type="string" required="no">
		<cfargument name="end_minute" type="string" required="no">
		<cfargument name="place" type="string" required="no">
		<cfargument name="recipient_user" type="numeric" required="no">
		<cfargument name="estimated_value" type="numeric" required="no">
		<cfargument name="real_value" type="numeric" required="no">
		<cfargument name="done" type="boolean" required="no" default="false">
		<cfargument name="position" type="numeric" required="no">
		<cfargument name="display_type" type="numeric" required="no">
		<cfargument name="iframe_url" type="string" required="no">
		<cfargument name="iframe_display_type" type="numeric" required="no">
		
		<cfset var method = "copyItemToAreas">
		
		<cftry>
			
			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
		  
		  	<cfloop index="cur_area" array="#arguments.areas_ids#">
		  		
				<!---Esto habría que cambiarlo: si existe archivo, primero hay que duplicarlo y subirlo para que al crear el item se notifique que tiene un adjunto (ahora mismo en la notificacion no viene que hay un archivo adjunto)--->
				
				<cfinvoke component="AreaItem" method="createItem" returnvariable="createItemResult">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="title" value="#arguments.title#">
					<cfinvokeargument name="link" value="#arguments.link#">
					<cfinvokeargument name="description" value="#arguments.description#">
					<cfinvokeargument name="parent_id" value="#cur_area#">
					<cfinvokeargument name="parent_kind" value="area">
					<cfinvokeargument name="area_id" value="#cur_area#">
					<cfinvokeargument name="Filedata" value="#arguments.Filedata#">
					<cfinvokeargument name="imagedata" value="#arguments.imagedata#">
					<!---<cfif isDefined("arguments.copy_attached_file_id")>
					<cfinvokeargument name="copy_attached_file_id" value="#FORM.copy_attached_file_id#">
					</cfif>--->
					<cfif isDefined("arguments.notify_by_sms")>
					<cfinvokeargument name="notify_by_sms" value="#arguments.notify_by_sms#">
					</cfif>
					<cfif isDefined("arguments.post_to_twitter")>
					<cfinvokeargument name="post_to_twitter" value="#arguments.post_to_twitter#">
					</cfif>
					<cfif isDefined("arguments.start_date")>
						<cfinvokeargument name="start_date" value="#arguments.start_date#">
					</cfif>
					<cfif isDefined("arguments.end_date")>
						<cfinvokeargument name="end_date" value="#arguments.end_date#">
					</cfif>
					<cfif isDefined("arguments.start_hour") AND isDefined("arguments.start_minute")>
						<cfinvokeargument name="start_hour" value="#arguments.start_hour#">
						<cfinvokeargument name="start_minute" value="#arguments.start_minute#">
					</cfif>
					<cfif isDefined("arguments.end_hour") AND isDefined("arguments.end_minute")>
						<cfinvokeargument name="end_hour" value="#arguments.end_hour#">
						<cfinvokeargument name="end_minute" value="#arguments.end_minute#">
					</cfif>
					<cfif isDefined("arguments.place")>
						<cfinvokeargument name="place" value="#arguments.place#">
					</cfif>
					<cfif isDefined("arguments.recipient_user")>
						<cfinvokeargument name="recipient_user" value="#arguments.recipient_user#">
					</cfif>
					<cfif isDefined("arguments.estimated_value")>
						<cfinvokeargument name="estimated_value" value="#arguments.estimated_value#">
					</cfif>
					<cfif isDefined("arguments.real_value")>
						<cfinvokeargument name="real_value" value="#arguments.real_value#">
					</cfif>
					<cfif isDefined("arguments.done")>
						<cfinvokeargument name="done" value="#arguments.done#">
					</cfif>
					<cfif isDefined("arguments.position")>
						<cfinvokeargument name="position" value="#arguments.position#">
					</cfif>
					<cfif isDefined("arguments.display_type")>
						<cfinvokeargument name="display_type" value="#arguments.display_type#">
					</cfif>
					<cfif isDefined("arguments.iframe_url")>
						<cfinvokeargument name="iframe_url" value="#arguments.iframe_url#">
					</cfif>
					<cfif isDefined("arguments.iframe_display_type")>
						<cfinvokeargument name="iframe_display_type" value="#arguments.iframe_display_type#">
					</cfif>
				</cfinvoke>
				
				<cfif createItemResult.result IS NOT true>
					
					<cfset response_message = "Ha ocurrido un error al copiar el #itemTypeNameEs#. #createItemResult.message#">
					<cfset response = {result="false", message=#response_message#}>
					<cfreturn response>
					
				</cfif>
			
				<!---Copia el archivo adjunto (si no se adjunta uno nuevo)--->
				<cfif len(arguments.Filedata) IS 0 AND isDefined("arguments.copy_attached_file_id")>
					<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="addFileToItem" returnvariable="objectFile">
						<cfinvokeargument name="file_id" value="#arguments.copy_attached_file_id#">
						<cfinvokeargument name="item_id" value="#createItemResult.item_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="file_type" value="file">
					</cfinvoke>				
				</cfif>
				
				<!---Copia la imagen (si no se adjunta una nueva)--->
				<cfif len(arguments.imagedata) IS 0 AND isDefined("arguments.copy_attached_image_id")>
					<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="addFileToItem" returnvariable="objectImage">
						<cfinvokeargument name="file_id" value="#arguments.copy_attached_image_id#">
						<cfinvokeargument name="item_id" value="#createItemResult.item_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="file_type" value="image">
					</cfinvoke>				
				</cfif>
				
			</cfloop>
		  	
			<cfif itemTypeGender IS "male">
				<cfset response_message = "#itemTypeNameEs# copiado a las áreas seleccionadas">
			<cfelse>
				<cfset response_message = "#itemTypeNameEs# copiada a las áreas seleccionadas">
			</cfif>
			<cfset response = {result="true", message=#response_message#}>
			<cfreturn response>			
            
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	
	
	
	<!--- --------------------------------tweetItem----------------------------------- --->
	
	<cffunction name="postItemToTwitter" returntype="void" access="remote">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="content" type="string" required="true">
		<cfargument name="return_path" type="string" required="true">
		
		<cfset var method = "postItemToTwitter">
		
		<cfset var response_page= "">
		<cfset var request_parameters = "">
		<cfset var msg = "">
		
		<cftry>
			
			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<cfset request_parameters = '<#itemTypeName# id="#arguments.item_id#"/>'>
			<cfset request_parameters = request_parameters&'<area id="#arguments.area_id#"/>'>
			<cfset request_parameters = request_parameters&'<tweet><content><![CDATA[#arguments.content#]]></content></tweet>'>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#itemTypeNameU#Manager">
				<cfinvokeargument name="request_method" value="post#itemTypeNameU#ToTwitter">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
			
			<cfif itemTypeGender EQ "male">
				<cfset msg = "#itemTypeNameEs# publicado en Twitter.">
			<cfelse>
				<cfset msg = "#itemTypeNameEs# publicada en Twitter.">
			</cfif>
			<cfset msg = URLEncodedFormat(msg)>
            
            <cflocation url="#return_path##itemTypeNameP#.cfm?area=#arguments.area_id#&msg=#msg#&res=1" addtoken="no">	
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	
	<cffunction name="deleteItem" returntype="void" access="remote">
		<cfargument name="item_id" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="return_page" type="string" required="true">
		
		<cfset var method = "deleteItem">
		
		<cfset var response_page= "">
		<cfset var request_parameters = "">
		
		<cftry>
			
			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<!---<cfif isDefined("arguments.return_page")>
				<cfset response_page = arguments.return_page>
			<cfelse>
				<cfset response_page = "#itemTypeNameP#.cfm?area=#arguments.area_id#">
			</cfif>--->
			
			<cfif len(arguments.item_id) IS 0 OR NOT isValid("integer",arguments.item_id)>
			
				<cfset item = "#itemTypeNameEs# incorrecto.">
				<cfset item = URLEncodedFormat(item)>
				<cflocation url="#APPLICATION.htmlPath#/#response_page#&item=#item#" addtoken="no">
			
			</cfif>
			
			<cfset request_parameters = '<#itemTypeName# id="#arguments.item_id#"/>'>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#itemTypeNameU#Manager">
				<cfinvokeargument name="request_method" value="delete#itemTypeNameU#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>	
			
			<cfif itemTypeGender EQ "male">
				<cfset msg = "#itemTypeNameEs# eliminado.">
			<cfelse>
				<cfset msg = "#itemTypeNameEs# eliminada.">
			</cfif>
			<cfset msg = URLEncodedFormat(msg)>
            
            <cflocation url="#arguments.return_page#&message=#msg#" addtoken="no">	
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	<!--- ----------------------- DELETE ITEM ATTACHED FILE -------------------------------- --->
	
	<cffunction name="deleteItemAttachedFileRemote" returntype="void" access="remote">
		<cfargument name="item_id" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="return_page" type="string" required="true">
		
		<cfset var method = "deleteItemAttachedFile">
		
		<cfset var request_parameters = "">
		
		<cftry>
			
			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<cfif len(arguments.item_id) IS 0 OR NOT isValid("integer",arguments.item_id)>
			
				<cfset msg = "#itemTypeNameEs# incorrecto.">
				<cfset msg = URLEncodedFormat(msg)>
				<cflocation url="#arguments.return_page#&res=0&msg=#msg#" addtoken="no">
			
			</cfif>
			
			<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="deleteItemAttachedFile" returnvariable="xmlResponseContent">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
			</cfinvoke>	
			
			
			<cfset msg = "Archivo eliminado.">
			<cfset msg = URLEncodedFormat(msg)>
            
            <cflocation url="#arguments.return_page#&res=1&msg=#msg#" addtoken="no">	
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	
	<!--- ----------------------- DELETE ITEM ATTACHED IMAGE -------------------------------- --->
	
	<cffunction name="deleteItemAttachedImageRemote" returntype="void" access="remote">
		<cfargument name="item_id" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="return_page" type="string" required="true">
		
		<cfset var method = "deleteItemAttachedImage">
		
		<cfset var request_parameters = "">
		
		<cftry>
			
			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<cfif len(arguments.item_id) IS 0 OR NOT isValid("integer",arguments.item_id)>
			
				<cfset msg = "#itemTypeNameEs# incorrecto.">
				<cfset msg = URLEncodedFormat(msg)>
				<cflocation url="#arguments.return_page#&res=0&msg=#msg#" addtoken="no">
			
			</cfif>
			
			<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="deleteItemAttachedImage" returnvariable="xmlResponseContent">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
			</cfinvoke>	
			
			
			<cfset msg = "Imagen eliminada.">
			<cfset msg = URLEncodedFormat(msg)>
            
            <cflocation url="#arguments.return_page#&res=1&msg=#msg#" addtoken="no">	
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	
	
	
	
	<!--- ----------------------------------- getAreaItemsList ------------------------------------- --->
	
	<cffunction name="getAreaItemsList" returntype="xml" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		
		<cfset var method = "getAreaItemsList">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
			
		<cftry>
			
			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<area id="#arguments.area_id#"/>
					<format content="default"/>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#itemTypeNameU#Manager">
				<cfinvokeargument name="request_method" value="getArea#itemTypeNameP#List">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	<!--- ----------------------------------- getAreaItemsTree ------------------------------------- --->
	
	<cffunction name="getAreaItemsTree" returntype="xml" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		
		<cfset var method = "getAreaItemsTree">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
			
		<cftry>
			
			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<area id="#arguments.area_id#"/>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#itemTypeNameU#Manager">
				<cfinvokeargument name="request_method" value="getArea#itemTypeNameU#sTree">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	
	<!--- ----------------------- GET ALL AREAS ITEMS -------------------------------- --->
	
	<cffunction name="getAllAreasItems" returntype="string" access="public">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="user_in_charge" type="numeric" required="no">
		<cfargument name="recipient_user" type="numeric" required="no">
		<cfargument name="limit" type="numeric" required="no">
		
		<cfset var method = "getAllAreasItems">
		
		<cfset var request_parameters = "">
		
		<cftry>
			
			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="getAllAreasItems" returnvariable="xmlResponseContent">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfif isDefined("arguments.user_in_charge")>
				<cfinvokeargument name="user_in_charge" value="#arguments.user_in_charge#">
				</cfif>
				<cfif isDefined("arguments.recipient_user")>
				<cfinvokeargument name="recipient_user" value="#arguments.recipient_user#">
				</cfif>
				<cfif IsDefined("arguments.limit")>
				<cfinvokeargument name="limit" value="#arguments.limit#">
				</cfif>
				<cfinvokeargument name="with_area" value="true">
			</cfinvoke>	
			
			<cfreturn xmlResponseContent>
            
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
		
	
	<cffunction name="outputItem" returntype="void" output="true" access="public">
		<cfargument name="objectItem" type="struct" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="itemTypeName" type="string" required="true">
		<!---<cfargument name="contact_format" type="boolean" required="false" default="false">--->
		
		<cfset var method = "outputItem">
		
		<cftry>
			
			<cfif len(objectItem.description) GT 0>
		
				<cfset objectItem.description = REReplace(objectItem.description,'[[:space:]]SIZE="',' style="font-size:',"ALL")>
			
			</cfif>
			
			<cfoutput>
				<div class="div_message_page_title">#objectItem.title#</div>
				<div class="div_separator"><!-- --></div>
				<div class="div_message_page_message">
					<div class="div_message_page_label">De: <span class="text_message_page">#objectItem.user_full_name#</span></div>
					
					<cfif itemTypeId IS 6><!---Tasks--->
						<div class="div_message_page_label">Asignada a: <span class="text_message_page">#objectItem.recipient_user_full_name#</span></div>
					</cfif>
					
					<div class="div_message_page_label">Fecha creación: <span class="text_message_page">#objectItem.creation_date#</span></div>
					<cfif itemTypeId IS NOT 1>
						<cfif len(objectItem.last_update_date) GT 0>
						<div class="div_message_page_label">Fecha de última modificación: <span class="text_message_page">#objectItem.last_update_date#</span></div>
						</cfif>
					</cfif>
					
					<!---<div class="div_message_page_date"></div>--->
					<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->
					<div class="div_message_page_label">Fecha de inicio<cfif itemTypeId IS 5> del evento</cfif>: <span class="text_message_page">#<!---DateFormat(--->objectItem.start_date<!---,APPLICATION.dateFormat)--->#</span>
					<cfif itemTypeId IS 5><span class="texto_gris_12px">Hora:</span> <span class="text_message_page">#TimeFormat(objectItem.start_time,"HH:mm")#</span></cfif>
					</div>
					<div class="div_message_page_label">Fecha de fin<cfif itemTypeId IS 5> del evento</cfif>: <span class="text_message_page">#<!---DateFormat(--->objectItem.end_date<!---,APPLICATION.dateFormat)--->#</span> 
					<cfif itemTypeId IS 5><span class="texto_gris_12px">Hora:</span> <span class="text_message_page">#TimeFormat(objectItem.end_time,"HH:mm")#</span></cfif>
					</div>
					
						<cfif itemTypeId IS 5><!---Events--->
						<div class="div_message_page_label">Lugar: <span class="text_message_page">#objectItem.place#</span></div>
						<cfelse><!---Tasks--->
						<div class="div_message_page_label">Valor estimado: <span class="text_message_page">#objectItem.estimated_value#</span></div>
						<div class="div_message_page_label">Valor real: <span class="text_message_page">#objectItem.real_value#</span></div>
						<div class="div_message_page_label">Realizada: <span class="text_message_page"><cfif objectItem.done IS true>Sí<cfelse>No</cfif></span></div>
						</cfif>
					
					</cfif>				
					
							
					<cfif isNumeric(objectItem.attached_file_id)>
					<div class="div_message_page_label">Archivo adjunto: </div>
					<div class="div_message_page_file"><a onclick="downloadFile('#APPLICATION.htmlPath#/file_download.cfm?id=#objectItem.attached_file_id#&#itemTypeName#=#objectItem.id#')" style="cursor:pointer">#objectItem.attached_file_name#</a></div>
					</cfif>
					<cfif isNumeric(objectItem.attached_image_id)>
					<div class="div_message_page_label">Imagen adjunta: </div>
					<div class="div_message_page_file"><a onclick="downloadFile('#APPLICATION.htmlPath#/file_download.cfm?id=#objectItem.attached_image_id#&#itemTypeName#=#objectItem.id#')" style="cursor:pointer">#objectItem.attached_image_name#</a></div>
					</cfif>
					
					
									
					<cfif len(objectItem.link) GT 0>
					<div class="div_message_page_label"><cfif itemTypeId IS 3>URL del enlace<cfelse>Más información</cfif>:</div>
					<div class="div_message_page_file"><a href="#objectItem.link#" target="_blank">#objectItem.link#</a></div>
					</cfif>
					<cfif len(objectItem.iframe_url) GT 0>
					<div class="div_message_page_label">URL contenido incrustado:</div>
					<div class="div_message_page_file"><a href="#objectItem.iframe_url#" target="_blank">#objectItem.iframe_url#</a></div>
					</cfif>
					
					<div class="div_message_page_label"><cfif itemTypeId IS 3>Descripción<cfelse>Contenido</cfif>:</div> 
					<div class="div_message_page_description">#objectItem.description#</div>
				</div>
			</cfoutput>								
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	
	<cffunction name="outputItemsList" returntype="void" output="true" access="public">
		<cfargument name="xmlItems" type="xml" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="full_content" type="boolean" required="no" default="false">
		<cfargument name="return_page" type="string" required="yes">
		
		<cfset var method = "outputItemsList">

		<cftry>
		
			<!---Required vars
				page_type
				
				page_types:

			--->
			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			
			<cfset numItems = ArrayLen(xmlItems.xmlChildren[1].XmlChildren)>

			<cfif numItems GT 0>
				
				<script type="text/javascript">
					$(document).ready(function() { 
						
						$.tablesorter.addParser({
							id: "datetime",
							is: function(s) {
								return false; 
							},
							format: function(s,table) {
								s = s.replace(/\-/g,"/");
								s = s.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/, "$3/$2/$1");
								return $.tablesorter.formatFloat(new Date(s).getTime());
							},
							type: "numeric"
						});
						
						$("##listTable").tablesorter({ 
							widgets: ['zebra'],
							<cfif itemTypeId IS 6><!---Tasks--->
								<cfif arguments.full_content IS false>
								sortList: [[6,1]] ,
								<cfelse>
								sortList: [[7,0],[8,0]] ,
								</cfif>
							<cfelseif itemTypeId IS 2 OR itemTypeId IS 3><!---Entries, Links Order by position--->
								sortList: [[4,0]] ,
							<cfelse>
								sortList: [[3,1]] ,
							</cfif>
							headers: { 
								0: { 
									sorter: false 
								},
								<cfif itemTypeId IS NOT 6>
								3: { 
									sorter: "datetime" 
								}
								<cfelse>
									<cfif arguments.full_content IS false>
									6: { 
										sorter: "datetime" 
									}
									<cfelse>
									7: { 
										sorter: "datetime" 
									},
									8: { 
										sorter: "datetime" 
									}
									</cfif>
								</cfif>
							} 
						});
						
						//  Adds "over" class to rows on mouseover
						$("##listTable tr").mouseover(function(){
						  $(this).addClass("over");
						});
					
						//  Removes "over" class from rows on mouseout
						$("##listTable tr").mouseout(function(){
						  $(this).removeClass("over");
						});
						
					}); 
				</script>
				
				<cfoutput>
				<table id="listTable" class="tablesorter">
					<thead>
						<tr>
							<cfif itemTypeId IS NOT 6>
								<th style="width:35px"></th>
								<cfif arguments.full_content IS false>
									<cfif itemTypeId IS 1><!---Messages--->
										<th style="width:50%">Asunto</th>
									<cfelseif itemTypeId IS 2 OR itemTypeId IS 3><!---Entries, Links--->
										<th style="width:44%">Título</th>
									<cfelse>
										<th style="width:50%">Título</th>
									</cfif>
									<th style="width:23%">De</th>
									<th style="width:22%">Fecha</th>
									<cfif itemTypeId IS 2 OR itemTypeId IS 3><!---Entries, Links--->
									<th style="width:6%">##</th>
									</cfif>
								<cfelse>
									<th style="width:34%"><cfif itemTypeId IS 1>Asunto<cfelse>Título</cfif></th>
									<th style="width:20%">De</th>
									<th style="width:20%">Fecha</th>
									<th style="width:22%">Área</th>
								</cfif>
							<cfelse><!---Tasks--->
								<th style="width:35px"></th>
								<cfif arguments.full_content IS false>
								<th style="width:27%">Título</th>
								<th style="width:17%">De</th>
								<th style="width:17%">Para</th>
								<th style="width:9%">Hecha</th>
								<th style="width:6%">VE</th>
								<th style="width:6%">VR</th>		
								<th style="width:14%">Creación</th>
								<cfelse>
								<th style="width:23%">Título</th>
								<th style="width:15%">De</th>
								<th style="width:15%">Para</th>
								<th style="width:8%">Hecha</th>
								<th style="width:6%">VE</th>
								<th style="width:6%">VR</th>
								<th style="width:6%">Fin</th>		
								<th style="width:6%">Creación</th>
								<th style="width:12%">Área</th>
								</cfif>					
							</cfif>
						</tr>
					</thead>
					
					<tbody>
					<cfloop index="xmlIndex" from="1" to="#numItems#" step="1">
						
						<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="objectItem" returnvariable="objectItem">
							<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
							<cfinvokeargument name="xml" value="#xmlItems.xmlChildren[1].xmlChildren[xmlIndex]#">
							<cfinvokeargument name="return_type" value="object">
						</cfinvoke>	
						
						<tr onclick="goToUrl('#itemTypeName#.cfm?#itemTypeName#=#objectItem.id#&return_page=#URLEncodedFormat(arguments.return_page)#')">
							<td>
								<cfif itemTypeId IS 6><!---Tasks--->
									
									<cfif objectItem.done IS true>
										<!---href="#itemTypeName#.cfm?#itemTypeName#=#objectItem.id#&return_page=#URLEncodedFormat(arguments.return_page)#"--->
										<img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_done.png" alt="Tarea realizada" title="Tarea realizada"/>
									<cfelse>
										<img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_not_done.png" alt="Tarea no realizada" title="Tarea no realizada"/>
									</cfif>
									
								<cfelseif itemTypeId IS NOT 3><!---No es link--->
									<cfif len(objectItem.attached_file_name) GT 0 AND objectItem.attached_file_name NEQ "-">
										<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#objectItem.attached_file_id#&#itemTypeName#=#objectItem.id#" style="float:left;"><img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_with_attached.png"/></a>
									<cfelse>
										<a href="#itemTypeName#.cfm?#itemTypeName#=#objectItem.id#&return_page=#URLEncodedFormat(arguments.return_page)#" style="float:left;"><img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#.png"/></a>
									</cfif>
								<cfelse>
									<a href="#APPLICATION.htmlPath#/go_to_link_link.cfm?#itemTypeName#=#objectItem.id#" style="float:left;" target="_blank" title="Visitar el enlace" onclick="event.stopPropagation()"><img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#.png"/></a>
								</cfif>
							</td>
							<td><a href="#itemTypeName#.cfm?#itemTypeName#=#objectItem.id#&return_page=#URLEncodedFormat(arguments.return_page)#" class="text_message_title">#objectItem.title#</a></td>
							<td><span class="text_message_data">#objectItem.user_full_name#</span></td>
							<cfif arguments.itemTypeId IS 6><!---Tasks--->
							<td><span class="text_message_data">#objectItem.recipient_user_full_name#</span></td>
							<td><span class="text_message_data" <cfif arguments.itemTypeId IS 6 AND objectItem.done IS false>style="color:##C61704"</cfif>><cfif objectItem.done IS true>Sí<cfelse>No</cfif></span></td>
							<td><span class="text_message_data">#objectItem.estimated_value#</span></td>
							<td><span class="text_message_data">#objectItem.real_value#</span></td>
							</cfif>
							<cfif arguments.itemTypeId IS 6 AND arguments.full_content IS true>
							<td><span class="text_message_data">#DateFormat(objectItem.end_date,APPLICATION.dateFormat)#</span></td>
							</cfif>
							<td><span class="text_message_data">#objectItem.creation_date#</span></td>
							<cfif arguments.full_content IS true>
								<td><a href="area.cfm?area=#objectItem.area_id#" onclick="event.stopPropagation()" target="_blank" class="link_blue">#objectItem.area_name#</a></td>
							<cfelse>
								<cfif itemTypeId IS 2 OR itemTypeId IS 3><!---Entries, Links--->
								<td style="vertical-align:middle"><span class="text_message_data" style="line-height:30px;">#objectItem.position#</span><div style="float:right;clear:none;"><a href="area_item_position_up.cfm?item=#objectItem.id#&type=#itemTypeId#&area=#objectItem.area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/up.jpg" alt="Subir" title="Subir"/></a><br/><a href="area_item_position_down.cfm?item=#objectItem.id#&type=#itemTypeId#&area=#objectItem.area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/down.jpg" alt="Bajar" title="Bajar" style="margin-top:2px;"/></a></div></td>
								</cfif>
							</cfif>
							
						</tr>
					</cfloop>
					</tbody>
				
				</table>
				</cfoutput>
			</cfif>
								
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
</cfcomponent>