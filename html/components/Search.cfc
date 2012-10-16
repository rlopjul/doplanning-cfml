<!---Copyright Era7 Information Technologies 2007-2009

	Date of file creation: 04-03-2009
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 27-04-2009
	
--->
<cfcomponent output="false">

	<cfset component = "Search">
	<cfset request_component = "SearchManager">
	

    <cffunction name="searchFiles" returntype="xml" access="public" output="false">
		<cfargument name="name" type="string" required="true">
		<cfargument name="file_name" type="string" required="true">
		<cfargument name="file_type" type="string" required="true">
		<cfargument name="page" type="numeric" required="false" default="1">
		
		<cfset var method = "searchFiles">
		
		<cfset var request_parameters = "">
		
		<cftry>		
			
			<cfset request_parameters = '<search page="#arguments.page#"><file'>
			<cfif len(arguments.file_type) GT 0>
				<cfset request_parameters = request_parameters&' file_type="#arguments.file_type#"'>
			</cfif>
			<cfset request_parameters = request_parameters&'>'>
			<cfif len(arguments.name) GT 0>
				<cfset request_parameters = request_parameters&'<name><![CDATA[#arguments.name#]]></name>'>
			</cfif>
			<cfif len(arguments.file_name) GT 0>
				<cfset request_parameters = request_parameters&'<file_name><![CDATA[#arguments.file_name#]]></file_name>'>
			</cfif>
			<cfset request_parameters = request_parameters&'</file></search>'>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<cffunction name="searchMessages" returntype="xml" access="public" output="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="date_from" type="string" required="false">
		<cfargument name="date_to" type="string" required="false">
		<cfargument name="user_in_charge" type="string" required="false">
		<cfargument name="page" type="numeric" required="false" default="1">
		
		<cfset var method = "searchMessages">
		
		<cfset var request_parameters = "">
		
		<cftry>		
			
			<cfset request_parameters = '<search page="#arguments.page#"><message'>
			
			<cfif isDefined("arguments.user_in_charge") AND isValid("integer", arguments.user_in_charge)>
				<cfset request_parameters = request_parameters&' user_in_charge="#arguments.user_in_charge#"'>
			</cfif>
			
			<cfset request_parameters = request_parameters&'><title><![CDATA[#arguments.title#]]></title><description><![CDATA[#arguments.description#]]></description>'>
			
			<cfif isDefined("arguments.date_from") AND len(arguments.date_from) GT 0>
				<cfset request_parameters = request_parameters&'<creation_date from="#arguments.date_from#" to="#arguments.date_to#"/>'>
			</cfif>
			
			<cfset request_parameters = request_parameters&'</message></search>'>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
        
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	<cffunction name="searchUsers" returntype="xml" access="public">
		<cfargument name="text" type="string" required="true">
		<cfargument name="page" type="numeric" required="false" default="1">
		
		<cfset var method = "searchUsers">
		
		<cfset var request_parameters = "">
		
		<cftry>		
			
			<cfset request_parameters = '<search page="#arguments.page#"><user><family_name><![CDATA[#arguments.text#]]></family_name></user></search>'>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
            
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<cffunction name="searchAreas" returntype="xml" access="public">
		<cfargument name="text" type="string" required="true">
		<cfargument name="page" type="numeric" required="false" default="1">
		
		<cfset var method = "searchAreas">
		
		<cfset var request_parameters = "">
		
		<cftry>		
			
			<cfset request_parameters = '<search page="#arguments.page#"><text><![CDATA[#arguments.text#]]></text></search>'>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
            
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>	
	
</cfcomponent>