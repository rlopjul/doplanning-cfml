<cfif isDefined("URL.user") AND isNumeric(URL.user)>

	<cfset user_id = URL.user>

	<cfinclude template="#APPLICATION.htmlPath#/includes/jstree_scripts.cfm">

	<cfinclude template="#APPLICATION.htmlPath#/includes/loading_div.cfm">

	<div class="form-inline" style="position:fixed;">

		<cfinclude template="#APPLICATION.htmlPath#/includes/tree_toolbar.cfm">

	</div>

	<cfprocessingdirective suppresswhitespace="true">
	<div id="areasTreeContainer" style="clear:both; padding-top:35px;">

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaTree" method="outputMainTreeAdmin">
			<cfinvokeargument name="get_user_id" value="#user_id#">
		</cfinvoke>

	</div>
	</cfprocessingdirective>
	<div style="height:2px; clear:both;"><!-- --></div>	

</cfif>