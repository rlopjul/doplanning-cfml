<cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<script type="text/javascript">
	$(document).ready(function() { 
		
		$("##dataTable").tablesorter({ 
			widgets: ['zebra','filter','select','stickyHeaders'],
			sortList: [[0,1]] ,
			headers: { 

				<cfset fieldsWithDate = false>
					
				<cfloop query="fields">

					<cfif fields.field_id IS "creation_date" OR fields.field_id IS "last_update_date" OR fields.field_type_id IS 6><!--- DATE --->
						<cfif fieldsWithDate IS true>,</cfif>#fields.currentRow#: { 
							sorter: "datetime" 
						}
						<cfset fieldsWithDate = true>
					</cfif>

				</cfloop>
			},

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
				filter_searchDelay : 500,
				filter_serversideFiltering: false,
				filter_startsWith : false,
				filter_useParsedRow : false
		    }
		});
		
	}); 
</script>

<cfset selectFirst = true>
<cfset listFields = false>

<cfif isDefined("URL.field")>
	<cfset selectFirst = false>
</cfif>

<table id="dataTable" class="table-hover" style="margin-top:5px;">
	<thead>
		<tr>
			<th style="width:25px;">##</th>
			<!---<th>Fecha última modificación</th>--->
			<cfloop query="fields">
				<th>#fields.label#</th>
				<cfif fields.field_type_id EQ 9 OR fields.field_type_id IS 10><!--- LISTS --->
					<cfset listFields = true>
				</cfif>
			</cfloop>
		</tr>
	</thead>
	<tbody>

	<cfif listFields IS true>
		
		<!--- Get selected areas --->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getRowSelectedAreas" returnvariable="getRowSelectedAreasResponse">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		</cfinvoke>

		<cfset selectedAreas = getRowSelectedAreasResponse.areas>

	</cfif>

	<cfset alreadySelected = false>

	<cfloop query="tableRows">

		<cfif isDefined("view_id")>
			<cfset rpage = "#itemTypeName#_rows.cfm?#itemTypeName#=#view_id#">
			<cfset row_page_url = "#itemTypeName#_row.cfm?#itemTypeName#=#view_id#&row=#tableRows.row_id#&return_page=#URLEncodedFormat(rpage)#">
		<cfelse>
			<cfset rpage = "#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#">
			<cfset row_page_url = "#tableTypeName#_row.cfm?#tableTypeName#=#table_id#&row=#tableRows.row_id#&return_page=#URLEncodedFormat(rpage)#">
		</cfif>
		

		<!---Row selection--->
		<cfset dataSelected = false>
		
		<cfif alreadySelected IS false>

			<cfif ( isDefined("URL.row") AND (URL.row IS tableRows.row_id) ) OR ( selectFirst IS true AND tableRows.currentrow IS tableRows.recordCount AND app_version NEQ "mobile" ) >

				<!---Esta acción solo se completa si está en la versión HTML2--->
				<script type="text/javascript">
					openUrlHtml2('#row_page_url#','itemIframe');
				</script>

				<cfset dataSelected = true>
				<cfset alreadySelected = true>
																
			</cfif>
			
		</cfif>

		<tr <cfif dataSelected IS true>class="selected"</cfif> onclick="openUrl('#row_page_url#','itemIframe',event)">
			<td>#tableRows.row_id#</td>
			
			<cfset row_id = tableRows.row_id>
			<cfloop query="fields">

				<cfif fields.field_id IS "creation_date"><!--- CREATION DATE --->

					<td>#DateFormat(tableRows.creation_date, APPLICATION.dateFormat)# #TimeFormat(tableRows.creation_date, "HH:mm")#</td>

				<cfelseif fields.field_id IS "last_update_date"><!--- LAST UPDATE DATE --->
					
					<td><cfif len(tableRows.last_update_date) GT 0>#DateFormat(tableRows.last_update_date, APPLICATION.dateFormat)# #TimeFormat(tableRows.last_update_date, "HH:mm")#<cfelse>-</cfif></td>

				<cfelseif fields.field_id IS "insert_user"><!--- INSERT USER --->

					<td>#insert_user_full_name#</td>

				<cfelseif fields.field_id IS "update_user"><!--- UPDATE USER --->

					<td>#update_user_full_name#</td>

				<cfelse><!--- TABLE FIELDS --->

					<cfset field_value = "">

					<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- IS LIST --->

						<cfif selectedAreas.recordCount GT 0>

							<cfquery dbtype="query" name="rowSelectedAreas">
								SELECT name
								FROM selectedAreas
								WHERE field_id = <cfqueryparam value="#fields.field_id#" cfsqltype="cf_sql_integer">
								AND row_id = <cfqueryparam value="#row_id#" cfsqltype="cf_sql_integer">;
							</cfquery>

							<cfif rowSelectedAreas.recordCount GT 0>
								<cfset field_value = valueList(rowSelectedAreas.name, "<br/>")>
							</cfif>

						</cfif>
						
					<cfelse><!--- IS NOT LIST --->

						<cfset field_value = tableRows['field_#fields.field_id#']>

						<cfif len(field_value) GT 0>
							<cfif fields.field_type_id IS 6><!--- DATE --->
								<cfset field_value = DateFormat(dateConvert("local2Utc",field_value), APPLICATION.dateFormat)>
							<cfelseif fields.field_type_id IS 7><!--- BOOLEAN --->
								<cfif field_value IS true>
									<cfset field_value = "Sí">
								<cfelseif field_value IS false>
									<cfset field_value = "No">
								</cfif>
								<cfset field_value = '<span lang="es">#field_value#</span>'>
							<cfelse>

								<cfif fields.field_type_id IS 2 OR fields.field_type_id IS 3 OR fields.field_type_id IS 11><!--- TEXTAREA --->
									
									<cfif len(field_value) GT 60><!---200--->

										<cfif fields.field_type_id IS NOT 2>

											<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="removeHTML" returnvariable="field_value">
												<cfinvokeargument name="string" value="#field_value#">
											</cfinvoke>
						
										</cfif>

										<!---<cfset field_value = left(field_value, 180)&"...">ANTES ESTABA ASÍ--->
										<cfset summary_value = left(field_value, 55)&"...">

										<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="insertBR" returnvariable="summary_value">
											<cfinvokeargument name="string" value="#summary_value#">
										</cfinvoke>

										<cfif fields.field_type_id IS NOT 11><!--- IS NOT Very long text --->
											<cfset field_value = '#summary_value#<span class="hidden">#field_value#</span>'>
										<cfelse>
											<cfset field_value = summary_value>
										</cfif>											

									<cfelseif fields.field_type_id IS 2>

										<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="insertBR" returnvariable="field_value">
											<cfinvokeargument name="string" value="#field_value#">
										</cfinvoke>

									</cfif>

								</cfif>
								
							</cfif>
						</cfif>

					</cfif>

					<td>#field_value#</td>

				</cfif>

			</cfloop>
		</tr>
	</cfloop>
	</tbody>
</table>

</cfoutput>