<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>

	<cfset table_id = URL[tableTypeName]>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
		<cfinvokeargument name="table_id" value="#table_id#"/>
		<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
	</cfinvoke>

	<cfset area_id = table.area_id>

	<cfif isDefined("URL.return_page") AND len(URL.return_page) GT 0>
		<cfset url_return_page = "&return_page="&URLEncodedFormat("#return_path##URL.return_page#")>
	<cfelse>
		<cfset url_return_page = "&return_page="&URLEncodedFormat("#return_path##tableTypeName#_users.cfm?#tableTypeName#=#table_id#")>
	</cfif>
	
	<!---is_user_table_area_responsible--->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="isUserAreaResponsible" returnvariable="is_user_table_area_responsible">				
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>

	<cfif is_user_table_area_responsible><!--- Table Area Responsible --->

		<cfoutput>
		<script type="text/javascript">

			function confirmRemoveUserFromTable() {
		
				var message_confirm = "¿Seguro que desea quitar este usuario de la #tableTypeNameEs#?";
				return confirm(message_confirm);
			}

		</script>

		<div class="div_elements_menu" style="clear:both">
			<a href="#APPLICATION.htmlComponentsPath#/Table.cfc?method=removeUserFromTable&table_id=#table_id#&tableTypeId=#tableTypeId#&remove_user_id=#user_id##url_return_page#" onclick="return confirmRemoveUserFromTable();" title="Quitar de esta #tableTypeNameEs#" class="btn btn-warning btn-sm"><i class="icon-remove"></i> <span lang="es">Quitar de esta #tableTypeNameEs#</span></a>
		</div>
		</cfoutput>
	</cfif>

</cfif>