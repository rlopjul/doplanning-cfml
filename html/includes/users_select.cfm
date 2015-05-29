<!---
	page_types
	1 select only one user
	2 multiple selection
--->

<cfoutput>
<!--- 
<script src="#APPLICATION.htmlPath#/language/area_users_select_en.js" charset="utf-8" type="text/javascript"></script>
 --->

<!---Este script hay que quitarlo de aquí, porque en la administración se incluye, y no es necesario incluirlo ya que está incluído en el main.cfm--->
<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<script src="#APPLICATION.path#/jquery/jquery.highlight.js"></script>

</cfoutput>

<cfif isDefined("URL.field")>
	
	<div class="clearfix" style="height:15px;"></div>
	<!--- SEARCH BAR --->
	<cfinclude template="#APPLICATION.htmlPath#/includes/users_search_bar.cfm">

	<cfif isDefined("URL.search")>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUsers" returnvariable="usersResponse">
			<cfif len(search_text) GT 0>
			<cfinvokeargument name="search_text" value="#search_text#">	
			</cfif>
			<!---<cfif isNumeric(limit_to)>
			<cfinvokeargument name="limit" value="#limit_to#">
			</cfif>--->
		</cfinvoke>

		<cfset users = usersResponse.users>
		<cfset numUsers = ArrayLen(users)>

		<cfoutput>
		<div class="div_search_results_text" style="margin-bottom:5px; margin-top:5px;"><span lang="es">Resultado:</span> #numUsers# <span lang="es"><cfif numUsers GT 1>Usuarios<cfelse>Usuario</cfif></span></div>
		</cfoutput>

		<div class="div_users">

			<cfif numUsers GT 0>

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersSelectList">
					<cfinvokeargument name="users" value="#users#">
					<cfinvokeargument name="page_type" value="#page_type#">
					<cfinvokeargument name="filter_enabled" value="false">
					<cfinvokeargument name="field_id" value="#URL.field#">
				</cfinvoke>

			<cfelse>
				<span lang="es">No hay usuarios.</span>
			</cfif>

		</div>

	<cfelse>

		<div class="alert alert-info" style="margin:10px;"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Introduzca el nombre, apellidos o email del usuario y haga click en "Buscar".</span></div>

	</cfif>

</cfif>