<cfoutput>
<script src="#APPLICATION.htmlPath#/language/preferences_alerts_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>


<cfinclude template="alert_message.cfm">

<!---<div class="div_head_subtitle">
Preferencias de notificaciones
</div>--->

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUserPreferences" returnvariable="xmlResponse">
</cfinvoke>

<cfxml variable="xmlPreferences">
	<cfoutput>
	#xmlResponse.response.result.preferences#
	</cfoutput>
</cfxml>

<cfset notify_new_message = xmlPreferences.preferences.xmlAttributes.notify_new_message>
<cfset notify_new_file = xmlPreferences.preferences.xmlAttributes.notify_new_file>
<cfset notify_replace_file = xmlPreferences.preferences.xmlAttributes.notify_replace_file>
<cfset notify_new_area = xmlPreferences.preferences.xmlAttributes.notify_new_area>

<cfif APPLICATION.moduleWeb EQ "enabled">
	<cfif APPLICATION.identifier EQ "vpnet">
		<cfset notify_new_link = xmlPreferences.preferences.xmlAttributes.notify_new_link>
	</cfif>
	<cfset notify_new_entry = xmlPreferences.preferences.xmlAttributes.notify_new_entry>
	<cfset notify_new_news = xmlPreferences.preferences.xmlAttributes.notify_new_news>
</cfif>

<cfset notify_new_event = xmlPreferences.preferences.xmlAttributes.notify_new_event>
<cfset notify_new_task = xmlPreferences.preferences.xmlAttributes.notify_new_task>

<cfif APPLICATION.moduleConsultations IS true>
	<cfset notify_new_consultation = xmlPreferences.preferences.xmlAttributes.notify_new_consultation>
</cfif>


<p style="padding-left:15px;"><span lang="es">Enviar un email cuando:</span></p>

<cfoutput>
<form action="#APPLICATION.htmlComponentsPath#/User.cfc?method=updateUserPreferences" method="post" style="margin-left:15px;">
	
	<div class="control-group">
	<label class="checkbox">
	 	<input type="checkbox" name="notify_new_message" value="true" <cfif notify_new_message IS true>checked="checked"</cfif> />
		<img src="#APPLICATION.htmlPath#/assets/icons/message.png" alt="Nuevo mensaje" />
		<span lang="es">Un mensaje ha sido creado o eliminado</span>
	</label>
	</div>

<cfif APPLICATION.moduleWeb EQ "enabled"><!---Web--->

<cfif APPLICATION.identifier EQ "vpnet">
	
	<div class="control-group">
	<label class="checkbox">
		<input type="checkbox" name="notify_new_link" value="true" <cfif notify_new_link IS true>checked="checked"</cfif> />
		<img src="#APPLICATION.htmlPath#/assets/icons/link_new.png" alt="Nuevo enlace" />
		<span lang="es">Un enlace ha sido creado, modificado o eliminado</span>
	</label>
	</div>
	
</cfif>

	<div class="control-group">
	<label class="checkbox">
		<input type="checkbox" name="notify_new_entry" value="true" <cfif notify_new_entry IS true>checked="checked"</cfif> />
		<img src="#APPLICATION.htmlPath#/assets/icons/entry.png" alt="Nuevo elemento de contenido web" />
		<span lang="es">Un elemento de contenido web ha sido creado, modificado o eliminado</span>
	</label>
	</div>

	<div class="control-group">
	<label class="checkbox">
		<input type="checkbox" name="notify_new_news" value="true" <cfif notify_new_news IS true>checked="checked"</cfif> />
		<img src="#APPLICATION.htmlPath#/assets/icons/news.png" alt="Nueva noticia" />
		<span lang="es">Una noticia ha sido creada, modificada o eliminada</span>
	</label>
	</div>

</cfif>
	
	<div class="control-group">
	<label class="checkbox">
		<input type="checkbox" name="notify_new_event" value="true" <cfif notify_new_event IS true>checked="checked"</cfif> />
		<img src="#APPLICATION.htmlPath#/assets/icons/event.png" alt="Nuevo evento" />
		<span lang="es">Un evento ha sido creado, modificado o eliminado</span>
	</label>
	</div>

<cfif APPLICATION.identifier EQ "dp">
	
	<div class="control-group">
	<label class="checkbox">
		<input type="checkbox" name="notify_new_task" value="true" <cfif notify_new_task IS true>checked="checked"</cfif> />
		<img src="#APPLICATION.htmlPath#/assets/icons/task.png" alt="Nueva tarea" />
		<span lang="es">Una tarea ha sido creada, modificada o eliminada</span>
	</label>
	</div>
	
</cfif>

<cfif APPLICATION.moduleConsultations IS true>
	
	<div class="control-group">
	<label class="checkbox">
		<input type="checkbox" name="notify_new_consultation" value="true" <cfif notify_new_consultation IS true>checked="checked"</cfif> />
		<!---<img src="#APPLICATION.htmlPath#/assets/icons/consultation.png" alt="Nueva interconsulta" />--->
		<i class="icon-exchange" style="font-size:25px; color:##0088CC"></i> <span lang="es">Una interconsulta ha sido creada, respondida, cerrada o eliminada</span>
	</label>
	</div>
	
</cfif>


	<div class="control-group">
	<label class="checkbox">
		<input type="checkbox" name="notify_new_file" value="true" <cfif notify_new_file IS true>checked="checked"</cfif> />
		<img src="#APPLICATION.htmlPath#/assets/icons/file_new.png" alt="Archivo asociado" />
		<span lang="es">Un fichero ha sido asociado a un área</span>
	</label>
	</div>

	<div class="control-group">
	<label class="checkbox">
		<input type="checkbox" name="notify_replace_file" value="true" <cfif notify_replace_file IS true>checked="checked"</cfif> />
		<img src="#APPLICATION.htmlPath#/assets/icons/file_replace.png" alt="Archivo reemplazado" />
		<span lang="es">Un fichero asociado a un área ha sido reemplazado</span>
	</label>
	</div>
	
	<div class="control-group">
	<label class="checkbox">
		<input type="checkbox" name="notify_new_area" value="true" <cfif notify_new_area IS true>checked="checked"</cfif> />
		<img src="#APPLICATION.htmlPath#/assets/icons/area_new.png" alt="Crear area" />
		<span lang="es">Un área nueva ha sido creada</span>
	</label>
	</div>
	<input type="submit" class="btn btn-primary" name="modify" value="Guardar" lang="es"/>
</form>
</cfoutput>