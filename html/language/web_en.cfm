<cfsilent>
<cfscript>
curLangTextEn = structNew();
curLangTextEn = {
  "token": {
    /*common*/
		"Salir":"Logout",
		"Volver":"Return",
		"Guardar":"Save",
		"Enviar":"Send",
		"Cancelar":"Cancel",
		"Sí":"Yes",
		"No":"No",
		"Aceptar":"Accept",
		/*END common*/


		/*login*/
		"Entrar":"Enter",
		"Acceder a la aplicación":"Access the application",
		"Resetear contraseña":"Reset password",
		"¿Olvidó su contraseña?":"Forgot your password?",
		"Acceso a DoPlanning":"Access of DoPlanning",
		"Ayuda DoPlanning":"DoPlanning Help",
		"Identificar con usuario y contraseña de:":"Identify with user and password of:",
		"Usuario o contraseña incorrecta.":"Incorrect user or password",
		"Para una mejor experiencia con DoPlanning recomendamos el uso de un navegador moderno distinto a Internet Explorer":"For the best experience with DoPlanning we recommend using a different browser than Internet Explorer",
		/*END login*/

		/*remember_password.cfm*/
		"es" : "en",
		"Obtener una nueva contraseña para DoPlanning":"Get a new password for DoPlanning",
		"Introduzca los siguientes números":"Enter the following numbers",
		"Su nueva contraseña ha sido enviada a su dirección de email":"Your new password has been sent to your email address",
		"Cuenta de usuario deshabilitada":"Disabled user account",
		/*END remember_password.cfm*/

    /*Intranet*/
    "Email" : "Email",
    "Contraseña" : "Password",

  }

};
</cfscript>
</cfsilent>
<cfcontent type="application/json">
<cfoutput>#SerializeJSON(curLangTextEn)#</cfoutput>
