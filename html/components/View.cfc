<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="true">

	<cfset component = "View">

	<cfset dateFormat = "%d-%m-%Y"><!---%H:%i:%s---><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset dateTimeFormat = "%d-%m-%Y %H:%i:%s">
	<cfset timeZoneTo = "+1:00">


	<!--- ----------------------------------- getView -------------------------------------- --->

	<!---Este método no hay que usarlo en páginas en las que su contenido se cague con JavaScript (páginas de html_content) porque si hay un error este método redirige a otra página. En esas páginas hay que obtener el Item directamente del AreaItemManager y comprobar si result es true o false para ver si hay error y mostrarlo correctamente--->

	<cffunction name="getView" output="false" returntype="query" access="public">
		<cfargument name="view_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_table" type="numeric" required="false" default="true">

		<cfset var method = "getView">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/ViewManager" method="getView" returnvariable="response">
				<cfinvokeargument name="view_id" value="#arguments.view_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="with_table" value="#arguments.with_table#"/>
				<cfinvokeargument name="parse_dates" value="true">
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response.view>
			
	</cffunction>


	<!--- ----------------------------------- getEmptyView -------------------------------------- --->

	<cffunction name="getEmptyView" output="false" returntype="query" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getEmptyView">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/ViewManager" method="getEmptyView" returnvariable="response">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response.view>
			
	</cffunction>


	<!--- -------------------------------createView-------------------------------------- --->
	
    <cffunction name="createView" returntype="struct" access="public">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="fields_ids" type="array" required="true">
		<cfargument name="include_creation_date" type="boolean" required="false" default="false">
		<cfargument name="include_last_update_date" type="boolean" required="false" default="false">
		<cfargument name="include_insert_user" type="boolean" required="false" default="false">
		<cfargument name="include_update_user" type="boolean" required="false" default="false">
				
		<cfset var method = "createView">

		<cfset var response = structNew()>
		
		<cftry>
					
			<cfinvoke component="#APPLICATION.componentsPath#/ViewManager" method="createView" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Vista creada">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>


	<!--- -------------------------------updateView-------------------------------------- --->
	
    <cffunction name="updateView" returntype="struct" access="public">
    	<cfargument name="view_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="fields_ids" type="array" required="true">
		<cfargument name="include_creation_date" type="boolean" required="false" default="false">
		<cfargument name="include_last_update_date" type="boolean" required="false" default="false">
		<cfargument name="include_insert_user" type="boolean" required="false" default="false">
		<cfargument name="include_update_user" type="boolean" required="false" default="false">
		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_hour" type="numeric" required="false">
		<cfargument name="publication_minute" type="numeric" required="false">
		<cfargument name="publication_validated" type="boolean" required="false">
		
		<cfset var method = "updateView">

		<cfset var response = structNew()>
		
		<cftry>
					
			<cfinvoke component="#APPLICATION.componentsPath#/ViewManager" method="updateView" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Vista modificada">
			</cfif>
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>



	<!--- ----------------------------------- getViewFields ------------------------------------- --->
	
	<cffunction name="getViewFields" returntype="struct" access="public">
		<cfargument name="view_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_types" type="boolean" required="false" default="false">
		<cfargument name="with_view_extra_fields" type="boolean" required="false" default="false">

		<cfset var method = "getTableFields">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/ViewManager" method="getViewFields" returnvariable="response">
				<cfinvokeargument name="view_id" value="#arguments.view_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="with_types" value="#arguments.with_types#"/>
				<cfinvokeargument name="with_view_extra_fields" value="#arguments.with_view_extra_fields#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>


	<!--- ----------------------------------- getViewRows ------------------------------------- --->
	
	<cffunction name="getViewRows" returntype="struct" access="public">
		<cfargument name="view_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfset var method = "getViewRows">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="getViewRows" returnvariable="response">
				<cfinvokeargument name="view_id" value="#arguments.view_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>


	<!--- -------------------------------deleteViewRemote-------------------------------------- --->
	
    <cffunction name="deleteViewRemote" returntype="void" access="remote">
    	<cfargument name="view_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		
		<cfargument name="return_path" type="string" required="yes">
		
		<cfset var method = "deleteViewRemote">

		<cfset var response = structNew()>
		
		<cftry>
					
			<cfinvoke component="#APPLICATION.componentsPath#/ViewManager" method="deleteView" returnvariable="response">
				<cfinvokeargument name="view_id" value="#arguments.view_id#"/>
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#"/>
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Vista eliminada">
			</cfif>
			
			<cfset msg = URLEncodedFormat(response.message)>
			
			<cflocation url="#arguments.return_path#&res=#response.result#&msg=#msg#" addtoken="no">		
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>



</cfcomponent>