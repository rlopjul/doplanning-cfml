<!---Copyright Era7 Information Technologies 2007-2013

	Date of file creation: 25-04-2012
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena

--->
<cfcomponent output="false">

	<cfset component = "AreaQuery">

	<cfset dbDateTimeFormat = "%d-%m-%Y %H:%i:%s">
	<!--- <cfset timeZoneTo = "+1:00"> --->
	<cfset timeZoneTo = "Europe/Madrid">

	<!---getArea--->

	<cffunction name="getArea" output="false" returntype="query" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		<!---<cfargument name="area_type" type="string" required="no">--->
		<cfargument name="with_user" type="boolean" required="no" default="true">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getArea">

			<cfquery name="selectAreaQuery" datasource="#client_dsn#">
				SELECT areas.id, areas.name, areas.parent_id, areas.user_in_charge, areas.description, areas.image_id, areas.link, areas.type, areas.default_typology_id, areas.hide_in_menu, areas.menu_type_id, areas.item_type_1_enabled, areas.item_type_2_enabled, areas.item_type_3_enabled, areas.item_type_4_enabled, areas.item_type_5_enabled, areas.item_type_6_enabled,  areas.item_type_7_enabled, areas.item_type_8_enabled, areas.item_type_9_enabled, areas.item_type_10_enabled, areas.item_type_11_enabled, areas.item_type_12_enabled, areas.item_type_13_enabled, areas.item_type_14_enabled, areas.item_type_15_enabled, areas.item_type_16_enabled, areas.item_type_17_enabled, areas.item_type_20_enabled, areas.users_visible, areas.read_only, areas.list_mode, areas.url_id
				, DATE_FORMAT(CONVERT_TZ(areas.creation_date,'SYSTEM','#timeZoneTo#'), '#dbDateTimeFormat#') AS creation_date
				<cfif arguments.with_user IS true>
				, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name
				</cfif>
				FROM `#client_abb#_areas` AS areas
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


	<!------------------------ IS USER RESPONSIBLE OF AREA-------------------------------------->

	<cffunction name="getAreaResponsible" returntype="query" output="false" access="public">
		<cfargument name="area_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getAreaResponsible">

		<cfset var response = structNew()>

			<!---getUserAreaResponsible--->
			<cfquery name="areaResponsibleQuery" datasource="#client_dsn#">
				SELECT areas.user_in_charge, areas.parent_id
				FROM #client_abb#_areas AS areas
				WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

		<cfreturn areaResponsibleQuery>

	</cffunction>





	<!---getRootArea--->

	<!---Devuelve el área raiz real del árbol--->

	<cffunction name="getRootArea" output="false" returntype="query" access="public">
		<cfargument name="onlyId" type="boolean" required="no" default="false">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getRootArea">

			<cfquery name="rootAreaQuery" datasource="#client_dsn#">
				SELECT areas.id <cfif arguments.onlyId IS false>, areas.name, areas.user_in_charge, areas.description, version_tree</cfif>
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
				WHERE areas.parent_id = <cfqueryparam value="#arguments.root_area_id#" cfsqltype="cf_sql_integer">
				ORDER BY areas.name ASC;
			</cfquery>

		<cfreturn rootAreasQuery>

	</cffunction>


	<!---getSubAreas--->

	<cffunction name="getSubAreas" output="false" returntype="query" access="public">
		<cfargument name="area_id" type="string" required="yes">
		<cfargument name="remove_order" type="boolean" required="no" default="false">

		<cfargument name="menu_type_id" type="numeric" required="false">

		<cfargument name="with_description" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getSubAreas">

			<cfquery name="subAreasQuery" datasource="#client_dsn#">
				SELECT id, <cfif arguments.remove_order IS true>SUBSTRING_INDEX(name, '.-', -1) AS name<cfelse>name</cfif>, parent_id, creation_date, user_in_charge, image_id, link, type, menu_type_id, hide_in_menu, url_id, read_only
				<cfif arguments.with_description IS true>
					, description
				</cfif>
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

	<cffunction name="getSubAreasIds" output="false" returntype="string" access="public">
		<cfargument name="area_id" type="numeric" required="yes">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getSubAreasIds">

		<cfset var areas_list = "">
		<cfset var new_areas_list = "">

			<cfquery name="subAreasQuery" datasource="#client_dsn#">
				SELECT id
				FROM #client_abb#_areas AS areas
				WHERE areas.parent_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfloop query="subAreasQuery">

				<cfset areas_list = ListAppend(areas_list,subAreasQuery.id)>

				<cfinvoke component="AreaQuery" method="getSubAreasIds" returnvariable="new_areas_list">
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


	<!---geSubAreasIds--->

	<!--- Este método con errata en el nombre se mantiene para retrocompatibilidad con versiones anteriores de DPWeb --->

	<cffunction name="geSubAreasIds" output="false" returntype="string" access="public">
		<cfargument name="area_id" type="numeric" required="yes">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var areas_list = "">

			<cfinvoke component="AreaQuery" method="getSubAreasIds" returnvariable="areas_list">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

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
		<cfargument name="from_area_id" type="numeric" required="no"><!---Define el área a partir de la cual se muestra la ruta--->
		<cfargument name="include_from_area" type="boolean" required="false" default="false">
		<cfargument name="path" type="string" required="no" default="">
		<cfargument name="separator" type="string" required="no" default="/">
		<cfargument name="with_base_link" type="string" required="no" default=""><!---Define si se debe enlazar el área y cuál es la url base a la que se añadirá el id del área--->
		<cfargument name="hide_menu_type_area" type="boolean" required="false" default="false">
		<cfargument name="cur_area_link_class" type="string" required="false" default="">
		<cfargument name="cur_area_link_styles" type="string" required="false" default="">
		<cfargument name="area_link_styles" type="string" required="false" default="">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getAreaPath">

		<cfset var area_path = "">
		<cfset var cur_area = "">
		<cfset var area_dot = 0>

		<cfif NOT isDefined("arguments.from_area_id") OR arguments.include_from_area IS true OR arguments.area_id NEQ arguments.from_area_id><!---Si el área de inicio no es el área actual o se incluye el área de inicio en la ruta)--->

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

							<cfif len(arguments.cur_area_link_class) GT 0>
								<cfset arguments.cur_area_link_class = 'class="#arguments.cur_area_link_class#"'>
							</cfif>
							<cfif len(arguments.area_link_styles) GT 0 OR len(arguments.cur_area_link_styles) GT 0>
								<cfset arguments.cur_area_link_styles = ' style="#arguments.area_link_styles##arguments.cur_area_link_styles#"'>
							</cfif>

							<cfset cur_area = '<a href="'&arguments.with_base_link&arguments.area_id&'" #arguments.cur_area_link_class##arguments.cur_area_link_styles#>'&cur_area&'</a>'>
						</cfif>

						<cfif len(arguments.path) GT 0>
							<cfset arguments.path = cur_area&separator&arguments.path>
						<cfelse>
							<cfset arguments.path = cur_area>
						</cfif>

					</cfif>

					<cfif isDefined("arguments.from_area_id") AND arguments.area_id EQ arguments.from_area_id>

						<cfset area_path = arguments.path>

					<cfelse>

						<cfinvoke component="AreaQuery" method="getAreaPath" returnvariable="area_path">
							<cfinvokeargument name="area_id" value="#getAreaQuery.parent_id#">
							<cfif isDefined("arguments.from_area_id")>
							<cfinvokeargument name="from_area_id" value="#arguments.from_area_id#">
							<cfinvokeargument name="include_from_area" value="#arguments.include_from_area#">
							</cfif>
							<cfinvokeargument name="path" value="#arguments.path#">
							<cfinvokeargument name="separator" value="#arguments.separator#">
							<cfinvokeargument name="with_base_link" value="#arguments.with_base_link#">
							<cfinvokeargument name="hide_menu_type_area" value="#arguments.hide_menu_type_area#">
							<cfinvokeargument name="area_link_styles" value="#arguments.area_link_styles#">

							<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
							<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
						</cfinvoke>

					</cfif>

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
		<cfset var typeAreaId = "">

		<cfquery datasource="#client_dsn#" name="getAreaType">
			SELECT areas.type, areas.parent_id, areas.id
			FROM #client_abb#_areas AS areas
			WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>

		<cfif getAreaType.recordCount GT 0>

			<cfif len(getAreaType.type) GT 0>

				<cfset areaType = getAreaType.type>
				<cfset typeAreaId = getAreaType.id>

			<cfelse>

				<cfif isNumeric(getAreaType.parent_id)>

					<cfinvoke component="AreaQuery" method="getAreaType" returnvariable="typeResponse">
						<cfinvokeargument name="area_id" value="#getAreaType.parent_id#">
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

					<cfset areaType = typeResponse.areaType>
					<cfset typeAreaId = typeResponse.typeAreaId>

				</cfif>

			</cfif>

		<cfelse><!---The area does not exist--->

			<cfset error_code = 401>
			<cfthrow errorcode="#error_code#">

		</cfif>

		<cfset response = {result="true", areaType=#areaType#, typeAreaId=#typeAreaId#}>
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
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="url_id" type="string" required="false">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getAreaTypeWeb">

		<cfset var areaType = "">
		<cfset var menuType = "">
		<cfset var link = "">

		<cfquery datasource="#client_dsn#" name="getAreaType">
			SELECT areas.type, areas.parent_id, areas.id, areas.name, areas.description, areas.menu_type_id, image_id, link, url_id
			FROM #client_abb#_areas AS areas
			<cfif isDefined("arguments.url_id")>
				WHERE areas.url_id = <cfqueryparam value="#arguments.url_id#" cfsqltype="cf_sql_varchar">
			<cfelse>
				WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
			</cfif>;
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

		<cfif isNumeric(getAreaType.image_id)>
			<cfset link = getAreaType.link>
		</cfif>

		<cfset response = {result="true", areaType=#areaType#, id=#getAreaType.id#, name=#getAreaType.name#, parent_id=#getAreaType.parent_id#, description=#getAreaType.description#, menu_type_id=#menuType#, link=#link#, url_id=#getAreaType.url_id#}>
		<cfreturn response>

	</cffunction>



	<!---getAreaImageId--->

	<!---Devuelve la imagen del área--->

	<cffunction name="getAreaImageId" output="false" returntype="numeric" access="public">
		<cfargument name="area_id" type="numeric" required="yes">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getAreaImageId">

			<!---
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

			</cfif>--->

			<cfinvoke component="AreaQuery" method="getAreaInheritedImage" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfreturn response.image_id>

	</cffunction>


	<!---getAreaInheritedImage--->

	<!---Devuelve la imagen a mostrar área--->

	<cffunction name="getAreaInheritedImage" output="false" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="yes">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">

		<cfset var method = "getAreaInheritedImage">

		<cfset var response = structNew()>

			<cfquery name="areaImageQuery" datasource="#arguments.client_dsn#">
				SELECT areas.parent_id, areas.image_id, areas.link
				FROM #client_abb#_areas AS areas
				<!---LEFT JOIN #client_abb#_areas_images AS images ON areas.image_id = images.id--->
				WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif areaImageQuery.recordCount GT 0>

				<cfif NOT isNumeric(areaImageQuery.image_id)>

					<cfif isNumeric(areaImageQuery.parent_id) AND areaImageQuery.parent_id GT 0>
						<cfinvoke component="AreaQuery" method="getAreaInheritedImage" returnvariable="response">
							<cfinvokeargument name="area_id" value="#areaImageQuery.parent_id#">

							<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
							<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
						</cfinvoke>
					<cfelse><!---Area image not found--->

						<!---<cfreturn -1>--->

						<cfset response = {result=true, image_id=-1, link=""}>
					</cfif>

				<cfelse>

					<cfset response = {result=true, image_id=#areaImageQuery.image_id#, link=#areaImageQuery.link#}>
				</cfif>

				<cfreturn response>

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


	<!--- -------------------------- updateAreaVersionTree -------------------------------- --->

	<cffunction name="updateAreaVersionTree" returntype="void" access="public">
		<cfargument name="area_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getMenuTypeList">

		<cfquery datasource="#client_dsn#" name="saveCache">
			UPDATE #client_abb#_areas
			SET version_tree = version_tree+1
			WHERE id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>

	</cffunction>


	<!--- -------------------------- getAreas -------------------------------- --->

	<cffunction name="getAreas" returntype="struct" output="false" access="public">
		<cfargument name="areas_ids" type="string" required="false">
		<cfargument name="search_text" type="string" required="false" default="">
		<cfargument name="from_date" type="string" required="no">
		<cfargument name="end_date" type="string" required="no">
		<cfargument name="order_by" type="string" required="false" default="name">
		<cfargument name="order_type" type="string" required="false" default="ASC">
		<cfargument name="limit" type="numeric" required="false">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">
		<cfargument name="remove_order" type="string" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getAreas">

		<cfset var response = structNew()>

		<cfset var text_re = "">

			<cfif len(arguments.search_text) GT 0>
				<cfinvoke component="#APPLICATION.coreComponentsPath#/SearchManager" method="generateSearchText" returnvariable="text_re">
					<cfinvokeargument name="text" value="#arguments.search_text#">
				</cfinvoke>
			</cfif>

			<cfquery datasource="#client_dsn#" name="areasQuery">
				SELECT areas.id, <cfif arguments.remove_order IS true>SUBSTRING_INDEX(areas.name, '.-', -1) AS name<cfelse>areas.name</cfif>, areas.parent_id, areas.user_in_charge, areas.description, areas.image_id, areas.link, areas.type, areas.default_typology_id, areas.hide_in_menu, areas.menu_type_id, areas.item_type_1_enabled, areas.item_type_2_enabled, areas.item_type_3_enabled, areas.item_type_4_enabled, areas.item_type_5_enabled, areas.item_type_6_enabled,  areas.item_type_7_enabled, areas.item_type_8_enabled, areas.item_type_9_enabled, areas.item_type_10_enabled, areas.item_type_11_enabled, areas.item_type_12_enabled, areas.item_type_13_enabled, areas.item_type_14_enabled, areas.item_type_15_enabled, areas.item_type_16_enabled, areas.item_type_20_enabled, areas.users_visible, areas.read_only, areas.id AS area_id, <cfif arguments.remove_order IS true>SUBSTRING_INDEX(areas.name, '.-', -1) AS area_name<cfelse>areas.name AS area_name</cfif>
				<cfif arguments.parse_dates IS true>
					, DATE_FORMAT(CONVERT_TZ(areas.creation_date,'SYSTEM','#timeZoneTo#'), '#dbDateTimeFormat#') AS creation_date
				<cfelse>
					, areas.creation_date
				</cfif>
				FROM #client_abb#_areas AS areas
				WHERE 1=1
				<cfif isDefined("arguments.areas_ids")>
					AND areas.id IN (<cfqueryparam value="#arguments.areas_ids#" list="true" cfsqltype="cf_sql_varchar"/>)
				</cfif>
				<cfif isDefined("arguments.from_date")>
					AND areas.creation_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateFormat#')
				</cfif>
				<cfif isDefined("arguments.end_date")>
					AND areas.creation_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#dbDateTimeFormat#')
				</cfif>
				<cfif len(arguments.search_text) GT 0>
					AND
					(areas.name REGEXP <cfqueryparam value="#text_re#" cfsqltype="cf_sql_varchar">
					OR areas.description REGEXP <cfqueryparam value="#text_re#" cfsqltype="cf_sql_varchar">)
				</cfif>
				ORDER BY #arguments.order_by# #arguments.order_type#
				<cfif isDefined("arguments.limit")>
					LIMIT #arguments.limit#
				</cfif>;
			</cfquery>

			<cfset response = {result=true, areas=#areasQuery#}>

		<cfreturn response>

	</cffunction>


	<!--- ---------------------------- getAreaUsers ------------------------------- --->

	<!--- Hay un método en UserManager que se llama igual que este, pero este es más simple --->

	<cffunction name="getAreaUsers" returntype="query" output="false" access="public">
		<cfargument name="area_id" type="string" required="false">
		<cfargument name="areas_ids" type="string" required="false">
		<cfargument name="from_date" type="string" required="no">
		<cfargument name="end_date" type="string" required="no">
		<cfargument name="order_by" type="string" required="false" default="name">
		<cfargument name="order_type" type="string" required="false" default="ASC">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">
		<cfargument name="with_area" type="boolean" required="false" default="false">

		<cfquery name="membersQuery" datasource="#client_dsn#">
			SELECT users.id, users.email, users.name, users.telephone, users.family_name, users.mobile_phone, users.telephone_ccode, users.mobile_phone_ccode, users.image_type
			, CONCAT_WS(' ', users.family_name, users.name) AS user_full_name, areas_users.area_id
			<cfif arguments.parse_dates IS true>
				, DATE_FORMAT(CONVERT_TZ(areas_users.association_date,'SYSTEM','#timeZoneTo#'), '#dbDateTimeFormat#') AS association_date
			<cfelse>
				, areas_users.association_date
			</cfif>
			<cfif arguments.with_area IS true>
				, areas.name AS area_name
			</cfif>
			FROM #client_abb#_users AS users
			INNER JOIN #client_abb#_areas_users AS areas_users ON users.id = areas_users.user_id
			<cfif arguments.with_area IS true>
				INNER JOIN #client_abb#_areas AS areas ON areas.id = areas_users.area_id
			</cfif>
			<cfif isDefined("arguments.from_date")>
				AND areas_users.association_date >= STR_TO_DATE(<cfqueryparam value="#arguments.from_date#" cfsqltype="cf_sql_varchar">,'#APPLICATION.dbDateFormat#')
			</cfif>
			<cfif isDefined("arguments.end_date")>
				AND areas_users.association_date <= STR_TO_DATE(<cfqueryparam value="#arguments.end_date# 23:59:59" cfsqltype="cf_sql_varchar">,'#dbDateTimeFormat#')
			</cfif>
			<cfif isDefined("arguments.area_id")>
				AND areas_users.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
			<cfelseif isDefined("arguments.areas_ids")>
				AND areas_users.area_id IN (<cfqueryparam value="#arguments.areas_ids#" cfsqltype="cf_sql_varchar" list="true">)
			</cfif>
			ORDER BY #arguments.order_by# #arguments.order_type#;
		</cfquery>

		<cfreturn membersQuery>

	</cffunction>




</cfcomponent>
