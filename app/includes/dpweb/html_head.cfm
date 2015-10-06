<cfif page_directory EQ "intranet">

  <!--- Add client abb to all URLs --->
  <cfoutput>
  <script src="#APPLICATION.path#/jquery/jquery.html5.history.min.js" charset="utf-8"></script>
  <script src="#APPLICATION.path#/jquery/jquery-lang/jquery-lang.min.js" charset="utf-8" ></script>

  <script>
  $(function () {

    window.lang = new Lang('es');

    <cfif language NEQ "es">
      window.lang.dynamic('en', '#APPLICATION.mainUrl#/html/language/web_en.cfm');
      window.lang.change('#language#');
    </cfif>

    <cfif NOT isDefined("URL.abb")>

      <cfif len(CGI.QUERY_STRING) GT 0>
        <cfset newQueryString = "?#CGI.QUERY_STRING#&abb=#clientAbb#">
      <cfelse>
        <cfset newQueryString = "?abb=#clientAbb#">
      </cfif>

      History.replaceState(History.getState().data, History.options.initialTitle, "#newQueryString#");

    </cfif>

  });
  </script>

  </cfoutput>

</cfif>
