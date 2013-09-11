<cfif SESSION.client_administrator EQ SESSION.user_id>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>IMPORTAR USUARIOS</title>
</head>

<body>

<cfif isDefined("FORM.area_id")>


	<cfset client_abb = SESSION.client_abb>
	
	<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>
	
	<cfset add_to_area_id = FORM.area_id>

	<cfquery datasource="#APPLICATION.dsn#" name="getClient">
		SELECT *
		FROM APP_clients
		WHERE abbreviation = <cfqueryparam value="#client_abb#" cfsqltype="cf_sql_varchar">;
	</cfquery>

	<cfif getClient.recordCount IS 0>
		<cfthrow message="Error al obtener el cliente: #client_abb#">
	</cfif>
	
	<cfoutput>
	CLIENTE: #getClient.name#<br/>
	ÁREA por defecto: #add_to_area_id#<br/><br/>
	</cfoutput>
	


	<cfquery datasource="#client_dsn#" name="getUsersToImport">
		SELECT *
		FROM #client_abb#_users_to_import;
	</cfquery>

	<cfloop query="getUsersToImport">
		
		<cfinvoke component="#APPLICATION.componentsPath#/LoginManager" method="generatePassword" returnvariable="newPassword">
			<cfinvokeargument name="numberofCharacters" value="5">
		</cfinvoke>

		<!--- <cfoutput>#newPassword#<br/></cfoutput> --->

		<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="xmlUser">
			<cfinvokeargument name="name" value="#getUsersToImport.family_name_1# #getUsersToImport.family_name_2#">
			<cfinvokeargument name="family_name" value="#getUsersToImport.name#">
			<cfinvokeargument name="email" value="#Trim(getUsersToImport.login)#">
			<!---<cfinvokeargument name="telephone" value="">
			<cfinvokeargument name="telephone_ccode" value="">
			<cfinvokeargument name="mobile_phone" value="">
			<cfinvokeargument name="mobile_phone_ccode" value="">--->
			<cfinvokeargument name="password" value="#hash(newPassword)#"/>
			<cfinvokeargument name="password_temp" value="#newPassword#"/>
			<cfinvokeargument name="login_ldap" value="#Trim(getUsersToImport.login_dmsas)#"/>
			<cfinvokeargument name="login_diraya" value="#Trim(getUsersToImport.login_diraya)#"/>
			<cfinvokeargument name="dni" value="#getUsersToImport.nif#"/>
			<cfinvokeargument name="address" value="#getUsersToImport.address#"/>
			<cfinvokeargument name="sms_allowed" value="false">
			<cfinvokeargument name="whole_tree_visible" value="true">
			
			<cfinvokeargument name="return_type" value="xml">
		</cfinvoke>

		<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="createRequest" returnvariable="createUserRequest">
			<cfinvokeargument name="request_parameters" value='#xmlUser#'>
		</cfinvoke>

		<cfdump var="#createUserRequest#"/>
		
		<!---createUser--->
		<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="createUser" returnvariable="createUserResponse">
			<cfinvokeargument name="request" value="#createUserRequest#">
		</cfinvoke>

		<cfxml variable="userResponseXml">
			<cfoutput>
			#createUserResponse#
			</cfoutput>
		</cfxml>

		<!---Si la respuesta es un error--->
		<cfif isDefined("userResponseXml.response.error.xmlAttributes.code") AND isValid("integer",userResponseXml.response.error.xmlAttributes.code)>
			
			<cfoutput>
			<strong>Error al crear el usuario con email #getUsersToImport.login#: #userResponseXml.response.error.xmlAttributes.code#</strong><br/>
			</cfoutput>

		<cfelse>

			<cfset created_user_id = userResponseXml.response.result.user.xmlAttributes.id>

			<cfoutput>
			Usuario con email #getUsersToImport.login# creado correctamente con ID: #created_user_id#<br/>
			</cfoutput>


			<!---assign User To Root Area--->
			<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="createRequest" returnvariable="assignUserToAreaRequest">
				<cfinvokeargument name="request_parameters" value='<user id="#created_user_id#"/><area id="#add_to_area_id#"/>'>
			</cfinvoke>
		
			<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="assignUserToArea" returnvariable="assignToAreaResponse">
				<cfinvokeargument name="request" value="#assignUserToAreaRequest#">
			</cfinvoke>

			<cfxml variable="assignToAreaResponseXml">
				<cfoutput>
				#assignToAreaResponse#
				</cfoutput>
			</cfxml>

			<!---Si la respuesta es un error--->
			<cfif isDefined("assignToAreaResponseXml.response.error.xmlAttributes.code") AND isValid("integer",assignToAreaResponseXml.response.error.xmlAttributes.code)>

				<cfoutput>
				<strong>Error al añadir el usuario al área: #assignToAreaResponseXml.response.error.xmlAttributes.code#</strong><br/>
				</cfoutput>

			<cfelse>

				<cfoutput>
					Añadido al área #add_to_area_id#.<br/>
				</cfoutput>

			</cfif>


		</cfif>		
		

		<br/><br/>

	</cfloop>

	Importación terminada.<br/>
</cfif>
<br/>
<cfform method="post" action="#CGI.SCRIPT_NAME#">
	<!---<label>Client Abb</label>
	<cfinput type="text" name="abb" value="" required="true" message="Client abb requerido">--->
	<label>ID de área a la que añadir los usuarios</label>
	<cfinput type="text" name="area_id" value="5" validate="integer" required="true" message="Area a la que añadir los usuarios requerida"/>
	<cfinput type="submit" name="import" value="IMPORTAR USUARIOS">
</cfform>

</body>
</html>

</cfif>