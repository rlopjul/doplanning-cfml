<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 07-11-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 07-06-2009
	
--->
<cfcomponent output="false">

	<cfset component = "DataBaseManager">

	<!---Esta función no se debe usar, entre otras cosas porque APPLICATION.dataBaseName no es correcto--->
	<!---<cffunction name="getNextValue" access="public" returntype="numeric">		
		<cfargument name="table_name" type="string" required="yes">
		
		<cfset var method = "getNextValue">
		
			<cfquery datasource="#client_dsn#" name="getNextValueQuery">
					SELECT Auto_increment AS next_val FROM information_schema.tables WHERE table_name='#arguments.table_name#' AND TABLE_SCHEMA='#APPLICATION.dataBaseName#';
			</cfquery>
		
		<cfreturn getNextValueQuery.next_val>
	
	</cffunction>--->
	
</cfcomponent>