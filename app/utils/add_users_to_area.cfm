<!DOCTYPE html>
<html lang="es">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<cfoutput>
  <link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
</cfoutput>
<title>Añadir usuarios a área</title>
</head>

<body>

<div class="container">

  <div class="row">

    <div class="col-sm-12">

      <h2>Añadir usuarios a área</h1>

    </div>

  </div>

<cfif isDefined("FORM.abb")>

    <cfset new_client_abb = FORM.abb>
    <cfset client_datasource = APPLICATION.identifier&"_"&new_client_abb>

    <cfquery datasource="#APPLICATION.dsn#" name="getClient">
      SELECT *
      FROM app_clients
      WHERE abbreviation = <cfqueryparam value="#new_client_abb#" cfsqltype="cf_sql_varchar">;
    </cfquery>

    <cfif getClient.recordCount IS 0>
      <cfthrow message="Error al obtener el cliente: #new_client_abb#">
    </cfif>

    <cfoutput>
    CLIENTE: #getClient.name#<br/>

    EMAILS:<br/>

    <cfset emailsList = "">

    <cfloop list="#trim(FORM.emails)#" delimiters="#chr(13)##chr(10)#" index="email_value">
      #email_value#<br/>
      <cfset emailsList = trim(lCase(listAppend(emailsList, email_value)))>
    </cfloop>

    <cfquery datasource="#client_datasource#" name="getUsers">
      SELECT *
      FROM `#new_client_abb#_users` AS users
      WHERE LCASE(email) IN (
       <cfqueryparam value="#emailsList#" list="true" cfsqltype="cf_sql_varchar">
      );
    </cfquery>

    <!---<cfdump var="#getUsers#">--->

    <br/>TOTAL USUARIOS ENCONTRADOS PARA AÑADIR: #getUsers.recordCount#

    <cfloop query="#getUsers#">

      <cfoutput>
        <br/>#getUsers.email#
      </cfoutput>

      <!--- areaToAddUser --->

      <cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="isUserAssociatedToArea" returnvariable="isUserAssociatedToAreaToAdd">
        <cfinvokeargument name="area_id" value="#FORM.add_to_area_id#"/>
        <cfinvokeargument name="user_id" value="#getUsers.id#"/>

        <cfinvokeargument name="client_abb" value="#new_client_abb#">
        <cfinvokeargument name="client_dsn" value="#client_datasource#">
      </cfinvoke>

      <cfif isUserAssociatedToAreaToAdd.isUserInArea IS false>

        <cfinvoke component="#APPLICATION.coreComponentsPath#/UserManager" method="assignUserToArea">
          <cfinvokeargument name="area_id" value="#FORM.add_to_area_id#"/>
          <cfinvokeargument name="user_id" value="#getUsers.id#"/>
          <cfinvokeargument name="send_alert" value="false">

          <cfinvokeargument name="client_abb" value="#new_client_abb#">
          <cfinvokeargument name="client_dsn" value="#client_datasource#">
        </cfinvoke>

        NO ESTABA EN EL ÁREA, YA ESTÁ ASOCIADO

      </cfif>

    </cfloop>


    </cfoutput>


<cfelse>


  <div class="row">

    <div class="col-sm-12">

      <cfform method="post" action="#CGI.SCRIPT_NAME#">

        <div class="form-group">
          <label>ID de área a la que asociar</label>
          <input type="number" name="add_to_area_id" value="">
        </div>

        <div class="form-group">

          <!---<cfquery datasource="#APPLICATION.dsn#" name="getClients">
            SELECT *
            FROM app_clients;
          </cfquery>
          <select name="abb">
            <cfoutput query="getClients">
              <option value="#getClients.abbreviation#">#getClients.name# (#getClients.abbreviation#)</option>
            </cfoutput>
          </select>--->
          <labekl>Cliente</label>
          <input type="text" name="abb" value=""/>
        </div>

        <div class="form-group">

          <label>Emails usuarios</label>

          <textarea name="emails">
email1@doplanning.net
email2@doplanning.net
          </textarea>

        </div>

        <cfinput type="submit" name="migrate" value="AÑADIR USUARIOS A ÁREA" class="btn btn-default btn-primary">
      </cfform>

    </div>

  </div>

</cfif>

</div>

</body>
</html>
