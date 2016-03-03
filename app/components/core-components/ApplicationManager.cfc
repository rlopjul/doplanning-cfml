<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "ApplicationManager">


	<!--- -------------------------------------- setApplicationVars ----------------------------------- --->

	<cffunction name="setApplicationVars" access="public" returntype="void">
		<cfargument name="emailSendMode" type="string" required="false" default="MandrillAPI"><!---SMTP/MandrillAPI--->
		<cfargument name="emailServer" type="string" required="false" default="smtp.mandrillapp.com">
		<cfargument name="emailServerPort" type="numeric" required="false" default="587"><!---Default 587, SSL 465 (SSL da problemas con algunas versiones de JDK/JRE y Railo)--->
		<cfargument name="emailServerUserName" type="string" required="true">
		<cfargument name="emailServerPassword" type="string" required="true">
		<cfargument name="emailFrom" type="string" required="true">
		<cfargument name="emailReply" type="string" required="false" default="support@doplanninng.net">
		<cfargument name="emailFalseTo" type="string" required="false" default="""Undisclosed-Recipients"" <dpera7@gmail.com>">

		<cfargument name="openTokApiKey" type="numeric" required="false">
		<cfargument name="openTokApiSecret" type="string" required="false">

		<cfargument name="serverIp" type="string" required="true">

		<cfargument name="proxy" type="boolean" required="false" default="false">
		<cfargument name="proxyServer" type="string" required="false">
		<cfargument name="proxyPort" type="numeric" required="false">

		<cfargument name="mainUrl" type="string" required="true">
		<cfargument name="signOutUrl" type="string" required="true">
		<cfargument name="helpUrl" type="string" required="false" default="https://doplanning.net/es/page.cfm?id=118&title=soporte"><!---https://doplanning.net/es/page.cfm?id=9&amp;title=tutoriales--->
		<cfargument name="termsOfUseUrl" type="string" required="false" default="https://doplanning.net/es/terminos_de_uso.cfm">

		<cfargument name="ldapName" type="string" required="false">
		<cfargument name="ldapServer" type="string" required="false" default="">
		<cfargument name="ldapServerPort" type="string" required="false" default="">
		<cfargument name="ldapServerUserName" type="string" required="false" default="">
		<cfargument name="ldapServerPassword" type="string" required="false" default="">
		<cfargument name="ldapUsersPath" type="string" required="false" default="">
		<cfargument name="ldapScope" type="string" required="false" default="">
		<cfargument name="ldapUsersLoginAtt" type="string" required="false" default="">
		<cfargument name="ldapUsersPasswordAtt" type="string" required="false" default="">

		<cfargument name="title" type="string" required="false" default="DoPlanning">
		<cfargument name="titlePrefix" type="string" required="false" default="application"><!--- application/web --->
		<cfargument name="moduleMessenger" type="boolean" required="false" default="false">
		<cfargument name="moduleLdapUsers" type="boolean" required="false" default="false">
		<cfargument name="moduleConvertFiles" type="boolean" required="false" default="false">
		<cfargument name="moduleWeb" type="boolean" required="false" default="false">
		<cfargument name="moduleTwitter" type="boolean" required="false" default="false">
		<cfargument name="moduleConsultations" type="boolean" required="false" default="true">
		<cfargument name="includeConsultationsInAlerts" type="boolean" required="false" default="true">
		<cfargument name="moduleVirtualMeetings" type="boolean" required="false" default="false">
		<cfargument name="moduleWebRTC" type="boolean" required="false" default="false">
		<cfargument name="showDniTitle" type="boolean" required="false" default="false">
		<cfargument name="twoUrlsToAccess" type="boolean" required="false" default="false">
		<cfargument name="modulefilesWithTables" type="boolean" required="false" default="true">
		<cfargument name="filesTablesInheritance" type="boolean" required="false" default="true">
		<cfargument name="moduleLists" type="boolean" required="false" default="true">
		<cfargument name="moduleForms" type="boolean" required="false" default="true">
		<cfargument name="modulePubMedComments" type="boolean" required="false" default="true">
		<cfargument name="moduleListsWithPermissions" type="boolean" required="false" default="false">
		<cfargument name="moduleAreaFilesLite" type="boolean" required="false" default="true">
		<cfargument name="changeElementsArea" type="boolean" required="false" default="true">
		<cfargument name="publicationScope" type="boolean" required="false" default="true">
		<cfargument name="publicationValidation" type="boolean" required="false" default="false">
		<cfargument name="publicationRestricted" type="boolean" required="false" default="false">
		<cfargument name="userEmailRequired" type="boolean" required="false" default="true">
		<cfargument name="moduleLdapDiraya" type="boolean" required="false" default="false">
		<cfargument name="moduleAntiVirus" type="boolean" required="false" default="false">
		<cfargument name="cacheTree" type="boolean" required="false" default="true">
		<cfargument name="changeUserPreferencesByAdmin" type="boolean" required="false" default="false">

		<cfargument name="homeTab" type="boolean" required="false" default="true">
		<cfargument name="moduleDPDocuments" type="boolean" required="false" default="true">
		<cfargument name="moduleMailing" type="boolean" required="false" default="true">
		<cfargument name="includeLegalTextInAlerts" type="boolean" required="false" default="false">
		<cfargument name="webFriendlyUrls" type="boolean" required="false" default="false">

		<cfargument name="hideInputLabels" type="boolean" required="false" default="false">

		<cfargument name="addSchedules" type="boolean" required="false" default="false">
		<cfargument name="schedulesExcludeClients" type="string" required="false" default="">
		<cfargument name="schedulesOnlyClient" type="string" required="false" default="">

		<cfargument name="defaultLanguage" type="string" required="false" default="es">

		<cfargument name="twitterConsumerKey" type="string" required="false">
		<cfargument name="twitterConsumerSecret" type="string" required="false">
		<cfargument name="twitterAccessToken" type="string" required="false">
		<cfargument name="twitterAccessTokenSecret" type="string" required="false">

		<cfargument name="baseCSSPath" type="string" required="false" default="//maxcdn.bootstrapcdn.com/bootswatch/3.3.6/paper/bootstrap.min.css">

		<cfargument name="dpCSSPath" type="string" required="false" default="/html/styles/styles.min.css?v=3.3">
		<cfargument name="themeCSSPath" type="string" required="false" default="">

		<cfargument name="intranetLayout" type="string" required="false" default="/app/layouts/pages/layout_intranet.cfm">
		<cfargument name="indexIntranetLayout" type="string" required="false" default="/app/layouts/pages/layout_index_intranet.cfm">
		<cfargument name="colorIntranetLayout" type="string" required="false" default="/app/css/colors/palette.css">
		<cfargument name="fontIntranetLayout" type="string" required="false" default="/app/css/fonts/type.css">

		<cfargument name="logoWebNotifications" type="string" required="true" default="/html/assets/v3/logo_doplanning.png">


			<cfset APPLICATION.dsn = "doplanning_app">
			<cfset APPLICATION.dataBaseName = "doplanning_app">

			<cfset APPLICATION.moduleMessenger = arguments.moduleMessenger><!---true/false--->
			<cfset APPLICATION.moduleLdapUsers = arguments.moduleLdapUsers>
			<cfset APPLICATION.moduleConvertFiles = arguments.moduleConvertFiles>
			<cfset APPLICATION.moduleWeb = arguments.moduleWeb>
			<cfset APPLICATION.moduleTwitter = arguments.moduleTwitter>
			<cfset APPLICATION.moduleConsultations = arguments.moduleConsultations>
			<cfset APPLICATION.includeConsultationsInAlerts = arguments.includeConsultationsInAlerts>
			<cfset APPLICATION.moduleVirtualMeetings = arguments.moduleVirtualMeetings>
			<cfset APPLICATION.moduleWebRTC = arguments.moduleWebRTC>
			<cfset APPLICATION.showDniTitle = arguments.showDniTitle>
			<cfset APPLICATION.twoUrlsToAccess = arguments.twoUrlsToAccess>
			<cfset APPLICATION.modulefilesWithTables = arguments.modulefilesWithTables>
			<cfset APPLICATION.filesTablesInheritance = arguments.filesTablesInheritance>
			<cfset APPLICATION.moduleLists = arguments.moduleLists>
			<cfset APPLICATION.moduleForms = arguments.moduleForms>
			<cfset APPLICATION.modulePubMedComments = arguments.modulePubMedComments>
			<cfset APPLICATION.moduleListsWithPermissions = arguments.moduleListsWithPermissions>
			<cfset APPLICATION.moduleAreaFilesLite = arguments.moduleAreaFilesLite>
			<cfset APPLICATION.changeElementsArea = arguments.changeElementsArea>
			<cfset APPLICATION.publicationScope = arguments.publicationScope>
			<cfset APPLICATION.publicationValidation = arguments.publicationValidation>
			<cfset APPLICATION.publicationRestricted = arguments.publicationRestricted>
			<cfset APPLICATION.userEmailRequired = arguments.userEmailRequired>
			<cfset APPLICATION.moduleLdapDiraya = arguments.moduleLdapDiraya><!--- asnc, agsna --->
			<cfset APPLICATION.moduleAntiVirus = arguments.moduleAntiVirus>
			<cfset APPLICATION.cacheTree = arguments.cacheTree>
			<cfset APPLICATION.changeUserPreferencesByAdmin = arguments.changeUserPreferencesByAdmin>
			<cfset APPLICATION.homeTab = arguments.homeTab>
			<cfset APPLICATION.moduleMailing = arguments.moduleMailing>
			<cfset APPLICATION.includeLegalTextInAlerts = arguments.includeLegalTextInAlerts>
			<cfset APPLICATION.webFriendlyUrls = arguments.webFriendlyUrls>

			<cfset APPLICATION.moduleDPDocuments = arguments.moduleDPDocuments>

			<cfif arguments.moduleWebRTC IS true>

				<cfif isDefined("arguments.openTokApiKey") AND isDefined("arguments.openTokApiSecret")>
					<cfset APPLICATION.openTokApiKey = arguments.openTokApiKey>
					<cfset APPLICATION.openTokApiSecret = arguments.openTokApiSecret>
				<cfelse>
					<cfthrow message="Las variables openTokApiKey y openTokApiSecret deben estar definidas">
				</cfif>

			</cfif>

			<cfset APPLICATION.title = arguments.title><!--- Default: DoPlanning --->
			<cfset APPLICATION.titlePrefix = arguments.titlePrefix>
			<cfset APPLICATION.identifier = "dp"><!---Por defecto aquí debe poner dp. dp para DoPlanning. vpnet para hospital--->

			<cfset APPLICATION.version = "1.8">
			<cfset APPLICATION.clientVersion = "1.8">
			<cfset APPLICATION.clientLoginVersion = "1.4.1">

			<cfset APPLICATION.languages = "es,en">

			<cfset APPLICATION.dateFormat = "dd-mm-yyyy">
			<cfset APPLICATION.dbDateFormat = "%d-%m-%Y">
			<cfset APPLICATION.dbDateTimeFormat = "%d-%m-%Y %H:%i:%s">
			<cfset APPLICATION.dbTimeZoneTo = "Europe/Madrid">

			<cfset APPLICATION.serverIp = arguments.serverIp>

			<cfset APPLICATION.errorReport = "email"><!---email/file--->

			<cfset APPLICATION.emailSendMode = arguments.emailSendMode>
			<cfset APPLICATION.emailServer = arguments.emailServer>
			<cfset APPLICATION.emailServerPort = arguments.emailServerPort>
			<cfset APPLICATION.emailServerUserName = arguments.emailServerUserName>
			<cfset APPLICATION.emailServerPassword = arguments.emailServerPassword>
			<cfset APPLICATION.emailFrom = arguments.emailFrom>

			<cfset APPLICATION.emailFalseTo = arguments.emailFalseTo>
			<cfset APPLICATION.emailReply = arguments.emailReply>
			<cfset APPLICATION.emailFail = "support@doplanning.net">
			<cfset APPLICATION.emailErrors = "bugs@doplanning.net">

			<cfset APPLICATION.proxy = arguments.proxy>
			<cfif APPLICATION.proxy IS true>
				<cfset APPLICATION.proxyServer = arguments.proxyServer>
				<cfset APPLICATION.proxyPort = arguments.proxyPort>
			</cfif>

			<cfset APPLICATION.smsFrom = APPLICATION.title>
			<cfset APPLICATION.smsUserName = "">
			<cfset APPLICATION.smsPassword = "">
			<cfset APPLICATION.smsServerAddress = "http://api.mensatek.com/v4/enviar.php">
			<cfset APPLICATION.smsReportAddress = "support@era7.com">

			<cfset APPLICATION.path = "">
			<cfset APPLICATION.resourcesPath = APPLICATION.path&"/app">
			<cfset APPLICATION.uploadFilesPath = APPLICATION.path&"/app/uploadFiles">
			<cfset APPLICATION.corePath = "/dp-core">
			<cfset APPLICATION.componentsPath = APPLICATION.corePath&"/components">
			<cfset APPLICATION.coreComponentsPath = APPLICATION.componentsPath&"/core-components">
			<cfset APPLICATION.filesPath = "/webroot/files/doplanning">
			<cfset APPLICATION.defaultTimeout = 840><!---Si se pone a un tiempo menor que el de filesTimeout parece que algunas veces da problemas en la subida de archivos al acceder a otros métodos--->
			<cfset APPLICATION.filesTimeout = 840><!---14 minutes--->

			<cfset APPLICATION.htmlPath = APPLICATION.path&"/html">
			<cfset APPLICATION.htmlComponentsPath = APPLICATION.htmlPath&"/components">

			<cfset APPLICATION.jqueryJSPath = "//ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js">
			<cfset APPLICATION.bootstrapJSPath = "//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js">
			<cfset APPLICATION.bootstrapDatepickerJSPath = APPLICATION.htmlPath&"/bootstrap/bootstrap-datepicker/js/bootstrap-datepicker.js">
	    <cfset APPLICATION.bootstrapDatepickerCSSPath = APPLICATION.htmlPath&"/bootstrap/bootstrap-datepicker/css/datepicker.css">
	    <cfset APPLICATION.functionsJSPath = APPLICATION.htmlPath&"/scripts/functions.min.js?v=3.3">

	    <cfset APPLICATION.ckeditorJSPath = "#APPLICATION.htmlPath#/ckeditor/ckeditor.js?v=4.4.4.4">

			<cfset APPLICATION.hideInputLabels = arguments.hideInputLabels>
			<cfset APPLICATION.baseCSSPath = arguments.baseCSSPath>
			<cfset APPLICATION.baseCSSIconsPath = "//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css">

			<cfset APPLICATION.themeCSSPath = arguments.themeCSSPath>

			<cfset APPLICATION.dpCSSPath = arguments.dpCSSPath>

			<cfset APPLICATION.mainUrl = arguments.mainUrl>
			<cfset APPLICATION.alternateUrl = "">
			<cfset APPLICATION.signOutUrl = arguments.signOutUrl>
			<cfset APPLICATION.helpUrl = arguments.helpUrl>
			<cfset APPLICATION.communityUrl = "https://doplanning.net/">
			<cfset APPLICATION.webUrl = ""><!--- http://doplanning.net/ ---><!--- Esta variable NO se debe usar en DoPlanning (se usa en DPWeb), se mantiene para retrocompatibilidad --->

			<!---<cfset APPLICATION.termsOfUseUrl = APPLICATION.mainUrl&"/web/terms_of_use.cfm">--->
			<cfset APPLICATION.termsOfUseUrl = arguments.termsOfUseUrl>

			<cfset APPLICATION.defaultLanguage = arguments.defaultLanguage>

			<cfset APPLICATION.logoWebNotifications = arguments.logoWebNotifications>

			<!--- Intranet --->
			<cfset APPLICATION.webCSSPath = arguments.baseCSSPath>
			<cfset APPLICATION.cssLayout = "#APPLICATION.path#/app/css/mockup.css">

			<cfset APPLICATION.intranetLayout = arguments.intranetLayout>
			<cfset APPLICATION.indexIntranetLayout = arguments.indexIntranetLayout>
			<cfset APPLICATION.colorIntranetLayout = arguments.colorIntranetLayout>
			<cfset APPLICATION.fontIntranetLayout = arguments.fontIntranetLayout>

			<cfset APPLICATION.includeTableSorter = true>

			<cfset APPLICATION.dpWebEnableTwitterWidgets = false>
			<cfset APPLICATION.dpWebEnableGeneratePdf = false>
			<!--- END Intranet --->

			<!---Google analytics--->
			<cfset APPLICATION.googleAnalyticsAccountId = "">

			<cfif arguments.addSchedules IS true>

				<cfset APPLICATION.schedulesExcludeClients = arguments.schedulesExcludeClients>
				<cfset APPLICATION.schedulesOnlyClient = arguments.schedulesOnlyClient>

				<!---sendAllDiaryAlerts schedule--->
				<cfschedule action="update"	task="sendAllDiaryAlerts" operation="HTTPRequest"
					url="#APPLICATION.mainUrl##APPLICATION.resourcesPath#/schedules/sendAllDiaryAlerts.cfm"
					startDate="#createDate( year(now()),month(now()),day(now()) )#" startTime="#createTime(0,5,0)#"
					interval="daily" requestTimeOut="300" resolveURL="no" publish="true" file="#expandPath('#APPLICATION.resourcesPath#/schedules/sendAllDiaryAlerts.txt')#">

				<!---sendDiaryAlerts schedule--->
				<cfschedule action="update"	task="sendDiaryAlerts" operation="HTTPRequest"
					url="#APPLICATION.mainUrl##APPLICATION.resourcesPath#/schedules/sendDiaryAlerts.cfm"
					startDate="#createDate( year(now()),month(now()),day(now()) )#" startTime="#createTime(1,5,0)#"
					interval="daily" requestTimeOut="60" resolveURL="no" publish="true" file="#expandPath('#APPLICATION.resourcesPath#/schedules/sendDiaryAlerts.txt')#">

				<!---deleteBinItems schedule--->
				<cfschedule action="update"	task="deleteBinItems" operation="HTTPRequest"
					url="#APPLICATION.mainUrl##APPLICATION.resourcesPath#/schedules/deleteBinItems.cfm"
					startDate="#createDate( year(now()),month(now()),day(now()) )#" startTime="#createTime(1,35,0)#"
					interval="daily" requestTimeOut="60" resolveURL="no" publish="true" file="#expandPath('#APPLICATION.resourcesPath#/schedules/deleteBinItems.txt')#">


			</cfif>

			<cfif APPLICATION.moduleMessenger EQ true>
				<cfset APPLICATION.messengerUserExpireTime = 60><!---In seconds--->

				<cfif arguments.addSchedules IS true>

					<cfschedule action="update"	task="checkIfUsersAreConnected"	operation="HTTPRequest"
						url="#APPLICATION.mainUrl##APPLICATION.resourcesPath#/schedules/checkIfUsersAreConnected.cfm"
						startDate="#DateFormat(now(), 'm/d/yyyy')#"	startTime="#TimeFormat(now(), 'h:mm tt')#"
						interval="#APPLICATION.messengerUserExpireTime#" requestTimeOut="30" publish="no"
						path="#ExpandPath('#APPLICATION.resourcesPath#/schedules/')#"
						resolveURL="yes" file="checkIfUsersAreConnectedResult.html">

				</cfif>
			</cfif>

			<cfif APPLICATION.moduleLdapUsers EQ true>
				<cfset APPLICATION.ldapName = arguments.ldapName>
				<cfset APPLICATION.ldapServer = arguments.ldapServer>
				<cfset APPLICATION.ldapServerPort = arguments.ldapServerPort>
				<cfset APPLICATION.ldapServerUserName = arguments.ldapServerUserName>
				<cfset APPLICATION.ldapServerPassword = arguments.ldapServerPassword>
				<cfset APPLICATION.ldapUsersPath = arguments.ldapUsersPath>
				<cfset APPLICATION.ldapScope = arguments.ldapScope>
				<cfset APPLICATION.ldapUsersLoginAtt = arguments.ldapUsersLoginAtt><!---Att=Attribute--->
				<cfset APPLICATION.ldapUsersPasswordAtt = arguments.ldapUsersPasswordAtt>
			</cfif>

			<cfif APPLICATION.moduleTwitter IS true>
				<cfset APPLICATION.twitterConsumerKey = arguments.twitterConsumerKey>
				<cfset APPLICATION.twitterConsumerSecret = arguments.twitterConsumerSecret>
				<cfset APPLICATION.twitterAccessToken = arguments.twitterAccessToken>
				<cfset APPLICATION.twitterAccessTokenSecret = arguments.twitterAccessTokenSecret>
			</cfif>
			<!---<cfif APPLICATION.moduleWeb EQ true>
				<cfset var paths = [expandPath("./app/WS/components/twitter4j-core-2.2.6-SNAPSHOT.jar")]>
				<cfset APPLICATION.javaloader = createObject("component", "app.WS.components.javaloader.JavaLoader").init(paths)>
				<cfset APPLICATION.Twitter = APPLICATION.javaloader.create("twitter4j.Twitter")>
			</cfif>--->

	</cffunction>


	<!--- -------------------------------------- setApplicationVars ----------------------------------- --->

	<cffunction name="setApplicationVarsDefault" access="public" returntype="void">
		<cfargument name="defaultSet" type="string" required="true" default="doplanning.net">

		<cfargument name="emailServerUserName" type="string" required="true">
		<cfargument name="emailServerPassword" type="string" required="true">
		<cfargument name="emailFrom" type="string" required="false">

		<cfargument name="openTokApiKey" type="numeric" required="false">
		<cfargument name="openTokApiSecret" type="string" required="false">

		<cfargument name="addSchedules" type="boolean" required="false" default="false">

		<cfswitch expression="#arguments.defaultSet#">

			<cfcase value="doplanning.net">

				<cfinvoke component="/dp-core/components/core-components/ApplicationManager" method="setApplicationVars">
					<cfinvokeargument name="emailServerUserName" value="#arguments.emailServerUserName#">
					<cfinvokeargument name="emailServerPassword" value="#arguments.emailServerPassword#">
					<cfif isDefined("arguments.emailFrom")>
						<cfinvokeargument name="emailFrom" value="#arguments.emailFrom#">
					<cfelse>
						<cfinvokeargument name="emailFrom" value="no-reply@doplanning.net">
					</cfif>

					<cfinvokeargument name="openTokApiKey" value="#arguments.openTokApiKey#">
					<cfinvokeargument name="openTokApiSecret" value="#arguments.openTokApiSecret#">

					<cfinvokeargument name="serverIp" value="54.217.233.240">

					<cfinvokeargument name="mainUrl" value="https://doplanning.net">
					<cfinvokeargument name="signOutUrl" value="https://doplanning.net">

					<cfinvokeargument name="moduleWeb" value="true">

					<cfinvokeargument name="homeTab" value="true">
					<cfinvokeargument name="moduleDPDocuments" value="true">
					<cfinvokeargument name="moduleMailing" value="false">

					<cfinvokeargument name="addSchedules" value="#arguments.addSchedules#">
				</cfinvoke>

			</cfcase>


			<cfcase value="hcs.es">

				<cfinvoke component="/dp-core/components/core-components/ApplicationManager" method="setApplicationVars">

					<cfinvokeargument name="emailServerUserName" value="#arguments.emailServerUserName#">
					<cfinvokeargument name="emailServerPassword" value="#arguments.emailServerPassword#">
					<cfif isDefined("arguments.emailFrom")>
						<cfinvokeargument name="emailFrom" value="#arguments.emailFrom#">
					<cfelse>
						<cfinvokeargument name="emailFrom" value="doplanning-no-reply@hcs.es">
					</cfif>

					<cfinvokeargument name="openTokApiKey" value="#arguments.openTokApiKey#">
					<cfinvokeargument name="openTokApiSecret" value="#arguments.openTokApiSecret#">

					<cfinvokeargument name="serverIp" value="54.228.233.178">

					<cfinvokeargument name="mainUrl" value="https://hcs.es">
					<cfinvokeargument name="signOutUrl" value="https://hcs.es">

					<cfinvokeargument name="ldapName" value="Portal del Empleado">

					<cfinvokeargument name="moduleLdapUsers" value="true">
					<cfinvokeargument name="moduleWeb" value="true">
					<cfinvokeargument name="moduleWebRTC" value="true">
					<cfinvokeargument name="showDniTitle" value="true">
					<cfinvokeargument name="modulePubMedComments" value="true">
					<cfinvokeargument name="moduleListsWithPermissions" value="true">
					<cfinvokeargument name="changeElementsArea" value="true">
					<cfinvokeargument name="publicationScope" value="true">
					<cfinvokeargument name="publicationValidation" value="true">
					<cfinvokeargument name="userEmailRequired" value="false">
					<cfinvokeargument name="moduleAntiVirus" value="true">

					<cfinvokeargument name="homeTab" value="true">
					<cfinvokeargument name="moduleDPDocuments" value="true">

					<cfinvokeargument name="addSchedules" value="#arguments.addSchedules#">

					<cfinvokeargument name="hideInputLabels" value="true">
				</cfinvoke>

			</cfcase>


			<cfcase value="era7bioinformatics.com">

				<cfinvoke component="/dp-core/components/core-components/ApplicationManager" method="setApplicationVars">
					<cfinvokeargument name="emailServerUserName" value="#arguments.emailServerUserName#">
					<cfinvokeargument name="emailServerPassword" value="#arguments.emailServerPassword#">
					<cfif isDefined("arguments.emailFrom")>
						<cfinvokeargument name="emailFrom" value="#arguments.emailFrom#">
					<cfelse>
						<cfinvokeargument name="emailFrom" value="doplanning@era7bioinformatics.com">
					</cfif>

					<cfinvokeargument name="openTokApiKey" value="#arguments.openTokApiKey#">
					<cfinvokeargument name="openTokApiSecret" value="#arguments.openTokApiSecret#">

					<cfinvokeargument name="serverIp" value="23.23.250.237">

					<cfinvokeargument name="mainUrl" value="https://era7bioinformatics.com">
					<cfinvokeargument name="signOutUrl" value="https://era7bioinformatics.com/bioinformatics7">

					<!---<cfinvokeargument name="title" value="Era7">--->
					<cfinvokeargument name="moduleWeb" value="true">
					<cfinvokeargument name="moduleWebRTC" value="true">

					<cfinvokeargument name="homeTab" value="true">
					<cfinvokeargument name="moduleDPDocuments" value="true">

					<cfinvokeargument name="addSchedules" value="#arguments.addSchedules#">

					<cfinvokeargument name="hideInputLabels" value="true">

					<cfinvokeargument name="logoWebNotifications" value="/assets/logo-era7-bioinformatics.png">
				</cfinvoke>

			</cfcase>


			<cfcase value="genome7.com">

				<cfinvoke component="/dp-core/components/core-components/ApplicationManager" method="setApplicationVars">
					<cfinvokeargument name="emailServerUserName" value="#arguments.emailServerUserName#">
					<cfinvokeargument name="emailServerPassword" value="#arguments.emailServerPassword#">
					<cfif isDefined("arguments.emailFrom")>
						<cfinvokeargument name="emailFrom" value="#arguments.emailFrom#">
					<cfelse>
						<cfinvokeargument name="emailFrom" value="no-reply@genome7.com">
					</cfif>

					<cfinvokeargument name="openTokApiKey" value="#arguments.openTokApiKey#">
					<cfinvokeargument name="openTokApiSecret" value="#arguments.openTokApiSecret#">

					<cfinvokeargument name="serverIp" value="54.77.243.167">

					<cfinvokeargument name="mainUrl" value="https://genome7.com">
					<cfinvokeargument name="signOutUrl" value="https://genome7.com/genome7">

					<cfinvokeargument name="title" value="Genome7">
					<cfinvokeargument name="moduleWeb" value="true">

					<cfinvokeargument name="addSchedules" value="#arguments.addSchedules#">
				</cfinvoke>

			</cfcase>


			<cfcase value="hla.era7software.com">

				<cfinvoke component="/dp-core/components/core-components/ApplicationManager" method="setApplicationVars">
					<cfinvokeargument name="emailServerUserName" value="#arguments.emailServerUserName#">
					<cfinvokeargument name="emailServerPassword" value="#arguments.emailServerPassword#">
					<cfif isDefined("arguments.emailFrom")>
						<cfinvokeargument name="emailFrom" value="#arguments.emailFrom#">
					<cfelse>
						<cfinvokeargument name="emailFrom" value="no-reply@doplanning.net">
					</cfif>

					<cfinvokeargument name="openTokApiKey" value="#arguments.openTokApiKey#">
					<cfinvokeargument name="openTokApiSecret" value="#arguments.openTokApiSecret#">

					<cfinvokeargument name="serverIp" value="52.18.214.172">

					<cfinvokeargument name="mainUrl" value="http://hla.era7software.com">
					<cfinvokeargument name="signOutUrl" value="http://hla.era7software.com">

					<cfinvokeargument name="moduleWeb" value="false">

					<cfinvokeargument name="homeTab" value="true">
					<cfinvokeargument name="moduleDPDocuments" value="true">
					<cfinvokeargument name="moduleMailing" value="false">

					<cfinvokeargument name="addSchedules" value="#arguments.addSchedules#">
				</cfinvoke>

			</cfcase>

			<cfcase value="ceseand.net">

				<cfinvoke component="/dp-core/components/core-components/ApplicationManager" method="setApplicationVars">
					<cfinvokeargument name="emailServerUserName" value="#arguments.emailServerUserName#">
					<cfinvokeargument name="emailServerPassword" value="#arguments.emailServerPassword#">
					<cfif isDefined("arguments.emailFrom")>
						<cfinvokeargument name="emailFrom" value="#arguments.emailFrom#">
					<cfelse>
						<cfinvokeargument name="emailFrom" value="info@ceseand.net">
					</cfif>
					<cfinvokeargument name="emailReply" value="info@ceseand.net">

					<cfinvokeargument name="openTokApiKey" value="#arguments.openTokApiKey#">
					<cfinvokeargument name="openTokApiSecret" value="#arguments.openTokApiSecret#">

					<cfinvokeargument name="serverIp" value="54.72.1.86">

					<cfinvokeargument name="mainUrl" value="https://ceseand.net">
					<cfinvokeargument name="signOutUrl" value="https://ceseand.net">

					<cfinvokeargument name="title" value="CESEAND">
					<cfinvokeargument name="titlePrefix" value="web">
					<cfinvokeargument name="moduleWeb" value="true">

					<cfinvokeargument name="homeTab" value="true">
					<cfinvokeargument name="moduleDPDocuments" value="true">
					<cfinvokeargument name="moduleMailing" value="true">
					<cfinvokeargument name="includeLegalTextInAlerts" value="true">

					<cfinvokeargument name="addSchedules" value="#arguments.addSchedules#">

					<cfinvokeargument name="helpUrl" value="https://ceseand.net/es/page.cfm?id=76&title=manuales-de-la-web">
					<cfinvokeargument name="termsOfUseUrl" value="https://ceseand.net/es/page.cfm?id=57&title=terminos-de-uso">

					<cfinvokeargument name="logoWebNotifications" value="/assets/logo-ceseand-emails.jpg">
					<cfinvokeargument name="changeUserPreferencesByAdmin" value="true">

				</cfinvoke>

			</cfcase>

		</cfswitch>

		<cfif NOT isDefined("APPLICATION.dsn")>

			<cfthrow message="defaultSet NO definido">

		</cfif>

	</cffunction>



	<!--- -------------------------------------- setApplicationVarsDPWeb ----------------------------------- --->

	<cffunction name="setApplicationVarsDPWeb" access="public" returntype="void">
		<cfargument name="dpWebClientAbb" type="string" required="true">
		<cfargument name="dpWebClientTitle" type="string" required="true">
		<cfargument name="intranetAutoLoginIps" type="string" required="false">

		<cfargument name="webUrl" type="string" required="true">
		<cfargument name="dpUrl" type="string" required="false">

		<cfargument name="webDirectories" type="string" required="false"><!---Esta variable será obligatoria, se mantiene opcional temporalmente para retrocompatibiilidad--->

		<!---Estas variables deben dejar se usarse y sustituirse por APPLICATION.webs, se mantienen para retrocompatibilidad--->
		<cfargument name="rootAreaEs" type="string" required="false">
		<cfargument name="rootAreaEn" type="string" required="false">
		<cfargument name="rootAreaIntranet" type="string" required="false">
		<cfargument name="rootAreaNews" type="string" required="false">
		<cfargument name="rootAreaIntranetNews" type="string" required="false">
		<!--- --->

		<cfargument name="logoClient" type="string" required="true">

		<cfargument name="jsLayout" type="string" required="false"><!---Esta variable NO se debe usar, se mantiene sólo para retrocompatibilidad---->

		<cfargument name="webCSSPath" type="string" required="true">
		<cfargument name="cssLayout" type="string" required="false" default="#APPLICATION.path#/app/css/mockup.css">

		<cfargument name="layout" type="string" required="false" default="#APPLICATION.path#/app/layouts/pages/layout.cfm">
		<cfargument name="indexLayout" type="string" required="false" default="#APPLICATION.path#/app/layouts/pages/layout_index.cfm">
		<cfargument name="colorLayout" type="string" required="false" default="#APPLICATION.path#/app/css/colors/palette.css">
		<cfargument name="fontLayout" type="string" required="false" default="#APPLICATION.path#/app/css/fonts/type.css">

		<cfargument name="intranetLayout" type="string" required="false" default="#APPLICATION.path#/app/layouts/pages/layout_intranet.cfm">
		<cfargument name="indexIntranetLayout" type="string" required="false" default="#APPLICATION.path#/app/layouts/pages/layout_index_intranet.cfm">
		<cfargument name="colorIntranetLayout" type="string" required="false" default="#APPLICATION.path#/app/css/colors/palette.css">
		<cfargument name="fontIntranetLayout" type="string" required="false" default="#APPLICATION.path#/app/css/fonts/type.css">

		<cfargument name="googleAnalyticsAccountId" type="string" required="true">
		<cfargument name="addThisProfileId" type="string" required="true">
		<cfargument name="googleSearchCode" type="string" required="false">

		<cfargument name="includeTableSorter" type="boolean" required="false" default="false">

		<cfargument name="dpWebEnableTwitterWidgets" type="boolean" required="false" default="false"><!---Carga el script de widgets de Twitter--->
		<cfargument name="dpWebEnableGeneratePdf" type="boolean" required="false" default="true">

			<cfset APPLICATION.dpWebClientAbb = arguments.dpWebClientAbb>
			<cfset APPLICATION.dpWebClientDsn = APPLICATION.identifier&"_"&APPLICATION.dpWebClientAbb>
			<cfset APPLICATION.dpWebClientTitle = arguments.dpWebClientTitle>

			<cfif isDefined("arguments.webDirectories")>

				<cfset APPLICATION.webDirectories = arguments.webDirectories>

				<cfset APPLICATION.webs = structNew()>

				<cfloop list="#APPLICATION.webDirectories#" index="webPath">

					<cfinvoke component="#APPLICATION.coreComponentsPath#/WebQuery" method="getWeb" returnvariable="getWebQuery">
						<cfinvokeargument name="path" value="#webPath#">

						<cfinvokeargument name="client_abb" value="#APPLICATION.dpWebClientAbb#">
						<cfinvokeargument name="client_dsn" value="#APPLICATION.dpWebClientDsn#">
					</cfinvoke>

					<cfif getWebQuery.recordCount GT 0>

						<cfset web = structNew()>
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

						<cfset APPLICATION.webs[webPath] = web>

					<cfelse>
						<cfthrow message="Web con directorio '#webPath#' no definido en tabla #APPLICATION.dpWebClientAbb#_webs">
					</cfif>

				</cfloop>

			</cfif>

			<cfset APPLICATION.webUrl = arguments.webUrl><!--- URL de la web en DPWeb --->

			<cfif isDefined("arguments.dpUrl")><!---Esta variable NO se debe usar, se mantiene para retrocompatibilidad--->
				<cfset APPLICATION.dpUrl = arguments.dpUrl>
			</cfif>

			<cfif isDefined("arguments.intranetAutoLoginIps")>
				<cfset APPLICATION.intranetAutoLoginIps = arguments.intranetAutoLoginIps>
			</cfif>

			<cfif isDefined("arguments.rootAreaEs")>
				<cfset APPLICATION.rootAreaEs = arguments.rootAreaEs>
			</cfif>
			<cfif isDefined("arguments.rootAreaEn")>
				<cfset APPLICATION.rootAreaEn = arguments.rootAreaEn>
			</cfif>
			<cfif isDefined("arguments.rootAreaIntranet")>
				<cfset APPLICATION.rootAreaIntranet = arguments.rootAreaIntranet>
			</cfif>
			<cfif isDefined("arguments.rootAreaNews")>
				<cfset APPLICATION.rootAreaNews = arguments.rootAreaNews>
			</cfif>
			<cfif isDefined("arguments.rootAreaIntranetNews")>
				<cfset APPLICATION.rootAreaIntranetNews = arguments.rootAreaIntranetNews>
			</cfif>

			<cfset APPLICATION.logoClient = arguments.logoClient>

			<cfset APPLICATION.webCSSPath = arguments.webCSSPath>

			<cfset APPLICATION.cssLayout = arguments.cssLayout>
      <cfset APPLICATION.colorLayout = arguments.colorLayout>
      <cfset APPLICATION.fontLayout = arguments.fontLayout>
      <cfset APPLICATION.layout = arguments.layout>
      <cfset APPLICATION.indexLayout = arguments.indexLayout>

      <cfif isDefined("arguments.jsLayout")><!---Esta variable NO se debe usar, se mantiene para retrocompatibilidad---->
      	<cfset APPLICATION.jsLayout = arguments.jsLayout>
      </cfif>

			<cfif ListFind(arguments.webDirectories, "intranet") GT 0>
				<cfset APPLICATION.intranetLayout = arguments.intranetLayout>
				<cfset APPLICATION.indexIntranetLayout = arguments.indexIntranetLayout>
				<cfset APPLICATION.colorIntranetLayout = arguments.colorIntranetLayout>
				<cfset APPLICATION.fontIntranetLayout = arguments.fontIntranetLayout>
			</cfif>

			<cfset APPLICATION.includeTableSorter = arguments.includeTableSorter>

			<cfset APPLICATION.dpWebEnableTwitterWidgets = arguments.dpWebEnableTwitterWidgets>
			<cfset APPLICATION.dpWebEnableGeneratePdf = arguments.dpWebEnableGeneratePdf>

			<!---Google analytics--->
			<cfset APPLICATION.googleAnalyticsAccountId = arguments.googleAnalyticsAccountId>
			<cfset APPLICATION.addThisProfileId = arguments.addThisProfileId>

			<cfif isDefined("arguments.googleSearchCode")>
				<cfset APPLICATION.googleSearchCode = arguments.googleSearchCode>
			</cfif>

	</cffunction>


</cfcomponent>
