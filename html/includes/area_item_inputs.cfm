<cfset delete_attached_file_action = "#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=deleteItemAttachedFileRemote">

<cfset delete_attached_image_action = "#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=deleteItemAttachedImageRemote">

<cfoutput>

<script type="text/javascript">
	<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->
	
	<cfif read_only IS false>
	
	$(function() {
		$.datepicker.setDefaults($.datepicker.regional['es']);
		
		var dates = $( ".input_datepicker" ).datepicker({ dateFormat: 'dd-mm-yy', 
			changeMonth: true,
			changeYear: true,
			onSelect: function( selectedDate ) {
				var option = this.id == "start_date" ? "minDate" : "maxDate",
				instance = $( this ).data( "datepicker" ),
				date = $.datepicker.parseDate(
					instance.settings.dateFormat ||
					$.datepicker._defaults.dateFormat,
					selectedDate, instance.settings );
					//dates.not( this ).datepicker( "option", option, date );
					if(this.id == "start_date")
						$( "##end_date" ).datepicker( "option", option, date );
					else if(this.id == "end_date")
						$( "##start_date" ).datepicker( "option", option, date );
				}
			});
		
	});
	
	</cfif>
	
	function checkDates(startDateFieldName, endDateFieldName) {
		
		var startDateVal = $("input:text[name="+startDateFieldName+"]").val();	
		var endDateVal = $("input:text[name="+endDateFieldName+"]").val();	
		
		var startDateParts = startDateVal.split('-');
		var endDateParts = endDateVal.split('-');
		
		//Comprueba que el año tenga 4 cifras
		//(Los años de 2 cifras generan fechas incorrectas al guardarse en MySQL)
		if(startDateParts[2].length != 4 || endDateParts[2].length != 4)
			return false;
		
		var startDate = $.datepicker.parseDate("dd-mm-yy", startDateVal);
		var endDate = $.datepicker.parseDate("dd-mm-yy", endDateVal);
				
		return startDate <= endDate;
		
	}

	</cfif>
	
	function downloadFile(url){
		showLoading = false;
		
		goToUrl(url);
	}
	
	function openPopup(url) {
		 window.open(url, "popup_id", "scrollbars,resizable,width=580,height=500");
		 return false;
	}
	
	function setRecipientUser(userId, userName) {
				
		document.getElementById("recipient_user").value = userId;
		document.getElementById("recipient_user_full_name").value = userName;
		/*$("##recipient_user").val(userId); 
		$("##recipient_user_name").val(userName); */
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
	
</script>
	
</script>


<script type="text/javascript">
	var railo_custom_form=new RailoForms('item_form');
</script>
<script type="text/javascript" src="#APPLICATION.htmlPath#/Scripts/checkRailoForm.js"></script>

<!---<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->
	<cfset objectItem.start_date = DateFormat(objectItem.start_date, APPLICATION.dateFormat)>
	<cfset objectItem.end_date = DateFormat(objectItem.end_date, APPLICATION.dateFormat)>
</cfif>--->
	


<cfif itemTypeId IS 1>
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
	<cfset t_link = "URL (con http://)">
	<cfset link_required = true>
<cfelse>
	<cfset t_link = "URL más información (con http://)">
	<cfset link_required = false>
</cfif>
<cfif itemTypeId IS 5 OR itemTypeId IS 6>
	<cfset t_start_date = "Fecha inicio">
	<cfset t_end_date = "Fecha fin">
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
<cfset t_position = "Posición">
<cfset t_iframe_url = "Incrustar contenido (URL)">
<cfset t_iframe_display_type = "Tamaño contenido incrustado">

<cfif read_only IS true>
	<cfset passthrough = 'readonly="readonly"'>
<cfelse>
	<cfset passthrough = "">
</cfif>

<div class="div_subject_input"><span class="texto_normal">#t_title#:</span>&nbsp;<cfinput type="text" name="title" class="input_message_subject" value="#objectItem.title#" required="#title_required#" message="#t_title# requerido" passthrough="#passthrough#"></div>
<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->

<cfif itemTypeId IS 6><!---Tasks--->
	<div style="padding-bottom:2px;"><span class="texto_normal">#t_recipient_user#:</span>&nbsp;<cfinput type="hidden" name="recipient_user" id="recipient_user" value="#objectItem.recipient_user#" validate="integer" required="yes" message="Usuario destinatario requerido"/><cfinput type="text" name="recipient_user_full_name" id="recipient_user_full_name" value="#objectItem.recipient_user_full_name#" readonly="yes"><cfif read_only IS false><button onclick="return openPopup('area_users_select.cfm?area=#area_id#');">Seleccionar usuario</button>&nbsp;<span style="font-size:10px">Usuario al que se le asignará la tarea</span></cfif></div>
</cfif>

<div><span class="texto_normal">#t_start_date#:</span>&nbsp;<cfinput type="text" name="start_date" id="start_date" class="input_datepicker" value="#objectItem.start_date#" required="true" message="#t_start_date# válida requerida" validate="eurodate" mask="DD-MM-YYYY" passthrough="#passthrough#">

<cfif itemTypeId IS 5>
	
	<cfif len(objectItem.start_time) IS 0>
		<cfset objectItem.start_time = createTime(0,0,0)>
	</cfif>
	
	<cfset start_hour = hour(objectItem.start_time)>
	<cfset start_minute = minute(objectItem.start_time)>
	
	<span class="texto_normal">#t_start_time#:</span>&nbsp;<select name="start_hour">
		<cfloop from="0" to="23" index="hour">
			<option value="#hour#" <cfif hour EQ start_hour>selected="selected"</cfif>>#hour#</option>
		</cfloop>
	</select>:<select name="start_minute">
		<cfloop from="0" to="59" index="minutes" step="15">
			<cfif minutes EQ "0">
				<cfset minutes = "00">
			</cfif>
			<option value="#minutes#" <cfif minutes EQ start_minute>selected="selected"</cfif>>#minutes#</option>
		</cfloop>
	</select>

<cfelse>
	<span style="font-size:10px">Formato DD-MM-AAAA. Ejemplo: #DateFormat(now(), "DD-MM-YYYY")#</span>
</cfif>
</div>

<div style="padding-top:5px; padding-bottom:5px;"><span class="texto_normal">#t_end_date#:&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;<cfinput type="text" name="end_date" id="end_date" class="input_datepicker" value="#objectItem.end_date#" required="true" message="#t_end_date# válida requerida" validate="eurodate" mask="DD-MM-YYYY" passthrough="#passthrough#">

<cfif itemTypeId IS 5>

	<cfif len(objectItem.end_time) IS 0>
		<cfset objectItem.end_time = createTime(0,0,0)>
	</cfif>

	<cfset end_hour = hour(objectItem.end_time)>
	<cfset end_minute = minute(objectItem.end_time)>
	
	<span class="texto_normal">#t_end_time#:</span>&nbsp;<select name="end_hour">
		<cfloop from="0" to="23" index="hour">
			<option value="#hour#" <cfif hour EQ end_hour>selected="selected"</cfif>>#hour#</option>
		</cfloop>
	</select>:<select name="end_minute">
		<cfloop from="0" to="59" index="minutes" step="15">
			<cfif minutes EQ "0">
				<cfset minutes = "00">
			</cfif>
			<option value="#minutes#" <cfif minutes EQ end_minute>selected="selected"</cfif>>#minutes#</option>
		</cfloop>
	</select>

</cfif>

</div>
</cfif>

<cfif itemTypeId IS 5><!---Events--->
<div><span class="texto_normal">#t_place#:</span>&nbsp;<cfinput type="text" name="place" id="place" value="#objectItem.place#" required="true" message="#t_place# requerido" passthrough="#passthrough#"></div>
<cfelseif itemTypeId IS 6><!---Tasks--->
<div><span class="texto_normal">#t_estimated_value#:</span>&nbsp;<cfinput type="text" name="estimated_value" id="estimated_value" value="#objectItem.estimated_value#" required="true" validate="float" message="#t_estimated_value# debe ser un decimal" style="width:50px;" passthrough="#passthrough#">&nbsp;<span style="font-size:10px">Valor (tiempo, coste, ...) estimado para la tarea.</span></div>
<div style="padding-top:5px; padding-bottom:5px;"><span class="texto_normal">#t_real_value#:</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfinput type="text" name="real_value" id="real_value" value="#objectItem.real_value#" required="true" validate="float" message="#t_real_value# debe ser un decimal" style="width:50px;">&nbsp;<span style="font-size:10px">Valor real de la tarea una vez realizada.</span></div>

<div style="padding-top:7px; padding-right:4px; float:left; clear:none;"><cfinput type="checkbox" name="done" value="true" title="Tarea realizada"></div><div style="clear:none; float:left;"><img src="#APPLICATION.htmlPath#/assets/icons/task_done.png" alt="Tarea realizada"/></div><div class="texto_normal" style="clear:none; float:left; padding-top:5px;">&nbsp;Tarea realizada</div>

<div style="clear:both; height:1px;"><!-- --></div>

</cfif>

<div class="div_content_textarea"><textarea name="description" class="textarea_content" <cfif read_only IS true>readonly="readonly"</cfif>>#objectItem.description#</textarea></div>

<!---<cfif itemTypeId IS NOT 1>--->
<div><span class="texto_normal">#t_link#:</span>&nbsp;<cfinput type="text" name="link" value="#objectItem.link#" required="#link_required#" message="#t_link# válida con http:// requerida" style="width:280px;" passthrough="#passthrough#"></div><!---validate="url" DA PROBLEMAS--->
<!---</cfif>--->

<cfif read_only IS false>
	
	<cfif itemTypeId IS NOT 3>
	
		<cfif len(objectItem.attached_file_name) GT 0 AND objectItem.attached_file_name NEQ "-">
			<!---<div style="padding-top:5px;"><span class="texto_normal">Modificar archivo adjunto:</span>&nbsp;<cfinput type="file" name="Filedata"></div>--->
			
			<cfif isNumeric(objectItem.id)><!---No es para copiar elemento--->
			
				<div style="padding-top:5px;"><span class="texto_normal">Archivo adjunto:</span> <a onclick="downloadFile('#APPLICATION.htmlPath#/file_download.cfm?id=#objectItem.attached_file_id#&#itemTypeName#=#objectItem.id#')" class="link_blue" style="cursor:pointer;">#objectItem.attached_file_name#</a>
				
				<button onclick="return deleteAttachedFile()">Eliminar archivo adjunto</button>
				
				</div>
			
			<cfelse><!---Es para copiar elemento--->
			
				<cfif itemTypeId IS NOT 3 AND isNumeric(objectItem.attached_file_id) AND objectItem.attached_file_id GT 0><!---No es enlace y el archivo está definido--->
					
					<div style="padding-top:5px;"><input type="checkbox" name="copy_attached_file_id" value="#objectItem.attached_file_id#" checked="checked" />&nbsp;<span class="texto_normal">Archivo adjunto:</span> <span>#objectItem.attached_file_name#</span>
					</div>
						
				</cfif>
			
			</cfif>

			
		<cfelse>
			<div style="padding-top:5px;"><span class="texto_normal">Adjuntar un archivo:</span>&nbsp;<cfinput type="file" name="Filedata"></div>
		</cfif>
	
	</cfif>
	
	<cfif APPLICATION.moduleWeb IS "enabled" AND itemTypeId IS NOT 1 AND itemTypeId IS NOT 6>
	
		<cfif len(objectItem.attached_image_name) GT 0 AND objectItem.attached_image_name NEQ "-">
		
			<cfif isNumeric(objectItem.id)><!---No es para copiar elemento--->
			
				<div style="padding-top:5px;"><span class="texto_normal">Imagen adjunta:</span> <a onclick="downloadFile('#APPLICATION.htmlPath#/file_download.cfm?id=#objectItem.attached_image_id#&#itemTypeName#=#objectItem.id#')" class="link_blue" style="cursor:pointer;">#objectItem.attached_image_name#</a>
				
				<button onclick="return deleteAttachedImage()">Eliminar imagen adjunta</button>
				
				</div>
			
			<cfelse><!---Es para copiar elemento--->
			
				<cfif itemTypeId IS NOT 1 AND itemTypeId IS NOT 6 AND isNumeric(objectItem.attached_image_id) AND objectItem.attached_image_id GT 0><!---No es mensaje y el archivo está definido--->
					
					<div style="padding-top:5px;"><input type="checkbox" name="copy_attached_image_id" value="#objectItem.attached_image_id#" checked="checked" />&nbsp;<span class="texto_normal">Imagen adjunta:</span> <span>#objectItem.attached_image_name#</span>
					</div>
						
				</cfif>
			
			</cfif>
		<cfelse>
			<div style="padding-top:5px;"><span class="texto_normal">Adjuntar una imagen (JPG, PNG, GIF):</span>&nbsp;<cfinput type="file" name="imagedata" accept="image/*"></div>
		</cfif>
	
	</cfif>
</cfif>

<cfif itemTypeId IS 2 OR itemTypeId IS 4 OR itemTypeId IS 5>
<div style="padding-top:5px;">

	<span class="texto_normal">#t_iframe_url#:</span>&nbsp;<cfinput type="text" name="iframe_url" value="#objectItem.iframe_url#" message="#t_iframe_url# válida con http:// requerida" style="width:324px;" passthrough="#passthrough#"><!---validate="url" DA PROBLEMAS--->
	<div style="height:2px;"><!--- ---></div>
	<span class="texto_normal">#t_iframe_display_type#:</span>
	<cfset iframe_display_type_options = "Ancho de página, 560 x 315">
	<cfset iframe_display_type_values = "1,2">
	<select name="iframe_display_type" <cfif read_only IS true>disabled="disabled"</cfif>>
		<cfloop list="#iframe_display_type_values#" index="iframe_display_type">
			<option value="#iframe_display_type#" <cfif objectItem.iframe_display_type IS iframe_display_type>selected="selected"</cfif>>#listGetAt(iframe_display_type_options,iframe_display_type)#</option>
		</cfloop>
	</select>

</div>
</cfif>

<cfif itemTypeId IS 2 OR itemTypeId IS 3><!---Entries, Links--->
<div style="padding-top:5px;">

<span class="texto_normal">#t_position#:</span>&nbsp;<cfinput type="text" name="position" id="position" value="#objectItem.position#" required="true" validate="integer" message="#t_position# debe ser un número entero" style="width:50px;" passthrough="#passthrough#">

	<cfif itemTypeId IS 2>
	<span class="texto_normal">#t_display_type#:</span>&nbsp;
	<cfset display_type_options = "Por defecto,Listado de elementos,Imagen a la derecha,Imagen a la izquierda,Figura con pie">
	<cfset display_type_values = "1,2,3,4,5">
	<select name="display_type" <cfif read_only IS true>disabled="disabled"</cfif>>
		<cfloop list="#display_type_values#" index="display_type">
			<option value="#display_type#" <cfif objectItem.display_type IS display_type>selected="selected"</cfif>>#listGetAt(display_type_options,display_type)#</option>
		</cfloop>
	</select>
	</cfif>

</div>
</cfif>



</cfoutput>

<cfif APPLICATION.identifier NEQ "dp"><!---SMS Deshabilitado para DoPlanning--->
	<cfif objectUser.sms_allowed IS true>
		<cfoutput>
		<div style="padding-top:8px; padding-right:4px; float:left; clear:none;"><cfinput type="checkbox" name="notify_by_sms" value="true" title="Enviar notificación por SMS"></div><div style="clear:none; float:left;"><img src="#APPLICATION.htmlPath#/assets/icons/sms.png" alt="Enviar SMS"/></div><div class="texto_normal" style="clear:none; float:left; padding-top:6px;">&nbsp;Enviar notificación por SMS</div>
		</cfoutput>
	</cfif>
</cfif>
<div style="clear:both"></div>

<cfif read_only IS true>
	<script type="text/javascript">
	
		var editor;

		// The instanceReady event is fired, when an instance of CKEditor has finished
		// its initialization.
		
		CKEDITOR.on('instanceReady', function( ev )	{
			editor = ev.editor;
		
			editor.setReadOnly(true);
		});
	
	</script>
</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/CKEditorManager" method="loadComponent">
	<cfinvokeargument name="name" value="description">
</cfinvoke>