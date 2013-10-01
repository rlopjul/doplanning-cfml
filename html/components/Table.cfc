<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="true">

	<cfset component = "Table">
	<cfset request_component = "TableManager">


	<!--- -------------------------------createTable-------------------------------------- --->
	
    <cffunction name="createTable" returntype="struct" access="public">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
				
		<cfset var method = "createTable">

		<cfset var response = structNew()>
		
		<cftry>
					
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="createTable" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Tabla creada">
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
		
		<cfset var method = "getTableData">

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



	<!--- -------------------------------createTable-------------------------------------- --->
	
    <cffunction name="createTable" returntype="struct" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="link" type="string" required="false" default="">
		<cfargument name="area_id" type="numeric" required="true">
        <cfargument name="position" type="numeric" required="false">
				
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
				<cfif isDefined("arguments.position")>
					<cfinvokeargument name="position" value="#arguments.position#">
				</cfif>
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>


	<!--- -------------------------------updateTable-------------------------------------- --->
	
    <cffunction name="updateTable" returntype="struct" access="public">
    	<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="label" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="required" type="boolean" required="false" default="false">
        <cfargument name="default_value" type="string" required="true">
		
		<cfset var method = "updateTable">

		<cfset var response = structNew()>
		
		<cftry>
					
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="updateTable" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Campo modificado">
			</cfif>
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>


	<!--- ----------------------------------- outputTablesList ------------------------------------- --->

	<cffunction name="outputTablesList" returntype="void" output="true" access="public">
		<cfargument name="itemsQuery" type="query" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="full_content" type="boolean" required="no" default="false">
		<cfargument name="return_page" type="string" required="no">
		<cfargument name="app_version" type="string" required="true">
		
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
						<cfset item_page_url = "#itemTypeName#.cfm?#itemTypeName#=#itemsQuery.id#&return_page=#URLEncodedFormat(rpage)#">
						
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
							<td><a href="#item_page_url#" class="text_item">#itemsQuery.title#</a></td>
							<td>
							<!---
							<cfif itemTypeId IS 11 OR itemTypeId IS 12 OR itemTypeId IS 13><!---Lists, Typologies, Forms--->
								<a href="#itemTypeName#_fields.cfm?#itemTypeName#=#itemsQuery.id#" onclick="event.stopPropagation()" title="Campos" class="btn btn-mini"><i class="icon-wrench"></i></a>
							</cfif>--->
							<cfif itemTypeId IS 11 OR itemTypeId IS 13><!---Lists, Forms--->
								<a href="#itemTypeName#_rows.cfm?#itemTypeName#=#itemsQuery.id#" onclick="event.stopPropagation()" title="Registros"><i class="icon-list" style="font-size:15px;"></i></a>
							</cfif>
							</td>
							<td><cfset spacePos = findOneOf(" ", itemsQuery.creation_date)>
								<span>#left(itemsQuery.creation_date, spacePos)#</span>
								<span class="hidden">#right(itemsQuery.creation_date, len(itemsQuery.creation_date)-spacePos)#</span>
							</td>							
						</tr>
					</cfloop>
					</tbody>
				
				</table>
				</cfoutput>
			</cfif>		
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>

</cfcomponent>