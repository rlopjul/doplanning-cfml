<!---Copyright Era7 Information Technologies 2007-2009

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 22-05-2012
	
--->

<cfcomponent displayname="Application" output="false">

	<!---<cfprocessingdirective pageencoding="utf-8"/>---><!---MUY IMPORTANTE PARA QUE LOS CARACTERES APAREZCAN BIEN--->

	<cfset this.name = 'ASNC_beta_3'>
	
	<cfset this.clientmanagement="true">
	<cfset this.sessionmanagement="true">
	<cfset this.sessiontimeout="#createtimespan(0,5,0,0)#">
	
	<!--- Define the page request properties. --->
	<cfsetting requesttimeout="50400" showdebugoutput="true" />
	
	<cffunction name="onApplicationStart" output="false" returntype="void" >
	
		<cfset APPLICATION.dsn = "asnc_app">
		<cfset APPLICATION.dataBaseName = "asnc_app">
		
		<cfset APPLICATION.moduleMessenger = "enabled"><!---enabled/disabled--->
		<cfset APPLICATION.moduleLdapUsers = "enabled">
		<cfset APPLICATION.moduleConvertFiles = "enabled">
		<cfset APPLICATION.moduleWeb = "enabled">
		<cfset APPLICATION.moduleTwitter = true>
		
		<cfset APPLICATION.errorReport = "email"><!---email/file--->
		
		<cfset APPLICATION.dateFormat = "dd-mm-yyyy">
		
		<cfset APPLICATION.version = "1.9.6">
		<cfset APPLICATION.clientVersion = "1.9.9">
		<cfset APPLICATION.clientLoginVersion = "1.4.1">
		<cfset APPLICATION.title = "Colabora">
		<cfset APPLICATION.identifier = "vpnet"><!---Por defecto aquí debe poner dp. dp para DoPlanning. vpnet para hospital--->
		
		<cfset APPLICATION.emailServer = "10.72.32.4">
		<cfset APPLICATION.emailServerUserName = "colabora">
		<cfset APPLICATION.emailServerPassword = "hare">
		<cfset APPLICATION.emailFrom = """#APPLICATION.title#"" <colabora.asnc.sspa@juntadeandalucia.es>">
		<cfset APPLICATION.emailFalseTo = """Undisclosed-Recipients"" <colabora.asnc@gmail.com>"> 
		<cfset APPLICATION.emailReply = "support@era7.com">
		<cfset APPLICATION.emailFail = "support@era7.com">
		<cfset APPLICATION.emailErrors = "bugs@doplanning.net">
		
		<cfset APPLICATION.smsFrom = APPLICATION.title>
		<cfset APPLICATION.smsUserName = "yolanda.garrido.sspa">
		<cfset APPLICATION.smsPassword = "1234567">
		<cfset APPLICATION.smsServerAddress = "http://pasarela-sms.juntadeandalucia.es:9090/p3s/SMS">
		<!---<cfset APPLICATION.smsServerProxyAddress = "http://api.mensatek.com:3378/v4/enviar.php">--->
		<cfset APPLICATION.smsReportAddress = "support@era7.com">
		
		<cfset APPLICATION.path = "/servicioandaluzdesalud/asnc/colabora/beta">
		<cfset APPLICATION.resourcesPath = APPLICATION.path&"/app">
		<cfset APPLICATION.componentsPath = APPLICATION.path&"/app/WS">
		<!---<cfset APPLICATION.webServicesPath = "/dp_pruebas/WS">--->
		<cfset APPLICATION.uploadFilesPath = APPLICATION.path&"/app/uploadFiles">
		<cfset APPLICATION.filesPath = "/opt/resin-3.1.8/webapps/app_files">
		<cfset APPLICATION.defaultTimeout = 55>
		<cfset APPLICATION.filesTimeout = 50400><!---14 minutes--->
		
		<cfset APPLICATION.htmlPath = APPLICATION.path&"/html">
		<cfset APPLICATION.htmlComponentsPath = APPLICATION.htmlPath&"/components">
		
		<cfset APPLICATION.jqueryJSPath = APPLICATION.path&"/jquery/js/jquery-1.7.2.min.js">
		<cfset APPLICATION.jqueryUIJSPath = APPLICATION.path&"/jquery/jquery-ui/jquery-ui-1.8.18.custom.min.js">
		<cfset APPLICATION.jqueryUICSSPath = APPLICATION.path&"/jquery/jquery-ui/css/cupertino/jquery-ui-1.8.18.custom.css">
		
		<cfset APPLICATION.mainUrl = "http://10.72.32.24">
		<cfset APPLICATION.alternateUrl = "http://www.juntadeandalucia.es/servicioandaluzdesalud/asnc/colabora/beta">
		<cfset APPLICATION.signOutUrl = "http://10.72.32.24">
		<!---<cfset APPLICATION.mainUrl = APPLICATION.path>
		<cfset APPLICATION.signOutUrl = APPLICATION.path>--->
		<cfset APPLICATION.helpUrl = APPLICATION.mainUrl&"/tutorials/">
		<cfset APPLICATION.communityUrl = APPLICATION.mainUrl&"">
		<cfset APPLICATION.webUrl = APPLICATION.mainUrl&"/web/">
		
		<cfset APPLICATION.termsOfUsePage = "/web/terms_of_use.cfm">
		
		<cfset APPLICATION.addThisProfileId = "ra-4fe04369255341c2">
		
		<cfset APPLICATION.defaultLanguage = "es">
		<!---Al cambiar la aplicacion de sitio tambien hay que modificar los extends de los Application--->
		
		<cfif APPLICATION.moduleMessenger EQ "enabled">
			
			<cfset APPLICATION.messengerUserExpireTime = 60><!---In seconds--->
			
			<cfschedule action="update"	task="checkIfUsersAreConnected"	operation="HTTPRequest"
			url="#APPLICATION.mainUrl##APPLICATION.resourcesPath#/schedules/checkIfUsersAreConnected.cfm"
			startDate="#DateFormat(now(), 'm/d/yyyy')#"	startTime="#TimeFormat(now(), 'h:mm tt')#"
			interval="#APPLICATION.messengerUserExpireTime#" requestTimeOut="30" publish="no"
			path="#ExpandPath('#APPLICATION.resourcesPath#/schedules/')#"
			resolveURL="yes" file="checkIfUsersAreConnectedResult.html">
		</cfif>
		
		<cfif APPLICATION.moduleLdapUsers EQ "enabled">
			
			<cfset APPLICATION.ldapServer = "10.72.32.3">
			<cfset APPLICATION.ldapServerPort = "389">
			<cfset APPLICATION.ldapServerUserName = "admcolabora@areanorte">
			<cfset APPLICATION.ldapServerPassword = "pozoblanco2">
			<cfset APPLICATION.ldapUsersPath = "OU=Usuarios.Areanorte,DC=AREANORTE">
			<cfset APPLICATION.ldapScope = "subtree">
			<cfset APPLICATION.ldapUsersLoginAtt = "samaccountname"><!---uid---><!---Att=Attribute--->
			<cfset APPLICATION.ldapUsersPasswordAtt = "userPassword">
			<cfset APPLICATION.ldapName = "Área Norte">
		</cfif>
		
		<cfif APPLICATION.moduleTwitter IS true>
			<cfset APPLICATION.twitterConsumerKey = "3RLGsSqZ9mjtoojl0pzA">
			<cfset APPLICATION.twitterConsumerSecret = "fT792UxhEGCYAdpWI5LNRKLeeeLnPK49ieaBknXoY8">
			<cfset APPLICATION.twitterAccessToken = "538555543-dBZRANirOkaNdRq2oDNMgniufRlV0meWvYh1Nta8">
			<cfset APPLICATION.twitterAccessTokenSecret = "pnq6WGCabU1zuqDm1b5sSBqX6vhzKmBNjVszHdQyI">
		
		</cfif>
		
		<!---<cfschedule action="update"	task="exportDatabase" operation="HTTPRequest"
		url="#APPLICATION.mainUrl##APPLICATION.resourcesPath#/schedules/exportDatabase.cfm"
		startDate="#DateFormat(now(), 'm/d/yyyy')#"	startTime="#TimeFormat(now(), 'h:mm tt')#"
		interval="1000" requestTimeOut="600" publish="no"
		path="#ExpandPath('#APPLICATION.resourcesPath#/schedules/')#"
		resolveURL="yes" file="exportDatabase.html">--->

		<!---<cfxml variable="xmlApplication">
			<cfoutput>
			<application name="#this.name#" clientmanagement="#this.clientmanagement#" sessiontimeout="#this.sessiontimeout#">
			
				<dsn><![CDATA[#APPLICATION.dsn#]]></dsn>
				<email_from><![CDATA[#APPLICATION.emailFrom#]]></email_from>
				<email_reply><![CDATA[#APPLICATION.emailReply#]]></email_reply>
				<email_fail><![CDATA[#APPLICATION.emailFail#]]></email_fail>
				
				<main_url><![CDATA[#APPLICATION.mainUrl#]]></main_url>
				<sign_out_url><![CDATA[#APPLICATION.signOutUrl#]]></sign_out_url>
				
				<path><![CDATA[#APPLICATION.path#]]></path>
				<components_path><![CDATA[#APPLICATION.componentsPath#]]></components_path>
				<upload_files_path><![CDATA[#APPLICATION.uploadFilesPath#]]></upload_files_path>
				
				<default_language><![CDATA[#APPLICATION.defaultLanguage#]]></default_language>
				
			</application>
			</cfoutput>
		</cfxml>--->
		
		<!---<cffile action="write" nameconflict="overwrite" file="#ExpandPath('#APPLICATION.path#/Application.xml')#" output="#xmlApplication#" charset="utf-8" mode="775">--->
	
	</cffunction>
	
	<cffunction name="onRequestStart" output="false" returntype="void" >
		<!---<cfinvoke method="onApplicationStart">--->
		
		<cfif NOT isDefined("APPLICATION.dsn")>
			<cfinvoke method="onApplicationStart">
		</cfif>
		
	</cffunction>
	
</cfcomponent>