<cfif isDefined("URL.abb")>
  <cflocation url="main.cfm?#CGI.QUERY_STRING#" addtoken="false">
<cfelse>
  <cflocation url="main.cfm?abb=#SESSION.client_abb#" addtoken="false">
</cfif>
