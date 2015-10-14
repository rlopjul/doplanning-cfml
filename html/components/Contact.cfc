<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 25-11-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 26-02-2008

--->
<cfcomponent output="true">

	<cfset component = "Contact">
	<cfset request_component = "ContactManager">


	<cffunction name="selectContact" returntype="xml" output="false" access="public">
		<cfargument name="contact_id" type="string" required="true">

		<cfset var method = "selectContact">

		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">

		<cftry>

			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<contact id="#arguments.contact_id#"/>
				</cfoutput>
			</cfsavecontent>

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


	<!--- ----------------------------------- getContact ------------------------------------- --->

	<cffunction name="getContact" output="false" returntype="struct" access="public">
		<cfargument name="contact_id" type="numeric" required="true">

		<cfset var method = "getContact">

		<cfset var objectUser = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/ContactManager" method="getContact" returnvariable="objectContact">
				<cfinvokeargument name="contact_id" value="#arguments.contact_id#">
				<cfinvokeargument name="return_type" value="object">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn objectContact>

	</cffunction>


	<cffunction name="createContact" returntype="void" output="false" access="remote">
		<cfargument name="family_name" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="telephone" type="string" required="true">
		<cfargument name="telephone_ccode" type="string" required="true">
		<cfargument name="mobile_phone" type="string" required="true">
		<cfargument name="mobile_phone_ccode" type="string" required="true">
		<cfargument name="address" type="string" required="true">
		<cfargument name="organization" type="string" required="true">

		<cfset var method = "createContact">

		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">

		<cftry>

			<cfset response_page = "contacts.cfm">

			<cfif len(arguments.email) IS 0 OR NOT isValid("email",arguments.email)>

				<cfset message = "Debe introducir un email válido.">
				<cfset message = URLEncodedFormat(message)>
				<cflocation url="#APPLICATION.htmlPath#/contact.cfm?message=#message#" addtoken="no">

			</cfif>

			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<contact
					email="#arguments.email#"
					mobile_phone_ccode="#arguments.mobile_phone_ccode#"
					mobile_phone="#arguments.mobile_phone#"
					telephone_ccode="#arguments.telephone_ccode#"
					telephone="#arguments.telephone#">
						<family_name><![CDATA[#arguments.family_name#]]></family_name>
						<name><![CDATA[#arguments.name#]]></name>
						<address><![CDATA[#arguments.address#]]></address>
						<organization><![CDATA[#arguments.organization#]]></organization>
					</contact>
				</cfoutput>
			</cfsavecontent>

			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>

			<cfset message = "Contacto guardado.">
			<cfset message = URLEncodedFormat(message)>

            <cflocation url="#APPLICATION.htmlPath#/#response_page#?message=#message#" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn xmlResponse>

	</cffunction>


	<cffunction name="updateContact" returntype="void" output="false" access="remote">
		<cfargument name="id" type="string" required="true">
		<cfargument name="family_name" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="telephone" type="string" required="true">
		<cfargument name="telephone_ccode" type="string" required="true">
		<cfargument name="mobile_phone" type="string" required="true">
		<cfargument name="mobile_phone_ccode" type="string" required="true">
		<cfargument name="address" type="string" required="true">
		<cfargument name="organization" type="string" required="true">

		<cfset var method = "updateContact">

		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">

		<cftry>

			<cfset response_page = "contacts.cfm">

			<cfif len(arguments.email) IS 0 OR NOT isValid("email",arguments.email)>

				<cfset message = "Debe introducir un email válido.">
				<cfset message = URLEncodedFormat(message)>
				<cflocation url="#APPLICATION.htmlPath#/contact.cfm?message=#message#" addtoken="no">

			</cfif>

			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<contact
					id="#arguments.id#"
					email="#arguments.email#"
					mobile_phone_ccode="#arguments.mobile_phone_ccode#"
					mobile_phone="#arguments.mobile_phone#"
					telephone_ccode="#arguments.telephone_ccode#"
					telephone="#arguments.telephone#">
						<family_name><![CDATA[#arguments.family_name#]]></family_name>
						<name><![CDATA[#arguments.name#]]></name>
						<address><![CDATA[#arguments.address#]]></address>
						<organization><![CDATA[#arguments.organization#]]></organization>
					</contact>
				</cfoutput>
			</cfsavecontent>

			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>

			<cfset message = "Contacto modificado.">
			<cfset message = URLEncodedFormat(message)>

            <cflocation url="#APPLICATION.htmlPath#/#response_page#?message=#message#" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn xmlResponse>

	</cffunction>


	<cffunction name="deleteContact" returntype="void" access="remote">
		<cfargument name="contact_id" type="string" required="true">

		<cfset var method = "deleteContact">

		<cfset var request_parameters = "">

		<cftry>

			<cfset response_page = "contacts.cfm">

			<cfif len(arguments.contact_id) IS 0 OR NOT isValid("integer",arguments.contact_id)>

				<cfset message = "Contacto incorrecto.">
				<cfset message = URLEncodedFormat(message)>
				<cflocation url="#APPLICATION.htmlPath#/#response_page#?message=#message#" addtoken="no">

			</cfif>

			<cfset request_parameters = '<contact id="#arguments.contact_id#"/>'>

			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>

			<cfset message = "Contacto eliminado.">
			<cfset message = URLEncodedFormat(message)>

            <cflocation url="#APPLICATION.htmlPath#/#response_page#?message=#message#" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

	</cffunction>



</cfcomponent>
