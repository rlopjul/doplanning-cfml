<cfif isDefined("page_directory")>

  <cfif page_directory NEQ "intranet" OR listFind(APPLICATION.webDirectories,"intranet") GT 0>

    <cfset clientAbb = APPLICATION.dpWebClientAbb>
    <cfset clientDsn = APPLICATION.dpWebClientDsn>
    <cfset clientTitle = APPLICATION.dpWebClientTitle>

    <cfset rootAreaId = APPLICATION.webs["#page_directory#"].areaId>
    <cfset areaTypeRequired = APPLICATION.webs["#page_directory#"].areaType>
    <cfset webDirectory = APPLICATION.webs["#page_directory#"].path>
    <cfset language = APPLICATION.webs["#page_directory#"].language>

  <cfelse><!--- Intranet --->


    <cfif ( isDefined("SESSION.client_abb") AND ( NOT isDefined("is_login_page") OR is_login_page IS false ) ) OR isDefined("URL.abb") OR isDefined("URL.client_abb")>


    	<cfif isDefined("SESSION.client_abb") AND ( NOT isDefined("is_login_page") OR is_login_page IS false )>
    		<cfset clientAbb = SESSION.client_abb>
    	<cfelseif isDefined("URL.abb")>
    		<cfset clientAbb = URL.abb>
    	<cfelseif isDefined("URL.client_abb")>
    		<cfset clientAbb = URL.client_abb>
    	</cfif>

    	<cfif isDefined("SESSION.client_abb") AND isDefined("URL.abb") AND SESSION.client_abb NEQ URL.abb AND ( NOT isDefined("is_login_page") OR is_login_page IS false )>
    		<cflocation url="#APPLICATION.path#/intranet/login/?abb=#URL.abb#" addtoken="no">
    	</cfif>

    	<cfset clientDsn = APPLICATION.identifier&"_"&clientAbb>

    	<!--- getClient --->
    	<cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="clientQuery">
    		<cfinvokeargument name="client_abb" value="#clientAbb#">
    	</cfinvoke>

    	<cfif clientQuery.recordCount GT 0 AND isDefined("page_directory")>

    		<cfset clientTitle = clientQuery.name>

    		<cfinvoke component="#APPLICATION.coreComponentsPath#/WebQuery" method="getWeb" returnvariable="getWebQuery">
    			<cfinvokeargument name="path" value="#page_directory#">

    			<cfinvokeargument name="client_abb" value="#clientAbb#">
    			<cfinvokeargument name="client_dsn" value="#clientDsn#">
    		</cfinvoke>

    		<cfif getWebQuery.recordCount GT 0>

    			<cfset rootAreaId = getWebQuery.area_id>
    			<cfset areaTypeRequired = getWebQuery.area_type>
    			<cfset webDirectory = page_directory>
    			<cfset language = getWebQuery.language>

    			<!---<cfif isDefined("getWebQuery.news_area_id")>
    				<cfset web.newsAreaId = getWebQuery.news_area_id>
    			</cfif>
    			<cfif isDefined("getWebQuery.events_area_id")>
    				<cfset web.eventsAreaId = getWebQuery.events_area_id>
    			</cfif>
    			<cfif isDefined("getWebQuery.publications_area_id")>
    				<cfset web.publicationsAreaId = getWebQuery.publications_area_id>
    			</cfif>--->

    		<cfelse>

    			<cfthrow message="La organización '#clientAbb#' no dispone de '#page_directory#'">

    		</cfif>

    	<cfelse>

    		<cflocation url="#APPLICATION.mainUrl#" addtoken="no">

    	</cfif>


    <cfelse>

    	<cflocation url="#APPLICATION.mainUrl#" addtoken="no">

    </cfif>


  </cfif>

<cfelse>

	<cflocation url="/" addtoken="no">

</cfif>
