<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">	

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<script type="text/javascript">
	$(document).ready(function() { 


		$.tablesorter.addParser({
			id: "datetime",
			is: function(s) {
				return false; 
			},
			format: function(s,table) {
				s = s.replace(/\-/g,"/");
				s = s.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/, "$3/$2/$1");
				return $.tablesorter.formatFloat(new Date(s).getTime());
			},
			type: "numeric"
		});
		
		
		$("#dataTable").tablesorter({ 
			widgets: ['zebra','select'],
			sortList: [[2,1]] ,
			headers: { 
				1: { 
					sorter: "datetime" 
				},
			},
		});


	}); 
</script>

<cfset selectFirst = true>

<cfif isDefined("URL.file_version")>
	<cfset selectFirst = false>
</cfif>

<cfoutput>
<table id="dataTable" class="table-hover" style="margin-top:5px;">
	<thead>
		<tr>
			<!---<th style="width:25px;">##</th>--->
			<th>Archivo</th>
			<th>Usuario</th>
			<th>Fecha</th>
			<th>Tamaño</th>
			<th>Aprobada</th>
			<th>Publicada</th>
		</tr>
	</thead>
	<tbody>

	<cfset alreadySelected = false>

	<cfloop query="versions">

		<!---<cfif isDefined("arguments.return_page")>
			<cfset rpage = arguments.return_page>
		<cfelse>--->
			<cfset rpage = "file_versions.cfm?#fileTypeName#=#file_id#">
		<!---</cfif>--->
		<cfset version_page_url = "file_version.cfm?file_version=#versions.version_id#&return_page=#URLEncodedFormat(rpage)#">

		<!---Row selection--->
		<cfset fieldSelected = false>
		
		<cfif alreadySelected IS false>

			<cfif ( isDefined("URL.file_version") AND (URL.file_version IS versions.version_id) ) OR ( selectFirst IS true AND versions.currentrow IS 1 AND app_version NEQ "mobile" ) >

				<!---Esta acción solo se completa si está en la versión HTML2--->
				<script type="text/javascript">
					openUrlHtml2('#version_page_url#','itemIframe');
				</script>

				<cfset fieldSelected = true>
				<cfset alreadySelected = true>
																
			</cfif>
			
		</cfif>


		<tr <cfif fieldSelected IS true>class="selected"</cfif> <cfif versions.currentRow IS 1>style="font-weight:bold"</cfif> onclick="openUrl('#version_page_url#','itemIframe',event)">
			<!---<td>#versions.currentRow#</td>--->		
			<td>#versions.file_name#</td>
			<cfset uploadDate = versions.uploading_date>	
			<cfset spacePos = findOneOf(" ", uploadDate)>
			<td>
				<cfif len(versions.user_image_type) GT 0>
					<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#versions.user_in_charge#&type=#versions.user_image_type#&small=" alt="#versions.user_full_name#" class="item_img"/>									
				<cfelse>							
					<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#versions.user_full_name#" class="item_img_default" />
				</cfif>
				<span>#versions.user_full_name#</span>
			</td>
			<td>
				<span>#left(uploadDate, spacePos)#</span>
				<span class="hidden">#right(uploadDate, len(uploadDate)-spacePos)#</span>
			</td>
			<td>
				<!---fileUrl--->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="trasnformFileSize" returnvariable="fileSize">
					<cfinvokeargument name="file_size_full" value="#versions.file_size#">
				</cfinvoke>
				<span>#fileSize#</span>
			</td>
			<td>
				<span lang="es"><cfif versions.approved IS true>Sí<cfelse>No</cfif></span>
			</td>
			<td>
				<span lang="es"><cfif isNumeric(versions.publication_file_id)>Sí<cfelse>No</cfif></span>
			</td>
		</tr>
	</cfloop>
	</tbody>
</table>
</cfoutput>

<div style="margin-top:10px">
	<small class="help-block" lang="es">Se muestra en negrita la versión vigente (última versión) del archivo.</small>
</div>