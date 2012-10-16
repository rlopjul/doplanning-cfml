<!---
Required URL variables:
id
--->
<cftry>
	
	<cfif isDefined("URL.id") AND isValid("integer",URL.id)>
		<cfset component = "goToAreaLink">
		<cfset method = "goToAreaLink">
		
		<cfinclude template="#APPLICATION.componentsPath#/includes/sessionVars.cfm">
		
		<cfset area_id = URL.id>
		
		<!---Un usuario puede acceder al enlace de un área superior a la que no tiene acceso--->
		<!---<cfinclude template="#APPLICATION.componentsPath#/includes/checkAreaAccess.cfm">--->
		
		<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaLink" returnvariable="area_link">
			<cfinvokeargument name="area_id" value="#area_id#"> 
		</cfinvoke>
		
		<cflocation url="#area_link#" addtoken="no">
		
	</cfif>

	<cfcatch>
	
		<cfinclude template="includes/errorHandler.cfm">
		
	</cfcatch>
</cftry>
