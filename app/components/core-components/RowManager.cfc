<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "RowManager">	


	<!--- ------------------------------------- generateRowStruct -------------------------------------  --->
	
	<cffunction name="generateRowStruct" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="view_id" type="numeric" required="false">
		<cfargument name="rowQuery" type="query" required="true">
		<cfargument name="fields" type="query" required="true">
		<cfargument name="file_id" type="numeric" required="false"><!---Only for typology--->

		<cfargument name="withDateFormatted" type="boolean" required="false" default="false">
		<cfargument name="withDoPlanningElements" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true"/>
		<cfargument name="client_dsn" type="string" required="true"/>

		<cfset var method = "generateRowStruct">

		<cfset var response = structNew()>

		<cfset var rowStruct = structNew()>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="queryToStruct" returnvariable="rowStruct">
				<cfinvokeargument name="Query" value="#arguments.rowQuery#">
			</cfinvoke>

			<cfset rowStruct = rowStruct[1]>


			<cfloop query="fields">

				<cfif fields.field_id IS "creation_date"><!--- CREATION DATE --->

					<cfif arguments.withDateFormatted IS true>
						
						<cfset rowStruct.creation_date = DateFormat(row.creation_date, APPLICATION.dateFormat)&" "&TimeFormat(row.creation_date, "HH:mm")>

					</cfif>

				<cfelseif fields.field_id IS "last_update_date"><!--- LAST UPDATE DATE --->
					
					<cfif arguments.withDateFormatted IS true>

						<cfset rowStruct.last_update_date = DateFormat(row.last_update_date, APPLICATION.dateFormat)&" "&TimeFormat(row.last_update_date, "HH:mm")>

					</cfif>

				<cfelseif fields.field_id IS "insert_user"><!--- INSERT USER --->

				
				<cfelseif fields.field_id IS "update_user"><!--- UPDATE USER --->


				<cfelse><!--- TABLE FIELDS --->

					<cfset field_label = fields.label&":">
					<cfset field_name = "field_#fields.field_id#">		
				
					<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10 OR fields.field_type_id IS 15 OR fields.field_type_id IS 16><!--- LISTS --->						

						<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- Area lists --->

							<!--- Get selected areas --->
							<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getRowSelectedAreas" returnvariable="selectedAreas">
								<cfinvokeargument name="table_id" value="#arguments.table_id#">
								<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
								<cfinvokeargument name="field_id" value="#fields.field_id#">
								<cfinvokeargument name="row_id" value="#rowStruct.row_id#">
								
								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

							<cfset field_value = valueList(selectedAreas.name, "<br/>")>

						<cfelse><!--- Text values lists --->

							<cfset field_value = rowStruct[field_name]>

							<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="insertBR" returnvariable="field_value">
								<cfinvokeargument name="string" value="#field_value#">
							</cfinvoke>

						</cfif>

						<cfset rowStruct[field_name] = field_value>

					<cfelse><!--- IS NOT LISTS --->

						<cfset field_value = rowStruct[field_name]>

						<cfif fields.field_type_id IS 12><!--- USER --->

							<cfif arguments.withDoPlanningElements IS true>
								
								<cfif isNumeric(field_value)>

									<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="userQuery">
										<cfinvokeargument name="user_id" value="#field_value#">

										<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
										<cfinvokeargument name="client_dsn" value="#client_dsn#">
									</cfinvoke>

									<cfif userQuery.recordCount GT 0>
										<cfset field_value_user = userQuery.user_full_name>
									<cfelse>
										<cfset field_value_user = "">
									</cfif>

								<cfelse>

									<cfset field_value_user = "">

								</cfif>

								<cfset rowStruct[field_name] = field_value_user>

							</cfif>

						<cfelseif fields.field_type_id IS 13><!--- ITEM --->

							<cfif arguments.withDoPlanningElements IS true>

								<cfif isNumeric(field_value)>

									<cfif fields.item_type_id IS 10><!--- FILE --->

										<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
											<cfinvokeargument name="file_id" value="#field_value#">
											<cfinvokeargument name="parse_dates" value="false"/>
											<cfinvokeargument name="published" value="false"/>

											<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
											<cfinvokeargument name="client_dsn" value="#client_dsn#">
										</cfinvoke>

										<cfif fileQuery.recordCount GT 0>
											<cfset field_value_item = fileQuery.name>
										<cfelse>
											<cfset field_value_item = "">
										</cfif>
									
										<cfset rowStruct[field_name] = field_value_item>

									<cfelse><!--- ITEM --->

										<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
											<cfinvokeargument name="item_id" value="#field_value#">
											<cfinvokeargument name="itemTypeId" value="#fields.item_type_id#">
											<cfinvokeargument name="parse_dates" value="false"/>
											<cfinvokeargument name="published" value="false"/>

											<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
											<cfinvokeargument name="client_dsn" value="#client_dsn#">
										</cfinvoke>

										<cfif itemQuery.recordCount GT 0>
											<cfif len(itemQuery.title) GT 0>
												<cfset field_value_item = itemQuery.title>
											<cfelse>
												<cfset field_value_item = "">
											</cfif>
										<cfelse>
											<cfset field_value_item = "">
										</cfif>

										<cfset rowStruct[field_name] = field_value_item>

									</cfif>

								</cfif>

							</cfif>

						<cfelse>

							<cfif fields.field_type_id IS 5><!--- DECIMAL --->

								<cfif isNumeric(fields.mask_type_id)>

									<cfset field_mask_type_id = fields.mask_type_id>

									<!--- getFieldMaskTypes --->
									<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldManager" method="getFieldMaskTypesStruct" returnvariable="maskTypesStruct">
										<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
										
										<cfinvokeargument name="client_abb" value="#client_abb#">
									</cfinvoke>

									<cfset cf_data_mask = maskTypesStruct[field_mask_type_id].cf_data_mask>
									<cfset cf_prefix = maskTypesStruct[field_mask_type_id].cf_prefix>
									<cfset cf_sufix = maskTypesStruct[field_mask_type_id].cf_sufix>
									<cfset cf_locale = maskTypesStruct[field_mask_type_id].cf_locale>
									<cfset field_value = cf_prefix&LSnumberFormat(field_value, cf_data_mask, cf_locale)&cf_sufix>

									<cfset rowStruct[field_name] = field_value>

								<cfelse>

									<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="trimDecimal" returnvariable="field_value">
										<cfinvokeargument name="value" value="#field_value#">
									</cfinvoke>

									<cfset rowStruct[field_name] = field_value>
									
								</cfif>

							<cfelseif fields.field_type_id IS 6><!--- DATE --->

								<cfif arguments.withDateFormatted IS true>

									<cfif isDate(field_value)>
										<cfset field_value = DateFormat(field_value, APPLICATION.dateFormat)>

										<cfset rowStruct[field_name] = field_value>
									</cfif>	

								</cfif>	
							
							<cfelseif fields.field_type_id IS 7><!--- BOOLEAN --->
								
							</cfif>

						</cfif>		

					</cfif>

				</cfif>

			</cfloop>

			<cfset response = {result="true", rowStruct=#rowStruct#}>

		<cfreturn response>

	</cffunction>



	<!--- ------------------------------------- getRowJSON -------------------------------------  --->
	
	<cffunction name="generateRowJSON" output="false" access="public" returntype="struct">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="view_id" type="numeric" required="false">
		<cfargument name="rowQuery" type="query" required="true">
		<cfargument name="fields" type="query" required="true">
		<cfargument name="file_id" type="numeric" required="false"><!---Only for typology--->

		<cfargument name="client_abb" type="string" required="true"/>
		<cfargument name="client_dsn" type="string" required="true"/>

		<cfset var rowStruct = structNew()>
		<cfset var rowJSON = structNew()>


			<!---generateRowStruct--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowManager" method="generateRowStruct" returnvariable="generateRowStructResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="view_id" value="#arguments.view_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="rowQuery" value="#arguments.rowQuery#">
				<cfinvokeargument name="fields" value="#arguments.fields#">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">

				<cfinvokeargument name="withDateFormatted" value="true"/>
				<cfinvokeargument name="withDoPlanningElements" value="true"/>

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#"/>
			</cfinvoke>

			<cfset rowStruct = generateRowStructResponse.rowStruct>

    		<cfloop query="fields">
				
				<cfset field_name = "field_#fields.field_id#">
				<cfset field_value = rowStruct[field_name]>
				
				<cfset rowJSON[fields.label] = field_value>

				<cfif fields.field_type_id IS 13><!--- DoPlanning Item --->
					
					<cfset rowJSON[fields.label&"_id"] = rowQuery[field_name]>

				</cfif>

			</cfloop>

		<cfreturn rowJSON>

	</cffunction>


</cfcomponent>