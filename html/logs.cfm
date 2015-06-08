<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_app_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#</title>
<!-- InstanceEndEditable -->

<cfinclude template="#APPLICATION.htmlPath#/includes/html_head.cfm">


<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
</cfoutput>
</head>

<body onBeforeUnload="onUnloadPage()" onLoad="onLoadPage()" class="body_global">
<!---divLoading--->
<cfinclude template="#APPLICATION.htmlPath#/includes/loading_page_div.cfm">
<cfif APPLICATION.identifier NEQ "dp">
	<div class="div_header">
		<a href="../html/"><div class="div_header_content"><!-- --></div></a>
		<div class="div_separador_header"><!-- --></div>
	</div>
</cfif>


 
<!---<cfoutput>
<cfif APPLICATION.title EQ "DoPlanning">
	<div style="float:left; padding-top:2px;">
		<a href="../html/index.cfm"><img src="../html/assets/logo_app.gif" alt="Inicio" title="Inicio"/></a>
	</div>
<cfelse>
	<div style="float:left;">
		<a href="../html/index.cfm" title="Inicio" class="btn"><i class="icon-home" style="font-size:16px"></i></a>
	</div>
</cfif>
<div style="float:right">
	<div style="float:right; margin-right:5px; padding-top:2px;" class="div_text_user_logged">
		<a href="../html/preferences.cfm" class="link_user_logged" title="Preferencias del usuario" lang="es">#getAuthUser()#</a>&nbsp;&nbsp;&nbsp;<a href="../html/logout.cfm" class="text_user_logged" title="Cerrar sesi?n" lang="es"><i class="icon-signout"></i> <span lang="es">Salir</span></a>
	</div>
</div>
</cfoutput>--->


<div id="wrapper"><!--- wrapper --->
        
	<!---<div class="container">
		<div class="row">
			<div class="col-lg-8 col-lg-offset-2">
				<h1></h1>
				<p></p>
							
			</div>
		</div>
	</div>--->

	<!---<div class="div_contenedor_contenido">--->
	
	
<cfinclude template="#APPLICATION.htmlPath#/includes/app_client_head.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/app_head.cfm">

<div id="page-content-wrapper"><!--- page-content-wrapper --->

	<div class="container app_main_container">
		<!-- InstanceBeginEditable name="contenido_app" -->
<cfinclude template="includes/logs_head.cfm">

<div class="div_head_subtitle">
Intentos de login fallidos
</div>

<cfset return_page = "index.cfm">

<cfinclude template="includes/logs_bar.cfm">

<cfif isDefined("search_page")>
	
	<cfif APPLICATION.moduleLdapUsers EQ true>
		<cfset get_action_id = 62>
	<cfelse>
		<cfset get_action_id = 1>
	</cfif>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Log" method="getLogs" returnvariable="xmlResponse">
		<cfinvokeargument name="date_from" value="#date_from#">
		<cfinvokeargument name="date_to" value="#date_to#">
		<cfinvokeargument name="action_id" value="#get_action_id#">
		<!---<cfinvokeargument name="page" value="#search_page#">--->
	</cfinvoke>
	
	<cfxml variable="xmlLogs">
		<cfoutput>
		#xmlResponse.response.result.logs#
		</cfoutput>
	</cfxml>
	
	<cfset page = xmlLogs.logs.xmlAttributes.page>
	<cfset pages = xmlLogs.logs.xmlAttributes.pages>
	<cfset total = xmlLogs.logs.xmlAttributes.total>
	
	<!---<cfinclude template="includes/search_result_text.cfm">
	
	<cfinclude template="includes/search_pages.cfm">--->
	
	<cfset numLogs = ArrayLen(xmlLogs.logs.XmlChildren)>
			
	<cfset page_type = 3>
	<cfif numLogs GT 0>
		
		<cfoutput>
		<div class="div_text_result">Número de intentos de login fallidos: <strong>#numLogs#</strong></div> 
		</cfoutput>
	
		<!---
		<!---<tr>
			<td>Fecha</td>
			<td>Nombre de usuario introducido</td>
		</tr>--->
		<cfoutput>
		<cfloop index="xmlIndex" from="1" to="#numLogs#" step="1">
			<tr>
				<td>#xmlLogs.logs.log[xmlIndex].xmlAttributes.time#</td>
				<td></td>
			</tr>

		</cfloop>
		</cfoutput>--->
	
	<!---<cfinclude template="includes/search_pages.cfm">--->
	
	<cfelse>
		<div class="div_text_result">No hay intentos de login registrados en esa fecha.</div>
	</cfif>

	<div style="height:30px;"><!-- --></div>
</cfif>


<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>
<!-- InstanceEndEditable -->
	</div>

</div><!---END page-content-wrapper --->


	<!---</div>--->
	
</div>
<!--- END wrapper --->

</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>