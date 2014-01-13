<!---Copyright Era7 Information Technologies 2007-2013--->

<cfcomponent output="false">

	<cfset component = "DateManager">

	<!--- createDateFromString --->

	<cffunction name="createDateFromString" returntype="date" output="false" access="public">
		<cfargument name="strDate" type="string" required="yes">
		
		<cfset date = createDate(listGetAt(strDate,3,'-'), listGetAt(strDate,2,"-"), listGetAt(strDate,1,"-"))>
		<cfreturn date>
		
	</cffunction>


	<!--- validateDate --->

	<cffunction name="validateDate" returntype="boolean" output="false" access="public">
		<cfargument name="strDate" type="string" required="yes">

		<cfset var result = false>
		<cfset var errorMessage = "">

		<cftry>
			
			<cfinvoke component="DateManager" method="createDateFromString" returnvariable="date">
				<cfinvokeargument name="strDate" value="#arguments.strDate#">
			</cfinvoke>

			<cfif isDate(date)>
				<cfset result = true>
			</cfif>

			<cfcatch>
				<cfset errorMessage = "Fecha con formato incorrecto #arguments.strDate#">
				<cfthrow message="#errorMessage#">
			</cfcatch>
		</cftry>
		
		<cfreturn result>

	</cffunction>



</cfcomponent>
	