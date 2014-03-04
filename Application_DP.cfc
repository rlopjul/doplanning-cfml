<!--- Copyright Era7 Information Technologies 2007-2014 --->

<cfcomponent displayname="Application" output="false">

	<cfset this.name = 'dp_beta_aws_7'>
	
	<cfset this.clientmanagement="true">
	<cfset this.sessionmanagement="true">
	<cfset this.sessiontimeout="#createtimespan(0,5,0,0)#">
	
	<!--- Set the page request properties. --->
	<cfsetting requesttimeout="840" showdebugoutput="true" /><!---14 minutes--->
	<!---En el web admin de Railo debe estar definido el default requesttimeout al valor de APPLICATION.filesTimeout para que se aplique en las páginas de subida de archivos--->
	
	<cffunction name="onApplicationStart" output="false" returntype="void" >
	
		<cfset APPLICATION.dsn = "doplanning_app">
		<cfset APPLICATION.dataBaseName = "doplanning_app">
		
		<cfset APPLICATION.moduleMessenger = false><!---true/false--->
		<cfset APPLICATION.moduleLdapUsers = false>
		<cfset APPLICATION.moduleConvertFiles = false>
		<cfset APPLICATION.moduleWeb = true>
		<cfset APPLICATION.moduleTwitter = false>
		<cfset APPLICATION.moduleConsultations = true>
		<cfset APPLICATION.includeConsultationsInAlerts = true>
		<cfset APPLICATION.moduleVirtualMeetings = false>
		<cfset APPLICATION.moduleWebRTC = true>
		<cfset APPLICATION.showDniTitle = false>
		<cfset APPLICATION.twoUrlsToAccess = false>
		<cfset APPLICATION.modulefilesWithTables = true>
		<cfset APPLICATION.filesTablesInheritance = true>
		<cfset APPLICATION.moduleLists = true>
		<cfset APPLICATION.moduleForms = true>
		<cfset APPLICATION.modulePubMedComments = true>
		<cfset APPLICATION.moduleListsWithPermissions = true>
		<cfset APPLICATION.moduleAreaFilesLite = true>
		<cfset APPLICATION.changeElementsArea = true>
		<cfset APPLICATION.publicationScope = true>
		<cfset APPLICATION.publicationValidation = true>
		<cfset APPLICATION.userEmailRequired = false>

		<cfset APPLICATION.openTokApiKey = "">
		<cfset APPLICATION.openTokApiSecret = "">
		
		<cfset APPLICATION.languages = "es,en">

		<cfset APPLICATION.errorReport = "email"><!---email/file--->
		
		<cfset APPLICATION.dateFormat = "dd-mm-yyyy">
		
		<cfset APPLICATION.version = "1.8">
		<cfset APPLICATION.clientVersion = "1.8">
		<cfset APPLICATION.clientLoginVersion = "1.4.1">
		
		<cfset APPLICATION.title = "DoPlanning">
		<cfset APPLICATION.identifier = "dp">
		
		<cfset APPLICATION.emailSendMode = ""><!---SMTP/MandrillAPI--->
		<cfset APPLICATION.emailServer = "">
		<cfset APPLICATION.emailServerUserName = "">
		<cfset APPLICATION.emailServerPassword = "">
		<cfset APPLICATION.emailServerPort = ""><!---Default 587, SSL 465 (SSL da problemas con algunas versiones de JDK/JRE y Railo)--->
		<cfset APPLICATION.emailFrom = "">
		<cfset APPLICATION.emailFalseTo = ""> 
		<cfset APPLICATION.emailReply = "">
		<cfset APPLICATION.emailFail = "">
		<cfset APPLICATION.emailErrors = "">
		
		<cfset APPLICATION.smsFrom = APPLICATION.title>
		<cfset APPLICATION.smsUserName = "">
		<cfset APPLICATION.smsPassword = "">
		<cfset APPLICATION.smsServerAddress = "">
		<cfset APPLICATION.smsReportAddress = "">
		
		<cfset APPLICATION.path = "">
		<cfset APPLICATION.resourcesPath = APPLICATION.path&"/app">
		<cfset APPLICATION.uploadFilesPath = APPLICATION.path&"/app/uploadFiles">
		<cfset APPLICATION.corePath = "/dp-core">
		<!---<cfset APPLICATION.componentsPath = APPLICATION.path&"/app/WS">--->
		<cfset APPLICATION.componentsPath = APPLICATION.corePath&"/components">
		<cfset APPLICATION.coreComponentsPath = APPLICATION.componentsPath&"/core-components">
		<cfset APPLICATION.filesPath = "/webroot/files/doplanning">
		<cfset APPLICATION.defaultTimeout = 840><!---Si se pone a un tiempo menor que el de filesTimeout parece que algunas veces da problemas en la subida de archivos al acceder a otros métodos--->
		<cfset APPLICATION.filesTimeout = 840><!---14 minutes--->
		
		<cfset APPLICATION.htmlPath = APPLICATION.path&"/html">
		<cfset APPLICATION.htmlComponentsPath = APPLICATION.htmlPath&"/components">
		
		<cfset APPLICATION.jqueryJSPath = "//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js">
		<cfset APPLICATION.bootstrapJSPath = "//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js">
		<cfset APPLICATION.bootstrapDatepickerJSPath = APPLICATION.htmlPath&"/bootstrap/bootstrap-datepicker/js/bootstrap-datepicker.js">
        <cfset APPLICATION.bootstrapDatepickerCSSPath = APPLICATION.htmlPath&"/bootstrap/bootstrap-datepicker/css/datepicker.css">
		
		<cfset APPLICATION.baseCSSPath = "//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
		<cfset APPLICATION.baseCSSIconsPath = "//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.css">

		<cfset APPLICATION.themeCSSPath = "//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
		
		<cfset APPLICATION.mainUrl = "">
		<cfset APPLICATION.alternateUrl = "">
		<cfset APPLICATION.signOutUrl = "">
		<cfset APPLICATION.helpUrl = "http://doplanning.net/es/page.cfm?id=9&title=tutoriales">
		<cfset APPLICATION.communityUrl = "http://doplanning.net/">
		<cfset APPLICATION.webUrl = "http://doplanning.net/">
		
		<cfset APPLICATION.termsOfUseUrl = APPLICATION.mainUrl&"/web/terms_of_use.cfm">

		<cfset APPLICATION.defaultLanguage = "es">
		
		<!---Google analytics--->
		<cfset APPLICATION.googleAnalyticsAccountId = "">
		

		<cfif APPLICATION.moduleWeb EQ true><!---DPWeb enabled--->
			
			<cfset APPLICATION.dpWebClientAbb = "doplanning">
			<cfset APPLICATION.dpWebClientDsn = APPLICATION.identifier&"_"&APPLICATION.dpWebClientAbb>
			<cfset APPLICATION.dpWebClientTitle = "DoPlanning">

			<cfset APPLICATION.dpUrl = "">

			<cfset APPLICATION.addThisProfileId = "">

			<cfset APPLICATION.cssLayout = "#APPLICATION.path#/app/css/mockup_hcs.css">
            <cfset APPLICATION.colorLayout = "#APPLICATION.path#/app/css/colors/palette_hcs.css">
            <cfset APPLICATION.fontLayout = "#APPLICATION.path#/app/css/fonts/type_hcs.css">
            <cfset APPLICATION.layout = "#APPLICATION.path#/app/layouts/pages/003_hcs.cfm">
            <cfset APPLICATION.indexLayout = "#APPLICATION.path#/app/layouts/pages/001_hcs.cfm">			
            <cfset APPLICATION.jsLayout = "#APPLICATION.path#/app/js/carousel_init.js">   
			
			<cfset APPLICATION.intranetLayout = "#APPLICATION.path#/app/layouts/pages/intranet_hcs.cfm">
			<cfset APPLICATION.indexIntranetLayout = "#APPLICATION.path#/app/layouts/pages/index_intranet_hcs.cfm">
			<cfset APPLICATION.colorIntranetLayout = "#APPLICATION.path#/app/css/colors/palette_intranet_hcs.css">
			<cfset APPLICATION.fontIntranetLayout = "#APPLICATION.path#/app/css/fonts/type_intranet_hcs.css">
			
		</cfif>

		<cfif APPLICATION.moduleMessenger EQ true>
			<cfset APPLICATION.messengerUserExpireTime = 60><!---In seconds--->
			
			<cfschedule action="update"	task="checkIfUsersAreConnected"	operation="HTTPRequest"
			url="#APPLICATION.mainUrl##APPLICATION.resourcesPath#/schedules/checkIfUsersAreConnected.cfm"
			startDate="#DateFormat(now(), 'm/d/yyyy')#"	startTime="#TimeFormat(now(), 'h:mm tt')#"
			interval="#APPLICATION.messengerUserExpireTime#" requestTimeOut="30" publish="no"
			path="#ExpandPath('#APPLICATION.resourcesPath#/schedules/')#"
			resolveURL="yes" file="checkIfUsersAreConnectedResult.html">
		</cfif>
		
		<cfif APPLICATION.moduleLdapUsers EQ true>
			<cfset APPLICATION.ldapServer = "">
			<cfset APPLICATION.ldapServerPort = "389">
			<cfset APPLICATION.ldapServerUserName = "">
			<cfset APPLICATION.ldapServerPassword = "">
			<cfset APPLICATION.ldapUsersPath = "">
			<cfset APPLICATION.ldapScope = "subtree">
			<cfset APPLICATION.ldapUsersLoginAtt = "samaccountname"><!---uid---><!---Att=Attribute--->
			<cfset APPLICATION.ldapUsersPasswordAtt = "userPassword">
			<cfset APPLICATION.ldapName = "">
		</cfif>
		
		<cfif APPLICATION.moduleTwitter IS true>
			<cfset APPLICATION.twitterConsumerKey = "">
			<cfset APPLICATION.twitterConsumerSecret = "">
			<cfset APPLICATION.twitterAccessToken = "">
			<cfset APPLICATION.twitterAccessTokenSecret = "">	
		</cfif>
	
	</cffunction>
	
	<cffunction name="onRequestStart" output="false" returntype="void" >
		
		<cfif NOT isDefined("APPLICATION.dsn")>
			<cfinvoke method="onApplicationStart">
		</cfif>
		
	</cffunction>
	
</cfcomponent>