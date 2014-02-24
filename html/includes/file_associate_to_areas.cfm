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

		<cfif isDefined("FORM.publication_date")>
			<cfinvokeargument name="publication_date" value="#FORM.publication_date#">
		</cfif>
		<cfif isDefined("FORM.publication_hour")>
			<cfinvokeargument name="publication_hour" value="#FORM.publication_hour#">
		</cfif>
		<cfif isDefined("FORM.publication_minute")>
			<cfinvokeargument name="publication_minute" value="#FORM.publication_minute#">
		</cfif>
		<cfif isDefined("FORM.publication_validated")>
			<cfinvokeargument name="publication_validated" value="#FORM.publication_validated#">
		</cfif>
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

<script src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js"></script>

<script type="text/javascript">
	var applicationId = "#APPLICATION.identifier#";
	var applicationPath = "#APPLICATION.path#";
</script>
<script src="#APPLICATION.htmlPath#/scripts/tree.min.js?v=2.3"></script>

<cfif APPLICATION.moduleWeb IS true>
	<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
	<script src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
	<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>
</cfif>

</cfoutput>

<script type="text/javascript">
	
	function treeLoaded() { 
		
		$("#loadingContainer").hide();
		$("#mainContainer").show();
	}

	function areaSelected(areaId)  {
		var checkBoxId = "#area"+areaId;
		if($(checkBoxId).attr('disabled')!='disabled')
			toggleCheckboxChecked(checkBoxId);
	}
	
	function searchTextInTree(){
		searchInTree(document.getElementById('searchText').value);	
	}

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
	
	$(window).load( function() {
		showTree(true);

		$("#searchText").on("keydown", function(e) { 
			
			if(e.which == 13) { //Enter key

				if(e.preventDefault)
				e.preventDefault();

				searchTextInTree();
			}
			
		});

		<cfif APPLICATION.moduleWeb IS true>
		$('#publication_date').datepicker({
			format: 'dd-mm-yyyy',
			weekStart: 1,
			language: 'es',
			todayBtn: 'linked', 
			autoclose: true
		});
		</cfif>

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
			
<div id="mainContainer" style="clear:both;display:none;padding-left:5px;">
<cfform name="add_file_to_areas" method="post" action="#CGI.SCRIPT_NAME#" class="form-horizontal" style="clear:both;" onsubmit="return onSubmitForm();">
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

	<cfif APPLICATION.publicationScope IS true AND isNumeric(objectFile.publication_scope_id)>
		<div>
			<span class="help-block">Ámbito de publicación definido para el archivo: #objectFile.publication_scope_name#</span>
		</div>
	</cfif>
	
	<input type="submit" class="btn btn-primary" value="Añadir archivo a áreas seleccionadas" />
	
	<a href="#return_page#" class="btn btn-default" style="float:right;">Cancelar</a>
	
	<div style="margin-top:2px;">

		<div class="btn-group">
			<div class="input-group" style="width:260px;" >
				<input type="text" name="text" id="searchText" value="" class="form-control"/>
				<span class="input-group-btn">
					<button onClick="searchTextInTree()" class="btn btn-default" type="button" title="Buscar área en el árbol" lang="es"><i class="icon-search"></i> <span lang="es">Buscar</span></button>
				</span>
			</div>
		</div>

		<!---<a onClick="expandTree();" class="btn btn-default" title="Expandir todo el árbol" lang="es"><i class="icon-plus"></i> <span lang="es">Expandir</span></a>
		<a onClick="collapseTree();" class="btn btn-default" title="Colapsar todo el árbol" lang="es"><i class="icon-minus"></i> <span lang="es">Colapsar</span></a>--->

	</div>
	<div id="areasTreeContainer" style="clear:both; margin-top:2px; margin-bottom:2px;">

	<cfif APPLICATION.publicationScope IS true AND isNumeric(objectFile.publication_scope_id)>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Scope" method="getScopeAreas" returnvariable="getScopesResult">
			<cfinvokeargument name="scope_id" value="#objectFile.publication_scope_id#">
		</cfinvoke>
		<cfset scopesQuery = getScopesResult.scopesAreas>
		<cfset scopeAreasList = valueList(scopesQuery.area_id)>

	</cfif>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaTree" method="outputMainTree">
		<!--- Ahora sí se pueden asociar archivos internos a las áreas web
		<cfinvokeargument name="disable_input_web" value="true"><!---Esto es para que no se puedan asociar archivos a las áreas WEB---> --->
		
		<cfif APPLICATION.publicationScope IS true AND isNumeric(objectFile.publication_scope_id) AND listLen(scopeAreasList) GT 0>
			<cfinvokeargument name="enable_only_areas_ids" value="#scopeAreasList#"><!--- Habilita sólo las áreas pasadas y sus descendientes --->
		</cfif>
		<cfinvokeargument name="with_input_type" value="checkbox">
	</cfinvoke>
	</div>
	
	<script type="text/javascript">
		addRailoRequiredCheckBox("areas_ids[]","Debe seleccionar al menos un área");			
	</script>


	<cfif APPLICATION.moduleWeb IS true>
	
		<div class="row">

			<cfif isDefined("FORM.publication_hour")><!--- After send FORM --->

				<cfset publication_hour = FORM.publication_hour>
				<cfset publication_minute = FORM.publication_minute>

				<cfset publication_date = FORM.publication_date>

			<cfelse>
				
				<cfset publication_hour = timeFormat(now(), "HH")>
				<cfset publication_minute = timeFormat(now(), "mm")>

				<cfset publication_date = DateFormat(now(),APPLICATION.dateFormat)>

			</cfif>

			<div class="col-xs-6 col-md-3">
				<label class="control-label" for="publication_date"><span lang="es">Fecha de publicación</span></label>
				<cfinput type="text" name="publication_date" id="publication_date" class="form-control" value="#publication_date#" required="false" message="Fecha de publicación válida requerida" validate="eurodate" mask="DD-MM-YYYY">
			</div>
						
			<div class="col-xs-6">
				 
				<!---<label class="control-label" for="publication_hour"><span lang="es">Hora de publicación</span></label>
				<div class="input-group" style="width:170px">
					<select name="publication_hour" id="publication_hour" class="form-control" style="width:70px;">
						<cfloop from="00:00" to="23:00" step="#CreateTimeSpan(0, 1, 0, 0)#" index="hour">
							<cfset curHour = TimeFormat(hour, 'HH')>
							<option value="#curHour#" <cfif curHour EQ publication_hour>selected="selected"</cfif>>#curHour#</option>
						</cfloop>
					</select><span class="input-group-addon">:</span><select name="publication_minute" class="form-control" style="width:70px;">
						<cfset minutesInOptions = false>
						<cfloop from="0" to="59" index="minutes" step="5">
							<cfif len(minutes) EQ 1>
								<cfset minutes = "0"&minutes>
							</cfif>
							<cfif minutes EQ publication_minute>
								<cfset minutesSelected = true>
								<cfset minutesInOptions = true>
							<cfelse>
								<cfset minutesSelected = false>
							</cfif>
							<option value="#minutes#" <cfif minutesSelected>selected="selected"</cfif>>#minutes#</option>
						</cfloop>
						<cfif minutesInOptions IS false AND len(publication_minute) GT 0>
							<option value="#publication_minute#" selected="selected">#publication_minute#</option>
						</cfif>
					</select>
				</div>--->
						
			</div>
			
			<input type="hidden" name="publication_hour" value="00"/>
			<input type="hidden" name="publication_minute" value="00"/>
			
		</div>

		<div class="row">
			<div class="col-sm-12">
				<small class="help-block">Si está definida, el archivo se publicará en la fecha especificada (sólo para publicación en web e intranet).</small>
			</div>
		</div>

		<cfif APPLICATION.publicationValidation IS true>

			<!--- isUserAreaResponsible --->
			<cfif is_user_area_responsible IS true>
				
				<div class="row">
					<div class="col-xs-12 col-sm-8">
						<div class="checkbox">
							<label>
								<input type="checkbox" name="publication_validated" id="publication_validated" value="true" class="checkbox_locked" <cfif NOT isDefined("FORM.publication_validated") OR FORM.publication_validated IS true>checked="checked"</cfif> /> Aprobar publicación
							</label>
							<small class="help-block">Valida el archivo para que pueda ser publicado (sólo para publicación en web e intranet).</small>
						</div>
					</div>
				</div>

			</cfif>

		</cfif>

	</cfif>

	
	<cfinput name="submit" type="submit" class="btn btn-primary" value="Añadir archivo a áreas seleccionadas"/>
	<a href="#return_page#" class="btn btn-default" style="float:right;">Cancelar</a>
	</cfoutput>
</cfform>
	
	<div style="height:5px;"><!-- --></div>
	
	<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="returnElement">
		<cfinvokeargument name="return_page" value="#return_page#">
	</cfinvoke>--->
</div>