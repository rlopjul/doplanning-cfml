<cfoutput>
<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.extras-0.1.22.min.js"></script>
<link href="#APPLICATION.path#/jquery/tablesorter/css/style.css" rel="stylesheet" type="text/css" media="all" />
</cfoutput>

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
			widgets: ['zebra'],
			sortList: [[3,1]] ,
			headers: { 
				0: { 
					sorter: false 
				},
				3: { 
					sorter: "datetime" 
				}
			} 
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

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getAreaFiles" returnvariable="xmlResponse">
	<cfinvokeargument name="area_id" value="#area_id#">
</cfinvoke>

<!---<textarea cols="70" rows="200">
<cfoutput>
#xmlResponse#
</cfoutput>
</textarea>--->

<cfxml variable="xmlFiles">
	<cfoutput>
	#xmlResponse.response.result.files#
	</cfoutput>
</cfxml>

<cfoutput>
<div class="div_head_subtitle_area">
<div class="div_head_subtitle_area_text"><strong>ARCHIVOS</strong><br/> del área</div>

<div class="div_element_menu">
	<div class="div_icon_menus"><a href="files.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/refresh.png" alt="Actualizar" title="Actualizar" /></a></div>
	<div class="div_text_menus"><a href="files.cfm?area=#area_id#"> Actualizar</a></div>
</div>
<div class="div_element_menu">
	<div class="div_icon_menus"><a href="file_associate.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/file_new.png" alt="Añadir archivo" title="Asociar archivo al área" /></a></div>
		<div class="div_text_menus"><a href="file_associate.cfm?area=#area_id#"> Añadir<br/> archivo</a></div>
</div>
<cfif APPLICATION.identifier NEQ "vpnet">
<div class="div_element_menu">
	<div class="div_icon_menus"><a href="area_file_new.cfm?area=#area_id#"><img src="#APPLICATION.htmlPath#/assets/icons/file_new.png" alt="Nuevo archivo" title="Nuevo archivo" /></a></div>
		<div class="div_text_menus"><a href="area_file_new.cfm?area=#area_id#"> Nuevo<br/> archivo</a></div>
</div>
</cfif>

</div>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfset numFiles = ArrayLen(xmlFiles.files.XmlChildren)>
<div class="div_files">
<!---<div class="div_separator"><!-- --></div>--->
<cfset page_type = 3>
<cfif numFiles GT 0>

	<cfoutput>
	
	<table id="listTable" class="tablesorter">
		<thead>
			<tr>
				<th style="width:33px"></th>
				<th style="width:55%">Archivo</th>
				<th style="width:23%">De</th>
				<!---<th style="width:12%">Tamaño</th>--->
				<th style="width:20%">Fecha</th>
			</tr>
		</thead>
	
	<cfloop index="xmlIndex" from="1" to="#numFiles#" step="1">
		<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="objectFile" returnvariable="objectFile">
				<cfinvokeargument name="xml" value="#xmlFiles.files.file[xmlIndex]#">
				<cfinvokeargument name="return_type" value="object">
		</cfinvoke>	
		<!---Importante: en este xml no viene user_full_name--->
		
		<!---<cfinclude template="#APPLICATION.htmlPath#/includes/element_file.cfm">--->
		
		<tr 
			<cfif page_type IS 1>
				onclick="goToUrl('my_files_file.cfm?folder=#folder_id#&file=#objectFile.id#')"
			<cfelseif page_type IS 2>
				onclick="submitForm('file_#objectFile.id#')"
			<cfelseif page_type IS 3>
				onclick="goToUrl('area_file.cfm?area=#area_id#&file=#objectFile.id#')"
			</cfif>
			>
			<td><cfif isDefined("page_type") AND page_type IS 2>
					<form name="file_#objectFile.id#" action="#APPLICATION.htmlComponentsPath#/File.cfc?method=associateFile" method="post" style="float:left;">
						<input type="hidden" name="area_id" value="#area_id#" />
						<input type="hidden" name="file_id" value="#objectFile.id#" />
						<input type="hidden" name="return_path" value="#return_path#" />
						<input type="image" src="#APPLICATION.htmlPath#/assets/icons/new_file.gif" class="img_file" title="Añadir archivo"/>
					</form>
				<cfelse>
					<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#objectFile.id#"><img src="#APPLICATION.htmlPath#/assets/icons/file_download.png" class="img_file"/></a>
				</cfif>
			</td>
			<td><cfif isDefined("page_type")>
				<cfif page_type IS 1>
				<a href="my_files_file.cfm?folder=#folder_id#&file=#objectFile.id#" class="text_file_name"><cfif len(objectFile.name) GT 0>#objectFile.name#<cfelse><i>Archivo sin nombre</i></cfif></a>
				<cfelseif page_type IS 2>
					<span class="text_file_name">#objectFile.name#</span>
				<cfelseif page_type IS 3>
					<a href="area_file.cfm?area=#area_id#&file=#objectFile.id#" class="text_file_name">#objectFile.name#</a>
				</cfif>
			</cfif></td>
			<td><span class="text_message_data">#objectFile.user_full_name#</span></td>
			<!---<td><span class="text_message_data">#objectFile.file_size#</span></td>--->
			<td><span class="text_message_data">#objectFile.association_date#</span></td>
		</tr>		
		
	</cfloop>
	
	</table>
	
	<!---<div class="div_separator"><!-- --></div>--->
	</cfoutput>
	
<cfelse>
	<div class="div_text_result">No hay archivos en esta área.</div>
</cfif>
</div>