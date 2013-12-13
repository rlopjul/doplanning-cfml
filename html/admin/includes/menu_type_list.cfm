<cfoutput>

	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getMenuTypeList" returnvariable="returnMenuTypeList">				
	</cfinvoke>
	
	<cfif returnMenuTypeList.result EQ true>
	
		<cfset objectMenuTypeList = returnMenuTypeList.menuTypeList>
		
		<select id="menu_type_id" name="menu_type_id" class="form-control">
		<cfloop query="objectMenuTypeList">
			<option value="#objectMenuTypeList.menu_type_id#" <cfif objectArea.menu_type_id EQ objectMenuTypeList.menu_type_id>selected="selected"</cfif> >#objectMenuTypeList.menu_type_title_es#</option>
		</cfloop>
		</select>
		
	<cfelse>
	
		<label>Se ha producido un error al cargar los tipos de menú</label>
	
	</cfif>

</cfoutput>