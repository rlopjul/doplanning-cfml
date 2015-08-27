<cfif isDefined("URL.all_enabled") AND URL.all_enabled IS true>
	<cfset allEnabled = true>
<cfelse>
	<cfset allEnabled = false>
</cfif>
<cfif isDefined("URL.web_enabled") AND URL.web_enabled IS NOT true>
	<cfset webEnabled = false>
<cfelse>
	<cfset webEnabled = true>
</cfif>
<cfif isDefined("URL.no_web_enabled") AND URL.no_web_enabled IS NOT true>
	<cfset noWebEnabled = false>
<cfelse>
	<cfset noWebEnabled = true>
</cfif>

<cfif isDefined("URL.scope") AND isNumeric(URL.scope)>
	<cfset scope_id = URL.scope>
</cfif>

<cfif isDefined("URL.itemTypeId") AND isNumeric(URL.itemTypeId)>
	<cfset itemTypeId = URL.itemTypeId>	
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/jstree_scripts.cfm">

<script>
	
	<cfoutput>
		var allEnabled = #allEnabled#;
		var webEnabled = #webEnabled#;
		var noWebEnabled = #noWebEnabled#;
		<cfif isDefined("itemTypeId")>
		var itemTypeId = #itemTypeId#;
		</cfif>
	</cfoutput>
	

	function areaSelected(areaId, areaUrl, withLink)  {

		var areaNode = $("#"+areaId);

		var relAtt = (areaNode).attr("rel");

		if( allEnabled == false) {

			if( relAtt == "not-allowed" || relAtt == "not-allowed-web" ){

				alert("No tiene permiso de acceso en esta área");
				return;

			} else if( (webEnabled == false && relAtt == "allowed-web") || (noWebEnabled == false && relAtt == "allowed") ) {

				alert("No puede seleccionar este tipo de área");
				return;
			}

		}

		var areaName = $.trim( $(areaNode).find("a:first").text() );

		<cfif isDefined("itemTypeId")><!--- select area to items categories --->
			window.opener.setSelectedArea(areaId, areaName, itemTypeId);
		<cfelse>
			window.opener.setSelectedArea(areaId, areaName);
		</cfif>
		
		window.close();			
	}

</script>

<cfinclude template="#APPLICATION.htmlPath#/includes/loading_div.cfm">

<cfoutput>
<div>
<cfif APPLICATION.publicationScope IS true AND isDefined("scope_id")>
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Scope" method="getScope" returnvariable="scope">
		<cfinvokeargument name="scope_id" value="#scope_id#">
	</cfinvoke>
	<span class="help-block">Ámbito de publicación definido: #scope.name#</span>
</cfif>
<cfif noWebEnabled IS false AND webEnabled IS true>
	<span class="help-block">Sólo puede seleccionar áreas web</span>
</cfif>
</div>
</cfoutput>

<div class="form-inline" style="margin-top:2px;">

	<div class="btn-toolbar">
								
		<div class="btn-group">
			<div class="input-group input-group-sm" style="width:260px;" >
				<input type="text" name="text" id="searchText" value="" class="form-control" placeholder="Búsqueda de área" lang="es"/>
				<span class="input-group-btn">
					<button onClick="searchTextInTree()" class="btn btn-default" type="button" title="Buscar área en el árbol" lang="es"><i class="icon-search"></i> <span lang="es">Buscar</span></button>
				</span>
			</div>
		</div>

		<div class="btn-group btn-group-sm">
			<a onClick="expandTree();" class="btn btn-default" title="Expandir todo el árbol" lang="es"><i class="icon-plus"></i> <span lang="es">Expandir</span></a>
			<a onClick="collapseTree();" class="btn btn-default" title="Colapsar todo el árbol" lang="es"><i class="icon-minus"></i> <span lang="es">Colapsar</span></a>
		</div>

	</div>

</div>

<cfif APPLICATION.publicationScope IS true AND isDefined("scope_id")>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="loggedUser">
		<cfinvokeargument name="user_id" value="#SESSION.user_id#">
	</cfinvoke>

	<cfif loggedUser.internal_user IS true AND loggedUser.hide_not_allowed_areas IS false>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Scope" method="getScopeAreas" returnvariable="getScopesResult">
			<cfinvokeargument name="scope_id" value="#scope_id#">
		</cfinvoke>
		<cfset scopesQuery = getScopesResult.scopesAreas>
		<cfset scopeAreasList = valueList(scopesQuery.area_id)>

	<cfelse>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Scope" method="getScopeAllAreasIds" returnvariable="getScopesResult">
			<cfinvokeargument name="scope_id" value="#scope_id#">
		</cfinvoke>
		<cfset scopeAreasList = getScopesResult.areasIds>
		
	</cfif>
	
</cfif>

<cfprocessingdirective suppresswhitespace="true">
<div id="areasTreeContainer" style="clear:both">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaTree" method="outputMainTree">
		<cfif APPLICATION.publicationScope IS true AND isDefined("scope_id") AND listLen(scopeAreasList) GT 0>
			<cfinvokeargument name="enable_only_areas_ids" value="#scopeAreasList#"><!--- Habilita sólo las áreas pasadas y sus descendientes --->
		</cfif>
		<cfinvokeargument name="get_user_id" value="#SESSION.user_id#">
	</cfinvoke>

</div>
</cfprocessingdirective>
<div style="height:2px; clear:both;"><!-- --></div>