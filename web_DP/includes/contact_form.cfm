<div class="formulario">
		

	<cfif isDefined("FORM.submit")>
		
		<!---<cfmail subject="Formulario rellenado desde la web de DoPlanning" to="info@doplanning.net" from="web@era7.com" failto="support@doplanning.net" username="b_E2-m._.rTH_" password="era7BIC" type="html">
		<html>
			<body>
			<br /><br />
			<b>Página desde la que contacta:</b>#CGI.SCRIPT_NAME#<br />
			<b>Organización:</b> #form.organization#<br />
			<b>Nombre:</b> #form.first_name#<br />
			<b>Apellidos:</b> #form.last_name#<br />
			<b>Dirección:</b> #form.address#<br />
			<b>Teléfono:</b> #form.telephone#<br />
			<b>E-mail:</b> #form.email#<br />
			<b>Comentario:</b><br/>
			#form.comment#<br />
			</body>
		</html>
		</cfmail>--->
		
		<cfsavecontent variable="email_content">
			<cfoutput>
			<br /><br />
			<b>Página desde la que contacta:</b>#CGI.SCRIPT_NAME#<br />
			<b>Organización:</b> #form.organization#<br />
			<b>Nombre:</b> #form.first_name#<br />
			<b>Apellidos:</b> #form.last_name#<br />
			<b>Dirección:</b> #form.address#<br />
			<b>Teléfono:</b> #form.telephone#<br />
			<b>E-mail:</b> #form.email#<br />
			<b>Comentario:</b><br/>
			#form.comment#<br />
			</cfoutput>
		</cfsavecontent>
		
		<cfinvoke component="#APPLICATION.componentsPath#/EmailManager" method="sendEmail">
			<cfinvokeargument name="from" value="web@era7.com">
			<cfinvokeargument name="to" value="info@doplanning.net">
			<cfinvokeargument name="subject" value="Formulario rellenado desde la web de DoPlanning">
			<cfinvokeargument name="content" value="#email_content#">
		</cfinvoke>	
		
		<div style="padding-left:50px; padding-top:50px;">
		<p>Gracias por el interés mostrado en DoPlanning.<br/>Nos pondremos en contacto con usted lo antes posible.</p>
		</div>
		
	<cfelse>
		
		<cfform action="#CGI.SCRIPT_NAME#" name="contactForm" method="post">
		
		<table width="500" height="307" border="0" align="center">
		  <tr>
			<td width="99" height="25" align="right">Organización:</td>
			<td width="389"><cfinput name="organization" type="text" size="30"/></td>
		  </tr>
		  <tr>
			<td height="25" align="right">Nombre:</td>
			<td><cfinput name="first_name" type="text" size="30"/></td>
		  </tr>
		  <tr>
			<td height="25" align="right">Apellidos:</td>
			<td><cfinput name="last_name" type="text" size="30"/></td>
		  </tr>
		  <tr>
			<td height="25" align="right">Dirección</td>
			<td><cfinput name="address" type="text" size="30"/></td>
		  </tr>
		  <tr>
			<td height="25" align="right">Teléfono</td>
			<td><cfinput name="telephone" type="text" size="30"/></td>
		  </tr>
		  <tr>
			<td height="25" align="right">E-mail <span class="texto_min_form">(obligatorio)</span></td>
			<td><cfinput name="email" type="text" size="30" validate="email" required="true" message="Email correcto requerido"/></td>
		  </tr>
		  <tr>
			<td height="111" align="right" valign="top">Comentario:</td>
			<td valign="top"><textarea name="comment" rows="5" cols="25"></textarea></td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td><cfinput name="submit" type="submit" value="Enviar" class="boton_form" border="0" /> &nbsp; &nbsp;<input type="reset" value="Borrar" class="boton_form" border="0" /></td>
		  </tr>
		</table>
	</cfform>		
		
	</cfif>

	

</div><!--fin formulario-->
		
