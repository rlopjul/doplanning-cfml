<cfoutput>

<script>

var editor;

var preventClose = false;
var sendForm = false;
	
$(window).on('beforeunload', function(event){

	<!---ESTO DABA PROBLEMAS EN CHROME (cuando se envía un formulario aparece la ventana de abandonar página)--->
	<!--- editor.updateElement(); //Update CKEditor state to update preventClose value: esto no funciona porque parece que el evento que cambia la variable preventClose se llama después de la comprobación siguiente de esta variable --->
	
	<cfif itemTypeId NEQ 1 AND itemTypeId NEQ 20>

		if( editor.checkDirty() )
			preventClose = true;

	</cfif>

	if( sendForm != true && preventClose )  <!--- Si el editor está modificado y no se va a enviar el formulario--->
	{
		showLoadingPage(false);

		var alertMessage = window.lang.translate('Tiene texto sin enviar, si abandona esta página lo perderá');
		
		return alertMessage;
	
	}

});


$(document).ready(function() {
  
  	$('input').change(function() {
		preventClose = true;
	});
	
	/*$('textarea').change(function() {
		preventClose = true;
	});*/	


	<cfif itemTypeId NEQ 1 AND itemTypeId NEQ 20>

		// The instanceReady event is fired, when an instance of CKEditor has finished
		// its initialization.
		
		CKEDITOR.on('instanceReady', function( ev )	{
			editor = ev.editor;
		
			<cfif read_only IS true>
			editor.setReadOnly(true);
			</cfif>
			
			editor.on('saveSnapshot', function(e) { 
				preventClose = true;
			});
			
			editor.on('blur', function(e) {
				if (e.editor.checkDirty()) { //CKEDITOR cambiado
					preventClose = true;
					//alert("CKEDITOR modificado");
				}
			});		
		});

	</cfif>
  
});


function onSubmitForm()
{
	if(check_custom_form())
	{
		var submitForm = true;
		
		<cfif itemTypeId IS 5>
		if(!checkDates("start_date", "end_date")) {
			submitForm = false;
			alert(window.lang.translate("Fechas incorrectas. Compruebe que la fecha de fin del evento es igual o posterior a la fecha de inicio y tiene el formato adecuado."));
		}
		</cfif>
		
		if(submitForm){

			<cfif itemTypeId IS 1>
				
				$('textarea[name="description"]').html($('##summernote').code());

			</cfif>

			document.getElementById("submitDiv1").innerHTML = window.lang.translate('Enviando...');
			document.getElementById("submitDiv2").innerHTML = window.lang.translate('Enviando...');

			preventClose = false;
			sendForm = true;
		}
		
		return submitForm;
	}
	else
		return false;
}
</script>
</cfoutput>