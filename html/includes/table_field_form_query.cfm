<!---page_types
1 Create new field
2 Modify field
--->

<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<!---<cfif app_version EQ "mobile">
	<cfset return_path = "#APPLICATION.htmlPath#/#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#">
<cfelse>
	<cfset return_path = "#APPLICATION.htmlPath#/iframes2/#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#">
</cfif>--->

<cfif isDefined("FORM.page")>

	<cfif page_type IS 1>
		<cfset methodAction = "createField">
	<cfelse>
		<cfset methodAction = "updateField">
	</cfif>
		
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Field" method="#methodAction#" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>

	<cfif actionResponse.result IS true>
		
		<cfset return_page = "#tableTypeName#_fields.cfm?#tableTypeName#=#actionResponse.table_id#">	

		<cfset msg = urlEncodedFormat(actionResponse.message)>

		<cflocation url="#return_page#&field=#actionResponse.field_id#&res=#actionResponse.result#&msg=#msg#" addtoken="no">

	<cfelse>
		
		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset field = FORM>
		
	</cfif> 

<cfelse>

	<cfif page_type IS 1>

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

	<cfelse>

		<cfif isDefined("URL.field") AND isNumeric(URL.field)>
			<cfset field_id = URL.field>
		<cfelse>
			<cflocation url="empty.cfm" addtoken="no">
		</cfif>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Field" method="getField" returnvariable="field">
			<cfinvokeargument name="field_id" value="#field_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
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

		</cfoutput>

	</cfif>

</cfif>