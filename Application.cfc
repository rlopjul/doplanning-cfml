<!--- Copyright Era7 Information Technologies 2007-2016 --->

<cfcomponent displayname="Application" output="false">

	<cfset this.name = 'dp_dev_1'>

	<cfset this.clientmanagement="true">
	<cfset this.sessionmanagement="true">
	<cfset this.sessiontimeout="#createtimespan(0,5,0,0)#">
	<cfset this.compression = true><!--- Enable compression (GZip) --->

	<!--- Set the page request properties. --->
	<cfsetting requesttimeout="840" showdebugoutput="true" /><!---14 minutes--->
	<!---En el web admin de Railo debe estar definido el default requesttimeout al valor de APPLICATION.filesTimeout para que se aplique en las páginas de subida de archivos--->

	<cffunction name="onApplicationStart" output="false" returntype="void">

		<cfinclude template="Application.private.cfm">

		<cfinvoke component="/dp-core/components/core-components/ApplicationManager" method="setApplicationVars">

			<cfinvokeargument name="emailServerUserName" value="#emailServerUserName#">
			<cfinvokeargument name="emailServerPassword" value="#emailServerPassword#">
			<cfinvokeargument name="emailFrom" value="#emailFrom#">

			<cfinvokeargument name="openTokApiKey" value="#openTokApiKey#">
			<cfinvokeargument name="openTokApiSecret" value="#openTokApiSecret#">

			<cfinvokeargument name="serverIp" value="#serverIp#">

			<cfinvokeargument name="mainUrl" value="#mainUrl#">
			<cfinvokeargument name="signOutUrl" value="#signOutUrl#">

			<cfinvokeargument name="ldapName" value="#ldapName#">

			<cfinvokeargument name="moduleLdapUsers" value="true">
			<cfinvokeargument name="moduleWeb" value="true">
			<cfinvokeargument name="moduleWebRTC" value="true">
			<cfinvokeargument name="showDniTitle" value="false">
			<cfinvokeargument name="modulePubMedComments" value="true">
			<cfinvokeargument name="moduleListsWithPermissions" value="true">
			<cfinvokeargument name="changeElementsArea" value="true">
			<cfinvokeargument name="publicationScope" value="true">
			<cfinvokeargument name="publicationValidation" value="true">
			<cfinvokeargument name="publicationRestricted" value="true">
			<cfinvokeargument name="userEmailRequired" value="false">
			<cfinvokeargument name="moduleAntiVirus" value="true">

			<cfinvokeargument name="homeTab" value="true">
			<cfinvokeargument name="moduleDPDocuments" value="true">
			<cfinvokeargument name="includeLegalTextInAlerts" value="false">

			<cfinvokeargument name="addSchedules" value="true">
			<cfinvokeargument name="schedulesExcludeClients" value="#schedulesExcludeClients#">

			<cfinvokeargument name="hideInputLabels" value="true">
			<cfinvokeargument name="webFriendlyUrls" value="true">
			<cfinvokeargument name="changeUserPreferencesByAdmin" value="true">
		</cfinvoke>

	</cffunction>


	<cffunction name="onRequestStart" output="false" returntype="void">

		<cfif NOT isDefined("APPLICATION.dsn")>
			<cfinvoke method="onApplicationStart">
		</cfif>

	</cffunction>

</cfcomponent>
