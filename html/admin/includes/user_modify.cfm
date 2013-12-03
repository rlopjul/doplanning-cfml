<cfoutput>
<script src="#APPLICATION.htmlPath#/language/user_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfif isDefined("URL.user") AND isNumeric(URL.user)>
	
	<cfset user_id = URL.user>

	<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

	<cfset return_page = "user.cfm?user=#user_id#">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
		<cfinvokeargument name="user_id" value="#user_id#"/>
		<cfinvokeargument name="format_content" value="all"/>
	</cfinvoke>

	<script type="text/javascript">

		function setLanguageBeforeSend(form) {
			
			return true;	
		}

	</script>

	<div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	    <h3 id="areaModalLabel">Modificar usuario</h3>
	</div>

 	<div class="modal-body">

 		<div>
		<cfinclude template="#APPLICATION.htmlPath#/includes/user_data_form.cfm"/>
		</div>

	</div>

	<!---<div class="modal-footer">
	    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancelar</button>
	    <button class="btn btn-primary" id="areaModifySubmit" onclick="submitAreaModal(event)">Guardar cambios</button>
	</div>--->

</cfif>