<!---Copyright Era7 Information Technologies 2007-2013

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
	
--->

<cfcomponent displayname="Application" output="false">

	<cfset this.name = 'dp_beta_aws_2'>
	
	<cfset this.clientmanagement="true">
	<cfset this.sessionmanagement="true">
	<cfset this.sessiontimeout="#createtimespan(0,5,0,0)#">
	
	<!--- Define the page request properties. --->
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
		<cfset APPLICATION.moduleLists = true>
		<cfset APPLICATION.moduleForms = true>
		<cfset APPLICATION.modulePubMedComments = true>

		<cfset APPLICATION.openTokApiKey = 29269902>
		<cfset APPLICATION.openTokApiSecret = "96298660cbdaef41dda77b9e97f41f7c749a28b4">
		
		<cfset APPLICATION.languages = "es,en">
		
		<cfset APPLICATION.errorReport = "email"><!---email/file--->
		
		<cfset APPLICATION.dateFormat = "dd-mm-yyyy">
		
		<cfset APPLICATION.version = "1.8">
		<cfset APPLICATION.clientVersion = "1.8">
		<cfset APPLICATION.clientLoginVersion = "1.4.1">
		<cfset APPLICATION.title = "DoPlanning">
		<cfset APPLICATION.identifier = "dp"><!---Por defecto aquí debe poner dp. dp para DoPlanning. vpnet para hospital--->
		
		<cfset APPLICATION.emailSendMode = "MandrillAPI"><!---SMTP/MandrillAPI--->
		<cfset APPLICATION.emailServer = "174.143.213.37">
		<cfset APPLICATION.emailServerUserName = "doplanning">
		<cfset APPLICATION.emailServerPassword = "lIFu-Rj_71Rla.Q13XzDfe">
		<cfset APPLICATION.emailFrom = "no-reply@doplanning.net">
		<cfset APPLICATION.emailFalseTo = """Undisclosed-Recipients"" <dpera7@gmail.com>"> 
		<cfset APPLICATION.emailReply = "support@doplanning.net">
		<cfset APPLICATION.emailFail = "support@doplanning.net">
		<cfset APPLICATION.emailErrors = "bugs@doplanning.net">
		
		<cfset APPLICATION.smsFrom = APPLICATION.title>
		<cfset APPLICATION.smsUserName = "epareja@era7.com">
		<cfset APPLICATION.smsPassword = "M_sop73sxr">
		<cfset APPLICATION.smsServerAddress = "http://api.mensatek.com/v4/enviar.php">
		<cfset APPLICATION.smsReportAddress = "support@era7.com">
		
		<cfset APPLICATION.path = "">
		<cfset APPLICATION.resourcesPath = APPLICATION.path&"/app">
		<cfset APPLICATION.componentsPath = APPLICATION.path&"/app/WS">
		<!---<cfset APPLICATION.webServicesPath = "/dp_pruebas/WS">--->
		<cfset APPLICATION.uploadFilesPath = APPLICATION.path&"/app/uploadFiles">
		<cfset APPLICATION.coreComponentsPath = "/dp-core/">
		<!---<cfset APPLICATION.filesPath = "/WEBpool/webroot/files/doplanning">--->
		<cfset APPLICATION.filesPath = "/webroot/files/doplanning">
		<cfset APPLICATION.defaultTimeout = 840><!---Si se pone a un tiempo menor que el de filesTimeout parece que algunas veces da problemas en la subida de archivos al acceder a otros métodos--->
		<cfset APPLICATION.filesTimeout = 840><!---14 minutes--->
		
		<cfset APPLICATION.htmlPath = APPLICATION.path&"/html">
		<cfset APPLICATION.htmlComponentsPath = APPLICATION.htmlPath&"/components">
		
		<cfset APPLICATION.jqueryJSPath = APPLICATION.path&"/jquery/js/jquery-1.7.2.min.js">
		<cfset APPLICATION.jqueryUIJSPath = APPLICATION.path&"/jquery/jquery-ui/jquery-ui-1.8.18.custom.min.js">
		<!---<cfset APPLICATION.jqueryUICSSPath = APPLICATION.path&"/jquery/jquery-ui/css/cupertino/jquery-ui-1.8.18.custom.css">--->
		<cfset APPLICATION.jqueryUICSSPath = APPLICATION.path&"/jquery/jquery-ui/css/jquery-ui-bootstrap/jquery-ui-1.8.16.custom.css">
		<cfset APPLICATION.bootstrapJSPath = "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/js/bootstrap.min.js">
		<cfset APPLICATION.bootstrapDatepickerJSPath = APPLICATION.htmlPath&"/bootstrap/bootstrap-datepicker/js/bootstrap-datepicker.js">
        <cfset APPLICATION.bootstrapDatepickerCSSPath = APPLICATION.htmlPath&"/bootstrap/bootstrap-datepicker/css/datepicker.css">

		<cfset APPLICATION.baseCSSPath = "//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/css/bootstrap.no-icons.min.css">
		<cfset APPLICATION.baseCSSIconsPath = "//netdna.bootstrapcdn.com/font-awesome/3.1.1/css/font-awesome.css">
		
		<cfset APPLICATION.mainUrl = "http://software.doplanning.net">
		<cfset APPLICATION.alternateUrl = "">
		<cfset APPLICATION.signOutUrl = "http://software.doplanning.net">
		<cfset APPLICATION.helpUrl = APPLICATION.mainUrl&"/tutorials/">
		<cfset APPLICATION.communityUrl = APPLICATION.mainUrl&"">
		<cfset APPLICATION.webUrl = APPLICATION.mainUrl&"/web/">
		
		<cfset APPLICATION.termsOfUseUrl = "/web/terms_of_use.cfm">
				
		<cfset APPLICATION.defaultLanguage = "es">
		<!---Al cambiar la aplicacion de sitio tambien hay que modificar los extends de los Application--->
		
		<cfif APPLICATION.moduleWeb EQ true><!---DPWeb enabled--->
			
			<cfset APPLICATION.dpWebClientAbb = "doplanning">
			<cfset APPLICATION.dpWebClientDsn = APPLICATION.identifier&"_"&APPLICATION.dpWebClientAbb>
			<cfset APPLICATION.dpWebClientTitle = "DoPlanning">

			<cfset APPLICATION.dpUrl = "http://software.doplanning.net">

			<cfset APPLICATION.addThisProfileId = "">

			<cfset APPLICATION.cssLayout = "#APPLICATION.path#/app/css/mockup.css">
	        <cfset APPLICATION.colorLayout = "#APPLICATION.path#/app/css/colors/palette.css">
	        <cfset APPLICATION.fontLayout = "#APPLICATION.path#/app/css/fonts/type.css">
	        <cfset APPLICATION.layout = "#APPLICATION.path#/app/layouts/pages/002.cfm">
	        <cfset APPLICATION.indexLayout = "#APPLICATION.path#/app/layouts/pages/index.cfm">

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
			<cfset APPLICATION.ldapServer = "10.72.32.3">
			<cfset APPLICATION.ldapServerPort = "389">
			<cfset APPLICATION.ldapServerUserName = "formacion@areanorte">
			<cfset APPLICATION.ldapServerPassword = "formacion">
			<cfset APPLICATION.ldapUsersPath = "OU=Usuarios.Areanorte,DC=AREANORTE">
			<cfset APPLICATION.ldapScope = "subtree">
			<cfset APPLICATION.ldapUsersLoginAtt = "samaccountname"><!---uid---><!---Att=Attribute--->
			<cfset APPLICATION.ldapUsersPasswordAtt = "userPassword">
			<cfset APPLICATION.ldapName = "Área Norte">
		</cfif>
		
		<cfif APPLICATION.moduleTwitter IS true>
			<cfset APPLICATION.twitterConsumerKey = "NnzqQl7cPIPDMWJxS0wvTQ">
			<cfset APPLICATION.twitterConsumerSecret = "WSfrXiKmqIt6eXwKoE5SBT7HvEWECXtkf6pCSihMOQ">
			<cfset APPLICATION.twitterAccessToken = "575490855-I82I7USCk2qzXAHYPqcJoQhNHTIcmJ9fZpm0D1JL">
			<cfset APPLICATION.twitterAccessTokenSecret = "ocWlHYr7K0J3NSIELSoHSih5Xk9V6swOqk442XbL3g">
		</cfif>
		<!---<cfif APPLICATION.moduleWeb EQ true>
			<cfset var paths = [expandPath("./app/WS/components/twitter4j-core-2.2.6-SNAPSHOT.jar")]>
			<cfset APPLICATION.javaloader = createObject("component", "app.WS.components.javaloader.JavaLoader").init(paths)>
			<cfset APPLICATION.Twitter = APPLICATION.javaloader.create("twitter4j.Twitter")>		
		</cfif>--->
		
		
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
		
		<cfif NOT isDefined("APPLICATION.dsn")>
			<cfinvoke method="onApplicationStart">
		</cfif>
		
	</cffunction>
	
</cfcomponent>