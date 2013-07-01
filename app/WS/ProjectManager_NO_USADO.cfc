<!---Copyright Era7 Information Technologies 2007-2008

    File created by: ppareja
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 22-08-2008
	
	ESTE COMPONENTE NO SE UTILIZA
	
--->
<cfcomponent output="false">

	<cfset component = "ProjectManager">
	
	<!--- _______________________CREATE PROJECT_________________________________________  --->
	
	<cffunction name="createProject" output="false" access="remote" returntype="String">		
		<cfargument name="request" type="string" required="yes">
		<!---<cfargument name="name" type="string" required="yes">				
		<cfargument name="user_in_charge" type="string" required="yes">
		<cfargument name="parent_id" type="string" required="yes">	
		<cfargument name="parent_kind" type="string" required="yes">--->		
		
		<cfset var method = "createProject">
		
		<cfset var name = "">
		<cfset var user_in_charge = "">
		<cfset var parent_id = "">
		<cfset var parent_kind = "">
		
		<cfset var projectsSequence = ""> 
	
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
		
			<!---<cfset name =  xmlRequest.request.parameters.project.name.xmlText>--->
		
			<cfset projectsSequence="#client_abb#_projects_id_seq">
		
			<cfquery name="beginQuery" datasource="#client_dsn#">
				BEGIN;
			</cfquery>
					
			<cfquery name="insertProjectQuery" datasource="#client_dsn#"  >					
				INSERT INTO #client_abb#_projects (name,user_in_charge,parent_id,parent_kind) 
				VALUES (
					<cfqueryPARAM value = "#name#" CFSQLType = "CF_SQL_varchar">,			
					<cfqueryPARAM value = "#parent_id#" CFSQLType = "CF_SQL_integer">,					
					<cfqueryPARAM value = "#user_in_charge#" CFSQLType="cf_sql_integer">
					<cfqueryPARAM value = "#parent_id#" CFSQLType = "CF_SQL_integer">,
					<cfqueryPARAM value = "#parent_kind#" CFSQLType = "CF_SQL_varchar">
					
					);			
			</cfquery>
			
			<cfquery name="getIdQuery" datasource="#client_dsn#">
				SELECT nextval('#projectsSequence#') AS val_seq;
			</cfquery>
				
			<cfset project_id = #getIdQuery.val_seq#-1>
			
			<cfquery name="insertUserQuery" datasource="#client_dsn#">
				INSERT INTO #client_abb#_projects_users 
				VALUES (#project_id#,
						<cfqueryPARAM value = "#user_in_charge#" CFSQLType="cf_sql_integer">				
					);
			</cfquery>
			
			<cfquery name="commitQuery" datasource="#client_dsn#">
				COMMIT;
			</cfquery>
			
			<cfreturn "#project_id#">
			
			<cfcatch type="any">
				<cfreturn '#cfcatch.detail# #cfcatch.type# #cfcatch.Message#'>										
			</cfcatch>
		
		</cftry>
		
		
		
	</cffunction>
	
	<!--- _____________________________________________________________________________  --->


	<!--- _______________________DELETE PROJECT_________________________________________  --->
	
	<cffunction name="deleteProject" output="false" access="remote" returntype="String">		
		<cfargument name="id" type="string" required="yes">				
		<!---<cfargument name="clientAbb" type="string" required="yes">		--->	
		
		<cfinclude template="includes/sessionVars.cfm">
		
		<cftry>
								
			<cfquery name="deleteProjectQuery" datasource="#client_dsn#"  >					
				DELETE 
				FROM #client_abb#_projects
				WHERE id = <cfqueryPARAM value = "#id#" CFSQLType = "CF_SQL_integer">;
			</cfquery>
									
			<cfreturn "true">
			
			<cfcatch type="any">
				<cfreturn '#cfcatch.detail# #cfcatch.type# #cfcatch.Message#'>										
			</cfcatch>
		
		</cftry>
		
		
		
	</cffunction>
	
	<!--- _____________________________________________________________________________  --->
	
	<!--- _______________________SELECT PROJECT_________________________________________  --->
	
	<cffunction name="selectProject" output="false" access="remote" returntype="String">		
		<cfargument name="id" type="string" required="yes">				
		<!---<cfargument name="clientAbb" type="string" required="yes">--->			
		
		<cfinclude template="includes/sessionVars.cfm">
		
		<cftry>
								
			<cfquery name="selectProjectQuery" datasource="#client_dsn#"  >					
				SELECT *
				FROM #client_abb#_projects
				WHERE id = <cfqueryPARAM value = "#id#" CFSQLType = "CF_SQL_integer">;
			</cfquery>
			
			<cfif #selectProjectQuery.RecordCount# GT 0>
				<cfxml variable="xmlResult">
					<cfoutput>
						<project id="#selectProjectQuery.id#"
								name="#selectProjectQuery.name#"
								label="#selectProjectQuery.name#" 
								user_in_charge="#selectProjectQuery.user_in_charge#"
								parent_id="#selectProjectQuery.parent_id#"
								parent_kind="#selectProjectQuery.parent_kind#"	
							/>
					</cfoutput>
				</cfxml>
				<cfreturn #xmlResult#>
				<cfelse>
					<cfreturn "false">
			</cfif>		
			
			<cfcatch type="any">
				<cfreturn '#cfcatch.detail# #cfcatch.type# #cfcatch.Message#'>										
			</cfcatch>
		
		</cftry>
		
		
		
	</cffunction>
	
	<!--- _____________________________________________________________________________  --->
	
	
	<!--- _______________________UPDATE PROJECT_________________________________________  --->
	
	<!--- ++++++++++++++++++++++++++++ PROJECT NAME  +++++++++++++++++++++++ --->
	<cffunction name="updateProjectName" returntype="Boolean" output="false" access="remote">
		<cfargument name="id" type="string" required="yes">
		<cfargument name="name" type="string" required="yes">
		<!---<cfargument name="clientAbb" type="string" required="yes">--->
		
		<cfinclude template="includes/sessionVars.cfm">
		
		<cfquery name="getCurrentValues" datasource="#client_dsn#" >		
			SELECT * 
			FROM #client_abb#_projects
			WHERE id = #id#		
		</cfquery>
		<cfif #getCurrentValues.recordCount# GT 0>
			<cfquery name="projectQuery" datasource="#client_dsn#">
				UPDATE #client_abb#_projects SET name = <cfqueryPARAM value = "#name#" CFSQLType = "CF_SQL_varchar">
				WHERE id = #id#;
			</cfquery>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<!--- ++++++++++++++++++++++++++++ PROJECT PARENT ID  +++++++++++++++++++++++ --->
	<cffunction name="updateProjectParenId" returntype="Boolean" output="false" access="remote">
		<cfargument name="id" type="string" required="yes">
		<cfargument name="parent_id" type="string" required="yes">
		<!---<cfargument name="clientAbb" type="string" required="yes">--->
		
		<cfinclude template="includes/sessionVars.cfm">
		
		<cfquery name="getCurrentValues" datasource="#client_dsn#" >		
			SELECT * FROM #client_abb#_project
			WHERE id = #id#;	
		</cfquery>
		<cfif #getCurrentValues.recordCount# GT 0>
			<cfquery name="parentIdQuery" datasource="#client_dsn#">
				UPDATE #client_abb#_project SET parent_id = <cfqueryPARAM value="#parent_id#" CFSQLType = "CF_SQL_integer">
				WHERE id = #id#;
			</cfquery>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<!--- ++++++++++++++++++++++++++++ PROJECT USER IN CHARGE  +++++++++++++++++++++++ --->
	<cffunction name="updateProjectUserInCharge" returntype="Boolean" output="false" access="remote">
		<cfargument name="id" type="string" required="yes">
		<cfargument name="user_in_charge" type="string" required="yes">
		<!---<cfargument name="clientAbb" type="string" required="yes">--->
		
		<cfinclude template="includes/sessionVars.cfm">
		
		<cfquery name="getCurrentValues" datasource="#client_dsn#" >		
			SELECT * 
			FROM #client_abb#_project
			WHERE id = #id#;	
		</cfquery>
		<cfif #getCurrentValues.recordCount# GT 0>
			<cfquery name="userInChargeQuery" datasource="#client_dsn#">
				UPDATE #client_abb#_projects SET user_in_charge = <cfqueryPARAM value="#user_in_charge#" CFSQLType="CF_SQL_integer">
				WHERE id = #id#;
			</cfquery>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	
	<!--- _____________________________________________________________________________  --->
	
	
	
	
	

</cfcomponent>