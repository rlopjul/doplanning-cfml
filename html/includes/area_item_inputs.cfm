<cfset delete_attached_file_action = "#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=deleteItemAttachedFileRemote">

<cfset delete_attached_image_action = "#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=deleteItemAttachedImageRemote">

<cfoutput>

<script type="text/javascript">
	
	
	<cfif read_only IS false>
	
	$(function() {

		<cfif itemTypeId IS 5 OR itemTypeId IS 6 OR itemTypeId IS 4><!---Events, Tasks, News--->

			$('##start_date').datepicker({
			  format: 'dd-mm-yyyy', 
			  autoclose: true,
			  weekStart: 1,
			  language: 'es',
			  todayBtn: 'linked'
				}).on('changeDate', function(ev){
					var startDateVal = $('##start_date').val();	
			        $('##end_date').datepicker('setStartDate', startDateVal);
			        if ( ev.date.valueOf() > $('##end_date').data('datepicker').date.valueOf() ){
			            $('##end_date').datepicker('update', startDateVal);
			        }
		    	});
		
			$('##end_date').datepicker({
			  format: 'dd-mm-yyyy',
			  weekStart: 1,
			  language: 'es',
			  todayBtn: 'linked', 
			  autoclose: true,
			  startDate: $('##start_date').val() 
			});

		</cfif>

		<cfif itemTypeWeb IS true AND ( NOT isDefined("area_type") OR len(area_type) GT 0 )><!--- WEB --->

			$('##publication_date').datepicker({
			  format: 'dd-mm-yyyy',
			  weekStart: 1,
			  language: 'es',
			  todayBtn: 'linked', 
			  autoclose: true
			});

		</cfif>

		<cfif itemTypeId IS 8>
			subTypeChange($('##sub_type_id').val());
		</cfif>
		

	});
	
	
	function checkDates(startDateFieldName, endDateFieldName) {
		
		var startDateVal = $("input:text[name="+startDateFieldName+"]").val();	
		var endDateVal = $("input:text[name="+endDateFieldName+"]").val();	
		
		var startDateParts = startDateVal.split('-');
		var endDateParts = endDateVal.split('-');
		
		//Comprueba que el año tenga 4 cifras
		//(Los años de 2 cifras generan fechas incorrectas al guardarse en MySQL)
		if(startDateParts[2].length != 4 || endDateParts[2].length != 4)
			return false;
		
		/*var startDate = $.datepicker.parseDate("dd-mm-yy", startDateVal);
		var endDate = $.datepicker.parseDate("dd-mm-yy", endDateVal);*/
				
		return startDateVal <= endDateVal;
		
	}

	function openUserSelector(){

		 return openPopUp('#APPLICATION.htmlPath#/iframes/area_users_select.cfm?area=#area_id#');
	}
	
	function setSelectedUser(userId, userName) {
				
		document.getElementById("recipient_user").value = userId;
		document.getElementById("recipient_user_full_name").value = userName;
		/*$("##recipient_user").val(userId); 
		$("##recipient_user_name").val(userName); */
	}
	

	function subTypeChange(subTypeId){

		if(subTypeId == 1){ 
			$("##identifierLabel").text("PubMed ID");
			$("##openInPubMedButton").show();
			$("##fieldPrice").hide();
		}else {
			$("##identifierLabel").text(window.lang.convert("Identificador/Número"));
			$("##openInPubMedButton").hide();
			$("##fieldPrice").show();
		}

	}

	function openPublicationInPubMed(pubMedId){

		if($.isNumeric(pubMedId))
			window.open("http://www.ncbi.nlm.nih.gov/pubmed/"+pubMedId, '_blank');
		else
			alert(window.lang.convert("PubMed Id no válido"));
	}

	<cfif isDefined("objectItem.id") AND read_only IS false>
				
		function deleteAttachedFile() {
		
			if(confirmAction('eliminar el archivo adjunto')) {
			
				goToUrl("#delete_attached_file_action#&item_id=#objectItem.id#&area_id=#area_id#&itemTypeId=#itemTypeId#&return_page=#URLEncodedFormat('#CGI.SCRIPT_NAME#?#itemTypeName#=#objectItem.id#')#");
				
			}
			return false;
		}
		
		function deleteAttachedImage() {
		
			if(confirmAction('eliminar la imagen adjunta')) {
			
				goToUrl("#delete_attached_image_action#&item_id=#objectItem.id#&area_id=#area_id#&itemTypeId=#itemTypeId#&return_page=#URLEncodedFormat('#CGI.SCRIPT_NAME#?#itemTypeName#=#objectItem.id#')#");
				
			}
			return false;
		}
		
	</cfif>

	</cfif><!--- END read_only IS false --->
	
</script>


<script type="text/javascript">
	var railo_custom_form=new RailoForms('item_form');
</script>
<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js"></script>


<cfif itemTypeId IS 1 OR itemTypeId IS 7>
	<cfset t_title = "Asunto">
<cfelse>
	<cfset t_title = "Título">
</cfif>
<cfif itemTypeId IS 2><!---Entradas--->
	<cfset title_required = false>
	<cfset t_display_type = "Tipo de visualización">
<cfelse>
	<cfset title_required = true>
</cfif>
<cfif itemTypeId IS 3>
	<cfset t_link = "URL">
	<cfset link_required = true>
<cfelse>
	<cfset t_link = "URL más información (enlace)">
	<cfset link_required = false>
</cfif>
<cfif itemTypeId IS 4>
	<cfset t_creation_date = "Fecha de creación">
</cfif>
<cfif itemTypeId IS 5 OR itemTypeId IS 6>
	<cfset t_start_date = "Fecha de inicio">
	<cfset t_end_date = "Fecha de fin">
	<cfif itemTypeId IS 5>
		<cfset t_start_time = "Hora">
		<cfset t_end_time = "Hora">
		<cfset t_place = "Lugar">
	<cfelse>
		<cfset t_recipient_user = "Usuario destinatario">
		<cfset t_estimated_value = "Valor estimado">
		<cfset t_real_value = "Valor real">
	</cfif>
</cfif>
<cfif itemTypeId IS 5 OR itemTypeId IS 8>
	<cfset t_price = "Precio">
</cfif>
<cfif itemTypeId IS 7 OR itemTypeId IS 8>
	<cfset t_identifier = "Identificador/Número">
</cfif>
<cfif itemTypeId IS 8>
	<cfset t_sub_type = "Tipo de">
</cfif>
<cfset t_position = "Posición">
<cfset t_iframe_url = "Incrustar contenido">
<cfset t_iframe_display_type = "Tamaño contenido incrustado">

<cfif read_only IS true>
	<cfset passthrough = 'readonly="readonly"'>
<cfelse>
	<cfset passthrough = "">
</cfif>

<cfif itemTypeId IS 8>
<div class="row">
	
	<div class="col-md-6">

		<label class="control-label" for="sub_type_id" id="subTypeLabel"><span lang="es">#t_sub_type#</span> <span lang="es">#itemTypeNameEs#</span> *</label>

		<cfinvoke component="#APPLICATION.componentsPath#/ItemSubTypeManager" method="getSubTypes" returnvariable="subTypeQuery">
			<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		</cfinvoke>
		
		<select name="sub_type_id" id="sub_type_id" <cfif read_only IS true>disabled="disabled"</cfif> onchange="subTypeChange($('##sub_type_id').val());">
			<cfloop query="subTypeQuery">
				<option value="#subTypeQuery.sub_type_id#" lang="es" <cfif objectItem.sub_type_id IS subTypeQuery.sub_type_id>selected="selected"</cfif>>#subTypeQuery.sub_type_title_es#</option>
			</cfloop>
		</select>

	</div>

</div>
</cfif>

<cfif itemTypeId IS NOT 7 OR NOT isDefined("parent_kind") OR parent_kind EQ "area">
<div class="row">
	<div class="col-xs-12 col-md-6">
		<label class="control-label" for="item_title"><span lang="es">#t_title#</span> <cfif title_required IS true>*</cfif></label>
		<div>
			<cfinput type="text" name="title" id="item_title" value="#objectItem.title#" required="#title_required#" message="#t_title# requerido" passthrough="#passthrough#" class="form-control">
		</div>
	</div>
</div>
<cfelse><!---Consultations--->
	<cfinput type="hidden" name="title" value="#objectItem.title#">
</cfif>

<cfif itemTypeWeb IS true AND ( NOT isDefined("area_type") OR len(area_type) GT 0 )><!--- WEB --->

	<div class="row">

		<cfif isDefined("objectItem.publication_hour")><!--- After send FORM --->

			<cfset publication_hour = objectItem.publication_hour>
			<cfset publication_minute = objectItem.publication_minute>

		<cfelse>

			<!---<cfif len(objectItem.publication_time) IS 0>
				<cfset objectItem.publication_time = createTime(0,0,0)>
			</cfif>--->
			
			<cfset publication_hour = timeFormat(objectItem.publication_date, "HH")>
			<cfset publication_minute = timeFormat(objectItem.publication_date, "mm")>

			<cfif len(objectItem.publication_date) GT 10>
				<cfset objectItem.publication_date = left(objectItem.publication_date, findOneOf(" ", objectItem.publication_date))>
			</cfif>

		</cfif>

		<!--- <cfif len(objectItem.publication_date) GT 10></cfif> --->

		<div class="col-xs-6 col-md-3">
			<label class="control-label" for="publication_date"><span lang="es">Fecha de publicación</span></label>
			<cfinput type="text" name="publication_date" id="publication_date" class="form-control" value="#objectItem.publication_date#" required="false" message="Fecha de publicación válida requerida" validate="eurodate" mask="DD-MM-YYYY" passthrough="#passthrough#">
		</div>
					
		<div class="col-xs-6">
			<!--- 
				<label class="control-label" for="publication_hour"><span lang="es">Hora de publicación</span></label>
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
							</div> --->
					
		</div>

		
		<input type="hidden" name="publication_hour" value="00"/>
		<input type="hidden" name="publication_minute" value="00"/>
		
		
	</div>

	<cfif isDefined("area_type")>
	<div class="row">
		<div class="col-sm-12">
			<!---<small class="help-block">Si está definida, <cfif itemTypeGender EQ "male">el<cfelse>la</cfif> #itemTypeNameEs# se publicará en la fecha especificada.</small>--->
			<small class="help-block" lang="es">Si está definida, este contenido se mostrará en la #area_type# en la fecha especificada.</small>
		</div>
	</div>
	</cfif>

	<cfif APPLICATION.publicationValidation IS true>
		
		<cfif isDefined("is_user_area_responsible")><!--- Está definida el área en la que se va a publicar el elemento --->
			
			<cfif is_user_area_responsible IS true>
			
				<div class="row">
					<div class="col-xs-12 col-sm-8">
						<div class="checkbox">
							<label>
								<input type="checkbox" name="publication_validated" id="publication_validated" value="true" <cfif isDefined("objectItem.publication_validated") AND objectItem.publication_validated IS true>checked="checked"</cfif> /> Aprobar publicación
							</label>
							<small class="help-block">Valida <cfif itemTypeGender EQ "male">el<cfelse>la</cfif> #itemTypeNameEs# para que pueda ser <cfif itemTypeGender EQ "male">publicado<cfelse>publicada</cfif>.</small>
						</div>
					</div>
				</div>

			</cfif>

		<cfelse>

			<input type="hidden" name="publication_validated"  value="false"/>
			<small class="help-block">La publicación del elemento deberá ser <b>aprobada</b> en cada una de las áreas en las que se publique.</small>

		</cfif>		

	</cfif>

</cfif>

<cfif itemTypeId IS 4><!---News--->

	<div class="row">
		<div class="col-xs-6 col-md-3">

			<cfif len(objectItem.creation_date) GT 10>
				<cfset objectItem.creation_date = left(objectItem.creation_date, findOneOf(" ", objectItem.creation_date))>
			</cfif>

			<label class="control-label" lang="es">#t_creation_date#</label>		
			<cfinput type="text" name="creation_date" id="creation_date" class="form-control" value="#objectItem.creation_date#" required="true" message="#t_creation_date# válida requerida" validate="eurodate" mask="DD-MM-YYYY" passthrough="#passthrough#">

		</div>
		<div class="col-xs-6">
			<br/>
			<span style="font-size:10px" lang="es">Formato DD-MM-AAAA.<br/> Ejemplo:</span><span style="font-size:10px"> #DateFormat(now(), "DD-MM-YYYY")#</span>

		</div>
	</div>

</cfif>

<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->

<cfif itemTypeId IS 6><!---Tasks--->
	<div class="row">
		<div class="col-md-12">

			<label class="control-label" lang="es">#t_recipient_user#</label>

			<div class="row">
				<div class="col-sm-5" style="padding-right:0;">
					<input type="hidden" name="recipient_user" id="recipient_user" value="#objectItem.recipient_user#" required="true" />
					<cfinput type="text" name="recipient_user_full_name" id="recipient_user_full_name" value="#objectItem.recipient_user_full_name#" readonly="yes" required="true" message="Usuario destinatario requerido" onclick="openUserSelector()">
				</div>
				<div class="col-sm-7">
					<cfif read_only IS false> <button onclick="return openUserSelector();" class="btn btn-default" lang="es">Seleccionar usuario</button></cfif>
				</div>
			</div>

		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<cfif read_only IS false><span style="font-size:10px" lang="es">Usuario al que se le asignará la tarea</span></cfif>
		</div>
	</div>
</cfif>

<div class="row">

	<div class="col-xs-6 col-md-3">
		<label class="control-label" for="start_date"><span lang="es">#t_start_date#</span> *</label>
		<cfinput type="text" name="start_date" id="start_date" class="form-control input_datepicker" value="#objectItem.start_date#" required="true" message="#t_start_date# válida requerida" validate="eurodate" mask="DD-MM-YYYY" passthrough="#passthrough#">
	</div>
	
	<cfif itemTypeId IS 5>
		
		<cfif isDefined("objectItem.start_time")>
			
			<cfif len(objectItem.start_time) IS 0>
				<cfset objectItem.start_time = createTime(0,0,0)>
			</cfif>
			
			<cfset start_hour = hour(objectItem.start_time)>
			<cfset start_minute = minute(objectItem.start_time)>

		<cfelse><!--- After send FORM --->

			<cfset start_hour = objectItem.start_hour>
			<cfset start_minute = objectItem.start_minute>

		</cfif>
		
		<div class="col-xs-6">
			<label class="control-label" for="start_hour"><span lang="es">#t_start_time#</span></label>
			<div class="input-group" style="width:170px">
				<select name="start_hour" id="start_hour" class="form-control" style="width:70px;">
					<cfloop from="00:00" to="23:00" step="#CreateTimeSpan(0, 1, 0, 0)#" index="hour">
						<cfset curHour = TimeFormat(hour, 'HH')>
						<option value="#curHour#" <cfif curHour EQ start_hour>selected="selected"</cfif>>#curHour#</option>
					</cfloop>
				</select><span class="input-group-addon">:</span><select name="start_minute" class="form-control" style="width:70px;">
					<cfloop from="0" to="59" index="minutes" step="5">
						<cfif minutes EQ "0">
							<cfset minutes = "00">
						</cfif>
						<option value="#minutes#" <cfif minutes EQ start_minute>selected="selected"</cfif>>#minutes#</option>
					</cfloop>
				</select>
			</div>	
		</div>
	
	</cfif>
	
</div>

<div class="row">

	<div class="col-xs-6 col-md-3">
		<label class="control-label" for="end_date"><span lang="es">#t_end_date#</span> *</label>
		<cfinput type="text" name="end_date" id="end_date" value="#objectItem.end_date#" required="true" message="#t_end_date# válida requerida" validate="eurodate" mask="DD-MM-YYYY" passthrough="#passthrough#">
	</div>

	<cfif itemTypeId IS 5>
		
		<cfif isDefined("objectItem.end_time")>

			<cfif len(objectItem.end_time) IS 0>
				<cfset objectItem.end_time = createTime(0,0,0)>
			</cfif>
		
			<cfset end_hour = hour(objectItem.end_time)>
			<cfset end_minute = minute(objectItem.end_time)>

		<cfelse><!--- After send FORM --->

			<cfset end_hour = objectItem.end_hour>
			<cfset end_minute = objectItem.end_minute>

		</cfif>
		
		<div class="col-xs-6">
			<label class="control-label" for="end_hour"><span lang="es">Hora de fin</span></label>
			<div class="input-group" style="width:170px">
				<select name="end_hour" style="width:70px;">
					<cfloop from="00:00" to="23:00" step="#CreateTimeSpan(0, 1, 0, 0)#" index="hour">
						<cfset curHour = TimeFormat(hour, 'HH')>
						<option value="#curHour#" <cfif curHour EQ end_hour>selected="selected"</cfif>>#curHour#</option>
					</cfloop>
				</select><span class="input-group-addon">:</span><select name="end_minute" style="width:70px;">
					<cfloop from="0" to="59" index="minutes" step="5">
						<cfif minutes EQ "0">
							<cfset minutes = "00">
						</cfif>
						<option value="#minutes#" <cfif minutes EQ end_minute>selected="selected"</cfif>>#minutes#</option>
					</cfloop>
				</select>
			</div>
		</div>
	
	</cfif>
</div>

</cfif>

<cfif itemTypeId IS 5><!---Events--->
<div class="row">
	<div class="col-md-3">
		<label class="control-label" for="place"><span lang="es">#t_place#</span> *</label>
		<cfinput type="text" name="place" id="place" value="#objectItem.place#" required="true" message="#t_place# requerido" passthrough="#passthrough#">
	</div>
</div>

<cfelseif itemTypeId IS 6><!---Tasks--->

<div class="row">

	<div class="col-xs-5 col-md-2">

		<label class="control-label" for="estimated_value"><span lang="es">#t_estimated_value#</span> *</label>
		<cfinput type="text" name="estimated_value" id="estimated_value" value="#objectItem.estimated_value#" required="true" validate="float" message="#t_estimated_value# debe ser un decimal" passthrough="#passthrough#"><!---&nbsp;<span style="font-size:10px">Valor (tiempo, coste, ...) estimado para la tarea.</span>--->

	</div>

	<div class="col-xs-6 col-md-2">

		<label class="control-label" for="real_value"><span lang="es">#t_real_value#</span> *</label>
		<cfinput type="text" name="real_value" id="real_value" value="#objectItem.real_value#" required="true" validate="float" message="#t_real_value# debe ser un decimal"><!---&nbsp;<span style="font-size:10px">Valor real de la tarea una vez realizada.</span>--->

	</div>

</div>

<div class="row">
    
    <div class="col-md-12">
	    <div class="checkbox">

			<label>
				<input type="checkbox" name="done" value="true" title="Tarea realizada" lang="es" <cfif isDefined("objectItem.done") AND objectItem.done IS true>checked="checked"</cfif>>
				<img src="#APPLICATION.htmlPath#/assets/icons/task_done.png" alt="Tarea realizada"/>
				<span lang="es">Tarea realizada</span>
			</label>

		</div>
	</div>
	
</div>

</cfif>

<cfif itemTypeId IS 7 OR itemTypeId IS 8>

	<!---<label class="control-label">##</label>--->
	<div class="row">
    
    	<div class="col-xs-6 col-md-3">
    		<label class="control-label" for="identifier" id="identifierLabel"><span lang="es">#t_identifier#</span> *</label>
			<cfinput type="text" name="identifier" id="identifier" value="#objectItem.identifier#" placeholder="Identificador" class="input-xlarge" passthrough="#passthrough#" lang="es">
			<cfif itemTypeId IS 8>
				<button type="button" class="btn btn-default btn-xs" id="openInPubMedButton" lang="es" onclick="openPublicationInPubMed($('##identifier').val())">Ver en PubMed</button>
			</cfif>
		</div>

		<!---<div class="col-xs-6 col-md-3">
		</div>--->

	</div>
	<!---<div style="height:5px;"><!-- --></div>--->
</cfif>

<cfif itemTypeId IS 5 OR itemTypeId IS 8><!---Events, Publications--->
	<div class="row" id="fieldPrice">
		<div class="col-xs-6 col-md-3">
			<label class="control-label" for="price"><span lang="es">#t_price#</span> *</label>
			<cfinput type="text" name="price" id="price" value="#objectItem.price#" required="true" validate="float" message="#t_price# debe ser un decimal" passthrough="#passthrough#">
		</div>
	</div>
</cfif>

<div style="clear:both; height:15px;"><!-- --></div>

<div class="row">

	<div class="col-md-12">
<!---style="margin-bottom:10px; margin-top:5px;"---><textarea name="description" class="form-control" style="height:200px;" <cfif read_only IS true>readonly="readonly"</cfif>>#objectItem.description#</textarea>
	</div>

</div>
<div style="height:10px;"><!-- --></div>	

<cfif read_only IS false>
	
	<cfif itemTypeId IS NOT 3 AND itemTypeId IS NOT 9>
	
		<cfif isDefined("objectItem.attached_file_name") AND len(objectItem.attached_file_name) GT 0 AND objectItem.attached_file_name NEQ "-">
			<!---<div style="padding-top:5px;"><span class="texto_normal">Modificar archivo adjunto:</span>&nbsp;<cfinput type="file" name="Filedata"></div>--->
			
			<cfif isNumeric(objectItem.id)><!---No es para copiar elemento--->
				
				<div><label class="control-label" lang="es">Archivo adjunto</label> <a href="#APPLICATION.htmlPath#/file_download.cfm?id=#objectItem.attached_file_id#&#itemTypeName#=#objectItem.id#" onclick="return downloadFileLinked(this,event)">#objectItem.attached_file_name#</a>
				
				<button onclick="return deleteAttachedFile()" class="btn btn-xs btn-danger" lang="es">Eliminar archivo adjunto</button>
				
				</div>
			
			<cfelse><!---Es para copiar elemento--->
			
				<cfif itemTypeId IS NOT 3 AND isNumeric(objectItem.attached_file_id) AND objectItem.attached_file_id GT 0><!---No es enlace y el archivo está definido--->
					
					<label class="checkbox"><input type="checkbox" name="copy_attached_file_id" value="#objectItem.attached_file_id#" checked="checked" />&nbsp;<span lang="es">Archivo adjunto:</span> <span class="texto_normal">#objectItem.attached_file_name#</span>
					</label>
						
				</cfif>
			
			</cfif>

			
		<cfelse>
			
			<div class="row">
				<div class="col-md-12">

					<label for="filedata" class="control-label"><i class="icon-file icon-large" title="Archivo" lang="es"></i> <span lang="es">Archivo</span></label>
					<cfinput type="file" name="Filedata" id="filedata">

				</div>
			</div>
		</cfif>
	
	</cfif>
	
	<cfif APPLICATION.moduleWeb IS true AND itemTypeId IS NOT 1 AND itemTypeId IS NOT 6>
	
		<cfif isDefined("objectItem.attached_image_name") AND len(objectItem.attached_image_name) GT 0 AND objectItem.attached_image_name NEQ "-">
		
			<cfif isNumeric(objectItem.id)><!---No es para copiar elemento--->
			
				<div class="row">
					<div class="col-md-12">

						<label class="control-label" lang="es">Imagen adjunta</label> <a href="#APPLICATION.htmlPath#/file_download.cfm?id=#objectItem.attached_image_id#&#itemTypeName#=#objectItem.id#" onclick="return downloadFileLinked(this,event)">#objectItem.attached_image_name#</a>
					
						<button onclick="return deleteAttachedImage()" class="btn btn-xs btn-danger" lang="es">Eliminar imagen adjunta</button>

					</div>	
				</div>
			
			<cfelse><!---Es para copiar elemento--->
			
				<cfif itemTypeId IS NOT 1 AND itemTypeId IS NOT 6 AND isNumeric(objectItem.attached_image_id) AND objectItem.attached_image_id GT 0><!---No es mensaje y el archivo está definido--->
					
					<div class="row">
						<div class="col-md-12">

							<label class="checkbox"><input type="checkbox" name="copy_attached_image_id" value="#objectItem.attached_image_id#" checked="checked" />&nbsp;<span lang="es">Imagen adjunta:</span> <span class="texto_normal">#objectItem.attached_image_name#</span>
							</label>

						</div>
					</div>
						
				</cfif>
			
			</cfif>
		<cfelse>
			<div class="row">
				<div class="col-md-12">

					<label for="imagedata" class="control-label"><i class="icon-camera icon-large" title="Imagen (jpg, png, gif)" lang="es"></i> <span lang="es">Imagen</span> <cfif itemTypeId IS 9>*</cfif></label>
					<cfif itemTypeId IS NOT 9>
						<cfinput type="file" name="imagedata" id="imagedata" accept="image/*">
					<cfelse><!--- Image --->
						<cfinput type="file" name="imagedata" id="imagedata" accept="image/*" required="true" message="Archivo de imagen requerido">
					</cfif>

				</div>
			</div>
		</cfif>
	
	</cfif>
</cfif>


<div class="row">

	<div class="col-md-12">

		<label class="control-label" for="link"><span lang="es">#t_link#</span> <cfif link_required IS true>*</cfif></label>
		<cfinput type="text" name="link" id="link" value="#objectItem.link#" placeholder="http://" required="#link_required#" message="#t_link# válida con http:// requerida" class="col-md-5" passthrough="#passthrough#"><!---validate="url" DA PROBLEMAS--->

	</div>
	
</div>

<cfif itemTypeId IS NOT 1 AND itemTypeId IS NOT 6 AND itemTypeId IS NOT 7><!---IS NOT Messages, Tasks OR Consultations--->
	
<div class="row">

	<div class="col-md-6">

		<label class="control-label" for="link_target"><span lang="es">Abrir URL en</span></label> <cfif APPLICATION.moduleWeb EQ true><small lang="es">(Sólo para publicar en web)</small></cfif>
		<select name="link_target" id="link_target">
			<option value="_blank" <cfif objectItem.link_target EQ "_blank">selected="selected"</cfif> lang="es">Nueva ventana</option>
			<option value="_self" <cfif objectItem.link_target EQ "_self">selected="selected"</cfif> lang="es">Misma ventana</option>
		</select>

	</div>
	
</div>

</cfif>


<cfif itemTypeId IS 2 OR itemTypeId IS 4 OR itemTypeId IS 5>

	<cfif APPLICATION.moduleWeb EQ true>

	<div class="row">

		<div class="col-md-12"></div>

	</div>
		
	<div class="row">

		<div class="col-md-12">

			<label class="control-label" for="iframe_url" lang="es">#t_iframe_url#</label> <small lang="es">(Sólo para publicar en web)</small>
			
			<cfinput type="text" name="iframe_url" id="iframe_url" value="#objectItem.iframe_url#" placeholder="http://" message="#t_iframe_url# válida con http:// requerida" class="col-md-5" passthrough="#passthrough#"><!---validate="url" DA PROBLEMAS--->
			
		</div>
		
	</div>

	<div class="row">

		<div class="col-md-6">

			<label class="control-label" for="iframe_display_type_id" lang="es">#t_iframe_display_type#</label> <small lang="es">(Sólo para publicar en web)</small>
		
			<cfinvoke component="#APPLICATION.componentsPath#/IframeDisplayTypeManager" method="getDisplayTypes" returnvariable="iframeDisplayTypeQuery">
			</cfinvoke>
		
			<!---<cfset iframe_display_type_options = "Ancho de página, 560 x 315">
			<cfset iframe_display_type_values = "1,2">
			<option value="#iframe_display_type_id#" <cfif objectItem.iframe_display_type_id IS iframe_display_type_id>selected="selected"</cfif>>#listGetAt(iframe_display_type_options,iframe_display_type_id)#</option>--->
	
			<select name="iframe_display_type_id" id="iframe_display_type_id" <cfif read_only IS true>disabled="disabled"</cfif>>
				<cfloop query="iframeDisplayTypeQuery">
					<option value="#iframeDisplayTypeQuery.iframe_display_type_id#" <cfif objectItem.iframe_display_type_id IS iframeDisplayTypeQuery.iframe_display_type_id>selected="selected"</cfif>>#iframeDisplayTypeQuery.iframe_display_type_title_es#</option>
				</cfloop>
			</select>

		</div>

	</div>


	<!---<cfset t_iframe_width = "Ancho">
	<cfset t_iframe_height = "Alto">

	<div class="form-group">
		<label class="control-label" for="iframe_width">#t_iframe_width#</label>
		
		<cfinput type="text" name="iframe_width" id="iframe_width" value="" required="true" message="#t_iframe_width# válido requerido" validate="integer" passthrough="#passthrough#" style="width:55px;"><!---#objectItem.iframe_width#--->
		
		&nbsp;<label class="control-label" for="iframe_height">#t_iframe_height#</label>
		
		<cfinput type="text" name="iframe_height" id="iframe_height" value="" required="true" message="#t_iframe_height# válido requerido" validate="integer" passthrough="#passthrough#" style="width:55px;">
		
	</div>
	--->

	<cfelse>
		<!--- Este valor es necesario porque la columna en la que se almacena tiene una referencia con otra tabla --->
		<input type="hidden" name="iframe_display_type_id" value="#objectItem.iframe_display_type_id#"/>

	</cfif>


</cfif>

<cfif itemTypeId IS 2 OR itemTypeId IS 3 OR itemTypeId IS 4><!---Entries, Links, News--->

	<!---<cfif SESSION.client_abb EQ "hcs">
		
		<div class="row">
		
			<div class="col-md-6">

				<label class="control-label" lang="es">#t_position#</label>
					
				<cfinput type="text" name="position" id="position" value="#objectItem.position#" required="true" validate="integer" message="#t_position# debe ser un número entero" style="width:50px;" passthrough="#passthrough#">

			</div>

		</div>

	</cfif>--->

	<cfif itemTypeId IS 2>
	<div class="row">
	
		<div class="col-md-6">

			<label class="control-label" lang="es">#t_display_type#</label> <small lang="es">(Sólo para publicar en web)</small>

			<cfinvoke component="#APPLICATION.componentsPath#/DisplayTypeManager" method="getDisplayTypes" returnvariable="displayTypeQuery">
			</cfinvoke>
			
			<select name="display_type_id" <cfif read_only IS true>disabled="disabled"</cfif>>
				<cfloop query="displayTypeQuery">
					<option value="#displayTypeQuery.display_type_id#" <cfif objectItem.display_type_id IS displayTypeQuery.display_type_id>selected="selected"</cfif>>#displayTypeQuery.display_type_title_es#</option>
				</cfloop>
			</select>

		</div>

	</div>
	</cfif>

</cfif>



</cfoutput>

<cfif APPLICATION.identifier NEQ "dp"><!---SMS Deshabilitado para DoPlanning--->
	<cfif objectUser.sms_allowed IS true>
		<cfoutput>
		
		<div class="row">
			<div class="col-md-12">

				<label class="checkbox">
				<img src="#APPLICATION.htmlPath#/assets/icons/sms.png" alt="Enviar SMS"/> <cfinput type="checkbox" name="notify_by_sms" value="true" title="Enviar notificación por SMS"> Enviar notificación por SMS
				</label>

			 </div>
		</div>
		
		</cfoutput>
	</cfif>
</cfif>
<div style="clear:both"></div>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/CKEditorManager" method="loadComponent">
	<cfinvokeargument name="name" value="description">
	<cfinvokeargument name="language" value="#SESSION.user_language#"/>
</cfinvoke>