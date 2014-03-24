<!---get area_type--->
<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaType" returnvariable="areaTypeResult">
	<cfif isDefined("parent_area_id")>
		<cfinvokeargument name="area_id" value="#parent_area_id#">
	<cfelse>
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfif>				
</cfinvoke>

<cfif areaTypeResult.result EQ true>

	<cfset area_type = areaTypeResult.areaType>
	
	<cfif area_type EQ "web" OR area_type EQ "intranet">
		
		<div class="row">
			<div class="col-sm-12">
				<div class="checkbox" style="margin-top:5px;">
					<label class="control-label" for="hide_in_menu" lang="es">
						<input id="hide_in_menu" name="hide_in_menu" type="checkbox" value="true" <cfif objectArea.hide_in_menu IS true>checked="checked"</cfif> />
						Ocultar del menú web
					</label>
					<small class="help-block">
						Si se selecciona esta opción no se mostrará el área ni sus áreas inferiores en el menú web
					</small>
				</div>
			</div>		
		</div>	
		
		<cfset show_type_menu = false>
		
		<cfif isDefined("area_id")><!---si está definidio area_id--->
		<!---solo se muestra si es un área de 3er nivel--->
		
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getArea" returnvariable="objectAreaParent">				
				<cfinvokeargument name="get_area_id" value="#objectArea.parent_id#">
				<cfinvokeargument name="return_type" value="query">
			</cfinvoke>	
			
			<cfset area_parent = objectAreaParent>
			
			<cfif area_parent.type EQ "web" OR area_parent.type EQ "intranet"><!---si es de tipo web o intranet--->
			
				<cfset show_type_menu = true>
			
			</cfif><!---end  si es de tipo web o intranet--->
			
		<cfelseif isDefined("parent_area_id")>
		
			<cfif objectParentArea.type EQ "web" OR objectParentArea.type EQ "intranet">
				<cfset show_type_menu = true>
			</cfif>				
		
		</cfif><!---end si está definidio area_id--->
		
			
		<cfif show_type_menu>
			
			<div class="row">
				<div class="col-sm-2 col-md-3">		
					<label class="control-label" for="menu_type_id" lang="es">Tipo de menú</label>
				</div>
				<div class="col-sm-8 col-md-7">
					<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getMenuTypeList" returnvariable="returnMenuTypeList">				
					</cfinvoke>
					
					<cfif returnMenuTypeList.result EQ true>
					
						<cfset objectMenuTypeList = returnMenuTypeList.menuTypeList>
						
						<cfoutput>
							<select id="menu_type_id" name="menu_type_id" class="form-control">
							<cfloop query="objectMenuTypeList">
								<option value="#objectMenuTypeList.menu_type_id#" <cfif objectArea.menu_type_id EQ objectMenuTypeList.menu_type_id>selected="selected"</cfif> >#objectMenuTypeList.menu_type_title_es#</option>
							</cfloop>
							</select>
						</cfoutput>
						
					<cfelse>
					
						<span>Se ha producido un error al cargar los tipos de menú</span>
					
					</cfif>
				</div>
			</div>					
		
		</cfif>
		
	</cfif>	
	
<cfelse>	
	<div class="alert alert-danger">
		<i class="icon-warning-sign"></i> <span>Error al obtener el tipo de área</span>
	</div>
</cfif>