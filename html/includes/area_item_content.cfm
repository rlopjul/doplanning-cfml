<cfoutput>
<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
</cfoutput>
<script type="text/javascript">
	<!---Esto es para evitar que se abran enlaces en el iframe--->
	$(document).ready(function(){
		$(".div_message_page_description a").attr('target','_blank');
	}); 
	
	function downloadFile(url){
		showLoading = false;
		
		goToUrl(url);
	}
	
	function submitCopyItemForm(){
		var url = "_copy.cfm";
		
		var form=document.getElementById("copy_item_to");
		
		var itemTypeName = form.elements["item_type"].value;
		
		url = itemTypeName+url;
		
		form.action = url;
				
		form.submit();
	
	}

</script>

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfif isDefined("URL.#itemTypeName#")>
	<cfset item_id = URL[#itemTypeName#]>
<cfelse>
	<cflocation url="area.cfm" addtoken="no">
</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="selectItem" returnvariable="xmlResponse">
	<cfinvokeargument name="item_id" value="#item_id#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>

<cfxml variable="xmlItem">
	<cfoutput>
	#xmlResponse.response.result.xmlChildren[1]#
	</cfoutput>
</cfxml>

<!---<cfoutput>
<textarea>
#xmlItem#
</textarea>
</cfoutput>--->

<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="objectItem" returnvariable="objectItem">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	<cfinvokeargument name="xml" value="#xmlItem#">
	<cfinvokeargument name="return_type" value="object">
</cfinvoke>

<cfset area_id = objectItem.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<div class="div_head_subtitle">
<cfoutput>
#itemTypeNameEs#
</cfoutput>
</div>

<cfoutput>
<div class="div_elements_menu" style="padding-top:5px;"><!---div_elements_menu--->

<cfif itemTypeId IS 1><!---Solo para mensajes--->
<div class="div_element_menu">
	<div class="div_icon_menus"><a href="#itemTypeName#_new.cfm?#itemTypeName#=#objectItem.id#"><img src="#APPLICATION.htmlPath#/assets/icons/message_reply.png" title="Responder #itemTypeNameEs#" alt="Responder #itemTypeNameEs#"/></a></div><div class="div_text_menus"><a href="#itemTypeName#_new.cfm?#itemTypeName#=#objectItem.id#"> <span class="texto_normal">Responder</span></a></div>
</div>
</cfif>
<cfif len(objectItem.attached_file_name) GT 0 AND objectItem.attached_file_name NEQ "-">
<div class="div_element_menu" style="padding-left:5px;">
<div class="div_icon_menus"><a onclick="downloadFile('#APPLICATION.htmlPath#/file_download.cfm?id=#objectItem.attached_file_id#&#itemTypeName#=#objectItem.id#')" style="cursor:pointer;"><img src="#APPLICATION.htmlPath#/assets/icons/file_download.png" alt="Descargar adjunto"/></a></div><div class="div_text_menus"><a onclick="downloadFile('#APPLICATION.htmlPath#/file_download.cfm?id=#objectItem.attached_file_id#&#itemTypeName#=#objectItem.id#')" style="cursor:pointer;"><span class="texto_normal"> Descargar adjunto</span></a></div>
</div>
	<cfif APPLICATION.moduleConvertFiles EQ "enabled">
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="objectFile">
			<cfinvokeargument name="file_id" value="#objectItem.attached_file_id#">
			<cfinvokeargument name="item_id" value="#item_id#">
			<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		</cfinvoke>
		<cfif objectFile.file_types_conversion.recordCount GT 0>
			<div class="div_element_menu" style="width:130px;">

				<cfset form_action = "#itemTypeName#_file_convert.cfm">
			
				<form name="convert_file" id="convert_file" method="get" action="#form_action#" onsubmit="showHideDiv('convert_file_loading');">
					<input type="hidden" name="file" value="#objectFile.id#" />
					
					<input type="hidden" name="#itemTypeName#" value="#objectItem.id#" />
					
					<div class="div_icon_menus"><input type="image" src="#APPLICATION.htmlPath#/assets/icons/view_file.gif" title="Visualizar el archivo"/></div>
					<div class="div_text_menus"><a href="##" onclick="showHideDiv('convert_file_loading');submitForm('convert_file');" class="text_menus">Ver adjunto en </a>
					<select name="file_type" style="width:90px;" onchange="showHideDiv('convert_file_loading');submitForm('convert_file');">
						<cfloop query="objectFile.file_types_conversion">
							<option value="#objectFile.file_types_conversion.file_type#">#objectFile.file_types_conversion.name_es#</option>
						</cfloop>
					</select>
					</div>
				</form>
			</div>
		</cfif> 
	</cfif>
</cfif>

<div class="div_element_menu">
	<div class="div_icon_menus"><a href="#itemTypeName#_copy.cfm?#itemTypeName#=#item_id#"><img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_copy.png" title="Copiar #itemTypeNameEs# a otras áreas" alt="Copiar #itemTypeNameEs# a otras áreas"/></a></div><div class="div_text_menus"><a href="#itemTypeName#_copy.cfm?#itemTypeName#=#item_id#"><span class="texto_normal">Copiar a<br/>otras áreas</span></a></div>
</div>


<div class="div_element_menu" style="width:130px;">

	<form name="copy_item_to" id="copy_item_to" method="get" action="">
		<input type="hidden" name="sourceItemTypeId" value="#itemTypeId#" />
		<input type="hidden" name="#itemTypeName#" value="#objectItem.id#" />
		
		<!---<input type="hidden" name="itemTypeId" value="#itemTypeId#" />--->
		
		<div class="div_icon_menus"><input type="image" src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_copy.png" title="Copiar a otras áreas como" onclick="submitCopyItemForm();"/></div>
		<div class="div_text_menus"><a href="##" onclick="submitCopyItemForm();"><span class="texto_normal">Copiar como</span></a>
		<select name="item_type" style="width:90px;" onchange="submitCopyItemForm();">
			<cfif itemTypeId IS NOT 1>
			<option value="message">Mensaje</option>
			</cfif>
			
			<cfif APPLICATION.moduleWeb EQ "enabled">
				<cfif itemTypeId IS NOT 2>
				<option value="entry">Entrada</option>
				</cfif>
				<cfif itemTypeId IS NOT 3>
				<option value="link">Enlace</option>
				</cfif>
				<cfif itemTypeId IS NOT 4>
				<option value="news">Noticia</option>
				</cfif>
			</cfif>
			
			<cfif itemTypeId IS NOT 5>
				<option value="event">Evento</option>
			</cfif>
			<cfif APPLICATION.identifier EQ "dp" AND itemTypeId IS NOT 6>
			<option value="task">Tarea</option>
			</cfif>
		</select>
		</div>
	</form>
	
</div>
		
<!---<cfelseif area_type EQ "web" OR area_type EQ "intranet">
	
	<div class="div_element_menu" style="width:130px;">

		<form name="copy_item_to" id="copy_item_to" method="get" action="">
			<input type="hidden" name="sourceItemTypeId" value="#itemTypeId#" />
			<input type="hidden" name="#itemTypeName#" value="#objectItem.id#" />
			
			<!---<input type="hidden" name="itemTypeId" value="#itemTypeId#" />--->
			
			<div class="div_icon_menus"><input type="image" src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_copy.png" title="Copiar a áreas" onclick="submitCopyItemForm();"/></div>
			<div class="div_text_menus"><a href="##" onclick="submitCopyItemForm();"><span class="texto_normal">Copiar como</span></a>
			<select name="item_type" style="width:90px;" onchange="submitCopyItemForm();">
				<option value="message">Mensaje</option>
				<cfif itemTypeId IS NOT 5>
				<option value="event">Evento</option>
				</cfif>
				<cfif APPLICATION.identifier EQ "dp">
				<option value="task">Tarea</option>
				</cfif>
			</select>
			</div>
		</form>
	</div>--->		
	

<cfif objectItem.user_in_charge EQ SESSION.user_id OR (itemTypeId IS 6 AND objectItem.recipient_user EQ SESSION.user_id)><!---Si es el propietario o es tarea y es el destinatario de la misma--->

	<cfif itemTypeId IS NOT 1><!---Si no es mensaje--->
	<div class="div_element_menu">
		<div class="div_icon_menus"><a href="#itemTypeName#_modify.cfm?#itemTypeName#=#item_id#"><img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_modify.png" title="Modificar #itemTypeNameEs#" alt="Modificar #itemTypeNameEs#"/></a></div><div class="div_text_menus"><a href="#itemTypeName#_modify.cfm?#itemTypeName#=#item_id#"><span class="texto_normal">Modificar</span></a></div>
	</div>
	</cfif>
	
</cfif>


<cfif APPLICATION.moduleWeb EQ "enabled" AND APPLICATION.moduleTwitter EQ "enabled" AND area_type EQ "web">
<div class="div_element_menu">
	<div class="div_icon_menus"><a href="#itemTypeName#_twitter.cfm?#itemTypeName#=#item_id#"><img src="#APPLICATION.htmlPath#/assets/icons/twitter_icon.png" title="Publicar #itemTypeNameEs# en Twitter" alt="Publicar #itemTypeNameEs# en Twitter"/></a></div><div class="div_text_menus"><a href="#itemTypeName#_twitter.cfm?#itemTypeName#=#item_id#"><span class="texto_normal">Publicar en<br/> Twitter</span></a></div>
</div>
</cfif>

<cfif objectItem.user_in_charge EQ SESSION.user_id>

<cfif isDefined("URL.return_page") AND len(URL.return_page) GT 0>
	<cfset url_return_page = "&return_page="&URLEncodedFormat("#return_path##URL.return_page#")>
<cfelse>
	<cfset url_return_page = "&return_page="&URLEncodedFormat("#return_path##itemTypeNameP#.cfm?area=#area_id#")>
</cfif>

<div class="div_element_menu">
	<div class="div_icon_menus"><a href="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=deleteItem&item_id=#item_id#&area_id=#area_id#&itemTypeId=#itemTypeId##url_return_page#" onclick="return confirmAction('eliminar');"><img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#_delete.png" title="Eliminar #itemTypeNameEs#" alt="Eliminar #itemTypeNameEs#"/></a></div>
	<div class="div_text_menus"><a href="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=deleteItem&item_id=#item_id#&area_id=#area_id#&itemTypeId=#itemTypeId##url_return_page#" onclick="return confirmAction('eliminar');"> <span class="texto_normal">Eliminar</span></a></div>
</div>

</cfif>

<div style="clear:both; height:3px;"><!-- --></div>
</div><!---END div_elements_menu--->
</cfoutput>
<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItem">
	<cfinvokeargument name="objectItem" value="#objectItem#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
</cfinvoke>


<div id="convert_file_loading" style="position:absolute; width:100%; height:94%; top:0px; background-color:#EEEEEE; text-align:center; padding-top:90px; display:none;">
<cfoutput>
<div class="div_alert_message">Generando archivo...</div>
<div style="margin:auto; text-align:center; padding-top:30px;">
<img src="#APPLICATION.path#/html/assets/icons/loading.gif" alt="Cargando" />
</div>
</cfoutput>
</div>