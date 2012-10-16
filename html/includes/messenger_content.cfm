<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
</cfinvoke>
<cfoutput>
<script type="text/javascript">
	Messenger.setConnectedUser("#objectUser.id#","#objectUser.family_name# #objectUser.name#")
</script>
</cfoutput>
<div style="height:10px;"><!-- --></div>
<div class="msg_div_loading" id="loadingContainer">
Conectando...
</div>
<div style="clear:both;display:none;" id="messengerContainer">
	<div style="clear:both">
		<div style="float:left; width:64%">
			<cfinclude template="messenger_conversation.cfm">
		</div>
		<div style="float:right; width:34%">
			<cfinclude template="messenger_connected_users.cfm">
		</div>
	</div>
	<cfinclude template="messenger_controls.cfm">	
</div>