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
	
	<cffunction name="getArea" output="false" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		
		<cfset var method = "getArea">
		
		<cfset var objectArea = structNew()>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getArea" returnvariable="objectArea">				
				<cfinvokeargument name="get_area_id" value="#arguments.area_id#">
				<cfinvokeargument name="return_type" value="object">
			</cfinvoke>
			
			<cfcatch>
				<!--- Esto hay que cambiarlo porque en las páginas en las que se carga con JavaScript el contenido no debe haber redirecciones a otras páginas--->
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn objectArea>
		
	</cffunction>
	
	
	<!--- ----------------------------------- canUserAccessToArea ------------------------------------- --->
	
	<cffunction name="canUserAccessToArea" output="false" returntype="boolean" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfset var method = "canUserAccessToArea">
		
		<cfset var access_result = false>
		
		<cftry>
			
			<!---<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAllUserAreasList" returnvariable="allUserAreasList">
				<cfinvokeargument name="get_user_id" value="#SESSION.user_id#">
			</cfinvoke>--->
			
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="#method#" returnvariable="access_result">				
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<!---<cfinvokeargument name="allUserAreasList" value="#allUserAreasList#">--->
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
	
	<cffunction name="getAreaFiles" returntype="xml" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		
		<cfset var method = "getAreaFiles">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<cftry>
			
			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<area id="#arguments.area_id#"/>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	<!--- ----------------------------------- getAreaMembers ------------------------------------- --->
	
	<cffunction name="getAreaMembers" returntype="xml" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="order_by" type="string" required="false" default="">
		<cfargument name="order_type" type="string" required="false" default="asc">
		
		<cfset var method = "getAreaMembers">
		
		<cfset var response = structNew()>
		
		<cftry>
			
			<!--- 
			<cfsavecontent variable="request_parameters">
							<cfoutput>
								<area id="#arguments.area_id#"/>
								<cfif len(arguments.order_by) GT 0>
								<order parameter="#arguments.order_by#" order_type="#arguments.order_type#"/>
								</cfif>
							</cfoutput>
						</cfsavecontent>
						
						<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
							<cfinvokeargument name="request_component" value="#request_component#">
							<cfinvokeargument name="request_method" value="#method#">
							<cfinvokeargument name="request_parameters" value="#request_parameters#">
						</cfinvoke>
						
						<cfcatch>
							<cfinclude template="includes/errorHandler.cfm">
						</cfcatch>										
						
					</cftry>
					
					<cfreturn xmlResponse> --->

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


	<!--- ----------------------------------- updateArea -------------------------------------- --->

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

	
</cfcomponent>