<cfif isDefined("URL.abb") AND isDefined("URL.mailing") AND isNumeric(URL.mailing)>

  <!---<cfset user_id = URL.user_id>--->
  <cfset client_abb = URL.abb>
  <cfset client_dsn = APPLICATION.identifier&"_"&client_abb>


  <!--- getUser --->
  <!---<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="selectUserQuery">
    <cfinvokeargument name="user_id" value="#user_id#">

    <cfinvokeargument name="client_abb" value="#client_abb#">
    <cfinvokeargument name="client_dsn" value="#client_dsn#">
  </cfinvoke>

  <cfif selectUserQuery.recordCount GT 0>--->

    <cflocation url="#APPLICATION.htmlPath#/preferences_alerts.cfm?abb=#client_abb#" addtoken="no">

  <!---<cfelse>
    <p>Usuario no encontrado.</p>
  </cfif>--->

</cfif>
