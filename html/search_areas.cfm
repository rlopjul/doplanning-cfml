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

	<!---<button type="button" class="hamburger is-closed" data-toggle="offcanvas">
		<span class="hamb-top"></span>
		<span class="hamb-middle"></span>
		<span class="hamb-bottom"></span>
	</button>--->
	
	<div class="container app_main_container">
		<!-- InstanceBeginEditable name="contenido_app" -->


<cfinclude template="#APPLICATION.htmlPath#/includes/app_page_head.cfm">

<!---<div class="div_head_title">
<cfoutput>
<div class="icon_title">
<a href="search_areas.cfm"><img src="assets/icons/search.png" alt="Búsqueda"/></a></div>
<div class="head_title" style="padding-top:8px;"><a href="search_areas.cfm">Buscar áreas</a></div>
</cfoutput>
</div>

<cfset return_page = "mobile.cfm">--->

<cfinclude template="#APPLICATION.htmlPath#/includes/search_head.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/search_menu.cfm">

<cfinclude template="includes/search_bar.cfm">

<cfif isDefined("search_text")>


	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Search" method="searchAreas" returnvariable="xmlResponse">
		<cfinvokeargument name="text" value="#search_text#">
		<cfinvokeargument name="page" value="#search_page#">
	</cfinvoke>
	
	<cfxml variable="xmlAreas">
		<cfoutput>
		#xmlResponse.response.result.areas#
		</cfoutput>
	</cfxml>
	
	<cfset page = xmlAreas.areas.xmlAttributes.page>
	<cfset pages = xmlAreas.areas.xmlAttributes.pages>
	<cfset total = xmlAreas.areas.xmlAttributes.total>
	
	<cfinclude template="includes/search_result_text.cfm">
	
	<cfinclude template="includes/search_pages.cfm">
	
	<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getParentAreaId" returnvariable="parent_area_id">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>--->
	
	<!---<cfset area_name = xmlAreas.area.xmlAttributes.name>
	<cfset area_allowed = xmlAreas.area.xmlAttributes.allowed>--->
	<cfset numAreas = ArrayLen(xmlAreas.areas.XmlChildren)>
	
	<cfif numAreas GT 0>

			<cfoutput>
			<cfloop index="xmlIndex" from="1" to="#numAreas#" step="1">
			
				<cfxml variable="xmlArea">
				#xmlAreas.areas.area[xmlIndex]#
				</cfxml>			
				
				<div class="div_area"><div class="div_img_area_area"><a href="area.cfm?area=#xmlArea.area.xmlAttributes.id#"><cfif xmlArea.area.xmlAttributes.allowed EQ true><img src="assets/icons_#APPLICATION.identifier#/area_small.png"/><cfelse><img src="assets/icons_#APPLICATION.identifier#/area_small_disabled.png"/></cfif></a></div><div class="div_text_area"><a href="area.cfm?area=#xmlArea.area.xmlAttributes.id#" class="a_area_area">#xmlArea.area.xmlAttributes.name#</a></div></div>		
			</cfloop>
			</cfoutput>
	
	<cfinclude template="includes/search_pages.cfm">
	
	<cfelse>
	<div class="div_text_result">No hay áreas con el texto buscado</div>
	</cfif>

<cfelse>

	<div class="alert" style="margin:10px;margin-top:30px;background-color:#65C5BD"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Rellene el formulario y haga click en "BUSCAR"</span></div>

</cfif>


<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>--->
<!-- InstanceEndEditable -->
	</div>

</div><!---END page-content-wrapper --->


	<!---</div>--->
	
</div>
<!--- END wrapper --->

</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>