<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es"><!-- InstanceBegin template="/Templates/plantilla_app_doplanning.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<head>
<cfoutput>
<!-- InstanceBeginEditable name="doctitle" -->
<title>#APPLICATION.title#-Elementos del &aacute;rea</title>
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


<!--- Alert --->
<cfinclude template="#APPLICATION.htmlPath#/includes/main_alert.cfm">

<cfif isDefined("URL.mode") AND URL.mode EQ "list">

	<cfinclude template="#APPLICATION.htmlPath#/includes/all_area_items_content.cfm">

<cfelse>

	<cfinclude template="#APPLICATION.htmlPath#/includes/all_area_items_full_content.cfm">

</cfif>

<!---<cfset return_page = "area.cfm?area=#area_id#">
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>--->


<!---
<script>

	function showAlertMessage(msg, res){

		if($("#alertContainer span").length != 0)
			$("#alertContainer span").remove();

		if(res == true)
			$("#alertContainer").attr("class", "alert alert-success");
		else
			$("#alertContainer").attr("class", "alert alert-danger");
		
		$("#alertContainer button").after('<span>'+msg+'</span>');

		var maxZIndex = getMaxZIndex();

	    $("#alertContainer").css('zIndex',maxZIndex+1);

		$("#alertContainer").fadeIn('slow');


		setTimeout(function(){
			    
		    hideAlertMessage();

		    }, 9500);	
	}

	function hideAlertMessage(){

		$("#alertContainer").fadeOut('slow', function() {
		    $("#alertContainer span").remove();
		});

	}
	
	$(document).ready(function () {

		// Alert
		$('#alertContainer .close').click(function(e) {

			hideAlertMessage();

		});
						
	});
	
</script>
--->



<!-- InstanceEndEditable -->
	</div>

</div><!---END page-content-wrapper --->


	<!---</div>--->
	
</div>
<!--- END wrapper --->

</body>
<!-- InstanceEnd --></html>
</cfprocessingdirective>