<br/>
<cfoutput>
<div style="background-color:##fafafa;">
	<cfif areaTypeRequired EQ "web">
		<a href="http://#CGI.SERVER_NAME##APPLICATION.path#/#areaTypeRequired#" target="_blank"><img src="#APPLICATION.path#/assets/logo_asnc.jpg" alt="Área Sanitaria Norte de Córdoba" /></a>
	<cfelseif areaTypeRequired EQ "intranet">
		<img src="#APPLICATION.path#/assets/logo_asnc_intranet.jpg" alt="Intranet Área Sanitaria Norte de Córdoba" />
	</cfif>
</div>
</cfoutput>
<br/><br/>