<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_items_content_en.js" charset="utf-8" type="text/javascript"></script>
<script src="#APPLICATION.path#/jquery/jquery.highlight.js"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<!---<script type="text/javascript" src="#APPLICATION.path#/jquery/jquery.highlight.js"></script>--->
</cfoutput>


<!---<cfinclude template="#APPLICATION.htmlPath#/includes/search_2_bar.cfm">--->

<cfif isDefined("URL.text")>
	<cfset search_text = URL.text>
	<cfset search_text_highlight = replace(search_text,' ','","',"ALL")>
	<cfoutput>
		<script type="text/javascript">
			$(document).ready(function() {
			  $(".text_item").highlight(["#search_text_highlight#"]);	
			});			
		</script>
	</cfoutput>
<cfelse>
	<cfset search_text = "">
</cfif>

<!---<cfif isDefined("URL.limit") AND isNumeric(URL.limit)>
	<cfset limit_to = URL.limit>
<cfelse>
	<cfset limit_to = 100>
</cfif>--->

<cfoutput>

<div class="div_message_page_title">Usuarios de la organización</div><!---(#numUsers#)--->

<div class="div_head_subtitle_area">
	
	<!--- 
	PENDIENTE DE TERMINAR LAS OPCIONES
	<a class="btn btn-info btn-sm" onclick="parent.loadModal('html_content/client_options.cfm');"><i class="icon-edit icon-white"></i> <span lang="es">Opciones de la organización</span></a> --->
	
	<!---<a href="#CGI.SCRIPT_NAME#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh"></i> <span lang="es">Actualizar</span></a>--->

</div>

<div class="div_search_bar">

	<form method="get" name="search_form" action="#CGI.SCRIPT_NAME#">

		<div class="container">

			<div class="row">

				<div class="col-xs-5">
					<!---<div class="input-group">
					  <span class="input-group-addon"><i class="icon-search"></i></span>
					  <input type="text" name="text" id="text" value="#HTMLEditFormat(search_text)#" class="form-control"/>
					</div>--->
					<input type="text" name="text" id="text" value="#HTMLEditFormat(search_text)#" class="form-control"/>
				</div>

				<div class="col-xs-1">
					<input type="submit" name="search" class="btn btn-primary" lang="es" value="Buscar" />
				</div>

			</div>

			<!---<div class="row">

				<label for="limit" class="col-xs-2 col-sm-2 control-label" lang="es">Nº resultados</label>

				<div class="col-xs-3 col-sm-2"> 
					<select name="limit" id="limit" class="form-control">
						<option value="100" <cfif limit_to IS 100>selected="selected"</cfif>>100</option>
						<option value="500" <cfif limit_to IS 500>selected="selected"</cfif>>500</option>
						<option value="1000" <cfif limit_to IS 1000>selected="selected"</cfif>>1000</option>
						<option value="5000" <cfif limit_to IS 5000>selected="selected"</cfif>>5000</option>
					</select>
				</div>

			</div>--->

			<!---<div class="row">

				<div class="col-sm-offset-2 col-sm-10"> 
					<input type="submit" name="search" class="btn btn-primary" lang="es" value="Buscar" />
				</div>

			</div>--->

		</div>

	</form>

</div>
</cfoutput>


<cfif isDefined("URL.search")>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUsers" returnvariable="usersResponse">
		<cfif len(search_text) GT 0>
		<cfinvokeargument name="search_text" value="#search_text#">	
		</cfif>
		<!---<cfif isNumeric(limit_to)>
		<cfinvokeargument name="limit" value="#limit_to#">
		</cfif>--->
	</cfinvoke>
	
	<!---<cfset full_content = true>--->

	<cfset users = usersResponse.users>
	<cfset numUsers = ArrayLen(users)>

	<cfoutput>
	<div class="div_search_results_text" style="margin-bottom:5px; margin-top:5px;"><span lang="es">Resultado:</span> #numUsers# <span lang="es"><cfif numUsers GT 1>Usuarios<cfelse>Usuario</cfif></span></div>
	</cfoutput>

	<div class="div_items">
		
		<cfif numUsers GT 0>
	
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersList">
				<cfinvokeargument name="users" value="#users#">
				<cfinvokeargument name="open_url_target" value="userAdminIframe">
				<cfinvokeargument name="filter_enabled" value="true">
				<cfinvokeargument name="showAdminFields" value="true">
			</cfinvoke>	
	
		<cfelse>
			
			<script type="text/javascript">
				openUrlHtml2('empty.cfm','userAdminIframe');
			</script>
		
			<span lang="es">No hay usuarios.</span>
		</cfif>
		
	</div>	
	
<cfelse>
	
	<script type="text/javascript">
		openUrlHtml2('empty.cfm','userAdminIframe');
	</script>
	
	<p class="bg-info text-info" style="margin:15px;padding:5px;"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Introduzca un texto y haga click en "Buscar" para listar usuarios de la organización.</span></p>

</cfif>