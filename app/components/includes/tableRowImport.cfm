<cfset error = false>

<cfloop query="fields"><!--- loop Columns --->

  <cfset errorMessage = "">
  <cfset errorMessagePrefix = "Error en fila #curRowIndex#, columna #curColumn#: ">

  <cfset fieldName = "field_#fields.field_id#">

  <cfset fieldValue = trim(fileArray[curRowIndex][curColumn])>

  <cfif fields.field_type_id IS 5><!---DECIMAL--->

    <cfif isNumeric(fields.mask_type_id) AND arguments.decimals_with_mask IS true><!---Hay máscara seleccionada en el campo y los datos importados del archivo están especificados como en la máscara--->

      <cfset cf_prefix = maskTypesStruct[fields.mask_type_id].cf_prefix>
      <cfset cf_sufix = maskTypesStruct[fields.mask_type_id].cf_sufix>
      <cfset cf_prefix_len = len(cf_prefix)>
      <cfset cf_sufix_len = len(cf_sufix)>
      <cfset decimal_delimiter = maskTypesStruct[fields.mask_type_id].decimal_delimiter>

      <cfif cf_prefix_len GT 0 AND cf_prefix EQ left(fieldValue, cf_prefix_len)>
        <!---Se borra el prefijo--->
        <cfset fieldValue = right(fieldValue, len(fieldValue)-cf_prefix_len)>

      </cfif>

      <cfif decimal_delimiter EQ "."><!---Decimales separados por punto--->

        <!---Se borran las comas que puede haber en los millares--->
        <cfset fieldValue = replace(fieldValue, ",", "", "ALL")>

      <cfelseif decimal_delimiter EQ ","><!---Decimales separados por coma--->

        <!---Se borran los puntos que puede haber en los millares---->
        <cfset fieldValue = replace(fieldValue, ".", "", "ALL")>

        <!---Se sustituyen las comas por puntos--->
        <cfset fieldValue = replace(fieldValue, ",", ".", "ALL")>

      </cfif>

      <cfif cf_sufix_len GT 0 AND cf_sufix EQ right(fieldValue, cf_sufix_len)>
        <!---Se borra el sufijo--->
        <cfset fieldValue = left(fieldValue, len(fieldValue)-cf_sufix_len)>
      </cfif>


    </cfif>

  <cfelseif fields.field_type_id IS 6><!--- DATE --->

    <cfif len(fieldValue) GT 0>

      <cfif findOneOf("/", fieldValue) GT 0>

        <cfset fieldValue = replace(fieldValue, "/", "-", "all")>

      </cfif>

      <cfinvoke component="#APPLICATION.coreComponentsPath#/DateManager" method="validateDate" returnvariable="result">
        <cfinvokeargument name="strDate" value="#fieldValue#">
      </cfinvoke>

    </cfif>

  <cfelseif fields.field_type_id IS 7><!--- BOOLEAN --->

    <cfif len(fieldValue) GT 0>

      <cfif fieldValue EQ true OR fieldValue EQ 1 OR fieldValue EQ "Sí" OR fieldValue EQ "Si" OR fieldValue EQ "Yes" OR uCase(fieldValue) EQ "VERDADERO">
        <cfset fieldValue = 1>
      <cfelseif fieldValue EQ false OR fieldValue EQ 0 OR fieldValue EQ "No" OR uCase(fieldValue) EQ "FALSO">
        <cfset fieldValue = 0>
      <cfelse>
        <!--- Error --->
        <cfset errorMessage = errorMessagePrefix&"Valor incorrecto (#fieldValue#) para campo Sí/No">
      </cfif>

    </cfif>

  <cfelseif fields.field_type_id EQ 9 OR fields.field_type_id EQ 10><!--- AREAS LISTS --->

    <cfset fieldAreasQuery = areasQueries[fields.field_id]>

    <cfif fields.field_type_id IS 10><!--- Multiple areas selection --->

      <cfif listLen(fieldValue, ";") GT 0>

        <cfset newFieldValue = arrayNew(1)>

        <cfloop list="#fieldValue#" index="curFieldValue" delimiters=";">

          <!---
          De esta forma dan problemas algunos caracteres especiales porque al hacer la comparación con el LIKE no concuerdan
          <cfquery dbtype="query" name="getAreaValue">
            SELECT id
            FROM fieldAreasQuery
            WHERE name LIKE <cfqueryparam value="#curFieldValue#" cfsqltype="cf_sql_varchar">;
          </cfquery>

          <cfif getAreaValue.recordCount GT 0>
            <cfset arrayAppend(newFieldValue, getAreaValue.id)>
          </cfif>--->

          <cfloop query="fieldAreasQuery">

            <cfif fieldAreasQuery.name EQ curFieldValue>

              <cfset arrayAppend(newFieldValue, fieldAreasQuery.id)>

            </cfif>

          </cfloop>

        </cfloop>

        <cfset fieldValue = newFieldValue>

      <cfelse>
        <cfset fieldValue = arrayNew(1)>
      </cfif>

    <cfelse>

      <!---
      De esta forma dan problemas algunos caracteres especiales porque al hacer la comparación con el LIKE no concuerdan
      <cfquery dbtype="query" name="getAreaValue">
        SELECT id
        FROM fieldAreasQuery
        WHERE name LIKE <cfqueryparam value="#fieldValue#" cfsqltype="cf_sql_varchar">;
      </cfquery>

      <cfif getAreaValue.recordCount GT 0>
        <!--- List values required array --->
        <cfset fieldValue = [getAreaValue.id]>
      <cfelse>
        <cfset fieldValue = arrayNew(1)>
      </cfif>
      --->
      <cfset fieldValueText = fieldValue>
      <cfset fieldValue = arrayNew(1)>

      <cfloop query="fieldAreasQuery">

        <cfif fieldAreasQuery.name EQ fieldValueText>

          <!--- List values required array --->
          <cfset fieldValue = [fieldAreasQuery.id]>

        </cfif>

      </cfloop>


    </cfif>

  <cfelseif fields.field_type_id EQ 15 OR fields.field_type_id EQ 16><!--- LISTS TEXT VALUES --->


    <cfif fields.field_type_id IS 16><!--- Multiple areas selection --->

      <cfif listLen(fieldValue, ";") GT 0>

        <cfset fieldValue = listToArray(fieldValue,";")>

      <cfelse>
        <cfset fieldValue = arrayNew(1)>
      </cfif>

    <cfelse>

      <cfif len(fieldValue) GT 0>
        <!--- List values required array --->
        <cfset fieldValue = [fieldValue]>
      <cfelse>
        <cfset fieldValue = arrayNew(1)>
      </cfif>

    </cfif>


  <cfelse>

    <cfif fields.field_type_id EQ 3 OR fields.field_type_id EQ 11><!--- LONG TEXT --->

      <!--- INSERT <br> --->
      <cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="insertBR" returnvariable="fieldValue">
        <cfinvokeargument name="string" value="#fieldValue#">
      </cfinvoke>

    </cfif>

    <cfset fieldValueLen = len(fieldValue)>

    <cfif len(errorMessage) IS 0 AND fieldValueLen GT fields.max_length>

      <!--- Error --->
      <cfset errorMessage = errorMessagePrefix&"El número de caracteres (#fieldValueLen#) es mayor del permitido para esa columna (#fields.max_length#)">

    </cfif>

  </cfif>

  <cfif len(errorMessage) GT 0><!--- Errors --->

    <cfset error = true>

    <cfif arguments.cancel_on_error IS true>

      <!--- Se lanza un error con cthrow para que se haga ROLLBACK --->
      <cfthrow message="#errorMessage#">

    <cfelse>

      <cfif len(errorMessages) GT 0>
        <cfset errorMessages = errorMessages&"<br>"&errorMessage>
      <cfelse>
        <cfset errorMessages = errorMessage>
      </cfif>

    </cfif>

  </cfif>

  <cfset rowValues[fieldName] = fieldValue>

  <cfset curColumn = curColumn+1>

</cfloop>
