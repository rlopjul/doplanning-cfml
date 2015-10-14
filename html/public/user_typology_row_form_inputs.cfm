<cfif isDefined("URL.abb")>


<!--- check here if client public registration is enabled --->


<cftry>

  <cfset client_abb = URL.abb>
  <cfset client_dsn = APPLICATION.identifier&"_"&client_abb>

  <cfset tableTypeId = 4>

	<cfif isDefined("URL.typology") AND isNumeric(URL.typology)>

		<cfset table_id = URL.typology>

		<!---Table fields--->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/FieldQuery" method="getTableFields" returnvariable="fields">
			<cfinvokeargument name="table_id" value="#table_id#"/>
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#"/>
			<cfinvokeargument name="with_types" value="true"/>
      <cfinvokeargument name="with_table" value="true">

      <cfinvokeargument name="client_abb" value="#client_abb#">
      <cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

		<cfset area_id = fields.area_id>

		<!--- NEW ROW --->

		<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getEmptyRow" returnvariable="emptyRow">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">

      <cfinvokeargument name="client_abb" value="#client_abb#">
      <cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="fillEmptyRow" returnvariable="row">
			<cfinvokeargument name="emptyRow" value="#emptyRow#">
			<cfinvokeargument name="fields" value="#fields#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">

      <cfinvokeargument name="client_abb" value="#client_abb#">
      <cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

		<!--- outputRowFormInputs --->
    <cfinvoke component="#APPLICATION.coreComponentsPath#/RowHtml" method="outputRowFormInputs">
      <cfinvokeargument name="table_id" value="#table_id#">
      <cfinvokeargument name="tableTypeId" value="#tableTypeId#">
      <cfinvokeargument name="row" value="#row#">
      <cfinvokeargument name="fields" value="#fields#">
      <cfinvokeargument name="language" value="#APPLICATION.defaultLanguage#">

      <cfinvokeargument name="client_abb" value="#client_abb#">
      <cfinvokeargument name="client_dsn" value="#client_dsn#">
    </cfinvoke>

	</cfif>


	<cfcatch>

		<cfoutput>
			<div class="alert alert-danger">
				<i class="icon-warning-sign"></i> <span lang="es">#cfcatch.message#</span>
			</div>
		</cfoutput>

		<!---<cfinclude template="#APPLICATION.htmlPath#/components/includes/errorHandlerNoRedirect.cfm">--->

	</cfcatch>

</cftry>

</cfif>
