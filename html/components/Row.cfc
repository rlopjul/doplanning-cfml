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

		<cfset var method = "getRow">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="getRow" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
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



	<!--- -------------------------------outputRowContent-------------------------------------- --->
	
    <cffunction name="outputRowContent" returntype="void" access="public" output="true">
    	<cfargument name="table_id" type="numeric" required="true">
    	<cfargument name="view_id" type="numeric" required="false">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="row" type="query" required="true">
		
		<cfset var method = "outputRowContent">
		
		<cftry>
					
			<cfif isDefined("arguments.view_id")>

				<!---View fields--->
				<cfinvoke component="#APPLICATION.htmlComponentsPath#/View" method="getViewFields" returnvariable="fieldsResult">
					<cfinvokeargument name="view_id" value="#arguments.view_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="with_types" value="true"/>
					<cfinvokeargument name="with_view_extra_fields" value="true">
				</cfinvoke>

				<cfset fields = fieldsResult.tableFields>

				<cfset cur_area_id = "">

			<cfelse>

				<!---Table fields--->
				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
					<cfinvokeargument name="with_types" value="true"/>
				</cfinvoke>

				<cfset fields = fieldsResult.tableFields>

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

			<cfoutput>
			<cfloop query="fields">


				<cfif fields.field_id IS "creation_date"><!--- CREATION DATE --->

					<div class="div_message_page_label"><span lang="es">Fecha de creación:</span> <span class="text_message_page">#DateFormat(row.creation_date, APPLICATION.dateFormat)# #TimeFormat(row.creation_date, "HH:mm")#</span></div>

				<cfelseif fields.field_id IS "last_update_date"><!--- LAST UPDATE DATE --->
					
					<div class="div_message_page_label"><span lang="es">Fecha de última modificación:</span> <span class="text_message_page">#DateFormat(row.last_update_date, APPLICATION.dateFormat)# #TimeFormat(row.last_update_date, "HH:mm")#</span></div>

				<cfelseif fields.field_id IS "insert_user"><!--- INSERT USER --->

					<div class="div_message_page_label">Creado por: 
				
						<a href="area_user.cfm?area=#arguments.area_id#&user=#row.insert_user_id#"><cfif len(row.insert_user_image_type) GT 0>
							<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#row.insert_user_id#&type=#row.insert_user_image_type#&small=" alt="#row.insert_user_full_name#" class="item_img" style="margin-right:2px;"/>									
						<cfelse>							
							<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#row.insert_user_full_name#" class="item_img_default" style="margin-right:2px;"/>
						</cfif></a>
						
						<a href="area_user.cfm?area=#arguments.area_id#&user=#row.insert_user_id#">#row.insert_user_full_name#</a>
					</div>


				<cfelseif fields.field_id IS "update_user"><!--- UPDATE USER --->

					<cfif isNumeric(row.last_update_user_id)>

						<div class="div_message_page_label">Última modificación por: 
							
							<a href="area_user.cfm?area=#arguments.area_id#&user=#row.last_update_user_id#"><cfif len(row.update_user_image_type) GT 0>
								<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#row.last_update_user_id#&type=#row.update_user_image_type#&small=" alt="#row.update_user_full_name#" class="item_img" style="margin-right:2px;"/>									
							<cfelse>							
								<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#row.update_user_full_name#" class="item_img_default" style="margin-right:2px;"/>
							</cfif></a>
							
							<a href="area_user.cfm?area=#arguments.area_id#&user=#row.last_update_user_id#">#row.update_user_full_name#</a>
						</div>

					</cfif>

				<cfelse><!--- TABLE FIELDS --->

					<cfset field_label = fields.label&":">
					<cfset field_name = "field_#fields.field_id#">		
				
					<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- LISTS --->

						<!--- Get selected areas --->
						<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getRowSelectedAreas" returnvariable="getRowSelectedAreasResponse">
							<cfinvokeargument name="table_id" value="#arguments.table_id#">
							<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
							<cfinvokeargument name="field_id" value="#fields.field_id#">
							<cfinvokeargument name="row_id" value="#row.row_id#">
						</cfinvoke>

						<cfset selectedAreas = getRowSelectedAreasResponse.areas>
						<cfset field_value = valueList(selectedAreas.name, "<br/>")>

						<div class="div_message_page_label">#field_label#<cfif fields.field_type_id IS 10><br/></cfif> <span class="text_message_page">#field_value#</span></div>

					<cfelse><!--- IS NOT LISTS --->

						<cfset field_value = row[field_name]>

						<cfif fields.input_type IS "textarea">

							<div class="div_message_page_label">#field_label#</div>
							<cfif len(field_value) GT 0>

								<cfif fields.field_type_id IS 2>

									<cfset field_value = HTMLEditFormat(field_value)>

									<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="insertBR" returnvariable="field_value">
										<cfinvokeargument name="string" value="#field_value#">
									</cfinvoke>
								</cfif>

								<div class="div_message_page_description">#field_value#</div>
							</cfif> 

						<cfelseif fields.field_type_id IS 8><!---URL--->

							<div class="div_message_page_label">#field_label#<br/> <a href="#field_value#" target="_blank">#field_value#</a></div>

						<cfelse>

							<cfif fields.field_type_id IS 6><!--- DATE --->

								<cfif isDate(field_value)>
									<cfset field_value = DateFormat(field_value, APPLICATION.dateFormat)>
								</cfif>		
							
							<cfelseif fields.field_type_id IS 7><!--- BOOLEAN --->
								
								<cfif field_value IS true>
									<cfset field_value = "Sí">
								<cfelseif field_Value IS false>
									<cfset field_value = "No">
								</cfif>

							</cfif>

							<div class="div_message_page_label">#field_label# <span class="text_message_page">#field_value#</span></div>

						</cfif>		

					</cfif>

				</cfif>

			</cfloop>
			</cfoutput>

			

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




</cfcomponent>