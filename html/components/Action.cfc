<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="true">

	<cfset component = "Action">
	<cfset request_component = "ActionManager">


	<!--- ----------------------------------- getActionTypes ------------------------------------- --->
	
	<cffunction name="getActionTypes" returntype="struct" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfset var method = "getActionTypes">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/ActionManager" method="getActionTypes" returnvariable="response">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>


	<!--- ----------------------------------- getAction -------------------------------------- --->

	<!---Este método no hay que usarlo en páginas en las que su contenido se cague con JavaScript (páginas de html_content) porque si hay un error este método redirige a otra página. En esas páginas hay que obtener el Item directamente del AreaItemManager y comprobar si result es true o false para ver si hay error y mostrarlo correctamente--->

	<cffunction name="getAction" output="false" returntype="query" access="public">
		<cfargument name="action_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_table" type="numeric" required="false" default="false">

		<cfset var method = "getAction">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/ActionManager" method="getAction" returnvariable="response">
				<cfinvokeargument name="action_id" value="#arguments.action_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="with_table" value="#arguments.with_table#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response.action>
			
	</cffunction>


	<!--- ----------------------------------- getEmptyAction -------------------------------------- --->

	<cffunction name="getEmptyAction" output="false" returntype="query" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getEmptyAction">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/ActionManager" method="getEmptyAction" returnvariable="response">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response.action>
			
	</cffunction>


	<!--- ----------------------------------- getActionFields -------------------------------------- --->

	<cffunction name="getActionFields" output="false" returntype="struct" access="public">
		<cfargument name="action_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getActionFields">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/ActionManager" method="getActionFields" returnvariable="response">
				<cfinvokeargument name="action_id" value="#arguments.action_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>


	<!--- -------------------------------createAction-------------------------------------- --->
	
    <cffunction name="createAction" returntype="struct" access="public">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="action_type_id" type="numeric" required="true">
		<cfargument name="action_event_type_id" type="numeric" required="true">
		<cfargument name="action_subject" type="string" required="true">
		<cfargument name="action_content" type="string" required="true">
		<cfargument name="action_content_with_row" type="boolean" required="false" default="false">
		<cfargument name="action_field_id" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">

		<cfset var method = "createAction">

		<cfset var response = structNew()>
		
		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/ActionManager" method="createAction" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Acción creada">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>


	<!--- -------------------------------updateAction-------------------------------------- --->
	
    <cffunction name="updateAction" returntype="struct" access="public">
    	<cfargument name="action_id" type="numeric" required="true">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="action_type_id" type="numeric" required="true">
		<cfargument name="action_event_type_id" type="numeric" required="true">
		<cfargument name="action_subject" type="string" required="true">
		<cfargument name="action_content" type="string" required="true">
		<cfargument name="action_content_with_row" type="boolean" required="false" default="false">
		<cfargument name="action_field_id" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
		
		<cfset var method = "updateAction">

		<cfset var response = structNew()>
		
		<cftry>
					
			<cfinvoke component="#APPLICATION.componentsPath#/ActionManager" method="updateAction" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Acción modificada">
			</cfif>
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>


	<!--- -------------------------------copyTableActions-------------------------------------- --->
	
    <!---<cffunction name="copyTableActions" returntype="struct" access="public">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="copy_from_table_id" type="numeric" required="true">
		<cfargument name="actions_ids" type="array" required="true">
		
		<cfset var method = "copyTableActions">

		<cfset var response = structNew()>
		
		<cftry>

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
					
			<cfinvoke component="#APPLICATION.componentsPath#/ActionManager" method="copyTableActions" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message="Campos de #tableTypeNameEs# copiados.">
			</cfif>
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>--->


	<!---  ---------------------- changeActionPosition -------------------------------- --->

	<!---<cffunction name="changeActionPosition" returntype="struct" access="public">
		<cfargument name="action_id" type="numeric" required="true">
		<cfargument name="other_action_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="action" type="string" required="true"><!---increase/decrease--->
		
		<cfset var method = "changeActionPosition">

		<cfset var response = structNew()>
		
		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/ActionManager" method="changeActionPosition" returnvariable="response">
				<cfinvokeargument name="a_action_id" value="#arguments.action_id#">
				<cfinvokeargument name="b_action_id" value="#arguments.other_action_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="action" value="#arguments.action#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>--->


	<!--- -------------------------------deleteActionRemote-------------------------------------- --->
	
    <cffunction name="deleteActionRemote" returntype="void" access="remote">
    	<cfargument name="action_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfargument name="return_path" type="string" required="yes">
		
		<cfset var method = "deleteActionRemote">

		<cfset var response = structNew()>
		
		<cftry>
					
			<cfinvoke component="#APPLICATION.componentsPath#/ActionManager" method="deleteAction" returnvariable="response">
				<cfinvokeargument name="action_id" value="#arguments.action_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Acción eliminada">
			</cfif>
			
			<cfset msg = URLEncodedFormat(response.message)>
			
			<cflocation url="#arguments.return_path#&res=#response.result#&msg=#msg#" addtoken="no">		
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>



</cfcomponent>