<!--- -------------------------------------- CHECK AREA ACCESS ----------------------------------------------- --->
<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="checkAreaAccess">
	<cfinvokeargument name="area_id" value="#area_id#">
</cfinvoke>