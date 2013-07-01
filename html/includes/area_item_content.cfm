<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<script type="text/javascript">
	<!---Esto es para evitar que se abran enlaces en el iframe--->
	$(document).ready( function(){
		$('.dropdown-toggle').dropdown();
		$(".div_message_page_description a").attr('target','_blank');
	}); 
	
	<!---function submitCopyItemForm(){
	
		var url = "_copy.cfm";
		
		var form=document.getElementById("copy_item_to");
		
		var itemTypeName = form.elements["item_type"].value;
		
		url = itemTypeName+url;
		
		form.action = url;
				
		form.submit();
	
	}--->

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

<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="objectItem" returnvariable="objectItem">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	<cfinvokeargument name="xml" value="#xmlItem#">
	<cfinvokeargument name="return_type" value="object">
</cfinvoke>

<cfset area_id = objectItem.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfif app_version NEQ "html2">
	<div class="div_head_subtitle">
	<cfoutput>
	<span lang="es">#itemTypeNameEs#</span>
	</cfoutput>
	</div>
</cfif>

<cfoutput>

<div class="div_message_page_title">#objectItem.title#</div>
<div class="div_separator"><!-- --></div>

<div class="div_elements_menu"><!---div_elements_menu--->

	<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->

		<cfif itemTypeId IS 1 OR itemTypeId IS 7><!---Solo para mensajes y consultas--->
			<cfif itemTypeId IS 1 OR objectItem.state NEQ "closed">
				<a href="#itemTypeName#_new.cfm?#itemTypeName#=#objectItem.id#" class="btn btn-small btn-info"><i class="icon-reply"></i> <span lang="es">Responder</span></a>
			</cfif>
		<cfelse><!---Si no es mensaje--->
			
			<!---En las áreas web o intranet se pueden modificar los elementos--->
			<cfif area_type EQ "web" OR area_type EQ "intranet" OR objectItem.user_in_charge EQ SESSION.user_id OR (itemTypeId IS 6 AND objectItem.recipient_user EQ SESSION.user_id)><!---Si es el propietario o es tarea y es el destinatario de la misma--->
							
				<a href="#itemTypeName#_modify.cfm?#itemTypeName#=#item_id#" class="btn btn-small btn-info"><i class="icon-edit icon-white"></i> <span lang="es">Modificar</span></a>
								
			</cfif>
			
		</cfif>		
		
		<cfif isDefined("URL.return_page") AND len(URL.return_page) GT 0>
			<cfset url_return_page = "&return_page="&URLEncodedFormat("#return_path##URL.return_page#")>
		<cfelse>
			<cfset url_return_page = "&return_page="&URLEncodedFormat("#return_path##itemTypeNameP#.cfm?area=#area_id#")>
		</cfif>
		
			
		<cfif itemTypeId IS 7><!---Consultations--->
				
			<cfif objectItem.state NEQ "closed">
			
				<cfif objectItem.parent_kind EQ "area">
				
					<cfset close_item_id = item_id>
					<cfset close_user_in_charge = objectItem.user_in_charge>
					
				<cfelse>
				
					<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="getItemRoot" returnvariable="getItemRootResult">
						<cfinvokeargument name="item_id" value="#objectItem.parent_id#">
						<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
					</cfinvoke>	
					
					<cfset close_item_id = getItemRootResult.id>
					<cfset close_user_in_charge = getItemRootResult.user_in_charge>
					
				</cfif>
				
				<cfif close_user_in_charge EQ SESSION.user_id>
				
					<a href="area_item_close.cfm?item=#close_item_id#&type=#itemTypeId#&area=#area_id##url_return_page#" onclick="return confirmAction('cerrar la #itemTypeNameEs#');" title="Cerrar #itemTypeNameEs#" class="btn btn-warning btn-small" lang="es"><i class="icon-lock"></i> <span lang="es">Cerrar</span></a>
				
				</cfif>
				
			</cfif>
				
		</cfif>
		
		
		<cfif itemTypeId IS 6><!---Tasks--->
		
			<cfif objectItem.done IS 0>
			
				<cfif objectItem.user_in_charge EQ SESSION.user_id OR objectItem.recipient_user EQ SESSION.user_id>
				
					<a href="area_item_done.cfm?item=#objectItem.id#&type=#itemTypeId#&area=#area_id#&done=1#url_return_page#" <!---onclick="return confirmAction('marcar la #itemTypeNameEs# como realizada');"---> title="Marcar la #itemTypeNameEs# como realizada" class="btn btn-info btn-small" lang="es"><i class="icon-ok"></i> <span lang="es">Realizada</span></a>
				
				</cfif>
				
			</cfif>
		
		</cfif>

			
		<cfif objectItem.user_in_charge EQ SESSION.user_id>
		
			<cfif itemTypeId IS NOT 7 OR objectItem.state EQ "created"><!---Is not consultation or is not created--->
				<a href="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=deleteItem&item_id=#item_id#&area_id=#area_id#&itemTypeId=#itemTypeId##url_return_page#" onclick="return confirmAction('eliminar');" title="Eliminar #itemTypeNameEs#" class="btn btn-danger btn-small"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a>
		
			</cfif>
		
		</cfif>
		
		<cfif app_version NEQ "mobile">
		<a href="#APPLICATION.htmlPath#/#itemTypeName#.cfm?#itemTypeName#=#item_id#" title="Abrir en nueva ventana" target="_blank" class="btn btn-small"><i class="icon-external-link"></i> <span lang="es">Ampliar</span></a>
		</cfif>
		
		<cfif len(objectItem.attached_file_name) GT 0 AND objectItem.attached_file_name NEQ "-">
			<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#objectItem.attached_file_id#&#itemTypeName#=#objectItem.id#" onclick="return downloadFileLinked(this,event)" class="btn btn-small"><i class="icon-download-alt"></i> <span lang="es">Adjunto</span></a>
			<cfif APPLICATION.moduleConvertFiles EQ true>
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
							<div class="div_text_menus"><a href="##" onclick="showHideDiv('convert_file_loading');submitForm('convert_file');" class="text_menus" lang="es">Ver adjunto en </a>
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
		
		<!---<a href="#itemTypeName#_copy.cfm?#itemTypeName#=#item_id#" title="Copiar #itemTypeNameEs# a otras áreas" class="btn btn-small"><i class="icon-copy"></i> Copiar</a>--->

		<!---<br/>
		<form name="copy_item_to" id="copy_item_to" method="get" action="" style="display:inline; padding:0; margin:0;">
			<input type="hidden" name="sourceItemTypeId" value="#itemTypeId#"/>
			<input type="hidden" name="#itemTypeName#" value="#objectItem.id#"/>
				
			<button type="submit" class="btn btn-small" style="margin-right:0;" onclick="submitCopyItemForm();">
            	<i class="icon-copy"></i> Copiar como
            </button>		
			<select name="item_type" style="width:100px; margin:0;" onchange="submitCopyItemForm();">
				<cfif itemTypeId IS NOT 1>
				<option value="message">Mensaje</option>
				</cfif>
				
				<cfif APPLICATION.moduleWeb EQ true>
					<cfif itemTypeId IS NOT 2>
					<option value="entry">Contenido web</option>
					</cfif>
					<cfif itemTypeId IS NOT 3 AND APPLICATION.identifier EQ "vpnet">
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
		</form>--->
		
		<cfset copy_query_string = "sourceItemTypeId=#itemTypeId#&#itemTypeName#=#objectItem.id#">
		<div class="btn-group">
			<a href="##" class="btn btn-small dropdown-toggle" data-toggle="dropdown" title="Copiar a otras áreas"> 
			<i class="icon-copy"></i> <span lang="es">Copiar como</span> <span class="caret"></span></a>
			<ul class="dropdown-menu">
				<!---<cfif itemTypeId IS NOT 1>--->
				<li><a href="message_copy.cfm?#copy_query_string#" lang="es">Mensaje</a></li>
				<!---</cfif>--->
				
				<cfif APPLICATION.moduleWeb EQ true>
					<!---<cfif itemTypeId IS NOT 2>--->
					<li><a href="entry_copy.cfm?#copy_query_string#" lang="es">Elemento de contenido web</a></li>
					<!---</cfif>--->
					<cfif APPLICATION.identifier EQ "vpnet"><!---itemTypeId IS NOT 3 AND --->
					<li><a href="link_copy.cfm?#copy_query_string#" lang="es">Enlace</a></li>
					</cfif>
					<!---<cfif itemTypeId IS NOT 4>--->
					<li><a href="news_copy.cfm?#copy_query_string#" lang="es">Noticia</a></li>
					<!---</cfif>--->
				</cfif>
				
				<!---<cfif itemTypeId IS NOT 5>--->
					<li><a href="event_copy.cfm?#copy_query_string#" lang="es">Evento</a></li>
				<!---</cfif>--->
				<cfif APPLICATION.identifier EQ "dp"><!---AND itemTypeId IS NOT 6--->
				<li><a href="task_copy.cfm?#copy_query_string#" lang="es">Tarea</a></li>
				</cfif>
				<cfif APPLICATION.moduleConsultations IS true>
				<li><a href="consultation_copy.cfm?#copy_query_string#" lang="es">Interconsulta</a></li>
				</cfif>
			</ul>
		</div>
		
		
		<cfif APPLICATION.moduleWeb EQ true AND APPLICATION.moduleTwitter IS true AND area_type EQ "web">
		<a href="#itemTypeName#_twitter.cfm?#itemTypeName#=#item_id#" class="btn btn-small"><i class="icon-twitter"></i> Publicar en Twitter</a>
		
		</cfif>
		
				
	<cfelse><!---VPNET--->

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_items_menu_vpnet.cfm">
	
	</cfif>
		
	
</div><!---END div_elements_menu--->
</cfoutput>
<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItem">
	<cfinvokeargument name="objectItem" value="#objectItem#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
</cfinvoke>


<div id="convert_file_loading" style="position:absolute; width:100%; height:94%; top:0px; background-color:#EEEEEE; text-align:center; padding-top:90px; display:none;">
<cfoutput>
<div class="alert">Generando archivo...</div>
<div style="margin:auto; text-align:center; padding-top:30px;">
<img src="#APPLICATION.path#/html/assets/icons/loading.gif" alt="Cargando" />
</div>
</cfoutput>
</div>