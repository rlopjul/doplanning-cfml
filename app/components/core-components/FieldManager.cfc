<!--- Copyright Era7 Information Technologies 2007-2014 --->
<cfcomponent output="false">

	<cfset component = "FieldManager">	

	<!--- getFieldMaskTypesStruct --->

	<cffunction name="getFieldMaskTypesStruct" returntype="struct" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="client_abb" type="string" required="true">

		<cfset var fieldMasksStruct = structNew()>

		<cfinclude template="includes/tableFieldMaskStruct.cfm">

		<cfreturn fieldMasksStruct>

	</cffunction>


</cfcomponent>