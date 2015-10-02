<!---Copyright Era7 Information Technologies 2007-2014--->

<cfcomponent output="false">

	<cfset component = "WebManager">


  <cffunction name="setWebVars" output="false" returntype="strcut" access="public">
    <cfargument name="path" type="string" required="true">

    <cfargument name="client_abb" type="string" required="true">
    <cfargument name="client_dsn" type="string" required="true">

    <cfset var method = "getWeb">

		<cfset var web = structNew()>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/WebQuery" method="getWeb" returnvariable="getWebQuery">
				<cfinvokeargument name="path" value="#arguments.path#">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfif getWebQuery.recordCount GT 0>

				<cfset web.path = webPath>
				<cfset web.pathUrl = getWebQuery.path_url>
				<cfset web.areaId = getWebQuery.area_id>
				<cfset web.areaType = getWebQuery.area_type>
				<cfset web.language = getWebQuery.language>


				<cfif isDefined("getWebQuery.news_area_id")>
					<cfset web.newsAreaId = getWebQuery.news_area_id>
				</cfif>
				<cfif isDefined("getWebQuery.events_area_id")>
					<cfset web.eventsAreaId = getWebQuery.events_area_id>
				</cfif>
				<cfif isDefined("getWebQuery.publications_area_id")>
					<cfset web.publicationsAreaId = getWebQuery.publications_area_id>
				</cfif>

				<cfreturn web>

			<cfelse>
				<cfthrow message="Web con directorio '#webPath#' no definido en tabla #APPLICATION.dpWebClientAbb#_webs">
			</cfif>

  </cffunction>

</cfcomponent>
