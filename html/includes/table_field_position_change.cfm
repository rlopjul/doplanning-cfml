<!---required var: action--->
<cfif isDefined("URL.field") AND isNumeric(URL.field) AND isDefined("URL.ofield") AND isNumeric(URL.ofield) AND isDefined("URL.tableTypeId") AND isNumeric(URL.tableTypeId) AND isDefined("URL.table") AND isNumeric(URL.table)>

	<cfset field_id = URL.field>
	<cfset other_field_id = URL.ofield>
	<cfset tableTypeId = URL.tableTypeId>
	<cfset table_id = URL.table>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Field" method="changeFieldPosition" returnvariable="changeTableFieldPositionResult">
		<cfinvokeargument name="field_id" value="#field_id#">
		<cfinvokeargument name="other_field_id" value="#other_field_id#">
		<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		<cfinvokeargument name="action" value="#action#">
	</cfinvoke>
	
	<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

	<cfif changeTableFieldPositionResult.result IS true>
		<cflocation url="#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#" addtoken="no">
	<cfelse>
		<cflocation url="#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#&res=0&msg=#URLEncodedFormat(changeTableFieldPositionResult.message)#" addtoken="no">
	</cfif>

</cfif>