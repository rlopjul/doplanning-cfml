<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_items_content_en.js" charset="utf-8" type="text/javascript"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<!---<script type="text/javascript" src="#APPLICATION.path#/jquery/jquery.highlight.js"></script>--->
</cfoutput>


<!---<cfinclude template="#APPLICATION.htmlPath#/includes/search_2_bar.cfm">--->


<!---<cfif isDefined("URL.search")>--->

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUsers" returnvariable="usersResponse">
		<!---<cfif len(search_text) GT 0>
		<cfinvokeargument name="search_text" value="#search_text#">	
		</cfif>
		<cfif isNumeric(limit_to)>
		<cfinvokeargument name="limit" value="#limit_to#">
		</cfif>--->
	</cfinvoke>
	
	<!---<cfset full_content = true>--->

	<cfset users = usersResponse.users>
	<cfset numUsers = ArrayLen(users)>

	<div class="div_message_page_title">Todos los usuarios</div>

	
	<div class="div_items">
		
		<cfif numUsers GT 0>
	
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersList">
				<cfinvokeargument name="users" value="#users#">
				<cfinvokeargument name="open_url_target" value="userAdminIframe">
				<cfinvokeargument name="filter_enabled" value="true">
			</cfinvoke>	
	
		<cfelse>
			
			<script type="text/javascript">
				openUrlHtml2('empty.cfm','user2Iframe');
			</script>
		
			<span lang="es">No hay usuarios.</span>
		</cfif>
		
	</div>	
	
<!---<cfelse>
	
	<script type="text/javascript">
		openUrlHtml2('empty.cfm','itemIframe');
	</script>
	
	<div class="alert alert-info" style="margin:10px;"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Introduzca unos parámetros de búsqueda y haga click en "Buscar".</span></div>
	
</cfif>--->