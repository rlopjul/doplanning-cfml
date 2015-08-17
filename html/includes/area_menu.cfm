<cfoutput>
<!---<script src="#APPLICATION.htmlPath#/language/area_menu_en.js?v=1" charset="utf-8"></script>--->
<script src="#APPLICATION.path#/jquery/jquery-shorten/jquery.shorten.min.js"></script>

<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="loggedUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
</cfinvoke>--->


<cfif isDefined("area_id")>

	<cfinclude template="#APPLICATION.htmlPath#/includes/app_page_head.cfm">

	<cfinclude template="#APPLICATION.htmlPath#/includes/area_path.cfm">
		
	<cfif isDefined("objectArea")>
		<cfinclude template="#APPLICATION.htmlPath#/includes/area_menu_info.cfm">
	</cfif>



</cfif><!---END isDefined("area_id")--->

<!---<div style="clear:both; height:2px;"></div>--->

</cfoutput>