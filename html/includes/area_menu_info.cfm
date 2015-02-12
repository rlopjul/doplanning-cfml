<cfoutput>
<div id="areaInfo" class="collapse more_info_content"><!---more_info_content--->
	<cfif area_type NEQ "">
		<cfif APPLICATION.identifier EQ "vpnet"><!---Por ahora, esto solo para Colabora--->
			<cfif area_type IS "web" OR area_type IS "intranet" AND (area_name NEQ "INTRANET" AND area_name NEQ "WEB PÚBLICA")><!---Las áreas raiz de web e intranet no tienen página, y se detectan porque parent_area_id no está definido (no es numérico)--->
				<div class="button_web" style="float:right; padding:4px;"><a href="#APPLICATION.path#/#area_type#/page.cfm?id=#area_id#" target="_blank" class="link_web" lang="es">&nbsp;Ver área en #area_type#&nbsp;</a></div>
			</cfif>
		</cfif>
	<div class="div_message_page_label">
	<span lang="es">Tipo de área:</span> <span class="text_message_page">#UCase(area_type)#</span>
	</div>
	</cfif>
	<cfif objectArea.read_only IS true>
		<div class="div_message_page_label">
			<i class="icon-lock"></i> <span lang="es">Área de sólo lectura</span>
		</div>
	</cfif>
	<div class="div_message_page_label">
	<span lang="es">Responsable:</span> <a onclick="openUrl('area_user.cfm?area=#area_id#&user=#objectArea.user_in_charge#','itemIframe',event)" style="cursor:pointer">#objectArea.user_full_name#</a>
	</div>
	<div class="div_message_page_label">
	<span lang="es">Fecha de creación:</span> <span class="text_message_page">#objectArea.creation_date#</span>
	</div>
	<div class="div_message_page_label">
	<span lang="es">Descripción:</span>
	</div>
	<div class="div_message_page_description"><cfif len(objectArea.description) GT 0>#objectArea.description#<cfelse><i><span lang="es">No hay descripción del área</span></i></cfif></div>

	<!---areaUrl--->
	<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaUrl" returnvariable="areaUrl">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
	</cfinvoke>
	<div class="div_message_page_label"><span lang="es">URL del área en #APPLICATION.title#:</span></div>
	<input type="text" value="#areaUrl#" onClick="this.select();" class="form-control" readonly="readonly" style="cursor:text"/>

	<cfif SESSION.client_abb EQ "hcs"><!---DoPlanning HCS--->
		
		<cfif area_type EQ "web" OR area_type EQ "intranet">
			<!---areaWebUrl--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaWebPage" returnvariable="areaPage">
				<cfinvokeargument name="area_id" value="#area_id#">
				<cfinvokeargument name="name" value="#objectArea.name#">
				<cfinvokeargument name="remove_order" value="true">
			</cfinvoke>
			<cfset areaWebUrl = "/#webPath#/#areaPage#">
			<div class="div_message_page_label"><span lang="es">URL relativa en la <b>#area_type#</b>:</span></div>
			<input type="text" value="#areaWebUrl#" onClick="this.select();" class="form-control" readonly="readonly" style="cursor:text"/>
		</cfif>

	</cfif>
</div>

<script>

	$('##areaInfo').on('hidden.bs.collapse', function () {
		$('##openAreaImg').show();
		$('##closeAreaImg').hide();

	});

	$('##areaInfo').on('shown.bs.collapse', function () {
		$('##openAreaImg').hide();
		$('##closeAreaImg').show();
	});			

</script>
</cfoutput>