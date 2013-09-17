<!---Variables requeridas:
itemTypeId
return_path: define la ruta donde se encuentra esta página, para que al enviar el mensaje se vuelva a ella--->
<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_content_en.js" charset="utf-8" type="text/javascript"></script>

<script src="#APPLICATION.htmlPath#/ckeditor/ckeditor.js" type="text/javascript"></script>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
	<cfinvokeargument name="format_content" value="all">
</cfinvoke>

	
<cfif isDefined("URL.#itemTypeName#")>
	<cfset item_id = URL[#itemTypeName#]>
	
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getItem" returnvariable="objectItem">
		<cfinvokeargument name="item_id" value="#item_id#">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	</cfinvoke>
	
	<!---<cfxml variable="xmlItem">
		<cfoutput>
		#xmlResponse.response.result.xmlChildren[1]#
		</cfoutput>
	</cfxml>
	
	<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="objectItem" returnvariable="objectItem">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		<cfinvokeargument name="xml" value="#xmlItem#">
		<cfinvokeargument name="return_type" value="object">
	</cfinvoke>--->
	
	<cfset area_id = objectItem.area_id>
	
	<cfset return_page = "#itemTypeName#.cfm?#itemTypeName#=#item_id#">
	
<cfelse>
	<cflocation url="#APPLICATION.htmlPath#/" addtoken="no">
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">
<div class="div_head_subtitle">
<cfoutput>
<span lang="es"><cfif itemTypeGender EQ "male">Modificar<cfelse>Modificar</cfif> #itemTypeNameEs#</span>
</cfoutput>
</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfset page_type = 2>
<cfinclude template="#APPLICATION.htmlPath#/includes/area_item_form.cfm">