<cfif isDefined("URL.id") AND isNumeric(URL.id)><!---If an id is passed in the URL--->

	<cfset item_id = URL.id>

<cfelseif NOT isDefined("id")><!---If no id is passed--->

	<cflocation url="#APPLICATION.webUrl#" addtoken="no">
	
</cfif>

<!---getItem--->
<cfinvoke component="#APPLICATION.componentsPath#/components/AreaItemQuery" method="getItem" returnvariable="getItem">
	<cfinvokeargument name="item_id" value="#item_id#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	
	<cfinvokeargument name="client_abb" value="#clientAbb#">
	<cfinvokeargument name="client_dsn" value="#clientDsn#">
</cfinvoke>

<cfif getItem.recordCount IS 0>
	<cflocation url="#APPLICATION.webUrl#" addtoken="no">
<cfelse>
	<cfset area_id = getItem.area_id>
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">


<!---getAreaType--->
<!---Esta consulta devuelve el tipo, el nombre, y el área padre para ahorrarse otra consulta--->
<cfinvoke component="#APPLICATION.componentsPath#/components/AreaQuery" method="getAreaTypeWeb" returnvariable="getArea">
	<cfinvokeargument name="area_id" value="#area_id#">
	
	<cfinvokeargument name="client_abb" value="#clientAbb#">
	<cfinvokeargument name="client_dsn" value="#clientDsn#">
</cfinvoke>

<!---Esto impide que se obtenga elementos que no sean del tipo de área requerida--->
<cfif getArea.areaType NEQ areaTypeRequired>
	<cflocation url="#APPLICATION.webUrl#" addtoken="no">
</cfif>

<cfset area_dot = find(".-",getArea.name)>
<cfif area_dot GT 0>
	<cfset area_name = right(getArea.name, len(getArea.name)-(area_dot+1))>
<cfelse>
	<cfset area_name = getArea.name>
</cfif>

<cfset page_title = getItem.title>

<!---getAreaPath--->
<!---
Esto no se usa porque se construye la ruta con los valores ya cargados pare evitar consultas a la BD
<cfinvoke component="#APPLICATION.componentsPath#/components/AreaQuery" method="getAreaPath" returnvariable="area_path">
	<cfinvokeargument name="area_id" value="#selectAreaQuery.parent_id#">
	<cfinvokeargument name="from_area_id" value="#rootAreaId#">
	<cfinvokeargument name="separator" value=" / ">
	<cfinvokeargument name="with_base_link" value="apartado.cfm?id=">
	<cfinvokeargument name="client_abb" value="#clientAbb#">
	<cfinvokeargument name="client_dsn" value="#clientDsn#">
</cfinvoke>--->