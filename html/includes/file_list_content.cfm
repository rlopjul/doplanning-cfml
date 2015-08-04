<!--- page_types:
		1 Mis documentos
		2 Asociar archivo a un área
		3 Archivos de un área

		En las últimas versiones sólos se utiliza page_type 3 porque Mis documentos y Asociar archivo a un área ya no están disponibles
 --->
<cfset page_type = 3>


<script>
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
		
		$("#listTable").tablesorter({ 
			<cfif full_content IS false>
			widgets: ['zebra','uitheme','filter','select'],
			<cfelse>
			widgets: ['zebra','uitheme','select'],
			</cfif>
			theme : "bootstrap",
			headerTemplate : '{content} {icon}',
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
		
		<!---//  Adds "over" class to rows on mouseover
		$("#listTable tr").mouseover(function(){
		  $(this).addClass("over");
		});
	
		//  Removes "over" class from rows on mouseout
		$("#listTable tr").mouseout(function(){
		  $(this).removeClass("over");
		});--->

    }); 
	
</script>

<!---<cfset iconTypes = "pdf,rtf,txt,doc,docx,png,jpg,jpeg,gif,rar,zip,xls,xlsm,xlsx,ppt,pptx,pps,ppsx,odt">--->

<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFileIconsTypes" returnvariable="iconTypes">
</cfinvoke>--->

<cfset numFiles = files.recordCount>
<div class="div_items">
<!---<div class="div_separator"><!-- --></div>--->

<cfif numFiles GT 0>

	<cfoutput>
	
	<table id="listTable" class="tablesorter">
		<thead>
			<tr>
				<cfif full_content IS false>
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
					<!---<th style="width:12%" lang="es">Tamaño</th>--->
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
		
		<!---
		<cfif alreadySelected IS false AND NOT isDefined("URL.field")><!---No es selección de archivo--->
		
			<cfif isDefined("URL.file")>
			
				<cfif URL.file IS files.id>
					<!---Esta acción solo se completa si está en la versión HTML2--->
					<script type="text/javascript">
						openUrlHtml2('file.cfm?area=#files.area_id#&file=#files.id#','itemIframe');
					</script>
					<cfset itemSelected = true>
				</cfif>
				
			<cfelseif files.currentRow IS 1>
			
				<!---Esta acción solo se completa si está en la versión HTML2--->
				<script type="text/javascript">
					openUrlHtml2('file.cfm?area=#files.area_id#&file=#files.id#','itemIframe');
				</script>
				<cfset itemSelected = true>
				
			</cfif>
			
			<cfif itemSelected IS true>
				<cfset alreadySelected = true>
			</cfif>
			
		</cfif>
		--->

		<cfset item_page_url = "file.cfm?area=#files.area_id#&file=#files.id#">

		<tr data-item-url="#item_page_url#" data-item-id="#files.id#" onclick="stopEvent(event)" <cfif itemSelected IS true>class="selected"</cfif>>
			<td style="text-align:center"><cfif isDefined("page_type") AND page_type IS 2>
					<form name="file_#files.id#" action="#APPLICATION.htmlComponentsPath#/File.cfc?method=associateFile" method="post" style="float:left;">
						<input type="hidden" name="area_id" value="#files.area_id#" />
						<input type="hidden" name="file_id" value="#files.id#" />
						<input type="hidden" name="return_path" value="#return_path#" />
						<input type="image" src="#APPLICATION.htmlPath#/assets/v3/icons/new_file.gif" class="img_file" title="Añadir archivo"/>
					</form>
				<cfelse>

					<!---<cfset fileType = lCase(replace(files.file_type,".",""))>
					<cfif listFind (iconTypes, fileType)>
						<cfset fileIcon = "_"&fileType>
					<cfelse>
						<cfset fileIcon = "">
					</cfif>

					<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#files.id#" target="_blank" onclick="return downloadFileLinked(this,event)" title="Descargar"><img src="#APPLICATION.htmlPath#/assets/v3/icons/file#fileIcon#.png" class="img_file" style="max-width:none;"/></a>--->

					<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFileIcon" returnvariable="file_icon">
						<cfinvokeargument name="file_name" value="#files.file_name#"/>
					</cfinvoke>

					<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#files.id#" target="_blank" onclick="return downloadFileLinked(this,event)" title="Descargar">
						<i class="#file_icon#" style="font-size:24px"></i>
					</a>
					
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

				<!---<cfif len(files.user_image_type) GT 0>
					<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#files.user_in_charge#&type=#files.user_image_type#&small=" alt="#files.user_full_name#" class="item_img"/>									
				<cfelse>							
					<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#files.user_full_name#" class="item_img_default" />
				</cfif>--->

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUserImage">
					<cfinvokeargument name="user_id" value="#files.user_in_charge#">
					<cfinvokeargument name="user_full_name" value="#files.user_full_name#">
					<cfinvokeargument name="user_image_type" value="#files.user_image_type#">
					<cfinvokeargument name="width_px" value="40">
				</cfinvoke>
				&nbsp;
				<span>#files.user_full_name#</span>

			<cfelse><i><span lang="es">Área</span></i></cfif>
			</td>
			<!---<td><span>#files.file_size#</span></td>--->
			<!---<cfif len(files.association_date) GT 0>
				<cfset addedDate = files.association_date>				
			<cfelse>
				<cfset addedDate = files.uploading_date>
			</cfif>--->
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
	
	<script type="text/javascript">
		openUrlHtml2('empty.cfm','itemIframe');
	</script>

	<!---<div class="div_text_result"><span lang="es">No hay archivos en esta área.</span></div>--->
	<div class="alert alert-info" role="alert" style="margin:10px;"><i class="icon-info-sign"></i> <span lang="es">No hay archivos en esta área.</span></div>
</cfif>
</div>