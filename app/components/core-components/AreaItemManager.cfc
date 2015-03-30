<!--- Copyright Era7 Information Technologies 2007-2013 --->
<cfcomponent output="false">

	<cfset component = "AreaItemManager">	
	
	<cfset dateFormat = "%d-%m-%Y"><!---%H:%i:%s---><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset dateTimeFormat = "%d-%m-%Y %H:%i:%s">
	<!---<cfset timeZoneTo = "+1:00">--->
	<cfset timeZoneTo = "Europe/Madrid">


	<!--- getAreaItemTypesStruct --->

	<cffunction name="getAreaItemTypesStruct" returntype="struct" access="public">
		<!---<cfargument name="client_abb" type="string" required="true">--->

		<cfset var itemTypesStruct = structNew()>

		<cfinclude template="includes/areaItemTypeStruct.cfm">

		<cfreturn itemTypesStruct>

	</cffunction>


	<!--- getAreaItemTypeStruct --->

	<cffunction name="getAreaItemTypeStruct" returntype="struct" access="public">

		<cfset var itemTypesStruct = structNew()>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
		</cfinvoke>

		<cfreturn itemTypesStruct[arguments.itemTypeId]>

	</cffunction>


	<!--- getAreaItemTypesArray --->

	<!---<cffunction name="getAreaItemTypesArray" returntype="array" access="public">
		<cfargument name="client_abb" type="string" required="true">

		<cfset var itemTypesStruct = structNew()>

		<cfinvoke component="AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
		</cfinvoke>

		<cfset var itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

		<cfreturn itemTypesArray>

	</cffunction>--->


	<!--- ----------------------- DELETE ITEM ATTACHED FILE -------------------------------- --->
	
	<cffunction name="deleteItemAttachedFile" returntype="void" access="public">
		<cfargument name="item_id" type="string" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="itemQuery" type="query" required="true">
		<cfargument name="forceDeleteVirus" type="string" required="true">
		<cfargument name="anti_virus_check_result" type="string" required="false">

		<cfargument name="file_type" type="string" required="true"><!--- file / image --->

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">
		
		<cfset var method = "deleteItemAttachedFile">
		
		<cfset var area_id = "">
									
			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">
		
			<!--- DELETE IN DB  --->
			<cfquery name="deleteAttachedFile" datasource="#client_dsn#">
				UPDATE #client_abb#_#itemTypeTable#
				SET	attached_#arguments.file_type#_name = <cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
				attached_#arguments.file_type#_id = <cfqueryparam cfsqltype="cf_sql_integer" null="yes">
				WHERE id = <cfqueryparam value="#itemQuery.id#" cfsqltype="cf_sql_integer">;
			</cfquery>
				
			<!---DELETE ATTACHED_IMAGE FILE--->
			<cfif itemQuery["attached_#arguments.file_type#_id"] NEQ "NULL" AND itemQuery["attached_#arguments.file_type#_id"] NEQ "" AND itemQuery["attached_#arguments.file_type#_id"] NEQ "-1">
			
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="deleteFile" returnvariable="deleteFileResult">
					<cfinvokeargument name="file_id" value="#itemQuery['attached_#arguments.file_type#_id']#">
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="forceDeleteVirus" value="#arguments.forceDeleteVirus#">
					<cfinvokeargument name="user_id" value="#user_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>
				
				<cfif deleteFileResult.result IS false><!---File delete failed--->

					<cfthrow message="#resultDeleteFile.message#">

				<cfelseif arguments.forceDeleteVirus IS true>

					<!--- Alert --->
					<cfinvoke component="#APPLICATION.componentsPath#/AlertManager" method="newAreaItem">
						<cfinvokeargument name="objectItem" value="#itemQuery#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="action" value="attached_#arguments.file_type#_deleted_virus">
						<cfinvokeargument name="anti_virus_check_result" value="#arguments.anti_virus_check_result#">
					</cfinvoke>
				
				</cfif>
				
			<cfelse>
			
				<cfset error_code = 601>

				<cfthrow errorcode="#error_code#">
				
			</cfif>

			<cfinclude template="includes/logRecord.cfm">
				
	</cffunction>
	<!--- ---------------------------------------------------------------------------------- --->




	<!--- ----------------------- DELETE ITEM -------------------------------- --->
	
	<cffunction name="deleteItem" output="false" access="public" returntype="struct">
		<cfargument name="item_id" type="string" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="moveToBin" type="boolean" required="false" default="true">
		<cfargument name="itemQuery" type="query" required="false">

		<cfargument name="delete_user_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">
		
		<cfset var method = "deleteItem">
		
		<cfset var response = structNew()>

		<cfset var area_id = "">

									
			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">
			
			<cfif NOT isDefined("arguments.itemQuery")>
				
				<!--- getItem --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
					<cfinvokeargument name="item_id" value="#arguments.item_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="parse_dates" value="true">
					<cfinvokeargument name="published" value="false">
					
					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif itemQuery.recordCount IS 0><!---Item does not exist--->
			
					<cfset error_code = 501>
			
					<cfthrow errorcode="#error_code#">

				</cfif>

			</cfif>
			
			<!--- getClient --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="clientQuery">
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			</cfinvoke>

			<cfif clientQuery.bin_enabled IS true AND arguments.moveToBin IS true><!--- MOVE TO BIN --->
				
				<cfinvoke component="#APPLICATION.coreComponentsPath#/BinQuery" method="moveItemToBin">
					<cfinvokeargument name="item_id" value="#arguments.item_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="delete_area_id" value="#itemQuery.area_id#">
					<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<!---Alert--->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newAreaItem">
					<cfinvokeargument name="objectItem" value="#itemQuery#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="action" value="delete">

					<cfinvokeargument name="user_id" value="#arguments.delete_user_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif itemTypeId IS 11 OR itemTypeId IS 12><!--- List, Forms --->

					<cfinvoke component="#APPLICATION.coreComponentsPath#/ViewManager" method="sendAlertDeleteTableViews">
						<cfinvokeargument name="table_id" value="#arguments.item_id#">
						<cfinvokeargument name="tableTypeId" value="#tableTypeId#">

						<cfinvokeargument name="user_id" value="#arguments.delete_user_id#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

				</cfif>


			<cfelse><!--- DELETE --->

				<cftry>

					<cftransaction>

						<!---IMPORTANTE: esto se hacía fuera de <cftransaction> porque si se hacía dentro da error, ya que al enviar las notificaciones por email de la elminicación de registros se accedía a otro Datasource dentro de la misma transacción--->

						<cfif itemTypeId IS 11 OR itemTypeId IS 12 OR itemTypeId IS 13><!---List, Forms, Typologies--->
						
							<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="deleteTableInDatabase">
								<cfinvokeargument name="table_id" value="#arguments.item_id#">
								<cfinvokeargument name="tableTypeId" value="#tableTypeId#">

								<cfinvokeargument name="user_id" value="#arguments.delete_user_id#">

								<cfif clientQuery.bin_enabled IS false OR itemQuery.status NEQ "deleted"><!---Bin enabled--->
									<cfinvokeargument name="send_alert" value="true">
								<cfelse>
									<cfinvokeargument name="send_alert" value="false">
								</cfif>

								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

						</cfif>
						
						<!--- CHANGE SUB ITEMS  --->
						<!---Ya no se borran los submensajes de un mensaje, lo que se hace es que se ponen como hijos del nivel superior--->
						<cfquery name="changeSubItemsQuery" datasource="#client_dsn#">
							UPDATE #client_abb#_#itemTypeTable#
							SET parent_id = #itemQuery.parent_id#, 
							parent_kind = <cfqueryparam value="#itemQuery.parent_kind#" cfsqltype="cf_sql_varchar">			
							WHERE parent_id = <cfqueryparam value="#itemQuery.id#" cfsqltype="cf_sql_integer"> 
							AND parent_kind = <cfqueryparam value="item" cfsqltype="cf_sql_varchar">;
						</cfquery>

						<!---DELETE ITEM POSITION--->
						<!---<cfinvoke component="AreaItemManager" method="deleteItemPosition">
							<cfinvokeargument name="item_id" value="#itemQuery.id#">
							<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						</cfinvoke>--->

						<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="deleteItemPosition">
							<cfinvokeargument name="item_id" value="#itemQuery.id#">
							<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>
						
						<!---DELETE ITEM--->
						<cfquery name="deleteItemQuery" datasource="#client_dsn#">	
							DELETE FROM #client_abb#_#itemTypeTable#
							WHERE id = <cfqueryparam value="#itemQuery.id#" cfsqltype="cf_sql_integer">;
						</cfquery>

						<!---DELETE ATTACHED_FILE FILE--->
						<cfif isNumeric(itemQuery.attached_file_id) AND itemQuery.attached_file_id GT 0>

							<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="deleteFile" returnvariable="resultDeleteFile">
								<cfinvokeargument name="file_id" value="#itemQuery.attached_file_id#">
								<cfinvokeargument name="user_id" value="#arguments.delete_user_id#">
								<cfinvokeargument name="with_transaction" value="false">
								<cfinvokeargument name="moveToBin" value="false">

								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>
							
							
							<cfif resultDeleteFile.result IS false><!---File delete failed--->
								
								<cfset error_code = 605>
			
								<cfthrow errorcode="#error_code#">
							
							</cfif>
							
						</cfif>
						
						<cfif arguments.itemTypeId IS NOT 1>
						
							<!---DELETE ATTACHED_IMAGE FILE--->
							<cfif isNumeric(itemQuery.attached_image_id) AND itemQuery.attached_image_id GT 0>

								<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="deleteFile" returnvariable="resultDeleteImage">
									<cfinvokeargument name="file_id" value="#itemQuery.attached_image_id#">
									<cfinvokeargument name="user_id" value="#arguments.delete_user_id#">
									<cfinvokeargument name="with_transaction" value="false">
									<cfinvokeargument name="moveToBin" value="false">

									<cfinvokeargument name="client_abb" value="#client_abb#">
									<cfinvokeargument name="client_dsn" value="#client_dsn#">
								</cfinvoke>
								
								<cfif resultDeleteImage.result IS false><!---File delete failed--->
									
									<cfset error_code = 605>
				
									<cfthrow errorcode="#error_code#">
								
								</cfif>
								
							</cfif>
							
						</cfif>	

						<cfif clientQuery.bin_enabled IS true><!---Bin enabled--->


							<cfinvoke component="#APPLICATION.coreComponentsPath#/BinQuery" method="updateBinItemDeleted">
								<cfinvokeargument name="item_id" value="#arguments.item_id#">
								<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">

								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

							<!--- 
							<cfquery name="updateItemDelete" datasource="#client_dsn#">		
								UPDATE #client_abb#_items_deleted
								SET in_bin = 0,
								final_delete_date = NOW(),
								final_delete_status = <cfqueryparam value="ok" cfsqltype="cf_sql_varchar">
								WHERE item_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">
								AND item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">;
							</cfquery> --->
							

						</cfif>									
					
					</cftransaction>


					<cfif clientQuery.bin_enabled IS false OR itemQuery.status NEQ "deleted"><!---Bin disabled OR item not deleted--->

						<!---Alert--->
						<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newAreaItem">
							<cfinvokeargument name="objectItem" value="#itemQuery#">
							<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
							<cfinvokeargument name="action" value="delete">

							<cfinvokeargument name="user_id" value="#arguments.delete_user_id#">

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

					</cfif>


					<cfcatch>

						<cfif clientQuery.bin_enabled IS true>

							<cfinvoke component="#APPLICATION.coreComponentsPath#/BinQuery" method="updateBinItemWithError">
								<cfinvokeargument name="item_id" value="#arguments.item_id#">
								<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
								<cfinvokeargument name="error_message" value="#cfcatch.message#">
								<cfinvokeargument name="error_detail" value="#cfcatch.detail#">

								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

						</cfif>
						
						<cfrethrow/>

					</cfcatch>

				</cftry>

				

			</cfif><!--- END DELETE --->


			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, item_id=#arguments.item_id#}>


		<cfreturn response>
				
	</cffunction>
	<!--- ----------------------------------------------------------------------- --->	


</cfcomponent>
	