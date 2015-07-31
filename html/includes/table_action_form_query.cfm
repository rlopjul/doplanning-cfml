<!---page_types
1 Create new action
2 Modify action
--->

<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

<!---<cfif app_version EQ "mobile">
	<cfset return_path = "#APPLICATION.htmlPath#/#tableTypeName#_actions.cfm?#tableTypeName#=#table_id#">
<cfelse>
	<cfset return_path = "#APPLICATION.htmlPath#/iframes2/#tableTypeName#_actions.cfm?#tableTypeName#=#table_id#">
</cfif>--->

<cfif isDefined("FORM.page")>

	<cfif page_type IS 1>
		<cfset methodAction = "createAction">
	<cfelse>
		<cfset methodAction = "updateAction">
	</cfif>
		
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Action" method="#methodAction#" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>

	<cfif actionResponse.result IS true>
		
		<cfset return_page = "#tableTypeName#_actions.cfm?#tableTypeName#=#actionResponse.table_id#">	

		<cfset msg = urlEncodedFormat(actionResponse.message)>

		<cflocation url="#return_page#&action=#actionResponse.action_id#&res=#actionResponse.result#&msg=#msg#" addtoken="no">

	<cfelse>
		
		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset action = FORM>
		<cfset table_id = FORM.table_id>
		
	</cfif> 

<cfelse>

	<cfif page_type IS 1>

		<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
			<cfset table_id = URL[tableTypeName]>
		<cfelse>
			<cflocation url="empty.cfm" addtoken="no">
		</cfif>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Action" method="getEmptyAction" returnvariable="action">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>
		
		<cfset area_id = table.area_id>

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

		<div class="div_head_subtitle">
			<span lang="es">Nueva acción</span>
		</div>

	<cfelse>

		<cfif isDefined("URL.action") AND isNumeric(URL.action)>
			<cfset action_id = URL.action>
		<cfelse>
			<cflocation url="empty.cfm" addtoken="no">
		</cfif>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Action" method="getAction" returnvariable="action">
			<cfinvokeargument name="action_id" value="#action_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

		<cfset table_id = action.table_id>
		<cfset area_id = action.area_id>

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

		<cfoutput>

		<cfif app_version NEQ "html2">
			<div class="div_head_subtitle">
				<span lang="es">Acción</span>
			</div>
		</cfif>

		<div class="div_message_page_title">#action.title#</div>
		<div class="div_separator"><!-- --></div>

		</cfoutput>

	</cfif>

</cfif>