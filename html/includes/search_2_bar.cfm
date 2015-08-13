
<cfoutput>
	<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
	<script src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
	<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>
	<script src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js?v=2"></script>

	<script src="#APPLICATION.path#/jquery/jquery.highlight.js"></script>

	<!---bootstrap-select--->
	<!---<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.2/css/bootstrap-select.min.css"/>
	<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.2/js/bootstrap-select.min.js"></script>--->

</cfoutput>

<cfif NOT isDefined("itemTypeId")>
	<cfset itemTypeId = "">
</cfif>

<cfif isDefined("URL.text")>
	<cfset search_text = URL.text>
	<cfset search_text_highlight = replace(search_text,' ','","',"ALL")>
	<cfoutput>
		<script>
			$(document).ready(function() {
			  <!---$(".text_item").highlight("#search_text#");--->
			  <cfif NOT isDefined("curElement") OR curElement NEQ "areas">
				$(".text_item").highlight(["#search_text_highlight#"]);	
			  <cfelse>
			  	$("h5").highlight(["#search_text_highlight#"]);	
			  </cfif>
			});			
		</script>
	</cfoutput>
<cfelse>
	<cfset search_text = "">
</cfif>

<cfif isDefined("URL.from_user") AND isNumeric(URL.from_user)>
	<cfset user_in_charge = URL.from_user>
<cfelse>
	<cfset user_in_charge = "">
</cfif>

<cfif isDefined("URL.to_user") AND isNumeric(URL.to_user)>
	<cfset recipient_user = URL.to_user>
<cfelse>
	<cfif NOT isDefined("URL.to_user") AND isDefined("SESSION.user_id")>
		<cfset recipient_user = SESSION.user_id>
	<cfelse>
		<cfset recipient_user = "">
	</cfif>
</cfif>

<cfif isDefined("URL.done") AND isNumeric(URL.done)>
	<cfset is_done = URL.done>
<cfelse>
	<cfset is_done = 0>
</cfif>

<cfif isDefined("URL.state")>
	<cfset cur_state = URL.state>
<cfelse>
	<cfset cur_state = "">
</cfif>

<cfif isDefined("URL.limit") AND isNumeric(URL.limit)>
	<cfset limit_to = URL.limit>
<cfelse>
	<cfset limit_to = 100>
</cfif>


<cfif isDefined("URL.from_date")>
	<cfset from_date = URL.from_date>
<cfelse>
	<cfset from_date = "">
</cfif>

<cfif isDefined("URL.end_date")>
	<cfset end_date = URL.end_date>
<cfelse>
	<cfset end_date = "">
</cfif>

<cfif isDefined("URL.identifier")>
	<cfset identifier = URL.identifier>
<cfelse>
	<cfset identifier = "">
</cfif>

<cfif isDefined("URL.typology_id")>
	<cfset selected_typology_id = URL.typology_id>
<cfelse>
	<cfset selected_typology_id = "">
</cfif>


<cfif NOT isDefined("curElement") OR curElement NEQ "users">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUsers" returnvariable="getUsersResponse">	
	</cfinvoke>
	
	<cfset users = getUsersResponse.users>
	<cfset numUsers = ArrayLen(users)>

</cfif>


<script>
	
	$(function() {

		$('#from_date').datepicker({
		  format: 'dd-mm-yyyy', 
		  autoclose: true,
		  weekStart: 1,
		  language: 'es',
		  todayBtn: 'linked',
		  endDate: $('#end_date').val()  
		});
	
		$('#end_date').datepicker({
		  format: 'dd-mm-yyyy',
		  weekStart: 1,
		  language: 'es',
		  todayBtn: 'linked', 
		  autoclose: true
		});

		<!---$('.selectpicker').selectpicker();--->

	});
	
	
	function setEndDate(){
		$('#from_date').datepicker('setEndDate', $('#end_date').val());
	}

	function setFromDate(){
		$('#end_date').datepicker('setStartDate', $('#from_date').val());
	}


	function onSubmitForm() {

		// Update textareas content from ckeditor
		/*for (var i in CKEDITOR.instances) {

		    (function(i){
		        CKEDITOR.instances[i].updateElement();
		    })(i);

		}*/

		if(check_custom_form())	{
			//document.getElementById("submitDiv").innerHTML = window.lang.translate("Enviando archivo...");

			return true;
		}
		else
			return false;
	}

	<cfoutput>
	<!---function loadTypology(typologyId,rowId) {

		if(!isNaN(typologyId)){

			showLoadingPage(true);

			var typologyPage = "#APPLICATION.htmlPath#/html_content/typology_row_form_inputs.cfm?typology="+typologyId;

			if(!isNaN(rowId)){
				typologyPage = typologyPage+"&row="+rowId;
			}

			$("##typologyContainer").load(typologyPage, function() {

				showLoadingPage(false);

			});

		} else {

			$("##typologyContainer").empty();
		}
	}--->
	function loadTypology(typologyId) {

		goToUrl("#CGI.SCRIPT_NAME#?typology_id="+typologyId);
	}
	</cfoutput>
	
</script>


<cfoutput>
<div class="div_search_bar">
<cfform method="get" name="search_form" action="#CGI.SCRIPT_NAME#" class="form-horizontal" onsubmit="return onSubmitForm();">
	
	<script>
		var railo_custom_form;

		if( typeof LuceeForms !== 'undefined' && $.isFunction(LuceeForms) ) 
			railo_custom_form = new LuceeForms('search_form');
		else
			railo_custom_form = new RailoForms('search_form');
	</script>

	<cfif isDefined("URL.field") AND isDefined("URL.itemTypeId")><!---SELECT ITEM PAGE--->
	
		<input type="hidden" name="field" value="#URL.field#" />
		<input type="hidden" name="itemTypeId" value="#URL.itemTypeId#" />

	<cfelse><!---SEARCH ITEMS PAGE--->

		<div class="row" style="margin-bottom:40px">

	    	<label for="search_page" class="col-xs-5 col-sm-3 control-label" lang="es" style="color:##36948C;font-size:17px;">Tipo de elemento a buscar</label>

	    	<div class="col-xs-7 col-md-4 col-lg-3">

		    	<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
				</cfinvoke>

				<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

				<div class="btn-group btn-block" id="selectSearchElements">

					<button type="button" class="btn btn-default btn-block dropdown-toggle" data-toggle="dropdown" aria-expanded="false" style="text-align:left;">

						<cfif isNumeric(itemTypeId)>
							
							<img src="#APPLICATION.htmlPath#/assets/v3/icons/#itemTypesStruct[itemTypeId].name#.png" alt="#itemTypesStruct[itemTypeId].labelPlural#" lang="es" style="width:35px"/>

							<span lang="es">#itemTypesStruct[itemTypeId].labelPlural#</span> <span class="caret"></span>

						<cfelseif curElement EQ "users"><!--- Users --->

							<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/users.png" alt="Usuarios" lang="es" style="width:35px"/> <span lang="es">Usuarios</span> <span class="caret"></span>

						<cfelse><!--- Areas --->

							<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/area_small.png" alt="áreas" lang="es" style="width:35px"/> <span lang="es">Áreas</span> <span class="caret"></span>

						</cfif>
						
					</button>

					<ul class="dropdown-menu" role="menu">

						<li>

							<div class="row" style="width:450px;">

					            <ul class="list-unstyled col-md-6">

					            	<li>
										<a href="areas_search.cfm" title="Áreas" lang="es">
											<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/area_small.png" alt="Áreas" lang="es" style="width:35px"/>&nbsp;<span lang="es">Áreas</span>
										</a>
									</li>

							    	<cfloop array="#itemTypesArray#" index="curItemTypeId">

							    		<cfif curItemTypeId NEQ 13 AND curItemTypeId NEQ 14 AND curItemTypeId NEQ 15 AND ( curItemTypeId NEQ 7 OR APPLICATION.moduleConsultations IS true ) AND ( curItemTypeId NEQ 13 OR APPLICATION.moduleForms IS true ) AND ( curItemTypeId NEQ 8 OR APPLICATION.modulePubMedComments IS true ) AND ( curItemTypeId NEQ 20 OR APPLICATION.moduleDPDocuments IS true ) AND ( (curItemTypeId NEQ 2 AND curItemTypeId NEQ 4 AND curItemTypeId NEQ 9) OR APPLICATION.moduleWeb EQ true )>

											<li>
												
												<a href="#itemTypesStruct[curItemTypeId].namePlural#_search.cfm" title="#itemTypesStruct[curItemTypeId].labelPlural#" lang="es">
											
													<img src="#APPLICATION.htmlPath#/assets/v3/icons/#itemTypesStruct[curItemTypeId].name#.png" alt="#itemTypesStruct[curItemTypeId].labelPlural#" lang="es" style="width:35px"/>

													&nbsp;<span lang="es">#itemTypesStruct[curItemTypeId].labelPlural#</span>
												</a>
												
											</li>

											<!---
											<cfif curItemTypeId IS 10>
												
												<li>

													<cfif APPLICATION.moduleAreaFilesLite IS true>
													<a title="Archivos de área" lang="es" class="btn-new-item-dp"><!---<i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>---> <img src="#APPLICATION.htmlPath#/assets/v3/icons/file_area.png" />
														<span title="Archivos de área" lang="es">Archivos de área</span> <!---href="area_file_new.cfm?area=#area_id#&fileTypeId=2"--->
													</a>
													</cfif>

												</li>

											</cfif>
											--->

										</cfif>

										<cfif curItemTypeId EQ 20><!--- Cierra la primera columna --->
												
											</ul><!--- END list-unstyled col-md-6 --->
											<ul class="list-unstyled col-md-6">   

										</cfif>

									</cfloop>

									<li>
										<a href="users_search.cfm" title="Usuarios" lang="es">
											<img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/users.png" alt="Usuarios" lang="es" style="width:35px"/>&nbsp;<span lang="es">Usuarios</span>
										</a>
									</li>

								</ul><!--- END list-unstyled col-md-6 --->

			           		</div><!--- END row --->

						</li>

					</ul><!--- END dropdown-menu --->

				</div><!--- END btn-group --->

			</div>
	  	</div>

	</cfif>


	<cfif APPLICATION.modulefilesWithTables IS true AND isDefined("curElement") AND curElement IS "files"><!--- Files Typologies --->
			
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAllAreasTypologies" returnvariable="getAreaTypologiesResponse">
		</cfinvoke>
		<cfset areasTypologies = getAreaTypologiesResponse.query>	

		<div class="row">

			<label for="typology_id" class="col-xs-5 col-sm-3 control-label" lang="es">Tipología</label>

			<div class="col-xs-7 col-sm-9">

				<select name="typology_id" id="typology_id" class="form-control" onchange="loadTypology($('##typology_id').val(),'');">
					<option value="" <cfif NOT isNumeric(selected_typology_id)>selected="selected"</cfif> lang="es">Todas</option>
					<option value="null" <cfif selected_typology_id EQ "null">selected="selected"</cfif> lang="es">Básica</option>
					<cfif areasTypologies.recordCount GT 0>
						<cfloop query="areasTypologies">
							<option value="#areasTypologies.id#" <cfif areasTypologies.id IS selected_typology_id>selected="selected"</cfif>>#areasTypologies.title#</option>
						</cfloop>
					</cfif>
				</select>
				&nbsp;<span class="help-inline" style="font-size:10px" lang="es">Se muestran las tipologías usadas en al menos un archivo</span>

			</div>

		</div>

		<cfif isDefined("URL.name")>
			<cfset file_name = URL.name>
		<cfelse>
			<cfset file_name = "">
		</cfif>

		<cfif isDefined("URL.file_name")>
			<cfset file_file_name = URL.file_name>
		<cfelse>
			<cfset file_file_name = "">
		</cfif>

		<cfif isDefined("URL.description")>
			<cfset file_description = URL.description>
		<cfelse>
			<cfset file_description = "">
		</cfif>

		<div class="row">
			<label for="name" class="col-xs-5 col-sm-3 control-label" lang="es">Nombre</label>
			<div class="col-xs-7 col-sm-9">
				<input type="text" name="name" id="name" value="#file_name#" class="form-control">
			</div>
		</div>

		<div class="row">
			<label for="file_name" class="col-xs-5 col-sm-3 control-label" lang="es">Nombre físico</label>
			<div class="col-xs-7 col-sm-9">
				<input type="text" name="file_name" id="file_name" value="#file_file_name#" class="form-control">
			</div>
		</div>

		<div class="row">
			<label for="description" class="col-xs-5 col-sm-3 control-label" lang="es">Descripción</label>
			<div class="col-xs-7 col-sm-9">
				<input type="text" name="description" id="description" value="#file_description#" class="form-control">
			</div>
		</div>

	<cfelse>

		<div class="row">
			<label for="text" class="col-xs-5 col-sm-3 control-label" lang="es">Texto a buscar</label>

			<div class="col-xs-7 col-sm-9">
				
				<!---<div class="input-group">
					<cfif APPLICATION.hideInputLabels IS true>
						<span class="input-group-addon"><label for="text"><i class="icon-search"></i></label></span>
					<cfelse>
						<span class="input-group-addon"><i class="icon-search"></i></span>
					</cfif>--->
				  <input type="text" name="text" id="text" value="#HTMLEditFormat(search_text)#" class="form-control" lang="es"/>
				<!---</div>--->
			</div>
		</div>

	</cfif>



	<cfif NOT isDefined("curElement") OR ( curElement NEQ "users" AND curElement NEQ "areas" ) >
				
		<div class="row">

			<label for="from_date" class="col-xs-5 col-sm-3 control-label" lang="es"><i class="icon-calendar"></i>&nbsp;&nbsp;<span lang="es">Fecha desde</span></label> 

			<div class="col-xs-7 col-sm-9">
				<!---<cfif APPLICATION.hideInputLabels IS true>
					<div class="input-group">	
						 <span class="input-group-addon"><label for="from_date"><i class="icon-calendar"></i></label></span>
						<input type="text" name="from_date" id="from_date" class="form-control input_datepicker" value="#from_date#" onchange="setFromDate()" placeholder="Fecha desde" lang="es">
					</div>
				<cfelse>--->
				<input type="text" name="from_date" id="from_date" class="form-control input_datepicker" value="#from_date#" onchange="setFromDate()">
			</div>

		</div>

		<div class="row">

			<label for="end_date" class="col-xs-5 col-sm-3 control-label"><i class="icon-calendar"></i>&nbsp;&nbsp;<span lang="es">Fecha hasta</span></label> 

			<div class="col-xs-7 col-sm-9">
				<input type="text" name="end_date" id="end_date" value="#end_date#" class="form-control input_datepicker" onchange="setEndDate()"/>
			</div>

		</div>
		
		<!---<div class="row">

			<div class="col-xs-7 col-xs-offset-5 col-sm-offset-3 col-sm-9">

				<hr style="margin-top:35px; border-top:1px solid ##ddd">

			</div>

		</div>--->

		<cfif itemTypeId IS 6><!---Tasks--->
			<div class="row">
				<label for="done" class="col-xs-5 col-sm-3 control-label" lang="es">Tarea realizada</label> 

				<div class="col-xs-7 col-sm-9">
					<select name="done" id="done" class="form-control">
						<option value="1" <cfif is_done IS 1>selected="selected"</cfif> lang="es">Sí</option>
						<option value="0" <cfif is_done IS 0>selected="selected"</cfif> lang="es">No</option>
					</select>
				</div>
			</div>

			<div class="row">
				<label for="to_user" class="col-xs-5 col-sm-3 control-label" lang="es">Tarea para</label> 

				<div class="col-xs-7 col-sm-9">
					<select name="to_user" lang="to_user" class="form-control">
						<option value="" lang="es">Todos</option>
						<cfloop index="objectUser" array="#users#">	
							<option value="#objectUser.id#" <cfif objectUser.id EQ recipient_user>selected="selected"</cfif>>#objectUser.family_name# #objectUser.name#</option>
						</cfloop>
					</select>
				</div>
			</div>
		</cfif>
				
		<cfif itemTypeId IS 7 OR itemTypeId IS 8><!---Consultations, Publications--->
			<div class="row">
				<label for="identifier" class="col-xs-5 col-sm-3 control-label" lang="es">Identificador</label> 

				<div class="col-xs-7 col-sm-9">
					<input type="text" name="identifier" id="identifier" value="#identifier#" class="form-control"/>
				</div>

				<cfif itemTypeId IS 7><!--- Consultations --->		
					<label for="done" class="col-xs-5 col-sm-3 control-label" lang="es">Estado actual</label> 

					<div class="col-xs-7 col-sm-9">
						<select name="state" id="state" class="form-control">
							<option value="" lang="es">Todos</option>
							<option value="created" <cfif cur_state EQ "created">selected="selected"</cfif> lang="es">Enviada</option>
							<option value="read" <cfif cur_state EQ "read">selected="selected"</cfif> lang="es">Leída</option>
							<option value="answered" <cfif cur_state EQ "answered">selected="selected"</cfif> lang="es">Respondida</option>
							<option value="closed" <cfif cur_state EQ "closed">selected="selected"</cfif> lang="es">Cerrada</option>
						</select>
					</div>	
				</cfif>
			</div>
		</cfif>
		

	</cfif>
	
	<div class="row">

		<cfif NOT isDefined("curElement") OR ( curElement NEQ "users" AND curElement NEQ "areas" )>
			
			<label for="from_user" class="col-xs-5 col-sm-3 control-label" lang="es"><cfif itemTypeId IS 6>Tarea encargada por<cfelse>Usuario</cfif></label> 

			<div class="col-xs-7 col-sm-9">

				<select name="from_user" id="from_user" class="form-control"><!---class="selectpicker" data-live-search="true"--->
					<option value="" lang="es">Todos</option>
					<cfloop index="objectUser" array="#users#">	
						<option value="#objectUser.id#" <cfif objectUser.id EQ user_in_charge>selected="selected"</cfif>>#objectUser.family_name# #objectUser.name#</option>
					</cfloop>
				</select>

			</div>

		</cfif>

		<label for="limit" class="col-xs-5 col-sm-3 control-label" lang="es">Nº resultados a mostrar</label>

		<div class="col-xs-7 col-sm-9"> 
			<select name="limit" id="limit" class="form-control">
				<option value="100" <cfif limit_to IS 100>selected="selected"</cfif>>100</option>
				<option value="500" <cfif limit_to IS 500>selected="selected"</cfif>>500</option>
				<option value="1000" <cfif limit_to IS 1000>selected="selected"</cfif>>1000</option>
			</select>
		</div>
	</div>


	<cfif isNumeric(selected_typology_id)>

		<!--- Typology fields --->
		<cfset tableTypeId = 3>

		<!---Table fields--->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="getFieldsResponse">
			<cfinvokeargument name="table_id" value="#selected_typology_id#"/>
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#"/>
			<cfinvokeargument name="with_types" value="true"/>
		</cfinvoke>

		<cfset fields = getFieldsResponse.tableFields>

		<cfif isDefined("URL.name") AND isDefined("URL.typology_id") AND URL.typology_id IS selected_typology_id>
			
			<cfset row = URL>

		<cfelse>

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getEmptyRow" returnvariable="emptyRow">
				<cfinvokeargument name="table_id" value="#selected_typology_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="fields" value="#fields#">
			</cfinvoke>

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="fillEmptyRow" returnvariable="row">
				<cfinvokeargument name="emptyRow" value="#emptyRow#">
				<cfinvokeargument name="fields" value="#fields#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="withDefaultValues" value="false">
			</cfinvoke>

		</cfif>
		
			
		<!--- outputRowFormInputs --->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="outputRowFormInputs">
			<cfinvokeargument name="table_id" value="#selected_typology_id#">
			<cfinvokeargument name="tableTypeId" value="3">
			<cfinvokeargument name="row" value="#row#">
			<cfinvokeargument name="fields" value="#fields#">
			<cfinvokeargument name="search_inputs" value="true">
		</cfinvoke>

	</cfif>

	<div class="row">
		<div class="col-xs-offset-0 col-xs-12 col-sm-offset-3 col-sm-7 col-md-offset-3 col-md-4 col-lg-3"> 
			<!---<input type="submit" name="search" class="btn btn-success" lang="es" value="Buscar" />--->

			<button type="submit" name="search" class="btn btn-success btn-lg btn-block" style="margin-top:30px;text-align:left;"><i class="icon-search"></i> <span lang="es">Buscar</span></button>

		</div>
	</div>
	
	<!--- <cfif NOT isDefined("curElement") OR curElement NEQ "users">
			<span class="help-block" style="font-size:10px" lang="es">Formato fecha DD-MM-AAAA. Ejemplo: #DateFormat(now(), "DD-MM-YYYY")#</span>
	</cfif> --->
	

</cfform>
</div><!--- END div_search_bar --->
</cfoutput>