<!---Copyright Era7 Information Technologies 2007-2012

    File created by: ppareja
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 15-11-2012
	
	07-09-2012 alucena: añadido eliminación de nuevos elementos al eliminar área
	29-09-2012 alucena: reemplazado "true" por true en comparaciones de booleanos
	15-11-2012 alucena: cambiado getAreaImageId
	14-01-2012 alucena: quitado description de los archivos en getAreaFiles
	19-06-2013 alucena: cambios por errores en comprobación de permisos al realizar importación de usuarios
	
--->
<cfcomponent output="false">
	
	<cfset component = "AreaManager">
	
	<cfset messageTypeId = 1>
	
	<cfinclude template="includes/functions.cfm">
	
	<!--- ----------------------- XML AREA -------------------------------- --->
	
	<cffunction name="xmlArea" returntype="string" output="false" access="public">		
		<cfargument name="objectArea" type="struct" required="yes">
		
		<cfset var method = "xmlArea">
		
		<cftry>
		
			<cfprocessingdirective suppresswhitespace="true">
			<cfsavecontent variable="xmlResult"><cfoutput><area id="#objectArea.id#"
						 parent_id="#objectArea.parent_id#"
						 user_in_charge="#objectArea.user_in_charge#"
						 creation_date="#objectArea.creation_date#"
						<cfif len(objectArea.image_id) GT 0>
						 image_id="#objectArea.image_id#"
						</cfif>
						<cfif len(objectArea.with_image) GT 0>
						 with_image="#objectArea.with_image#"
						</cfif>
						<cfif len(objectArea.link) GT 0>
						 link="#objectArea.link#"
						</cfif>
						<cfif len(objectArea.with_link) GT 0>
						 with_link="#objectArea.with_link#"
						</cfif>
						<cfif len(objectArea.type) GT 0>
						 type="#objectArea.type#"
						</cfif>
						<cfif len(objectArea.default_typology_id) GT 0>
						 default_typology_id="#objectArea.default_typology_id#"
						</cfif>>
						<name><![CDATA[#objectArea.name#]]></name>
						<description><![CDATA[#objectArea.description#]]></description>
						<cfif len(objectArea.user_full_name) GT 0>
						<user_full_name><![CDATA[#objectArea.user_full_name#]]></user_full_name>
						</cfif></area></cfoutput></cfsavecontent>
			</cfprocessingdirective>
			<!---<cfif len(objectArea.image_background_color) GT 0>
			 image_background_color="#objectArea.image_background_color#"
			</cfif>--->
			
			<cfreturn xmlResult>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
				<cfreturn null>
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	
	<!--- ----------------------- AREA OBJECT -------------------------------- --->
	
	<cffunction name="objectArea" returntype="any" output="false" access="public">	
		
		<cfargument name="xml" type="string" required="no">
		
		<cfargument name="id" type="string" required="no" default="">
		<cfargument name="parent_id" type="string" required="no" default="">		
		<cfargument name="parent_kind" type="string" required="no" default="">		
		<cfargument name="user_in_charge" type="string" required="no" default="">
		<cfargument name="creation_date" type="string" required="no" default="">
		<cfargument name="name" type="string" required="no" default="">
		<cfargument name="image_id" type="string" required="no" default="">
		<cfargument name="with_image" type="string" required="no" default="">
		<!---<cfargument name="image_background_color" type="string" required="no" default="">--->
		<cfargument name="link" type="string" required="no" default="">
		<cfargument name="with_link" type="string" required="no" default="">
		<cfargument name="description" type="string" required="no" default="">
		<cfargument name="user_full_name" type="string" required="no" default="">
		<cfargument name="type" type="string" required="no" default="">
		<cfargument name="default_typology_id" type="string" required="false" default="">
		<cfargument name="hide_in_menu" type="string" required="no" default="">
		<cfargument name="menu_type_id" type="string" required="no" default="">
		
		
		<cfargument name="return_type" type="string" required="no">
		
		<cfset var method = "objectArea">
		
		<cftry>
			
			<cfif isDefined("arguments.xml")>
			
				<cfxml variable="xmlArea">
				<cfoutput>
				#arguments.xml#
				</cfoutput>
				</cfxml>
				
				<cfif isDefined("xmlArea.area.XmlAttributes.id")>
					<cfset id=#xmlArea.area.XmlAttributes.id#>
				</cfif>		
					
				<cfif isDefined("xmlArea.area.XmlAttributes.parent_id")>
					<cfset parent_id=#xmlArea.area.XmlAttributes.parent_id#>
				</cfif>
				
				<cfif isDefined("xmlArea.area.XmlAttributes.user_in_charge")>
					<cfset user_in_charge="#xmlArea.area.XmlAttributes.user_in_charge#">
				</cfif>
				
				<cfif isDefined("xmlArea.area.XmlAttributes.creation_date")>
					<cfset creation_date="#xmlArea.area.XmlAttributes.creation_date#">
				</cfif>
				
				<cfif isDefined("xmlArea.area.name.xmlText")>
					<cfset name="#xmlArea.area.name.xmlText#">
				</cfif>
				
				<cfif isDefined("xmlArea.area.XmlAttributes.image_id")>
					<cfset image_id=xmlArea.area.XmlAttributes.image_id>
				</cfif>
				
				<cfif isDefined("xmlArea.area.XmlAttributes.with_image")>
					<cfset with_image=xmlArea.area.XmlAttributes.with_image>
				</cfif>
				
				<cfif isDefined("xmlArea.area.XmlAttributes.link")>
					<cfset link=xmlArea.area.XmlAttributes.link>
				</cfif>
				
				<cfif isDefined("xmlArea.area.XmlAttributes.with_link")>
					<cfset with_link=xmlArea.area.XmlAttributes.with_link>
				</cfif>
				
				<cfif isDefined("xmlArea.area.XmlAttributes.type")>
					<cfset type=xmlArea.area.XmlAttributes.type>
				</cfif>

				<cfif isDefined("xmlArea.area.XmlAttributes.default_typology_id")>
					<cfset default_typology_id=xmlArea.area.XmlAttributes.default_typology_id>
				</cfif>
				
				<cfif isDefined("xmlArea.area.description.xmlText")>
					<cfset description="#xmlArea.area.description.xmlText#">
				</cfif>
				
				<cfif isDefined("xmlArea.area.user_full_name.xmlText")>
					<cfset user_full_name="#xmlArea.area.user_full_name.xmlText#">
				</cfif>
				
				<cfif isDefined("xmlArea.area.XmlAttributes.hide_in_menu")>
					<cfset with_link=xmlArea.area.XmlAttributes.hide_in_menu>
				</cfif>
				
				<cfif isDefined("xmlArea.area.XmlAttributes.menu_type_id")>
					<cfset with_link=xmlArea.area.XmlAttributes.menu_type_id>
				</cfif>				
			
			<cfelseif NOT isDefined("arguments.id")>
				<cfreturn null>
			</cfif>
			
			<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringDate">
				<cfinvokeargument name="timestamp_date" value="#creation_date#">
			</cfinvoke>
			<cfset creation_date = stringDate>
					
			<cfset object = {
				id="#id#",
				parent_id="#parent_id#",
				user_in_charge="#user_in_charge#",
				creation_date="#creation_date#",
				name="#name#",
				image_id="#image_id#",
				with_image="#with_image#",
				link="#link#",
				with_link="#with_link#",
				type="#type#",
				default_typology_id="#default_typology_id#",
				description="#description#",
				user_full_name="#user_full_name#",
				hide_in_menu="#hide_in_menu#", 
				menu_type_id ="#menu_type_id#"
				}>
				
			
			<cfif isDefined("arguments.return_type") AND arguments.return_type EQ "xml">
				
				<cfinvoke component="AreaManager" method="xmlArea" returnvariable="xmlResult">
					<cfinvokeargument name="objectArea" value="#object#">
				</cfinvoke>
				<cfreturn xmlResult>
				
			<cfelse>
			
				<cfreturn object>
				
			</cfif>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
				<cfreturn null>
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	
	<!--- -------------------------- GET AREA PATH -------------------------------- --->
	<!---Devuelve la dirección completa del área pasada como id--->
	<!---A este método accede cualquier usuario, sea interno o no, ya que de él se obtiene el path para enviar las notificaciones por email--->
	
	<cffunction name="getAreaPath" returntype="string" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		<!---<cfargument name="path" type="string" required="no" default="">--->
		
		<cfset var method = "getAreaPath">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cfinclude template="includes/functionStart.cfm">
		
		<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getAreaPath" returnvariable="area_path">
			<cfinvokeargument name="area_id" value="#arguments.area_id#">
			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>
		
		<cfreturn area_path>
					
	</cffunction>


	<!--- -------------------------- getAreaType -------------------------------- --->
	<!---Obtiene el tipo del área, si el área no la tiene definida la busca en sus áreas superiores--->
	
	<cffunction name="getAreaType" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfset var method = "getAreaType">
							
		<cfinclude template="includes/functionStart.cfm">
		
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getAreaType" returnvariable="getAreaTypeResult">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
					

		<cfreturn getAreaTypeResult>
		
	</cffunction>
	
	
	
	
	
	
	
	<!--- -------------------------- CHECK ADMIN ACCESS -------------------------------- --->
	<!---Comprueba si el usuario es el administrador de la organización y si no lanza un error--->
	
	<cffunction name="checkAdminAccess" returntype="void" access="public">
		
		<cfset var method = "checkAdminAccess">
		
		<cfset var user_id = "">

		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cfinclude template="includes/functionStart.cfm">
		
		<cfif SESSION.client_administrator NEQ user_id><!---Te user logged in is not an administrator user--->
			<cfset error_code = 106>
			
			<cfthrow errorcode="#error_code#">		

		</cfif>
			
	</cffunction>
	
	
	<!--- -------------------------- CAN THE USER ACCESS -------------------------------- --->
	<!---Obtiene si el usuario puede acceder al área a partir de la lista pasada--->
	
	<cffunction name="canTheUserAccess" returntype="boolean" access="public">
 		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="allUserAreasList" type="string" required="yes">
		
		<cfset var method = "canTheUserAccess">
		
		<cfinclude template="includes/functionStart.cfm">

		<cfset areaIndex = listFind(arguments.allUserAreasList, #arguments.area_id#)>
		<cfif areaIndex LT 1>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>
		
		<cfreturn access_result>
	
	</cffunction>
	
	
	<!--- -------------------------- CHECK AREA ACCESS -------------------------------- --->
	<!---Comprueba si el usuario puede acceder al área y si no puede lanza un error--->
	<!---Los administradores pueden acceder a todas las áreas aunque no estén en ellas--->
	
	<cffunction name="checkAreaAccess" returntype="void" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfset var method = "checkAreaAccess">
		
		<cfset var access_result = "">
					
		<cfinclude template="includes/functionStart.cfm">
		
		<cfif SESSION.client_administrator NEQ user_id><!---Is not an administrator user--->

			<cfinvoke component="AreaManager" method="canUserAccessToArea" returnvariable="access_result">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>
			
			<cfif access_result IS NOT true>
				<cfset error_code = 104>
				
				<cfthrow errorcode="#error_code#">		
			</cfif>		
		
		</cfif>
			
	</cffunction>
	
	
	
	<!--- -------------------------- canUserAccessToArea -------------------------------- --->
	<!---Comprueba si el usuario puede acceder al área, y devuelve el resultado en una variable--->
	
	<cffunction name="canUserAccessToArea" returntype="boolean" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfset var method = "canUserAccessToArea">
		
		<cfset var access_result = false>
		<cfset var area_users_list = "">
					
		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfquery datasource="#client_dsn#" name="getAreaUsers">
			SELECT areas_users.user_id, areas.parent_id
			FROM #client_abb#_areas_users AS areas_users
			INNER JOIN #client_abb#_areas AS areas ON areas_users.area_id = areas.id 
			AND areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<cfif getAreaUsers.recordCount GT 0>
		
			<cfset area_users_list = ValueList(getAreaUsers.user_id, ",")>
			<cfif listFind(area_users_list, user_id) GT 0>
			
				<cfset access_result = true>
				
			<cfelse>
					
				<cfif isNumeric(getAreaUsers.parent_id)>
						
					<cfinvoke component="AreaManager" method="canUserAccessToArea" returnvariable="access_result">
						<cfinvokeargument name="area_id" value="#getAreaUsers.parent_id#">
					</cfinvoke>
					
				</cfif>
				
			</cfif>
			
		<cfelse><!---No users in area--->
		
			<!---<cfinvoke component="AreaManager" method="getArea" returnvariable="objectArea">
				<cfinvokeargument name="get_area_id" value="#arguments.area_id#">
				<cfinvokeargument name="format_content" value="default">
				<cfinvokeargument name="return_type" value="object">
			</cfinvoke>--->
			<cfquery datasource="#client_dsn#" name="getAreaParent">
				SELECT areas.parent_id
				FROM #client_abb#_areas AS areas
				WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif isNumeric(getAreaParent.parent_id)>
			
				<cfinvoke component="AreaManager" method="canUserAccessToArea" returnvariable="access_result">
					<cfinvokeargument name="area_id" value="#getAreaParent.parent_id#">
				</cfinvoke>
			
			</cfif>
		
		</cfif>
		
		<cfreturn access_result>
		
	</cffunction>
	
	
	
	<!--- -------------------------- CHECK AREA ADMIN ACCESS -------------------------------- --->
	<!---Comprueba si el usuario es administrador del área al que quiere acceder y si no lanza un error--->
	
	<cffunction name="checkAreaAdminAccess" returntype="void" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfset var method = "checkAreaAdminAccess">
		
		<cfset var user_id = "">
		
		<cfset var allUserAreasList = "">
		<cfset var access_result = false>

		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cfinclude template="includes/functionStartOnlySession.cfm">
		
		<cfif SESSION.client_administrator NEQ user_id><!---Is not an administrator user--->

			<cfinvoke component="AreaManager" method="getAllUserAreasAdminList" returnvariable="allUserAreasAdminList">
			</cfinvoke>
			
			<cfinvoke component="AreaManager" method="canTheUserAccess" returnvariable="access_result">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="allUserAreasList" value="#allUserAreasAdminList#">
			</cfinvoke>
	
			<cfif access_result IS NOT true>
				<cfset error_code = 105>
				
				<cfthrow errorcode="#error_code#">		
			</cfif>		
		
		</cfif>
			
	</cffunction>


	<!--- -------------------------- isUserAreaResponsible -------------------------------- --->
	<!---Comprueba si el usuario es responsable del área, y devuelve el resultado en una variable--->
	<!---El administrador general tiene permiso de responsable en todas las áreas--->
	
	<cffunction name="isUserAreaResponsible" returntype="boolean" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		
		<cfset var method = "isUserAreaResponsible">

		<cfset var user_id = "">
		<cfset var client_administrator = "">
		
		<cfset var access_result = false>

		<cfinclude template="includes/functionStartOnlySession.cfm">
					
		<cfif client_administrator IS user_id><!---Is general administrator user--->
			<cfreturn true>
		</cfif>

		<cfquery datasource="#client_dsn#" name="getArea">
			SELECT areas.user_in_charge, areas.parent_id
			FROM #client_abb#_areas AS areas
			WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<cfif getArea.recordCount GT 0>
			
			<cfif getArea.user_in_charge IS user_id>
				<cfreturn true>
			</cfif>

			<cfif isNumeric(getArea.parent_id)>	
				<cfinvoke component="AreaManager" method="isUserAreaResponsible" returnvariable="access_result">
					<cfinvokeargument name="area_id" value="#getArea.parent_id#">
				</cfinvoke>
			</cfif>
		
		</cfif>

		<cfreturn access_result>
				
	</cffunction>


	<!--- -------------------------- CHECK AREA RESPONSIBLE ACCESS -------------------------------- --->
	<!---Comprueba si el usuario es responsable del área y si no lanza un error--->
	<!---El administrador general tiene permiso de responsable en todas las áreas--->

	<cffunction name="checkAreaResponsibleAccess" returntype="void" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		
		<cfset var method = "checkAreaResponsibleAccess">
									
		<cfif SESSION.client_administrator NEQ SESSION.user_id><!---Is not an administrator user--->

			<cfinvoke component="AreaManager" method="isUserAreaResponsible" returnvariable="access_result">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>
	
			<cfif access_result IS NOT true>
				<cfset error_code = 105>
				
				<cfthrow errorcode="#error_code#">		
			</cfif>		
		
		</cfif>
			
	</cffunction>


	<!--- -------------------------- CHECK AREA ADMIN ACCESS -------------------------------- --->
	<!---Comprueba si el usuario es administrador del área al que quiere acceder y si no lanza un error--->
	
	<!---
		
	Esto está pendiente de terminar

	<cffunction name="isUserAreaAdministrator" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="user_id" type="numeric" required="true">
		
		<cfset var method = "isUserAreaAdministrator">

		<cfset var response = structNew()>
		
		<cfset var allUserAreasList = "">
		<cfset var access_result = false>
					
		<cfif SESSION.client_administrator NEQ arguments.user_id><!---Is not an administrator user--->

			<cfinvoke component="AreaManager" method="getAllUserAreasAdminList" returnvariable="allUserAreasAdminList">
				ESTE MÉTODO HAY QUE CAMBIARLO PARA PODER PASARLE EL USUARIO DEL QUE HAY QUE COMPROBAR SI ES ADMINISTRADOR
			</cfinvoke>
			
			<cfinvoke component="AreaManager" method="canTheUserAccess" returnvariable="access_result">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="allUserAreasList" value="#allUserAreasAdminList#">
			</cfinvoke>
	
			<cfif access_result IS NOT true>

				<cfset response = {result=false}>

			</cfif>		
		
		<cfelse>

			<cfset response = {result=true}>

		</cfif>

		<cfreturn response>
			
	</cffunction>--->
	
	
	<!--- -------------------------- CHECK AREAS ACCESS -------------------------------- --->
	<!---Comprueba si el usuario puede acceder a algún área de la lista--->
	
	<cffunction name="checkAreasAccess" returntype="void" access="public">
		<cfargument name="areasList" type="string" required="yes">
		
		<cfset var method = "checkAreasAccess">
		
		<cfset var current_area = "">
		<cfset var access_result = false>
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cfinclude template="includes/functionStart.cfm">

		<cfloop list="#arguments.areasList#" index="current_area">

			<cfinvoke component="AreaManager" method="canUserAccessToArea" returnvariable="current_access_result">
				<cfinvokeargument name="area_id" value="#current_area#">
			</cfinvoke>
			
			<cfif current_access_result IS true>
				<cfset access_result = true>
				<cfbreak>
			</cfif>
		
		</cfloop>

		<cfif access_result IS NOT true>
			<cfset error_code = 104>
			
			<cfthrow errorcode="#error_code#">		
		</cfif>		
	
	</cffunction>		
	
	
	
	<!--- ---------------------------- getRootAreaId ---------------------------------- --->
	
	<cffunction name="getRootAreaId" returntype="numeric" access="public">
		
		<cfset var method = "getRootAreaId">
		
		<cfset var root_area_id = "">
					
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getRootArea" returnvariable="rootAreaQuery">
				<cfinvokeargument name="onlyId" value="true">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfset root_area_id = rootAreaQuery.id>
		
		<cfreturn root_area_id>
		
	</cffunction>
    
	
    <!--- ---------------------------- getRootArea ---------------------------------- --->
	
	<cffunction name="getRootArea" returntype="query" access="public">
		
		<cfset var method = "getRootArea">
		
		<cfset var root_area = structNew()>
					
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getRootArea" returnvariable="rootAreaQuery">
				<cfinvokeargument name="onlyId" value="false">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			         
		<cfreturn rootAreaQuery>
		
	</cffunction>
	
	
	
	<!--- ---------------------------- canUserSeeTheWholeTree ---------------------------------- --->
	
	<cffunction name="canUserSeeTheWholeTree" returntype="boolean" access="public">
		
		<cfset var method = "canUserSeeTheWholeTree">
		
		<cfset var user_id = "">

		<cfset var whole_tree_visible = false>
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="UserManager" method="isInternalUser" returnvariable="internal_user">
				<cfinvokeargument name="get_user_id" value="#user_id#"> 
			</cfinvoke>
			
			<cfset whole_tree_visible = internal_user>

		<cfreturn whole_tree_visible>
		
	</cffunction>
	
	
	<!--- ---------------------------- getUserAreasArray ---------------------------------- --->
	<!---Obtiene las áreas donde el usuario está en la lista de usuarios--->
	<!---A esta función siempre la llama otra funcion de ColdFusion, por lo que no tiene que tener try catch, ya que la otra fucion que llame a esta lo tendrá.--->
	
	<!---Obtiene las áreas del usuario pasado como parámetro--->
	
	<cffunction name="getUserAreasArray" returntype="array" access="public">
		<cfargument name="get_user_id" type="numeric" required="true">
		
		<cfset var method = "getUserAreasArray">
		
		<cfset var areasArray = ArrayNew(1)>
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfquery name="getUserAreas" datasource="#client_dsn#">
				SELECT area_id
				FROM #client_abb#_areas_users
				WHERE user_id = <cfqueryparam value="#arguments.get_user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>			
			
			<cfif getUserAreas.RecordCount GT 0>
				
				<cfloop query="getUserAreas">
					<cfscript>
						ArrayAppend(areasArray,#getUserAreas.area_id#);
					</cfscript>
				</cfloop>
				
				
			<cfelse><!---The user has no areas--->
			
				<cfset xmlResponseContent = "">
				
				<cfset error_code = 403>
				
				<cfthrow errorcode="#error_code#">
			
			</cfif>									
			
		
		<cfreturn areasArray>
		
	</cffunction>
	
	
	<!--- ---------------------------- loopUserAreas ---------------------------------- --->
	
	<cffunction name="loopUserAreas" returntype="string" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="areasArray" type="array" required="yes">
		<cfargument name="allAreasList" type="string" required="yes">
		<cfargument name="allowed" type="boolean" required="no" default="false">
		
		<cfset var method = "loopUserAreas">
		
		<cfset var userBelongsToArea = false>
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfif arguments.allowed EQ true>
				<cfset userBelongsToArea = true>
			<cfelse>
				<cfset list = ArrayToList(#arguments.areasArray#,",")>
				<cfset temp = ListFind(list, #arguments.area_id#)>
				 
				<cfif temp GT 0>
					<cfset userBelongsToArea = true>
				<cfelse>
					<cfset userBelongsToArea = false>
				</cfif>	

			</cfif>
			
			<cfif userBelongsToArea EQ true>

				<cfset allAreasList = ListAppend(allAreasList,#arguments.area_id#)>
				
			</cfif>
			
			<!--- Sub areas --->
			<cfquery name="subAreasQuery" datasource="#client_dsn#">
				SELECT id 
				FROM #client_abb#_areas
				WHERE parent_id = #arguments.area_id#
			</cfquery>
			
			<cfset hasSubAreas = (#subAreasQuery.recordCount# GT 0)>
			
			<!--- Appending subareas content in the case where there are sub areas --->
			<cfif hasSubAreas EQ true>			
				<cfloop query="subAreasQuery">				
					<cfinvoke component="AreaManager" method="loopUserAreas" returnvariable="allAreasListUpdated">
						<cfinvokeargument name="area_id" value="#subAreasQuery.id#">
						<cfinvokeargument name="areasArray" value="#arguments.areasArray#">
						<cfinvokeargument name="allAreasList" value="#allAreasList#">
						<cfinvokeargument name="allowed" value="#userBelongsToArea#">
					</cfinvoke>
					
					<cfset allAreasList = allAreasListUpdated>
										
				</cfloop>			
			</cfif>
		
		<cfreturn allAreasList>
		
	</cffunction>
	
	
	<!--- ---------------------------- getAllUserAreasList ---------------------------------- --->
	<!---Obtiene la lista de todas las areas donde el usuario tiene acceso--->
	<!---Obtiene las áreas del usuario pasado como parámetro--->
	
	<cffunction name="getAllUserAreasList" returntype="string" access="public">
		<cfargument name="get_user_id" type="numeric" required="yes">
		
		<cfset var method = "getAllUserAreasList">
		
		<cfset var user_id = "">

		<cfset var allAreasList = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinvoke component="AreaManager" method="getRootAreaId" returnvariable="root_area_id">
			</cfinvoke>			
			
			<cfinvoke component="UserManager" method="isRootUser" returnvariable="root_user">
				<cfinvokeargument name="get_user_id" value="#user_id#"> 
			</cfinvoke>
			
			<cfif root_user IS true><!---Is root user--->
				
				<cfquery name="getAllAreasQuery" datasource="#client_dsn#">
					SELECT id
					FROM #client_abb#_areas
				</cfquery>			
				
				<cfif getAllAreasQuery.RecordCount GT 0>
					
					<cfloop query="getAllAreasQuery">
						<cfset allAreasList = listAppend(allAreasList,getAllAreasQuery.id)>
					</cfloop>
					
				</cfif>
			
			<cfelse><!---Is not root user--->
			
				<cfinvoke component="AreaManager" method="getUserAreasArray" returnvariable="areasArray">
					<cfinvokeargument name="get_user_id" value="#arguments.get_user_id#">
				</cfinvoke>			
			
				<cfinvoke component="AreaManager" method="loopUserAreas" returnvariable="allAreasListUpdated">
					<cfinvokeargument name="area_id" value="#root_area_id#">
					<cfinvokeargument name="areasArray" value="#areasArray#">
					<cfinvokeargument name="allAreasList" value="#allAreasList#">
				</cfinvoke>
			
				<cfset allAreasList = allAreasListUpdated>
			
			</cfif>
		
		<cfreturn allAreasList>
		
	</cffunction>
	
	
	
	
	<!--- ---------------------------- getAllUserAreasListRemote ---------------------------------- --->
	<!---Obtiene la lista de todas las areas donde el usuario tiene acceso--->
	
	<!---
	NO USADO EN VERSION HTML
	<cffunction name="getAllUserAreasListRemote" returntype="string" access="public">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "getAllUserAreasListRemote">
		
		<cfset var areas_list = "">
		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">
			
		<cfset var xmlRequest = "">
		<cfset var xmlResponseContent = "">
		
		
		<cftry>
				
			<cfinclude template="includes/functionStart.cfm">
			
			<!---<cfset get_user_id = xmlRequest.request.parameters.user[0].xmlAttributes.id>--->
			
			<cfinvoke component="AreaManager" method="getAllUserAreasList" returnvariable="areas_list_result">
				<cfinvokeargument name="get_user_id" value="#user_id#">
			</cfinvoke>
				
			<cfset areas_list = areas_list_result>
			
			<cfset xmlResponseContent = "<areas_list><![CDATA["&areas_list&"]]></areas_list>">
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfreturn xmlResponse>
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
				<cfreturn xmlResponse>
			</cfcatch>
		</cftry>		
			

		<cfreturn allAreasList>
		
	</cffunction>--->
	
	
	
	<!--- ---------------------------- getUserAreasAdminArray ---------------------------------- --->
	<!---Obtiene las áreas donde el usuario es administrador--->
	
	<cffunction name="getUserAreasAdminArray" returntype="array" access="public">
		
		<cfset var method = "getUserAreasAdminArray">

		<cfset var user_id = "">
		
		<cfset var areasAdminArray = ArrayNew(1)>
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfquery name="getUserAreasAdmin" datasource="#client_dsn#">
				SELECT area_id
				FROM #client_abb#_areas_administrators
				WHERE user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>			
			
			<cfif getUserAreasAdmin.RecordCount GT 0>
				
				<cfloop query="getUserAreasAdmin">
					<cfscript>
						ArrayAppend(areasAdminArray,#getUserAreasAdmin.area_id#);
					</cfscript>
				</cfloop>
				
				
			<cfelse><!---The user has no areas to admin--->
			
				<cfset xmlResponseContent = "">
				
				<cfset error_code = 404>
				
				<cfthrow errorcode="#error_code#">
			
			</cfif>									
			
		
		<cfreturn areasAdminArray>
		
	</cffunction>
	
	
	<!--- ---------------------------- getAllUserAreasAdminList ---------------------------------- --->
	<!---Obtiene la lista de todas las areas donde el usuario es ADMINISTRADOR--->
	
	<cffunction name="getAllUserAreasAdminList" returntype="string" access="public">
		
		<cfset var method = "getAllUserAreasAdminList">
		
		<cfset var root_area_id = "">
		<cfset var allAreasAdminList = "">
		<cfset var areasAdminArray = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinvoke component="AreaManager" method="getRootAreaId" returnvariable="root_area_id">
			</cfinvoke>			
			
			<cfinvoke component="AreaManager" method="getUserAreasAdminArray" returnvariable="areasAdminArray">
			</cfinvoke>			
			
			<cfinvoke component="AreaManager" method="loopUserAreas" returnvariable="allAreasListUpdated">
				<cfinvokeargument name="area_id" value="#root_area_id#">
				<cfinvokeargument name="areasArray" value="#areasAdminArray#">
				<cfinvokeargument name="allAreasList" value="#allAreasAdminList#">
			</cfinvoke>
			
			<cfset allAreasList = allAreasListUpdated>
			
		
		<cfreturn allAreasList>
		
	</cffunction>	
	
	<!--- ------------------------------------- getMainTree -------------------------------------  --->
	
	<cffunction name="getMainTree" output="false" access="public" returntype="struct">
		
		<cfset var method = "getMainTree">

		<cfset var response = structNew()>
		
		<cfset var with_sub_areas = true>
		<cfset var root_area_id = "">
		<cfset var areasArray = ArrayNew(1)>
		<cfset var whole_tree = false>
		
		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">
			
		<cfset var visibleRootAreas = "">
		<cfset var areasContent = "">
		<cfset var areasXml = "">
		
		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
	
			<cfinvoke component="AreaManager" method="getRootAreaId" returnvariable="root_area_id">
			</cfinvoke>			
			
			<!---Se obtiene la lista de las áreas raices visibles (la raiz real no se muestra en el árbol de la aplicación)--->			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getVisibleRootAreas" returnvariable="rootAreasQuery">
				<cfinvokeargument name="root_area_id" value="#root_area_id#">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfset visibleRootAreas = valueList(rootAreasQuery.id, ",")>
			
			<cfinvoke component="AreaManager" method="canUserSeeTheWholeTree" returnvariable="whole_tree">
			</cfinvoke>
			
			<!---Se obtiene si el usuario está en el área raiz--->
			<cfquery datasource="#client_dsn#" name="isUserInRootArea">
				SELECT user_id
				FROM #client_abb#_areas_users AS areas_users
				WHERE area_id = <cfqueryparam value="#root_area_id#" cfsqltype="cf_sql_integer"> 
				AND user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif isUserInRootArea.recordCount GT 0>
				<cfset userInRootArea = true>
			<cfelse>
				<cfset userInRootArea = false>						
			</cfif>	
			
			
			<!---Este loop se hace sobre la lista porque daba problemas hacerlo sobre la consulta (¿por los otros loops que ya existen sobre consultas?)--->
			<cfloop list="#visibleRootAreas#" index="root_area_id">
				
				<cfinvoke component="AreaManager" method="getAreaContent" returnvariable="areasResult">
					<cfinvokeargument name="area_id" value="#root_area_id#">
					<!---<cfinvokeargument name="withSubAreas" value="#with_sub_areas#">--->
					<cfinvokeargument name="allowed" value="#userInRootArea#">	
					<cfinvokeargument name="whole_tree" value="#whole_tree#">
					<cfinvokeargument name="list_type" value="default">		
				</cfinvoke> 		
				
				<cfset areasContent = areasContent&areasResult>
				
			</cfloop>
			
			<!--- <cfset xmlResponseContent = "<areas>#areasContent#</areas>">	
			<cfinclude template="includes/functionEndNoLog.cfm">
			<cfreturn xmlResponse> --->

			<cfset areasXml =  "<areas>#areasContent#</areas>">

			<cfset response = {result=true, message="", areasXml=#areasXml#}>
		

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>
	
	<!---  --->
	
	<!--- ------------------------------------- getMainTreeAdmin -------------------------------------  --->
	
	<cffunction name="getMainTreeAdmin" access="public" returntype="struct">
		
		<cfset var method = "getMainTreeAdmin">

		<cfset var response = structNew()>
		
		<cfset var root_area_id = "">
		<cfset var whole_tree = false>
		
		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">

		<cfset var rootAreas = "">
		<cfset var areasContent = "">
		
		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="AreaManager" method="getRootAreaId" returnvariable="root_area_id">
			</cfinvoke>
			
			<cfif SESSION.client_administrator EQ user_id>
				<cfset whole_tree = true>
			<cfelse>
				<cfset whole_tree = false>

				<cfquery name="getUserAreasAdmin" datasource="#client_dsn#">
					SELECT area_id
					FROM #client_abb#_areas_administrators
					WHERE user_id = <cfqueryPARAM value = "#user_id#" CFSQLType = "CF_SQL_varchar">;
				</cfquery>

				<cfif getUserAreasAdmin.RecordCount IS 0><!---The user has no areas--->
				
					<!--- <cfset xmlResponseContent = arguments.request> --->
					
					<cfset error_code = 404>
					
					<cfthrow errorcode="#error_code#">
					
				</cfif> 
			</cfif>
							
			<cfinvoke component="AreaManager" method="getAreaContent" returnvariable="areasResult">
				<cfinvokeargument name="area_id" value="#root_area_id#">
				<cfinvokeargument name="allowed" value="false">	
				<cfinvokeargument name="whole_tree" value="#whole_tree#">
				<cfinvokeargument name="list_type" value="administrator">		
			</cfinvoke> 			
			
			<cfset areasXml =  "<areas>#areasResult#</areas>">

			<cfset response = {result=true, areasXml=#areasXml#}>

		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	
	<!--- --->	
	
		
	<!--- ------------------------------------- getAreaContent ------------------------------------- --->
	<!---A esta función siempre la llama otra funcion de ColdFusion, por lo que no tiene que tener try catch, ya que la otra fucion que llame a esta lo tendrá.--->
	
	<cffunction name="getAreaContent" output="true" returntype="string" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="allowed" type="Boolean" required="true">
		<cfargument name="whole_tree" type="Boolean" required="false">
		<cfargument name="areaType" type="string" required="false" default="">
		
		<cfargument name="parent_image_id" type="string" required="false" default="">
		<cfargument name="parent_link" type="string" required="false" default="">
		
		<cfargument name="withSubAreas" type="boolean" required="false" default="true">
		<cfargument name="withSubSubAreas" type="boolean" required="false" default="true">
		
		<cfargument name="list_type" type="string" required="false" default="default">
		
		<cfset var method = "getAreaContent">
		
		<cfset var image_id = "">

		<cfset var with_link = ""> 
		
		<cfset var xmlPart = "">
		<cfset var xmlAreaResult = "">
		
			<cfinclude template="includes/functionStart.cfm">
		
			<!---Este método no necesita chequeo de acceso al área porque si un usuario puede ver el árbol entero se tiene que acceder a este método para generarlo.--->	
			
			<cfif NOT isDefined("arguments.whole_tree")>
			
				<cfinvoke component="AreaManager" method="canUserSeeTheWholeTree" returnvariable="whole_tree_visible">
				</cfinvoke>
				
				<cfset arguments.whole_tree = whole_tree_visible>
			
			</cfif>
			
			<cfquery name="areaAttsQuery" datasource="#client_dsn#">
				SELECT id, name, parent_id, creation_date, user_in_charge, image_id, link, type 
				FROM #client_abb#_areas AS areas 
				WHERE areas.id = #arguments.area_id#
				ORDER BY areas.name ASC;
			</cfquery>
			
			<cfif areaAttsQuery.RecordCount LT 1>
			
				<cfset error_code = 401>
				
				<cfthrow errorcode="#error_code#">
						
			</cfif>
			
			<cfinvoke component="AreaManager" method="getAreaQueryContent" returnvariable="xmlAreaResult">
				<cfinvokeargument name="areaQuery" value="#areaAttsQuery#">
				<cfinvokeargument name="areaRow" value="1">
 				
				<cfinvokeargument name="allowed" value="#arguments.allowed#">	
				<cfinvokeargument name="whole_tree" value="#arguments.whole_tree#">
				<cfinvokeargument name="areaType" value="#arguments.areaType#">
				
				<cfinvokeargument name="parent_image_id" value="#arguments.parent_image_id#">
				<cfinvokeargument name="parent_link" value="#arguments.parent_link#">
				
				<cfinvokeargument name="withSubAreas" value="#arguments.withSubAreas#">	
				<cfinvokeargument name="withSubSubAreas" value="#arguments.withSubSubAreas#">	
				
				<cfinvokeargument name="list_type" value="#arguments.list_type#">	
			</cfinvoke>				
			
			<cfreturn #xmlAreaResult#>			
			
	</cffunction>
	
	
	<!--- ------------------------------------- getAreaQueryContent ------------------------------------- --->
	<!---A esta función siempre la llama otra funcion de ColdFusion, por lo que no tiene que tener try catch, ya que la otra fucion que llame a esta lo tendrá.--->
	
	<cffunction name="getAreaQueryContent" output="true" returntype="string" access="public">
		<cfargument name="areaQuery" type="query" required="yes">
		<cfargument name="areaRow" type="numeric" required="yes">

		<!---<cfargument name="areasArray" type="Array" required="false">--->
		<cfargument name="allowed" type="Boolean" required="true">
		<cfargument name="whole_tree" type="Boolean" required="true">
		<cfargument name="areaType" type="string" required="false" default="">
		
		<cfargument name="parent_image_id" type="string" required="true">
		<cfargument name="parent_link" type="string" required="true">
		
		<cfargument name="withSubAreas" type="boolean" required="true">
		<cfargument name="withSubSubAreas" type="boolean" required="false" default="true">
		
		<cfargument name="list_type" type="string" required="true">
		
		<cfset var method = "getAreaQueryContent">
		
		<cfset var area_id = "">
		<cfset var image_id = "">

		<cfset var with_link = ""> 
		
		<cfset var xmlPart = "">
		<cfset var xmlAreasResult = "">
		
		<cfset var aRow = arguments.areaRow>
		<cfset var userBelongsToArea = false>
		<cfset var curAreaType = "">
		
			<cfinclude template="includes/functionStart.cfm">
	
			<cfset area_id = areaQuery.id[aRow]>
			
			<cfif arguments.allowed EQ true>
				<cfset userBelongsToArea = true>
			<cfelse>
				
				<cfif list_type NEQ "administrator">
					<!---<cfset list = ArrayToList(#arguments.areasArray#,",")>
					<cfset temp = ListFind(list, #areaId#)> 
					<cfif temp GT 0>--->
					
					<cfquery datasource="#client_dsn#" name="isUserInArea">
						SELECT user_id
						FROM #client_abb#_areas_users AS areas_users
						WHERE area_id=<cfqueryparam value="#area_id#" cfsqltype="cf_sql_integer"> AND user_id=<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<cfif isUserInArea.recordCount GT 0>
						<cfset userBelongsToArea = true>
					<cfelse>
						<cfset userBelongsToArea = false>						
					</cfif>	
					
				<cfelse><!---LIST ADMINISTRATOR AREAS (to method getMainTreeAdministrator)--->
					
					<cfif whole_tree EQ true><!---Si es administrador general whole_tree IS true--->
						
						<cfset userBelongsToArea = true>
						
					<cfelse>
						<!---<cfset list = ArrayToList(#arguments.areasArray#,",")>
						<cfset temp = ListFind(list, #area_id#)> 
						<cfif temp GT 0>--->
						
						<cfquery datasource="#client_dsn#" name="isUserAdministratorOfArea">
							SELECT areas_administrators.user_id
							FROM #client_abb#_areas_administrators AS areas_administrators
							WHERE areas_administrators.area_id = <cfqueryparam value="#area_id#" cfsqltype="cf_sql_integer"> AND user_id=<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
						</cfquery>
						
						<cfif isUserAdministratorOfArea.recordCount GT 0>
							<cfset userBelongsToArea = true>
						<cfelse>
							<cfset userBelongsToArea = false>
						</cfif>
					</cfif>
				
				</cfif>

			</cfif>
			
			<!---area_image--->
			<cfif len(areaQuery.image_id[aRow]) IS NOT 0 AND areaQuery.image_id[aRow] NEQ "NULL">
				
				<cfset image_id = areaQuery.image_id[aRow]>
				<!---<cfset image_background_color = areaQuery.image_background_color>--->
				<cfif len(areaQuery.link[aRow]) GT 0 AND areaQuery.link[aRow] NEQ "NULL">
					<cfset with_link = "true">
				</cfif>
			<cfelse>
			
				<cfset image_id = arguments.parent_image_id>
				<!---<cfset image_background_color = arguments.parent_image_background_color>--->
				<cfif len(arguments.parent_link) GT 0 AND arguments.parent_link EQ "true"><!---Si hereda la imagen tambien hereda la url--->
					<cfset with_link = "true">
				<cfelse>
					<cfset with_link = "false">
				</cfif>
			
			</cfif>
			
			<!---areaType--->
			<cfif len(arguments.areaType) GT 0>
				<cfset curAreaType = arguments.areaType>
			<cfelse>
				<cfset curAreaType = areaQuery.type[aRow]>
			</cfif> 
			
			<cfset xmlPart = ''>
						
			
			<cfif whole_tree EQ true OR userBelongsToArea EQ true>
								
					<cfset xmlPart='<area id="#area_id#" name="#xmlFormat(areaQuery.name[aRow])#" parent_id="#areaQuery.parent_id[aRow]#" allowed="#userBelongsToArea#" image_id="#image_id#" with_link="#with_link#" type="#curAreaType#">'><!--- label="#xmlFormat(areaQuery.name[aRow])#" user_in_charge="#areaQuery.user_in_charge[aRow]#" creation_date="#areaQuery.creation_date[aRow]#"--->					
				
			</cfif>
					
			<cfif arguments.withSubAreas EQ true><!---withSubAreas--->		
			
				<cfinvoke component="AreaManager" method="getSubAreasContent" returnvariable="xmlAreasResult">
					<cfinvokeargument name="parent_id" value="#area_id#">
					<!---<cfif isDefined("arguments.areasArray")>
					<cfinvokeargument name="areasArray" value="#arguments.areasArray#">
					</cfif>--->
					<cfinvokeargument name="allowed" value="#userBelongsToArea#">	
					<cfinvokeargument name="whole_tree" value="#whole_tree#">
					<cfinvokeargument name="areaType" value="#curAreaType#">
					
					<cfinvokeargument name="parent_image_id" value="#image_id#">
					<!---<cfinvokeargument name="parent_image_background_color" value="#image_background_color#">--->
					<cfinvokeargument name="parent_link" value="#with_link#">
					
					<cfinvokeargument name="withSubSubAreas" value="#arguments.withSubSubAreas#">	
					
					<cfinvokeargument name="list_type" value="#arguments.list_type#">	
				</cfinvoke>
				
				<cfset xmlPart = xmlPart&xmlAreasResult>		
												
			</cfif>
			
			<cfif whole_tree EQ true OR userBelongsToArea EQ true>
				<cfset xmlPart=xmlPart&'</area>'>				
			</cfif>					
			
			<cfreturn #xmlPart#>			
			
	</cffunction>
	
	
	<!--- ------------------------------------- getSubAreasContent ------------------------------------- --->
	<!---A esta función siempre la llama otra funcion de ColdFusion, por lo que no tiene que tener try catch, ya que la otra fucion que llame a esta lo tendrá.--->
	
	<cffunction name="getSubAreasContent" output="true" returntype="string" access="public">
		<cfargument name="parent_id" type="numeric" required="true">
		<!---<cfargument name="areasArray" type="Array" required="false">--->
		<cfargument name="allowed" type="Boolean" required="true">
		<cfargument name="whole_tree" type="Boolean" required="true">
		<cfargument name="areaType" type="string" required="true">
		
		<cfargument name="parent_image_id" type="string" required="false" default="">
		<cfargument name="parent_link" type="string" required="false" default="">
		
		<cfargument name="withSubSubAreas" type="boolean" required="true">
		
		<cfargument name="list_type" type="string" required="true">
		
		<cfset var method = "getSubAreasContent">
		
		<cfset var image_id = "">

		<cfset var with_link = ""> 
		
		<cfset var subAreasQuery = "">
		<cfset var xmlPart = "">
		<cfset var xmlAreaResult = "">
		
			<cfinclude template="includes/functionStart.cfm">
			
			<!--- Sub areas --->
			<!---<cfquery name="subAreasQuery" datasource="#client_dsn#">
				SELECT id, name, parent_id, creation_date, user_in_charge, image_id, link
				FROM #client_abb#_areas AS areas
				WHERE areas.parent_id = <cfqueryparam value="#arguments.parent_id#" cfsqltype="cf_sql_integer">
				ORDER BY areas.name ASC;
			</cfquery>--->
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreas" returnvariable="subAreasQuery">
				<cfinvokeargument name="area_id" value="#arguments.parent_id#">				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfif subAreasQuery.recordCount GT 0>
			
				<cfloop index="currentRow" from="1" to="#subAreasQuery.recordCount#">			
				
					<cfinvoke component="AreaManager" method="getAreaQueryContent" returnvariable="xmlAreaResult">
						<cfinvokeargument name="areaQuery" value="#subAreasQuery#">
						<cfinvokeargument name="areaRow" value="#currentRow#">
						
						<!---<cfif isDefined("arguments.areasArray")>
						<cfinvokeargument name="areasArray" value="#arguments.areasArray#">
						</cfif>--->
						<cfinvokeargument name="allowed" value="#arguments.allowed#">	
						<cfinvokeargument name="whole_tree" value="#arguments.whole_tree#">
						<cfinvokeargument name="areaType" value="#arguments.areaType#">
						
						<cfinvokeargument name="parent_image_id" value="#arguments.parent_image_id#">
						<cfinvokeargument name="parent_link" value="#arguments.parent_link#">
						
						<cfinvokeargument name="withSubAreas" value="#arguments.withSubSubAreas#">	
						
						<cfinvokeargument name="list_type" value="#arguments.list_type#">	
					</cfinvoke>				
				
					<cfset xmlPart = xmlPart&xmlAreaResult>	
					
				</cfloop>
			
			</cfif>
			
			<cfreturn #xmlPart#>			
			
	</cffunction>
	
	
	
	<!--- ------------------------------------- createArea ------------------------------------- --->
	
	<cffunction name="createArea" output="false" access="public" returntype="struct">		
		<cfargument name="parent_id" type="string" required="true"/>
		<cfargument name="user_in_charge" type="numeric" required="true"/>
		<cfargument name="name" type="string" required="true"/>
		<cfargument name="description" type="string" required="true"/>
		<cfargument name="hide_in_menu" type="boolean" required="false" default="false"/>
		<cfargument name="menu_type_id" type="numeric" required="false"/>
		
		<cfset var method = "createArea">

		<cfset var response = structNew()>
		
		<cfset var area_id = "">
		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">
			
		<cftry>
				
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<!---<cfinclude template="includes/checkAreaAdminAccess.cfm">--->
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="checkAreaAdminAccess">
				<cfinvokeargument name="area_id" value="#arguments.parent_id#">
			</cfinvoke>
		
			<cfquery name="beginQuery" datasource="#client_dsn#">
				BEGIN;
			</cfquery>
			
			<cfinvoke component="DateManager" method="getCurrentDateTime" returnvariable="current_date">
			</cfinvoke>
			
			<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringCurrentDate">
				<cfinvokeargument name="timestamp_date" value="#current_date#">
			</cfinvoke>
					
			<cfquery name="insertAreaQuery" datasource="#client_dsn#" result="insertAreaResult">					
				INSERT INTO #client_abb#_areas (name,parent_id,user_in_charge,creation_date,description, hide_in_menu
					<cfif isDefined("arguments.menu_type_id") AND arguments.menu_type_id NEQ "">
						, menu_type_id
					</cfif>		
				) 
				VALUES (
					<cfqueryPARAM value="#arguments.name#" CFSQLType="CF_SQL_varchar">,			
					<cfqueryPARAM value="#arguments.parent_id#" CFSQLType="cf_sql_integer">,					
					<cfqueryPARAM value="#arguments.user_in_charge#" CFSQLType="cf_sql_integer">,
					<cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">,
					<cfqueryPARAM value="#arguments.description#" CFSQLType="CF_SQL_varchar">,
					<cfqueryPARAM value="#arguments.hide_in_menu#" CFSQLType="CF_SQL_boolean">
						<cfif isDefined("arguments.menu_type_id") AND arguments.menu_type_id NEQ "">
							,<cfqueryPARAM value = "#arguments.menu_type_id#" cfsqltype = "CF_SQL_integer">									
						</cfif>	
					);			
			</cfquery>
			<cfquery name="getLastInsertId" datasource="#client_dsn#">
				SELECT LAST_INSERT_ID() AS last_insert_id FROM #client_abb#_areas;
			</cfquery>
			<cfset area_id = getLastInsertId.last_insert_id>
			
			<cfquery name="insertUserQuery" datasource="#client_dsn#">
				INSERT INTO #client_abb#_areas_users
				VALUES (#area_id#,
						<cfqueryPARAM value = "#arguments.user_in_charge#" CFSQLType="cf_sql_integer">				
					);
			</cfquery>
			
			<cfquery name="commitQuery" datasource="#client_dsn#">
				COMMIT;
			</cfquery>
						
            <!---Alerta a todos los usuarios que tienen acceso al área que se ha creado--->
			<cfinvoke component="AreaManager" method="objectArea" returnvariable="objectArea">
				<cfinvokeargument name="id" value="#area_id#"/>
				<cfinvokeargument name="parent_id" value="#arguments.parent_id#"/>
				<cfinvokeargument name="user_in_charge" value="#arguments.user_in_charge#"/>
				<cfinvokeargument name="name" value="#arguments.name#"/>
				<cfinvokeargument name="description" value="#arguments.description#"/>
				<cfinvokeargument name="creation_date" value="#stringCurrentDate#"/>
			</cfinvoke>

			<cfinvoke component="AlertManager" method="newArea">
				<cfinvokeargument name="objectArea" value="#objectArea#">
			</cfinvoke>	
            
			<!---Alerta al usuario que que es responsable de la misma--->
			<cfinvoke component="UserManager" method="getUser" returnvariable="objectUser">
				<cfinvokeargument name="get_user_id" value="#arguments.user_in_charge#"/>
				<cfinvokeargument name="return_type" value="object"/>
			</cfinvoke>
		
			<cfinvoke component="AlertManager" method="assignUserToArea">
				<cfinvokeargument name="objectUser" value="#objectUser#">
				<cfinvokeargument name="area_id" value="#area_id#">
				<cfinvokeargument name="new_area" value="true">
			</cfinvoke>
			
			
			<!---<cfinvoke component="AreaManager" method="xmlArea" returnvariable="areaXml">
				<cfinvokeargument name="objectArea" value="#area#">
			</cfinvoke>--->
			
			<cfinclude template="includes/logRecord.cfm">
			
			<cfset response = {result=true, message="", area_id=#area_id#}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>
	
	<!---  --->


	<!--- -------------------------------- updateArea ----------------------------------  --->
	
	<cffunction name="updateArea" returntype="struct" output="false" access="public">
		<cfargument name="area_id" type="string" required="true"/>
		<cfargument name="name" type="string" required="false"/>
		<cfargument name="parent_id" type="numeric" required="false"/>
		<cfargument name="with_link" type="string" required="false"/>
		<cfargument name="link" type="string" required="false"/>
		<cfargument name="with_image" type="boolean" required="false"/>
		<cfargument name="user_in_charge" type="numeric" required="false"/>
		<cfargument name="description" type="string" required="false"/>
		<cfargument name="image_file" type="string" required="false"/>
		<cfargument name="hide_in_menu" type="boolean" required="false" default="false"/>
		<cfargument name="menu_type_id" type="numeric" required="false"/>

		<cfset var method = "updateArea">
		
		<cfset var response = structNew()>

		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">		
			
			<cfinclude template="includes/checkAreaAdminAccess.cfm">
				
			<cfquery name="beginQuery" datasource="#client_dsn#">
				BEGIN;
			</cfquery>
			
				<cftry>
				
					<cfif isDefined("arguments.name") AND arguments.name NEQ "">
						<cfquery name="nameQuery" datasource="#client_dsn#">
							UPDATE #client_abb#_areas SET name = <cfqueryPARAM value = "#arguments.name#" CFSQLType = "CF_SQL_varchar">
							WHERE id = <cfqueryPARAM value = "#arguments.area_id#" CFSQLType = "CF_SQL_integer">;
						</cfquery>
					</cfif>
					<cfif isDefined("arguments.parent_id") AND arguments.parent_id NEQ "">
						<cfquery name="parentIdQuery" datasource="#client_dsn#">
							UPDATE #client_abb#_areas SET parent_id = <cfqueryPARAM value = "#arguments.parent_id#" CFSQLType = "CF_SQL_integer">
							WHERE id = <cfqueryPARAM value = "#arguments.area_id#" CFSQLType = "CF_SQL_integer">;
						</cfquery>
					</cfif>
					<cfif isDefined("arguments.with_link") AND arguments.with_link NEQ "">
						<cfif arguments.with_link EQ "false">
							<cfquery name="withLinkQuery" datasource="#client_dsn#">
								UPDATE #client_abb#_areas SET link = <cfqueryPARAM null="yes" cfsqltype="cf_sql_varchar">
								WHERE id = <cfqueryPARAM value="#arguments.area_id#" CFSQLType="CF_SQL_integer">;
							</cfquery>
						<cfelse>
							<cfquery name="withLinkQuery" datasource="#client_dsn#">
								UPDATE #client_abb#_areas SET link = <cfqueryPARAM value="" cfsqltype="cf_sql_varchar">
								WHERE id = <cfqueryPARAM value="#arguments.area_id#" CFSQLType="CF_SQL_integer">;
							</cfquery>
						</cfif>
					</cfif>
					<cfif isDefined("arguments.link") AND arguments.link NEQ "">
						<cfquery name="parentIdQuery" datasource="#client_dsn#">
							UPDATE #client_abb#_areas SET link = <cfqueryPARAM value="#arguments.link#" cfsqltype="cf_sql_varchar">
							WHERE id = <cfqueryPARAM value="#arguments.area_id#" CFSQLType="CF_SQL_integer">;
						</cfquery>
					</cfif>
					
					<cfif isDefined("arguments.hide_in_menu") AND arguments.hide_in_menu NEQ "">
						<cfquery name="hideMenuQuery" datasource="#client_dsn#">
							UPDATE #client_abb#_areas SET hide_in_menu = <cfqueryPARAM value = "#arguments.hide_in_menu#" cfsqltype = "cf_sql_boolean">
							WHERE id = <cfqueryPARAM value = "#arguments.area_id#" CFSQLType = "CF_SQL_integer">;
						</cfquery>		
					</cfif>
					
					<cfif isDefined("arguments.menu_type_id") AND arguments.menu_type_id NEQ "">
						<cfquery name="menuTypeIdQuery" datasource="#client_dsn#">
							UPDATE #client_abb#_areas SET menu_type_id = <cfqueryPARAM value = "#arguments.menu_type_id#" cfsqltype = "CF_SQL_integer">
							WHERE id = <cfqueryPARAM value = "#arguments.area_id#" CFSQLType = "CF_SQL_integer">;
						</cfquery>		
					</cfif>					
					
					
					<cfif isDefined("arguments.with_image") AND arguments.with_image NEQ "">
						<cfif arguments.with_image EQ "false">
							<!--- check if exist the image --->
							<cfquery name="selectAreaQuery" datasource="#client_dsn#">
								SELECT * 
								FROM #client_abb#_areas AS areas
								WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
							</cfquery>
							
							<cfif selectAreaQuery.recordCount GT 0>
								<cfif len(selectAreaQuery.image_id) GT 0 AND selectAreaQuery.image_id NEQ "NULL">
									<!---Delete area image--->
									<cfinvoke component="AreaManager" method="deleteAreaImage" returnvariable="deleteAreaImageResponse">
										<cfinvokeargument name="area_id" value="#arguments.area_id#">
									</cfinvoke>
									<cfif deleteAreaImageResponse.result NEQ true>
					
										<cfset error_code = 605>
								
										<cfthrow errorcode="#error_code#">
										
									</cfif>
								</cfif>
							<cfelse><!---The area does not exist--->
				
								<cfset error_code = 401>
								
								<cfthrow errorcode="#error_code#">
							</cfif>
						</cfif> 
					</cfif>
					<!--- +++++++++++++++++++++++++++++++++++USER IN CHARGE+++++++++++++++++++++++++++++++++++++ --->
					<cfif isDefined("arguments.user_in_charge") AND arguments.user_in_charge NEQ "">
						<cfquery name="userInChargeQuery" datasource="#client_dsn#">
							UPDATE #client_abb#_areas SET user_in_charge = <cfqueryPARAM value = "#arguments.user_in_charge#" cfsqltype="cf_sql_integer">
							WHERE id = <cfqueryPARAM value = "#arguments.area_id#" CFSQLType = "CF_SQL_integer">;
						</cfquery>
						
						<cfquery name="checkIsMember" datasource="#client_dsn#">
							SELECT user_id 
							FROM #client_abb#_areas_users
							WHERE user_id = <cfqueryPARAM value = "#arguments.user_in_charge#" CFSQLType="cf_sql_integer">
								AND area_id = <cfqueryPARAM value = "#arguments.area_id#" CFSQLType = "CF_SQL_integer">;
						</cfquery>
						
						<cfif #checkIsMember.recordCount# LT 1> 
							<cfquery name="insertMember" datasource="#client_dsn#">
								INSERT 
								INTO #client_abb#_areas_users
								VALUES(<cfqueryPARAM value = "#arguments.area_id#" CFSQLType = "CF_SQL_integer">,
										<cfqueryPARAM value = "#arguments.user_in_charge#" CFSQLType="cf_sql_integer">);					
							</cfquery>
						</cfif>				
					</cfif>
					<cfif isDefined("arguments.description") AND arguments.description NEQ "">
						<cfquery name="descriptionQuery" datasource="#client_dsn#">
							UPDATE #client_abb#_areas SET description = <cfqueryPARAM value = "#arguments.description#" CFSQLType="cf_sql_longvarchar">
							WHERE id = <cfqueryPARAM value = "#arguments.area_id#" CFSQLType = "CF_SQL_integer">;
						</cfquery>
					</cfif>	

				
				<cfquery name="commitQuery" datasource="#client_dsn#">
					COMMIT;
				</cfquery>	
				
				<cfcatch>

					<cfquery name="rollBackQuery" datasource="#client_dsn#">
						ROLLBACK;
					</cfquery>

					<cfinclude template="includes/errorHandlerStruct.cfm">

					<cfset response = {result=false, message=#cfcatch.message#, area_id=#arguments.area_id#}>
					<cfreturn response>
				</cfcatch>										
				
			</cftry>



			<cfif isDefined("arguments.image_file") AND len(arguments.image_file) GT 0>


				<cfquery name="getAreaFile" datasource="#client_dsn#">
					SELECT image_id
					FROM #client_abb#_areas
					WHERE id = <cfqueryparam value="#area_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
			
				<cfif getAreaFile.recordCount GT 0>
					
					<cfif NOT isValid("integer", getAreaFile.image_id)><!---El area no tiene imagen--->
						

						<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="createFile" returnvariable="createImageFileResponse">
							<cfinvokeargument name="name" value=" ">		
							<cfinvokeargument name="file_name" value=" ">
							<cfinvokeargument name="file_type" value=" ">
							<cfinvokeargument name="file_size" value="0">
							<cfinvokeargument name="description" value="">
						</cfinvoke>

						<cfif createImageFileResponse.result IS true>
			
							<cfset image_id = createImageFileResponse.objectFile.id>
							<cfset image_physical_name = createImageFileResponse.objectFile.physical_name>

						<cfelse>
				
							<cfset response_message = "Error al crear la imagen.">

							<cfset response = {result=false, message=#response_message#}>	
							<cfreturn response>
							
						</cfif>			

						
					<cfelse><!---El área ya tiene una imagen: se va a reemplazar--->
						
						<cfset image_id = getAreaFile.image_id>

						<cfinvoke component="FileManager" method="getFile" returnvariable="objectFile">				
							<cfinvokeargument name="get_file_id" value="#image_id#">
						
							<cfinvokeargument name="return_type" value="object">
						</cfinvoke>	

						<cfset image_physical_name = objectFile.physical_name>
						
						<cfquery name="updateStateUploadingFile" datasource="#client_dsn#">
							UPDATE #client_abb#_#files_table#
							SET status_replacement = 'pending'
							WHERE id=<cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">;
						</cfquery>
						
					</cfif>
					
					
				<cfelse><!---The area does not exist--->
			
					<cfset error_code = 301>
					
					<cfthrow errorcode="#error_code#">
				
				</cfif>		

					
				<cftry>
				
					<cfinvoke component="AreaItemFile" method="uploadItemFile">
						<cfinvokeargument name="file_type" value="area_image">
						<cfinvokeargument name="file_id" value="#image_id#">
						<cfinvokeargument name="file_physical_name" value="#image_physical_name#">
						<cfinvokeargument name="Filedata" value="#arguments.image_file#">
					</cfinvoke>
					
					<cfcatch>
					
						<cfset response = {result=false, message=#cfcatch.Message#}>	
						<cfreturn response>
					
					</cfcatch>
					
				</cftry>
					
					
				
			</cfif>

			
			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, message="", area_id=#arguments.area_id#}><!---areaXml=#areaXml#--->
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
		
	</cffunction>
	
	<!--- _____________________________________________________________________________  --->
	
	
	
	<!--- ------------------------------------- selectArea -------------------------------------  --->
	
	<cffunction name="selectArea" output="false" access="public" returntype="string">		
		<cfargument name="request" type="string" required="yes">

		<cfset var method = "selectArea">
		
		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">
			
		<cfset var xmlRequest = "">
		<cfset var xmlResponseContent = "">

		
		<cftry>
					
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset select_area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
			
			<cfinvoke component="AreaManager" method="getArea" returnvariable="xmlResponseContent">
				<cfinvokeargument name="get_area_id" value="#select_area_id#">
				<cfinvokeargument name="format_content" value="default">
			</cfinvoke>
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		
		</cftry>
		
		<cfreturn xmlResponse>
					
	</cffunction>
	
	<!---  --->
	
	
	<!--- ------------------------------------- selectAreaAdmin -------------------------------------  --->
	
	<cffunction name="selectAreaAdmin" output="false" access="public" returntype="string">		
		<cfargument name="request" type="string" required="yes">

		<cfset var method = "selectAreaAdmin">
		
		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">
			
		<cfset var xmlRequest = "">
		<cfset var xmlResponseContent = "">

		
		<cftry>
					
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset select_area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
			
			<cfinvoke component="AreaManager" method="getArea" returnvariable="xmlResponseContent">
				<cfinvokeargument name="get_area_id" value="#select_area_id#">
				<cfinvokeargument name="format_content" value="all">
			</cfinvoke>
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		
		</cftry>
		
		<cfreturn xmlResponse>
					
	</cffunction>
	
	<!---   --->
	
	
	<!--- ------------------------------------- getArea ------------------------------------ --->
	
	<cffunction name="getArea" returntype="any" access="public">		
		<cfargument name="get_area_id" type="numeric" required="yes">
		<cfargument name="format_content" type="string" required="no" default="default">
        <cfargument name="return_type" type="string" required="no" default="xml">

		<cfset var method = "getArea">
		
		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">
		
		<cfset var xmlResponseContent = "">
		<cfset var xmlResponse = "">
		
					
			<cfinclude template="includes/functionStart.cfm">
			
			<!---<cfinclude template="includes/checkAreaAccess.cfm">Un usuario aunque no tenga permisos de área puede acceder a ver su nombre y descripción--->
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getArea" returnvariable="selectAreaQuery">
				<cfinvokeargument name="area_id" value="#arguments.get_area_id#">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfif selectAreaQuery.recordCount GT 0>
			
				<cfinvoke component="AreaManager" method="objectArea" returnvariable="area">
					<cfinvokeargument name="id" value="#selectAreaQuery.id#">
					<cfinvokeargument name="name" value="#selectAreaQuery.area_name#">
					<cfinvokeargument name="creation_date" value="#selectAreaQuery.creation_date#">
					<cfinvokeargument name="parent_id" value="#selectAreaQuery.parent_id#">
					<cfinvokeargument name="user_in_charge" value="#selectAreaQuery.user_in_charge#">
					<cfinvokeargument name="description" value="#selectAreaQuery.description#">
					<cfinvokeargument name="user_full_name" value="#selectAreaQuery.family_name# #selectAreaQuery.user_name#">
					<cfinvokeargument name="image_id" value="#selectAreaQuery.area_image_id#">
					<cfif arguments.format_content EQ "all">
						<cfinvokeargument name="link" value="#selectAreaQuery.area_link#">
					</cfif>
					<cfinvokeargument name="type" value="#selectAreaQuery.type#">
					<cfinvokeargument name="default_typology_id" value="#selectAreaQuery.default_typology_id#">
					<cfinvokeargument name="hide_in_menu" value="#selectAreaQuery.hide_in_menu#">
					<cfinvokeargument name="menu_type_id" value="#selectAreaQuery.menu_type_id#">

				</cfinvoke>
				
                <cfif arguments.return_type EQ "object">
                    
                    <cfset xmlResponse = area>
                    
                <cfelse>
                
                	<cfinvoke component="AreaManager" method="xmlArea" returnvariable="xmlResponseContent">
                        <cfinvokeargument name="objectArea" value="#area#">
                    </cfinvoke>
                    
                    <cfset xmlResponse = xmlResponseContent>
                
                </cfif>
				
				
				
			<cfelse><!---The area does not exist--->
				
				<cfset error_code = 401>
				
				<cfthrow errorcode="#error_code#">
			
			</cfif>
				
		
		<cfreturn xmlResponse>
					
	</cffunction>
	
	<!--- _____________________________________________________________________________  --->
	
	

	<!--- ________________________________DELETE AREA__________________________________  --->
	
	<cffunction name="deleteArea" output="false" access="public" returntype="struct">		
		<cfargument name="area_id" type="numeric" required="true">
		
		<cfset var method = "deleteArea">
		
		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
						
			<cfinclude template="includes/checkAreaAdminAccess.cfm">
			
			<!---getRootAreaId--->
			<cfinvoke component="AreaManager" method="getRootAreaId" returnvariable="root_area_id">
			</cfinvoke>
			
			<cfif arguments.area_id IS root_area_id><!---No se puede eliminar el área Raiz--->
				<cfset error_code = 103><!---Access denied--->
			
				<cfthrow errorcode="#error_code#">		
			</cfif>
			
			<cfinvoke component="AreaManager" method="getArea" returnvariable="area">
				<cfinvokeargument name="get_area_id" value="#arguments.area_id#">
				<cfinvokeargument name="format_content" value="all">
				<cfinvokeargument name="return_type" value="object">
			</cfinvoke>
			
			<cfif len(area.type) GT 0><!---No se pueden borrar las áreas raices especiales--->
				<cfset error_code = 103><!---Access denied--->
			
				<cfthrow errorcode="#error_code#">
			</cfif>
		
			<cfquery name="beginQuery" datasource="#client_dsn#">
				BEGIN;
			</cfquery>
			
			<!--- -----------------DELETE AREA MESSAGES------------------------- --->
			<cfinvoke component="AreaItemManager" method="deleteAreaItems">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="itemTypeId" value="1">
			</cfinvoke>
		
		
			<cfif APPLICATION.moduleWeb EQ true>
				
				<!--- -----------------DELETE AREA ENTRIES------------------------- --->
				<cfinvoke component="AreaItemManager" method="deleteAreaItems">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="itemTypeId" value="2">
				</cfinvoke>
				
				<cfif APPLICATION.identifier EQ "vpnet">
				
					<!--- -----------------DELETE AREA LINKS------------------------- --->
					<cfinvoke component="AreaItemManager" method="deleteAreaItems">
						<cfinvokeargument name="area_id" value="#arguments.area_id#">
						<cfinvokeargument name="itemTypeId" value="3">
					</cfinvoke>
				
				</cfif>
				
				<!--- -----------------DELETE AREA NEWS------------------------- --->
				<cfinvoke component="AreaItemManager" method="deleteAreaItems">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="itemTypeId" value="4">
				</cfinvoke>
				
			</cfif>
			
			
			<cfif APPLICATION.moduleWeb EQ true OR APPLICATION.identifier NEQ "vpnet">
			
				<!--- -----------------DELETE AREA EVENTS------------------------- --->
				<cfinvoke component="AreaItemManager" method="deleteAreaItems">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="itemTypeId" value="5">
				</cfinvoke>
				
			</cfif>
			
			<cfif APPLICATION.identifier NEQ "vpnet">
			
				<!--- -----------------DELETE AREA TASKS------------------------- --->
				<cfinvoke component="AreaItemManager" method="deleteAreaItems">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="itemTypeId" value="6">
				</cfinvoke>
			
			</cfif>
			
			<cfif APPLICATION.moduleConsultations IS true>
			
				<!--- -----------------DELETE AREA CONSULTATIONS------------------------- --->
				<cfinvoke component="AreaItemManager" method="deleteAreaItems">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="itemTypeId" value="7">
				</cfinvoke>
			
			</cfif>
			
			
			
			<!--- -------------------DELETE AREAS_FILES------------------------ --->
			<cfquery name="deleteAreasFiles" datasource="#client_dsn#">
				DELETE 
				FROM #client_abb#_areas_files
				WHERE area_id = #arguments.area_id#;
			</cfquery>
			
			<!--- --------------------DELETE AREAS USERS---------------------  --->
			<cfquery name="membersQuery" datasource="#client_dsn#">
				DELETE 
				FROM #client_abb#_areas_users
				WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<!--- --------------------DELETE AREA IMAGE---------------------  --->
			<cfif len(area.image_id) GT 0 AND isNumeric(area.image_id)>
			
				<!---Delete area image--->
				<cfinvoke component="AreaManager" method="deleteAreaImage" returnvariable="deleteAreaImageResponse">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>
				
				<cfif deleteAreaImageResponse.result NEQ true>
					
					<cfset error_code = 605>
			
					<cfthrow errorcode="#error_code#">
					
				</cfif>
				
			</cfif>
			
			<!--- -----------------DELETE SUB AREAS-------------------------- --->
			<cfquery name="subAreasQuery" datasource="#client_dsn#">
				SELECT id 
				FROM #client_abb#_areas
				WHERE parent_id = #arguments.area_id#;
			</cfquery>
			<cfif subAreasQuery.recordCount GT 0>
				<cfloop query="subAreasQuery">
					<cfinvoke component="AreaManager" method="deleteArea" returnvariable="deleteSubAreaResult">
						<cfinvokeargument name="area_id" value="#subAreasQuery.id#">
					</cfinvoke>
					<cfif deleteSubAreaResult.result IS false>
						<cfthrow message="#deleteSubAreaResult.message#">
					</cfif>
				</cfloop>
			</cfif>
			
			
			<cfquery name="deleteAreaQuery" datasource="#client_dsn#">
				DELETE 
				FROM #client_abb#_areas
				WHERE id = #arguments.area_id#;
			</cfquery>				
			
			<cfquery name="commitQuery" datasource="#client_dsn#">
				COMMIT;
			</cfquery>	
		
			<cfinclude template="includes/functionEndOnlyLog.cfm">

			<cfset response = {result=true, message="", area_id=#arguments.area_id#}>				
			
			<cfcatch>
				<!--- RollBack the transaction --->
				<cfquery name="rollBackTransaction" datasource="#client_dsn#">
					ROLLBACK;
				</cfquery>
				
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
					
	</cffunction>
	<!--- _____________________________________________________________________________  --->


	
	<!--- ----------------GET AREA MESSAGES LIST---------------------------------------   --->
	<!---Esta función hay que quitarla de este componente ya que se debe usar directamente la de MessageManager, se mantiene aquí para mantener compatibilidad con la versión de cliente de Flex--->
	<cffunction name="getAreaMessagesList" output="false" returntype="string" access="public">
		<cfargument name="request" type="string" required="yes">
		
			<cfinvoke component="MessageManager" method="getAreaMessagesList" returnvariable="xmlResponse">
				<cfinvokeargument name="request" value="#arguments.request#">
			</cfinvoke>
							
		<cfreturn xmlResponse>
			
	</cffunction>
	<!--- ------------------------------------------------------------------------------  --->
	
	
	<!--- ----------------GET AREA MESSAGES TREE---------------------------------------   --->
	<!---Esta función hay que quitarla de este componente ya que se debe usar directamente la de MessageManager, se mantiene aquí para mantener compatibilidad con la versión de cliente de Flex--->
	<cffunction name="getAreaMessagesTree" output="false" returntype="string" access="public">
		<cfargument name="request" type="string" required="yes">
				
			<cfinvoke component="MessageManager" method="getAreaMessagesTree" returnvariable="xmlResponse">
				<cfinvokeargument name="request" value="#arguments.request#">
			</cfinvoke>
		
		<cfreturn xmlResponse>
				
	</cffunction>
	<!--- ------------------------------------------------------------------------------  --->
	
	
	
	
	
	<!---    --------------------GET AREA MEMBERS-------------------------------------  --->
	<!---Obtiene los usuarios asociados a un área.
	Hay un método en el UserManager que hace practicamente lo mismo--->
	<cffunction name="getAreaMembers" output="false" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true"/>
		<cfargument name="order_by" type="string" required="false"/>
		<cfargument name="order_type" type="string" required="false"/>
		
		<cfset var method = "getAreaMembers">

		<cfset var response = structNew()>
				
		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">
						
			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">
			
			<!--- ORDER --->
			<cfinclude template="includes/usersOrderParameters.cfm">
			
			
			<cfinvoke component="AreaManager" method="getAreaUsers" returnvariable="usersXml">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="order_by" value="#order_by#">
				<cfinvokeargument name="order_type" value="#order_type#">
			</cfinvoke>	
				
		
			<cfset response = {result=true, message="", usersXml=#usersXml#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>			
			
	</cffunction>
	<!--- -----------------------------------------------------------------------  --->
	
	
	<!---    --------------------GET AREA MEMBERS ADMIN-------------------------------------  --->

	<cffunction name="getAreaMembersAdmin" output="false" returntype="string" access="public">
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "getAreaMembersAdmin">
		
		<cfset var area_id = "">
		
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset area_id = xmlRequest.request.parameters.area.xmlAttributes.id>	
			
			<cfinvoke component="AreaManager" method="getAreaUsers" returnvariable="xmlResponseContent">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>		
			
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>		
			
	</cffunction>
	<!--- -----------------------------------------------------------------------  --->
	
	
	<!---    --------------------GET AREA USERS-------------------------------------  --->
	<!---Hay un método en el UserManager que hace practicamente lo mismo, pero este es más simple, y por lo tanto más rápido, y es el que se debe usar en determinados casos--->
	<cffunction name="getAreaUsers" output="false" returntype="string" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="order_by" type="string" required="no" default="name">
		<cfargument name="order_type" type="string" required="no" default="asc">
				
		<cfset var method = "getAreaUsers">
		<cfset var user_in_charge = "">
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfquery name="membersQuery" datasource="#client_dsn#">
				SELECT users.id, users.email, users.name, users.telephone, users.family_name, users.mobile_phone, users.telephone_ccode, users.mobile_phone_ccode, users.image_type
				FROM #client_abb#_users AS users
				INNER JOIN #client_abb#_areas_users AS areas_users ON users.id = areas_users.user_id
				WHERE areas_users.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				ORDER BY #arguments.order_by# #arguments.order_type#;
			</cfquery>
						
			<cfset xmlResult = '<users>'>
			
			<cfif membersQuery.recordCount GT 0>
				
				<cfquery name="getAreaUserInCharge" datasource="#client_dsn#">
					SELECT user_in_charge
					FROM #client_abb#_areas AS areas
					WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				</cfquery>
				
				<cfif getAreaUserInCharge.recordCount IS 0><!---The area does not exist--->
				
					<cfset error_code = 401>
					
					<cfthrow errorcode="#error_code#">
	
				</cfif>
					
				<cfset user_in_charge = getAreaUserInCharge.user_in_charge>
				
				<cfquery name="getUserInCharge" dbtype="query">
					SELECT id, email, telephone, family_name, name, mobile_phone, telephone_ccode, mobile_phone_ccode, image_type
					FROM membersQuery
					WHERE id = #user_in_charge#;			
				</cfquery>
			
				<cfif getUserInCharge.recordCount GT 0>
				
					<cfloop query="getUserInCharge">
						<cfinvoke component="UserManager" method="objectUser" returnvariable="xmlUser">
							<cfinvokeargument name="id" value="#getUserInCharge.id#">
							<cfinvokeargument name="email" value="#getUserInCharge.email#">
							<cfinvokeargument name="telephone" value="#getUserInCharge.telephone#">
							<cfinvokeargument name="family_name" value="#getUserInCharge.family_name#">
							<cfinvokeargument name="name" value="#getUserInCharge.name#">
							<cfinvokeargument name="mobile_phone" value="#getUserInCharge.mobile_phone#">
							<cfinvokeargument name="telephone_ccode" value="#getUserInCharge.telephone_ccode#">
							<cfinvokeargument name="mobile_phone_ccode" value="#getUserInCharge.mobile_phone_ccode#">
							<cfinvokeargument name="image_type" value="#getUserInCharge.image_type#">
							<cfinvokeargument name="user_in_charge" value="true">
								
							<cfinvokeargument name="return_type" value="xml">
						</cfinvoke>
						<cfset xmlResult = xmlResult&xmlUser>				
					</cfloop>
				
				</cfif>
			
				<cfloop query="membersQuery">						
					<cfif membersQuery.id NEQ user_in_charge>
						<cfinvoke component="UserManager" method="objectUser" returnvariable="xmlUser">
							<cfinvokeargument name="id" value="#membersQuery.id#">
							<cfinvokeargument name="email" value="#membersQuery.email#">
							<cfinvokeargument name="telephone" value="#membersQuery.telephone#">
							<cfinvokeargument name="family_name" value="#membersQuery.family_name#">
							<cfinvokeargument name="name" value="#membersQuery.name#">
							<cfinvokeargument name="mobile_phone" value="#membersQuery.mobile_phone#">
							<cfinvokeargument name="telephone_ccode" value="#membersQuery.telephone_ccode#">
							<cfinvokeargument name="mobile_phone_ccode" value="#membersQuery.mobile_phone_ccode#">
							<cfinvokeargument name="image_type" value="#membersQuery.image_type#">

							<cfinvokeargument name="return_type" value="xml">
						</cfinvoke>
						<cfset xmlResult = xmlResult&xmlUser>
					</cfif>
				</cfloop>		

			</cfif>		
			
			<cfset xmlResponse = xmlResult&'</users>'>		
		
		
		<cfreturn xmlResponse>		
			
	</cffunction>
	<!--- -----------------------------------------------------------------------  --->
	
	
	<!---  --------------------GET AREA FILES-------------------------------------  --->
	<cffunction name="getAreaFiles" output="false" returntype="string" access="public">
		<cfargument name="request" type="string">
		
		<cfset var method = "getAreaFiles">
		
		<cfset var area_id = "">
		
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset area_id = xmlRequest.request.parameters.area.xmlAttributes.id>	
			
			<cfinclude template="includes/checkAreaAccess.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getAreaFiles" returnvariable="getAreaFilesResult">
				<cfinvokeargument name="area_id" value="#area_id#">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfset filesQuery = getAreaFilesResult.query>
			
			<cfset xmlObject='<files label="files">'>	
			<cfif filesQuery.recordCount GT 0>
				<cfloop query="filesQuery">
					<cfinvoke component="FileManager" method="objectFile" returnvariable="xmlFile">
						<cfinvokeargument name="id" value="#filesQuery.id#">
						<cfinvokeargument name="physical_name" value="#filesQuery.physical_name#">		
						<cfinvokeargument name="user_in_charge" value="#filesQuery.user_in_charge#">		
						<cfinvokeargument name="file_size" value="#filesQuery.file_size#">
						<cfinvokeargument name="file_type" value="#filesQuery.file_type#">
						<cfinvokeargument name="association_date" value="#filesQuery.association_date#">
						<cfinvokeargument name="replacement_date" value="#filesQuery.replacement_date#">
						<cfinvokeargument name="name" value="#filesQuery.name#">
						<cfinvokeargument name="file_name" value="#filesQuery.file_name#">
						<!---<cfinvokeargument name="description" value="#filesQuery.description#">--->
						<cfinvokeargument name="user_full_name" value="#filesQuery.family_name# #filesQuery.user_name#">
						
						<cfinvokeargument name="return_type" value="xml">
					</cfinvoke>
					
					<cfset xmlObject = xmlObject&xmlFile>
				</cfloop>				
			</cfif>
			<cfset xmlObject=xmlObject&'</files>'>			
			
			<cfset xmlResponseContent = xmlObject>			
									
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>
			
		</cftry>
		
		<cfreturn xmlResponse>
			
	</cffunction>
	<!--- -----------------------------------------------------------------------  --->
	

	<!---    --------------------GET AREA ADMINISTRATORS-------------------------------------  --->
	<cffunction name="getAreasAdministrators" output="false" returntype="string" access="public">
	
		<cfset var method = "getAreasAdministrators">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinclude template="includes/checkAdminAccess.cfm">
			
			
			<cfquery name="getAreasAdministrators" datasource="#client_dsn#">
				SELECT areas_administrators.user_id, areas_administrators.area_id, users.family_name, areas.name,  users.name AS user_name
				FROM #client_abb#_areas_administrators AS areas_administrators 
				INNER JOIN #client_abb#_areas AS areas ON areas_administrators.area_id = areas.id 
				INNER JOIN #client_abb#_users AS users ON areas_administrators.user_id = users.id;
			</cfquery>
			<!---WHERE areas_administrators.area_id = areas.id;--->
			
			<cfprocessingdirective suppresswhitespace="yes">
				<cfsavecontent variable="xmlResult">
				<areas_admins>
					<cfif getAreasAdministrators.recordCount GT 0>
						<cfoutput>
							<cfloop query="getAreasAdministrators">
								<area_admin>
									<user id="#getAreasAdministrators.user_id#"><name><![CDATA[#getAreasAdministrators.user_name#]]></name><family_name><![CDATA[#getAreasAdministrators.family_name#]]></family_name></user>
									<area id="#getAreasAdministrators.area_id#">
										<name><![CDATA[#getAreasAdministrators.name#]]></name>
									</area>
								</area_admin>
							</cfloop>
						</cfoutput>
					</cfif>
				</areas_admins>
				</cfsavecontent>
			</cfprocessingdirective>
			
			
			<cfset xmlResponseContent = xmlResult>
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>

	<!---    --------------------SET AREA ADMINISTRATOR-------------------------------------  --->
	<cffunction name="setAreaAdministrator" output="false" returntype="string" access="public">
		<cfargument name="request" type="string" required="yes">
		<!---<cfargument name="area_id" type="string" required="true">--->
		
		<cfset var method = "setAreaAdministrator">
		<cfset var usr_id = "">
		<cfset var area_id = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->
		
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinclude template="includes/checkAdminAccess.cfm">
			
			<cfset usr_id = xmlRequest.request.parameters.user.xmlAttributes.id>
			<cfset area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
			
			<!---checkIfExist--->
			<cfquery name="checkIfExist" datasource="#client_dsn#">
				SELECT *
				FROM #client_abb#_areas_administrators
				WHERE user_id=<cfqueryparam value="#usr_id#" cfsqltype="cf_sql_integer"> AND area_id=<cfqueryparam value="#area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif checkIfExist.recordCount GT 0><!---The user already is an administrator of the area  --->
				<cfset error_code = 409>
			
				<cfthrow errorcode="#error_code#">
			</cfif>
			
			
			<cfquery name="getArea" datasource="#client_dsn#">
				SELECT id, name
				FROM #client_abb#_areas AS areas
				WHERE areas.id = <cfqueryparam value="#area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
						
			<cfif getArea.recordCount GT 0>
				
				<cfquery name="getUser" datasource="#client_dsn#">
					SELECT id, name, family_name
					FROM #client_abb#_users
					WHERE id = <cfqueryparam value="#usr_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
				
				<cfif getUser.recordCount GT 0>
				
					<cfquery name="insertQuery" datasource="#client_dsn#"  >					
						INSERT INTO #client_abb#_areas_administrators (user_id, area_id)
						VALUES (
							<cfqueryPARAM value="#usr_id#" CFSQLType="cf_sql_integer">,			
							<cfqueryPARAM value="#area_id#" CFSQLType="cf_sql_integer">									
							);			
					</cfquery>
				
					<cfsavecontent variable="xmlResponseContent">
						<cfoutput>
						<area_admin>
						<user id="#usr_id#"><name><![CDATA[#getUser.name#]]></name><family_name><![CDATA[#getUser.family_name#]]></family_name></user>
						<area id="#area_id#">
							<name><![CDATA[#getArea.name#]]></name>
						</area>
						</area_admin>
						</cfoutput>
					</cfsavecontent>
					
					<cfinclude template="includes/functionEnd.cfm">
				
				<cfelse><!---the user does not exist--->
				
					<cfset error_code = 204>
					
					<cfthrow errorcode="#error_code#"> 
				
				</cfif>
			
			<cfelse><!---The area does not exist--->
				
				<cfset xmlResponseContent = arguments.request>
				
				<cfset error_code = 401>
				
				<cfthrow errorcode="#error_code#">
				
			</cfif>
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
	
		<cfreturn xmlResponse>
		
	</cffunction>
	<!--- -----------------------------------------------------------------------  --->
	
	<!---    --------------------DISSOCIATE AREA ADMINISTRATOR-------------------------------------  --->
	<cffunction name="dissociateAreaAdministrator" output="false" returntype="string" access="public">
		<cfargument name="request" type="string" required="yes">
		<!---<cfargument name="area_id" type="string" required="true">--->
		
		<cfset var method = "dissociateAreaAdministrator">
		<cfset var usr_id = "">
		<cfset var area_id = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->
		
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinclude template="includes/checkAdminAccess.cfm">
			
			<cfset usr_id = xmlRequest.request.parameters.user.xmlAttributes.id>
			<cfset area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
							
			<cfquery name="deleteQuery" datasource="#client_dsn#"  >					
				DELETE FROM #client_abb#_areas_administrators 
				WHERE user_id = <cfqueryPARAM value = "#usr_id#" CFSQLType = "CF_SQL_varchar">
					AND area_id = <cfqueryPARAM value = "#area_id#" CFSQLType = "CF_SQL_integer">;			
			</cfquery>
						
			<cfset xmlResponseContent = '<user id="#usr_id#"/><area id="#area_id#"/>'>
		
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
	
		<cfreturn xmlResponse>
		
			
	</cffunction>
	<!--- -----------------------------------------------------------------------  --->
	
	
	<!---  -------------------getAreaLink----------------------   --->
	
	<cffunction name="getAreaLink" returntype="string" access="public">
		<cfargument name="area_id" required="yes" type="numeric">
		
		<cfset var method = "getAreaLink">
		
		<cfset var area_link = "">
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfquery name="getAreaLink" datasource="#client_dsn#">
				SELECT link, parent_id
				FROM #client_abb#_areas AS areas
				WHERE areas.id = #arguments.area_id#;
			</cfquery>	
			
			<cfif getAreaLink.recordCount GT 0>
			
				<cfif len(getAreaLink.link) IS 0 OR getAreaLink.link EQ "NULL">
					<cfif len(getAreaLink.parent_id) IS NOT 0 AND getAreaLink.parent_id IS NOT "NULL" AND getAreaLink.parent_id GT 0> 
						<cfinvoke component="AreaManager" method="getAreaLink" returnvariable="area_link">
							<cfinvokeargument name="area_id" value="#getAreaLink.parent_id#">
						</cfinvoke>
					<cfelse><!---Area link not found--->
			
						<cfset error_code = 407>
					
						<cfthrow errorcode="#error_code#">
					</cfif>	
				<cfelse>
					<cfset area_link = getAreaLink.link>	
				</cfif>
				
				<cfreturn area_link>
				
			<cfelse><!---Area does not exist--->
			
				<cfset error_code = 401>
			
				<cfthrow errorcode="#error_code#">
					
			</cfif>	

	</cffunction>
	
	
	<!---  -------------------getAreaImageId----------------------   --->
	
	<cffunction name="getAreaImageId" returntype="numeric" access="public">
		<cfargument name="area_id" required="yes" type="numeric">
		
		<cfset var method = "getAreaImageId">
		
		<cfset var area_image_id = "">
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getAreaImageId" returnvariable="area_image_id">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
						
			<cfreturn area_image_id>

	</cffunction>	
	
	<!--- ----------------------- createAreaImage -------------------------------- --->
	<!---Este método no se usa pero más adelante debería usarse--->
	<!--- 
	<cffunction name="createAreaImage" returntype="string" output="false" access="public">		
			<cfargument name="request" type="string" required="yes">
			
			<cfset var method = "createAreaImage">
			
			<!---<cfinclude template="includes/initVars.cfm">--->	
			
			<cftry>
				
				<cfinclude template="includes/functionStart.cfm">
				
				<cfinvoke component="FileManager" method="createImageFile" returnvariable="xmlResponseContent">
					<cfinvokeargument name="file" value="#xmlRequest.request.parameters.file#">
					<cfinvokeargument name="type" value="area_image">
					<cfinvokeargument name="status" value="pending"> 
				</cfinvoke>
			
				<cfinclude template="includes/functionEnd.cfm">
				
				<cfcatch>
					<cfset xmlResponseContent = arguments.request>
					<cfinclude template="includes/errorHandler.cfm">
				</cfcatch>										
				
			</cftry>
			
			<cfreturn xmlResponse>
		
		</cffunction> 
	--->
	
	
	
	<!--- ----------------------- selectAreaImage -------------------------------- --->
	
	<cffunction name="selectAreaImage" returntype="string" access="public">		
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "selectAreaImage">
		
		<cfset var area_id = "">
		<cfset var with_image = "">
		<cfset var link = "">
		<cfset var with_link = "">
		<cfset var xmlFile = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
		
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
			
			<cfinclude template="includes/checkAreaAdminAccess.cfm">
			
			<cfquery name="selectAreaImageQuery" datasource="#client_dsn#">
				SELECT image_id, file_name, link
				FROM #client_abb#_areas AS areas INNER JOIN #client_abb#_areas_images AS images ON areas.image_id = images.id
				WHERE areas.id = <cfqueryparam value="#area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif selectAreaImageQuery.recordCount GT 0>
				<cfset with_image = true>
				<cfset xmlFile = '<file id="#selectAreaImageQuery.image_id#"><file_name><![CDATA[#selectAreaImageQuery.file_name#]]></file_name></file>' >
				<!---check if link exist--->
				<cfif len(selectAreaImageQuery.link) GT 0 AND selectAreaImageQuery.link NEQ "NULL">
					<cfset with_link = true>
				<cfelse>
					<cfset with_link = false>
				</cfif>
				<cfset link = selectAreaImageQuery.link>
			<cfelse>
				<cfset with_image = false>
				<cfset with_link = false>
				<cfset link = "">
			</cfif>
			
			<cfset xmlResponseContent = '<area id="#area_id#" with_image="#with_image#" with_link="#with_link#" link="#link#" />'&xmlFile>
					
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
	
	</cffunction>
	

	<!--- -------------------------- deleteAreaImage -------------------------------- --->

	<cffunction name="deleteAreaImage" returntype="struct" output="false" access="public">		
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfset var method = "deleteAreaImage">

		<cfset var response = structNew()>

		<cfset var image_id = "">
				
		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
						
			<cfinclude template="includes/checkAreaAdminAccess.cfm">
						
			<cfquery name="beginQuery" datasource="#client_dsn#">
				BEGIN;
			</cfquery>
			
			<!--- Query to get the physical name and file_size of the file --->
			<cfquery name="selectAreaImageQuery" datasource="#client_dsn#">
				SELECT image_id, physical_name, file_size
				FROM #client_abb#_areas AS areas INNER JOIN #client_abb#_areas_images AS images ON areas.image_id = images.id
				WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif selectAreaImageQuery.recordCount GT 0>
			
				<cfset image_id = selectAreaImageQuery.image_id>
				
				<!--- Change association --->
				<cfquery name="deleteAssociationFolderQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_areas
					SET image_id = <cfqueryparam null="yes" cfsqltype="cf_sql_numeric">
					WHERE id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
				</cfquery>		
				
				<!--- Deletion of the row representing the file --->
				<cfquery name="deleteFileQuery" datasource="#client_dsn#">		
					DELETE
					FROM #client_abb#_areas_images
					WHERE id = <cfqueryparam value="#image_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
				
				<cfset path = APPLICATION.filesPath&'/#client_abb#/areas_images/'>	
				<cfset filePath = path & "#selectAreaImageQuery.physical_name#">			
				
				<!--- Now we delete physically the file on the server --->
				<cfif FileExists(filePath)><!---If the physical file exist--->
					<cffile action="delete" file="#filePath#">
				<cfelse><!---The physical file does not exist--->
					<cfset error_code = 608>
				
					<cfthrow errorcode="#error_code#">
				</cfif>
				
				<!---Update User Space Used--->
				<cfquery name="updateAreaSpaceUsed" datasource="#client_dsn#">
					UPDATE #client_abb#_areas
					SET space_used = space_used-#selectAreaImageQuery.file_size#
					WHERE id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
								
				<!--- End of the transaction --->
				<cfquery name="endTransaction" datasource="#client_dsn#">
					COMMIT;
				</cfquery>		

				<cfinclude template="includes/functionEndOnlyLog.cfm">

				<cfset response = {result=true, message="", file_id=#image_id#}>
					
			<cfelse><!---The area has no image--->
			
				<!--- RollBack the transaction --->
				<cfquery name="rollBackTransaction" datasource="#client_dsn#">
					ROLLBACK;
				</cfquery>
				
				<cfset error_code = 406>
			
				<cfthrow errorcode="#error_code#">
							
			</cfif>	
					
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
	
	</cffunction>
	
	
<!--- -------------------------- GET MENU TYPE LIST -------------------------------- --->
	
	<cffunction name="getMenuTypeList" returntype="struct" access="public">
		
		<cfset var method = "getMenuTypeList">
		
		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getMenuTypeList" returnvariable="menuTypeList">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, menuTypeList=#menuTypeList#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>		
		
					
	</cffunction>	

</cfcomponent>