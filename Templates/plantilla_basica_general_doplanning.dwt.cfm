<!-- TemplateInfo codeOutsideHTMLIsLocked="true" --><cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es">
<head>
<cfoutput>
<!-- TemplateBeginEditable name="doctitle" -->
<title>#APPLICATION.title#</title>
<!-- TemplateEndEditable -->

<cfinclude template="#APPLICATION.htmlPath#/includes/html_head.cfm">

<!-- TemplateBeginEditable name="head" -->
<!-- TemplateEndEditable -->
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

<!-- TemplateBeginEditable name="header" -->

<!-- TemplateEndEditable -->

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
	<!-- TemplateBeginEditable name="contenido" -->
	<!-- TemplateEndEditable -->
	<!---</div>--->
	
</div>
<!--- END wrapper --->

</body>
</html>
</cfprocessingdirective>