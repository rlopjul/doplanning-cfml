<!---Copyright Era7 Information Technologies 2007-2012

	Date of file creation: 30-09-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	
--->
<cfcomponent output="false">

	<cfset component = "Area">
	<cfset request_component = "AreaManager">
	
	<!--- ----------------------------------- getMainTree -------------------------------------- --->

	<cffunction name="getMainTree" output="false" returntype="struct" access="public">
		
		<cfset var method = "getMainTree">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getMainTree" returnvariable="response">
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>


	<!--- ----------------------------------- getMainTreeAdmin -------------------------------------- --->

	<cffunction name="getMainTreeAdmin" output="false" returntype="struct" access="public">
		
		<cfset var method = "getMainTreeAdmin">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getMainTreeAdmin" returnvariable="response">
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>
	
	
	
	<!--- ----------------------------------- getAreaContent -------------------------------------- --->
	
	<cffunction name="getAreaContent" returntype="xml" output="false" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="allowed" type="boolean" required="yes"> 
		<cfargument name="areaType" type="string" required="no" default="">
	
		<cfset var method = "getAreaContent">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		<cfset var response = "">
		
		<cftry>
			
			<!---checkAreaAccess--->
			<!---No se chequea porque se tiene que poder acceder a las areas que hay dentro por si tenemos acceso a alguna--->
						
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaContent" returnvariable="response">				
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="allowed" value="#arguments.allowed#">
				<cfinvokeargument name="areaType" value="#arguments.areaType#">
				
				<cfinvokeargument name="withSubAreas" value="true">
				<cfinvokeargument name="withSubSubAreas" value="false">
			</cfinvoke>
			
			<cfxml variable="xmlResponse">
				<cfoutput>
				#response#
				</cfoutput>
			</cfxml>
			
			
			<cfcatch>
			
				<!---Esto está puesto aquí para intentar detectar un error que daba--->	
				<cfinvoke component="#APPLICATION.componentsPath#/EmailManager" method="sendEmail">
					<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
					<cfinvokeargument name="to" value="alucena@era7.com">
					<cfinvokeargument name="bcc" value="">
					<cfinvokeargument name="subject" value="Error en #APPLICATION.title# getAreaContent">
					<cfinvokeargument name="content" value="#arguments.area_id# #response#">
					<cfinvokeargument name="foot_content" value="">
				</cfinvoke>
			
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- ----------------------------------- getParentAreaId -------------------------------------- --->
	
	<!---<cffunction name="getParentAreaId" returntype="numeric" access="public">
		<cfargument name="area_id" type="numeric" required="true">
	
		<cfset var method = "getParentAreaId">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<cfset var parent_area_id = "">
		
		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/#request_component#" method="#method#" returnvariable="parent_area_id">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">			
			</cfinvoke>		
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn parent_area_id>
		
	</cffunction>--->
	
	<!--- ----------------------------------- getArea ------------------------------------- --->
	
	<!---Este método NO hay que usarlo en páginas en las que su contenido se cague con JavaScript (páginas de html_content) porque si hay un error este método redirige a otra página. En esas páginas hay que obtener el Area directamente del AreaManager y comprobar si result es true o false para ver si hay error y mostrarlo correctamente--->
	
	<cffunction name="getArea" output="false" returntype="query" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		
		<cfset var method = "getArea">
		
		<cfset var objectArea = structNew()>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getArea" returnvariable="objectArea">				
				<cfinvokeargument name="get_area_id" value="#arguments.area_id#">
				<cfinvokeargument name="return_type" value="query">
			</cfinvoke>
			
			<cfcatch>
				<!--- En las páginas en las que se carga con JavaScript el contenido no debe haber redirecciones a otras páginas
				EN EL CASO DE ESTAS PÁGINAS NO HAY QUE USAR ESTE MÉTODO, HAY QUE USAR DIRECTAMENTE getArea de AreaManager y comprobar en el resultado si es true o false para mostrar si hay error--->
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn objectArea>
		
	</cffunction>
	
	
	<!--- ----------------------------------- canUserAccessToArea ------------------------------------- --->
	
	<cffunction name="canUserAccessToArea" output="false" returntype="boolean" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		
		<cfset var method = "canUserAccessToArea">
		
		<cfset var access_result = false>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="canUserAccessToArea" returnvariable="access_result">				
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn access_result>
		
	</cffunction>
	

	<!--- ----------------------------------- isUserAreaResponsible ------------------------------------- --->
	
	<cffunction name="isUserAreaResponsible" output="false" returntype="boolean" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		
		<cfset var method = "isUserAreaResponsible">
		
		<cfset var access_result = false>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="isUserAreaResponsible" returnvariable="access_result">				
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn access_result>
		
	</cffunction>
	
	
	<!--- ----------------------------------- getAreaType ------------------------------------- --->
	
	<cffunction name="getAreaType" output="false" returntype="string" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfset var method = "getAreaType">
		
		<cfset var areaType = "">
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="#method#" returnvariable="areaTypeResult">				
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn areaTypeResult.areaType>
		
	</cffunction>
	
	
	
	<!--- ----------------------------------- getAreaFiles ------------------------------------- --->
	
	<cffunction name="getAreaFiles" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		
		<cfset var method = "getAreaFiles">
		
		<cfset var response = structNew()>
		
		<cftry>
			
			<!---<cfsavecontent variable="request_parameters">
				<cfoutput>
					<area id="#arguments.area_id#"/>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>--->
			
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaFiles" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>
	
	<!--- ----------------------------------- getAreaMembers ------------------------------------- --->
	
	<cffunction name="getAreaMembers" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="order_by" type="string" required="false" default="family_name">
		<cfargument name="order_type" type="string" required="false" default="asc">
		
		<cfset var method = "getAreaMembers">
		
		<cfset var response = structNew()>
		
		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaMembers" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="order_by" value="#arguments.order_by#"/>
				<cfinvokeargument name="order_type" value="#arguments.order_type#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>				
																							
		</cftry>
		
		<cfreturn response>
			
		
	</cffunction>


	<!--- ----------------------------------- createArea -------------------------------------- --->

	<cffunction name="createArea" output="false" returntype="struct" returnformat="json" access="remote">
		
		<cfset var method = "createArea">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="createArea" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Área creada">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>


	<!--- ----------------------------------- importAreas -------------------------------------- --->

	<cffunction name="importAreas" output="true" returntype="void" access="remote">
		<!---NO se puede usar returnformat="json" porque da problemas con la subida de archivos en IE--->
		
		<cfset var method = "importAreas">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="importAreas" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "#response.areasCount# áreas importadas">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<!---<cfreturn serializeJSON(response)>--->

		<cfoutput>#serializeJSON(response)#</cfoutput>
			
	</cffunction>


	<!--- ----------------------------------- updateArea -------------------------------------- --->

	<cffunction name="updateArea" output="false" returntype="struct" returnformat="json" access="remote">
		<cfargument name="area_id" type="numeric" required="true"/>
		
		<cfset var method = "updateArea">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="updateArea" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Área modificada">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>


	<!--- ----------------------------------- moveArea -------------------------------------- --->

	<cffunction name="moveArea" output="false" returntype="struct" returnformat="json" access="remote">
		<cfargument name="area_id" type="numeric" required="true"/>
		<cfargument name="parent_id" type="numeric" required="true"/>
		
		<cfset var method = "moveArea">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="updateArea" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Área movida">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>


	<!--- ----------------------------------- updateAreaImage -------------------------------------- --->

	<cffunction name="updateAreaImage" output="false" returntype="struct" returnformat="json" access="remote">
		<cfargument name="area_id" type="numeric" required="true"/>
		
		<cfset var method = "updateArea">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="updateArea" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Imagen de área modificada">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>


	<!--- ----------------------------------- deleteArea -------------------------------------- --->

	<cffunction name="deleteArea" output="false" returntype="struct" returnformat="json" access="remote">
		<cfargument name="area_id" type="numeric" required="true"/>
		
		<cfset var method = "deleteArea">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="deleteArea" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Área eliminada">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>



	<!--- ----------------------------------- outputSubAreasSelect ------------------------------------- --->
	
	<cffunction name="outputSubAreasSelect" output="true" access="public" returntype="void">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="selected_areas_ids" type="string" required="false">
		<cfargument name="level" type="numeric" required="false" default="1">
		<cfargument name="recursive" type="boolean" required="false" default="false">
		
		<cfset var method = "outputSubAreasSelect">
				
		<cftry>

			<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaHtml" method="outputSubAreasSelect">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="selected_areas_ids" value="#arguments.selected_areas_ids#">
				<cfinvokeargument name="level" value="#arguments.level#">
				<cfinvokeargument name="recursive" value="#arguments.recursive#">

				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirect.cfm">
			</cfcatch>				
																							
		</cftry>			
		
	</cffunction>

	
</cfcomponent>