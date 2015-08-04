<cfif APPLICATION.moduleWebRTC IS true AND isDefined("URL.user") AND isNumeric(URL.user)>
	<cfset user_id = URL.user>
<cfelse>
	<cflocation url="#APPLICATION.htmlPath#" addtoken="no">
</cfif>


<cfoutput>
<script src="#APPLICATION.htmlPath#/language/user_meeting_onpentok_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<!---Usuario con el que se va a reunir--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="meetingUser">
	<cfinvokeargument name="user_id" value="#user_id#">
</cfinvoke>

<!---Usuario logeado--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="loggedUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
	<cfinvokeargument name="format_content" value="all">
</cfinvoke>

<!---Obtiene sesión--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Meeting" method="getUserMeetingSession" returnvariable="session_id">
	<cfinvokeargument name="user_a_id" value="#loggedUser.id#">
	<cfinvokeargument name="user_b_id" value="#meetingUser.id#">
</cfinvoke>

<!---Obtiene token--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Meeting" method="getSessionToken" returnvariable="token_id">
	<cfinvokeargument name="session_id" value="#session_id#">
</cfinvoke>

<cfset meeting_user_name = "#meetingUser.family_name# #meetingUser.name#">
<cfset logged_user_name = "#loggedUser.family_name# #loggedUser.name#">

<style type="text/css">
<!--
	.OT_mute {
	   display: none !important;
	}

	#publisherStreamContainer {
		width:220px;
		height:165px;
	}
-->
</style>

<div class="div_head_subtitle"><span lang="es">Reunión virtual</span></div>

<cfif meetingUser.id IS loggedUser.id>
	<div class="alert alert-block" style="margin-top:10px;">
		<button type="button" class="close" data-dismiss="alert">&times;</button>
	  	<span lang="es">¡Ha iniciado una reunión consigo mismo!</span>
	</div>
</cfif>

<cfoutput>

<div style="float:left">
	<div>
		<div id="subscriberConnectionWaitingAlert" class="alert alert-block" style="margin-top:10px;">
			<img src="#APPLICATION.htmlPath#/assets/v3/icons/loading.gif" alt="Loading" title="Loading" style="text-align:center; margin-right:8px; margin-bottom:8px;" /><strong lang="es">Esperando conexión del usuario solicitado...</strong><br/>
			<span lang="es">El usuario debe acceder a la siguiente dirección para entrar en esta reunión:</span><br/>
			<i>#APPLICATION.mainUrl##APPLICATION.htmlPath#/meeting/?user=#loggedUser.id#&abb=#SESSION.client_abb#</i>
		</div>
		<div id="subscriberStreamWaitingAlert" class="alert alert-block" style="margin-top:10px;display:none;">
			<span lang="es">El usuario está conectado a la reunión pero no está retransmitiendo su cámara ni su audio.</span><br/>
		</div>
	</div>
	<!---<div id="subscriberStream"></div>--->
	<div id="streamsContainer"></div>
	
	<div style="margin-top:5px; clear:both;">
		<cfif len(meetingUser.image_type) GT 0>
			<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#meetingUser.id#&type=#meetingUser.image_type#&small=" alt="#meeting_user_name#" class="item_img" style="margin-right:2px;"/>									
		<cfelse>							
			<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#meeting_user_name#" class="item_img_default" style="margin-right:2px;"/>
		</cfif>
		<span>#meeting_user_name#</span>
	</div>
	
	<div class="div_user_page_user">
		<div class="div_user_page_label"><span lang="es">Email:</span> <a href="mailto:#meetingUser.email#" class="div_user_page_text">#meetingUser.email#</a></div>
		<div class="div_user_page_label"><span lang="es">Teléfono:</span> <span class="div_user_page_text"><cfif len(meetingUser.telephone) GT 0>#meetingUser.telephone_ccode#</cfif> #meetingUser.telephone#</span></div>
		<div class="div_user_page_label"><span lang="es">Teléfono móvil:</span> <span class="div_user_page_text"><cfif len(meetingUser.mobile_phone) GT 0>#meetingUser.mobile_phone_ccode#</cfif> #meetingUser.mobile_phone#</span></div>
		
	</div>
</div>

<div style="float:right; text-align:right">
	<div id="publisherStreamContainer" style="float:right">
		<div id="publisherStream">
		</div>
	</div>
	<div style="margin-bottom:5px; padding-top:5px; clear:both;">
		<cfif len(loggedUser.image_type) GT 0>
			<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#loggedUser.id#&type=#loggedUser.image_type#&small=" alt="#logged_user_name#" class="item_img" style="margin-right:2px;"/>									
		<cfelse>							
			<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#logged_user_name#" class="item_img_default" style="margin-right:2px;"/>
		</cfif>
		<span>#logged_user_name#</span>
	</div>
	
	<div>
		<button onClick="unpublish()" id="unpublishButton" class="btn btn-default btn-sm" lang="es"><i class="icon-stop"></i> Detener retransmisión</button>
		<button onClick="publish()" id="publishButton" class="btn btn-sm btn-primary" style="display:none"  lang="es"><i class="icon-play"></i> Iniciar retransmisión</button>
		<button onClick="stopPublishVideo()" id="stopVideoButton" class="btn btn-default btn-sm" title="Detener webcam" lang="es"><img src="#APPLICATION.htmlPath#/assets/icons_dp/webcam_stop.png" alt="Detener webcam" lang="es" width="20"/></button>
		<button onClick="startPublishVideo()" id="startVideoButton" style="display:none" class="btn btn-default btn-sm" title="Retransmitir webcam" lang="es"><img src="#APPLICATION.htmlPath#/assets/icons_dp/webcam_start.png" alt="Retransmitir webcam" lang="es" width="20"/></button>
		
		<button onClick="stopPublishAudio()" id="stopAudioButton" class="btn btn-default btn-sm" title="Desactivar micrófono" lang="es"><i class="icon-microphone-off icon-large"></i></button>
		<button onClick="startPublishAudio()" id="startAudioButton" class="btn btn-default btn-sm" style="display:none" title="Activar micrófono" lang="es"><i class="icon-microphone icon-large"></i></button>
		<div id="publisherNoStreamAlert" class="alert alert-block" style="margin-top:8px; display:none;">
			<span lang="es">No está retransmitiendo su webcam, sólo está retransmitiento su audio.</span><br/>
			<span lang="es">Para retransmitir su webcam, haga clic en el botón Retransmitir webcam.</span>
		</div>
	</div>
</div>


<script src="https://swww.tokbox.com/webrtc/v2.0/js/TB.min.js"></script>
<cfoutput>
<script src="#APPLICATION.htmlPath#/scripts/openTokUserMeeting.js"></script>
<script type="text/javascript" charset="utf-8">

	var openTokApiKey = #APPLICATION.openTokApiKey#; 

	var openTokSessionId = "#session_id#";
	var openTokToken = "#token_id#";
	var openTokPublisherName = "#logged_user_name#";
	
	initOpenTokUserMeeting(openTokApiKey, openTokSessionId, openTokToken, openTokPublisherName);
	
</script>
</cfoutput>

</cfoutput>