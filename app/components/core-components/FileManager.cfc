<!---Copyright Era7 Information Technologies 2007-2013--->
<cfcomponent output="false">


	<!--- ----------------------- trasnformFileSize -------------------------------- --->
	
	<cffunction name="trasnformFileSize" returntype="string" output="false" access="public">	
		<cfargument name="file_size_full" type="numeric" required="true"><!---file_size_full is the file_size from database without parse to kilobytes--->

		<cfset var file_size = "">
		<cfset var file_size_kb = "">	
			
			<cfif arguments.file_size_full LT (1024*1024)><!---File size is LT a mega byte--->
			
				<!---Get the file size in KB--->
				<cfset file_size_kb = arguments.file_size_full/1024>
				<cfset file_size_kb = round(file_size_kb*10)/10>
				<cfif file_size_kb IS 0>
					<cfset file_size_kb = 1>
				</cfif>
				<cfset file_size_kb = file_size_kb&" KB">

				<cfset file_size = file_size_kb>
				
			<cfelse>
				
				<!---Get the file size in MB--->
				<cfset file_size = arguments.file_size_full/(1024*1024)>
				<cfset file_size = round(file_size*100)/100>
				
				<cfset file_size = file_size&" MB">
				
			</cfif>

		<cfreturn file_size>

	</cffunction>

</cfcomponent>