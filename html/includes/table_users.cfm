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

<cfif app_version NEQ "mobile">
	<div class="div_message_page_title">#table.title#</div>
	<div class="div_separator"><!-- --></div>
</cfif>

<div class="div_head_subtitle_area">

	<div class="btn-toolbar" style="padding-right:5px;">

		<div class="btn-group">
			<a href="#itemTypeName#_rows.cfm?#tableTypeName#=#table_id#&area=#area_id#" class="btn btn-default btn-sm" title="#tableTypeNameEs#" lang="es"> <img style="height:17px;" src="/html/assets/icons/#itemTypeName#.png" alt="#tableTypeNameEs#">&nbsp;&nbsp;<span lang="es">#tableTypeNameEs#</span></a>
		</div>

		<div class="btn-group">
			<a  href="#tableTypeName#_users_add.cfm?#tableTypeName#=#table_id#" onclick="openUrl('#tableTypeName#_users_add.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)" class="btn btn-primary btn-sm"><i class="icon-plus icon-white" style="font-size:14px;line-height:20px;"></i> <span lang="es">Añadir editores</span></a>
		</div>

		<cfif app_version NEQ "mobile">
			<div class="btn-group pull-right">
				<a href="#APPLICATION.htmlPath#/#tableTypeName#_users.cfm?#tableTypeName#=#table_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
			</div>
		</cfif>

	</div>

</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_users">

	<cfif users.recordCount GT 0>

		<cfoutput>
		<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">
		</cfoutput>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="queryToArray" returnvariable="usersArray">
			<cfinvokeargument name="data" value="#users#">
		</cfinvoke>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersList">
			<cfinvokeargument name="users" value="#usersArray#">
			<cfinvokeargument name="openRowOnSelect" value="true">
			<cfif tableTypeId IS 1>
				<cfinvokeargument name="list_id" value="#table_id#"/>
			</cfif>
		</cfinvoke>

	<cfelse>

		<cfoutput>
		<div class="alert alert-info" style="margin-top:10px;">
			<i class="icon-info-sign"></i>&nbsp;<span lang="es">Haga clic en Añadir editores parar añadir un nuevo usuario.</span>
		</div>
		</cfoutput>

	</cfif>

	<div style="margin-top:10px">
		<small class="help-block" lang="es">Los usuarios responsables de este área tienen el permiso de editores por defecto.</small>
	</div>

</div>

</cfoutput>
