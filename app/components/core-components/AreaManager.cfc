<!--- Copyright Era7 Information Technologies 2007-2014 --->
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
	


</cfcomponent>	