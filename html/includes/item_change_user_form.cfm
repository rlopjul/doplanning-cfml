<cfinclude template="#APPLICATION.htmlPath#/includes/item_change_user_query.cfm">

<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>

<div class="div_head_subtitle"><span lang="es">Cambiar propietario <cfif itemTypeGender EQ "male">del<cfelse>de la</cfif> #itemTypeNameEs#</span></div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<script type="text/javascript">

	function onSubmitForm() {

		if(check_custom_form())	{
			document.getElementById("submitDiv").innerHTML = window.lang.convert("Enviando...");

			return true;
		}
		else
			return false;
	}

	function openUserSelector(){

		return openPopUp('#APPLICATION.htmlPath#/iframes/area_users_select.cfm?area=#area_id#');
	}

	function setSelectedUser(userId, userName) {
		
		var curUserId = "#item.user_in_charge#";

		if(curUserId != userId) {
			document.getElementById("new_user_in_charge").value = userId;
			document.getElementById("new_user_full_name").value = userName;			
		} else {
			alert("Debe seleccionar un propietario distinto al actual");
		}
			
	}

</script>

<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js"></script>

<div class="contenedor_fondo_blanco">

<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" enctype="multipart/form-data" name="item_form" class="form-horizontal" onsubmit="return onSubmitForm();">
	
	<script type="text/javascript">
		var railo_custom_form=new RailoForms('item_form');
	</script>
	
	<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#" />
	<input type="hidden" name="item_id" value="#item_id#"/>
	<input type="hidden" name="itemTypeId" value="#itemTypeId#"/>
	<input type="hidden" name="area_id" value="#area_id#"/>

	<div class="row">
		<div class="col-sm-12">
			<span>#itemTypeNameEs#:</span>
			<strong>#item.title#</strong>
		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">
			<span>Propietario actual:</span>
			<strong>#item.user_full_name#</strong>
		</div>
	</div>
	
	<div class="row">
		<div class="col-xs-12 col-sm-6">
			<label class="control-label" for="new_user_full_name" lang="es">Nuevo propietario</label>
			<input type="hidden" name="new_user_in_charge" id="new_user_in_charge" value="#newUser.new_user_in_charge#" validate="integer" required="true"/>
			<cfinput type="text" name="new_user_full_name" id="new_user_full_name" value="#newUser.new_user_full_name#" readonly="true" required="true" message="Debe seleccionar un nuevo propietario" onclick="openUserSelector()" /> <button onclick="return openUserSelector()" type="button" class="btn btn-default" lang="es">Seleccionar usuario</button>
		</div>
	</div>
	
	<div style="height:10px;"><!--- ---></div>

	<div id="submitDiv">
		<input type="submit" class="btn btn-primary" name="modify" value="Cambiar propietario" lang="es"/>

		<a href="#itemTypeName#.cfm?#itemTypeName#=#item_id#&area=#area#" class="btn btn-default" style="float:right" lang="es">Cancelar</a>
	</div>

	<br/>
	<small class="help-block" lang="es">Se enviará notificación por email del cambio al nuevo propietario y al anterior.</small>
</cfform>

</div>

</cfoutput>