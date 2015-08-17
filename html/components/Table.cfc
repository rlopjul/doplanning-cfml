<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="true">

	<cfset component = "Table">
	<cfset request_component = "TableManager">


	<!--- -------------------------------createTable-------------------------------------- --->
	
    <cffunction name="createTable" returntype="struct" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="structure_available" type="boolean" required="false" default="false">
		<cfargument name="general" type="boolean" required="false" default="false">
		<cfargument name="publication_scope_id" type="numeric" required="false">
		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_hour" type="numeric" required="false">
		<cfargument name="publication_minute" type="numeric" required="false">
		<cfargument name="publication_validated" type="boolean" required="false">
				
		<cfset var method = "createTable">

		<cfset var response = structNew()>
		
		<cftry>

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
					
			<cfinvoke component="AreaItem" method="createItem" returnvariable="response">
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
				<cfinvokeargument name="title" value="#arguments.title#">
				<cfinvokeargument name="link" value="">
				<cfinvokeargument name="link_target" value="">
				<cfinvokeargument name="description" value="#arguments.description#">
				<cfinvokeargument name="parent_id" value="#arguments.area_id#">
				<cfinvokeargument name="parent_kind" value="area">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="structure_available" value="#arguments.structure_available#">
				<cfinvokeargument name="general" value="#arguments.general#">
				<cfinvokeargument name="publication_scope_id" value="#arguments.publication_scope_id#">
				<cfinvokeargument name="publication_date" value="#arguments.publication_date#">
				<cfinvokeargument name="publication_hour" value="#arguments.publication_hour#">
				<cfinvokeargument name="publication_minute" value="#arguments.publication_minute#">
				<cfinvokeargument name="publication_validated" value="#arguments.publication_validated#">
			</cfinvoke>

			<cfif response.result IS true>

				<cfif tableTypeGender EQ "male">
					<cfset response_message = "#tableTypeNameEs# creado, ahora debe definir los campos.">
				<cfelse>
					<cfset response_message = "#tableTypeNameEs# creada, ahora debe definir los campos.">
				</cfif>

				<cfset response = {result=true, message=response_message, table_id=response.item_id, area_id=#arguments.area_id#}>
			</cfif>	

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>


	<!--- -------------------------------updateTable-------------------------------------- --->
	
    <cffunction name="updateTable" returntype="struct" access="public">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="link" type="string" required="false" default="">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="structure_available" type="boolean" required="false" default="false">
		<cfargument name="general" type="boolean" required="false" default="false">
		<cfargument name="publication_scope_id" type="numeric" required="false">
		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_hour" type="numeric" required="false">
		<cfargument name="publication_minute" type="numeric" required="false">
		<cfargument name="publication_validated" type="boolean" required="false">
		
		<cfset var method = "updateTable">

		<cfset var response = structNew()>
		
		<cftry>

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
					
			<cfinvoke component="AreaItem" method="updateItem" returnvariable="response">
				<cfinvokeargument name="item_id" value="#arguments.table_id#">
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
				<cfinvokeargument name="title" value="#arguments.title#">
				<cfinvokeargument name="link" value="#arguments.link#">
				<cfinvokeargument name="description" value="#arguments.description#">
				<cfinvokeargument name="structure_available" value="#arguments.structure_available#">
				<cfinvokeargument name="general" value="#arguments.general#">
				<cfinvokeargument name="publication_scope_id" value="#arguments.publication_scope_id#">
				<cfinvokeargument name="publication_date" value="#arguments.publication_date#">
				<cfinvokeargument name="publication_hour" value="#arguments.publication_hour#">
				<cfinvokeargument name="publication_minute" value="#arguments.publication_minute#">
				<cfinvokeargument name="publication_validated" value="#arguments.publication_validated#">
			</cfinvoke>
			
			<cfif response.result IS true>

				<cfif tableTypeGender EQ "male">
					<cfset response_message = "#tableTypeNameEs# modificado.">
				<cfelse>
					<cfset response_message = "#tableTypeNameEs# modificada.">
				</cfif>

				<cfset response = {result=true, message=response_message, table_id=arguments.table_id, area_id=#arguments.area_id#}>
			</cfif>
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>


	<!--- ----------------------------------- getTable -------------------------------------- --->

	<!---Este método no hay que usarlo en páginas en las que su contenido se cague con JavaScript (páginas de html_content) porque si hay un error este método redirige a otra página. En esas páginas hay que obtener el Item directamente del AreaItemManager y comprobar si result es true o false para ver si hay error y mostrarlo correctamente--->

	<cffunction name="getTable" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getTable">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTable" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response.table>
			
	</cffunction>


	<!--- ----------------------------------- getEmptyTable -------------------------------------- --->

	<cffunction name="getEmptyTable" output="false" returntype="query" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getEmptyTable">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getEmptyTable" returnvariable="response">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response.table>
			
	</cffunction>



	<!--- ----------------------------------- getAreaTables ------------------------------------- --->
	
	<cffunction name="getAreaTables" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_user" type="boolean" required="false">
		
		<cfset var method = "getAreaTables">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getAreaTables" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="with_user" value="#arguments.with_user#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>



	<!--- ----------------------------------- getAllAreasTables ------------------------------------- --->
	
	<cffunction name="getAllAreasTypologies" returntype="struct" access="public">
		
		<cfset var method = "getAllAreasTables">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getAllAreasTypologies" returnvariable="response">
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>



	<!--- ----------------------------------- getAllTypologies ------------------------------------- --->
	
	<cffunction name="getAllTypologies" returntype="struct" access="public">
		<cfargument name="tableTypeId" type="string" required="true">
		<cfargument name="with_area" type="boolean" required="false">
		<cfargument name="parse_dates" type="boolean" required="false">
		
		<cfset var method = "getAllTypologies">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getAllTypologies" returnvariable="response">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="with_area" value="#arguments.with_area#"/>
				<cfinvokeargument name="parse_dates" value="#arguments.parse_dates#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>


	<!--- ---------------------------- getTablesWithStructureAvailable ---------------------------------- --->
	
	<cffunction name="getTablesWithStructureAvailable" returntype="struct" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfset var method = "getTablesWithStructureAvailable">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTablesWithStructureAvailable" returnvariable="response">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>


	<!--- ----------------------------------- getTableFields ------------------------------------- --->
	
	<cffunction name="getTableFields" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_types" type="boolean" required="false" default="false">
		<cfargument name="view_id" type="numeric" required="false">
		<cfargument name="only_view_fields" type="boolean" required="false">
		<cfargument name="file_id" type="boolean" required="false">

		<cfset var method = "getTableFields">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTableFields" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="with_types" value="#arguments.with_types#"/>
				<cfinvokeargument name="view_id" value="#arguments.view_id#">
				<cfinvokeargument name="only_view_fields" value="#arguments.only_view_fields#">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>


	<!--- ----------------------------------- getTableRows ------------------------------------- --->
	
	<cffunction name="getTableRows" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="fields" type="query" required="false">
		
		<cfset var method = "getTableRows">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTableRows" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="fields" value="#arguments.fields#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>


	<!--- ----------------------------------- getTableUsers ------------------------------------- --->
	
	<cffunction name="getTableUsers" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfset var method = "getTableUsers">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTableUsers" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>


	<!--- ----------------------------------- getTableViews ------------------------------------- --->
	
	<cffunction name="getTableViews" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getTableViews">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTableViews" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>


	<!--- ----------------------------------- getTableActions ------------------------------------- --->
	
	<cffunction name="getTableActions" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getTableActions">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTableActions" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>




	<!--- ----------------------------------- addUsersToTable -------------------------------------- --->

	<cffunction name="addUsersToTable" output="false" returntype="struct" returnformat="json" access="remote">
		<cfargument name="table_id" type="numeric" required="true" />
		<cfargument name="tableTypeId" type="numeric" required="true" />
		<cfargument name="users_ids" type="array" required="true" />
		
		<cfset var method = "addUsersToTable">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="addUsersToTable" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="users_ids" value="#arguments.users_ids#"/>
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Usuario/s añadido/s">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>


	<!--- ----------------------------------- removeUserFromTable ------------------------------------- --->
	
	<cffunction name="removeUserFromTable" returntype="void" access="remote">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="remove_user_id" type="numeric" required="true">
		<cfargument name="return_page" type="string" required="true">
		
		<cfset var method = "removeUserFromTable">

		<cfset var response = structNew()>
					
		<cftry>
			
			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="removeUserFromTable" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="remove_user_id" value="#arguments.remove_user_id#"/>
			</cfinvoke>

			<cfif response.result IS true>

				<cfset msg = "Usuario quitado">            
		
			<cfelse>

				<cfset msg = response.message>
				
			</cfif>

			<cfset msg = URLEncodedFormat(msg)>

			
			<cflocation url="#arguments.return_page#&msg=#msg#&res=#response.result#" addtoken="no">	

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
				
	</cffunction>


	<!--- ----------------------------------- setAreaDefaultTableRemote ------------------------------------- --->
	
	<cffunction name="setAreaDefaultTableRemote" returntype="void" access="remote">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="return_page" type="string" required="true">
		
		<cfset var method = "setAreaDefaultTableRemote">

		<cfset var response = structNew()>
					
		<cftry>
			
			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="setAreaDefaultTable" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>

			<cfif response.result IS true>

				<cfset msg = "#tableTypeNameEs# definida por defecto en esta área">            
		
			<cfelse>

				<cfset msg = response.message>
				
			</cfif>

			<cfset msg = URLEncodedFormat(msg)>

			
			<cflocation url="#arguments.return_page#&msg=#msg#&res=#response.result#&#tableTypeName#=#arguments.table_id#" addtoken="no">	

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
				
	</cffunction>


	<!--- ----------------------------------- removeAreaDefaultTable ------------------------------------- --->
	
	<cffunction name="removeAreaDefaultTable" returntype="void" access="remote">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="return_page" type="string" required="true">
		
		<cfset var method = "removeAreaDefaultTable">

		<cfset var response = structNew()>
					
		<cftry>
			
			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="removeAreaDefaultTable" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>

			<cfif response.result IS true>

				<cfset msg = "#tableTypeNameEs# por defecto quitada">            
		
			<cfelse>

				<cfset msg = response.message>
				
			</cfif>

			<cfset msg = URLEncodedFormat(msg)>

			
			<cflocation url="#arguments.return_page#&msg=#msg#&res=#response.result#&#tableTypeName#=#arguments.table_id#" addtoken="no">	

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
				
	</cffunction>


	<!--- ----------------------------------- getAreaDefaultTable ------------------------------------- --->
	
	<cffunction name="getAreaDefaultTable" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfset var method = "getAreaDefaultTable">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getAreaDefaultTable" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>


	<!--- ----------------------------------- isUserInTable ------------------------------------- --->
	
	<cffunction name="isUserInTable" returntype="boolean" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfset var method = "isUserInTable">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="isUserInTable" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="check_user_id" value="#SESSION.user_id#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response.isUserInTable>
		
	</cffunction>

	

	<!--- ----------------------------------- outputTablesList ------------------------------------- --->

	<cffunction name="outputTablesList" returntype="void" output="true" access="public">
		<cfargument name="itemsQuery" type="query" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="full_content" type="boolean" required="no" default="false">
		<cfargument name="return_page" type="string" required="no">
		<cfargument name="app_version" type="string" required="true">
		<cfargument name="default_table_id" type="numeric" required="false" default="0">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="openItemOnSelect" type="boolean" required="false" default="true">

		<cfset var method = "outputTablesList">

		<cftry>
			
			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<cfset numItems = itemsQuery.recordCount>
			
			<cfif numItems GT 0>
				
				<cfoutput>

				<script type="text/javascript">
					$(document).ready(function() { 
						
						$("##listTable").tablesorter({ 
							<cfif arguments.full_content IS false>
							widgets: ['zebra','uitheme','filter'],<!---,'select'--->
							<cfelse>
							widgets: ['zebra','uitheme'],
							</cfif>
							theme : "bootstrap",
							headerTemplate : '{content} {icon}',
							<cfif itemTypeId IS 11 OR itemTypeId IS 12><!---Lists, Forms--->
							sortList: [[2,1]],
							headers: { 
								1: { 
									sorter: false 
								},
								2: { 
									sorter: "datetime" 
								}								
							}
							<cfelse><!--- Typologies --->
							sortList: [[1,1]],
							headers: { 
								1: { 
									sorter: "datetime" 
								}								
							}
							</cfif>
							<cfif arguments.full_content IS false>
							, widgetOptions : {
								filter_childRows : false,
								filter_columnFilters : true,
								filter_cssFilter : 'tablesorter-filter',
								filter_filteredRow   : 'filtered',
								filter_formatter : null,
								filter_functions : null,
								filter_hideFilters : false,
								filter_ignoreCase : true,
								filter_liveSearch : true,
								//filter_reset : 'button.reset',
								filter_searchDelay : 300,
								filter_serversideFiltering: false,
								filter_startsWith : false,
								filter_useParsedData : false,
						    } 
						    </cfif> 
						});


						<cfif arguments.openItemOnSelect IS true>
						<!--- https://code.google.com/p/tablesorter-extras/wiki/TablesorterSelect --->
						<!---
						Esto se basa en un script antiguo (tablesorter-extras) que hay que dejar de usar
						$('##listTable').bind('select.tablesorter.select', function(event, ts){
						    var itemUrl= $(ts.elem).data("item-url");
						    openUrlLite(itemUrl,'itemIframe');
						});---->

						$('##listTable tbody tr').on('click', function(e) {

					        var row = $(this);

					        <!---if(!row.hasClass("selected")) {
					        	$('##listTable tbody tr').removeClass("selected");
					        	row.addClass("selected");
					        }--->

					        var itemUrl = row.data("item-url");
					        goToUrl(itemUrl);

					    });
						</cfif>
						
					}); 
				</script>
				
				
				<table id="listTable">
					<thead>
						<tr>
							<th><span lang="es">Nombre</span></th>
							<cfif itemTypeId IS 11 OR itemTypeId IS 12><!---Lists, Forms--->
							<th class="filter-false" style="width:55px;"></th>
							</cfif>
							<th style="width:20%;"><span lang="es">Fecha</span></th>
							<th><span lang="es">Estructura compartida</span></th>
							<cfif tableTypeId IS 3><!---Typologies--->
							<th><span lang="es">De esta área</span></th>
							<th><span lang="es">General</span></th>	
							</cfif>
							<cfif arguments.full_content IS true>
							<th><span lang="es">Área</span></th>
							</cfif>
						</tr>
					</thead>
					
					<tbody>
					
					<cfset alreadySelected = false>
					
					<cfloop query="itemsQuery">
						
						<cfif isDefined("arguments.return_page")>
							<cfset rpage = arguments.return_page>
						<cfelse>
							<cfset rpage = "#lCase(itemTypeNameP)#.cfm?area=#itemsQuery.area_id#">
						</cfif>

						<cfif tableTypeId IS 4>

							<cfset item_page_url = "#itemTypeName#_fields.cfm?#itemTypeName#=#itemsQuery.id#&return_page=#URLEncodedFormat(rpage)#">

						<cfelse>

							<cfif isDefined("arguments.area_id")>
								<cfset item_page_url = "#itemTypeName#.cfm?#itemTypeName#=#itemsQuery.id#&area=#arguments.area_id#&return_page=#URLEncodedFormat(rpage)#">
							<cfelse>
								<cfset item_page_url = "#itemTypeName#.cfm?#itemTypeName#=#itemsQuery.id#&return_page=#URLEncodedFormat(rpage)#">
							</cfif>

						</cfif>
						
						
						<!---Item selection--->
						<cfset itemSelected = false>
						
						<cfif arguments.openItemOnSelect IS true AND alreadySelected IS false>
						
							<cfif isDefined("URL.#itemTypeName#")>
							
								<cfif URL[itemTypeName] IS itemsQuery.id>
								
									<!---Esta acción solo se completa si está en la versión HTML2--->
									<script type="text/javascript">
										openUrlHtml2('#item_page_url#','itemIframe');
									</script>
									<cfset itemSelected = true>
									
								</cfif>
								
							<!---<cfelseif itemsQuery.currentRow IS 1>
							
								<cfif app_version NEQ "mobile">
									<!---Esta acción solo se completa si está en la versión HTML2--->
									<script type="text/javascript">
										openUrlHtml2('#item_page_url#','itemIframe');
									</script>
									<cfset itemSelected = true>
								</cfif>--->
								
							</cfif>
							
							<cfif itemSelected IS true>
								<cfset alreadySelected = true>
							</cfif>
							
						</cfif>
						
						<!---Para lo de seleccionar el primero, en lugar de como está hecho, se puede llamar a un método JavaScript que compruebe si el padre es el HTML2, y si lo es seleccionar el primero--->
						
						<tr <cfif itemSelected IS true>class="selected"</cfif> data-item-url="#item_page_url#" data-item-id="#itemsQuery.id#"><!---onclick="stopEvent(event)"--->
							<td><a href="#APPLICATION.path#/html/#item_page_url#" class="text_item" <cfif arguments.default_table_id IS itemsQuery.id>style="font-weight:bold"</cfif>>#itemsQuery.title# <cfif arguments.default_table_id IS itemsQuery.id>*</cfif></a></td>
							<cfif itemTypeId IS 11 OR itemTypeId IS 12><!---Lists, Forms--->
							<td>
								<!---
								<cfif arguments.full_content IS true><!--- Search page --->
									<cfset rowsOnClick = "openUrl('#itemTypeName#_rows.cfm?#itemTypeName#=#itemsQuery.id#&area=#itemsQuery.area_id#','areaIframe',event)">
								<cfelse>
									<cfset rowsOnClick = "openUrl('#itemTypeName#_rows.cfm?#itemTypeName#=#itemsQuery.id#','_self',event)">
								</cfif>
								onclick="#rowsOnClick#" 
								--->
								<a href="#itemTypeName#_rows.cfm?#itemTypeName#=#itemsQuery.id#" onclick="stopPropagation(event)" title="Registros" lang="es"><i class="icon-list" style="font-size:15px;"></i></a>
							</td>
							</cfif>
							<td><cfset spacePos = findOneOf(" ", itemsQuery.creation_date)>
								<span>#left(itemsQuery.creation_date, spacePos)#</span>
								<span class="hidden">#right(itemsQuery.creation_date, len(itemsQuery.creation_date)-spacePos)#</span>
							</td>
							<td><span lang="es"><cfif itemsQuery.structure_available IS true>Sí<cfelse>No</cfif></span></td>
							<cfif tableTypeId IS 3><!---Typologies--->
							<td><span lang="es"><cfif itemsQuery.area_id EQ arguments.area_id>Sí<cfelse>No</cfif></span></td>
							<td><span lang="es"><cfif itemsQuery.general IS true>Sí<cfelse>No</cfif></span></td>
							</cfif>

							<cfif arguments.full_content IS true><!--- Search page --->
								<td><a onclick="openUrl('area_items.cfm?area=#itemsQuery.area_id#&#itemTypeName#=#itemsQuery.id#','areaIframe',event)" class="link_blue">#itemsQuery.area_name#</a></td>
							</cfif>							
						</tr>
					</cfloop>
					</tbody>
				
				</table>

				<cfif arguments.default_table_id IS NOT 0>
					<div style="margin-top:10px">
						<small class="help-block" lang="es">* #tableTypeNameEs# por defecto en esta área</small>
					</div>
				</cfif>
				
				</cfoutput>
			</cfif>	

			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>


	<!--- ----------------------------------- outputAllTypologiesList ------------------------------------- --->

	<cffunction name="outputAllTypologiesList" returntype="void" output="true" access="public">
		<cfargument name="itemsQuery" type="query" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="full_content" type="boolean" required="no" default="false">
		<cfargument name="return_page" type="string" required="no">
		<cfargument name="app_version" type="string" required="true">
		<cfargument name="default_table_id" type="numeric" required="false" default="0">
		<cfargument name="openItemOnSelect" type="boolean" required="false" default="true">

		<cfset var method = "outputAllTypologiesList">

		<cftry>
			
			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<cfset numItems = itemsQuery.recordCount>
			
			<cfif numItems GT 0>
				
				<cfoutput>

				<script type="text/javascript">
					$(document).ready(function() { 
						
						$("##listTable").tablesorter({ 
							<cfif arguments.full_content IS false>
							widgets: ['zebra','uitheme','filter'],
							<cfelse>
							widgets: ['zebra','uitheme'],
							</cfif>
							theme : "bootstrap",
							headerTemplate : '{content} {icon}',
							<cfif itemTypeId IS 11 OR itemTypeId IS 12><!---Lists, Forms--->
							sortList: [[2,1]],
							headers: { 
								1: { 
									sorter: false 
								},
								2: { 
									sorter: "datetime" 
								}								
							}
							<cfelse><!--- Typologies --->
							sortList: [[1,1]],
							headers: { 
								1: { 
									sorter: "datetime" 
								}								
							}
							</cfif>
							<cfif arguments.full_content IS false>
							, widgetOptions : {
								filter_childRows : false,
								filter_columnFilters : true,
								filter_cssFilter : 'tablesorter-filter',
								filter_filteredRow   : 'filtered',
								filter_formatter : null,
								filter_functions : null,
								filter_hideFilters : false,
								filter_ignoreCase : true,
								filter_liveSearch : true,
								//filter_reset : 'button.reset',
								filter_searchDelay : 300,
								filter_serversideFiltering: false,
								filter_startsWith : false,
								filter_useParsedData : false,
						    } 
						    </cfif> 
						});


						<cfif arguments.openItemOnSelect IS true>
						$('##listTable tbody tr').on('click', function(e) {

					        var row = $(this);

					        var itemUrl = row.data("item-url");
					        goToUrl(itemUrl);

					    });
						</cfif>
						
					}); 
				</script>
				
				
				<table id="listTable">
					<thead>
						<tr>
							<th><span lang="es">Nombre</span></th>
							<cfif itemTypeId IS 11 OR itemTypeId IS 12><!---Lists, Forms--->
							<th class="filter-false" style="width:55px;"></th>
							</cfif>
							<th style="width:20%;"><span lang="es">Fecha</span></th>
							<th><span lang="es">Estructura compartida</span></th>
							<cfif tableTypeId IS 3><!---Typologies--->
							<th><span lang="es">General</span></th>	
							<th><span lang="es">Área</span></th>
							</cfif>
						</tr>
					</thead>
					
					<tbody>
					
					<cfset alreadySelected = false>
					
					<cfloop query="itemsQuery">
						
						<cfif isDefined("arguments.return_page")>
							<cfset rpage = arguments.return_page>
						<cfelse>
							<cfset rpage = "#lCase(itemTypeNameP)#.cfm?area=#itemsQuery.area_id#">
						</cfif>

						<cfif tableTypeId IS 4>

							<cfset item_page_url = "#itemTypeName#_fields.cfm?#itemTypeName#=#itemsQuery.id#&return_page=#URLEncodedFormat(rpage)#">

						<cfelse>

							<!---<cfif isDefined("arguments.area_id")>--->
								<cfset item_page_url = "#itemTypeName#.cfm?#itemTypeName#=#itemsQuery.id#&area=#itemsQuery.area_id#&return_page=#URLEncodedFormat(rpage)#">
							<!---<cfelse>
								<cfset item_page_url = "#itemTypeName#.cfm?#itemTypeName#=#itemsQuery.id#&return_page=#URLEncodedFormat(rpage)#">
							</cfif>--->

						</cfif>
						
						
						<!---Item selection--->
						<cfset itemSelected = false>
						
						<cfif arguments.openItemOnSelect IS true AND alreadySelected IS false>
						
							<cfif isDefined("URL.#itemTypeName#")>
							
								<cfif URL[itemTypeName] IS itemsQuery.id>
								
									<!---Esta acción solo se completa si está en la versión HTML2--->
									<script type="text/javascript">
										openUrlHtml2('#item_page_url#','itemIframe');
									</script>
									<cfset itemSelected = true>
									
								</cfif>
								
							</cfif>
							
							<cfif itemSelected IS true>
								<cfset alreadySelected = true>
							</cfif>
							
						</cfif>
						
						<!---Para lo de seleccionar el primero, en lugar de como está hecho, se puede llamar a un método JavaScript que compruebe si el padre es el HTML2, y si lo es seleccionar el primero--->
						
						<tr <cfif itemSelected IS true>class="selected"</cfif> data-item-url="#item_page_url#" data-item-id="#itemsQuery.id#">
							<td><a href="#APPLICATION.path#/html/#item_page_url#" target="_blank" <cfif arguments.default_table_id IS itemsQuery.id>style="font-weight:bold"</cfif>>#itemsQuery.title# <cfif arguments.default_table_id IS itemsQuery.id>*</cfif></a></td>
							<cfif itemTypeId IS 11 OR itemTypeId IS 12><!---Lists, Forms--->
							<td>
								<a href="#itemTypeName#_rows.cfm?#itemTypeName#=#itemsQuery.id#" onclick="stopPropagation(event)" title="Registros" lang="es"><i class="icon-list" style="font-size:15px;"></i></a>
							</td>
							</cfif>
							<td><cfset spacePos = findOneOf(" ", itemsQuery.creation_date)>
								<span>#left(itemsQuery.creation_date, spacePos)#</span>
								<span class="hidden">#right(itemsQuery.creation_date, len(itemsQuery.creation_date)-spacePos)#</span>
							</td>
							<td><span lang="es"><cfif itemsQuery.structure_available IS true>Sí<cfelse>No</cfif></span></td>
							<cfif arguments.tableTypeId IS 3><!---Typologies--->
								<td><span lang="es"><cfif itemsQuery.general IS true>Sí<cfelse>No</cfif></span></td>
								<td><a href="#APPLICATION.htmlPath#/area_items.cfm?area=#itemsQuery.area_id#&#itemTypeName#=#itemsQuery.id#" target="_blank" class="link_blue">#itemsQuery.area_name#</a></td>
							</cfif>							
						</tr>
					</cfloop>
					</tbody>
				
				</table>

				<cfif arguments.default_table_id IS NOT 0>
					<div style="margin-top:10px">
						<small class="help-block" lang="es">* #tableTypeNameEs# por defecto en esta área</small>
					</div>
				</cfif>
				
				</cfoutput>
			</cfif>	

			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>



	<!--- outputTablesFullList --->

	<cffunction name="outputTablesFullList" returntype="void" output="true" access="public">
		<cfargument name="itemsQuery" type="query" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="return_path" type="string" required="true">
		<cfargument name="return_page" type="string" required="false">
		<cfargument name="showLastUpdate" type="boolean" required="false" default="false">
		<cfargument name="generatePdf" type="boolean" required="false" default="false"><!--- true = Generate PDF --->
		<cfargument name="app_version" type="string" required="false" default="html2">
		
		<cfset var method = "outputTablesFullList">

		<cftry>
							
			<cfoutput>

			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<div class="elements_container">
				<cfloop query="itemsQuery">
	
					<cfif isDefined("arguments.return_page")>
						<cfset rpage = arguments.return_page>
					<cfelse>
						<cfset rpage = "#lCase(itemTypeNameP)#.cfm?area=#itemsQuery.area_id#">
					</cfif>
					
					<cfif itemTypeId NEQ 10>
						<cfset item_page_url = "#itemTypeName#.cfm?#itemTypeName#=#itemsQuery.id#&return_page=#URLEncodedFormat(rpage)#">
					<cfelse><!---Files--->
						<cfset item_page_url = "#itemTypeName#.cfm?#itemTypeName#=#itemsQuery.id#&area=#itemsQuery.area_id#&return_page=#URLEncodedFormat(rpage)#">
					</cfif>

					<div class="row element_item #itemTypeName#"><!--- row item container --->
						<div class="col-sm-12">

							<a name="#itemTypeName##itemsQuery.id#" class="item_anchor"></a>

							<div class="panel panel-default">
							  <div class="panel-body">
							   	
							   	<div class="row">

							   		<div class="col-xs-11">

								   		<div class="media"><!--- item user name and date --->

								   			<a class="media-left">
										    

										    	<cfif arguments.showLastUpdate IS false OR NOT isNumeric(itemsQuery.last_update_user_id) OR itemsQuery.user_in_charge EQ itemsQuery.last_update_user_id>
										    		<cfset userInCharge = itemsQuery.user_in_charge>
										    		<cfset userImageType = itemsQuery.user_image_type>
										    		<cfset userFullName = itemsQuery.user_full_name>
										    	<cfelse>
										    		<!--- Last update user --->
										    		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
														<cfinvokeargument name="user_id" value="#itemsQuery.last_update_user_id#">
													</cfinvoke>

													<cfset userInCharge = objectUser.id>
													<cfset userImageType = objectUser.image_type>
													<cfset userFullName = objectUser.user_full_name>
										    	</cfif>

												<cfif arguments.generatePdf IS false>
													
													<cfif len(userImageType) GT 0>
														<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#userInCharge#&type=#userImageType#&small=" alt="#userFullName#" class="user_img" style="width:48px" />								
													<cfelse>							
														<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#userFullName#" class="user_img_default" style="width:48px" />
													</cfif>

												</cfif>
												

										 	</a>
										 	<div class="media-body">

												<a href="area_user.cfm?area=#itemsQuery.area_id#&user=#itemsQuery.user_in_charge#" class="link_user">#userFullName#</a> 
									
												&nbsp;&nbsp;&nbsp;&nbsp;

												<cfif arguments.showLastUpdate IS false OR itemTypeId EQ 1 OR itemTypeId EQ 7 OR itemsQuery.creation_date EQ itemsQuery.last_update_date><!--- Creation date --->

													<cfinvoke component="#APPLICATION.componentsPath#/DateManager" method="timestampToString" returnvariable="stringDate">
														<cfinvokeargument name="timestamp_date" value="#itemsQuery.creation_date#">
													</cfinvoke>							
													<cfset spacePos = findOneOf(" ", stringDate)>
													<span class="text_date">
														<cfif spacePos GT 0>
														#left(stringDate, spacePos)#
														<cfelse><!---Esto es para que no de error en versiones antiguas de DoPlanning que tienen la fecha en otro formato--->
														#stringDate#
														</cfif>
													</span>&nbsp;&nbsp;&nbsp;
													<cfif spacePos GT 0>
														<span  class="text_hour">#right(stringDate, len(stringDate)-spacePos)#</span>
													</cfif>

												<cfelse><!--- Last update date --->
													
													<cfinvoke component="#APPLICATION.componentsPath#/DateManager" method="timestampToString" returnvariable="stringLastDate">
														<cfinvokeargument name="timestamp_date" value="#itemsQuery.last_update_date#">
													</cfinvoke>							
													<cfset spacePosLast = findOneOf(" ", stringLastDate)>
													<span class="text_date">
														#left(stringLastDate, spacePosLast)#
													</span>&nbsp;&nbsp;&nbsp;
													<cfif spacePosLast GT 0>
														<span class="text_hour">#right(stringLastDate, len(stringLastDate)-spacePosLast)#</span>
													</cfif>

												</cfif>	

												<cfif arguments.showLastUpdate IS true>
													&nbsp;&nbsp;
													<cfif itemsQuery.itemTypeId IS 10><!---Files---->
														<cfif  isNumeric(objectFile.replacement_user)>
															<span class="label label-info" lang="es">Nueva versión</span>									
														</cfif>
													<cfelseif itemTypeId NEQ 1 AND itemTypeId NEQ 7 AND itemsQuery.creation_date NEQ itemsQuery.last_update_date>

														<span class="label label-info" lang="es">Modificación</span>	

													</cfif>

												</cfif>

											</div>
										</div>

										<cfif arguments.generatePdf IS false>
											
											<hr style="margin:0"/>
												
										</cfif>

									</div>	

									<div class="col-xs-1"><!--- item type icon --->
										<div class="pull-right">

											<cfif arguments.generatePdf IS true><!--- PDF --->
												
												<i>#itemTypeNameEs#</i><br/><br/><br/>
											
											<cfelse>

													<a href="#APPLICATION.htmlPath#/#itemTypeName#.cfm?#itemTypeName#=#itemsQuery.id#&area=#itemsQuery.area_id#">
													
														<img src="#APPLICATION.htmlPath#/assets/v3/icons/#itemTypeName#.png" alt="#itemTypeNameEs#" title="#itemTypeNameEs#" style="width:60px;"/>
															
													</a>

											</cfif>

										</div>
									</div>
								</div>

								<div class="row">

									<div class="col-xs-12">

										<cfset titleContent = itemsQuery.title>
										
										<h4>#titleContent#</h4>
							
										<div style="font-size: 16px">

											<b lang="es">Estructura compartida</b> <span lang="es"><cfif itemsQuery.structure_available IS true>Sí<cfelse>No</cfif></span><br/>
											
											<cfif tableTypeId IS 3><!---Typologies--->
												<b lang="es">General</b> <span lang="es"><cfif itemsQuery.general IS true>Sí<cfelse>No</cfif></span><br/>

												<b lang="es">De esta área</b> <cfif itemsQuery.area_id EQ arguments.area_id>Sí<cfelse>No</cfif></span><br/>
											</cfif>

										</div>
										
										<div class="lead" style="clear:both;margin-top:15px;<cfif arguments.generatePdf IS false>margin-bottom:10px;</cfif>">
											#itemsQuery.description#
										</div>
										
									</div>

								</div>


								<!---<cfif arguments.deletedItems IS false>--->
								<div class="row">
									<div class="col-sm-12"><!--- URL --->

										<!---itemUrl--->
										<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaItemUrl" returnvariable="areaItemUrl">
											<cfinvokeargument name="item_id" value="#itemsQuery.id#">
											<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
											<cfinvokeargument name="area_id" value="#itemsQuery.area_id#">

											<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
										</cfinvoke>

										<cfif arguments.generatePdf IS false>

											<div style="margin-bottom:15px;">

												<div class="input-group">

													<span class="input-group-addon" style="padding-left:0"><i class="fa fa-share-alt" style="font-size: 16px;"></i></span>
													<input type="text" value="#areaItemUrl#" onClick="this.select();" class="form-control item_url_dp" readonly="readonly" style="cursor:text;border-bottom:none"/>

												</div>

											</div>

										<cfelse>

											<div style="margin-top:10px;">
												<a href="#areaItemUrl#" target="_blank">#areaItemUrl#</a>
											</div>

											<hr style="margin-bottom:35px;"/>

										</cfif>
										

									</div>
								</div>
								<!---</cfif>--->


								<cfif arguments.generatePdf IS false>
								<div class="row">
									<div class="col-sm-12">


										<cfif tableTypeId IS 3>
											<a href="#itemTypeName#_fields.cfm?#itemTypeName#=#itemsQuery.id#" class="btn btn-sm btn-primary" title="Campos"><i class="icon-wrench" style="font-size:15px;"></i> <span lang="es">Campos</span></a>	
										</cfif> 
												

										<div class="pull-right">

												
											<cfif arguments.app_version NEQ "mobile">
												<a href="#APPLICATION.htmlPath#/#itemTypeName#.cfm?#itemTypeName#=#item_id#&area=#itemsQuery.area_id#" title="Abrir en nueva ventana" target="_blank" class="btn btn-default btn-sm" lang="es"><i class="icon-external-link"></i></a>
											</cfif>
											
											<span class="divider">&nbsp;</span>

											<cfif NOT isDefined("arguments.area_id")>

												<cfif app_version EQ "mobile">

													<a href="area_items.cfm?area=#itemsQuery.area_id####itemTypeName##itemsQuery.id#" class="btn btn-sm btn-info" title="Ir al área"><img src="#APPLICATION.htmlPath#/assets/icons_dp/area_small_white.png" alt="Area" title="Ver en área"> <span lang="es">Ver en área</span></a>

												<cfelse>
													<!---onclick="openUrl('area_items.cfm?area=#itemsQuery.area_id#&#itemTypeName#=#itemsQuery.id#','areaIframe',event)"--->

													<a href="area_items.cfm?area=#itemsQuery.area_id#&#itemTypeName#=#itemsQuery.id#" class="btn btn-sm btn-info" title="Ir al área"><img src="#APPLICATION.htmlPath#/assets/icons_dp/area_small_white.png" alt="Area" title="Ver en área"> <span lang="es">Ver en área</span></a>

												</cfif>

											<cfelse>
												<!---onclick="openUrl('#itemTypeName#.cfm?#itemTypeName#=#itemsQuery.id#&area=#itemsQuery.area_id#','itemIframe',event)"--->
												<a href="#itemTypeName#.cfm?#itemTypeName#=#itemsQuery.id#&area=#itemsQuery.area_id#" class="btn btn-sm btn-info" title="Ver #itemTypeNameEs#"><span lang="es">Ver #itemTypeNameEs#</span></a>
											</cfif>

										</div>

									</div>
								</div>
								</cfif>


								</div>
							</div>
						
						</div><!--- END col --->
					</div><!---END row item container--->
				</cfloop>
				</div>
				</cfoutput>			
								
			
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>


</cfcomponent>