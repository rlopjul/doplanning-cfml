<cfset itemTypeId = 10>
<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

<cfif isDefined("URL.file") AND isNumeric(URL.file) AND isDefined("URL.area") AND isNumeric(URL.area)>

	<cfset file_id = URL.file>
	<cfset area_id = URL.area>

	<!---<cfset return_page = "file.cfm?file=#file_id#&area=#area_id#">--->

	<!--- File --->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="objectFile">
		<cfinvokeargument name="file_id" value="#file_id#">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>

	<cfset fileTypeId = objectFile.file_type_id>

	<cfif fileTypeId IS 1 AND (SESSION.user_id NEQ objectFile.user_in_charge AND SESSION.user_id NEQ SESSION.client_administrator)>
		<!--- Access denied --->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Error" method="showError">
			<cfinvokeargument name="error_code" value="103">
		</cfinvoke>
	<cfelseif fileTypeId IS NOT 1><!---Area file--->

		<!---area_allowed--->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="canUserAccessToArea" returnvariable="file_area_allowed">
			<cfinvokeargument name="area_id" value="#objectFile.area_id#">
		</cfinvoke>

		<cfif file_area_allowed IS false>
			<!--- Access denied --->
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Error" method="showError">
				<cfinvokeargument name="error_code" value="103">
			</cfinvoke>
		</cfif>

	</cfif>

	<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

	<!---<cfinclude template="#APPLICATION.htmlPath#/includes/file_name_head.cfm">--->

	<cfoutput>
	<!---<div class="div_message_page_title">#objectFile.name#</div>
	<div class="div_separator"><!-- --></div>--->

	<cfif app_version NEQ "mobile">

		<div class="div_head_subtitle_area">

			<div class="btn-toolbar" style="padding-right:5px;">

				<!---<a href="area_items.cfm?area=#area_id#&file=#file_id#" class="btn btn-default btn-sm" title="Archivo" lang="es"> <img style="height:22px;" src="/html/assets/icons/file_edited.png">&nbsp;&nbsp;<span lang="es">Archivo</span></a>--->

				<div class="btn-group">
					<a href="area_items.cfm?area=#area_id#&file=#file_id#" class="btn btn-default btn-sm" title="Área" lang="es"> <img src="/html/assets/icons_dp/area_small.png" style="height:17px;" alt="Área" lang="es">&nbsp;<span lang="es">Área</span></a>
				</div>

				<div class="btn-group pull-right">
					<a href="#APPLICATION.htmlPath#/file_areas.cfm?file=#file_id#&area=#area_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px;"></i></a>
				</div>

			</div>

		</div>
	</cfif>
	</cfoutput>

	<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

	<cfoutput>
	<div class="div_items">


	<cfif fileTypeId NEQ 3><!--- User and Area file (without versions) --->

		<!--- File areas --->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFileAreas" returnvariable="areasResult">
			<cfinvokeargument name="file_id" value="#file_id#">
			<cfinvokeargument name="accessCheck" value="false">
		</cfinvoke>
		<cfset fileAreas = areasResult.fileAreas>

		<!---<cfoutput>
		<ul class="list-group">
		<cfloop query="fileAreas">
			<li class="list-group-item" style="padding:5px">
				<a onclick="openUrl('area_items.cfm?area=#fileAreas.area_id#&file=#file_id#','areaIframe',event)">#fileAreas.name#</a>

				<a href="#APPLICATION.htmlPath#/file.cfm?file=#file_id#&area=#fileAreas.area_id#" title="Abrir en nueva ventana" target="_blank" class="btn btn-default btn-sm" lang="es"><i class="icon-external-link"></i></a>
				<span class="divider">&nbsp;</span>
				<a onclick="openUrl('area_items.cfm?area=#fileAreas.area_id#&file=#file_id#','areaIframe',event)" class="btn btn-sm btn-info" title="Ir al área"><img src="#APPLICATION.htmlPath#/assets/icons_dp/area_small.png" alt="Area" title="Ver en área"><span lang="es">Ver en área</a>
			</li>
		</cfloop>
		</ul>
		</cfoutput>--->

		<script>
			$(document).ready(function() {

				$("##listTable").tablesorter({
					widgets: ['zebra','uitheme'], <!---,'select'--->
					theme : "bootstrap",
					headerTemplate : '{content} {icon}',
					sortList: [[1,1]] ,
					<!--- http://mottie.github.io/tablesorter/docs/example-option-date-format.html ---->
					dateFormat: "ddmmyyyy", // set the default date format
					headers: {
						1: {
							sorter: "shortDate"
						}
					}
				});


				$('##listTable tbody tr').on('click', function(e) {

			       	var row = $(this);

			        if(!row.hasClass("selected")) {
			        	$('##listTable tbody tr').removeClass("selected");
			        	row.addClass("selected");
			        }

			        var itemUrl= row.data("item-url");
				    openUrlLite(itemUrl,'itemIframe');

			    });


			});
		</script>

		<table id="listTable" class="tablesorter" style="margin-top:5px;">
			<thead>
				<tr>
					<!---<th style="width:25px;">##</th>--->
					<th><span lang="es">Área</span></th>
					<th><span lang="es">Fecha de asociación</span></th>
				</tr>
			</thead>

			<tbody>
			<cfset curFileAreaId = area_id>
			<cfset alreadySelected = false>

			<cfloop query="fileAreas">

				<!---<cfset rpage = "file_areas.cfm?file=#file_id#">--->
				<cfset file_page_url = "file.cfm?file=#file_id#&area=#fileAreas.area_id#"><!---&return_page=#URLEncodedFormat(rpage)#--->

				<!---Row selection--->
				<cfset fieldSelected = false>

				<cfif alreadySelected IS false>

					<cfif fileAreas.area_id EQ curFileAreaId AND app_version NEQ "mobile">

						<cfset onpenUrlHtml2 = file_page_url>

						<cfset fieldSelected = true>
						<cfset alreadySelected = true>

					</cfif>

				</cfif>

				<tr <cfif fieldSelected IS true>class="selected"</cfif> <cfif fileAreas.area_id EQ curFileAreaId>style="font-weight:bold"</cfif> data-item-url="#file_page_url#">
					<!---<td>#fileAreas.currentRow#</td>--->
					<td><a onclick="openUrl('area_items.cfm?area=#fileAreas.area_id#&file=#file_id#','areaIframe',event)">#fileAreas.name#</a></td>
					<!---<cfset uploadDate = fileAreas.association_date>
					<cfset spacePos = findOneOf(" ", uploadDate)>--->
					<td>
						<!---<span>#left(uploadDate, spacePos)#</span>
						<span class="hidden">#right(uploadDate, len(uploadDate)-spacePos)#</span>--->
						<span>#fileAreas.association_date#</span>
					</td>
				</tr>
			</cfloop>
			</tbody>
		</table>


	<cfelse><!--- fileTypeId 3 --->


		<!--- File versions --->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFileVersions" returnvariable="versionsResult">
			<cfinvokeargument name="file_id" value="#file_id#">
			<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
		</cfinvoke>
		<cfset versions = versionsResult.fileVersions>

		<script>
			$(document).ready(function() {

				$("##listTable").tablesorter({
					widgets: ['zebra','uitheme'], <!---,'select'--->
					theme : "bootstrap",
					headerTemplate : '{content} {icon}',
					sortList: [[4,1]] ,
					<!--- http://mottie.github.io/tablesorter/docs/example-option-date-format.html ---->
					dateFormat: "ddmmyyyy", // set the default date format
					headers: {
						0: {
							sorter: "shortDate"
						},
						4: {
							sorter: "shortDate"
						}
					}
				});


				$('##listTable tbody tr').on('click', function(e) {

			       	var row = $(this);

			        if(!row.hasClass("selected")) {
			        	$('##listTable tbody tr').removeClass("selected");
			        	row.addClass("selected");
			        }

			        var itemUrl= row.data("item-url");
				    openUrlLite(itemUrl,'itemIframe');

			    });


			});
		</script>

		<cfset curFileAreaId = area_id>
		<cfset alreadySelected = false>

		<cfset filePublished = false>

		<table id="listTable" class="tablesorter" style="margin-top:5px;">
			<thead>
				<tr>
					<!---<th style="width:25px;">##</th>--->
					<th>Fecha de versión</th>
					<th>Archivo</th>
					<th>Tamaño</th>
					<th>Área</th>
					<th>Fecha de asociación</th>
				</tr>
			</thead>

			<tbody>

			<cfloop query="versions">

				<cfif isNumeric(versions.publication_file_id)>

					<cfset filePublished = true>

					<!--- File areas --->
					<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFileAreas" returnvariable="areasResult">
						<cfinvokeargument name="file_id" value="#versions.publication_file_id#">
						<cfinvokeargument name="accessCheck" value="false">
					</cfinvoke>
					<cfset fileAreas = areasResult.fileAreas>

					<cfloop query="fileAreas">

						<!---<cfset rpage = "file_areas.cfm?file=#file_id#">--->
						<cfset file_page_url = "file.cfm?file=#versions.publication_file_id#&area=#fileAreas.area_id#"><!---&return_page=#URLEncodedFormat(rpage)#--->

						<!---Row selection--->
						<cfset fieldSelected = false>

						<cfif alreadySelected IS false>

							<cfif fileAreas.area_id EQ curFileAreaId AND app_version NEQ "mobile">

								<cfset onpenUrlHtml2 = file_page_url>

								<cfset fieldSelected = true>
								<cfset alreadySelected = true>

							</cfif>

						</cfif>

						<tr <cfif fieldSelected IS true>class="selected"</cfif> <cfif fileAreas.area_id EQ curFileAreaId>style="font-weight:bold"</cfif> data-item-url="#file_page_url#">
							<!---<td>#fileAreas.currentRow#</td>--->
							<td>#versions.uploading_date#</td>
							<td>#versions.file_name#</td>
							<td><!---fileSize--->
								<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="trasnformFileSize" returnvariable="fileSize">
									<cfinvokeargument name="file_size_full" value="#versions.file_size#">
								</cfinvoke>
								<span>#fileSize#</span>
							</td>
							<td><a onclick="openUrl('area_items.cfm?area=#fileAreas.area_id#&file=#versions.publication_file_id#','areaIframe',event)">#fileAreas.name#</a></td>
							<!---<cfset uploadDate = fileAreas.association_date>
							<cfset spacePos = findOneOf(" ", uploadDate)>--->
							<td>
								<!---<span>#left(uploadDate, spacePos)#</span>
								<span class="hidden">#right(uploadDate, len(uploadDate)-spacePos)#</span>--->
								<span>#fileAreas.association_date#</span>
							</td>
						</tr>
					</cfloop>

				</cfif>

			</cfloop>
			</tbody>
		</table>

		<cfif filePublished IS false>

			<div class="alert alert-info"><span lang="es">Este archivo de área no se ha publicado en otras áreas</span></div>

		</cfif>


	</cfif>

	</div>

		<cfif isDefined("onpenUrlHtml2")>

			<!---Esta acción sólo se completa si está en la versión HTML2--->
			<script>
				openUrlHtml2('#onpenUrlHtml2#','itemIframe');
			</script>

		</cfif>

	</cfoutput>

</cfif>
