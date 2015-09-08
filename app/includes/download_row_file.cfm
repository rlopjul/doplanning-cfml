




<cfinvoke component="#APPLICATION.coreComponentsPath#/RowAttachedFile" method="deleteRowAttachedFileF">
  <cfinvokeargument name="table_id" value="#table_id#">
  <cfinvokeargument name="row_id" value="#row_id#">
  <cfinvokeargument name="field_id" value="#field_id#">
  <cfinvokeargument name="tableTypeNameP" value="#tableTypeNameP#">

  <cfinvokeargument name="client_abb" value="#client_abb#">
  <cfinvokeargument name="client_dsn" value="#client_dsn#">
</cfinvoke>


<cfset files_directory = tableTypeNameP>

<cfinclude template="get_file.cfm">
