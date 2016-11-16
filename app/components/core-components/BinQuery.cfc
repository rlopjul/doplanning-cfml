<!--- Copyright Era7 Information Technologies 2007-2015 --->
<cfcomponent output="true">

	<cfset component = "BinQuery">


	<!---getBinItems--->

	<cffunction name="getBinItems" output="false" returntype="query" access="public">
		<cfargument name="delete_user_id" type="numeric" required="false">
		<cfargument name="to_delete_date" type="date" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getBinItems">


			<cfquery datasource="#arguments.client_dsn#" name="binItemsQuery">
				SELECT *
				FROM #arguments.client_abb#_items_deleted AS items_deleted
				WHERE items_deleted.in_bin = 1
				<cfif isDefined("arguments.delete_user_id")>
					AND items_deleted.delete_user_id = <cfqueryparam value="#arguments.delete_user_id#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif isDefined("arguments.to_delete_date")>
					AND items_deleted.delete_date <= <cfqueryparam value="#arguments.to_delete_date#" cfsqltype="cf_sql_date">
				</cfif>
				<!---AND delete_date <= <cfqueryparam value="#dateDelete#" cfsqltype="cf_sql_date">--->
				GROUP BY item_id, item_type_id <!--- This is to fix a not found bug that duplicates items in this table --->;
			</cfquery>


		<cfreturn binItemsQuery>

	</cffunction>



	<!--------------------------- MOVE ITEM TO BIN ----------------------------------->

	<cffunction name="moveItemToBin" output="false" returntype="void" access="public">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="delete_area_id" type="numeric" required="true">
 		<cfargument name="delete_user_id" type="numeric" required="true">
 		<cfargument name="with_transaction" type="boolean" required="false" default="true">

 		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "moveItemToBin">

 		<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

		<cftry>

			<cfif arguments.with_transaction IS true>
				<!--- <cftransaction nested="true"> Aquí debería estar definido nested="true", pero Railo/Lucee no permite definirlo (parece que hay un bug)--->
				<cfquery datasource="#client_dsn#" name="startTransaction">
					START TRANSACTION;
				</cfquery>
			</cfif>

				<cfquery name="insertItemDelete" datasource="#client_dsn#">
					INSERT INTO #client_abb#_items_deleted
					SET item_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">,
					item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">,
					delete_area_id = <cfqueryparam value="#arguments.delete_area_id#" cfsqltype="cf_sql_integer">,
					delete_user_id = <cfqueryparam value="#arguments.delete_user_id#" cfsqltype="cf_sql_integer">,
					delete_date = NOW();
				</cfquery>

				<cfquery name="deleteItemQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_#itemTypeTable#
					SET status = <cfqueryparam value="deleted" cfsqltype="cf_sql_varchar">
					WHERE id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
				</cfquery>


			<cfif arguments.with_transaction IS true>
				<!--- </cftransaction> --->
				<cfquery datasource="#client_dsn#" name="endTransaction">
					COMMIT;
				</cfquery>
			</cfif>


			<cfcatch>

				<cfif arguments.with_transaction IS true>
					<cfquery datasource="#client_dsn#" name="rollbackTransaction">
						ROLLBACK;
					</cfquery>
				</cfif>

				<cfrethrow/>

			</cfcatch>

		</cftry>

	</cffunction>




	<!--------------------------- RESTORE ITEM FROM BIN ----------------------------------->

	<cffunction name="restoreBinItem" output="false" returntype="void" access="public">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">

 		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "restoreBinItem">

 		<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

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

	</cffunction>


	<!--------------------------- UPDATE BIN ITEM DELETED----------------------------------->

	<cffunction name="updateBinItemDeleted" output="false" returntype="void" access="public">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">

 		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "updateBinItemDeleted">

			<cfquery name="updateItemDelete" datasource="#client_dsn#">
				UPDATE #client_abb#_items_deleted
				SET in_bin = 0,
				final_delete_date = NOW(),
				final_delete_status = <cfqueryparam value="ok" cfsqltype="cf_sql_varchar">
				WHERE item_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">
				AND item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">;
			</cfquery>

	</cffunction>


	<!--------------------------- UPDATE BIN ITEM WITH ERROR----------------------------------->

	<cffunction name="updateBinItemWithError" output="false" returntype="void" access="public">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="error_message" type="string" required="true">
		<cfargument name="error_detail" type="string" required="true">

 		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "updateBinItemWithError">

			<cfquery name="updateBinItemWhithError" datasource="#client_dsn#">
				UPDATE #client_abb#_items_deleted
				SET final_delete_status = <cfqueryparam value="error" cfsqltype="cf_sql_varchar">,
				final_delete_error_message = <cfqueryparam value="#arguments.error_message#" cfsqltype="cf_sql_longvarchar">,
				final_delete_error_detail = <cfqueryparam value="#arguments.error_detail#" cfsqltype="cf_sql_longvarchar">
				WHERE item_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">
				AND item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">;
			</cfquery>

	</cffunction>


</cfcomponent>
