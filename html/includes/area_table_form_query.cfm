<!---page_types
1 Create new table
2 Modify table
--->

<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfif page_type IS 1>
	<cfset methodAction = "createTable">
<cfelse>
	<cfset methodAction = "updateTable">
</cfif>

<cfif isDefined("FORM.page")>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="#methodAction#" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>

	<cfif actionResponse.result IS true>
		
		<cfset return_page = "#tableTypeNameP#.cfm?#tableTypeName#=#actionResponse.table_id#">	

		<cfset msg = urlEncodedFormat(actionResponse.message)>

		<cflocation url="#return_page#&table=#actionResponse.table_id#&res=#actionResponse.result#&msg=#msg#" addtoken="no">

	<cfelse>
		
		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset table = FORM>
		
	</cfif> 

<cfelse>

	<cfif isDefined("URL.area") AND isNumeric(URL.area)>
		<cfset area_id = URL.area>
	<cfelse>
		<cflocation url="empty.cfm" addtoken="no">
	</cfif>

	<cfif page_type IS 1>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getEmptyTable" returnvariable="table">
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
			<span lang="es">Nueva tipología</span>
		</div>

	<cfelse>

		<cfif isDefined("URL.table") AND isNumeric(URL.table)>
			<cfset table_id = URL.table>
		<cfelse>
			<cflocation url="empty.cfm" addtoken="no">
		</cfif>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="getTableResponse">
			<cfinvokeargument name="table_id" value="#table_id#"/>
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			<cfinvokeargument name="table_id" value="#table_id#">
		</cfinvoke>

		<cfset table = getTableResponse.tables>
		<cfset area_id = getTableResponse.table.area_id>

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

		<cfif app_version NEQ "html2">
			<div class="div_head_subtitle">
			<cfoutput>
			<span lang="es">Modificar tipología</span>
			</cfoutput>
			</div>
		</cfif>

		<cfoutput>

		<!---<div class="div_message_page_title">#table.label#</div>--->
		<div class="div_separator"><!-- --></div>

		</cfoutput>

	</cfif>

</cfif>