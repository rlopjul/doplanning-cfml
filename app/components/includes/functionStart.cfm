<!--- IMPORTANTE: NO USAR ESTE SCRIPT EN LAS NUEVAS FUNCIONES, se debe usar en su lugar functionStartOnlySession.cfm  --->

<!---<cfsetting enablecfoutputonly="true" />---><!---IMPORTANTE: A partir de esta etiqueta no se hace output de nada salvo lo que esté dentro de cfoutput--->
<cfinclude template="sessionVars.cfm">		

<cfif NOT isDefined("method")>
	<cfset method = "undefined">
</cfif>
<cfset xmlResponseContent = "undefined">

<cfif isDefined("arguments.request") AND arguments.request NEQ "">				
	<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="xmlRequest" returnvariable="xmlRequest">
		<cfinvokeargument name="request" value="#arguments.request#">
	</cfinvoke>
</cfif>