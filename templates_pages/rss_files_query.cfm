<cfsetting enablecfoutputonly="yes">

<!---Obtiene todas las áreas de la intranet--->
<cfinvoke component="#APPLICATION.componentsPath#/components/AreaQuery" method="geSubAreasIds" returnvariable="areas_ids">
	<cfinvokeargument name="area_id" value="#rootAreaId#">
	
	<cfinvokeargument name="client_abb" value="#clientAbb#">
	<cfinvokeargument name="client_dsn" value="#clientDsn#">
</cfinvoke>

<!---AreaItems--->
<cfinvoke component="#APPLICATION.componentsPath#/components/FileQuery" method="getAreaFiles" returnvariable="items">
	<cfinvokeargument name="areas_ids" value="#areas_ids#">

	<cfinvokeargument name="client_abb" value="#clientAbb#">
	<cfinvokeargument name="client_dsn" value="#clientDsn#">
</cfinvoke>

<cfif CGI.HTTP_HOST IS "10.72.32.24">
	<cfset base_url = "http://10.72.32.24/servicioandaluzdesalud/asnc/colabora/beta/#areaTypeRequired#/">
<cfelse>
	<cfset base_url = "#APPLICATION.alternateUrl#/#areaTypeRequired#/">
</cfif>