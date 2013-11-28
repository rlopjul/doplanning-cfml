
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
<div style="clear:both; padding-left:5px;">
<cfform method="get" name="search_form" class="form-inline" action="#CGI.SCRIPT_NAME#" onsubmit="return onSubmitForm();">
	
	<script type="text/javascript">
		var railo_custom_form=new RailoForms('search_form');
	</script>

	<cfif APPLICATION.modulefilesWithTables IS true AND isDefined("curElement") AND curElement IS "files"><!--- Files Typologies --->
			
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAllAreasTypologies" returnvariable="getAreaTypologiesResponse">
		</cfinvoke>
		<cfset areasTypologies = getAreaTypologiesResponse.query>	

		<div class="control-group">
			<label for="typology_id">Tipología</label>
			<select name="typology_id" id="typology_id" class="span5" onchange="loadTypology($('##typology_id').val(),'');">
				<option value="" <cfif NOT isNumeric(selected_typology_id)>selected="selected"</cfif>>Todas</option>
				<cfif areasTypologies.recordCount GT 0>
					<cfloop query="#areasTypologies#">
						<option value="#areasTypologies.id#" <cfif areasTypologies.id IS selected_typology_id>selected="selected"</cfif>>#areasTypologies.title#</option>
					</cfloop>
				</cfif>
			</select>
			&nbsp;<span class="help-inline" style="font-size:10px" lang="es">Se muestran las tipologías usadas en al menos un archivo</span>
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

		<div class="control-group">
			<label for="name" lang="es">Nombre</label>
			<input type="text" name="name" id="name" value="#file_name#" class="span5">
		</div>

		<div class="control-group">
			<label for="file_name" lang="es">Nombre físico del archivo</label>
			<input type="text" name="file_name" id="file_name" value="#file_file_name#" class="span5">
		</div>

		<div class="control-group">
			<label for="description" lang="es">Descripción</label>
			<input type="text" name="description" id="description" value="#file_description#" class="span5">
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

	<cfelse>

		<div class="input-prepend">
		  <span class="add-on"><i class="icon-search"></i></span>
		  <input type="text" name="text" value="#HTMLEditFormat(search_text)#" class="input-medium"/>
		</div>&nbsp;

	</cfif>

	<cfif NOT isDefined("curElement") OR curElement NEQ "users">
	
		<label for="from_user" lang="es">De</label> <select name="from_user" id="from_user">
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
		
		<div style="height:8px;"></div>

		<label for="from_user" lang="es">Fecha desde</label> 		
		<input type="text" name="from_date" id="from_date" class="input_datepicker" value="#from_date#" onchange="setFromDate()">

		&nbsp;<label for="end_user" lang="es">Fecha hasta</label> 
		<input type="text" name="end_date" id="end_date" value="#end_date#" class="input_datepicker" onchange="setEndDate()"/>
	
		<cfif itemTypeId IS 6><!---Tasks--->
			&nbsp;<label for="done" lang="es">Hecha</label> <select name="done" id="done" class="input-mini">
				<option value="1" <cfif is_done IS 1>selected="selected"</cfif> lang="es">Sí</option>
				<option value="0" <cfif is_done IS 0>selected="selected"</cfif> lang="es">No</option>
			</select><br/>
		
			<label for="to_user" lang="es">Para</label> <select name="to_user" lang="to_user">
				<option value="" lang="es">Todos</option>
				<cfloop index="objectUser" array="#users#">	
					
					<option value="#objectUser.id#" <cfif objectUser.id EQ recipient_user>selected="selected"</cfif>>#objectUser.family_name# #objectUser.name#</option>
				</cfloop>
			</select>
		</cfif>
		
		<cfif itemTypeId IS 7><!---Consultations--->
			<br/>
			<label for="done" lang="es">Estado actual</label> <select name="state" id="state" class="input-medium">
				<option value="" lang="es">Todos</option>
				<option value="created" <cfif cur_state EQ "created">selected="selected"</cfif> lang="es">Enviada</option>
				<option value="read" <cfif cur_state EQ "read">selected="selected"</cfif> lang="es">Leída</option>
				<option value="answered" <cfif cur_state EQ "answered">selected="selected"</cfif> lang="es">Respondida</option>
				<option value="closed" <cfif cur_state EQ "closed">selected="selected"</cfif> lang="es">Cerrada</option>
			</select>	
		</cfif>
		
	</cfif>
	
	&nbsp;<label for="limit" lang="es">Nº resultados</label> <select name="limit" id="limit" class="input-small">
	<!---<option value="1" <cfif limit_to IS 1>selected="selected"</cfif>>1</option>--->
	<option value="100" <cfif limit_to IS 100>selected="selected"</cfif>>100</option>
	<option value="500" <cfif limit_to IS 500>selected="selected"</cfif>>500</option>
	<option value="1000" <cfif limit_to IS 1000>selected="selected"</cfif>>1000</option>
	</select>
	<input type="submit" name="search" class="btn btn-primary" lang="es" value="Buscar" />
	
	<cfif NOT isDefined("curElement") OR curElement NEQ "users">
		<span class="help-block" style="font-size:10px" lang="es">Formato fecha DD-MM-AAAA. Ejemplo: #DateFormat(now(), "DD-MM-YYYY")#</span>
	</cfif>

</cfform>
</div>
</cfoutput>