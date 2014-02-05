<!--- 
<cfif isDefined("view_id")>

	<!---View fields--->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/View" method="getViewFields" returnvariable="fieldsResult">
		<cfinvokeargument name="view_id" value="#view_id#">
		<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		<cfinvokeargument name="with_types" value="true"/>
		<cfinvokeargument name="with_view_extra_fields" value="true">
	</cfinvoke>

	<cfset fields = fieldsResult.tableFields>

	<!---
	<!--- creation_date --->
	<cfif view.include_creation_date IS true>
		<cfset queryAddRow(fields, 1)>
		<cfset querySetCell(fields, "field_id", "creation_date")>
		<cfset querySetCell(fields, "label", "Fecha de creación")>
		<cfset querySetCell(fields, "view_position", view.creation_date_position)>
	</cfif>

	<!--- last_update_date --->
	<cfif view.include_last_update_date IS true>
		<cfset queryAddRow(fields, 1)>
		<cfset querySetCell(fields, "field_id", "last_update_date")>
		<cfset querySetCell(fields, "label", "Fecha de última modificación")>
		<cfset querySetCell(fields, "view_position", view.last_update_date_position)>
	</cfif>

	<!--- insert_user --->
	<cfif view.include_insert_user IS true>
		<cfset queryAddRow(fields, 1)>
		<cfset querySetCell(fields, "field_id", "insert_user")>
		<cfset querySetCell(fields, "label", "Usuario creación")>
		<cfset querySetCell(fields, "view_position", view.insert_user_position)>
	</cfif>

	<!--- update_user --->
	<cfif view.include_update_user IS true>
		<cfset queryAddRow(fields, 1)>
		<cfset querySetCell(fields, "field_id", "update_user")>
		<cfset querySetCell(fields, "label", "Usuario última modificación")>
		<cfset querySetCell(fields, "view_position", view.update_user_position)>
	</cfif>

	<cfquery dbtype="query" name="fields">
		SELECT * 
		FROM fields
		ORDER BY view_position ASC;
	</cfquery>--->

	<cfset cur_area_id = "">

<cfelse>

	<!---Table fields--->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
		<cfinvokeargument name="table_id" value="#table_id#">
		<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
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
	
			<a href="area_user.cfm?area=#area_id#&user=#row.insert_user_id#"><cfif len(row.insert_user_image_type) GT 0>
				<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#row.insert_user_id#&type=#row.insert_user_image_type#&small=" alt="#row.insert_user_full_name#" class="item_img" style="margin-right:2px;"/>									
			<cfelse>							
				<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#row.insert_user_full_name#" class="item_img_default" style="margin-right:2px;"/>
			</cfif></a>
			
			<a href="area_user.cfm?area=#area_id#&user=#row.insert_user_id#">#row.insert_user_full_name#</a>
		</div>


	<cfelseif fields.field_id IS "update_user"><!--- UPDATE USER --->

		<cfif isNumeric(row.last_update_user_id)>

			<div class="div_message_page_label">Última modificación por: 
				
				<a href="area_user.cfm?area=#area_id#&user=#row.last_update_user_id#"><cfif len(row.update_user_image_type) GT 0>
					<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#row.last_update_user_id#&type=#row.update_user_image_type#&small=" alt="#row.update_user_full_name#" class="item_img" style="margin-right:2px;"/>									
				<cfelse>							
					<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#row.update_user_full_name#" class="item_img_default" style="margin-right:2px;"/>
				</cfif></a>
				
				<a href="area_user.cfm?area=#area_id#&user=#row.last_update_user_id#">#row.update_user_full_name#</a>
			</div>

		</cfif>

	<cfelse><!--- TABLE FIELDS --->

		<cfset field_label = fields.label&":">
		<cfset field_name = "field_#fields.field_id#">		
	
		<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- LISTS --->

			<!--- Get selected areas --->
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getRowSelectedAreas" returnvariable="getRowSelectedAreasResponse">
				<cfinvokeargument name="table_id" value="#table_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="field_id" value="#fields.field_id#">
				<cfinvokeargument name="row_id" value="#row_id#">
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
</cfoutput> --->

