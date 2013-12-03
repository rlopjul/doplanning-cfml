<cfoutput>

	<cfif is_user_area_responsible OR (itemTypeId IS NOT 11 AND itemTypeId IS NOT 12 AND itemTypeId IS NOT 13)>
		
	<a href="#itemTypeName#_new.cfm?area=#area_id#" onclick="openUrl('#itemTypeName#_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm" title="<cfif itemTypeGender EQ 'male'>Nuevo<cfelse>Nueva</cfif> #itemTypeNameEs#" lang="es"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> 
		<cfif itemTypeId IS 7><!--- Consultation --->
			<i class="icon-exchange" style="font-size:18px; color:##0088CC"></i>
		<!---
		<cfelseif itemTypeId IS 8><!---PubMed article--->
			<i class="icon-book" style="font-size:19px; color:##7A7A7A"></i>
		<cfelseif itemTypeId IS 9><!---Images--->
			<i class="icon-picture" style="font-size:18px; color:##0088CC"></i>
		<cfelseif itemTypeId IS 11><!--- Lists --->
			<i class="icon-table" style="font-size:18px; color:##7A7A7A"></i>
		<cfelseif itemTypeId IS 12><!--- Forms --->
			<i class="icon-columns" style="font-size:18px; color:##7A7A7A"></i>--->
		<cfelseif itemTypeId IS 13><!---Typologies--->
			<i class="icon-file-text" style="font-size:19px; color:##7A7A7A"></i>
		<cfelse>
			<img src="#APPLICATION.htmlPath#/assets/icons/#itemTypeName#.png" style="height:22px;"/>
		</cfif>
	</a>
		
	<span class="divider">&nbsp;</span>

	</cfif>

	<cfif itemTypeId IS 1 OR itemTypeId IS 7><!---Messages OR consultations--->
		<a href="#lCase(itemTypeNameP)#.cfm?area=#area_id#&mode=tree" class="btn btn-default btn-sm"><i class="icon-sitemap" style="font-size:14px; line-height:23px;"></i> <span lang="es">Modo árbol</span></a>
	</cfif>

	<cfif app_version NEQ "mobile">
	<a href="#APPLICATION.htmlPath#/#lCase(itemTypeNameP)#.cfm?area=#area_id#" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
	</cfif>

	<a href="#lCase(itemTypeNameP)#.cfm?area=#area_id#&mode=list" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>
</cfoutput>
