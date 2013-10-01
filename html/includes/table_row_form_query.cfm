<!---page_types
1 Create new row
2 Modify row
--->

<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfif page_type IS 1>
	<cfset methodAction = "createRow">
<cfelse>
	<cfset methodAction = "updateRow">
</cfif>

<cfif isDefined("FORM.page")>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="#methodAction#" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>

	<cfif actionResponse.result IS true>
		
		<cfset return_page = "#tableTypeName#_rows.cfm?#tableTypeName#=#actionResponse.table_id#">	

		<cfset msg = urlEncodedFormat(actionResponse.message)>

		<cflocation url="#return_page#&row=#actionResponse.row_id#&res=#actionResponse.result#&msg=#msg#" addtoken="no">

	<cfelse>
		
		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset row = FORM>
		
	</cfif> 

<cfelse>

	<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
		<cfset table_id = URL[tableTypeName]>
	<cfelse>
		<cflocation url="empty.cfm" addtoken="no">
	</cfif>

	<cfif page_type IS 1>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getEmptyRow" returnvariable="row">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

		<cfset area_id = table.area_id>

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

		<div class="div_head_subtitle">
			<span lang="es">Nuevo registro</span>
		</div>

	<cfelse>

		<cfif isDefined("URL.row") AND isNumeric(URL.row)>
			<cfset row_id = URL.row>
		<cfelse>
			<cflocation url="empty.cfm" addtoken="no">
		</cfif>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getRow" returnvariable="getRowResponse">
			<cfinvokeargument name="table_id" value="#table_id#"/>
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			<cfinvokeargument name="row_id" value="#row_id#">
		</cfinvoke>

		<cfset row = getRowResponse.rows>
		<cfset area_id = getRowResponse.table.area_id>

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

		<cfif app_version NEQ "html2">
			<div class="div_head_subtitle">
			<cfoutput>
			<span lang="es">Modificar registro</span>
			</cfoutput>
			</div>
		</cfif>

		<cfoutput>

		<!---<div class="div_message_page_title">#row.label#</div>--->
		<div class="div_separator"><!-- --></div>

		</cfoutput>

	</cfif>

</cfif>