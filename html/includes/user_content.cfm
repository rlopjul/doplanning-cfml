<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#user_id#">
</cfinvoke>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUser">
	<cfinvokeargument name="objectUser" value="#objectUser#">
</cfinvoke>