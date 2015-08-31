<cfoutput>
<!---
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8" type="text/javascript"></script>
 --->

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

</cfoutput>

<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">


<div class="container">

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">


<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAllTypologies" returnvariable="getAreaTablesResponse">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
	<cfif tableTypeId IS 3>
		<cfinvokeargument name="with_area" value="true">
	</cfif>
</cfinvoke>

<cfset typologies = getAreaTablesResponse.query>

<cfset numItems = typologies.recordCount>

<!---getRootAreaId--->
<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getRootAreaId" returnvariable="root_area_id">
</cfinvoke>

<cfif tableTypeId IS 4>

	<br/>
	<p lang="es" style="padding-left:10px;">Si sólo se crea una tipología de usuario, ésta será la que quede seleccionada por defecto para todos los usuarios y la que se asignará de forma automática a los nuevos usuarios que se den de alta en la aplicación.</p>

	<cfoutput>
		<div class="row">
			<div class="col-sm-12">
				<div class="btn-toolbar" role="toolbar" style="padding-bottom:10px;padding-left:10px;">

					<div class="btn-group">
						<a class="btn btn-default" href="#tableTypeName#_new.cfm?area=#root_area_id#"><img src="#APPLICATION.htmlPath#/assets/v3/icons/#tableTypeName#.png" alt="Nueva tipología de usuario" lang="es" style="height:20px"/> <span lang="es">Nueva tipología de usuario</span></a>
					</div>

				</div>
			</div>
		</div>
	</cfoutput>

<cfelseif tableTypeId IS 3>

	<br/>
	<p lang="es" style="padding-left:10px;">Las tipologías de archivos se gestionan en las áreas a las que pertenecen por los usuarios con permiso.</p>

</cfif>

<div class="row">

	<div class="col-sm-12">

		<div class="div_items">
		<cfif numItems GT 0>

			<!---<cfif isDefined("URL.mode") AND URL.mode EQ "list">--->

				<cfset app_version = "standard">

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="outputAllTypologiesList">
					<cfinvokeargument name="itemsQuery" value="#typologies#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="return_page" value="#lCase(itemTypeNameP)#.cfm">
					<cfinvokeargument name="app_version" value="#app_version#">
					<cfif tableTypeId IS 3>
						<cfinvokeargument name="openItemOnSelect" value="false"/>
					</cfif>
				</cfinvoke>

			<!---<cfelse>

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="outputTablesFullList">
					<cfinvokeargument name="itemsQuery" value="#areaTables#">
					<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
					<cfinvokeargument name="return_path" value="#APPLICATION.htmlPath#/">
					<cfinvokeargument name="area_id" value="#area_id#"/>
					<cfinvokeargument name="app_version" value="#app_version#">
				</cfinvoke>

			</cfif>--->

		<cfelse>
			<cfoutput>
				<!---<div class="div_text_result"><span lang="es">No hay #lCase(itemTypeNameEsP)# en esta área.</span></div>--->
				<div class="alert alert-info" role="alert" style="margin:10px;"><i class="icon-info-sign"></i> <span lang="es">No hay #lCase(itemTypeNameEsP)#.</span></div>
			</cfoutput>
		</cfif>
		</div>

	</div>

</div>
