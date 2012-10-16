<cfoutput>
<div class="box_border_sup"><img src="../assets/box_border_sup.jpg" alt="ASNC" title="ASNC" /></div>
<div class="box_border_content">

	<cfif isDefined("parent_area_name")><!---APARTADO--->
		<cfset page_title = titleToUrl(parent_area_name)>
	
		<p><a href="page.cfm?id=#getArea.parent_id#&title=#page_title#" class="link_bold_14px">#parent_area_name#</a></p>
	<cfelse><!---Si no está definido parent_area_name es porque esta es el área padre--->
		<cfset page_title = titleToUrl(area_name)>
	
		<p><a href="page.cfm?id=#area_id#&title=#page_title#" class="link_bold_14px">#area_name#</a></p>
	</cfif>
	<br />
	
	<cfif getArea.parent_id IS rootAreaId><!---Apartados--->
		<cfset subAreasQuery = menuSubAreasQueries[getArea.id]>
	<cfelseif isDefined("menuSubAreasQueries[getArea.parent_id]")><!---Subapartados--->
		<cfset subAreasQuery = menuSubAreasQueries[getArea.parent_id]>
	<cfelse><!---Subsubapartados--->
		
		<cfinvoke component="#APPLICATION.componentsPath#/components/AreaQuery" method="getArea" returnvariable="selectParentAreaQuery">
			<cfinvokeargument name="area_id" value="#getArea.parent_id#">
			<cfinvokeargument name="with_user" value="false">
			<cfinvokeargument name="client_abb" value="#clientAbb#">
			<cfinvokeargument name="client_dsn" value="#clientDsn#">
		</cfinvoke>
	
		<cfset subAreasQuery = menuSubAreasQueries[selectParentAreaQuery.parent_id]>
	</cfif>
	
	<cfif subAreasQuery.recordCount GT 0>
	<ul class="submenu">
		<cfloop query="subAreasQuery"><!---SUBAPARTADOS--->
			<cfset subarea_name = subAreasQuery.name>
			
			<cfif subAreasQuery.id IS area_id><!--- isDefined("area_id") AND --->
				<cfset cur_subarea = true>
			<cfelse>
				<cfset cur_subarea = false>
			</cfif>
			
			<cfif subAreasQuery.id IS area_id OR (isDefined("sub_area_id") AND subAreasQuery.id IS sub_area_id)>
				<cfset cur_submenu = true>
			<cfelse>
				<cfset cur_submenu = false>
			</cfif>
			
			<cfset subpage_title = titleToUrl(subarea_name)>
			
			<li <cfif cur_subarea>class="paginaActual"</cfif>><a href="page.cfm?id=#subAreasQuery.id#&title=#subpage_title#">#subarea_name#</a>
				
				<cfif cur_submenu IS true><!---Se muestran los subapartados--->
				
					<cfset subSubAreasQuery = menuSubSubAreasQueries[subAreasQuery.id]>
					<cfif subSubAreasQuery.recordCount GT 0>
						<ul>
						<cfloop query="subSubAreasQuery"><!---SUBSUBAPARTADOS--->
							<cfif subSubAreasQuery.id IS area_id>
								<cfset cur_subsubarea = true>
							<cfelse>
								<cfset cur_subsubarea = false>
							</cfif>
							
							<cfset subsubpage_title = titleToUrl(subSubAreasQuery.name)>
							
							<li <cfif cur_subsubarea>class="paginaActual"</cfif>><a href="page.cfm?id=#subSubAreasQuery.id#&title=#subsubpage_title#">#subSubAreasQuery.name#</a></li>
						</cfloop>
						</ul>
					</cfif>
					
				</cfif>
			</li>
			
			
		</cfloop>
	</ul>
	
	<cfelseif getArea.id IS 500><!---Contacto--->
	
	<ul class="submenu">
		<li <cfif getFileFromPath(CGI.SCRIPT_NAME) EQ "formulario_contacto.cfm">class="paginaActual"</cfif>><a href="formulario_contacto.cfm">Formulario de contacto</a></li>
	</ul>
		
	</cfif>

</div>
<div class="box_border_bottom"><img src="../assets/box_border_bottom.jpg" alt="ASNC" title="ASNC" /></div>
</cfoutput>