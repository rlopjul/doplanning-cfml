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
		
		$("#listTable").tablesorter({ 
			<cfif full_content IS false>
			widgets: ['zebra','filter','select'],
			<cfelse>
			widgets: ['zebra','select'],
			</cfif>
			sortList: [[5,1]] ,
			headers: { 
				0: { 
					sorter: false 
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
		
		//  Adds "over" class to rows on mouseover
		$("#listTable tr").mouseover(function(){
		  $(this).addClass("over");
		});
	
		//  Removes "over" class from rows on mouseout
		$("#listTable tr").mouseout(function(){
		  $(this).removeClass("over");
		});
		
    }); 
	
</script>

<cfset iconTypes = "pdf,rtf,txt,doc,docx,png,jpg,jpeg,gif,rar,zip,xls,xlsm,xlsmx,ppt,pptx,pps,ppsx,odt">

<cfset numFiles = ArrayLen(xmlFiles.files.XmlChildren)>
<div class="div_items">
<!---<div class="div_separator"><!-- --></div>--->
<cfset page_type = 3>
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
	
	<cfloop index="xmlIndex" from="1" to="#numFiles#" step="1">
			
		<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="objectFile" returnvariable="objectFile">
				<cfinvokeargument name="xml" value="#xmlFiles.files.file[xmlIndex]#">
				<cfinvokeargument name="return_type" value="object">
		</cfinvoke>	
		<!---Importante: en este xml no viene user_full_name--->
		
		<!---<cfinclude template="#APPLICATION.htmlPath#/includes/element_file.cfm">--->

		<cfif isDefined("area_id")>
			<cfset objectFile.area_id = area_id>
		</cfif>

		<!---File selection--->
		<cfset itemSelected = false>
		
		<cfif alreadySelected IS false>
		
			<cfif isDefined("URL.file")>
			
				<cfif URL.file IS objectFile.id>
					<!---Esta acción solo se completa si está en la versión HTML2--->
					<script type="text/javascript">
						openUrlHtml2('file.cfm?area=#objectFile.area_id#&file=#objectFile.id#','itemIframe');
					</script>
					<cfset itemSelected = true>
				</cfif>
				
			<cfelseif xmlIndex IS 1>
			
				<!---Esta acción solo se completa si está en la versión HTML2--->
				<script type="text/javascript">
					openUrlHtml2('file.cfm?area=#objectFile.area_id#&file=#objectFile.id#','itemIframe');
				</script>
				<cfset itemSelected = true>
				
			</cfif>
			
			<cfif itemSelected IS true>
				<cfset alreadySelected = true>
			</cfif>
			
		</cfif>
				
		
		<tr <cfif itemSelected IS true>class="selected"</cfif>
			<!---<cfif page_type IS 1>
				onclick="goToUrl('my_files_file.cfm?folder=#folder_id#&file=#objectFile.id#')"--->
			<cfif page_type IS 2>
				onclick="submitForm('file_#objectFile.id#')"
			<cfelseif page_type IS 3>
				<!---onclick="goToUrl('file.cfm?area=#area_id#&file=#objectFile.id#')"--->
				onclick="openUrl('file.cfm?area=#objectFile.area_id#&file=#objectFile.id#','itemIframe',event)"
			</cfif>
			>
			<td style="text-align:center"><cfif isDefined("page_type") AND page_type IS 2>
					<form name="file_#objectFile.id#" action="#APPLICATION.htmlComponentsPath#/File.cfc?method=associateFile" method="post" style="float:left;">
						<input type="hidden" name="area_id" value="#objectFile.area_id#" />
						<input type="hidden" name="file_id" value="#objectFile.id#" />
						<input type="hidden" name="return_path" value="#return_path#" />
						<input type="image" src="#APPLICATION.htmlPath#/assets/icons/new_file.gif" class="img_file" title="Añadir archivo"/>
					</form>
				<cfelse>

					<cfset fileType = replace(objectFile.file_type,".","")>
					<cfif listFind (iconTypes, fileType)>
						<cfset fileIcon = "_"&fileType>
					<cfelse>
						<cfset fileIcon = "">
					</cfif>

					<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#objectFile.id#" target="_blank" onclick="return downloadFileLinked(this,event)" title="Descargar"><img src="#APPLICATION.htmlPath#/assets/icons/file#fileIcon#.png" class="img_file" style="max-width:none;"/></a>
					<!---<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#objectFile.id#" target="_blank" onclick="return downloadFileLinked(this,event)" title="Descargar"><img src="#APPLICATION.htmlPath#/assets/icons/file_download.png" class="img_file" style="max-width:none;"/></a>--->
				</cfif><!---style="max-width:none;" Requerido para corregir un bug con Bootstrap en Chrome--->
			</td>
			<td><cfif isDefined("page_type")>
					<cfif page_type IS 1>
					<a href="my_files_file.cfm?folder=#folder_id#&file=#objectFile.id#" class="text_item"><cfif len(objectFile.name) GT 0>#objectFile.name#<cfelse><i><span lang="es">Archivo sin nombre</span></i></cfif></a>
					<cfelseif page_type IS 2>
						<span class="text_item">#objectFile.name#</span>
					<cfelseif page_type IS 3>
						<a href="file.cfm?area=#objectFile.area_id#&file=#objectFile.id#" class="text_item">#objectFile.name#</a>
					</cfif>
			</cfif></td>
			<td><span class="text_message_data">#objectFile.file_type#</span></td>
			<td><span class="text_message_data">#objectFile.user_full_name#</span></td>
			<!---<td><span class="text_message_data">#objectFile.file_size#</span></td>--->
			<td>
				<cfset spacePos = findOneOf(" ", objectFile.association_date)>
				<span class="text_message_data">#left(objectFile.association_date, spacePos)#</span>
				<span class="hidden">#right(objectFile.association_date, len(objectFile.association_date)-spacePos)#</span>
			</td>
			<td><cfif len(objectFile.replacement_date) GT 0>				
				<cfset spacePos2 = findOneOf(" ", objectFile.replacement_date)>
				<span class="text_message_data">#left(objectFile.replacement_date, spacePos2)#</span>
				<span class="hidden">#right(objectFile.replacement_date, len(objectFile.replacement_date)-spacePos2)#</span>
			<cfelse>
				<span class="text_message_data">#left(objectFile.association_date, spacePos)#</span>
				<span class="hidden">#right(objectFile.association_date, len(objectFile.association_date)-spacePos)#</span>
			</cfif></td>
			
			<cfif full_content IS true>
				<td>
				<a onclick="openUrl('files.cfm?area=#objectFile.area_id#&file=#objectFile.id#','areaIframe',event)" class="link_blue">#objectFile.area_name#</a>
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

	<div class="div_text_result"><span lang="es">No hay archivos en esta área.</span></div>
</cfif>
</div>