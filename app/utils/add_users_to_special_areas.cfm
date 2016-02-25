<!DOCTYPE html>
<html lang="es">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<cfoutput>
  <link href="#APPLICATION.baseCSSPath#" rel="stylesheet">
</cfoutput>
<title>Añadir/quitar usuarios de áreas</title>
</head>

<body>

<div class="container">

  <div class="row">

    <div class="col-sm-12">

      <h2>Añadir/quitar usuarios de áreas</h1>

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


    <cfset ADD_TO_AREA_USER_TYPOLOGY = 1>
    <cfset ADD_TO_AREA_TYPOLOGY_FIELD = 52>

    <cfset ADD_TO_AREA_WITH_TRUE_VALUE = 118>
    <cfset ADD_TO_AREA_WITH_FALSE_VALUE = 120>

    <cfquery datasource="#client_datasource#" name="getTypologyUsers">
      SELECT users.id, users.email, typologies.field_#ADD_TO_AREA_TYPOLOGY_FIELD#
      FROM `#new_client_abb#_users` AS users
      INNER JOIN `#new_client_abb#_users_typologies_rows_#ADD_TO_AREA_USER_TYPOLOGY#` AS typologies
      ON users.typology_id = <cfqueryparam value="#ADD_TO_AREA_USER_TYPOLOGY#" cfsqltype="cf_sql_integer">
      AND users.typology_row_id = typologies.row_id;
    </cfquery>

    <cfdump var="#getTypologyUsers#">

    <cfloop query="#getTypologyUsers#">

      <cfset fieldValue = getTypologyUsers['field_#ADD_TO_AREA_TYPOLOGY_FIELD#']>

      <cfoutput>
        #getTypologyUsers.email#
        #fieldValue#<br/>
      </cfoutput>

      <cfif fieldValue IS true OR fieldValue IS false>

        <cfif fieldValue IS true>

          <cfset areaToAddUser = ADD_TO_AREA_WITH_TRUE_VALUE>
          <cfset areaToRemoveUser = ADD_TO_AREA_WITH_FALSE_VALUE>

        <cfelse>

          <cfset areaToAddUser = ADD_TO_AREA_WITH_FALSE_VALUE>
          <cfset areaToRemoveUser = ADD_TO_AREA_WITH_TRUE_VALUE>

        </cfif>

        <cfinvoke component="#APPLICATION.coreComponentsPath#/UserManager" method="addOrRemoveUserFromSpecialArea" returnvariable="isUserAssociatedToAreaToAdd">
          <cfinvokeargument name="user_id" value="#getTypologyUsers.id#"/>
          <cfinvokeargument name="field_value" value="#fieldValue#"/>

          <cfinvokeargument name="add_to_area_id" value="#areaToAddUser#"/>
          <cfinvokeargument name="remove_from_area_id" value="#areaToRemoveUser#"/>

          <cfinvokeargument name="client_abb" value="#new_client_abb#">
          <cfinvokeargument name="client_dsn" value="#client_datasource#">
        </cfinvoke>

      </cfif>

    </cfloop>


    </cfoutput>


<cfelse>


  <div class="row">

    <div class="col-sm-12">

      <cfform method="post" action="#CGI.SCRIPT_NAME#">

        <div class="form-group">
          <label>Web a cambiar URLs</label>

          <cfquery datasource="#APPLICATION.dsn#" name="getClients">
            SELECT *
            FROM app_clients;
          </cfquery>
          <select name="abb">
            <cfoutput query="getClients">
              <option value="#getClients.abbreviation#">#getClients.name# (#getClients.abbreviation#)</option>
            </cfoutput>
          </select>
        </div>

        <cfinput type="submit" name="migrate" value="AÑADIR USUARIOS A ÁREAS ESPECIALES" class="btn btn-default btn-primary">
      </cfform>

    </div>

  </div>

</cfif>

</div>




<!---<br/>
<cfform method="post" action="#CGI.SCRIPT_NAME#">
  <cfinput type="submit" name="migrate" value="MIGRAR TODOS LOS CLIENTES">
</cfform>--->

</body>
</html>
