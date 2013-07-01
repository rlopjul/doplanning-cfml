<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 15-09-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 14-07-2009
	
--->
<cfcomponent output="false">

	<cfset component = "SMSManager">
	
	
	<!--- ----------------------- XML SMS -------------------------------- --->
	
	<cffunction name="xmlSMS" returntype="string" access="public">		
		<cfargument name="objectSMS" type="struct" required="yes">
		
		<cfset var method = "xmlSMS">
		
		<cftry>
			
			<cfsavecontent variable="xmlResult">
				<cfoutput>
					<sms 
						<cfif len(objectSMS.id) GT 0>
							id="#objectSMS.id#"
						</cfif>
						<cfif len(objectSMS.user_id) GT 0>
							user_id="#objectSMS.user_id#"
						</cfif>
						<cfif len(objectSMS.date) GT 0>
							date="#objectSMS.date#"
						</cfif>
						<cfif len(objectSMS.msgid) GT 0>
							msgid="#objectSMS.msgid#"
						</cfif>
						<cfif len(objectSMS.recipients) GT 0>
							recipients="#objectSMS.recipients#"
						</cfif>
						>
						<cfif len(objectSMS.text) GT 0>
							<text><![CDATA[#objectSMS.text#]]></text>
						</cfif>
						<cfif len(objectSMS.response) GT 0>
							<response><![CDATA[#objectSMS.response#]]></response>
						</cfif>
					</sms>
				</cfoutput>
			</cfsavecontent>
			
			<cfreturn xmlResult>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	
	<!--- ----------------------- SMS OBJECT -------------------------------- --->
	
	<cffunction name="objectSMS" returntype="any" output="false" access="public">	
		
		<cfargument name="xml" type="string" required="no">
		
		<cfargument name="id" type="string" required="no" default="">
		<cfargument name="user_id" type="string" required="no" default="">
		<cfargument name="date" type="string" required="no" default="">
		<cfargument name="msgid" type="string" required="no" default="">
		<cfargument name="recipients" type="string" required="no" default="">
		<cfargument name="text" type="string" required="no" default="">
		<cfargument name="response" type="string" required="no" default="">
		
		<cfargument name="return_type" type="string" required="no">
		
		<cfset var method = "objectSMS"> 
		
		<cftry>
			
			
			<cfif isDefined("arguments.xml")>
			
				<cfxml variable="xmlSMS">
				<cfoutput>
				#xml#
				</cfoutput>
				</cfxml>
			
				<cfif isDefined("xmlSMS.sms.xmlAttributes.id")>
					<cfset id = xmlSMS.sms.XmlAttributes.id>
				</cfif>
				<cfif isDefined("xmlSMS.sms.xmlAttributes.user_id")>
					<cfset user_id = xmlSMS.sms.xmlAttributes.user_id>
				</cfif>
				<cfif isDefined("xmlSMS.sms.xmlAttributes.date")>
					<cfset date = xmlSMS.sms.xmlAttributes.date>
				</cfif>
				<cfif isDefined("xmlSMS.sms.xmlAttributes.msgid")>
					<cfset msgid = xmlSMS.sms.xmlAttributes.msgid>
				</cfif>
				<cfif isDefined("xmlSMS.sms.xmlAttributes.recipients")>
					<cfset recipients = xmlSMS.sms.xmlAttributes.recipients>
				</cfif>
				<cfif isDefined("xmlSMS.sms.text.xmlText")>
					<cfset text = xmlSMS.sms.text.xmlText>
				</cfif>
				<cfif isDefined("xmlSMS.sms.response.xmlText")>
					<cfset description = xmlSMS.sms.response.xmlText>
				</cfif>
			
			<cfelseif NOT isDefined("arguments.id")>
				
				<cfreturn null>
				
			</cfif>
			
			<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringDate">
				<cfinvokeargument name="timestamp_date" value="#date#">
			</cfinvoke>
			<cfset date = stringDate>
			
			
			<cfset object = {
				id="#id#",
				user_id="#user_id#",
				date="#date#",
				msgid="#msgid#",
				recipients="#recipients#",
				text="#text#",
				response="#response#"
				}>
				
			
			<cfif isDefined("arguments.return_type")>
			
				<cfif arguments.return_type EQ "object">
				
					<cfreturn object>
					
				<cfelseif arguments.return_type EQ "xml">
				
					<cfinvoke component="SMSManager" method="xmlSMS" returnvariable="xmlResult">
						<cfinvokeargument name="objectSMS" value="#object#">
					</cfinvoke>
					<cfreturn xmlResult>
					
				<cfelse>
					
					<cfreturn object>
					
				</cfif>
				
			<cfelse>
			
				<cfreturn object>
				
			</cfif>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>
		</cftry>
		
	</cffunction>


	<!--- ----------------------- SEND SMS NEW -------------------------------- --->
	
	<!---Método que deberá permitir enviar SMS sin tener que pasar request, solo con pasar directamente los parámetros, además de que access deberá ser public--->
	
	<cffunction name="sendSMSNew" returntype="string" output="true" access="public">
		<!---<cfargument name="request" type="string" required="yes">--->
		<cfargument name="text" type="string" required="yes">
		<cfargument name="recipients" type="String" required="yes">			
		
		<cfset var method = "sendSMSNew">
		
		<!---<cfset var text = "">
		<cfset var recipient = "">--->
		
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfsavecontent variable="sendSMSRequest">
				<cfoutput>
					<request>
					<parameters>
					<sms recipients="#arguments.recipients#">
						<text><![CDATA[#arguments.text#]]></text>
					</sms>
					</parameters>
					</request>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="SMSManager" method="sendSMS" returnvariable="xmlResponse">
				<cfinvokeargument name="request" value="#sendSMSRequest#">	
			</cfinvoke>
					
			<!---<cfinclude template="includes/functionEnd.cfm">--->
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
	
		<cfreturn xmlResponse>
		
		
	</cffunction>

	<!--- ----------------------- SEND SMS -------------------------------- --->
	
	<cffunction name="sendSMS" returntype="string" output="true" access="public">
		<cfargument name="request" type="string" required="yes">
		<!---<cfargument name="text" type="string" required="yes">
		<cfargument name="recipient" type="String" required="yes">--->			
		
		<cfset var method = "sendSMS">
		
		<cfset var text = "">
		<cfset var recipient = "">
		
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<!---check if the user logged in already exist--->
			<cfquery name="checkUser" datasource="#client_dsn#">
				SELECT * FROM #client_abb#_users
				WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			<cfif checkUser.recordCount IS 0><!---The user does not exist--->
				<cfset error_code = 204>
				
				<cfthrow errorcode="#error_code#"> 
			<cfelseif checkUser.sms_allowed IS NOT true>
				<cfset error_code = 103>
				
				<cfthrow errorcode="#error_code#"> 
			</cfif>
			
			
			<cfset text = xmlRequest.request.parameters.sms.text.xmlText>
			<cfset recipient = xmlRequest.request.parameters.sms.xmlAttributes.recipients>
		
			<cfquery name="checkNumber" datasource="#APPLICATION.dsn#">
				SELECT number_of_sms_used, number_of_sms_paid
				FROM APP_clients
				WHERE abbreviation = <cfqueryPARAM value = "#client_abb#" CFSQLType = "CF_SQL_varchar">			
			</cfquery>
			
			<cfset num_sms = listLen(recipient,";")><!---ColdFusion ignores empty list elements--->
			
			<cfset num_sms_total = checkNumber.number_of_sms_used+num_sms>
								
			<cfif num_sms_total LTE checkNumber.number_of_sms_paid>
				
				<cfset response=''>
				
				<cfif APPLICATION.identifier EQ "dp">
				
					<!---Envio de SMS por defecto--->
					<cfhttp url="#APPLICATION.smsServerAddress#" method="POST" resolveurl="false" > 
						<cfhttpparam type="formfield" name="Correo" value="#APPLICATION.smsUserName#"> 
						<cfhttpparam type="FORMfield" name="Passwd" value="#APPLICATION.smsPassword#"> 
						<!---<cfhttpparam type="FORMfield" name="Remitente" value="#APPLICATION.smsFrom#">--->
						<cfhttpparam type="FORMfield" name="Remitente" value="#SESSION.client_id#"> 
						<cfhttpparam type="FORMfield" name="Destinatarios" value="#recipient#"> 
						<cfhttpparam type="FORMfield" name="Mensaje" value="#text#"> 
						<cfhttpparam type="FORMfield" name="Flash" value="0"> 
						<cfhttpparam type="FORMfield" name="Report" value="1"> 
						<cfhttpparam type="FORMfield" name="Descuento" value="0"> 
						<cfhttpparam type="FORMfield" name="EmailReport" value="#APPLICATION.smsReportAddress#"> 
					</cfhttp>
					
				<cfelseif APPLICATION.identifier EQ "vpnet">
				
					<!---Envío de SMS de Pozoblanco--->
					<cfloop index="recipient_number" list="#recipient#" delimiters=";">
						<cfhttp url="#APPLICATION.smsServerAddress#" method="get" resolveurl="false" timeout="40" charset="utf-8"> 
							<cfhttpparam type="url" name="id_emisor" value="asnc"> 
							<cfhttpparam type="url" name="clave" value="#APPLICATION.smsPassword#"> 
							<!---<cfhttpparam type="FORMfield" name="Remitente" value="#APPLICATION.smsFrom#">---> 
							<cfhttpparam type="url" name="destino" value="#recipient_number#"> 
							<cfhttpparam type="url" name="texto" value="#text#">
							<cfhttpparam type="url" name="prioridad" value="0">  
							<cfhttpparam type="url" name="recibo" value="0">
							<cfhttpparam type="url" name="usuario" value="#APPLICATION.smsUserName#"> 
							<!---<cfhttpparam type="FORMfield" name="EmailReport" value="#APPLICATION.smsReportAddress#">---> 
						</cfhttp>
					</cfloop>
					
				</cfif>
				
				<cfquery name="updateSMSUsed" datasource="#APPLICATION.dsn#">
					UPDATE APP_clients
					SET number_of_sms_used = <cfqueryparam value="#num_sms_total#" cfsqltype="cf_sql_integer">
					WHERE abbreviation = <cfqueryPARAM value = "#client_abb#" CFSQLType = "CF_SQL_varchar">;
				</cfquery>
				
				<cfset msgid=''>	
				<cfset blau=''>		
				
				<cfinvoke component="DateManager" method="getCurrentDateTime" returnvariable="current_date">
				</cfinvoke>	
							
				<cftransaction>
													
				<cfquery name="insertSMSQuery" datasource="#client_dsn#" result="insertSMSQueryResult">		
					INSERT INTO #client_abb#_sms (text,user_id,recipients,response,msgid,date) 
						VALUES(
						<cfqueryPARAM value = "#text#" CFSQLType = "CF_SQL_varchar">,
						<cfqueryPARAM value = "#user_id#" CFSQLType="cf_sql_integer">,					
						<cfqueryPARAM value = "#recipient#" CFSQLType = "CF_SQL_varchar">,
						<cfqueryPARAM value = "#blau#" CFSQLType = "CF_SQL_varchar">,
						<cfqueryPARAM value = "#msgid#" CFSQLType = "CF_SQL_varchar">,
						<cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">						
					);			
				</cfquery>	
				
				<!---<cfset returnValue = insertSMSQueryResult.GENERATED_KEY>--->
				<cfquery name="getLastInsertId" datasource="#client_dsn#">
					SELECT LAST_INSERT_ID() AS last_insert_id FROM #client_abb#_sms;
				</cfquery>
				</cftransaction>
				
				<cfset returnValue = getLastInsertId.last_insert_id>						
				
			
			<cfelse><!---SMS limit reached--->
				
				<cfset error_code = 510>
				<cfthrow errorcode="#error_code#">
			
			</cfif>		
			
			<cfset xmlResponseContent = '<sms id="#returnValue#"/>'>
					
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
	
		<cfreturn xmlResponse>
		
		
	</cffunction>

	
	<cffunction name="getUserSMS" returntype="string" access="public">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "getUserSMS">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinvoke component="RequestManager" method="createRequest" returnvariable="getSMSesRequest">
				<cfinvokeargument name="request_parameters" value='<user id="#user_id#"/>'>
			</cfinvoke>
			
			<cfinvoke component="SMSManager" method="getSMSes" returnvariable="responseGetSMSes">
				<cfinvokeargument name="request" value="#getSMSesRequest#">
			</cfinvoke>
			
			<cfxml variable="xmlResponse">
			<cfoutput>
				#responseGetSMSes#
			</cfoutput>
			</cfxml>
		
			<cfset xmlResponse.response.xmlAttributes.component = component>
			<cfset xmlResponse.response.xmlAttributes.method = method>
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	<!----------------------------------------- getUsersSMSSent -------------------------------------------------->
	
	<cffunction name="getUsersSMSSent" returntype="string" access="public">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "getUsersSMSSent">
		
		<cfset var xmlResult = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinclude template="includes/checkAdminAccess.cfm">
			
			<!--- ORDER --->
			<cfif isDefined("xmlRequest.request.parameters.order")>
		
				<cfset order_by = xmlRequest.request.parameters.order.xmlAttributes.parameter>
				
				<cfif order_by EQ "sms_id">
					<cfset order_by = "id">
				</cfif>
				
				<cfset order_type = xmlRequest.request.parameters.order.xmlAttributes.order_type>
			
			<cfelse>
			
				<cfset order_by = "smses_sent">
				<cfset order_type = "desc">
			
			</cfif>

			<cfquery datasource="#client_dsn#" name="getAllSMSes">
            	SELECT count(*) as total_sms
                FROM #client_abb#_sms
            </cfquery>
            
			<cfquery datasource="#client_dsn#" name="getUsersSMSesQuery">
				SELECT count(*) AS smses_sent, user_id
				FROM #client_abb#_sms AS s
				GROUP BY user_id
				ORDER BY #order_by# #order_type#
			</cfquery>
			
			<cfset xmlResult = '<users total_sms_sent="#getAllSMSes.total_sms#">'>
			
			<cfif getUsersSMSesQuery.RecordCount GT 0>
				<cfloop query="getUsersSMSesQuery">
					<cfset xmlUser = '<user id="#getUsersSMSesQuery.user_id#" smses_sent="#getUsersSMSesQuery.smses_sent#"/>'>
					<cfset xmlResult = xmlResult&xmlUser>
				</cfloop>
			</cfif>
			
			<cfset xmlResponseContent = xmlResult&"</users>">
	
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	<cffunction name="getSMSes" returntype="string" access="public">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "getSMSes">
		
		<cfset var xmlResult = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfif NOT isDefined("xmlRequest.request.parameters.group")>
				
				<cfquery datasource="#client_dsn#" name="getSMSQuery">
					SELECT *
					FROM #client_abb#_sms
					<cfif isDefined("xmlRequest.request.parameters.user.xmlAttributes.id")>
					WHERE user_id = <cfqueryparam value="#xmlRequest.request.parameters.user.xmlAttributes.id#" cfsqltype="cf_sql_integer">
					</cfif>	
					<cfif isDefined("xmlRequest.request.parameters.order")>
					ORDER BY #xmlRequest.request.parameters.order.xmlAttributes.parameter# #xmlRequest.request.parameters.order.xmlAttributes.order_type#
					</cfif>
				</cfquery>
				
				<cfset xmlResult = '<smses count="#getSMSQuery.RecordCount#">'>
						
				<cfif getSMSQuery.RecordCount GT 0>
					<cfloop query="getSMSQuery">
						<cfinvoke component="SMSManager" method="objectSMS" returnvariable="xmlResultSMS">
							<cfinvokeargument name="id" value="#getSMSQuery.id#">
							<cfinvokeargument name="user_id" value="#getSMSQuery.user_id#">
							<cfinvokeargument name="date" value="#getSMSQuery.date#">
							<cfinvokeargument name="msgid" value="#getSMSQuery.msgid#">
							<cfinvokeargument name="recipients" value="#getSMSQuery.recipients#">
							<cfinvokeargument name="text" value="#getSMSQuery.text#">
							<cfinvokeargument name="response" value="#getSMSQuery.response#">
							
							<cfinvokeargument name="return_type" value="xml">
						</cfinvoke>
						<cfset xmlResult = xmlResult&xmlResultSMS>
					</cfloop>				
				</cfif>
	
				<cfset xmlResult = xmlResult&'</smses>'>
									
				
				
			<cfelse><!---List smses group by user--->
				
				<cfquery datasource="#client_dsn#" name="getAllUsersQuery">
					SELECT *
					FROM #client_abb#_users
				</cfquery>
				<!---ORDER BY #order_by# #order_type#;--->
				
		
					<cfset xmlResult = '<users_smses>'>
						
						<cfloop query="getAllUsersQuery">
							<cfset query_user_id = getAllUsersQuery.id>
							
							<cfinvoke component="RequestManager" method="createRequest" returnvariable="getSMSesRequest">
								<cfinvokeargument name="request_parameters" value='<user id="#query_user_id#"/>'>
							</cfinvoke>
							
							<cfinvoke component="SMSManager" method="getSMSes" returnvariable="userSMSes">
								<cfinvokeargument name="request" value="#getSMSesRequest#">
							</cfinvoke>
							
							<cfxml variable="xmlUserSMSes">
							<cfoutput>
							#userSMSes#
							</cfoutput>
							</cfxml>
							
							
							
							<cfset xmlResult = xmlResult&'<user id="#query_user_id#">'>
							<cfset xmlResult = xmlResult&xmlUserSMSes.response.result.smses>
							<cfset xmlResult = xmlResult&'</user>'>
						
						</cfloop>
							
					<cfset xmlResult = xmlResult&'</users_smses>'>
						
				
			</cfif>
			
			<cfset xmlResponseContent = xmlResult>
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
</cfcomponent>