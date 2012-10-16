<!---Variables requeridas:
itemTypeId
return_path: define la ruta donde se encuentra esta página, para que al enviar el mensaje se vuelva a ella--->
<cfoutput>
<script src="#APPLICATION.htmlPath#/ckeditor/ckeditor.js" type="text/javascript"></script>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
	<cfinvokeargument name="format_content" value="all">
</cfinvoke>

	
<cfif isDefined("URL.#itemTypeName#")>
	<cfset item_id = URL[#itemTypeName#]>
	
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="selectItem" returnvariable="xmlResponse">
		<cfinvokeargument name="item_id" value="#item_id#">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	</cfinvoke>
	
	<cfxml variable="xmlItem">
		<cfoutput>
		#xmlResponse.response.result.xmlChildren[1]#
		</cfoutput>
	</cfxml>
	
	<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="objectItem" returnvariable="objectItem">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		<cfinvokeargument name="xml" value="#xmlItem#">
		<cfinvokeargument name="return_type" value="object">
	</cfinvoke>
	
	<!---<cfset area_id = xmlItem.xmlChildren[1].xmlAttributes.area_id>
	<cfset title_default = "Re: "&xmlItem.xmlChildren[1].title.xmlText>--->
	
	<cfset area_id = objectItem.area_id>
	
	<cfset return_page = "#itemTypeName#.cfm?#itemTypeName#=#item_id#">
	
<cfelse>
	<cflocation url="#APPLICATION.htmlPath#/" addtoken="no">
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">
<div class="div_head_subtitle">
<cfoutput>
<cfif itemTypeGender EQ "male">Modificar<cfelse>Modificar</cfif> #itemTypeNameEs#
</cfoutput>
</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfset page_type = 2>
<cfinclude template="#APPLICATION.htmlPath#/includes/area_item_form.cfm">

<!---<div class="contenedor_fondo_blanco">
<div class="div_send_message">
<script type="text/javascript">
function onSubmitForm()
{
	if(check_custom_form())
	{
		document.getElementById("submitDiv").innerHTML = "Enviando...";

		return true;
	}
	else
		return false;
}
</script>

<cfform action="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=updateItem" method="post" enctype="multipart/form-data" name="item_form" onsubmit="return onSubmitForm();">
	<cfinput type="hidden" name="itemTypeId" value="#itemTypeId#">
	<cfinput type="hidden" name="item_id" value="#item_id#">
	<cfinput type="hidden" name="area_id" value="#area_id#">
	<cfinput type="hidden" name="return_path" value="#return_path#">
	
	<cfinclude template="#APPLICATION.htmlPath#/includes/area_item_inputs.cfm">
	<!---<div class="div_subject_input"><span class="texto_normal">Asunto:</span>&nbsp;<cfinput type="text" name="title" class="input_message_subject" value="#objectItem.title#" required="true" message="Asunto requerido"></div>
    
	<cfoutput>
    <div class="div_content_textarea"><textarea name="description" class="textarea_content">#objectItem.description#</textarea></div>
    </cfoutput>
	
	<cfif len(objectItem.attached_file_name) GT 0 AND objectItem.attached_file_name NEQ "-">
    	<div style="padding-top:5px;"><span class="texto_normal">Modificar archivo adjunto:</span>&nbsp;<cfinput type="file" name="Filedata"></div>
	<cfelse>
		<div style="padding-top:5px;"><span class="texto_normal">Adjuntar un archivo:</span>&nbsp;<cfinput type="file" name="Filedata"></div>
	</cfif>
	
	<cfif objectUser.sms_allowed IS true>
	<cfoutput>
	<div style="padding-top:5px; clear:both;"><div style="float:left; clear:none"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/sms.gif" alt="SMS"/></div><div style="vertical-align:top; padding-top:4px; float:left; clear:right;"><span class="texto_normal">Notificar a los usuarios por SMS</span>&nbsp;<cfinput type="checkbox" name="notify_by_sms" value="true" title="Enviar notificación por SMS"></div></div>
	</cfoutput>
	</cfif>
	<div style="clear:both"></div>--->
	
    <div class="input_submit" id="submitDiv"><cfinput type="submit" name="submit" class="input_message_submit" value="Enviar"></div>
</cfform>


</div>

</div>--->