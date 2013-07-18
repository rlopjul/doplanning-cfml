<!DOCTYPE html>
<html lang="es">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<!---Esta página se usa para mostrar en el iframe del área resultados de acciones como crear un nuevo mensaje, modificar un archivo, etc, cuya página no se encuentra en el directorio iframes2--->
<cfoutput>
<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/iframesFunctions.min.js"></script>
<script type="text/javascript">
	openUrlLite("#getFileFromPath(CGI.SCRIPT_NAME)#?#CGI.QUERY_STRING#", "areaIframe");
</script>
</cfoutput>
</head>
<body>
</body>
</html>
