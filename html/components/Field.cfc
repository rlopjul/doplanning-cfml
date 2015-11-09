<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="true">

	<cfset component = "Field">
	<cfset request_component = "FieldManager">


	<!--- ----------------------------------- getFieldTypes ------------------------------------- --->

	<cffunction name="getFieldTypes" returntype="struct" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getFieldTypes">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="getFieldTypes" returnvariable="response">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ----------------------------------- getFieldMaskTypes ------------------------------------- --->

	<cffunction name="getFieldMaskTypes" returntype="struct" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getFieldMaskTypes">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="getFieldMaskTypes" returnvariable="response">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ----------------------------------- getField -------------------------------------- --->

	<!---Este método no hay que usarlo en páginas en las que su contenido se cague con JavaScript (páginas de html_content) porque si hay un error este método redirige a otra página. En esas páginas hay que obtener el Item directamente del AreaItemManager y comprobar si result es true o false para ver si hay error y mostrarlo correctamente--->

	<cffunction name="getField" output="false" returntype="query" access="public">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_table" type="numeric" required="false" default="false">

		<cfset var method = "getField">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="getField" returnvariable="response">
				<cfinvokeargument name="field_id" value="#arguments.field_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="with_table" value="#arguments.with_table#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response.field>

	</cffunction>


	<!--- ----------------------------------- getEmptyField -------------------------------------- --->

	<cffunction name="getEmptyField" output="false" returntype="query" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getEmptyField">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="getEmptyField" returnvariable="response">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response.field>

	</cffunction>


	<!--- -------------------------------createField-------------------------------------- --->

    <cffunction name="createField" returntype="struct" access="public">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="field_type_id" type="numeric" required="true">
		<cfargument name="label" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="required" type="boolean" required="false" default="false">
		<cfargument name="sort_by_this" type="string" required="true">
        <cfargument name="default_value" type="string" required="true">
        <cfargument name="position" type="numeric" required="false">
        <cfargument name="list_area_id" type="string" required="false">
        <cfargument name="field_input_type" type="string" required="false">
        <cfargument name="list_values" type="string" required="false">

		<cfset var method = "createField">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="createField" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message = "Campo creado">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- -------------------------------updateField-------------------------------------- --->

  <cffunction name="updateField" returntype="struct" access="public">
  	<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="label" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="required" type="boolean" required="false" default="false">
		<cfargument name="sort_by_this" type="string" required="true">
    <cfargument name="default_value" type="string" required="true">
    <cfargument name="list_area_id" type="string" required="false">
    <cfargument name="field_input_type" type="string" required="false">
    <cfargument name="list_values" type="string" required="false">

		<cfset var method = "updateField">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="updateField" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message = "Campo modificado">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- -------------------------------copyTableFields-------------------------------------- --->

    <cffunction name="copyTableFields" returntype="struct" access="public">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="copy_from_table_id" type="numeric" required="true">
		<cfargument name="fields_ids" type="array" required="true">

		<cfset var method = "copyTableFields">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="copyTableFields" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message="Campos de #tableTypeNameEs# copiados.">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!---  ---------------------- changeFieldPosition -------------------------------- --->

	<cffunction name="changeFieldPosition" returntype="struct" access="public">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="other_field_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="action" type="string" required="true"><!---increase/decrease--->

		<cfset var method = "changeFieldPosition">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="changeFieldPosition" returnvariable="response">
				<cfinvokeargument name="a_field_id" value="#arguments.field_id#">
				<cfinvokeargument name="b_field_id" value="#arguments.other_field_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="action" value="#arguments.action#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- -------------------------------deleteFieldRemote-------------------------------------- --->

    <cffunction name="deleteFieldRemote" returntype="void" access="remote">
    	<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="return_path" type="string" required="yes">

		<cfset var method = "deleteFieldRemote">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="deleteField" returnvariable="response">
				<cfinvokeargument name="field_id" value="#arguments.field_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message = "Campo eliminado">
			</cfif>

			<cfset msg = URLEncodedFormat(response.message)>

			<cflocation url="#arguments.return_path#&res=#response.result#&msg=#msg#" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

	</cffunction>



</cfcomponent>
