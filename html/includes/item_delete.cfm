<cfif isDefined("FORM.items_ids") AND isDefined("FORM.area_id")>

	<cfset items_ids = FORM.items_ids>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Item" method="deleteItems" returnvariable="resultDeleteItems">
		<cfinvokeargument name="items_ids" value="#items_ids#">
		<cfinvokeargument name="area_id" value="#FORM.area_id#">
	</cfinvoke>
	<cfset msg = resultDeleteItems.message>
	<cfset res = resultDeleteItems.result>

	<cfif res IS false>
		<cflocation url="#return_path#area_items.cfm?area=#FORM.area_id#&res=#res#&msg=#URLEncodedFormat(msg)#" addtoken="no">
	<cfelse><!--- Show warning message: we don't know if all items result are success --->
		<cflocation url="#return_path#area_items.cfm?area=#FORM.area_id#&res=-1&msg=#URLEncodedFormat(msg)#" addtoken="no">
	</cfif>

</cfif>

<cfif isDefined("URL.item")>
	<cfset items_ids = URL.item>
<cfelseif isDefined("URL.items")>
	<cfset items_ids = URL.items>
<cfelse>
	<cflocation url="index.cfm" addtoken="no">
</cfif>

<cfif isDefined("URL.area") AND isDefined("URL.itemTypeId")>

	<cfset area_id = URL.area>

	<cfset itemTypeId = URL.itemTypeId>
	<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

	<cfinclude template="#APPLICATION.htmlPath#/includes/area_id.cfm">
	<cfinclude template="#APPLICATION.htmlPath#/includes/area_checks.cfm">

	<cfinclude template="#APPLICATION.htmlPath#/includes/app_page_head.cfm">

<cfelse>

	<cflocation url="index.cfm" addtoken="no">

</cfif>

<div class="div_head_subtitle">
	<span lang="es">Eliminar</span>
</div>

<cfoutput>

<cfset itemsDeleteIds = items_ids>

<cfloop list="#items_ids#" index="item_id">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getItem" returnvariable="objectItem">
		<cfinvokeargument name="item_id" value="#item_id#">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="canUserDeleteItem" returnvariable="canUserDeleteItemResponse">
		<cfinvokeargument name="item_id" value="#item_id#">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		<cfinvokeargument name="itemQuery" value="#objectItem#">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>

	<cfif canUserDeleteItemResponse.result IS false>
		<cfset itemsDeleteIds = listDeleteAt(itemsDeleteIds, listFind(itemsDeleteIds, item_id))>
	</cfif>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItemSmall">
		<cfinvokeargument name="itemQuery" value="#objectItem#">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfif canUserDeleteItemResponse.result IS false>
			<cfinvokeargument name="alertMessage" value="#canUserDeleteItemResponse.message#">
			<cfinvokeargument name="alertClass" value="alert alert-warning">
		</cfif>
	</cfinvoke>

</cfloop>

<cfif isDefined("area_id")>
		<cfset return_page = "#return_path#items.cfm?area=#area_id#">
</cfif>

<cfif listLen(itemsDeleteIds) GT 0>

  <form name="delete_items" method="post" action="#CGI.SCRIPT_NAME#" class="form-horizontal" style="clear:both;">

  	<input type="hidden" name="items_ids" value="#itemsDeleteIds#">
		<input type="hidden" name="area_id" value="#area_id#">

    <cfif listLen(itemsDeleteIds) GT 1>
  		<input type="submit" class="btn btn-primary" lang="es" value="Eliminar archivos" />
    <cfelse>
      <input type="submit" class="btn btn-primary" lang="es" value="Eliminar archivo" />
    </cfif>

  	<a href="#return_page#" class="btn btn-default" style="float:right;" lang="es">Cancelar</a>

  </form>

<cfelse>

	<div class="alert alert-danger" role="alert" lang="es">No puede eliminar el archivo o archivos seleccionados.</div>

	<a href="#return_page#" class="btn btn-default" lang="es">Cancelar</a>

</cfif>

<div style="height:10px;"><!-- --></div>

</cfoutput>
