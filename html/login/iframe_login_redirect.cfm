<!---Esta página redirige a la página padre del iframe cuando se ha acabado la sesión--->
<cfoutput>
<script type="text/javascript">
	<!---Para que pueda acceder al login hay que pasarle el client_abb--->	
	<cfif isDefined("URL.abb")>
		window.parent.location.href = "#APPLICATION.htmlPath#/login/?client_abb=#URL.abb#";
	<cfelse>
		window.parent.location.href = "#APPLICATION.mainUrl#";
	</cfif>
</script>
</cfoutput>