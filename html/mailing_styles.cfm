<cfif isDefined("URL.mailing") AND isNumeric(URL.mailing)>

  <cfset itemTypeId = 17>
  <cfset item_id = URL.mailing>

  <cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getItem" returnvariable="objectItem">
  	<cfinvokeargument name="item_id" value="#item_id#">
  	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
  </cfinvoke>

  <cfset content_styles = objectItem.content_styles>

<cfelseif isDefined("URL.template") AND isNumeric(URL.template)>

  <cfset template_id = URL.template>

  <cfinvoke component="#APPLICATION.htmlComponentsPath#/ItemTemplate" method="getTemplate" returnvariable="getTemplateResponse">
  	<cfinvokeargument name="template_id" value="#template_id#">
  </cfinvoke>

  <cfset templateQuery = getTemplateResponse.template>

  <cfset content_styles = templateQuery.content_styles>

</cfif>

<cfif isDefined("content_styles")>
  <cfcontent type="text/css" />
  <cfoutput>
    body {
      #content_styles#
    }
  </cfoutput>
</cfif>
