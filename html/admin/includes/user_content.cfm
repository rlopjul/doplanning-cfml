<cfoutput>
<script src="#APPLICATION.htmlPath#/language/user_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#user_id#">
	<cfinvokeargument name="format_content" value="all">
</cfinvoke>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUser">
	<cfinvokeargument name="objectUser" value="#objectUser#">
	<cfinvokeargument name="showAdminFields" value="true">
</cfinvoke>