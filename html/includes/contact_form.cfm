<cfif NOT isDefined("objectContact")>

	<cfinvoke component="#APPLICATION.componentsPath#/ContactManager" method="objectContact" returnvariable="objectContact">
			
			<cfinvokeargument name="return_type" value="object">
	</cfinvoke>
	
	<!---<cfset ccode = "34">--->
	<cfset objectContact.mobile_phone_ccode = "34">
	<cfset objectContact.telephone_ccode = "34">
	
</cfif>

<cfoutput>
<cfif len(objectContact.id) IS 0>
	<form action="#APPLICATION.htmlComponentsPath#/Contact.cfc?method=createContact" method="post">
<cfelse>
	<form action="#APPLICATION.htmlComponentsPath#/Contact.cfc?method=updateContact" method="post">
		<input type="hidden" name="id" value="#objectContact.id#">
</cfif>
	<div class="form_fila"><span class="texto_gris_12px">Nombre:</span><br /> <input type="text" name="family_name" value="#objectContact.family_name#" style="width:100%;"/></div>
	<div class="form_fila"><span class="texto_gris_12px">Apellidos:</span><br /> <input type="text" name="name" value="#objectContact.name#" style="width:100%;"/></div>
	<div class="form_fila"><span class="texto_gris_12px">Email:</span><br /> <input type="text" name="email" value="#objectContact.email#" style="width:100%;"/></div>
	<div class="form_fila">
	<div class="form_text" style="width:100px;"><span class="texto_gris_12px">Teléfono móvil:</span></div>
	<div class="form_input" style="width:85%;"> 
	 <div style="float:left; width:17px;"><input type="text" name="mobile_phone_ccode" value="#objectContact.mobile_phone_ccode#" readonly="true" style="width:17px;" /></div>
	 <div style="float:left; width:75px;"><input type="text" name="mobile_phone" value="#objectContact.mobile_phone#" style="width:100%" /></div>
	 </div>
	</div>
	
	<div class="form_text" style="width:100px;"><span class="texto_gris_12px">Teléfono:</span></div>
	<div class="form_input" style="width:85%;"> 
	 <div style="float:left; width:17px;"><input type="text" name="telephone_ccode" value="#objectContact.telephone_ccode#" readonly="true" style="width:17px;" /></div>
	 <div style="float:left; width:75px;"><input type="text" name="telephone" value="#objectContact.telephone#" style="width:100%"/></div>
	</div>
	 
	<div class="form_fila"><span class="texto_gris_12px">Dirección:</span><br />
	 <textarea type="text" name="address"  style="width:100%" rows="2"/>#objectContact.address#</textarea></div>
	<div class="form_fila"><span class="texto_gris_12px">Organización:</span><br />
	 <input type="text" name="organization" value="#objectContact.organization#" style="width:100%;"/></div>

	<div class="input_submit">
	<cfif len(objectContact.id) IS 0>
		<input type="submit" name="insert" value="Insertar" />
	<cfelse>	
		<input type="submit" name="modify" value="Guardar" />
	</cfif>
	</div>
</form>
<br />
</cfoutput>