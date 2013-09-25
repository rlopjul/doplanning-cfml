<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfif isDefined("URL.field") AND isNumeric(URL.field)>
	<cfset field_id = URL.field>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>


<cfinvoke component="#APPLICATION.htmlComponentsPath#/Field" method="getField" returnvariable="field">
	<cfinvokeargument name="field_id" value="#field_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
	<cfinvokeargument name="with_table" value="true"/>
</cfinvoke>

<cfset table_id = field.table_id>
<cfset area_id = field.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfif app_version NEQ "html2">
	<div class="div_head_subtitle">
	<cfoutput>
	<span lang="es">Campo</span>
	</cfoutput>
	</div>
</cfif>

<cfoutput>

<div class="div_message_page_title">#field.label#</div>
<div class="div_separator"><!-- --></div>

<!--- 
<div class="div_elements_menu"><!---div_elements_menu--->
	
	<a href="" onclick="return confirmAction('eliminar');" title="Eliminar campo" class="btn btn-danger btn-small"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a>

	<!---<a onclick="return confirmActionLink('Campo #index#', 'eliminar', 'table_field_delete.cfm?ffid=#fieldsList.field_id#&fid=#fieldsList.table_id#')" class="btn btn-danger btn-small" title="Eliminar"><i class="icon-remove"></i></a>--->
		
</div> --->


</cfoutput>

<cfset page_type = 2>
<cfinclude template="#APPLICATION.htmlPath#/includes/table_field_form.cfm">