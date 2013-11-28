<!---Copyright Era7 Information Technologies 2007-2013--->

<cfcomponent output="false">

	<cfset component = "DateManager">

	<!--- createDateFromString --->

	<cffunction name="createDateFromString" returntype="date" output="false" access="public">
		<cfargument name="strDate" type="string" required="yes">
		
		<cfset date = createDate(listGetAt(strDate,3,'-'), listGetAt(strDate,2,"-"), listGetAt(strDate,1,"-"))>
		<cfreturn date>
		
	</cffunction>


</cfcomponent>
	