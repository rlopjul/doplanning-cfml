<cfinclude template="#APPLICATION.path#/templates_pages/udf_url.cfm">

<!---getSubAreas--->
<cfinvoke component="#APPLICATION.componentsPath#/components/AreaQuery" method="getSubAreas" returnvariable="menuAreasQuery">
	<cfinvokeargument name="area_id" value="#rootAreaId#">
	<cfinvokeargument name="remove_order" value="true">
					
	<cfinvokeargument name="client_abb" value="#clientAbb#">
	<cfinvokeargument name="client_dsn" value="#clientDsn#">
</cfinvoke>

<cfset menuSubAreasQueries = structNew()>
<cfset menuSubSubAreasQueries = structNew()>
<cfif isDefined("area_id")><!---En páginas como la de inicio area_id no está definido--->
	<cfset parent_area_id = area_id><!---Si no hay subapartados, el área padre es el área actual--->
</cfif>

<div id="contenedor_menu">
	<div id="menu_superior">
		<ul class="pureCssMenu intranet">
		
			<cfoutput>
			<li id="menuinicio" <cfif GetFileFromPath(CGI.SCRIPT_NAME) EQ "index.cfm">class="apartadoActual"</cfif>><a href="../intranet/index.cfm">Inicio</a></li>
			<cfloop query="menuAreasQuery">
				
				<cfset menu_area_name = menuAreasQuery.name>	
				
				<cfset cur_menu = false>												
				<cfif isDefined("getArea")>
					<cfif menuAreasQuery.id IS getArea.parent_id>
						<cfset parent_area_name = menu_area_name>
						<cfset parent_area_id = menuAreasQuery.id>
						<cfset cur_menu = true>
					<cfelseif menuAreasQuery.id IS getArea.id>
						<cfset cur_menu = true>
					</cfif>
				</cfif>
				<li id="menu#menuAreasQuery.id#"><!---<cfif cur_menu>class="apartadoActual"</cfif>--->

				<a href="../intranet/page.cfm?id=#menuAreasQuery.id#"><span>#menu_area_name#</span><![if gt IE 6]></a><![endif]><!--[if lte IE 6]><table><tr><td><![endif]-->
				
				<!---getSubAreas--->
				<cfinvoke component="#APPLICATION.componentsPath#/components/AreaQuery" method="getSubAreas" returnvariable="menuSubAreasQuery">
					<cfinvokeargument name="area_id" value="#menuAreasQuery.id#">
					<cfinvokeargument name="remove_order" value="true">
									
					<cfinvokeargument name="client_abb" value="#clientAbb#">
					<cfinvokeargument name="client_dsn" value="#clientDsn#">
				</cfinvoke>
				
				<cfset menuSubAreasQueries[menuAreasQuery.id] = menuSubAreasQuery>
				
				<cfif menuSubAreasQuery.recordCount GT 0>

					<ul class="menu_segundo_nivel">
						<cfloop query="menuSubAreasQuery">
						
							<cfset cur_submenu = false>	
							<cfif isDefined("getArea")>
								<cfif menuSubAreasQuery.id IS getArea.parent_id><!---Si este subarea es padre del área actual--->
									<cfset parent_area_name = menu_area_name>
									<cfset parent_area_id =  menuSubAreasQuery.parent_id>
									<cfset sub_area_name = menuSubAreasQuery.name><!---Esta variable es para mostrar la ruta del subapartado--->
									<cfset sub_area_id = menuSubAreasQuery.id><!---Esta variable es para obtener el subapartado actual y mostrar en el menu de la izquierda sus subapartados--->
									<cfset cur_submenu = true>
								<cfelseif menuSubAreasQuery.id IS getArea.id>
									<cfset cur_submenu = true>
								</cfif>
							</cfif>
						
							<!---getSubSubAreas--->
							<cfinvoke component="#APPLICATION.componentsPath#/components/AreaQuery" method="getSubAreas" returnvariable="menuSubSubAreasQuery">
								<cfinvokeargument name="area_id" value="#menuSubAreasQuery.id#">
								<cfinvokeargument name="remove_order" value="true">
												
								<cfinvokeargument name="client_abb" value="#clientAbb#">
								<cfinvokeargument name="client_dsn" value="#clientDsn#">
							</cfinvoke>
							
							<cfset menuSubSubAreasQueries[menuSubAreasQuery.id] = menuSubSubAreasQuery>
							<cfif menuSubSubAreasQuery.recordCount GT 0>	
							
								<li <cfif isDefined("area_id") AND (menuSubAreasQuery.id IS area_id)>class="subapartadoActual"</cfif>><a href="../intranet/page.cfm?id=#menuSubAreasQuery.id#"><span>#menuSubAreasQuery.name#</span><![if gt IE 6]></a><![endif]><!--[if lte IE 6]><table><tr><td><![endif]-->
														
								<ul class="menu_tercer_nivel"><!---class="pureCssMenum"--->
									<!---<li class="pureCssMenui"><a class="pureCssMenui" href="#">Internet Explorer</a></li>--->
									<cfloop query="menuSubSubAreasQuery">
									<li <cfif isDefined("area_id") AND menuSubSubAreasQuery.id IS area_id>class="subapartadoActual"</cfif>><a href="../intranet/page.cfm?id=#menuSubSubAreasQuery.id#">#menuSubSubAreasQuery.name#</a></li>
									</cfloop>
								</ul>
								
								<!--[if lte IE 6]></td></tr></table></a><![endif]-->
								</li>
							<cfelse>
							
								<li <cfif isDefined("area_id") AND (menuSubAreasQuery.id IS area_id)>class="subapartadoActual"</cfif>><a href="../intranet/page.cfm?id=#menuSubAreasQuery.id#">#menuSubAreasQuery.name#</a></li>
							</cfif>
							
						</cfloop>
					</ul>
					
				</cfif>
				<!--[if lte IE 6]></td></tr></table></a><![endif]-->
				
				</li>
			
			</cfloop>	
			</cfoutput>
			
		</ul>
	</div><!--fin menu superior-->

</div><!--fin contenedor menu-->

<cfif isDefined("parent_area_id")>
	<cfoutput>
	<script type="text/javascript">
		 (function() {mostrarActual("#parent_area_id#"); })();
	</script>
	</cfoutput> 
</cfif>