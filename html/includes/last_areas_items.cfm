<!---<cfset app_version = "html2">
<cfset return_path = "#APPLICATION.htmlPath#/iframes/">--->

<cfif isDefined("URL.limit")>
	<cfset limit_to = URL.limit>
<cfelse>
	<cfset limit_to = 20>
</cfif>

<div class="row" id="lastItemsHead">
	<div class="col-sm-12">
		<div class="navbar navbar-default navbar-static-top">
			<div class="container-fluid">
				<span class="navbar-brand" lang="es">Últimos elementos</span>

				<form class="navbar-form navbar-right">
					<div class="form-group">
						<label for="limit" class="control-label" lang="es">Mostrar</label>
						<select name="limit" id="limit" class="form-control" onchange="loadHome();">
							<option value="20" <cfif limit_to IS 20>selected="selected"</cfif>>20</option>
							<option value="50" <cfif limit_to IS 50>selected="selected"</cfif>>50</option>
							<option value="100" <cfif limit_to IS 100>selected="selected"</cfif>>100</option>
						</select>
					</div>
					<!---<a class="btn btn-default btn-md navbar-btn navbar-right" onclick="loadHome();" title="Actualizar" lang="es"><i class="icon-refresh icon-white"></i></a>--->
					<button type="button" class="btn btn-default btn-sm navbar-btn" onclick="loadHome();" title="Actualizar" lang="es" style="margin-bottom:0;margin-top:0"><i class="icon-refresh icon-white"></i></button>
				</form>

			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-sm-12" id="lastItemsContainer" style="overflow:auto;">

<!--- All items --->

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAllItems" returnvariable="getAllItemsResult">
	<cfif isDefined("limit_to") AND isNumeric(limit_to)>
	<cfinvokeargument name="limit" value="#limit_to#">
	</cfif>
	<cfinvokeargument name="full_content" value="true">
</cfinvoke>

<cfset itemsQuery = getAllItemsResult.query>

<!---<cfdump var="#areaItemsQuery#">--->


<cfif itemsQuery.recordCount GT 0>
	
	<!---<cfset area_type = "">
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsList">
		<cfinvokeargument name="itemsQuery" value="#itemsQuery#">
		<cfinvokeargument name="area_type" value="#area_type#">
		<cfinvokeargument name="app_version" value="#app_version#">
	</cfinvoke>--->

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsFullList">
		<cfinvokeargument name="itemsQuery" value="#itemsQuery#">
		<cfinvokeargument name="return_path" value="#APPLICATION.htmlPath#/iframes/">
		<cfinvokeargument name="showLastUpdate" value="true">
	</cfinvoke>

<cfelse>		

	<cfoutput>
	<span lang="es">No hay elementos</span>
	</cfoutput>

	<div class="alert alert-info" style="margin-top:10px;"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Accede a las áreas de la organización a través de la pestaña</span> <a onclick="showTreeTab()" style="cursor:pointer" lang="es">Árbol</a> <span lang="es">para crear nuevos elementos</span></div>

</cfif>


	</div>
</div>