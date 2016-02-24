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


	<!--- -------------------------------------- throwTableAction ------------------------------------ --->

	<cffunction name="throwTableAction" access="public" returntype="void">
		<cfargument name="action_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "throwAction">

		<cfset var root_area = "">
		<cfset var actionEmailTo = "">

		<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

		<!--- getTableAction --->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/ActionQuery" method="getAction" returnvariable="actionQuery">
			<cfinvokeargument name="action_id" value="#arguments.action_id#">
			<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			<cfinvokeargument name="with_table" value="true">

			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

		<cfset table_id = actionQuery.table_id>

		<!--- getTable --->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTable" returnvariable="tableQuery">
			<cfinvokeargument name="table_id" value="#actionQuery.table_id#">
			<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			<cfinvokeargument name="parse_dates" value="false">
			<cfinvokeargument name="published" value="false">

			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

		<!--- getUser --->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="getUserQuery">
			<cfinvokeargument name="user_id" value="#arguments.user_id#">
			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

		<cfset actionEmailTo = getUserQuery.email>


		<cftry>


			<!--- getActionFields --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ActionQuery" method="getActionFields" returnvariable="actionFieldsQuery">
				<cfinvokeargument name="action_id" value="#arguments.action_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfloop query="#actionFieldsQuery#">

				<cfif actionFieldsQuery.field_type_id IS 8><!--- URL --->

					<cfset urlRequestFieldId = actionFieldsQuery.field_id>

				<cfelseif actionFieldsQuery.field_type_id IS 2><!--- TEXT CONTENT --->

					<cfset contentFieldId = actionFieldsQuery.field_id>

				</cfif>

			</cfloop>

			<cfif actionQuery.recordCount GT 0>

				<!--- getTableRows --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="rowsQuery">
					<cfinvokeargument name="table_id" value="#actionQuery.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfloop query="#rowsQuery#">

					<cfset urlRequest = rowsQuery['field_#urlRequestFieldId#']>
					<cfset content = rowsQuery['field_#contentFieldId#']>

					<cfif len(content) IS 0 AND len(urlRequest) GT 0 AND isValid("url", urlRequest)>

						<cfhttp method="get" url="#urlRequest#" result="responseResult" timeout="20">
						</cfhttp>

						<cfif responseResult.status_code EQ 200 AND isDefined("responseResult.filecontent")>

								<cfquery name="saveRow" datasource="#client_dsn#">
									UPDATE `#client_abb#_#tableTypeTable#_rows_#table_id#`
									SET
									last_update_user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">,
									last_update_date = NOW()
									, field_#contentFieldId# = <cfqueryparam value="#responseResult.filecontent#" cfsqltype="cf_sql_longvarchar">
									WHERE row_id = <cfqueryparam value="#rowsQuery.row_id#" cfsqltype="cf_sql_integer">;
								</cfquery>

								<!--- saveRow --->
								<!---<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="saveRow" argumentcollection="#rowValues#" returnvariable="row_id">
									<cfinvokeargument name="table_id" value="#arguments.table_id#">
									<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
									<cfinvokeargument name="area_id" value="#tableQuery.area_id#">
									<cfinvokeargument name="row_id" value="#rowsQuery.row_id#">

									<cfinvokeargument name="action" value="modify">

									<cfinvokeargument name="fields" value="#fields#">
									<cfinvokeargument name="user_id" value="#arguments.user_id#">
									<cfinvokeargument name="send_alert" value="true">
									<cfinvokeargument name="import" value="true">
									<cfif arguments.cancel_on_error IS true>
										<cfinvokeargument name="with_transaction" value="false">
									<cfelse>
										<cfinvokeargument name="with_transaction" value="true">
									</cfif>

									<cfinvokeargument name="client_abb" value="#client_abb#">
									<cfinvokeargument name="client_dsn" value="#client_dsn#">
								</cfinvoke>--->

								<cfset last_row_id = rowsQuery.row_id>

								<cfset sleep(3000)>

						<cfelse>

							<cfif isDefined("responseResult.filecontent")>
								<cfthrow message="Error: #responseResult.filecontent#">
							<cfelse>
								<cfthrow message="Error: #responseResult.status_code#">
							</cfif>

						</cfif>

					</cfif>

				</cfloop>

				<cfif isNumeric("last_row_id")>

					<!--- setActionLastSuccessExecution --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/ActionQuery" method="setActionLastSuccessExecution" returnvariable="getActionFieldsQuery">
						<cfinvokeargument name="action_id" value="#arguments.action_id#">
						<cfinvokeargument name="row_id" value="#last_row_id#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

				</cfif>

				<cfif len(actionEmailTo) GT 0>

					<cfset emailSubject = "Acción ejecutada correctamente en #tableQuery.title#">
					<cfset emailContent = "Acción completada en #tableQuery.title#">

					<cfinvoke component="#APPLICATION.coreComponentsPath#/EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
						<cfinvokeargument name="to" value="#actionEmailTo#">
						<cfinvokeargument name="subject" value="#emailSubject#">
						<cfinvokeargument name="content" value="#emailContent#">
					</cfinvoke>

				</cfif>

			</cfif>


			<cfcatch>

				<cfif len(actionEmailTo) GT 0>

					<cfset emailSubject = "Error al ejecutar la acción en #tableQuery.title#">
					<cfset emailContent = "#cfcatch.message#">

					<cfinvoke component="#APPLICATION.coreComponentsPath#/EmailManager" method="sendEmail">
						<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
						<cfinvokeargument name="to" value="#actionEmailTo#">
						<cfinvokeargument name="subject" value="#emailSubject#">
						<cfinvokeargument name="content" value="#emailContent#">
					</cfinvoke>

				</cfif>

			</cfcatch>

		</cftry>

	</cffunction>



</cfcomponent>
