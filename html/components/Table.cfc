<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="true">

	<cfset component = "Table">
	<cfset request_component = "TableManager">


	<!--- -------------------------------createTable-------------------------------------- --->
	
    <cffunction name="createTable" returntype="struct" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="link" type="string" required="false" default="">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="structure_available" type="boolean" required="false" default="false">
		<cfargument name="general" type="boolean" required="false" default="false">
				
		<cfset var method = "createTable">

		<cfset var response = structNew()>
		
		<cftry>

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
					
			<cfinvoke component="AreaItem" method="createItem" returnvariable="response">
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
				<cfinvokeargument name="title" value="#arguments.title#">
				<cfinvokeargument name="link" value="#arguments.link#">
				<cfinvokeargument name="description" value="#arguments.description#">
				<cfinvokeargument name="parent_id" value="#arguments.area_id#">
				<cfinvokeargument name="parent_kind" value="area">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="structure_available" value="#arguments.structure_available#">
				<cfinvokeargument name="general" value="#arguments.general#">
			</cfinvoke>

			<cfif response.result IS true>

				<cfif tableTypeGender EQ "male">
					<cfset response_message = "#tableTypeNameEs# creado, defina ahora los campos.">
				<cfelse>
					<cfset response_message = "#tableTypeNameEs# creada, defina ahora los campos.">
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
			</cfinvoke>
			
			<cfif response.result IS true>

				<cfif tableTypeGender EQ "male">
					<cfset response_message = "#tableTypeNameEs# modificado.">
				<cfelse>
					<cfset response_message = "#itemTypeNameEs# modificada.">
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
		
		<cfset var method = "getAreaTables">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getAreaTables" returnvariable="response">
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

		<cfset var method = "getTableFields">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTableFields" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="with_types" value="#arguments.with_types#"/>
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
		
		<cfset var method = "getTableRows">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTableRows" returnvariable="response">
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

		<cfset var method = "outputItemsList">

		<cftry>
			
			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<cfset numItems = itemsQuery.recordCount>
			
			<cfif numItems GT 0>
			
				<script type="text/javascript">
					$(document).ready(function() { 
						
						$("##dataTable").tablesorter({ 
							<cfif arguments.full_content IS false>
							widgets: ['zebra','filter','select'],
							<cfelse>
							widgets: ['zebra','select'],
							</cfif>
							sortList: [[2,1]],
							headers: { 
								1: { 
									sorter: false 
								},
								2: { 
									sorter: "datetime" 
								}
							},
							<cfif arguments.full_content IS false>
							widgetOptions : {
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
						    }, 
						    </cfif> 
						});
						
					}); 
				</script>
				
				
				<cfoutput>
				
				<table id="dataTable" class="table-hover">
					<thead>
						<tr>
							<th lang="es">Nombre</th>
							<th class="filter-false" style="width:55px;"></th>
							<th style="width:20%;" lang="es">Fecha</th>
							<th>Estructura compartida</th>
							<cfif tableTypeId IS 3><!---Typologies--->
							<th>De esta área</th>
							<th>General</th>	
							</cfif>
							<cfif arguments.full_content IS true>
							<th lang="es">Área</th>
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

						<cfif isDefined("arguments.area_id")>
							<cfset item_page_url = "#itemTypeName#.cfm?#itemTypeName#=#itemsQuery.id#&area=#arguments.area_id#&return_page=#URLEncodedFormat(rpage)#">
						<cfelse>
							<cfset item_page_url = "#itemTypeName#.cfm?#itemTypeName#=#itemsQuery.id#&return_page=#URLEncodedFormat(rpage)#">
						</cfif>
						
						<!---Item selection--->
						<cfset itemSelected = false>
						
						<cfif alreadySelected IS false>
						
							<cfif isDefined("URL.#itemTypeName#")>
							
								<cfif URL[itemTypeName] IS itemsQuery.id>
								
									<!---Esta acción solo se completa si está en la versión HTML2--->
									<script type="text/javascript">
										openUrlHtml2('#item_page_url#','itemIframe');
									</script>
									<cfset itemSelected = true>
									
								</cfif>
								
							<cfelseif itemsQuery.currentRow IS 1>
							
								<cfif app_version NEQ "mobile">
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
			
						<tr <cfif itemSelected IS true>class="selected"</cfif> onclick="openUrl('#item_page_url#','itemIframe',event)">													
							<td><a href="#item_page_url#" class="text_item" <cfif arguments.default_table_id IS itemsQuery.id>style="font-weight:bold"</cfif>>#itemsQuery.title# <cfif arguments.default_table_id IS itemsQuery.id>*</cfif></a></td>
							<td>

							<cfif itemTypeId IS 11 OR itemTypeId IS 12><!---Lists, Forms--->

								<cfif arguments.full_content IS true><!--- Search page --->
									<cfset rowsOnClick = "openUrl('#itemTypeName#_rows.cfm?#itemTypeName#=#itemsQuery.id#&area=#itemsQuery.area_id#','areaIframe',event)">
								<cfelse>
									<cfset rowsOnClick = "openUrl('#itemTypeName#_rows.cfm?#itemTypeName#=#itemsQuery.id#','_self',event)">
								</cfif>
								<a href="#itemTypeName#_rows.cfm?#itemTypeName#=#itemsQuery.id#" onclick="#rowsOnClick#" title="Registros"><i class="icon-list" style="font-size:15px;"></i></a>

							</cfif>
							</td>
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
								<td><a onclick="openUrl('#itemTypeNameP#.cfm?area=#itemsQuery.area_id#&#itemTypeName#=#itemsQuery.id#','areaIframe',event)" class="link_blue">#itemsQuery.area_name#</a></td>
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

</cfcomponent>