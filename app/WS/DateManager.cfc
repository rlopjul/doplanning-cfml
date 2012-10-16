<!---Copyright Era7 Information Technologies 2007-2012

	Date of file creation: 15-09-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 07-09-2012
	
	07-09-2012 alucena: añadido en timestampToString parámetro with_time para que no se añada el tiempo al motrar las fechas de inicio y de fin de tareas y eventos
	
--->
<cfcomponent output="false">

	<cfset component = "DateManager">
	
	<cffunction name="timestampToString" access="public" returntype="string">
		<cfargument name="timestamp_date" type="string" required="yes">
		<cfargument name="with_time" type="boolean" default="true">
		
		<cfset var method = "timestampToString">
		
		
			<cfif len(timestamp_date) IS 0 OR timestamp_date EQ "NULL">
				<cfset stringDate = "">
			<cfelse>
				<cfif findOneOf("-",timestamp_date) GT 3><!---The format is yyyy-mm-dd--->
					<cfif arguments.with_time IS true>
						<cfset stringDate = DateFormat(timestamp_date, APPLICATION.dateFormat)&" "&TimeFormat(timestamp_date, "HH:mm:ss")>
					<cfelse>
						<cfset stringDate = DateFormat(timestamp_date, APPLICATION.dateFormat)>
					</cfif>
				<cfelse><!---The format is not yyyy-mm-dd--->
					<cfset stringDate = timestamp_date>
				</cfif>
			</cfif>
			
			<cfreturn stringDate>
			
	</cffunction>
	
	
	<cffunction name="getCurrentDateTime" access="public" returntype="string">
		
		<cfset var method = "getCurrentDateTime">
		
		
			<cfquery datasource="#APPLICATION.dsn#" name="getCurrentDateTimeQuery">
				SELECT NOW() AS now;				
			</cfquery>
			
			<cfreturn getCurrentDateTimeQuery.now>
			
			
	</cffunction>
	
</cfcomponent>