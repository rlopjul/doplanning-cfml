<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
</head>

<body>

<!---<cfargument name="id" type="string" required="no" default="">
<cfargument name="name" type="string" required="no" default="">
<cfargument name="administrator_id" type="string" required="no" default="">
<cfargument name="root_area_id" type="string" required="no" default="">
<cfargument name="number_of_users" type="string" required="no" default="">
<cfargument name="space" type="string" required="no" default="">
<cfargument name="abbreviation" type="string" required="no" default="">
<cfargument name="creation_date" type="string" required="no" default="">
<cfargument name="number_of_sms_used" type="string" required="no" default="">
<cfargument name="number_of_sms_paid" type="string" required="no" default="">--->

<cfform action="create_client.cfm" method="post">
	<fieldset>
		<legend>Datos del cliente</legend>
		<div><label for="name">Nombre de la organización</label>*&nbsp;<cfinput type="text" name="name" required="yes" value="" /></div>
		<div><label for="id">Id de la organización</label>*&nbsp;<cfinput type="text" name="id" value="" required="yes" maxlength="15" /></div>
		<!---<cfinput type="text" name="administrator_id" value="" />--->
		<!---<cfinput type="text" name="root_area_id" value="" />--->
		<!---<cfinput type="text" name="number_of_users" value="" />--->
		<!---<cfinput type="text" name="space" value="" />--->
		<div><label for="abbreviation">Abreviatura</label>*&nbsp;<cfinput type="text" name="abbreviation" value="" required="yes" maxlength="15" /></div>
		<!---<div><label for="creation_date">Fecha de creación</label><cfinput type="text" name="creation_date" value="" /></div>--->
		<!---<div><label for="number_of_sms_paid">Número de sms pagados</label>&nbsp;<cfinput type="text" name="number_of_sms_paid" value="0" validate="integer" required="yes" message="Introduzca un número de sms pagados" /></div>--->
		<input type="hidden" name="number_of_sms_paid" value="0" />
	</fieldset>
	<fieldset>
		<legend>Datos del usuario administrador</legend>
		<div><label for="user_family_name">Nombre</label>&nbsp;<cfinput type="text" name="user_family_name" value="" /></div>
		<div><label for="user_name">zzApellidos</label>&nbsp;<cfinput type="text" name="user_name" value="" /></div>
		<div><label for="user_email">Email</label>*&nbsp;<cfinput type="text" name="user_email" value="" required="yes"/></div>
		<div><label for="user_telephone">Teléfono</label><label for="user_telephone_ccode"></label>&nbsp;<cfinput type="text" name="user_telephone_ccode" value="34" size="5" /><cfinput type="text" name="user_telephone" value="" /></div>
		<div><label for="user_mobile_phone">Teléfono móvil</label><label for="user_mobile_phone_ccode"></label>&nbsp;<cfinput type="text" name="user_mobile_phone_ccode" value="34" size="5"><cfinput type="text" name="user_mobile_phone" value=""></div>
		<div><label for="user_password">Contraseña</label>*&nbsp;<cfinput type="text" name="user_password" value="" required="yes"></div>
		<!---<div><label for="user_sms_allowed">Puede enviar SMS</label>&nbsp;<cfinput type="checkbox" name="user_sms_allowed" value="true"></div>--->
		<input type="hidden" name="user_sms_allowed" value="false" />
		<div><label for="user_password">Usuario interno</label>&nbsp;<cfinput type="checkbox" name="whole_tree_visible" value="true" checked="yes" disabled="disabled"></div>
		<cfinput type="hidden" name="user_whole_tree_visible" value="true" />
	</fieldset>

	<cfinput type="submit" name="create_client" value="Crear" />
</cfform>

<cfif isDefined("FORM.id")>

	<!---<cfinvoke component="#APPLICATION.componentsPath#/ClientManager" method="xmlClient" returnvariable="xmlResult">
		<cfinvokeargument name="objectClient" value="#FORM#">
	</cfinvoke>--->

	<cfinvoke component="#APPLICATION.componentsPath#/ClientManager" method="objectClient" returnvariable="xmlClient">
		<cfinvokeargument name="id" value="#FORM.id#">
		<cfinvokeargument name="name" value="#FORM.name#">
		<cfinvokeargument name="abbreviation" value="#FORM.abbreviation#">
		<cfinvokeargument name="number_of_sms_paid" value="#FORM.number_of_sms_paid#">

		<cfinvokeargument name="return_type" value="xml">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="xmlUser">
		<cfinvokeargument name="family_name" value="#FORM.user_family_name#">
		<cfinvokeargument name="name" value="#FORM.user_name#">
		<cfinvokeargument name="email" value="#FORM.user_email#">
		<cfinvokeargument name="telephone" value="#FORM.user_telephone#">
		<cfinvokeargument name="telephone_ccode" value="#FORM.user_telephone_ccode#">
		<cfinvokeargument name="mobile_phone" value="#FORM.user_mobile_phone#">
		<cfinvokeargument name="mobile_phone_ccode" value="#FORM.user_mobile_phone_ccode#">
		<cfinvokeargument name="password" value="#hash(FORM.user_password)#">
		<cfif isDefined("FORM.user_sms_allowed")>
			<cfinvokeargument name="sms_allowed" value="true">
		<cfelse>
			<cfinvokeargument name="sms_allowed" value="false">
		</cfif>
		<cfif isDefined("FORM.user_whole_tree_visible")>
			<cfinvokeargument name="whole_tree_visible" value="true">
		<cfelse>
			<cfinvokeargument name="whole_tree_visible" value="false">
		</cfif>

		<cfinvokeargument name="return_type" value="xml">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.componentsPath#/RequestManager" method="createRequest" returnvariable="createClientRequest">
		<cfinvokeargument name="request_parameters" value="#xmlClient##xmlUser#">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.componentsPath#/ClientManager" method="createClient" returnvariable="createClientResult">
		<cfinvokeargument name="request" value="#createClientRequest#">
	</cfinvoke>

	<cfxml variable="xmlResult">
		<cfoutput>
		#createClientResult#
		</cfoutput>
	</cfxml>

	<cfif xmlResult.response.xmlAttributes.status EQ "ok">
		<cfoutput>
		Organización #FORM.name# creada correctamente
		</cfoutput>
	<cfelse>
		<cfoutput>
		Ha ocurrido un error al crear la organización<cfif isDefined("xmlResult.response.error.title")>: #xmlResult.response.error.title.xmlText#</cfif>
		</cfoutput>
	</cfif>

	<!---<cfinvoke component="#APPLICATION.componentsPath#/ClientManager" method="createClientFolders">
		<cfinvokeargument name="client_id" value="#FORM.client_id#">
	</cfinvoke>--->
</cfif>
</body>
</html>
