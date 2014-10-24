<cfset app_version = "html2">
<cfset limit_to = 100>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAllItems" returnvariable="getAllItemsResult">
	<cfif isDefined("limit_to") AND isNumeric(limit_to)>
	<cfinvokeargument name="limit" value="#limit_to#">
	</cfif>
	<cfinvokeargument name="full_content" value="true">
</cfinvoke>

<cfset areaItemsQuery = getAllItemsResult.query>

<cfdump var="#areaItemsQuery#">

<div class="div_items">
<cfif areaItemsQuery.recordCount GT 0>
	
	<cfset area_type = "">
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsList">
		<cfinvokeargument name="itemsQuery" value="#areaItemsQuery#">
		<cfinvokeargument name="area_type" value="#area_type#">
		<cfinvokeargument name="app_version" value="#app_version#">
	</cfinvoke>

<cfelse>		

	<cfoutput>
	<div class="div_text_result"><span lang="es">No hay elementos</span></div>
	</cfoutput>

</cfif>
</div>



<cfset taskTypeId = 6>
<cfset curUserId = SESSION.user_id>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAllAreasItems" returnvariable="getAllAreasTasksResponse">
	<cfinvokeargument name="itemTypeId" value="#taskTypeId#">
	<cfinvokeargument name="recipient_user" value="#curUserId#">
	<cfinvokeargument name="done" value="false">
</cfinvoke>

<cfset tasksQuery = getAllAreasTasksResponse.query>

<cfdump var="#tasksQuery#">

<cfset numItems = tasksQuery.recordCount>
<cfif numItems GT 0>
	<cfoutput>
	<div class="div_search_results_text" style="margin-bottom:5px; margin-top:5px;">Tiene #numItems# pendientes</div>
	</cfoutput>
	<div class="div_items">

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItemsList">
			<cfinvokeargument name="itemsQuery" value="#tasksQuery#">
			<cfinvokeargument name="itemTypeId" value="#taskTypeId#">
			<cfinvokeargument name="full_content" value="true">
			<cfinvokeargument name="app_version" value="html2">
		</cfinvoke>

	</div>
<cfelse>
	<div class="div_items">
	<cfoutput>
	<div class="div_text_result"><span lang="es">No tiene tareas pendientes.</span></div>
	</cfoutput>
	</div>
</cfif>