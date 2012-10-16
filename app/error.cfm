<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Error</title>
</head>

<body>


<div style="clear:both">
<cfoutput>
<cfif isDefined("URL.error_code")>
	<cfinvoke component="#APPLICATION.componentsPath#/ErrorManager" method="getError" returnvariable="objectError">
		<cfinvokeargument name="error_code" value="#URL.error_code#">	
	</cfinvoke>
	
	<cfif objectError.error_code IS 102>
							
		<cflocation url="../#SESSION.client_id#" addtoken="no">
				
	<cfelse>
	
		<div class="div_text_result"><strong>#objectError.title#</strong><br />
		#objectError.description#</div>
	
	</cfif>
	
</cfif>

<a href="../#SESSION.client_id#">Volver</a>

</cfoutput>
</div>

</body>
</html>
