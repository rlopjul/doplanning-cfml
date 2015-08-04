<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="true">

	<cfset component = "Row">
	<cfset request_component = "RowManager">


	<!--- ----------------------------------- getRow -------------------------------------- --->

	<!---Este método no hay que usarlo en páginas en las que su contenido se cague con JavaScript (páginas de html_content) porque si hay un error este método redirige a otra página. En esas páginas hay que obtener el Item directamente del RowManager y comprobar si result es true o false para ver si hay error y mostrarlo correctamente--->

	<cffunction name="getRow" output="false" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="file_id" type="numeric" required="false">

		<cfset var method = "getRow">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="getRow" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="row_id" value="#arguments.row_id#"/>
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>


	<!--- ----------------------------------- getViewRow -------------------------------------- --->

	<cffunction name="getViewRow" output="false" returntype="struct" access="public">
		<cfargument name="view_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="true">

		<cfset var method = "getViewRow">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="getViewRow" returnvariable="response">
				<cfinvokeargument name="view_id" value="#arguments.view_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="row_id" value="#arguments.row_id#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>


	<!--- ----------------------------------- getEmptyRow -------------------------------------- --->

	<cffunction name="getEmptyRow" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true"/>
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getEmptyRow">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="getEmptyRow" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response.row>
			
	</cffunction>



	<!--- ----------------------------------- fillEmptyRow -------------------------------------- --->

	<cffunction name="fillEmptyRow" output="false" returntype="query" access="public">
		<cfargument name="emptyRow" type="query" required="true"/>
		<cfargument name="fields" type="query" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="withDefaultValues" type="boolean" required="false">

		<cfset var method = "fillEmptyRow">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="fillEmptyRow" returnvariable="response">
				<cfinvokeargument name="emptyRow" value="#arguments.emptyRow#">
				<cfinvokeargument name="fields" value="#arguments.fields#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="withDefaultValues" value="#arguments.withDefaultValues#">
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response.row>
			
	</cffunction>


	<!--- ----------------------------------- getRowSelectedAreas -------------------------------------- --->

	<cffunction name="getRowSelectedAreas" output="false" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="field_id" type="numeric" required="false">
		<cfargument name="row_id" type="numeric" required="false">

		<cfset var method = "getRowSelectedAreas">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="getRowSelectedAreas" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="field_id" value="#arguments.field_id#">
				<cfinvokeargument name="row_id" value="#arguments.row_id#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>



	<!--- -------------------------------createRow-------------------------------------- --->
	
    <cffunction name="createRow" returntype="struct" access="public">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "createRow">

		<cfset var response = structNew()>
		
		<cftry>
			
			<!---<cfset arguments.action = "create">--->

			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="saveRow" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Registro guardado">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>


	<!--- -------------------------------updateRow-------------------------------------- --->
	
    <cffunction name="updateRow" returntype="struct" access="public">
    	<cfargument name="row_id" type="numeric" required="true">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfset var method = "updateRow">

		<cfset var response = structNew()>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="saveRow" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Registro modificado">
			</cfif>
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>



	<!--- -------------------------------deleteRowRemote-------------------------------------- --->
	
    <cffunction name="deleteRowRemote" returntype="void" access="remote">
    	<cfargument name="row_id" type="numeric" required="true">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfargument name="return_path" type="string" required="yes">
		
		<cfset var method = "deleteRowRemote">

		<cfset var response = structNew()>
		
		<cftry>
					
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="deleteRow" returnvariable="response">
				<cfinvokeargument name="row_id" value="#arguments.row_id#"/>
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Registro eliminado">
			</cfif>
			
			<cfset msg = URLEncodedFormat(response.message)>
			
			<cflocation url="#arguments.return_path#&res=#response.result#&msg=#msg#" addtoken="no">		
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>


	<!--- -------------------------------importRows-------------------------------------- --->
	
    <cffunction name="importRows" returntype="struct" access="public">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="file" type="string" required="true">
		<cfargument name="delimiter" type="string" required="true">
		<cfargument name="start_row" type="numeric" required="false">
		<cfargument name="delete_rows" type="boolean" required="false">
		<cfargument name="cancel_on_error" type="boolean" required="false">
		<cfargument name="decimals_with_mask" type="boolean" required="false">
		
		<cfset var method = "importRows">

		<cfset var response = structNew()>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="importRows" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Registros importados">
			</cfif>
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>


	<!--- -------------------------------exportRows-------------------------------------- --->
	
    <cffunction name="exportRows" returntype="struct" access="public">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="delimiter" type="string" required="true">
		
		<cfset var method = "exportRows">

		<cfset var response = structNew()>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="exportRows" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Registros exportados">
			</cfif>
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>


	<!--- -------------------------------outputRowFormInputs-------------------------------------- --->
	
    <cffunction name="outputRowFormInputs" returntype="void" access="public" output="true">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row" type="object" required="true">
		<cfargument name="fields" type="query" required="true">
		<cfargument name="search_inputs" type="boolean" required="false">
		
		<cfset var method = "outputRowFormInputs">
		
		<cftry>
					
			<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowHtml" method="outputRowFormInputs">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="row" value="#arguments.row#">
				<cfinvokeargument name="fields" value="#arguments.fields#">
				<cfinvokeargument name="language" value="#SESSION.user_language#">
				<cfinvokeargument name="search_inputs" value="#arguments.search_inputs#">

				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfcatch>
				<cfoutput>
					<div class="alert alert-danger">
						<i class="icon-warning-sign"></i> <span lang="es">#cfcatch.message#</span>
					</div>
				</cfoutput>
				<cfinclude template="includes/errorHandlerNoRedirect.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>



	<!--- -------------------------------outputRowList-------------------------------------- --->
	
    <cffunction name="outputRowList" returntype="void" access="public" output="true">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="view_id" type="numeric" required="false">
		<cfargument name="tableRows" type="query" required="true">
		<cfargument name="fields" type="query" required="true">
		<cfargument name="openRowOnSelect" type="boolean" required="true">
		<cfargument name="app_version" type="string" required="true">
		<cfargument name="columnSelectorContainer" type="string" required="false">
		
		<cfset var method = "outputRowList">
		
		<cftry>
					
			<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowHtml" method="outputRowList">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="view_id" value="#arguments.view_id#">
				<cfinvokeargument name="tableRows" value="#arguments.tableRows#">
				<cfinvokeargument name="fields" value="#arguments.fields#">
				<cfinvokeargument name="openRowOnSelect" value="#arguments.openRowOnSelect#">
				<cfinvokeargument name="app_version" value="#arguments.app_version#">
				<cfinvokeargument name="columnSelectorContainer" value="#arguments.columnSelectorContainer#">

				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfcatch>
				<cfoutput>
					<div class="alert alert-danger">
						<i class="icon-warning-sign"></i> <span lang="es">#cfcatch.message#</span>
					</div>
				</cfoutput>
				<cfinclude template="includes/errorHandlerNoRedirect.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>



	<!--- -------------------------------outputRowContent-------------------------------------- --->
	
    <cffunction name="outputRowContent" returntype="void" access="public" output="true">
    	<cfargument name="table_id" type="numeric" required="true">
    	<cfargument name="view_id" type="numeric" required="false">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="row" type="query" required="true">
		<cfargument name="fields" type="query" required="false">
		<cfargument name="file_id" type="numeric" required="false"><!---Only for typology--->
		
		<cfset var method = "outputRowContent">
		
		<!---<cftry>--->

			<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>
					
			<cfif isDefined("arguments.view_id")>

				<cfif NOT isDefined("arguments.fields")>
					
					<!---View fields--->
					<cfinvoke component="#APPLICATION.htmlComponentsPath#/View" method="getViewFields" returnvariable="fieldsResult">
						<cfinvokeargument name="view_id" value="#arguments.view_id#">
						<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
						<cfinvokeargument name="with_types" value="true"/>
						<cfinvokeargument name="with_view_extra_fields" value="true">
					</cfinvoke>

					<cfset fields = fieldsResult.tableFields>

				</cfif>
				
				<cfset cur_area_id = "">

			<cfelse>

				<cfif NOT isDefined("arguments.fields")>

					<!---Table fields--->
					<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
						<cfinvokeargument name="table_id" value="#arguments.table_id#">
						<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
						<cfinvokeargument name="with_types" value="true"/>
						<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
					</cfinvoke>

					<cfset fields = fieldsResult.tableFields>

				</cfif>

				<!--- creation_date --->
				<cfset queryAddRow(fields, 1)>
				<cfset querySetCell(fields, "field_id", "creation_date")>
				<cfset querySetCell(fields, "label", "Fecha de creación")>
				<cfset querySetCell(fields, "position", 0)>

				<!--- last_update_date --->
				<cfset queryAddRow(fields, 1)>
				<cfset querySetCell(fields, "field_id", "last_update_date")>
				<cfset querySetCell(fields, "label", "Fecha de última modificación")>
				<cfset querySetCell(fields, "position", 0)>

				<!--- insert_user --->
				<cfset queryAddRow(fields, 1)>
				<cfset querySetCell(fields, "field_id", "insert_user")>
				<cfset querySetCell(fields, "label", "Usuario creación")>
				<cfset querySetCell(fields, "position", 0)>

				<!--- update_user --->
				<cfset queryAddRow(fields, 1)>
				<cfset querySetCell(fields, "field_id", "update_user")>
				<cfset querySetCell(fields, "label", "Usuario última modificación")>
				<cfset querySetCell(fields, "position", 0)>

			</cfif>

			<!---generateRowStruct--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowManager" method="generateRowStruct" returnvariable="generateRowStructResponse">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="view_id" value="#arguments.view_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="rowQuery" value="#arguments.row#">
				<cfinvokeargument name="fields" value="#arguments.fields#">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">

				<cfinvokeargument name="withDateFormatted" value="false"/>
				<cfinvokeargument name="withDoPlanningElements" value="false"/>

				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#"/>
				<cfinvokeargument name="client_dsn" value="#client_dsn#"/>
			</cfinvoke>

			<cfset rowStruct = generateRowStructResponse.rowStruct>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			</cfinvoke>

			<cfoutput>

			<cfif NOT isDefined("arguments.view_id")><!--- IS LIST ROW --->

				<cfif arguments.tableTypeId IS NOT 3><!--- IS NOT typology row --->
					
					<div class="row">

						<div class="col-xs-12">

					   		<div class="media"><!--- item user name and date --->

								<a href="area_user.cfm?area=#arguments.area_id#&user=#rowStruct.insert_user_id#" class="media-left"><cfif len(rowStruct.insert_user_image_type) GT 0>
									<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#rowStruct.insert_user_id#&type=#rowStruct.insert_user_image_type#&small=" alt="#rowStruct.insert_user_full_name#" class="user_img" style="margin-right:2px;"/>									
								<cfelse>							
									<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#rowStruct.insert_user_full_name#" class="item_img_default" style="margin-right:2px;"/>
								</cfif></a>

								<div class="media-body">

									<a href="area_user.cfm?area=#arguments.area_id#&user=#rowStruct.insert_user_id#" class="link_user">#rowStruct.insert_user_full_name#</a>
									&nbsp;&nbsp;&nbsp;&nbsp;
									<span class="text_date">#DateFormat(rowStruct.creation_date, APPLICATION.dateFormat)#</span>
									&nbsp;&nbsp;&nbsp;
									<span class="text_hour">#TimeFormat(rowStruct.creation_date, "HH:mm:ss")#</span>

								</div>

							
							</div><!--- END media --->

						</div><!--- END col-xs-12 --->

					</div><!--- END row --->

					<cfif isNumeric(rowStruct.last_update_user_id)>

						<div class="row">

							<div class="col-xs-12">

						   		<div class="media"><!--- Usuario última modificación --->

									<a href="area_user.cfm?area=#arguments.area_id#&user=#rowStruct.last_update_user_id#" class="media-left"><cfif len(rowStruct.update_user_image_type) GT 0>
										<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#rowStruct.last_update_user_id#&type=#rowStruct.update_user_image_type#&small=" alt="#rowStruct.update_user_full_name#" class="user_img" style="margin-right:2px;"/>									
									<cfelse>							
										<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#rowStruct.update_user_full_name#" class="item_img_default" style="margin-right:2px;"/>
									</cfif></a>

									<div class="media-body">

										<a href="area_user.cfm?area=#arguments.area_id#&user=#rowStruct.last_update_user_id#" class="link_user">#rowStruct.update_user_full_name#</a>
										&nbsp;&nbsp;&nbsp;&nbsp;
										<span class="text_date">#DateFormat(rowStruct.last_update_date, APPLICATION.dateFormat)#</span>
										&nbsp;&nbsp;&nbsp;
										<span class="text_hour">#TimeFormat(rowStruct.last_update_date, "HH:mm:ss")#</span> <span class="text_hour" lang="es">(Última modificación)</span>

									</div>

								
								</div><!--- END media --->

							</div><!--- END col-xs-12 --->

						</div><!--- END row --->

					</cfif>

				</cfif>

			</cfif>

			<cfloop query="fields">


				<cfif fields.field_id IS "creation_date"><!--- CREATION DATE --->

					<cfif isDefined("arguments.view_id")>
						<div class="div_message_page_label"><span lang="es">Fecha de creación</span>: <span class="text_message_page">#DateFormat(rowStruct.creation_date, APPLICATION.dateFormat)# #TimeFormat(rowStruct.creation_date, "HH:mm")#</span></div>
					</cfif>

				<cfelseif fields.field_id IS "last_update_date"><!--- LAST UPDATE DATE --->
					
					<div class="div_message_page_label"><span lang="es">Fecha de última modificación</span>: <span class="text_message_page">#DateFormat(rowStruct.last_update_date, APPLICATION.dateFormat)# #TimeFormat(rowStruct.last_update_date, "HH:mm")#</span></div>

				<cfelseif fields.field_id IS "insert_user"><!--- INSERT USER --->

					<cfif isDefined("arguments.view_id")>
						<div class="div_message_page_label"><span lang="es">Creado por</span>: 
					
							<a href="area_user.cfm?area=#arguments.area_id#&user=#rowStruct.insert_user_id#"><cfif len(rowStruct.insert_user_image_type) GT 0>
								<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#rowStruct.insert_user_id#&type=#rowStruct.insert_user_image_type#&small=" alt="#rowStruct.insert_user_full_name#" class="item_img" style="margin-right:2px;"/>									
							<cfelse>							
								<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#rowStruct.insert_user_full_name#" class="item_img_default" style="margin-right:2px;"/>
							</cfif></a>
							
							<a href="area_user.cfm?area=#arguments.area_id#&user=#rowStruct.insert_user_id#">#rowStruct.insert_user_full_name#</a>
						</div>
					</cfif>


				<cfelseif fields.field_id IS "update_user"><!--- UPDATE USER --->

					<cfif isNumeric(rowStruct.last_update_user_id)>

						<div class="div_message_page_label"><span lang="es">Última modificación por</span>: 
							
							<a href="area_user.cfm?area=#arguments.area_id#&user=#rowStruct.last_update_user_id#"><cfif len(rowStruct.update_user_image_type) GT 0>
								<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#rowStruct.last_update_user_id#&type=#rowStruct.update_user_image_type#&small=" alt="#rowStruct.update_user_full_name#" class="item_img" style="margin-right:2px;"/>									
							<cfelse>							
								<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#rowStruct.update_user_full_name#" class="item_img_default" style="margin-right:2px;"/>
							</cfif></a>
							
							<a href="area_user.cfm?area=#arguments.area_id#&user=#rowStruct.last_update_user_id#">#rowStruct.update_user_full_name#</a>
						</div>

					</cfif>

				<cfelse><!--- TABLE FIELDS --->

					<cfset field_label = fields.label&":">
					<cfset field_name = "field_#fields.field_id#">		
				
					<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10 OR fields.field_type_id IS 15 OR fields.field_type_id IS 16><!--- LISTS --->						

						<!---
						<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- Area lists --->

							<!--- Get selected areas --->
							<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getRowSelectedAreas" returnvariable="getRowSelectedAreasResponse">
								<cfinvokeargument name="table_id" value="#arguments.table_id#">
								<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
								<cfinvokeargument name="field_id" value="#fields.field_id#">
								<cfinvokeargument name="row_id" value="#row.row_id#">
							</cfinvoke>

							<cfset selectedAreas = getRowSelectedAreasResponse.areas>
							<cfset field_value = valueList(selectedAreas.name, "<br/>")>

						<cfelse><!--- Text values lists --->

							<cfset field_value = row[field_name]>

							<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="insertBR" returnvariable="field_value">
								<cfinvokeargument name="string" value="#field_value#">
							</cfinvoke>

						</cfif>--->

						<cfset field_value = rowStruct[field_name]>

						<div class="div_message_page_label">#field_label#<cfif fields.field_type_id IS 10 OR fields.field_type_id IS 16><br/></cfif> <span class="text_message_page">#field_value#</span></div>

					<cfelse><!--- IS NOT LISTS --->

						<cfset field_value = rowStruct[field_name]>

						<cfif fields.input_type IS "textarea">

							<div class="div_message_page_label">#field_label#</div>
							<cfif len(field_value) GT 0>

								<cfif fields.field_type_id IS 2>

									<cfset field_value = HTMLEditFormat(field_value)>

									<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="insertBR" returnvariable="field_value">
										<cfinvokeargument name="string" value="#field_value#">
									</cfinvoke>--->

									<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="insertBR" returnvariable="field_value">
										<cfinvokeargument name="string" value="#field_value#">
									</cfinvoke>
								</cfif>

								<div class="lead div_message_page_description">#field_value#</div>
							</cfif> 

						<cfelseif fields.field_type_id IS 8><!---URL--->

							<div class="div_message_page_label">#field_label#<br/> <a href="#field_value#" target="_blank">#field_value#</a></div>

						<cfelseif fields.field_type_id IS 12><!--- USER --->


							<div class="div_message_page_label">#field_label# 

								<cfif isNumeric(field_value)>

									<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="userQuery">
										<cfinvokeargument name="user_id" value="#field_value#">

										<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
										<cfinvokeargument name="client_dsn" value="#client_dsn#">
									</cfinvoke>

									<cfif userQuery.recordCount GT 0>
										<cfset field_value_user = userQuery.user_full_name>

										<cfif len(userQuery.image_type) GT 0>
											<a href="user.cfm?user=#userQuery.user_id#"><img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#field_value#&type=#userQuery.image_type#&small=" alt="#field_value_user#" class="item_img" style="margin-right:2px;"/></>									
										<cfelse>						
											<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#userQuery.user_full_name#" class="item_img_default" style="margin-right:2px;"/>
										</cfif>
										<a href="user.cfm?user=#userQuery.user_id#">#field_value_user#</a>

									<cfelse>
										<i lang="es">Usuario no encontrado</i>
									</cfif>

								</cfif>

							</div>


						<cfelseif fields.field_type_id IS 13><!--- ITEM --->


							<div class="div_message_page_label">#field_label# 

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
											<cfif len(fileQuery.name) GT 0>
												<cfset field_value_item = fileQuery.name>
											<cfelse>
												<cfset field_value_item = '<i lang="es">Archivo sin título</i>'>
											</cfif>

											<a href="file.cfm?file=#fileQuery.file_id#">#field_value_item#</a>
										<cfelse>
											<i lang="es">ARCHIVO NO DISPONIBLE</i>
										</cfif>
										
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
												<cfset field_value_item = '<i lang="es">Elemento sin título</i>'>
											</cfif>

											<a href="#itemTypesStruct[fields.item_type_id].name#.cfm?#itemTypesStruct[fields.item_type_id].name#=#itemQuery.item_id#">#field_value_item#</a>
										<cfelse>
											<i lang="es">ELEMENTO NO DISPONIBLE</i>
										</cfif>

									</cfif>

								</cfif>

							</div>


						<cfelse>

							<cfif fields.field_type_id IS 5><!--- DECIMAL --->

								<!---<cfif isNumeric(fields.mask_type_id)>

									<cfset field_mask_type_id = fields.mask_type_id>

									<!--- getFieldMaskTypes --->
									<cfinvoke component="#APPLICATION.htmlComponentsPath#/Field" method="getFieldMaskTypes" returnvariable="getFieldMaskTypesResponse">
										<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
									</cfinvoke>

									<cfset maskTypesStruct = getFieldMaskTypesResponse.maskTypesStruct>

									<cfset cf_data_mask = maskTypesStruct[field_mask_type_id].cf_data_mask>
									<cfset cf_prefix = maskTypesStruct[field_mask_type_id].cf_prefix>
									<cfset cf_sufix = maskTypesStruct[field_mask_type_id].cf_sufix>
									<cfset cf_locale = maskTypesStruct[field_mask_type_id].cf_locale>
									<cfset field_value = cf_prefix&LSnumberFormat(field_value, cf_data_mask, cf_locale)&cf_sufix>

								<cfelse>

									<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="trimDecimal" returnvariable="field_value">
										<cfinvokeargument name="value" value="#field_value#">
									</cfinvoke>
									
								</cfif>--->

							<cfelseif fields.field_type_id IS 6><!--- DATE --->

								<cfif isDate(field_value)>
									<cfset field_value = DateFormat(field_value, APPLICATION.dateFormat)>
								</cfif>		
							
							<cfelseif fields.field_type_id IS 7><!--- BOOLEAN --->
								
								<cfif field_value IS true>
									<cfset field_value = '<span lang="es">Sí</span>'>
								<cfelseif field_Value IS false>
									<cfset field_value = '<span lang="es">No</span>'>
								</cfif>

							</cfif>

							<div class="div_message_page_label">#field_label# <span class="text_message_page">#field_value#</span></div>

						</cfif>		

					</cfif>

				</cfif>

			</cfloop>
			</cfoutput>

			

			<!---<cfcatch>
				<cfoutput>
					<div class="alert alert-danger">
						<i class="icon-warning-sign"></i> <span lang="es">#cfcatch.message#</span>
					</div>
				</cfoutput>
				<cfinclude template="includes/errorHandlerNoRedirect.cfm">
			</cfcatch>							
			
		</cftry>	--->		
		
	</cffunction>




</cfcomponent>