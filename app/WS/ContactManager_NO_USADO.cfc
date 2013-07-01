<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 04-11-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 27-02-2008
	
--->
<cfcomponent output="false">
	
	<cfset component = "ContactManager">
	
	<!--- ----------------------- XML CONTACT -------------------------------- --->
	
	<cffunction name="xmlContact" returntype="string" output="false" access="public">		
		<cfargument name="objectContact" type="struct" required="yes">
		
		<cfset var method = "xmlContact">
		
		<cftry>
		
			<cfprocessingdirective suppresswhitespace="true">
			<cfsavecontent variable="xmlResult">
				<cfoutput>
					<contact 
						<cfif len(objectContact.id) NEQ 0>
							id="#objectContact.id#"
						</cfif>
						<cfif len(objectContact.user_id) NEQ 0>
						 	user_id="#objectContact.user_id#"
						</cfif> 
						<cfif len(objectContact.telephone) NEQ 0>
						 	telephone="#objectContact.telephone#"
						</cfif> 
						<cfif len(objectContact.email) NEQ 0>
						 	email="#objectContact.email#"
						</cfif> 
						<cfif len(objectContact.mobile_phone) NEQ 0>
						 	mobile_phone="#objectContact.mobile_phone#"
						</cfif>
						<cfif len(objectContact.telephone_ccode) NEQ 0>
							telephone_ccode="#objectContact.telephone_ccode#"
						</cfif>
						<cfif len(objectContact.mobile_phone_ccode) NEQ 0>
							mobile_phone_ccode="#objectContact.mobile_phone_ccode#"
						</cfif>
						>
						<cfif len(objectContact.family_name) NEQ 0>
							<family_name><![CDATA[#objectContact.family_name#]]></family_name>
						</cfif>
						<cfif len(objectContact.name) NEQ 0>
							<name><![CDATA[#objectContact.name#]]></name>
						</cfif>
						<cfif len(objectContact.address) NEQ 0>	
							<address><![CDATA[#objectContact.address#]]></address>
						</cfif>
						<cfif len(objectContact.organization) NEQ 0>
							<organization><![CDATA[#objectContact.organization#]]></organization>	
						</cfif>
					</contact>
				</cfoutput>
			</cfsavecontent>
			</cfprocessingdirective>
			
			<cfreturn xmlResult>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
				<cfreturn null>
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	
	<!--- ----------------------- CONTACT OBJECT -------------------------------- --->
	
	<cffunction name="objectContact" returntype="any" output="false" access="public">	
		
		<cfargument name="xml" type="string" required="no">
		
		<cfargument name="id" type="string" required="no" default="">
		<cfargument name="user_id" type="string" required="no" default="">		
		<cfargument name="telephone" type="string" required="no" default="">		
		<cfargument name="email" type="string" required="no" default="">
		<cfargument name="family_name" type="string" required="no" default="">
		<cfargument name="name" type="string" required="no" default="">
		<cfargument name="address" type="string" required="no" default="">
		<cfargument name="mobile_phone" type="string" required="no" default="">
		<cfargument name="organization" type="string" required="no" default="">
		<cfargument name="telephone_ccode" type="string" required="no" default="">
		<cfargument name="mobile_phone_ccode" type="string" required="no" default="">
		
		<cfargument name="return_type" type="string" required="no">
		
		<cfset var method = "objectContact">
		
		<cftry>
			
			<cfif isDefined("xml")>
			
				<cfxml variable="xmlContact">
				<cfoutput>
				#xml#
				</cfoutput>
				</cfxml>
			
				<cfif isDefined("xmlContact.contact.XmlAttributes.id")>
					<cfset id=xmlContact.contact.XmlAttributes.id>
				</cfif>
				<cfif isDefined("xmlContact.contact.XmlAttributes.user_id")>
					<cfset user_id=xmlContact.contact.XmlAttributes.user_id>
				</cfif>
				<cfif isDefined("xmlContact.contact.XmlAttributes.telephone")>
					<cfset telephone=xmlContact.contact.XmlAttributes.telephone>
				</cfif>
				<cfif isDefined("xmlContact.contact.XmlAttributes.email")>
					<cfset email=xmlContact.contact.XmlAttributes.email>
				</cfif>
				<cfif isDefined("xmlContact.contact.family_name")>
					<cfset family_name=xmlContact.contact.family_name.xmlText>
				</cfif>
				<cfif isDefined("xmlContact.contact.name")>
					<cfset name=xmlContact.contact.name.xmlText>
				</cfif>
				<cfif isDefined("xmlContact.contact.address")>
					<cfset address=xmlContact.contact.address.xmlText>
				</cfif>
				<cfif isDefined("xmlContact.contact.XmlAttributes.mobile_phone")>
					<cfset mobile_phone="#xmlContact.contact.XmlAttributes.mobile_phone#">
				</cfif>
				<cfif isDefined("xmlContact.contact.organization")>
					<cfset organization="#xmlContact.contact.organization.xmlText#">
				</cfif>
				<cfif isDefined("xmlContact.contact.XmlAttributes.telephone_ccode")>
					<cfset telephone_ccode="#xmlContact.contact.XmlAttributes.telephone_ccode#">
				</cfif>
				
				<cfif isDefined("xmlContact.contact.XmlAttributes.mobile_phone_ccode")>
					<cfset mobile_phone_ccode="#xmlContact.contact.XmlAttributes.mobile_phone_ccode#">
				</cfif>
			
			<cfelseif NOT isDefined("id")>
				
					<cfreturn null>
				
			</cfif>
					
			<cfset object = {
				id="#id#",
				user_id="#arguments.user_id#",
				telephone="#telephone#",
				email="#email#",
				family_name="#family_name#",
				name="#name#",
				address="#address#",
				mobile_phone="#mobile_phone#",
				organization="#organization#",
				telephone_ccode="#telephone_ccode#",
				mobile_phone_ccode="#mobile_phone_ccode#"
				}>
				
			<cfif isDefined("arguments.return_type") AND arguments.return_type EQ "xml">
				
				<cfinvoke component="ContactManager" method="xmlContact" returnvariable="xmlResult">
					<cfinvokeargument name="objectContact" value="#object#">
				</cfinvoke>
				<cfreturn xmlResult>
				
			<cfelse>
			
				<cfreturn object>
				
			</cfif>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
				<cfreturn null>
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	<!--- ------------------------ getContact ------------------------------------ --->
	<cffunction name="getContact" returntype="any" output="true" access="public">
		<cfargument name="contact_id" type="string" required="yes">
		<cfargument name="return_type" type="string" required="no" default="xml">
		
		<cfset var method = "getContact">
		
		<cfset var user_id = "">
<cfset var client_abb = "">
<cfset var user_language = "">
	
<cfset var xmlRequest = "">
<cfset var xmlResponseContent = "">
	
	
		<cfset var id = arguments.contact_id>
			

		<cfinclude template="includes/functionStart.cfm">
				
		<cfquery name="getUserContactQuery" datasource="#client_dsn#">
			SELECT * 
			FROM #client_abb#_contacts
			WHERE id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">;			
		</cfquery>		
		
		<cfif getUserContactQuery.recordCount GT 0>
		
			<cfinvoke component="ContactManager" method="objectContact" returnvariable="contact">
				<cfinvokeargument name="id" value="#getUserContactQuery.id#">
				<cfinvokeargument name="user_id" value="#getUserContactQuery.user_id#">
				<cfinvokeargument name="telephone" value="#getUserContactQuery.telephone#">
				<cfinvokeargument name="email" value="#getUserContactQuery.email#">
				<cfinvokeargument name="family_name" value="#getUserContactQuery.family_name#">
				<cfinvokeargument name="name" value="#getUserContactQuery.name#">
				<cfinvokeargument name="address" value="#getUserContactQuery.address#">
				<cfinvokeargument name="mobile_phone" value="#getUserContactQuery.mobile_phone#">
				<cfinvokeargument name="organization" value="#getUserContactQuery.organization#">
				<cfinvokeargument name="telephone_ccode" value="#getUserContactQuery.telephone_ccode#">
				<cfinvokeargument name="mobile_phone_ccode" value="#getUserContactQuery.mobile_phone_ccode#">
				
				<cfinvokeargument name="return_type" value="#arguments.return_type#">
			</cfinvoke>

			<cfset xmlResponse = contact>	
			
		<cfelse><!---Contact does not exist--->
			
			<cfset error_code = 1201>
			
			<cfthrow errorcode="#error_code#">
				
		</cfif>
		
		<cfreturn xmlResponse>		
		
	</cffunction>
	
	
	<!--- ------------------------ SELECT USER CONTACT ------------------------------------ --->
	<cffunction name="selectContact" returntype="string" output="true" access="remote">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "selectContact">
		<cfset var contact_id = "">
		<cfset var user_id = "">
<cfset var client_abb = "">
<cfset var user_language = "">
	
<cfset var xmlRequest = "">
<cfset var xmlResponseContent = "">
	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset contact_id = xmlRequest.request.parameters.contact.xmlAttributes.id>
			
			<cfinvoke component="ContactManager" method="getContact" returnvariable="xmlResponseContent">
				<cfinvokeargument name="contact_id" value="#contact_id#">
				
				<cfinvokeargument name="return_type" value="xml">
			</cfinvoke>
				
			<cfinclude template="includes/functionEndNoLog.cfm">
		
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>		
		
	</cffunction>

	<!--- ----------------------- DELETE USER CONTACT -------------------------------- --->
	
	<cffunction name="deleteContact" returntype="string" output="false" access="remote">
		<cfargument name="request" type="string" required="yes">
		<!---<cfargument name="id" type="string" required="yes">--->		
		
		<cfset var method = "deleteContact">
		<cfset var id = "">
		<cfset var user_id = "">
<cfset var client_abb = "">
<cfset var user_language = "">
	
<cfset var xmlRequest = "">
<cfset var xmlResponseContent = "">
	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset id = xmlRequest.request.parameters.contact.xmlAttributes.id>
		
		
			<!--- DELETE USER CONTACT --->
			<cfquery name="deleteQuery" datasource="#client_dsn#">	
				DELETE FROM #client_abb#_contacts
				WHERE id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
			</cfquery>	
			
			<!---<cfreturn "#id#">--->
		
			<cfset xmlResponseContent = '<contact id="#id#"/>'>
		
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
				
	</cffunction>
	
	<!--- ----------------------------------------------------------------------- --->
	
	<!--- ----------------------- CREATE USER CONTACT -------------------------------- --->
	
	<cffunction name="createContact" returntype="string" output="false" access="remote">
		<cfargument name="request" type="string" required="yes">

		<cfset var method = "createContact">
		
		<cfset var user_id = "">
<cfset var client_abb = "">
<cfset var user_language = "">
	
<cfset var xmlRequest = "">
<cfset var xmlResponseContent = "">
	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinvoke component="ContactManager" method="objectContact" returnvariable="objectContact">
					<cfinvokeargument name="xml" value="#xmlRequest.request.parameters.contact#">
					
					<cfinvokeargument name="return_type" value="object">
			</cfinvoke>
			
			<cfset objectContact.user_id = user_id>
			
			<!---<cfquery name="beginQuery" datasource="#client_dsn#">
				BEGIN;
			</cfquery>--->
			
			<!--- CREATE USER CONTACT --->
			<cfquery name="createQuery" datasource="#client_dsn#" result="insertContactResult">	
				INSERT INTO #client_abb#_contacts
				(user_id,name,family_name,telephone,address,email, mobile_phone, organization, telephone_ccode, mobile_phone_ccode)
				VALUES(<cfqueryparam value="#objectContact.user_id#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#objectContact.name#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#objectContact.family_name#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#objectContact.telephone#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#objectContact.address#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#objectContact.email#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#objectContact.mobile_phone#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#objectContact.organization#" cfsqltype="cf_sql_varchar">,
						<cfif len(objectContact.telephone) GT 0>
							<cfqueryparam value="#objectContact.telephone_ccode#" cfsqltype="cf_sql_integer">,
						<cfelse>
							<cfqueryparam null="yes" cfsqltype="cf_sql_numeric">,
						</cfif>
						<cfif len(objectContact.mobile_phone) GT 0>
							<cfqueryparam value="#objectContact.mobile_phone_ccode#" cfsqltype="cf_sql_integer">
						<cfelse>
							<cfqueryparam null="yes" cfsqltype="cf_sql_numeric">
						</cfif>
						);				
			</cfquery>
			<!---<cfset objectContact.id = insertContactResult.GENERATED_KEY>--->
			<cfquery name="getLastInsertId" datasource="#client_dsn#">
				SELECT LAST_INSERT_ID() AS last_insert_id FROM #client_abb#_contacts;
			</cfquery>
			<cfset objectContact.id = getLastInsertId.last_insert_id>	
			
			<cfif len(objectContact.mobile_phone) IS 0>
				<cfset objectContact.mobile_phone_ccode = "">
			</cfif>
			
			<!---<cfquery name="endQuery" datasource="#client_dsn#">
				COMMIT;
			</cfquery>--->
			
			<!---<cfquery name="selectQuery" datasource="#client_dsn#">
				SELECT *
				FROM #client_abb#_contacts
				WHERE id = #returnValue#;
			</cfquery>	
			<cfinvoke component="ContactManager" method="objectContact" returnvariable="contact">
				<cfinvokeargument name="id" value="#selectQuery.id#">
				<cfinvokeargument name="user_id" value="#selectQuery.user_id#">
				<cfinvokeargument name="telephone" value="#selectQuery.telephone#">
				<cfinvokeargument name="email" value="#selectQuery.email#">
				<cfinvokeargument name="family_name" value="#selectQuery.family_name#">
				<cfinvokeargument name="name" value="#selectQuery.name#">
				<cfinvokeargument name="address" value="#selectQuery.address#">
				<cfinvokeargument name="mobile_phone" value="#selectQuery.mobile_phone#">
				<cfinvokeargument name="organization" value="#selectQuery.organization#">
			</cfinvoke>--->
			
			<cfinvoke component="ContactManager" method="xmlContact" returnvariable="xmlResult">
				<cfinvokeargument name="objectContact" value="#objectContact#">
			</cfinvoke>

			<cfset xmlResponseContent = xmlResult>
		
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
				
	</cffunction>
	
	<!--- ----------------------------------------------------------------------- --->

	

	<!--- ++++++++++++++++++++++++++++ UPDATE USER CONTACT ++++++++++++++++++++++++++++++++ --->
	<cffunction name="updateContact" returntype="string" output="false" access="remote">
		<cfargument name="request" type="string" required="yes">
		<!---<cfargument name="contact" type="string" required="yes">--->
		
		<cfset var method = "updateContact">
		<cfset var user_id = "">
<cfset var client_abb = "">
<cfset var user_language = "">
	
<cfset var xmlRequest = "">
<cfset var xmlResponseContent = "">
	
		<!---<cfset var contactXml = XMLNew()>--->
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
		
			<cfxml variable="contactXml">
				<cfoutput>
				#xmlRequest.request.parameters.contact#
				</cfoutput>
			</cfxml>
			
			<!---<cfset contactXml = xmlRequest.request.parameters.contact>--->
			
			<cfquery datasource="#client_dsn#" name="beginQuery">
				BEGIN;
			</cfquery>
			
			<cfif isDefined("contactXml.contact.XmlAttributes.telephone")>
				<cfquery name="telephoneQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_contacts SET telephone = <cfqueryPARAM value = "#contactXml.contact.XmlAttributes.telephone#" CFSQLType = "CF_SQL_varchar">
					WHERE id = <cfqueryPARAM value = "#contactXml.contact.XmlAttributes.id#" CFSQLType = "CF_SQL_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("contactXml.contact.name")>
				<cfquery name="nameQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_contacts SET name=<cfqueryPARAM value="#contactXml.contact.name.xmlText#" CFSQLType="CF_SQL_varchar">
					WHERE id = <cfqueryPARAM value="#contactXml.contact.XmlAttributes.id#" CFSQLType="CF_SQL_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("contactXml.contact.family_name")>
				<cfquery name="familyNameQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_contacts SET family_name = <cfqueryPARAM value = "#contactXml.contact.family_name.xmlText#" CFSQLType="CF_SQL_varchar">
					WHERE id = <cfqueryPARAM value="#contactXml.contact.XmlAttributes.id#" CFSQLType="CF_SQL_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("contactXml.contact.address")>
				<cfquery name="addressQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_contacts SET address = <cfqueryPARAM value = "#contactXml.contact.address.xmlText#" CFSQLType = "CF_SQL_varchar">
					WHERE id = <cfqueryPARAM value = "#contactXml.contact.XmlAttributes.id#" CFSQLType = "CF_SQL_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("contactXml.contact.XmlAttributes.email")>
				<cfquery name="emailQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_contacts SET email = <cfqueryPARAM value = "#contactXml.contact.XmlAttributes.email#" CFSQLType = "CF_SQL_varchar">
					WHERE id = <cfqueryPARAM value = "#contactXml.contact.XmlAttributes.id#" CFSQLType = "CF_SQL_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("contactXml.contact.XmlAttributes.mobile_phone")>
				<cfquery name="mobile_phoneQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_contacts SET mobile_phone = <cfqueryPARAM value = "#contactXml.contact.XmlAttributes.mobile_phone#" CFSQLType = "CF_SQL_varchar">
					WHERE id = <cfqueryPARAM value = "#contactXml.contact.XmlAttributes.id#" CFSQLType = "CF_SQL_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("contactXml.contact.organization")>
				<cfquery name="organizationQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_contacts SET organization = <cfqueryPARAM value = "#contactXml.contact.organization.xmlText#" CFSQLType = "CF_SQL_varchar">
					WHERE id = <cfqueryPARAM value="#contactXml.contact.XmlAttributes.id#" CFSQLType = "CF_SQL_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("contactXml.contact.XmlAttributes.telephone_ccode")>
				<cfquery name="telephoneCcodeQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_contacts SET telephone_ccode = <cfqueryPARAM value = "#contactXml.contact.XmlAttributes.telephone_ccode#" cfsqltype="cf_sql_integer">
					WHERE id = <cfqueryparam value="#contactXml.contact.XmlAttributes.id#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("contactXml.contact.XmlAttributes.mobile_phone_ccode")>
				<cfquery name="mobilePhoneCcodeQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_contacts SET mobile_phone_ccode = <cfqueryPARAM value = "#contactXml.contact.XmlAttributes.mobile_phone_ccode#" cfsqltype="cf_sql_integer">
					WHERE id = <cfqueryparam value="#contactXml.contact.XmlAttributes.id#" cfsqltype="cf_sql_integer">;
				</cfquery>
			</cfif>
			
			<cfquery datasource="#client_dsn#" name="endQuery">
				COMMIT;
			</cfquery>
			
			<cfquery name="selectQuery" datasource="#client_dsn#">
				SELECT *
				FROM #client_abb#_contacts
				WHERE id = <cfqueryPARAM value = "#contactXml.contact.XmlAttributes.id#" CFSQLType="CF_SQL_integer">;
			</cfquery>
			
			<cfinvoke component="ContactManager" method="objectContact" returnvariable="contact">
				<cfinvokeargument name="id" value="#selectQuery.id#">
				<cfinvokeargument name="user_id" value="#selectQuery.user_id#">
				<cfinvokeargument name="telephone" value="#selectQuery.telephone#">
				<cfinvokeargument name="email" value="#selectQuery.email#">
				<cfinvokeargument name="family_name" value="#selectQuery.family_name#">
				<cfinvokeargument name="name" value="#selectQuery.name#">
				<cfinvokeargument name="address" value="#selectQuery.address#">
				<cfinvokeargument name="mobile_phone" value="#selectQuery.mobile_phone#">
				<cfinvokeargument name="organization" value="#selectQuery.organization#">
				<cfinvokeargument name="telephone_ccode" value="#selectQuery.telephone_ccode#">
				<cfinvokeargument name="mobile_phone_ccode" value="#selectQuery.mobile_phone_ccode#">
			</cfinvoke>
	
			<cfinvoke component="ContactManager" method="xmlContact" returnvariable="xmlResult">
				<cfinvokeargument name="objectContact" value="#contact#">
			</cfinvoke>
			
			<cfset xmlResponseContent = xmlResult>
			
			<cfinclude template="includes/functionEnd.cfm">
		
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
</cfcomponent>