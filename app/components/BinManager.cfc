<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "BinManager">


	<!--- ----------------GET ALL BIN ITEMS--------------------------------------------   --->
	
	<cffunction name="getAllBinItems" output="false" returntype="struct" access="public">
		<cfargument name="limit" type="numeric" required="false" default="50">
		<cfargument name="full_content" type="boolean" required="false" default="true">

		<cfargument name="delete_user_id" type="numeric" required="false">
		
		<cfset var method = "getAllBinItems">

		<cfset var response = structNew()>

		<cfset var userAreasIds = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!---checkAdminUser--->
			<cfif SESSION.user_id NEQ SESSION.client_administrator AND ( NOT isDefined("arguments.delete_user_id") OR arguments.delete_user_id NEQ SESSION.user_id ) >

				<cfset error_code = 106>
		
				<cfthrow errorcode="#error_code#">

			</cfif>
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="listAllAreaItems" returnvariable="getAreaItemsResult">
				<!---<cfinvokeargument name="areas_ids" value="#userAreasIds#">--->
				<cfinvokeargument name="limit" value="#arguments.limit#">
				<cfinvokeargument name="full_content" value="#arguments.full_content#">

				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="withConsultations" value="#APPLICATION.moduleConsultations#">
				<cfinvokeargument name="withPubmedsComments" value="#APPLICATION.modulePubMedComments#">
				<cfinvokeargument name="withLists" value="#APPLICATION.moduleLists#">
				<cfinvokeargument name="withForms" value="#APPLICATION.moduleForms#">
				<cfinvokeargument name="withDPDocuments" value="#APPLICATION.moduleDPDocuments#">
				<cfinvokeargument name="withArea" value="true">

				<cfinvokeargument name="status" value="deleted">

				<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">				
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, query=#getAreaItemsResult.query#}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>
	<!--- ------------------------------------------------------------------------------  --->



	<!---  -------------------------- restoreBinItem -------------------------------- --->
	
	<cffunction name="restoreBinItem" returntype="struct" access="public">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">

		<cfset var method = "restoreBinItem">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfif itemTypeId IS 10><!--- File --->

				<!--- getFile --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
					<cfinvokeargument name="file_id" value="#arguments.item_id#">
					<cfinvokeargument name="with_lock" value="false">
					<cfinvokeargument name="parse_dates" value="true">
					<cfinvokeargument name="ignore_status" value="true">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif fileQuery.recordCount IS 0><!---The file does not exist (is not found)--->
					
					<cfset error_code = 601>
					
					<cfthrow errorcode="#error_code#">
								
				</cfif>	

				<cfset fileTypeId = fileQuery.file_type_id>

				<!---checkAccess--->
				<cfif fileQuery.file_type_id IS 2 OR fileQuery.file_type_id IS 3><!---Area file (ALL area users can delete the file)--->
					
					<cfset area_id = fileQuery.area_id>

					<!---checkAreaAccess--->
					<cfinclude template="includes/checkAreaAccess.cfm">

				<cfelse><!--- User file --->
			
					<cfif fileQuery.user_in_charge NEQ user_id><!---El usuario del item no es el mismo que el que intenta eliminar--->

						<cfif isDefined("arguments.area_id")>
						
							<cfset area_id = arguments.area_id>

							<cfinclude template="includes/checkAreaAdminAccess.cfm">

						<cfelse>

							<cfinclude template="includes/checkAdminAccess.cfm">

						</cfif>

					</cfif>			

				</cfif>

				<!--- restoreBinItem --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/BinQuery" method="restoreBinItem" returnvariable="binItemsQuery">
					<cfinvokeargument name="item_id" value="#arguments.item_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>
				
			<cfelse><!--- Items --->

				<!--- getItem --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
					<cfinvokeargument name="item_id" value="#arguments.item_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="parse_dates" value="true">
					<cfinvokeargument name="published" value="false">
					
					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>
							
				<cfif itemQuery.recordCount GT 0>
					
					<!---checkAreaAccess--->
					<cfset area_id = itemQuery.area_id>
					
					<cfinclude template="includes/checkAreaAccess.cfm">
					
					<cfif itemQuery.user_in_charge NEQ user_id><!---El usuario del item no es el mismo que el que intenta eliminar--->

						<cfinclude template="includes/checkAreaAdminAccess.cfm">
					
					<cfelseif arguments.itemTypeId IS 7 AND itemQuery.state NEQ "created"><!---Consultations--->

						<!---Las consultas solo se pueden eliminar si están en estado creadas (enviadas)
						Los administradores sí pueden borrar las consultas cuando borran un área--->
						<cfinclude template="includes/checkAreaAdminAccess.cfm">

					</cfif>

					<cfif itemTypeId IS 11 OR itemTypeId IS 12 OR itemTypeId IS 13><!---List, Forms, Typologies--->

						<!---checkAreaResponsibleAccess--->
						<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
							<cfinvokeargument name="area_id" value="#area_id#">
						</cfinvoke>

					</cfif>

					<!--- restoreBinItem --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/BinQuery" method="restoreBinItem" returnvariable="binItemsQuery">
						<cfinvokeargument name="item_id" value="#arguments.item_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<!---
					<cftransaction>
						
						<cfquery name="changeStatusItemQuery" datasource="#client_dsn#">	
							UPDATE #client_abb#_#itemTypeTable#
							SET status = <cfqueryparam value="ok" cfsqltype="cf_sql_varchar">
							WHERE id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">
						</cfquery>

						<cfquery name="deleteItemFromBin" datasource="#client_dsn#">	
							DELETE FROM #client_abb#_items_deleted
							WHERE item_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">
							AND item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">;
						</cfquery>

					</cftransaction>
					--->
						
				<cfelse><!---Item does not exist--->
				
					<cfset error_code = 501>
				
					<cfthrow errorcode="#error_code#">
						
				</cfif>

			</cfif>
			
			<cfinclude template="includes/logRecord.cfm">	

			<cfset response = {result=true, item_id=#arguments.item_id#}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>

	<!---  ----------------------------------------------------------------------------- --->




	<!---  -------------------------- restoreBinItems -------------------------------- --->
	
	<cffunction name="restoreBinItems" returntype="struct" access="public">
		<cfargument name="delete_user_id" type="numeric" required="false">

		<cfset var method = "restoreBinItems">

		<cfset var response = structNew()>

		<cfset var binItemsQuery = "">

		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!---checkAdminUser--->
			<cfif SESSION.user_id NEQ SESSION.client_administrator AND ( NOT isDefined("arguments.delete_user_id") OR arguments.delete_user_id NEQ SESSION.user_id ) >

				<cfset error_code = 106>
		
				<cfthrow errorcode="#error_code#">

			</cfif>
				
			<cfinvoke component="#APPLICATION.coreComponentsPath#/BinQuery" method="getBinItems" returnvariable="binItemsQuery">
				<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfloop query="binItemsQuery">
				
				<cfinvoke component="#APPLICATION.componentsPath#/BinManager" method="restoreBinItem" returnvariable="restoreItemResult">
					<cfinvokeargument name="item_id" value="#binItemsQuery.item_id#">
					<cfinvokeargument name="itemTypeId" value="#binItemsQuery.item_type_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>	

				<cfif restoreItemResult.result IS false>
					
					<cfreturn restoreItemResult>

				</cfif>		

			</cfloop>
		
			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>

	<!---  ----------------------------------------------------------------------------- --->



	<!---  -------------------------- deleteBinItem -------------------------------- --->
	
	<cffunction name="deleteBinItem" returntype="struct" access="public">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">

		<cfset var method = "deleteBinItem">

		<cfset var response = structNew()>

		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!--- NO se llama directamente a los componentes de core-components porque no comprueban los permisos--->

			<cfif arguments.itemTypeId IS 10><!--- File --->

				<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="deleteFile" returnvariable="response">
					<cfinvokeargument name="file_id" value="#arguments.item_id#">
					<cfinvokeargument name="delete_user_id" value="#user_id#">
					<cfinvokeargument name="moveToBin" value="false">
				</cfinvoke>

			<cfelse><!--- Item --->

				<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="deleteItem" returnvariable="response">
					<cfinvokeargument name="item_id" value="#arguments.item_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">					
					<cfinvokeargument name="moveToBin" value="false">
				</cfinvoke>

			</cfif>

			<cfinclude template="includes/logRecord.cfm">

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>

	<!---  ----------------------------------------------------------------------------- --->



	<!---  -------------------------- deleteBinItems -------------------------------- --->
	
	<cffunction name="deleteBinItems" returntype="struct" access="public">
		<cfargument name="delete_user_id" type="numeric" required="false">

		<cfset var method = "deleteBinItems">

		<cfset var response = structNew()>

		<cfset var binItemsQuery = "">

		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!---checkAdminUser--->
			<cfif SESSION.user_id NEQ SESSION.client_administrator AND ( NOT isDefined("arguments.delete_user_id") OR arguments.delete_user_id NEQ SESSION.user_id ) >

				<cfset error_code = 106>
		
				<cfthrow errorcode="#error_code#">

			</cfif>
			
			<!--- getBinItems --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/BinQuery" method="getBinItems" returnvariable="binItemsQuery">
				<cfinvokeargument name="user_id" value="#arguments.delete_user_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfloop query="binItemsQuery">

				<!--- deleteBinItem --->
				<cfinvoke component="#APPLICATION.componentsPath#/BinManager" method="deleteBinItem" returnvariable="deleteBinItemResult">
					<cfinvokeargument name="item_id" value="#binItemsQuery.item_id#">
					<cfinvokeargument name="itemTypeId" value="#binItemsQuery.item_type_id#">
				</cfinvoke>

				<cfif deleteBinItemResult.result IS false>
						
					<cfreturn deleteBinItemResult>

				</cfif>

				<!---

				<cfif binItemsQuery.itemTypeId IS 10><!--- File --->

					<!--- deleteFile --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="deleteFile" returnvariable="deleteFileResult">
						<cfinvokeargument name="file_id" value="#binItemsQuery.item_id#">
						<cfinvokeargument name="user_id" value="#binItemsQuery.delete_user_id#">					
						<cfinvokeargument name="area_id" value="#binItemsQuery.delete_area_id#">
						<cfinvokeargument name="moveToBin" value="false">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfif deleteFileResult.result IS false>
						
						<cfreturn deleteFileResult>

					</cfif>	

				<cfelse><!--- Item --->

					<!--- deleteItem --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="deleteItem" returnvariable="deleteItemResult">
						<cfinvokeargument name="item_id" value="#binItemsQuery.item_id#">
						<cfinvokeargument name="itemTypeId" value="#binItemsQuery.item_type_id#">
						<cfinvokeargument name="moveToBin" value="false">

						<cfinvokeargument name="delete_user_id" value="#binItemsQuery.delete_user_id#">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>	

					<cfif deleteItemResult.result IS false>
						
						<cfreturn deleteItemResult>

					</cfif>

				</cfif>

				---->

			</cfloop>
		
			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>

	<!---  ----------------------------------------------------------------------------- --->


	
</cfcomponent>