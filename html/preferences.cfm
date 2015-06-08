<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_app_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#-Preferencias</title>
<!-- InstanceEndEditable -->

<cfinclude template="#APPLICATION.htmlPath#/includes/html_head.cfm">


<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
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

	<cfinclude template="#APPLICATION.htmlPath#/includes/app_page_head.cfm">

<!---<cfoutput>
<script src="#APPLICATION.htmlPath#/language/preferences_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>--->

<!---<cfif APPLICATION.identifier EQ "vpnet">
	<cfinclude template="includes/preferences_head.cfm">
</cfif>--->

<cfset return_page = "index.cfm">
<!---<div>

<div class="div_list_item"><a href="preferences_alerts.cfm">Preferencias de notificaciones</a></div>
<div class="div_list_item"><a href="preferences_user_data.cfm">Datos Personales</a></div>

</div>--->

<script>

	
	function resizeIframes() {
		var newHeight = windowHeight()-74;

		$(".iframes").height(newHeight);
	}
	
	$(window).load( function() {	

		resizeIframes();	
		
		$('#preferencesTab a').click( function (e) {
			if(e.preventDefault)
		  		e.preventDefault();
				
		  	$(this).tab('show');
		})
		
	} );

	$(window).resize( function() {
		resizeIframes();
	});
	
</script>

<!--- getClient --->
<cfinvoke component="#APPLICATION.htmlPath#/components/Client" method="getClient" returnvariable="clientQuery">
	<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
</cfinvoke>

<div style="clear:both"><!-- --></div>

<div class="tabbable"><!---Tab Panel--->

	<div style="clear:none;float:right;padding-top:5px; padding-right:6px;"><!---width:200px; --->
		<cfoutput>
		<a href="#APPLICATION.htmlPath#/admin/main.cfm?abb=#SESSION.client_abb#" class="btn btn-default btn-sm"><i class="icon-arrow-left"></i> <span lang="es">Volver</span></a>
		</cfoutput>
	</div>
	
	<ul class="nav nav-pills" id="preferencesTab" style="clear:none; padding-bottom:5px;">
		<li class="active"><a href="#tab1" data-toggle="tab" lang="es"><i class="icon-user"></i> Datos personales</a></li>
		<li><a href="#tab2" data-toggle="tab" lang="es"><i class="icon-envelope-alt"></i> Notificaciones</a></li>
		<!---<cfif clientQuery.bin_enabled IS true>
			<li><a href="#tab3" data-toggle="tab" lang="es"><i class="icon-trash"></i> Papelera</a></li>
		</cfif>--->
	</ul>

  
  <div class="tab-content">
  
	<div class="tab-pane active" id="tab1"><!---Tab Datos personales--->
	
		<!---<cfoutput>
		<iframe src="#APPLICATION.htmlPath#/iframes/preferences_user_data.cfm" marginheight="0" marginwidth="0" scrolling="auto" frameborder="0" style="width:100%;height:690px;background-color:##FFFFFF;clear:none;"></iframe>
		</cfoutput> --->
		<cfinclude template="#APPLICATION.htmlPath#/includes/preferences_user_data.cfm"/>
						
	
	</div><!---END Tab Datos personales--->
	
	
	<div class="tab-pane" id="tab2"><!---Tab Notificaciones--->
		<cfoutput>
		<iframe src="#APPLICATION.htmlPath#/iframes/preferences_alerts.cfm" marginheight="0" marginwidth="0" scrolling="auto" frameborder="0" class="iframes" style="width:100%;height:100%;background-color:##FFFFFF;clear:none;"></iframe>
		</cfoutput>
		
	</div><!---END Tab Notificaciones--->


	<!---<cfif clientQuery.bin_enabled IS true>

		<div class="tab-pane" id="tab3"><!---Tab Papelera--->

			<cfoutput>
			<iframe src="#APPLICATION.htmlPath#/iframes/bin.cfm" marginheight="0" marginwidth="0" scrolling="auto" frameborder="0" class="iframes" style="width:100%;height:100%;background-color:##FFFFFF;clear:none;"></iframe>
			</cfoutput>
			
		</div><!---END Tab Notificaciones--->

	</cfif>---->
	
	
  </div>
  
</div><!---END TabPanel--->

<!---<cfset return_page = "index.cfm">
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="returnElement">
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