<!--- Copyright Era7 Information Technologies 2007-2015 --->
<cfcomponent output="true">

	<cfset component = "BinManager">


	<!--- ----------------------- DELETE ALL CLIENTS BIN ITEMS -------------------------------- --->

	<cffunction name="deleteAllClientsBinItems" returntype="void" access="public">

		<cfset var method = "deleteAllClientsBinItems">

		<cftry>

			<cfinvoke component="ClientQuery" method="getClients" returnvariable="getClientsQuery">
				<cfif isDefined("APPLICATION.schedulesExcludeClients") AND len(APPLICATION.schedulesExcludeClients) GT 0>
					<cfinvokeargument name="excludeClients" value="#APPLICATION.schedulesExcludeClients#">
				</cfif>
				<cfif isDefined("APPLICATION.schedulesOnlyClient") AND len(APPLICATION.schedulesOnlyClient) GT 0>
					<cfinvokeargument name="client_abb" value="#APPLICATION.schedulesOnlyClient#">
				</cfif>
			</cfinvoke>

			<cfloop query="getClientsQuery">

				<!---<cfif getClientsQuery.bin_enabled IS true>--->

				<!--- Se recorren todos los clientes aunque no tengan la papelera habilitada por si la tenían antes habilitada y la han deshabilitado --->

					<cfset client_abb = getClientsQuery.abbreviation>
					<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>

					<cftry>

						<cfinvoke component="#APPLICATION.coreComponentsPath#/BinManager" method="deleteClientBinItems">
							<cfinvokeargument name="bin_days" value="#getClientsQuery.bin_days#">
							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

						<cfcatch>
							<cfinclude template="includes/errorHandler.cfm">
						</cfcatch>

					</cftry>

				<!---</cfif>--->

			</cfloop>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

	</cffunction>

	<!--- ---------------------------------------------------------------------------------- --->




	<!--- ----------------------- DELETE BIN ITEMS -------------------------------- --->

	<cffunction name="deleteClientBinItems" returntype="void" access="private">
		<cfargument name="bin_days" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "deleteClientBinItems">

			<cfset toDeleteDate = dateAdd("d", -arguments.bin_days, now())>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/BinQuery" method="getBinItems" returnvariable="binItemsQuery">
				<cfinvokeargument name="to_delete_date" value="#toDeleteDate#">

				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>


			<!---<cfoutput>
				Días: #arguments.bin_days#<br/>
				Fecha: #toDeleteDate#

				<cfdump var="#binItemsQuery#">--->

			<cfloop query="binItemsQuery">

				<cfinvoke component="#APPLICATION.coreComponentsPath#/BinManager" method="deleteBinItem" returnvariable="deleteBinItemResponse">
					<cfinvokeargument name="item_id" value="#binItemsQuery.item_id#">
					<cfinvokeargument name="itemTypeId" value="#binItemsQuery.item_type_id#">
					<cfinvokeargument name="delete_user_id" value="#binItemsQuery.delete_user_id#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

				<cfif deleteBinItemResponse.result IS false>

					<cfthrow message="#response.message#">

				</cfif>

				<!---Borrado definitivamente #binItemsQuery.item_id#--->

			</cfloop>

			<!---</cfoutput>--->

	</cffunction>

	<!--- ---------------------------------------------------------------------------------- --->



	<!---  -------------------------- deleteBinItem -------------------------------- --->

	<!--- Este método no comprueba permisos. Debe poder eliminar los elementos aunque no exista su área. --->

	<cffunction name="deleteBinItem" returntype="struct" access="public">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="delete_user_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "deleteBinItem">

		<cfset var response = structNew()>

			<cfif arguments.itemTypeId IS 10><!--- File --->

				<!--- deleteFile --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="deleteFile" returnvariable="response">
					<cfinvokeargument name="file_id" value="#arguments.item_id#">
					<cfinvokeargument name="user_id" value="#arguments.delete_user_id#">
					<cfinvokeargument name="moveToBin" value="false">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			<cfelse><!--- Item --->

				<!--- deleteItem --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="deleteItem" returnvariable="response">
					<cfinvokeargument name="item_id" value="#arguments.item_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="moveToBin" value="false">

					<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>

		<cfreturn response>

	</cffunction>

	<!---  ----------------------------------------------------------------------------- --->



</cfcomponent>
