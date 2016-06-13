<!--- page_types:
		1 Mis documentos
		2 Asociar archivo a un área
		3 Archivos de un área

		En las últimas versiones sólos se utiliza page_type 3 porque Mis documentos y Asociar archivo a un área ya no están disponibles
 --->
<cfset page_type = 3>

<cfif full_content IS false>
	<cfset select_enabled = true>
<cfelse>
	<cfset select_enabled = false>
</cfif>


<script>
	$(document).ready(function() {

		$("#listTable").tablesorter({
			<cfif full_content IS false>
			widgets: ['zebra','filter'],
			<cfelse>
			widgets: ['zebra'],
			</cfif>
			<cfif select_enabled IS true>
				sortList: [[6,1]] ,
				headers: {
					0: {
						sorter: false
					},
					1: {
						sorter: false
					},
					2: {
						sorter: "text"
					},
					5: {
						sorter: "datetime"
					},
					6: {
						sorter: "datetime"
					}
				},
			<cfelse>
				sortList: [[5,1]] ,
				headers: {
					0: {
						sorter: false
					},
					1: {
						sorter: "text"
					},
					4: {
						sorter: "datetime"
					},
					5: {
						sorter: "datetime"
					}
				},
			</cfif>
			<cfif full_content IS false>
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


		<cfif select_enabled IS true>

			$('#listTable tbody input[type=checkbox]').on('click', function(e) {

	    	stopPropagation(e);

	    	if( $('#listTable tbody tr:visible input[type=checkbox]:checked').length > 0 )
					$('#actionFilesNavBar').show();
				else
					$('#actionFilesNavBar').hide();

	    });

		</cfif>


  });

	<cfoutput>

	<cfif select_enabled IS true>

		function goToAssociateFileToAreas() {

			var associateFilesIds = "";

			$('##listTable tbody tr:visible input[type=checkbox]:checked').each(function() {

				if(associateFilesIds.length > 0)
					associateFilesIds = associateFilesIds+","+this.value;
				else
					associateFilesIds = this.value;

			});

			if(associateFilesIds.length > 0)
				goToUrl("area_file_associate_areas.cfm?area=#area_id#&files="+associateFilesIds);
			else
				parent.showAlertModal("No hay archivos seleccionados");

		}

	</cfif>

	</cfoutput>

</script>

<div class="row">

	<nav class="navbar-default" id="actionFilesNavBar" style="display:none">
		<div class="container">
			<div class="row">
				<div class="col-sm-12">

					<div class="btn-toolbar">
						<div class="btn-group">
							<button class="btn btn-info btn-sm navbar-btn" onclick="goToAssociateFileToAreas()"><i class="icon-plus icon-white"></i> <span lang="es">Asociar a áreas</span></button>
						</div>
					</div>

				</div>
			</div>
		</div>
	</nav>

</div>

<cfset numFiles = files.recordCount>
<div class="div_items">

<cfif numFiles GT 0>

	<cfoutput>

	<table id="listTable" class="table table-hover table-bordered table-striped tablesorter-bootstrap">
		<thead>
			<tr>
				<cfif full_content IS false><!--- Files of one area --->
					<cfif select_enabled IS true>
						<th style="width:35px;" class="filter-false"></th>
					</cfif>
					<th style="width:32px" class="filter-false"></th>
					<th style="width:37%" lang="es">Archivo</th>
					<th style="width:6%" lang="es">Tipo</th>
					<th style="width:20%" lang="es">De</th>
					<th style="width:18%" lang="es">Fecha asociación</th>
					<th style="width:17%" lang="es">Última versión</th>
				<cfelse>
					<th style="width:32px"></th>
					<th style="width:21%" lang="es">Archivo</th>
					<th style="width:6%" lang="es">Tipo</th>
					<th style="width:18%" lang="es">De</th>
					<th style="width:17%" lang="es">Fecha asociación</th>
					<th style="width:17%" lang="es">Última versión</th>
					<th style="width:19%" lang="es">Área</th>
				</cfif>
			</tr>
		</thead>
	<tbody>

	<cfset alreadySelected = false>

	<cfloop query="files">

		<!---File selection--->
		<cfset itemSelected = false>

		<cfset item_page_url = "file.cfm?area=#files.area_id#&file=#files.id#">

		<tr data-item-url="#item_page_url#" data-item-id="#files.id#" onclick="stopEvent(event)" <cfif itemSelected IS true>class="selected"</cfif>>

			<cfif select_enabled IS true>
				<td style="text-align:center" onclick="stopEvent(event)">
					<input type="checkbox" name="selected_file_#files.id#" value="#files.id#">
				</td>
			</cfif>

			<td style="text-align:center">
				<cfif isDefined("page_type") AND page_type IS 2>
					<form name="file_#files.id#" action="#APPLICATION.htmlComponentsPath#/File.cfc?method=associateFile" method="post" style="float:left;">
						<input type="hidden" name="area_id" value="#files.area_id#" />
						<input type="hidden" name="file_id" value="#files.id#" />
						<input type="hidden" name="return_path" value="#return_path#" />
						<input type="image" src="#APPLICATION.htmlPath#/assets/v3/icons/new_file.gif" class="img_file" title="Añadir archivo"/>
					</form>
				<cfelse>

					<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFileIcon" returnvariable="file_icon">
						<cfinvokeargument name="file_name" value="#files.file_name#"/>
					</cfinvoke>

					<cfif page_type IS 3>
						<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#files.id#&area=#area_id#" target="_blank" onclick="return downloadFileLinked(this,event)" title="Descargar">
							<i class="#file_icon#" style="font-size:24px"></i>
						</a>
					<cfelse>
						<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#files.id#" target="_blank" onclick="return downloadFileLinked(this,event)" title="Descargar">
						<i class="#file_icon#" style="font-size:24px"></i>
					</a>
					</cfif>


				</cfif><!---style="max-width:none;" Requerido para corregir un bug con Bootstrap en Chrome--->
			</td>
			<td><cfif isDefined("page_type")>
					<cfif page_type IS 1>
					<a href="my_files_file.cfm?folder=#folder_id#&file=#files.id#" class="text_item"><cfif len(files.name) GT 0>#files.name#<cfelse><i><span lang="es">Archivo sin nombre</span></i></cfif></a>
					<cfelseif page_type IS 2>
						<span class="text_item">#files.name#</span>
					<cfelseif page_type IS 3>
						<a href="file.cfm?area=#files.area_id#&file=#files.id#" class="text_item">#files.name#</a>
					</cfif>
			</cfif></td>
			<td><span>#files.file_type#</span></td>
			<td><cfif files.file_type_id IS 1>

				<div style="float:left;margin-right:5px;">
				<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUserImage">
					<cfinvokeargument name="user_id" value="#files.user_in_charge#">
					<cfinvokeargument name="user_full_name" value="#files.user_full_name#">
					<cfinvokeargument name="user_image_type" value="#files.user_image_type#">
					<cfinvokeargument name="width_px" value="40">
				</cfinvoke>
				</div>
				<span>#files.user_full_name#</span>

			<cfelse><i><span lang="es">Área</span></i></cfif>
			</td>
			<cfset addedDate = files.association_date>
			<cfset spacePos = findOneOf(" ", addedDate)>
			<td>
				<span>#left(addedDate, spacePos)#</span>
				<span class="hidden">#right(addedDate, len(addedDate)-spacePos)#</span>
			</td>
			<td><cfif len(files.replacement_date) GT 0>
				<cfset spacePos2 = findOneOf(" ", files.replacement_date)>
				<span>#left(files.replacement_date, spacePos2)#</span>
				<span class="hidden">#right(files.replacement_date, len(files.replacement_date)-spacePos2)#</span>
			<cfelse>
				<span>#left(addedDate, spacePos)#</span>
				<span class="hidden">#right(addedDate, len(addedDate)-spacePos)#</span>
			</cfif></td>

			<cfif full_content IS true>
				<td>
				<a onclick="openUrl('area_items.cfm?area=#files.area_id#&file=#files.id#','areaIframe',event)" class="link_blue">#files.area_name#</a>
				</td>
			</cfif>
		</tr>

	</cfloop>
	</tbody>

	</table>

	</cfoutput>

<cfelse>
	<div class="alert alert-info" role="alert" style="margin:10px;"><i class="icon-info-sign"></i> <span lang="es">No hay archivos en esta área.</span></div>
</cfif>
</div>
