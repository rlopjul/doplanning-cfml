<!---Required var: 
	page_type
	return_path
	
	page_type 1:
		folder_id
	page_type 2:
		area_id
--->
<cfif isDefined("FORM.areas_ids") AND isDefined("FORM.file_id")>

	<cfset file_id = FORM.file_id>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="associateFileToAreas" returnvariable="resultAddFiles">
		<cfinvokeargument name="file_id" value="#file_id#">
		<cfinvokeargument name="areas_ids" value="#FORM.areas_ids#">
	</cfinvoke>
	<cfset msg = resultAddFiles.message>
	<cfset res = resultAddFiles.result>
	
	<cfif isDefined("FORM.area_id")>
		<cflocation url="#return_path#file.cfm?file=#file_id#&area=#FORM.area_id#&res=#res#&msg=#URLEncodedFormat(msg)#" addtoken="no">
	<cfelseif isDefined("FORM.folder_id")>
		<cflocation url="#return_path#my_files_file.cfm?file=#file_id#&folder=#FORM.folder_id#&res=#res#&msg=#URLEncodedFormat(msg)#" addtoken="no">
	</cfif>	

</cfif>

<cfoutput>

<script type="text/javascript" src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js"></script>

<script type="text/javascript">
	var applicationId = "#APPLICATION.identifier#";
	var applicationPath = "#APPLICATION.path#";
</script>
<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/tree.min.js"></script>
</cfoutput>

<script type="text/javascript">
	
	function areaSelected(areaId)  {
		var checkBoxId = "#area"+areaId;
		if($(checkBoxId).attr('disabled')!='disabled')
			toggleCheckboxChecked(checkBoxId);
	}
	
	function treeLoaded (event, data) { //JStree loaded
		$("#areasTreeContainer").bind("select_node.jstree", function (e, data) {
			var $obj = data.rslt.obj;
			areaSelected($obj.attr("id"));
		});
		
		$("#loadingContainer").hide();
		$("#mainContainer").show();
	}
	
	$(window).load( function() {
		showTree(true);/*,""*/
	});

</script>

<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	<cfset area_id = URL.area>
</cfif>
<cfif isDefined("URL.folder") AND isNumeric(URL.folder)>
	<cfset folder_id = URL.folder>
</cfif>

<cfif isDefined("area_id")>
<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/file_head.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="objectFile">
	<cfinvokeargument name="file_id" value="#file_id#">
	<!---<cfif isDefined("area_id")>
	<cfinvokeargument name="area_id" value="#area_id#">
	</cfif>--->
</cfinvoke>
<cfoutput>
<div class="div_file_page_name">#objectFile.name#</div>
</cfoutput>

<div class="div_head_subtitle">
<cfif page_type IS 1>
Asociar archivo a áreas
<cfelse>
<!---Copiar archivo a áreas--->
Asociar archivo a áreas
</cfif>
</div>

<div class="alert alert-info" style="margin:5px;">Seleccione las áreas a las que desea asociar el archivo:</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/loading_div.cfm">

<script type="text/javascript">
function onSubmitForm()
{
	if(check_custom_form())
	{
		//document.getElementById("submitDiv").innerHTML = "Enviando...";

		return true;
	}
	else
		return false;
}
</script>
			
<div id="mainContainer" style="clear:both;display:none;padding-left:5px;">
<cfform name="add_file_to_areas" method="post" action="#CGI.SCRIPT_NAME#" style="clear:both;" onsubmit="return onSubmitForm();">
	<cfoutput>
	
	<script type="text/javascript">
		var railo_custom_form=new RailoForms('add_file_to_areas');
	</script>
	<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js"></script>
	
	<input type="hidden" name="file_id" value="#file_id#">
	<cfif isDefined("area_id")>
	<input type="hidden" name="area_id" value="#area_id#">
	</cfif>
	<cfif isDefined("folder_id")>
	<input type="hidden" name="folder_id" value="#folder_id#">
	</cfif>
	
	</cfoutput>
	
	<!---<div id="buttons">
	<cfoutput>
	<cfif isDefined("area_id")>
		<a href="#return_path#file.cfm?file=#file_id#&area=#area_id#">Cancelar</a>
	<cfelseif isDefined("folder_id")>
		<a href="#return_path#my_files_file.cfm?file=#file_id#&folder=#folder_id#">Cancelar</a>
	</cfif>
	</cfoutput>
	</div>--->
	<cfif isDefined("area_id")>
		<cfset return_page = "#return_path#file.cfm?file=#file_id#&area=#area_id#">
	<cfelseif isDefined("folder_id")>
		<cfset return_page = "#return_path#my_files_file.cfm?file=#file_id#&folder=#folder_id#">
	</cfif>
	
	<cfoutput>
	
	<input type="submit" class="btn btn-primary" value="Añadir archivo a áreas seleccionadas" />
	
	<a href="#return_page#" class="btn" style="float:right;">Cancelar</a>
	
	<div id="areasTreeContainer" style="clear:both; margin-top:2px; margin-bottom:2px;">
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaTree" method="outputMainTree">
		<cfif APPLICATION.identifier EQ "dp">
			<cfinvokeargument name="disable_input_web" value="true"><!---Esto es para que no se puedan asociar archivos a las áreas WEB--->
		</cfif>
		<cfinvokeargument name="with_input_type" value="checkbox">
	</cfinvoke>
	</div>
	
	<script type="text/javascript">
		addRailoRequiredCheckBox("areas_ids[]","Debe seleccionar al menos un área");			
	</script>
	
	<cfinput name="submit" type="submit" class="btn btn-primary" value="Añadir archivo a áreas seleccionadas"/>
	<a href="#return_page#" class="btn" style="float:right;">Cancelar</a>
	</cfoutput>
</cfform>
	
	<div style="height:5px;"><!-- --></div>
	
	<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
		<cfinvokeargument name="return_page" value="#return_page#">
	</cfinvoke>--->
</div>