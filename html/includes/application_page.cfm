<cfprocessingdirective suppresswhitespace="true">

<cfif NOT isDefined("app_main_container_class")>
  <cfset app_main_container_class = "app_main_container">
</cfif>

<cfoutput>
<!DOCTYPE html>
<html lang="es">

<head>

<title>#APPLICATION.title#<cfif isDefined("SESSION.client_name")> - #SESSION.client_name#</cfif></title>

<cfinclude template="#APPLICATION.htmlPath#/includes/html_head.cfm">
</head>

<body onBeforeUnload="onUnloadPage()" onLoad="onLoadPage()" class="body_global">

<!---divLoading--->
<cfinclude template="#APPLICATION.htmlPath#/includes/loading_page_div.cfm">

<div id="wrapper"><!--- wrapper --->

	<!---<cfinclude template="#APPLICATION.htmlPath#/includes/app_head.cfm">--->

	<div id="page-content-wrapper"><!--- page-content-wrapper --->

		<div class="container #app_main_container_class#">

			<!--- PAGE CONTENT HERE --->

      <cfinclude template="#template_page#">

			<!--- END PAGE CONTENT --->

		</div>

	</div><!---END page-content-wrapper --->

</div>

</body>
</html>
</cfoutput>
</cfprocessingdirective>
