<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
	<cfset table_id = URL[#tableTypeName#]>
<cfelse>
	<cflocation url="area.cfm" addtoken="no">
</cfif>

<!---Table--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>

<!---Table users--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableUsers" returnvariable="usersResult">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset users = usersResult.tableUsers>

<cfset area_id = table.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>

<!---<script type="text/javascript">

	function openUsersSelector(){

		 return openPopUp('#APPLICATION.htmlPath#/iframes/area_users_select_multiple.cfm?area=#area_id#');
	}

</script>--->

<div class="div_message_page_title">#table.title#</div>
<div class="div_separator"><!-- --></div>

<div class="div_head_subtitle_area">

	<a  href="#tableTypeName#_users_add.cfm?#tableTypeName#=#table_id#" onclick="openUrl('#tableTypeName#_users_add.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)" class="btn btn-default btn-sm"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <span>Añadir usuarios</span></a>

	<span class="divider">&nbsp;</span>

	<a href="#tableTypeNameP#.cfm?area=#area_id#" class="btn btn-default btn-sm" title="#itemTypeNameEsP# del área" lang="es"><!---<i class="icon-file-text" style="font-size:19px; color:##7A7A7A"></i>---> <span lang="es">#itemTypeNameEsP# del área</span></a>

	<span class="divider">&nbsp;</span>

	<cfif app_version NEQ "mobile">
		<a href="#APPLICATION.htmlPath#/#tableTypeName#_users.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
	</cfif>

	<!---<a href="#tableTypeName#_users.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>--->

</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_users">

	<cfif users.recordCount GT 0>

		<!---<cfinclude template="#APPLICATION.htmlPath#/includes/table_users_list.cfm">--->

		<cfoutput>
		<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">
		</cfoutput>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="queryToArray" returnvariable="usersArray">
			<cfinvokeargument name="data" value="#users#">
		</cfinvoke>	

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersList">
			<cfinvokeargument name="users" value="#usersArray#">
			<cfif tableTypeId IS 1>
				<cfinvokeargument name="list_id" value="#table_id#"/>
			</cfif>
		</cfinvoke>	

	<cfelse>
	
		<script type="text/javascript">
			openUrlHtml2('empty.cfm','itemIframe');
		</script>				

		<cfoutput>
		<div class="div_text_result"><span lang="es">Haga clic en Añadir usuarios parar añadir un nuevo usuario.</span></div>
		</cfoutput>

	</cfif>

</div>

</cfoutput>
