<cfoutput>
	<cfif isDefined("item_id")>
		<cfset item_page = true>
	<cfelse>
		<cfset item_page = false>
	</cfif>

	<cfif getArea.parent_id IS rootAreaId><!---PRIMER NIVEL: si el área raiz es el área padre--->
		<cfset parent_page_url_title = titleToUrl(area_name)>	
		/ <a href="page.cfm?id=#getArea.id#&title=#parent_page_url_title#" <cfif getFileFromPath(CGI.SCRIPT_NAME) EQ "page.cfm">class="actual"</cfif>>#area_name#</a>
		
	<cfelseif isDefined("sub_area_id") AND getArea.parent_id IS sub_area_id><!---TERCER NIVEL: el área padre es del segundo nivel--->
		<cfset parent_page_url_title = titleToUrl(parent_area_name)>
		/ <a href="page.cfm?id=#parent_area_id#&title=#parent_page_url_title#">#parent_area_name#</a>
		
		<cfset parent_page_url_title = titleToUrl(sub_area_name)>
		/ <a href="page.cfm?id=#getArea.parent_id#&title=#parent_page_url_title#">#sub_area_name#</a>
		
		<cfset page_url_title = titleToUrl(area_name)>
		/ <a href="page.cfm?id=#area_id#&title=#page_url_title#" <cfif getFileFromPath(CGI.SCRIPT_NAME) EQ "page.cfm">class="actual"</cfif>>#area_name#</a>
	<cfelse><!---SEGUNDO NIVEL: el área padre es del primer nivel--->
		<cfset parent_page_url_title = titleToUrl(parent_area_name)>
		/ <a href="page.cfm?id=#getArea.parent_id#&title=#parent_page_url_title#">#parent_area_name#</a>
		
		<cfset page_url_title = titleToUrl(area_name)>
		/ <a href="page.cfm?id=#area_id#&title=#page_url_title#" <cfif getFileFromPath(CGI.SCRIPT_NAME) EQ "page.cfm">class="actual"</cfif>>#area_name#</a>
	</cfif>
	<cfif item_page IS true><!---ITEM--->
		<cfset page_url_title = titleToUrl(page_title)>
		/ <a href="#CGI.SCRIPT_NAME#?id=#item_id#&title=#page_url_title#" class="actual">#page_title#</a>
	</cfif>
</cfoutput>	