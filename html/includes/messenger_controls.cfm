<form>
<div style="clear:both; padding-top:5px;">
	<div style="float:left; width:62%">
		<textarea style="width:100%;" rows="3" id="messageTextArea" name="messageTextArea" onkeypress="return Messenger.onTextAreaKeyPressed(event)" class="msg_message_text_area"></textarea>
	</div>
	<div style="float:right; width:36%; clear:none;">
		<div style="float:left"><input type="button" value="Enviar" id="sendButton" onclick="onSendButtonClicked(event)" class="msg_button" /></div>
		<div style="float:left; clear:left; margin-top:10px;">
		<div id="saveContainer"><input type="button" value="Guardar conversación" style="font-size:10px" onclick="onSaveButtonClicked(event)" class="msg_button" /></div><div id="loadingSaveContainer" style="display:none;"><input type="button" value="Guardando..." style="font-size:10px" disabled="disabled" class="msg_button" /></div></div>
	</div>
</div>
</form>
<div class="msg_div_error" id="errorMessage"></div>