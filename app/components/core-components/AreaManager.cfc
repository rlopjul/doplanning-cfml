<!--- Copyright Era7 Information Technologies 2007-2015 --->
<cfcomponent output="false">
	
	<cfset component = "AreaManager">


	<!--- ---------------------------- getAllUserAreasList ---------------------------------- --->
	<!---Obtiene la lista de todas las areas donde el usuario tiene acceso--->
	<!---Obtiene las áreas del usuario pasado como parámetro--->
	
	<cffunction name="getAllUserAreasList" returntype="string" access="public">
		<cfargument name="get_user_id" type="numeric" required="yes">

		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">		
		
		<cfset var method = "getAllUserAreasList">
		
		<cfset var root_area_id = "">
		<cfset var root_user = "">
		<cfset var areasArray = "">
		<cfset var allAreasListUpdated = "">
		<cfset var allAreasList = "">			
						
			<!---<cfinvoke component="AreaManager" method="getRootAreaId" returnvariable="root_area_id">
			</cfinvoke>--->

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getRootArea" returnvariable="rootAreaQuery">
				<cfinvokeargument name="onlyId" value="true">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>
			
			<cfset root_area_id = rootAreaQuery.id>			
			
			<cfinvoke component="UserManager" method="isRootUser" returnvariable="root_user">
				<cfinvokeargument name="get_user_id" value="#arguments.get_user_id#"> 
				<cfinvokeargument name="root_area_id" value="#root_area_id#">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>
			
			<cfif root_user IS true><!---Is root user--->
				
				<cfquery name="getAllAreasQuery" datasource="#client_dsn#">
					SELECT id
					FROM #client_abb#_areas;
				</cfquery>			
				
				<cfif getAllAreasQuery.RecordCount GT 0>

					<cfset allAreasList = valueList(getAllAreasQuery.id)>
					
				</cfif>
			
			<cfelse><!---Is not root user--->
			
				<cfinvoke component="AreaManager" method="getUserAreasArray" returnvariable="areasArray">
					<cfinvokeargument name="get_user_id" value="#arguments.get_user_id#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>			
			
				<cfinvoke component="AreaManager" method="loopUserAreas" returnvariable="allAreasListUpdated">
					<cfinvokeargument name="area_id" value="#root_area_id#">
					<cfinvokeargument name="areasArray" value="#areasArray#">
					<cfinvokeargument name="allAreasList" value="#allAreasList#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>
			
				<cfset allAreasList = allAreasListUpdated>
			
			</cfif>
		
		<cfreturn allAreasList>
		
	</cffunction>



	<!--- ---------------------------- getUserAreasArray ---------------------------------- --->
	<!---Obtiene las áreas donde el usuario está en la lista de usuarios--->
	
	<!---Obtiene las áreas del usuario pasado como parámetro--->
	
	<cffunction name="getUserAreasArray" returntype="array" access="public">
		<cfargument name="get_user_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">	
		
		<cfset var method = "getUserAreasArray">
		
		<cfset var areasArray = ArrayNew(1)>
					
			<cfquery name="getUserAreas" datasource="#arguments.client_dsn#">
				SELECT area_id
				FROM #arguments.client_abb#_areas_users
				WHERE user_id = <cfqueryparam value="#arguments.get_user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>			
			
			<cfif getUserAreas.RecordCount GT 0>
				
				<cfloop query="getUserAreas">
					<cfset ArrayAppend(areasArray,#getUserAreas.area_id#)>
				</cfloop>

			</cfif>									
		
		<cfreturn areasArray>
		
	</cffunction>



	<!--- ---------------------------- loopUserAreas ---------------------------------- --->
	
	<cffunction name="loopUserAreas" returntype="string" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="areasArray" type="array" required="yes">
		<cfargument name="allAreasList" type="string" required="yes">
		<cfargument name="allowed" type="boolean" required="no" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">
		
		<cfset var method = "loopUserAreas">
		
		<cfset var userBelongsToArea = false>
								
			<cfif arguments.allowed EQ true>
				<cfset userBelongsToArea = true>
			<cfelse>
				<cfset list = ArrayToList(#arguments.areasArray#,",")>
				<cfset findAreaInList = ListFind(list, arguments.area_id)>
				 
				<cfif findAreaInList GT 0>
					<cfset userBelongsToArea = true>
				<cfelse>
					<cfset userBelongsToArea = false>
				</cfif>	

			</cfif>
			
			<cfif userBelongsToArea EQ true>

				<cfset arguments.allAreasList = ListAppend(arguments.allAreasList,arguments.area_id)>
				
			</cfif>
			
			<!--- Sub areas --->
			<cfquery name="subAreasQuery" datasource="#arguments.client_dsn#">
				SELECT id 
				FROM #arguments.client_abb#_areas
				WHERE parent_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfset var hasSubAreas = (#subAreasQuery.recordCount# GT 0)>
			
			<!--- Appending subareas content in the case where there are sub areas --->
			<cfif hasSubAreas EQ true>			
				<cfloop query="subAreasQuery">				
					<cfinvoke component="AreaManager" method="loopUserAreas" returnvariable="allAreasListUpdated">
						<cfinvokeargument name="area_id" value="#subAreasQuery.id#">
						<cfinvokeargument name="areasArray" value="#arguments.areasArray#">
						<cfinvokeargument name="allAreasList" value="#arguments.allAreasList#">
						<cfinvokeargument name="allowed" value="#userBelongsToArea#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>
					
					<cfset arguments.allAreasList = allAreasListUpdated>
										
				</cfloop>			
			</cfif>
		
		<cfreturn arguments.allAreasList>
		
	</cffunction>


	<!--- ------------------------------------- getSubAreasIds ------------------------------------- --->

	<!--- Hay un getSubAreasIds en AreaQuery.cfc --->
	
	<!---<cffunction name="getSubAreasIds" output="false" access="public" returntype="string">		
		<cfargument name="area_id" type="numeric" required="true"/>
		
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getSubAreasIds">

		<cfset var getAreasQuery = "">
		<cfset var subAreasIds = "">
		<cfset var subSubAreasIds = "">
						
			<cfquery name="getAreasQuery" datasource="#client_dsn#">
				SELECT id
				FROM #client_abb#_areas
				WHERE parent_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfset subAreasIds = valueList(getAreasQuery.id)>

			<cfloop query="#getAreasQuery#">

				<cfinvoke component="AreaManager" method="getSubAreasIds" returnvariable="subSubAreasIds">
					<cfinvokeargument name="area_id" value="#getAreasQuery.id#">				
					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

				<cfif len(subSubAreasIds) GT 0>
					<cfset subAreasIds = listAppend(subAreasIds, subSubAreasIds)>
				</cfif>
				
			</cfloop>
			
		<cfreturn subAreasIds>
		
	</cffunction>--->
	

	<!--- -------------------------- canUserAccessToArea -------------------------------- --->
	<!---Comprueba si el usuario puede acceder al área, y devuelve el resultado en una variable--->
	
	<cffunction name="canUserAccessToArea" returntype="boolean" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">
		
		<cfset var method = "canUserAccessToArea">
		
		<cfset var access_result = false>
		<cfset var area_users_list = "">

		<cfquery datasource="#client_dsn#" name="getAreaUsers">
			SELECT areas.parent_id, areas_users.user_id
			FROM #client_abb#_areas AS areas
			LEFT JOIN #client_abb#_areas_users AS areas_users ON areas_users.area_id = areas.id 
			WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<cfif getAreaUsers.recordCount GT 0>

			<!--- 
			<cfquery dbtype="query" name="getAreaUser">
				SELECT user_id 
				FROM getAreaUsers
				WHERE user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">;
			</cfquery> 
			

			<cfif getAreaUser.recordCount GT 0>
			
				<cfset access_result = true>--->

			<cfset area_users_list = ValueList(getAreaUsers.user_id, ",")>
			
			<cfif listFind(area_users_list, arguments.user_id) GT 0>
			
				<cfset access_result = true>
								
			<cfelse>
					
				<cfif isNumeric(getAreaUsers.parent_id)>
						
					<cfinvoke component="AreaManager" method="canUserAccessToArea" returnvariable="access_result">
						<cfinvokeargument name="area_id" value="#getAreaUsers.parent_id#">
						<cfinvokeargument name="user_id" value="#arguments.user_id#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>
					
				</cfif>
				
			</cfif>

		<cfelse><!---The area does not exist--->
		
			<cfset error_code = 401>
			
			<cfthrow errorcode="#error_code#">
		
		</cfif>	

		<!---
		<cfquery datasource="#client_dsn#" name="getAreaUsers">
			SELECT areas_users.user_id, areas.parent_id
			FROM #client_abb#_areas_users AS areas_users
			INNER JOIN #client_abb#_areas AS areas ON areas_users.area_id = areas.id 
			AND areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<cfif getAreaUsers.recordCount GT 0>
		
			<cfset area_users_list = ValueList(getAreaUsers.user_id, ",")>
			<cfif listFind(area_users_list, arguments.check_user_id) GT 0>
			
				<cfset access_result = true>
				
			<cfelse>
					
				<cfif isNumeric(getAreaUsers.parent_id)>
						
					<cfinvoke component="AreaManager" method="canUserAccessToArea" returnvariable="access_result">
						<cfinvokeargument name="area_id" value="#getAreaUsers.parent_id#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>
					
				</cfif>
				
			</cfif>
			
		<cfelse><!---No users in area--->
		
			<cfquery datasource="#client_dsn#" name="getAreaParent">
				SELECT areas.parent_id
				FROM #client_abb#_areas AS areas
				WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif isNumeric(getAreaParent.parent_id)>
			
				<cfinvoke component="AreaManager" method="canUserAccessToArea" returnvariable="access_result">
					<cfinvokeargument name="area_id" value="#getAreaParent.parent_id#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>
			
			</cfif>
		
		</cfif>--->
		
		<cfreturn access_result>
		
	</cffunction>
	


	<!--- -------------------------- canUserAccessToAreaExtended -------------------------------- --->
	<!---Comprueba si el usuario puede acceder al área, y devuelve el resultado en una variable--->
	
	<cffunction name="canUserAccessToAreaExtended" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="user_id" type="numeric" required="true">
		<cfargument name="checkedAreasIds" type="string" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">
		
		<cfset var method = "canUserAccessToAreaExtended">
		
		<cfset var access_result = false>
		<cfset var area_users_list = "">
		<!--- <cfset var checkedAreasIds = arguments.area_id> --->

		<cfquery datasource="#client_dsn#" name="getAreaUsers">
			SELECT areas.parent_id, areas_users.user_id
			FROM #client_abb#_areas AS areas
			LEFT JOIN #client_abb#_areas_users AS areas_users ON areas_users.area_id = areas.id 
			WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<cfif getAreaUsers.recordCount GT 0>

			<cfset area_users_list = ValueList(getAreaUsers.user_id, ",")>
			
			<cfif listFind(area_users_list, arguments.user_id) GT 0>
			
				<cfset access_result = true>
								
			<cfelse>

				<cfset arguments.checkedAreasIds = listAppend(arguments.checkedAreasIds, arguments.area_id)>
					
				<cfif isNumeric(getAreaUsers.parent_id) AND listFind(arguments.checkedAreasIds, getAreaUsers.parent_id) IS 0>
						
					<cfinvoke component="AreaManager" method="canUserAccessToAreaExtended" returnvariable="accessToAreaResult">
						<cfinvokeargument name="area_id" value="#getAreaUsers.parent_id#">
						<cfinvokeargument name="user_id" value="#arguments.user_id#">
						<cfinvokeargument name="checkedAreasIds" value="#arguments.checkedAreasIds#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

					<cfset access_result = accessToAreaResult.accessResult>

				</cfif>
				
			</cfif>

		<cfelse><!---The area does not exist--->
		
			<cfset error_code = 401>
			
			<cfthrow errorcode="#error_code#">
		
		</cfif>	

		<cfreturn {accessResult=access_result, checkedAreasIds=#arguments.checkedAreasIds#}>
		
	</cffunction>



	<!--- -------------------------- getNearestAreaUserAssociated -------------------------------- --->
	<!---Obtiene el área más próxima en la que está asociado el usuario (como usuario o como administrador)--->
	
	<cffunction name="getNearestAreaUserAssociated" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="userType" type="string" required="false" default="users"><!---users/administrators--->

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">
		
		<cfset var method = "getNearestAreaUserAssociated">

		<cfset var response = structNew()>

		<cfset var area_users_list = "">

		<cfquery datasource="#client_dsn#" name="getAreaUsers">
			SELECT areas.parent_id, areas.name, areas_users.user_id 
			FROM #client_abb#_areas AS areas
			LEFT JOIN #client_abb#_areas_#arguments.userType# AS areas_users ON areas_users.area_id = areas.id 
			WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<cfif getAreaUsers.recordCount GT 0>

			<cfset area_users_list = ValueList(getAreaUsers.user_id, ",")>
			
			<cfif listFind(area_users_list, arguments.user_id) GT 0>

				<cfset response = {result=true, area_id=#arguments.area_id#, area_name=#getAreaUsers.name#}>

			<cfelse>

				<cfif isNumeric(getAreaUsers.parent_id)>
					
					<cfinvoke component="AreaManager" method="getNearestAreaUserAssociated" returnvariable="getAreaUserAssociatedResponse">
						<cfinvokeargument name="area_id" value="#getAreaUsers.parent_id#">
						<cfinvokeargument name="user_id" value="#arguments.user_id#">

						<cfinvokeargument name="userType" value="#arguments.userType#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

					<cfset response = getAreaUserAssociatedResponse>

				<cfelse>

					<cfset response = {result=false}>

				</cfif>

			</cfif>
							
		<cfelse>
				
			<cfset error_code = 401>
			
			<cfthrow errorcode="#error_code#">
			
		</cfif>
		
		<cfreturn response>
		
	</cffunction>



	<!--- -------------------------- getHighestAreaUserAssociated -------------------------------- --->
	<!---Obtiene el área más alta en la que está asociado el usuario (como usuario o como administrador)--->
	
	<cffunction name="getHighestAreaUserAssociated" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="highest_area_id" type="numeric" required="false">

		<cfargument name="userType" type="string" required="false" default="users"><!---users/administrators--->

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">
		
		<cfset var method = "getNearestAreaUserAssociated">

		<cfset var response = structNew()>

		<cfset var area_users_list = "">

		<cfquery datasource="#client_dsn#" name="getAreaUsers">
			SELECT areas.parent_id, areas.name, areas_users.user_id 
			FROM #client_abb#_areas AS areas
			LEFT JOIN #client_abb#_areas_#arguments.userType# AS areas_users ON areas_users.area_id = areas.id 
			WHERE areas.id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
		
		<cfif getAreaUsers.recordCount GT 0>

			<cfset area_users_list = ValueList(getAreaUsers.user_id, ",")>
			
			<cfif listFind(area_users_list, arguments.user_id) GT 0>

				<cfif isNumeric(getAreaUsers.parent_id)>

					<cfinvoke component="AreaManager" method="getHighestAreaUserAssociated" returnvariable="getAreaUserAssociatedResponse">
						<cfinvokeargument name="area_id" value="#getAreaUsers.parent_id#">
						<cfinvokeargument name="user_id" value="#arguments.user_id#">

						<cfinvokeargument name="highest_area_id" value="#arguments.area_id#">

						<cfinvokeargument name="userType" value="#arguments.userType#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

					<cfset response = getAreaUserAssociatedResponse>

				<cfelse>

					<cfset response = {result=true, highest_area_id=#arguments.area_id#}>

				</cfif>

			<cfelse>

				<cfif isNumeric(getAreaUsers.parent_id)>
					
					<cfinvoke component="AreaManager" method="getHighestAreaUserAssociated" returnvariable="getAreaUserAssociatedResponse">
						<cfinvokeargument name="area_id" value="#getAreaUsers.parent_id#">
						<cfinvokeargument name="user_id" value="#arguments.user_id#">

						<cfinvokeargument name="highest_area_id" value="#arguments.highest_area_id#">

						<cfinvokeargument name="userType" value="#arguments.userType#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

					<cfset response = getAreaUserAssociatedResponse>

				<cfelse>

					<cfif NOT isDefined("arguments.highest_area_id")>
						
						<cfset error_code = 104>
			
						<cfthrow errorcode="#error_code#">

					<cfelse>

						<cfset response = {result=true, highest_area_id=#arguments.highest_area_id#}>

					</cfif>

				</cfif>

			</cfif>
							
		<cfelse>
				
			<cfset error_code = 401>
			
			<cfthrow errorcode="#error_code#">
			
		</cfif>
		
		<cfreturn response>
		
	</cffunction>


	


</cfcomponent>	