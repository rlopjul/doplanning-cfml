<div class="formulario">
		

	<cfif isDefined("FORM.submit")>
		
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
		
		<!---<cfmail subject="Formulario rellenado desde la web de DoPlanning" to="info@doplanning.net" from="web@era7.com" failto="support@doplanning.net" username="b_E2-m._.rTH_" password="era7BIC" type="html">
			<br /><br />
			<b>Page from which you contract:</b>#CGI.SCRIPT_NAME#<br />
			<b>Organization:</b> #form.organization#<br />
			<b>First name:</b> #form.first_name#<br />
			<b>Last name:</b> #form.last_name#<br />
			<b>Address:</b> #form.address#<br />
			<b>Phone:</b> #form.telephone#<br />
			<b>E-mail:</b> #form.email#<br />
			<b>Comments:</b><br/>
			#form.comment#<br />
		</cfmail>--->
		
		<div style="padding-left:50px; padding-top:50px;">
		<p>Thank you for your interest<br/>We will answer you very soon.</p>
		</div>
		
	<cfelse>
		
		<cfform action="#CGI.SCRIPT_NAME#" name="contactForm" method="post">
		
		<table width="500" height="307" border="0" align="center">
		  <tr>
			<td width="99" height="25" align="right">Organization:</td>
			<td width="389"><cfinput name="organization" type="text" size="30"/></td>
		  </tr>
		  <tr>
			<td height="25" align="right">First name:</td>
			<td><cfinput name="first_name" type="text" size="30"/></td>
		  </tr>
		  <tr>
			<td height="25" align="right">Last name:</td>
			<td><cfinput name="last_name" type="text" size="30"/></td>
		  </tr>
		  <tr>
			<td height="25" align="right">Address:</td>
			<td><cfinput name="address" type="text" size="30"/></td>
		  </tr>
		  <tr>
			<td height="25" align="right">Phone:</td>
			<td><cfinput name="telephone" type="text" size="30"/></td>
		  </tr>
		  <tr>
			<td height="25" align="right">E-mail: <span class="texto_min_form">(compulsory)</span></td>
			<td><cfinput name="email" type="text" size="30" validate="email" required="true" message="Email correcto requerido"/></td>
		  </tr>
		  <tr>
			<td height="111" align="right" valign="top">Comments:</td>
			<td valign="top"><textarea name="comment" rows="5" cols="25"></textarea></td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td><cfinput name="submit" type="submit" value="Send" class="boton_form" border="0" /> &nbsp; &nbsp;<input type="reset" value="Cancel" class="boton_form" border="0" /></td>
		  </tr>
		</table>
	</cfform>		
		
	</cfif>

	

</div><!--fin formulario-->
		
