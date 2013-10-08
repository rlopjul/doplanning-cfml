<cfinclude template="#APPLICATION.htmlPath#/includes/area_item_form_query.cfm">

<div class="contenedor_fondo_blanco">
<div class="div_send_message">

<cfif page_type IS 1 OR objectItem.user_in_charge EQ SESSION.user_id>
	<cfset read_only = false>
<cfelseif itemTypeId IS NOT 1 AND (area_type EQ "web" OR area_type EQ "intranet")>
	<cfset read_only = false>
<cfelse>
	<cfif itemTypeId IS 6 AND objectItem.recipient_user EQ SESSION.user_id><!---Los destinatarios de tareas pueden acceder a modificar algunos de sus valores--->
		<cfset read_only = true>
	<cfelse>
		<cflocation url="#return_page#" addtoken="no">
	</cfif>
</cfif>

<cfif itemTypeId IS 4 OR itemTypeId IS 5 OR itemTypeId IS 6><!---News, Events, Tasks--->

<cfoutput>
<link href="#APPLICATION.jqueryUICSSPath#" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="#APPLICATION.jqueryUIJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/jquery-ui/jquery.ui.datepicker-es.js"></script>
</cfoutput>

</cfif>

<cfoutput>
<script type="text/javascript">

var editor;

var preventClose = false;
	
$(window).on('beforeunload', function(){
	
	//editor.updateElement();	//Update CKEditor state to update preventClose value
	
	if(preventClose){
		
		var alerMessage = window.lang.convert('Tiene texto sin enviar, si abandona esta página lo perderá');
		
		return alertMessage;
	
	}
	else 
		return;

});


$(document).ready(function() {
  
  	$('input').change(function() {
		preventClose = true;
	});
	
	/*$('textarea').change(function() {
		preventClose = true;
	});*/	

	// The instanceReady event is fired, when an instance of CKEditor has finished
	// its initialization.

	CKEDITOR.on('instanceReady', function( ev )	{
		editor = ev.editor;
	
		<cfif read_only IS true>
		editor.setReadOnly(true);
		</cfif>
		
		editor.on('saveSnapshot', function(e) { 
			preventClose = true;
		});
		
		editor.on('blur', function(e) {
			if (e.editor.checkDirty()) { //CKEDITOR cambiado
				preventClose = true;
				//alert("CKEDITOR modificado");
			}
		});		
	});
  
});

function onSubmitForm()
{
	if(check_custom_form())
	{
		var submitForm = true;
		
		<cfif itemTypeId IS 5>
		if(!checkDates("start_date", "end_date")) {
			submitForm = false;
			alert(window.lang.convert("Fechas incorrectas. Compruebe que la fecha de fin del evento es igual o posterior a la fecha de inicio y tiene el formato adecuado."));
		}
		</cfif>
		
		if(submitForm){		
			document.getElementById("submitDiv1").innerHTML = window.lang.convert('Enviando...');
			document.getElementById("submitDiv2").innerHTML = window.lang.convert('Enviando...');
		}
		
		preventClose = false;
		
		return submitForm;
	}
	else
		return false;
}
</script>
</cfoutput>

<cfif page_type IS 1><!---NEW ITEM--->

	<!---<cfset form_action = "#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=createItemRemote">--->


	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getEmptyItem" returnvariable="objectItem">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	</cfinvoke>
	
	<cfset objectItem.title = title_default>

	<!---<cfset objectItem = structNew()>
	<cfset objectItem.title = title_default>
	<cfset objectItem.description = "">
	<cfset objectItem.attached_file_name = ""> 
	<cfset objectItem.attached_image_name = "">
	
	<cfset objectItem.display_type_id = "">
	<cfset objectItem.iframe_url = "">
	<cfset objectItem.iframe_display_type_id = 1>
	
	<cfif itemTypeId IS 3>
		<cfset objectItem.link = "http://">
	<cfelse>
		<cfset objectItem.link = "">
	</cfif>
	
	<cfif itemTypeId IS 4><!---News--->
		<cfset cur_date = DateFormat(now(), "DD-MM-YYYY")>
		<cfset objectItem.creation_date = cur_date>
	</cfif>
	
	<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->
		<cfset cur_date = DateFormat(now(), "DD-MM-YYYY")>
		
		<cfset objectItem.start_date = cur_date>
		<cfset objectItem.end_date = cur_date>
		
		<cfif itemTypeId IS 5>
			<cfset objectItem.start_time = "00:00">
			<cfset objectItem.end_time = "00:00">
			<cfset objectItem.place = "">
		<cfelse>
			<cfset objectItem.recipient_user = "">
			<cfset objectItem.recipient_user_full_name = "">
			<cfset objectItem.done = "">
			<cfset objectItem.estimated_value = 0>
			<cfset objectItem.real_value = 0>
		</cfif>
 	</cfif>
	
	<cfif itemTypeId IS 7><!---Consultation--->
		<cfset objectItem.identifier = "">
	</cfif>
	
	<cfif itemTypeId IS 2 OR itemTypeId IS 3 OR itemTypeId IS 4><!---Entries, Links, News--->
	
		<!---getAreaItemsLastPosition--->
		<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="getAreaItemsLastPosition" returnvariable="lastPosition">
			<cfinvokeargument name="area_id" value="#area_id#">
			<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		</cfinvoke>
		
		<cfset objectItem.position = lastPosition+1>
	
	</cfif>--->
	

<cfelse><!---MODIFY ITEM--->
	<!---<cfset form_action = "#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=updateItemRemote">--->
</cfif>

<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" enctype="multipart/form-data" name="item_form" class="form-inline" onsubmit="return onSubmitForm();">
	<cfinput type="hidden" name="itemTypeId" value="#itemTypeId#">
	<cfinput type="hidden" name="area_id" value="#area_id#">
	<cfinput type="hidden" name="return_path" value="#return_path#">
	<cfif page_type IS 1><!---NEW ITEM--->
		<cfinput type="hidden" name="parent_id" value="#parent_id#">
		<cfinput type="hidden" name="parent_kind" value="#parent_kind#">
	<cfelse>
		<cfinput type="hidden" name="item_id" value="#item_id#">
	</cfif>
	
	<div id="submitDiv1" style="margin-bottom:5px;"><input type="submit" name="submit1" value="Enviar" class="btn btn-primary" lang="es"/>
		<cfif page_type IS 2 OR isDefined("URL.message")>
			<cfoutput>
			<a href="#return_page#" class="btn" style="float:right;" lang="es">Cancelar</a>
			</cfoutput>
		</cfif>
	</div>
	
	<cfinclude template="#APPLICATION.htmlPath#/includes/area_item_inputs.cfm">
	
	<cfif APPLICATION.moduleTwitter IS true AND area_type IS "web">
	<cfoutput>
	<div class="control-group">
		<div class="controls">
			<label class="checkbox">
				<img src="#APPLICATION.htmlPath#/assets/icons/twitter_icon.png" alt="Twitter"/> <cfinput type="checkbox" name="post_to_twitter" value="true" title="Enviar #itemTypeNameEs# a Twitter"> Publicar #itemTypeNameEs# en Twitter
			</label>			
		</div>
	</div>
	</cfoutput>
	</cfif>
	
	<div style="clear:both; height:10px;"><!-- --></div>
	
    <div id="submitDiv2"><input type="submit" name="submit2" value="Enviar" class="btn btn-primary" lang="es"/>
		<cfif page_type IS 2 OR isDefined("URL.message")>
			<cfoutput>
			<a href="#return_page#" class="btn" style="float:right;" lang="es">Cancelar</a>
			</cfoutput>
		</cfif>
	</div>
	
</cfform>


</div>

</div>