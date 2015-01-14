<cfprocessingdirective suppresswhitespace="true">
<div id="areasTreeContainer" style="clear:both">
<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaTree" method="outputMainTree">
	<cfinvokeargument name="get_user_id" value="#SESSION.user_id#">
</cfinvoke>
</div>
</cfprocessingdirective>