<div class="contenedor_fondo_blanco">
<div class="div_send_message">

<cfif page_type IS 1 OR objectItem.user_in_charge EQ SESSION.user_id>
	<cfset read_only = false>
<cfelse>
	<cfif itemTypeId IS 6 AND objectItem.recipient_user EQ SESSION.user_id><!---Los destinatarios de tareas pueden acceder a modificar algunos de sus valores--->
		<cfset read_only = true>
	<cfelse>
		<cflocation url="#return_page#" addtoken="no">
	</cfif>
</cfif>

<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->

<cfoutput>
<link href="#APPLICATION.jqueryUICSSPath#" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.jqueryUIJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/jquery-ui/jquery.ui.datepicker-es.js"></script>
</cfoutput>

</cfif>

<script type="text/javascript">

function onSubmitForm()
{
	if(check_custom_form())
	{
		var submitForm = true;
		
		<cfif itemTypeId IS 5>
		if(!checkDates("start_date", "end_date")) {
			submitForm = false;
			alert("Fechas incorrectas. Compruebe que la fecha de fin del evento es igual o posterior a la fecha de inicio y tiene el formato adecuado.");
		}
		</cfif>
		
		if(submitForm){
			document.getElementById("submitDiv1").innerHTML = "Enviando...";
			document.getElementById("submitDiv2").innerHTML = "Enviando...";
		}

		return submitForm;
	}
	else
		return false;
}
</script>

<cfif page_type IS 1><!---NEW ITEM--->
	<cfset form_action = "#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=createItemRemote">

	<cfset objectItem = structNew()>
	<cfset objectItem.title = title_default>
	<cfset objectItem.description = "">
	<cfset objectItem.attached_file_name = ""> 
	<cfset objectItem.attached_image_name = "">
	
	<cfset objectItem.display_type = "">
	<cfset objectItem.iframe_url = "">
	<cfset objectItem.iframe_display_type = "">
	
	<cfif itemTypeId IS 3>
		<cfset objectItem.link = "http://">
	<cfelse>
		<cfset objectItem.link = "">
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
	
	<cfif itemTypeId IS 2 OR itemTypeId IS 3><!---Entries, Links--->
	
		<!---getAreaItemsLastPosition--->
		<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="getAreaItemsLastPosition" returnvariable="lastPosition">
			<cfinvokeargument name="area_id" value="#area_id#">
			<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		</cfinvoke>
		
		<cfset objectItem.position = lastPosition+1>
	
	</cfif>
	

<cfelse><!---MODIFY ITEM--->
	<cfset form_action = "#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=updateItemRemote">
</cfif>

<cfform action="#form_action#" method="post" enctype="multipart/form-data" name="item_form" onsubmit="return onSubmitForm();">
	<cfinput type="hidden" name="itemTypeId" value="#itemTypeId#">
	<cfinput type="hidden" name="area_id" value="#area_id#">
	<cfinput type="hidden" name="return_path" value="#return_path#">
	<cfif page_type IS 1><!---NEW ITEM--->
		<cfinput type="hidden" name="parent_id" value="#parent_id#">
		<cfinput type="hidden" name="parent_kind" value="#parent_kind#">
	<cfelse>
		<cfinput type="hidden" name="item_id" value="#item_id#">
	</cfif>
	
	<div class="input_submit" id="submitDiv1" style="padding-bottom:5px;"><input type="submit" name="submit1" class="input_message_submit" value="Guardar"></div>
	
	<cfinclude template="#APPLICATION.htmlPath#/includes/area_item_inputs.cfm">
	
	<!---
	<div class="div_subject_input"><span class="texto_normal">Asunto:</span>&nbsp;<cfinput type="text" name="title" class="input_message_subject" value="#title_default#" required="true" message="Asunto requerido"></div>
    
    <!---cftextarea is not supported by Railo 3.0--->
    <div class="div_content_textarea"><textarea name="description" class="textarea_content"></textarea></div>
    
    <div style="padding-top:5px;"><span class="texto_normal">Adjuntar:</span>&nbsp;<cfinput type="file" name="Filedata"></div>
	
	<cfif objectUser.sms_allowed IS true>
	<cfoutput>
	<div style="padding-top:5px; clear:both;"><div style="float:left; clear:none"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/sms.gif" alt="SMS"/></div><div style="vertical-align:top; padding-top:4px; float:left; clear:right;"><span class="texto_normal">Notificar a los usuarios por SMS</span>&nbsp;<cfinput type="checkbox" name="notify_by_sms" value="true" title="Enviar notificación por SMS"></div></div>
	</cfoutput>
	</cfif>
	<div style="clear:both"></div>--->
	
	<cfif APPLICATION.moduleTwitter IS "enabled" AND area_type IS "web">
	<cfoutput>
	<div style="padding-top:6px; padding-right:8px; float:left; clear:none;"><cfinput type="checkbox" name="post_to_twitter" value="true" title="Enviar #itemTypeNameEs# a Twitter"></div><div style="clear:none; float:left;"><img src="#APPLICATION.htmlPath#/assets/icons/twitter_icon.png" alt="Twitter"/></div><div class="texto_normal" style="clear:none; float:left; padding-top:5px;">&nbsp;Publicar #itemTypeNameEs# en Twitter</div>
	</cfoutput>
	</cfif>
	<div style="clear:both; height:10px;"><!-- --></div>
	
    <div class="input_submit" id="submitDiv2"><input type="submit" name="submit2" class="input_message_submit" value="Enviar"></div>
</cfform>

<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/CKEditorManager" method="loadComponent">
	<cfinvokeargument name="name" value="description">
</cfinvoke>
--->
</div>

</div>