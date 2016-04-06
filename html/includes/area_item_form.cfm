<!---Variables requeridas:
itemTypeId
return_path: define la ruta donde se encuentra esta página, para que al enviar el mensaje se vuelva a ella--->

<cfinclude template="#APPLICATION.htmlPath#/includes/area_item_form_query.cfm">

<cfoutput>
<!---
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8"></script>
 --->

<!---
<cfif (itemTypeId IS 1 OR itemTypeId IS 20) AND arrayLen(REMatch("Trident/7.*rv:11", CGI.HTTP_USER_AGENT)) IS 0 AND NOT (CGI.HTTP_USER_AGENT CONTAINS "MSIE")><!---Messages o DP Documents--->

	<!--- arrayLen(REMatch("Trident/7.*rv:11", CGI.HTTP_USER_AGENT)) IS TO CHECK INTERNET EXPLORER
	summernote fails in IE--->

	<cfset editorApp = "summernote">

	<cfinclude template="#APPLICATION.htmlPath#/includes/summernote_scripts.cfm">

<cfelse>--->

	<cfset editorApp = "ckeditor">

	<script src="#APPLICATION.htmlPath#/ckeditor/ckeditor.js?v=4.4.4.4"></script>

<!---</cfif>--->

<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
<script src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>
<script src="#APPLICATION.path#/jquery/jquery-mask/jquery.mask.min.js"></script>

</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<!---
<div class="div_head_subtitle">
	<cfoutput>
	<cfif page_type IS 1>
		<cfif itemTypeId IS NOT 7 OR parent_kind EQ "area">
			<span lang="es"><cfif itemTypeGender EQ "male">Nuevo<cfelse>Nueva</cfif> #itemTypeNameEs#</span>
		<cfelse>
			<span lang="es">Respuesta a #itemTypeNameEs#</span>
		</cfif>
	<cfelse>
		<span lang="es">Modificar #itemTypeNameEs#</span>
	</cfif>
	</cfoutput>
</div>
--->

<!---<div class="contenedor_fondo_blanco">--->

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfif page_type IS 1 OR objectItem.user_in_charge EQ SESSION.user_id><!--- User item --->
	<cfset read_only = false>
<cfelseif itemTypeId IS 17 AND is_user_area_responsible IS true><!---Mailing--->
	<cfset read_only = false>
<cfelseif itemTypeId IS 20><!--- DoPlanning Document --->
	<cfset read_only = false>
<cfelseif itemTypeId IS NOT 1 AND (area_type EQ "web" OR area_type EQ "intranet")><!--- Web item --->
	<cfset read_only = false>
<cfelse>
	<cfif itemTypeId IS 6 AND objectItem.recipient_user EQ SESSION.user_id><!---Los destinatarios de tareas pueden acceder a modificar algunos de sus valores--->
		<cfset read_only = true>
	<cfelse>
		<cflocation url="#return_page#" addtoken="no">
	</cfif>
</cfif>

<cfif objectArea.read_only IS true OR ( page_type IS NOT 1 AND objectArea["item_type_#itemTypeId#_enabled"] IS false )><!---Está deshabilitada la creación de nuevos mensajes en esta área--->

	<cfset msg = UrlEncodedFormat("Edición del elemento deshabilitada en el área")>
	<cflocation url="#return_page#&res=0&msg=#msg#" addtoken="no">

</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_item_form_js.cfm">

<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" enctype="multipart/form-data" name="item_form" id="itemForm" class="form-horizontal item_form"  onsubmit="return onSubmitForm();"><!--- class="form-horizontal" class="form-inline" --->
	<cfinput type="hidden" name="itemTypeId" value="#itemTypeId#">
	<cfinput type="hidden" name="area_id" value="#area_id#">
	<cfinput type="hidden" name="return_path" value="#return_path#">
	<cfif page_type IS 1><!---NEW ITEM--->
		<cfinput type="hidden" name="parent_id" value="#parent_id#">
		<cfinput type="hidden" name="parent_kind" value="#parent_kind#">
	<cfelse>
		<cfinput type="hidden" name="item_id" value="#item_id#">
		<cfinput type="hidden" name="user_in_charge" value="#objectItem.user_in_charge#">
	</cfif>

	<cfif itemTypeId IS 1>
		<cfset sendValue = "Enviar">
	<cfelse>
		<cfset sendValue = "Guardar">
	</cfif>

	<cfoutput>

	<div id="submitDiv1" style="margin-bottom:5px;"><input type="submit" name="submit1" value="#sendValue#" class="btn btn-primary" lang="es"/>
		<cfif page_type IS 2 OR isDefined("URL.message")>
			<a href="#return_page#" class="btn btn-default" style="float:right;" lang="es">Cancelar</a>
		</cfif>
	</div>


	<cfif itemTypeId IS 1 AND objectArea.users_visible IS true>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getAllAreaUsers" returnvariable="areaUsersResponse">
			<cfinvokeargument name="area_id" value="#area_id#">
		</cfinvoke>

		<cfset areaUsers = areaUsersResponse.users>

		<div class="row">
			<div class="col-sm-12">
				<div class="well well-sm" style="margin-bottom:15px;">
		  			<ul class="list-inline" style="margin-bottom:0px;">
					<cfloop index="objectUser" array="#areaUsers#">
						<li>
						<cfif len(objectUser.image_type) GT 0>
							<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectUser.id#&type=#objectUser.image_type#&small=" alt="#objectUser.family_name# #objectUser.name#" style="max-width:22px;max-height:22px;" />
						<cfelse>
							<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#objectUser.user_full_name#" style="width:22px;" />
						</cfif>
						&nbsp;<small style="font-size:11px;">#objectUser.family_name# #objectUser.name#</small>
						</li>
					</cfloop>
					</ul>
				</div>
			</div>
		</div>

	</cfif>

	<cfif itemTypeId IS 20 AND page_type IS NOT 1><!--- Modify DoPlanning document --->

		<cfif objectItem.locked IS false>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="changeAreaItemLock" returnvariable="lockResponse">
				<cfinvokeargument name="item_id" value="#item_id#"/>
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#"/>
				<cfinvokeargument name="lock" value="true"/>
			</cfinvoke>

			<cfif lockResponse.result IS true>
				<cfif objectItem.area_editable IS true>
					<div class="alert alert-info">
						<span lang="es">Se ha bloqueado el archivo para poder editarlo.</span>
					</div>
				</cfif>

			<cfelse>
				<cflocation url="area_items.cfm?area=#area_id#&#itemTypeName#=#item_id#&res=#lockResponse.result#&msg=#msg#">
			</cfif>

		</cfif>

		<input type="hidden" name="locked" value="true"/>

	</cfif>

	<cfinclude template="#APPLICATION.htmlPath#/includes/area_item_inputs.cfm">

	<cfif APPLICATION.moduleTwitter IS true AND area_type IS "web">
	<div class="row">
		<div class="col-sm-12">
			<label class="checkbox">
				<img src="#APPLICATION.htmlPath#/assets/v3/icons/twitter_icon.png" alt="Twitter"/> <cfinput type="checkbox" name="post_to_twitter" value="true" title="Enviar #itemTypeNameEs# a Twitter"> Publicar #itemTypeNameEs# en Twitter
			</label>
		</div>
	</div>
	</cfif>

	<div style="clear:both; height:10px;"><!-- --></div>

    <div id="submitDiv2"><input type="submit" name="submit2" value="#sendValue#" class="btn btn-primary" lang="es"/>
		<cfif page_type IS 2 OR isDefined("URL.message")>
			<a href="#return_page#" class="btn btn-default" style="float:right;" lang="es">Cancelar</a>
		</cfif>
	</div>

	<div style="height:10px;"><!--- ---></div>
	<small lang="es">* Campos obligatorios.</small>

	</cfoutput>
</cfform>


<cfif page_type IS 1 AND isDefined("URL.#itemTypeName#")>

	<cfif NOT isDefined("getItemObject")>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getItem" returnvariable="getItemObject">
			<cfinvokeargument name="item_id" value="#URL[#itemTypeName#]#">
			<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		</cfinvoke>

	</cfif>

	<div>
		<hr>
		<h3 lang="es">Respondiendo a:</h3>
		<cfoutput>
			<h5 lang="es">#getItemObject.title#</h5>
		</cfoutput>
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItem">
			<cfinvokeargument name="objectItem" value="#getItemObject#">
			<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
			<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
			<cfinvokeargument name="area_type" value="#area_type#">
			<cfif isDefined("webPath")>
				<cfinvokeargument name="webPath" value="#webPath#">
			</cfif>
		</cfinvoke>

	</div>

</cfif>

<!---</div>--->
