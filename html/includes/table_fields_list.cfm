
<cfif NOT isDefined("fields_selectable")>
	<cfset fields_selectable = false>
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<script type="text/javascript">
	$(document).ready(function() { 
		
		<cfif fields_selectable IS false>
			$("#dataTable").tablesorter({ 
				widgets: ['zebra','select'],
				sortList: [[0,0]] ,
			});
		<cfelse>
			$("#dataTable").tablesorter({ 
				widgets: ['zebra'],
				sortList: [[1,0]] ,
				 headers: {
			      0: { sorter: false },
			    },
			});
		</cfif>

	}); 

	<cfif fields_selectable IS true>
		
		function toggleCheckboxesChecked(status) {
			$("input").each( function() {
				$(this).attr("checked",status);
			})
		}

		function stopPropagation(e) {
			if (!e) var e = window.event;
			e.cancelBubble = true;
			if (e.stopPropagation) e.stopPropagation();		
		}

	</cfif>
</script>

<cfset selectFirst = true>

<cfif isDefined("URL.field")>
	<cfset selectFirst = false>
</cfif>

<cfoutput>
<table id="dataTable" class="table-hover" style="margin-top:5px;">
	<thead>
		<tr>
			<cfif fields_selectable IS true>
			<th style="width:25px;text-align:center;"><input type="checkbox" name="select_all" checked="checked" onclick="toggleCheckboxesChecked(this.checked);"/></th>
			</cfif>
			<th style="width:25px;">##</th>
			<th style="width:35%">Nombre del campo</th>
			<th>Tipo de campo</th>
			<th>Obligatorio</th>
			<th style="width:25%">Valor por defecto</th>
		</tr>
	</thead>
	<tbody>

	<cfset alreadySelected = false>

	<cfloop query="fields">

		<!---<cfif isDefined("arguments.return_page")>
			<cfset rpage = arguments.return_page>
		<cfelse>--->
			<cfset rpage = "#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#">
		<!---</cfif>--->
		<cfset field_page_url = "#tableTypeName#_field.cfm?field=#fields.field_id#&return_page=#URLEncodedFormat(rpage)#">

		<!---Row selection--->
		<cfset fieldSelected = false>
		
		<cfif fields_selectable IS false>
			
			<cfif alreadySelected IS false>

				<cfif ( isDefined("URL.field") AND (URL.field IS fields.field_id) ) OR ( selectFirst IS true AND fields.currentrow IS 1 AND app_version NEQ "mobile" ) >

					<!---Esta acción solo se completa si está en la versión HTML2--->
					<script type="text/javascript">
						openUrlHtml2('#field_page_url#','itemIframe');
					</script>

					<cfset fieldSelected = true>
					<cfset alreadySelected = true>
																	
				</cfif>
				
			</cfif>

		</cfif>

		<tr <cfif fieldSelected IS true>class="selected"</cfif> onclick="<cfif fields_selectable IS false>openUrl('#field_page_url#','itemIframe',event)<cfelse>toggleCheckboxChecked('##field_#fields.field_id#')</cfif>">
			<cfif fields_selectable IS true>
				<td style="text-align:center;"><input type="checkbox" name="fields_ids[]" id="field_#fields.field_id#" value="#fields.field_id#" checked="checked" onClick="stopPropagation(event);" /></td>
			</cfif>	
			<td>#fields.currentRow#</td>		
			<td>
				<span class="field_label">#fields.label#</span>
			</td>
			<td>
				#fields.name#
			</td>
			<td>
				<cfif fields.required IS true>Sí<cfelse>No</cfif>
			</td>
			<td>
				#fields.default_value#
			</td>
		</tr>
	</cfloop>
	</tbody>
</table>
</cfoutput>