<!--- Copyright Era7 Information Technologies 2007-2015 --->
<cfcomponent output="false">

	<cfset component = "ActionManager">	

	<!--- getActionTypesStruct --->

	<cffunction name="getActionTypesStruct" returntype="struct" access="public">

		<cfset var actionTypesStruct = structNew()>

		<cfinclude template="includes/tableActionTypeStruct.cfm">

		<cfreturn actionTypesStruct>

	</cffunction>


	<!--- -------------------------------------- throwAction ------------------------------------ --->
	
	<cffunction name="throwAction" access="public" returntype="void">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="rowQuery" type="query" required="false">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="action_event_type_id" type="numeric" required="true">
		<cfargument name="user_id" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">	
			
		<cfset var method = "throwAction">
		
        <cfset var root_area = "">
        <cfset var actionEmailTo = "">

		
		<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

		<!--- getTableActions --->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/ActionQuery" method="getTableActions" returnvariable="getTableActionsQuery">
			<cfinvokeargument name="table_id" value="#arguments.table_id#">
			<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			<cfinvokeargument name="with_table" value="true">
			<cfinvokeargument name="action_event_type_id" value="#arguments.action_event_type_id#">
			
			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>


		<cfif getTableActionsQuery.recordCount GT 0>


			<cfif NOT isDefined("arguments.rowQuery")>
				
				<!--- getTableRow --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="rowQuery">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="row_id" value="#arguments.row_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>
			

			<cfloop query="#getTableActionsQuery#">
				
				<cfif getTableActionsQuery.action_type_id IS 1><!--- EMAIL --->

					<cfset emailSubject = "#getTableActionsQuery.action_subject#">

					<!--- getActionFields --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/ActionQuery" method="getActionFields" returnvariable="getActionFieldsQuery">
						<cfinvokeargument name="action_id" value="#getTableActionsQuery.action_id#">
						<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
						
						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfif getActionFieldsQuery.recordCount GT 0>

						<cfset actionEmailTo = rowQuery['field_#getActionFieldsQuery.field_id#']>

						<cfif len(actionEmailTo) GT 0 AND isValid("email", actionEmailTo)>
														
							<cfinvoke component="#APPLICATION.componentsPath#/EmailManager" method="sendEmail">
								<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
								<cfinvokeargument name="to" value="#actionEmailTo#">
								<cfinvokeargument name="subject" value="#emailSubject#">
								<cfinvokeargument name="content" value="#getTableActionsQuery.action_content#">
								<!---<cfinvokeargument name="head_content" value="#head_content#">
								<cfinvokeargument name="foot_content" value="#foot_content#">--->
							</cfinvoke>

							<!--- setActionLastSuccessExecution --->
							<cfinvoke component="#APPLICATION.coreComponentsPath#/ActionQuery" method="setActionLastSuccessExecution" returnvariable="getActionFieldsQuery">
								<cfinvokeargument name="action_id" value="#getTableActionsQuery.action_id#">
								<cfinvokeargument name="row_id" value="#arguments.row_id#">
								
								<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
								<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
							</cfinvoke>

						</cfif>

					</cfif>

				</cfif>
				
			</cfloop>			

		</cfif>

					
	</cffunction>



</cfcomponent>