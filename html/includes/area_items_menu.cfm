<cfoutput>
	<a href="#itemTypeName#_new.cfm?area=#area_id#" onclick="openUrl('#itemTypeName#_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-small btn-info"><i class="icon-plus icon-white"></i> <span lang="es"><cfif itemTypeGender EQ "male">Nuevo<cfelse>Nueva</cfif> #itemTypeNameEs#</span></a>
		
	<cfif itemTypeId IS 1 OR itemTypeId IS 7><!---Messages--->
		<a href="#lCase(itemTypeNameP)#.cfm?area=#area_id#&mode=tree" class="btn btn-small"><i class="icon-sitemap"></i> <span lang="es">Modo árbol</span></a>
	</cfif>
	
	<a href="#lCase(itemTypeNameP)#.cfm?area=#area_id#&mode=list" class="btn btn-small" title="Actualizar" lang="es"><i class="icon-refresh"></i> <span lang="es">Actualizar</span></a>
</cfoutput>
