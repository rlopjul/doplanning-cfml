<cfoutput>
<!---
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8" type="text/javascript"></script>
 --->

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

</cfoutput>


<cfinclude template="#APPLICATION.htmlPath#/includes/search_2_bar.cfm">


<cfif isDefined("URL.search")>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUsers" argumentcollection="#URL#" returnvariable="usersResponse">
		<cfif len(search_text) GT 0>
			<cfinvokeargument name="search_text" value="#search_text#">
		</cfif>
		<cfif isNumeric(limit_to)>
			<cfinvokeargument name="limit" value="#limit_to#">
		</cfif>
	</cfinvoke>


	<!---<cfset full_content = true>--->

	<!---<cfxml variable="xmlUsers">
		<cfoutput>
		#usersResponse.usersXml#
		</cfoutput>
	</cfxml>
	<cfset numUsers = ArrayLen(xmlUsers.users.XmlChildren)>--->

	<cfset users = usersResponse.users>
	<cfset numUsers = ArrayLen(users)>

	<cfoutput>
	<div class="div_search_results_text" style="margin-bottom:5px; margin-top:5px;"><span lang="es">Resultado:</span> #numUsers# <span lang="es"><cfif numUsers GT 1>Usuarios<cfelse>Usuario</cfif></span></div>
	</cfoutput>

	<div class="div_items">

		<cfif numUsers GT 0>

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersList">
				<cfinvokeargument name="users" value="#users#">
			</cfinvoke>

		<cfelse>

			<script type="text/javascript">
				openUrlHtml2('empty.cfm','itemIframe');
			</script>

			<span lang="es">No se han encontrado usuarios.</span>
		</cfif>

	</div>

<cfelse>

	<script type="text/javascript">
		openUrlHtml2('empty.cfm','itemIframe');
	</script>

	<div class="alert alert-info" style="margin:10px;background-color:#65C5BD"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Rellene el formulario y haga click en BUSCAR</span></div>

</cfif>
