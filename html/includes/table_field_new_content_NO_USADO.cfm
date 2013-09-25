<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
	<cfset table_id = URL[tableTypeName]>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Field" method="getEmptyField" returnvariable="field">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>

<cfset area_id = table.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">
<div class="div_head_subtitle">
	<span lang="es">Nuevo campo</span>
</div>

<cfset page_type = 1>
<cfinclude template="#APPLICATION.htmlPath#/includes/table_field_form.cfm">