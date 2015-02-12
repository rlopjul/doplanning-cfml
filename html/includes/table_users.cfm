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

	<div class="btn-toolbar" style="padding-right:5px;">

		<div class="btn-group">
			<!---<a href="area_items.cfm?area=#area_id#&#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="#tableTypeNameEs#" lang="es"> <img style="height:17px;" src="/html/assets/icons/#itemTypeName#.png" alt="#tableTypeNameEs#">&nbsp;&nbsp;<span lang="es">#tableTypeNameEs#</span></a>--->
			<a href="#itemTypeName#_rows.cfm?#tableTypeName#=#table_id#&area=#area_id#" class="btn btn-default btn-sm" title="#tableTypeNameEs#" lang="es"> <img style="height:17px;" src="/html/assets/icons/#itemTypeName#.png" alt="#tableTypeNameEs#">&nbsp;&nbsp;<span lang="es">#tableTypeNameEs#</span></a>
		</div>

		<div class="btn-group">
			<a  href="#tableTypeName#_users_add.cfm?#tableTypeName#=#table_id#" onclick="openUrl('#tableTypeName#_users_add.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)" class="btn btn-info btn-sm"><i class="icon-plus icon-white" style="font-size:14px;line-height:20px;"></i> <span>Añadir editores</span></a><!---color:##5BB75B;--->
		</div>

		<!---<span class="divider">&nbsp;</span>--->

		<cfif app_version NEQ "mobile">
			<div class="btn-group pull-right">
				<a href="#APPLICATION.htmlPath#/#tableTypeName#_users.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
			</div>
		</cfif>

		<!---<a href="#tableTypeName#_users.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>--->

	</div>

</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_users">

	<cfif users.recordCount GT 0>

		<!---<cfinclude template="#APPLICATION.htmlPath#/includes/table_users_list.cfm">--->

		<cfoutput>
		<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">
		</cfoutput>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="queryToArray" returnvariable="usersArray">
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
		<div class="div_text_result"><span lang="es">Haga clic en Añadir editores parar añadir un nuevo usuario.</span></div>
		</cfoutput>

	</cfif>

	<div style="margin-top:10px">
		<small class="help-block" lang="es">Los usuarios responsables de este área tienen el permiso de editores por defecto.</small>
	</div>

</div>

</cfoutput>
