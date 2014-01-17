<!---Copyright Era7 Information Technologies 2007-2013

	Date of file creation: 25-04-2012
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	
--->
<cfcomponent output="false">

	<cfset component = "AreaQuery">	
	
	<cfset dateTimeFormat = "%d-%m-%Y %H:%i:%s">
	<cfset timeZoneTo = "+1:00">
	
	<!---getArea--->
		
	<cffunction name="getArea" output="false" returntype="query" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		<!---<cfargument name="area_type" type="string" required="no">--->		
		<cfargument name="with_user" type="boolean" required="no" default="true">
		
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">		
		
		<cfset var method = "getArea">
			
			<cfquery name="selectAreaQuery" datasource="#client_dsn#">
				SELECT areas.id, areas.name, areas.parent_id, areas.user_in_charge, areas.description, areas.image_id, areas.link, areas.type, areas.default_typology_id, areas.hide_in_menu, areas.menu_type_id
				, DATE_FORMAT(CONVERT_TZ(areas.creation_date,'SYSTEM','#timeZoneTo#'), '#dateTimeFormat#') AS creation_date
				<cfif arguments.with_user IS true>
				, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name
				</cfif>
				FROM #client_abb#_areas AS areas
				<cfif arguments.with_user IS true>
				INNER JOIN #client_abb#_users AS users ON areas.user_in_charge = users.id
				</cfif>
				WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				<!---<cfif isDefined("arguments.area_type")>
				, areas.type = <cfqueryparam value="#arguments.type#" cfsqltype="cf_sql_varchar">
				</cfif>--->	
				LIMIT 1;
			</cfquery>
		
		<cfreturn selectAreaQuery>
		
	</cffunction>
	
	
	<!---getRootArea--->
	
	<!---Devuelve el área raiz real del árbol--->
	
	<cffunction name="getRootArea" output="false" returntype="query" access="public">
		<cfargument name="onlyId" type="boolean" required="no" default="false">	
			
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">		
		
		<cfset var method = "getRootArea">
								
			<cfquery name="rootAreaQuery" datasource="#client_dsn#">
				SELECT areas.id <cfif arguments.onlyId IS false>, areas.name, areas.user_in_charge, areas.description</cfif>
				FROM #client_abb#_areas AS areas
				WHERE areas.parent_id IS NULL
				LIMIT 1;
			</cfquery>	
		
		<cfreturn rootAreaQuery>
		
	</cffunction>
	
	
	<!---getRootArea--->
	
	<!---Devuelve las áreas raices visibles en el árbol del usuario--->
	
	<cffunction name="getVisibleRootAreas" output="false" returntype="query" access="public">
		<cfargument name="root_area_id" type="numeric" required="yes">		
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">		
		
		<cfset var method = "getVisibleRootAreas">
								
			<cfquery name="rootAreasQuery" datasource="#client_dsn#">
				SELECT areas.id
				FROM #client_abb#_areas AS areas
				WHERE areas.parent_id = <cfqueryparam value="#arguments.root_area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>	
		
		<cfreturn rootAreasQuery>
		
	</cffunction>
	
	
	<!---getSubAreas--->
	
	<cffunction name="getSubAreas" output="false" returntype="query" access="public">
		<cfargument name="area_id" type="string" required="yes">
		<cfargument name="remove_order" type="boolean" required="no" default="false">

		 <cfargument name="menu_type_id" type="numeric" required="false" >        
		
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">		
		
		<cfset var method = "getSubAreas">
								
			<cfquery name="subAreasQuery" datasource="#client_dsn#">
				SELECT id, <cfif arguments.remove_order IS true>SUBSTRING_INDEX(name, '.-', -1) AS name<cfelse>name</cfif>, parent_id, creation_date, user_in_charge, image_id, link, type, menu_type_id, hide_in_menu
				FROM #client_abb#_areas AS areas
				WHERE areas.parent_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				<cfif isDefined("arguments.menu_type_id")>
                AND menu_type_id = <cfqueryparam value="#arguments.menu_type_id#" cfsqltype="cf_sql_integer">
                </cfif>
				ORDER BY areas.name ASC;
			</cfquery>	
		
		<cfreturn subAreasQuery>
		
	</cffunction>
	
	
	
	<!---getSubAreasIds--->
	
	<cffunction name="geSubAreasIds" output="false" returntype="string" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
				
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">		
		
		<cfset var method = "geSubAreasIds">

		<cfset var areas_list = "">
		<cfset var new_areas_list = "">
								
			<cfquery name="subAreasQuery" datasource="#client_dsn#">
				SELECT id
				FROM #client_abb#_areas AS areas
				WHERE areas.parent_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>	
			
			<cfloop query="subAreasQuery">
			
				<cfset areas_list = ListAppend(areas_list,subAreasQuery.id)>
				
				<cfinvoke component="AreaQuery" method="geSubAreasIds" returnvariable="new_areas_list">
					<cfinvokeargument name="area_id" value="#subAreasQuery.id#">
					
					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>
				
				<cfif len(new_areas_list) GT 0>
					<cfset areas_list = ListAppend(areas_list, new_areas_list)>
				</cfif>
		
			</cfloop>
			
		<cfreturn areas_list>
		
	</cffunction>



	<!---getParentAreasIds--->
	
	<cffunction name="getParentAreasIds" output="false" returntype="string" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="areas_list" type="string" required="false" default="">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
		
		<cfset var method = "getParentAreasIds">

		<cfset var new_areas_list = arguments.areas_list>
								
			<cfquery name="parentAreaQuery" datasource="#client_dsn#">
				SELECT parent_id
				FROM #client_abb#_areas AS areas
				WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>	

			<cfif parentAreaQuery.recordCount GT 0>

				<cfif isNumeric(parentAreaQuery.parent_id)>
					
					<cfset new_areas_list = ListAppend(new_areas_list,parentAreaQuery.parent_id)>
				
					<cfinvoke component="AreaQuery" method="getParentAreasIds" returnvariable="new_areas_list">
						<cfinvokeargument name="area_id" value="#parentAreaQuery.parent_id#">
						<cfinvokeargument name="areas_list" value="#new_areas_list#">
						
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

				</cfif>

				<cfreturn new_areas_list>
				
			<cfelse><!---The area does not exist--->
				
				<cfset error_code = 401>
				
				<cfthrow errorcode="#error_code#">

			</cfif>
		
	</cffunction>
	
	
	
	
	<!---getAreaPath--->
	
	<cffunction name="getAreaPath" returntype="string" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="from_area_id" type="numeric" required="no"><!---Define el área a partir de la cual se muestra la ruta (sin incluirla)--->
		<cfargument name="path" type="string" required="no" default="">
		<cfargument name="separator" type="string" required="no" default="/">
		<cfargument name="with_base_link" type="string" required="no" default=""><!---Define si se debe enlazar el área y cuál es la url base a la que se añadirá el id del área--->
		<cfargument name="hide_menu_type_area" type="boolean" required="false" default="false">
		
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">	
		
		<cfset var method = "getAreaPath">
		
		<cfset var area_path = "">
		<cfset var cur_area = "">
		<cfset var area_dot = 0>
						
		<cfif NOT isDefined("arguments.from_area_id") OR arguments.area_id NEQ arguments.from_area_id><!---Si el área de inicio no es el área actual (no se incluye el área de inicio en la ruta)--->
						
			<cfquery name="getAreaQuery" datasource="#client_dsn#">
				SELECT name, parent_id, menu_type_id
				FROM #client_abb#_areas
				WHERE id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif getAreaQuery.recordCount GT 0>
				
				<cfif isNumeric(getAreaQuery.parent_id)>
										
					<cfif arguments.hide_menu_type_area IS false OR getAreaQuery.menu_type_id IS 1 OR len(getAreaQuery.menu_type_id) IS 0><!---Si no es un área especial de las que NO se deben mostrar en la ruta--->

						<cfset cur_area = getAreaQuery.name>
						
						<cfif len(arguments.with_base_link) GT 0>
						
							<cfset area_dot = find(".-",cur_area)>
							
							<cfif area_dot GT 0>
								<cfset cur_area = right(cur_area, len(cur_area)-(area_dot+1))>
							</cfif>
							
							<cfset cur_area = '<a href="'&arguments.with_base_link&arguments.area_id&'">'&cur_area&'</a>'>
						</cfif>
						
						<cfif len(arguments.path) GT 0>
							<cfset arguments.path = cur_area&separator&arguments.path>
						<cfelse>
							<cfset arguments.path = cur_area>
						</cfif>
							
					</cfif>

					<cfinvoke component="AreaQuery" method="getAreaPath" returnvariable="area_path">
						<cfinvokeargument name="area_id" value="#getAreaQuery.parent_id#">
						<cfif isDefined("arguments.from_area_id")>
						<cfinvokeargument name="from_area_id" value="#arguments.from_area_id#">
						</cfif>
						<cfinvokeargument name="path" value="#arguments.path#">
						<cfinvokeargument name="separator" value="#arguments.separator#">
						<cfinvokeargument name="with_base_link" value="#arguments.with_base_link#">
						<cfinvokeargument name="hide_menu_type_area" value="#arguments.hide_menu_type_area#">
						
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>
					

				<cfelse>
					
					<cfset area_path = arguments.path>
				
				</cfif>
			
			<cfelse><!---The area does not exist--->
				
				<cfset error_code = 301>
				
				<cfthrow errorcode="#error_code#">
			
			</cfif>
			
		<cfelse>
		
			<cfset area_path = arguments.path>
			
		</cfif>
		
		<cfreturn area_path>
					
	</cffunction>
	
	
	
	
	<!--- -------------------------- getAreaType -------------------------------- --->
	<!---Obtiene el tipo del área, si el área no la tiene definida la busca en sus áreas superiores--->
	
	<cffunction name="getAreaType" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">	
		
		<cfset var method = "getAreaType">
		
		<cfset var areaType = "">
					
		<cfquery datasource="#client_dsn#" name="getAreaType">
			SELECT areas.type, areas.parent_id
			FROM #client_abb#_areas AS areas
			WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<cfif getAreaType.recordCount GT 0>
		
			<cfif len(getAreaType.type) GT 0>
			
				<cfset areaType = getAreaType.type>
				
			<cfelse>
					
				<cfif isNumeric(getAreaType.parent_id)>
						
					<cfinvoke component="AreaQuery" method="getAreaType" returnvariable="typeResponse">
						<cfinvokeargument name="area_id" value="#getAreaType.parent_id#">
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>
					
					<cfset areaType = typeResponse.areaType>
					
				</cfif>
				
			</cfif>
			
		<cfelse><!---The area does not exist--->
				
			<cfset error_code = 401>
			<cfthrow errorcode="#error_code#">
		
		</cfif>
		
		<cfset response = {result="true", areaType=#areaType#}>	
		<cfreturn response>
		
	</cffunction>
	
	

	<!--- -------------------------- getAreaMenuType -------------------------------- --->
	<!---Obtiene el tipo de menu del área, si el área no la tiene definida la busca en sus áreas superiores--->
	
	<cffunction name="getAreaMenuType" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">	
		
		<cfset var method = "getAreaMenuType">
		
		<cfset var menuType = "">
					
		<cfquery datasource="#client_dsn#" name="getAreaMenuType">
			SELECT areas.menu_type_id, areas.parent_id
			FROM #client_abb#_areas AS areas
			WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<cfif getAreaMenuType.recordCount GT 0>
		
			<cfif isNumeric(getAreaMenuType.menu_type_id)>
			
				<cfset menuType = getAreaMenuType.menu_type_id>
				
			<cfelse>
					
				<cfif isNumeric(getAreaMenuType.parent_id)>
						
					<cfinvoke component="AreaQuery" method="getAreaMenuType" returnvariable="menuTypeResponse">
						<cfinvokeargument name="area_id" value="#getAreaMenuType.parent_id#">
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>
					
					<cfset menuType = menuTypeResponse.menuType>
					
				</cfif>
				
			</cfif>
			
		<cfelse><!---The area does not exist--->
				
			<cfset error_code = 401>
			<cfthrow errorcode="#error_code#">
		
		</cfif>
		
		<cfset response = {result="true", menuType=#menuType#}>	
		<cfreturn response>
		
	</cffunction>
	
	
	
	<!--- -------------------------- getAreaTypeWeb -------------------------------- --->
	<!---Obtiene el tipo del área, si el área no la tiene definida la busca en sus áreas superiores--->
	<!---Además del tipo de área, devuelve otros valores que son necesarios para la web--->
	
	<cffunction name="getAreaTypeWeb" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">	
		
		<cfset var method = "getAreaTypeWeb">
		
		<cfset var areaType = "">
		<cfset var menuType = "">
					
		<cfquery datasource="#client_dsn#" name="getAreaType">
			SELECT areas.type, areas.parent_id, areas.id, areas.name, areas.description, areas.menu_type_id
			FROM #client_abb#_areas AS areas
			WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<cfif getAreaType.recordCount GT 0>
		
			<cfif len(getAreaType.type) GT 0>
			
				<cfset areaType = getAreaType.type>
				
			<cfelse>
					
				<cfif isNumeric(getAreaType.parent_id)>
						
					<cfinvoke component="AreaQuery" method="getAreaType" returnvariable="typeResponse">
						<cfinvokeargument name="area_id" value="#getAreaType.parent_id#">
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>
					
					<cfset areaType = typeResponse.areaType>
					
				</cfif>
				
			</cfif>

			<cfif isNumeric(getAreaType.menu_type_id)>
				
				<cfset menuType = getAreaType.menu_type_id>

			<cfelse>

				<cfif isNumeric(getAreaType.parent_id)>
						
					<cfinvoke component="AreaQuery" method="getAreaMenuType" returnvariable="menuTypeResponse">
						<cfinvokeargument name="area_id" value="#getAreaType.parent_id#">
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>
					
					<cfset menuType = menuTypeResponse.menuType>
					
				</cfif>

			</cfif>
			
		<cfelse><!---The area does not exist--->
				
			<cfset error_code = 401>
			<cfthrow errorcode="#error_code#">
		
		</cfif>
		
		<cfset response = {result="true", areaType=#areaType#, id=#getAreaType.id#, name=#getAreaType.name#, parent_id=#getAreaType.parent_id#, description=#getAreaType.description#, menu_type_id=#menuType#}>	
		<cfreturn response>
		
	</cffunction>
	
	
	
	<!---getAreaImageId--->
	
	<!---Devuelve la imagen del área--->
	
	<cffunction name="getAreaImageId" output="false" returntype="numeric" access="public">
		<cfargument name="area_id" type="numeric" required="yes">	
			
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">		
		
		<cfset var method = "getAreaImageId">
								
			<cfquery name="areaImageIdQuery" datasource="#arguments.client_dsn#">
				SELECT areas.parent_id, images.id AS image_id
				FROM #client_abb#_areas AS areas LEFT JOIN #client_abb#_areas_images AS images ON areas.image_id = images.id
				WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>	
		
			<cfif areaImageIdQuery.recordCount GT 0>
			
				<cfif NOT isNumeric(areaImageIdQuery.image_id)>
				
					<cfif isNumeric(areaImageIdQuery.parent_id) AND areaImageIdQuery.parent_id GT 0> 
						<cfinvoke component="AreaQuery" method="getAreaImageId" returnvariable="area_image_id">
							<cfinvokeargument name="area_id" value="#areaImageIdQuery.parent_id#">
							
							<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
							<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
						</cfinvoke>
					<cfelse><!---Area image not found--->
			
						<!---<cfset error_code = 406>
						<cfthrow errorcode="#error_code#">--->
						
						<cfreturn -1>
					</cfif>	
					
				<cfelse>
					<cfset area_image_id = areaImageIdQuery.image_id>	
				</cfif>
				
				<cfreturn area_image_id>
				
			<cfelse><!---Area does not exist--->
			
				<cfset error_code = 401>
			
				<cfthrow errorcode="#error_code#">
					
			</cfif>	
		
	</cffunction>
	
	
	<!--- -------------------------- getMenuTypeList -------------------------------- --->
	<!---Obtiene la lista de menu type--->
	
	<cffunction name="getMenuTypeList" returntype="query" access="public">
		
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">	
		
		<cfset var method = "getMenuTypeList">
					
		<cfquery datasource="#client_dsn#" name="getMenuTypeList">
			SELECT *
			FROM #client_abb#_menu_types AS menu_types;
		</cfquery>

		<cfreturn getMenuTypeList>
		
	</cffunction>	
	
    
  
</cfcomponent>