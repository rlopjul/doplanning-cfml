<!---page_types
1 Create new view
2 Modify view
--->

<!--- <cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm"> --->

<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

<cfif isDefined("FORM.page")>

	<cfif page_type IS 1>
		<cfset methodAction = "createView">
	<cfelse>
		<cfset methodAction = "updateView">
	</cfif>
		
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/View" method="#methodAction#" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>

	<cfif actionResponse.result IS true>
		
		<cfset return_page = "#tableTypeName#_views.cfm?#tableTypeName#=#actionResponse.table_id#">	

		<cfset msg = urlEncodedFormat(actionResponse.message)>

		<cflocation url="#return_page#&view=#actionResponse.view_id#&res=#actionResponse.result#&msg=#msg#" addtoken="no">

	<cfelse>
		
		<cfset URL.res = 0>
		<cfset URL.msg = actionResponse.message>

		<cfset view = FORM>
		<cfset table_id = FORM.table_id>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>
		
	</cfif> 

<cfelse>

	<cfif page_type IS 1>

		<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
			<cfset table_id = URL[tableTypeName]>
		<cfelse>
			<cflocation url="empty.cfm" addtoken="no">
		</cfif>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/View" method="getEmptyView" returnvariable="view">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>
		
		<cfset area_id = table.area_id>

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

		<cfoutput>
		<div class="div_head_subtitle">
			<!--- <span lang="es">Nueva vista de #tableTypeNameEs#</span> --->
			<span lang="es">Nueva #itemTypeNameEs#</span>
		</div>
		</cfoutput>

	<cfelse>

		<cfif isDefined("URL.view") AND isNumeric(URL.view)>
			<cfset view_id = URL.view>
		<cfelse>
			<cflocation url="empty.cfm" addtoken="no">
		</cfif>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/View" method="getView" returnvariable="view">
			<cfinvokeargument name="view_id" value="#view_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

		<cfset table_id = view.table_id>
		<cfset area_id = view.area_id>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

		<cfoutput>

		<cfif app_version NEQ "html2">
			<cfoutput>
			<div class="div_head_subtitle">
				<!--- <span lang="es">Vista de #tableTypeNameEs#</span> --->
				<span lang="es">#itemTypeNameEs#</span>
			</div>
			</cfoutput>
		</cfif>

		<div class="div_message_page_title">#view.title#</div>
		<div class="div_separator"><!-- --></div>

		</cfoutput>

	</cfif>

</cfif>