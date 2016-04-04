<!---Check if the user logged in has access to the area--->
<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="checkAreaAdministratorAdminAccess">
  <cfinvokeargument name="area_id" value="#area_id#">
</cfinvoke>
