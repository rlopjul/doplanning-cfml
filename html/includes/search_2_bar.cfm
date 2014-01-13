
<cfoutput>
	<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
	<script type="text/javascript" src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>
	<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js?v=2"></script>

</cfoutput>

<cfif NOT isDefined("itemTypeId")>
	<cfset itemTypeId = "">
</cfif>

<cfif isDefined("URL.text")>
	<cfset search_text = URL.text>
	<cfset search_text_highlight = replace(search_text,' ','","',"ALL")>
	<cfoutput>
		<script type="text/javascript">
			$(document).ready(function() {
			  <!---$(".text_item").highlight("#search_text#");--->
			  $(".text_item").highlight(["#search_text_highlight#"]);	
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


<cfif isDefined("URL.typology_id")>
	<cfset selected_typology_id = URL.typology_id>
<cfelse>
	<cfset selected_typology_id = "">
</cfif>


<cfif NOT isDefined("curElement") OR curElement NEQ "users">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUsers" returnvariable="getUsersResponse">	
	</cfinvoke>
	
	<!---<cfxml variable="xmlUsers">
		<cfoutput>
		#getUsersResponse.usersXml#
		</cfoutput>
	</cfxml>
	<cfset numUsers = ArrayLen(xmlUsers.users.XmlChildren)>--->

	<cfset users = getUsersResponse.users>
	<cfset numUsers = ArrayLen(users)>

</cfif>


<script type="text/javascript">
	
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
			//document.getElementById("submitDiv").innerHTML = window.lang.convert("Enviando archivo...");

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
	
	<script type="text/javascript">
		var railo_custom_form=new RailoForms('search_form');
	</script>

	<div class="row">

    	<label for="search_page" class="col-sm-2 control-label" lang="es">Buscar en</label>

    	<div class="col-sm-4">
	    	<select name="search_page" id="search_page" class="form-control" onchange="goToUrl($('##search_page').val(),'');">
	    		<option value="messages_search.cfm" <cfif curElement EQ "messages">selected="selected"</cfif> lang="es">Mensajes</option>
	    		<option value="files_search.cfm" <cfif curElement EQ "files">selected="selected"</cfif> lang="es">Archivos</option>
	    		<option value="events_search.cfm" <cfif curElement EQ "events">selected="selected"</cfif> lang="es">Eventos</option>
	    		<option value="tasks_search.cfm" <cfif curElement EQ "tasks">selected="selected"</cfif> lang="es">Tareas</option>
	    		<cfif APPLICATION.moduleLists IS true>
	    			<option value="lists_search.cfm" <cfif curElement EQ "lists">selected="selected"</cfif> lang="es">Listas</option>
	    		</cfif>

	    		<cfif APPLICATION.moduleForms IS true>
	    			<option value="forms_search.cfm" <cfif curElement EQ "forms">selected="selected"</cfif> lang="es">Formularios</option>
	    		</cfif>
	    		
	    		<cfif APPLICATION.moduleConsultations IS true>
	    			<option value="consultations_search.cfm" <cfif curElement EQ "consultations">selected="selected"</cfif> lang="es">Interconsultas</option>
				</cfif>
			
				<cfif APPLICATION.modulePubMedComments IS true>
					<option value="pubmeds_search.cfm" <cfif curElement EQ "pubmeds">selected="selected"</cfif> lang="es">Comentarios de PubMed</option>
				</cfif>
			
				<cfif APPLICATION.moduleWeb EQ true>
					<option value="entries_search.cfm" <cfif curElement EQ "entries">selected="selected"</cfif> lang="es">Elementos de contenido web</option>

					<option value="newss_search.cfm" <cfif curElement EQ "news">selected="selected"</cfif> lang="es">Noticias</option>

					<option value="images_search.cfm" <cfif curElement EQ "images">selected="selected"</cfif> lang="es">Imágenes</option>
				</cfif>

				<option value="users_search.cfm" <cfif curElement EQ "users">selected="selected"</cfif> lang="es">Usuarios</option>
		
	    	</select>
		</div>
  	</div>


	<cfif APPLICATION.modulefilesWithTables IS true AND isDefined("curElement") AND curElement IS "files"><!--- Files Typologies --->
			
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAllAreasTypologies" returnvariable="getAreaTypologiesResponse">
		</cfinvoke>
		<cfset areasTypologies = getAreaTypologiesResponse.query>	

		<div class="row">

			<label for="typology_id" class="col-sm-2 control-label">Tipología</label>

			<div class="col-sm-10">

				<select name="typology_id" id="typology_id" class="form-control" onchange="loadTypology($('##typology_id').val(),'');">
					<option value="" <cfif NOT isNumeric(selected_typology_id)>selected="selected"</cfif>>Todas</option>
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
			<label for="name" class="col-sm-2 control-label" lang="es">Nombre</label>
			<div class="col-sm-10">
				<input type="text" name="name" id="name" value="#file_name#" class="form-control">
			</div>
		</div>

		<div class="row">
			<label for="file_name" class="col-sm-2 control-label" lang="es">Nombre físico</label>
			<div class="col-sm-10">
				<input type="text" name="file_name" id="file_name" value="#file_file_name#" class="form-control">
			</div>
		</div>

		<div class="row">
			<label for="description" class="col-sm-2 control-label" lang="es">Descripción</label>
			<div class="col-sm-10">
				<input type="text" name="description" id="description" value="#file_description#" class="form-control">
			</div>
		</div>

	<cfelse>

		<div class="row">
			<label for="text" class="col-sm-2 control-label" lang="es">Buscar texto</label>
			<div class="col-sm-5">
				<div class="input-group">
				  <span class="input-group-addon"><i class="icon-search"></i></span>
				  <input type="text" name="text" id="text" value="#HTMLEditFormat(search_text)#" class="input-medium"/>
				</div>
			</div>
		</div>

	</cfif>



	<cfif NOT isDefined("curElement") OR curElement NEQ "users">
				
		<div class="row">

			<label for="from_date" class="col-xs-2 col-sm-2 control-label" lang="es">Fecha desde</label> 

			<div class="col-xs-4 col-sm-4">		
				<input type="text" name="from_date" id="from_date" class="input_datepicker" value="#from_date#" onchange="setFromDate()">
			</div>

			<label for="end_date" class="col-xs-2 col-sm-2 control-label" lang="es">Fecha hasta</label> 

			<div class="col-xs-4 col-sm-4">		
				<input type="text" name="end_date" id="end_date" value="#end_date#" class="input_datepicker" onchange="setEndDate()"/>
			</div>

		</div>
		

		<cfif itemTypeId IS 6><!---Tasks--->
			<div class="row">
				<label for="done" class="col-sm-2 control-label" lang="es">Hecha</label> 

				<div class="col-sm-4">
					<select name="done" id="done" class="input-mini">
						<option value="1" <cfif is_done IS 1>selected="selected"</cfif> lang="es">Sí</option>
						<option value="0" <cfif is_done IS 0>selected="selected"</cfif> lang="es">No</option>
					</select>
				</div>
			
				<label for="to_user" class="col-sm-2 control-label" lang="es">Para</label> 

				<div class="col-sm-4">
					<select name="to_user" lang="to_user" class="form-control">
						<option value="" lang="es">Todos</option>
						<cfloop index="objectUser" array="#users#">	
							<option value="#objectUser.id#" <cfif objectUser.id EQ recipient_user>selected="selected"</cfif>>#objectUser.family_name# #objectUser.name#</option>
						</cfloop>
					</select>
				</div>
			</div>
		</cfif>
				
		<cfif itemTypeId IS 7><!---Consultations--->
			<div class="row">
				<label for="done" class="col-sm-2 control-label" lang="es">Estado actual</label> 

				<div class="col-sm-4">
					<select name="state" id="state" class="form-control">
						<option value="" lang="es">Todos</option>
						<option value="created" <cfif cur_state EQ "created">selected="selected"</cfif> lang="es">Enviada</option>
						<option value="read" <cfif cur_state EQ "read">selected="selected"</cfif> lang="es">Leída</option>
						<option value="answered" <cfif cur_state EQ "answered">selected="selected"</cfif> lang="es">Respondida</option>
						<option value="closed" <cfif cur_state EQ "closed">selected="selected"</cfif> lang="es">Cerrada</option>
					</select>
				</div>
			</div>	
		</cfif>
		

	</cfif>
	
	<div class="row">

		<cfif NOT isDefined("curElement") OR curElement NEQ "users">
			
			<label for="from_user" class="col-xs-2 col-sm-2 control-label" lang="es">Usuario</label> 

			<div class="col-xs-5 col-sm-5">

				<select name="from_user" id="from_user" class="form-control">
				<option value="" lang="es">Todos</option>
				<!---<cfloop index="xmlIndex" from="1" to="#numUsers#" step="1">				
					<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="objectUser">
						<cfinvokeargument name="xml" value="#xmlUsers.users.user[xmlIndex]#">
						<cfinvokeargument name="return_type" value="object">
					</cfinvoke>--->	
				<cfloop index="objectUser" array="#users#">	
					
					<option value="#objectUser.id#" <cfif objectUser.id EQ user_in_charge>selected="selected"</cfif>>#objectUser.family_name# #objectUser.name#</option>
					
				</cfloop>
				</select>

			</div>

		</cfif>

		<label for="limit" class="col-xs-2 col-sm-2 control-label" lang="es">Nº resultados</label>

		<div class="col-xs-3 col-sm-2"> 
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
		<div class="col-sm-offset-2 col-sm-10"> 
			<input type="submit" name="search" class="btn btn-primary" lang="es" value="Buscar" />
		</div>
	</div>
	
	<!--- <cfif NOT isDefined("curElement") OR curElement NEQ "users">
			<span class="help-block" style="font-size:10px" lang="es">Formato fecha DD-MM-AAAA. Ejemplo: #DateFormat(now(), "DD-MM-YYYY")#</span>
	</cfif> --->
	

</cfform>
</div><!--- END div_search_bar --->
</cfoutput>