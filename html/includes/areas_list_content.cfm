<cfif isDefined("URL.search") AND isDefined("search_text") AND isDefined("limit_to")>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getAreas" returnvariable="areasResponse">
		<cfinvokeargument name="search_text" value="#search_text#">	
		<cfinvokeargument name="limit" value="#limit_to#">
	</cfinvoke>
	
	<cfset areasQuery = areasResponse.areas>

	<cfoutput>
	<div class="div_search_results_text" style="margin-bottom:5px; margin-top:5px;"><span lang="es">Resultado:</span> #areasQuery.recordCount# <span lang="es"><cfif areasQuery.recordCount GT 1>Áreas<cfelse>Áreas</cfif></span></div>
	</cfoutput>
	
	<!---<div class="div_items">--->
		
		<cfif areasQuery.recordCount GT 0>
	
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="outputAreasFullList">
				<cfinvokeargument name="areasQuery" value="#areasQuery#">
				<cfinvokeargument name="loggedUser" value="#loggedUser#">
				<cfinvokeargument name="small" value="true">
			</cfinvoke>
	
		<cfelse>
			
			<!---<script type="text/javascript">
				openUrlHtml2('empty.cfm','itemIframe');
			</script>--->
		
			<span lang="es">No se han encontrado áreas.</span>
		</cfif>
		
	<!---</div>--->	
	
<cfelse>
	
	<!---<script type="text/javascript">
		openUrlHtml2('empty.cfm','itemIframe');
	</script>--->
	
	<div class="alert alert-info" style="margin:10px;background-color:#65C5BD"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Rellene el formulario y haga click en BUSCAR</span></div>
	
</cfif>