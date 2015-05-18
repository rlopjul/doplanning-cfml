
<cfif NOT isDefined("views_selectable")>
	<cfset views_selectable = false>
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<script>
	$(document).ready(function() { 
		
		<cfif views_selectable IS false>
			$("#dataTable").tablesorter({ 
				widgets: ['zebra','uitheme','select','filter','stickyHeaders'],
				theme : "bootstrap",
				headerTemplate : '{content} {icon}',
				sortList: [[2,1]],
				headers: {
			      0: { sorter: false },
			      2: { sorter: "datetime" }
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
		<cfelse>
			$("#dataTable").tablesorter({ 
				widgets: ['zebra','uitheme','stickyHeaders'],
				theme : "bootstrap",
				headerTemplate : '{content} {icon}',
				sortList: [[3,0]] ,
				headers: {
			      0: { sorter: false },
			      3: { sorter: "datetime" }
			    }
			});
		</cfif>

	}); 

	<!---<cfif views_selectable IS true>

		function stopPropagation(e) {
			if (!e) var e = window.event;
			e.cancelBubble = true;
			if (e.stopPropagation) e.stopPropagation();		
		}

	</cfif>--->
</script>

<cfset selectFirst = true>

<cfif isDefined("URL.view")>
	<cfset selectFirst = false>
</cfif>

<cfoutput>
<table id="dataTable" class="data-table table-hover" style="margin-top:5px;">
	<thead>
		<tr>
			<cfif views_selectable IS true>
			<th style="width:25px;text-align:center;"><input type="checkbox" name="select_all" checked="checked" onclick="toggleCheckboxesChecked(this.checked);"/></th>
			</cfif>
			<th>Nombre</th>
			<th>Área</th>
			<th>Fecha de creación</th>
			<th>Usuario</th>
		</tr>
	</thead>
	<tbody>

	<cfset alreadySelected = false>

	<cfloop query="views">

		<!---<cfif isDefined("arguments.return_page")>
			<cfset rpage = arguments.return_page>
		<cfelse>--->
			<cfset rpage = "#tableTypeName#_views.cfm?#tableTypeName#=#table_id#">
		<!---</cfif>--->
		<cfset view_page_url = "#tableTypeName#_view_modify.cfm?view=#views.view_id#&return_page=#URLEncodedFormat(rpage)#">

		<!---Row selection--->
		<cfset viewSelected = false>
		
		<cfif views_selectable IS false>
			
			<cfif alreadySelected IS false>

				<cfif ( isDefined("URL.view") AND (URL.view IS views.view_id) ) OR ( selectFirst IS true AND views.currentrow IS 1 AND app_version NEQ "mobile" ) >

					<!---Esta acción solo se completa si está en la versión HTML2--->
					<script type="text/javascript">
						openUrlHtml2('#view_page_url#','itemIframe');
					</script>

					<cfset viewSelected = true>
					<cfset alreadySelected = true>
																	
				</cfif>
				
			</cfif>

		</cfif>

		<tr <cfif viewSelected IS true>class="selected"</cfif> onclick="<cfif views_selectable IS false>openUrl('#view_page_url#','itemIframe',event)<cfelse>toggleCheckboxChecked('##view_#views.view_id#')</cfif>">
			<cfif views_selectable IS true>
				<td style="text-align:center;"><input type="checkbox" name="views_ids[]" id="view_#views.view_id#" value="#views.view_id#" checked="checked" onClick="stopPropagation(event);" /></td>
			</cfif>	
			<td>#views.title#</td>
			<td><a onclick="openUrl('area_items.cfm?area=#views.area_id#&#itemTypeName#=#views.view_id#','areaIframe',event)" class="link_blue">#views.area_name#</a>
			</td>
			<td>#views.creation_date#</td>
			<td>#views.user_full_name#</td>
		</tr>
	</cfloop>
	</tbody>
</table>
</cfoutput>