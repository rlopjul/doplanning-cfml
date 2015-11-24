<cfoutput>
<cfloop query="fields"><!--- Este loop debe ser igual que el que hay en UserQuery.cfc --->

  <cfset field_name = "field_#fields.field_id#">

  <cfif isDefined("arguments[field_name]")>

    <cfif fields.field_type_id NEQ 9 AND fields.field_type_id NEQ 10><!--- IS NOT SELECT FIELD FROM AREA--->

      <cfset field_value = arguments[field_name]>

      <cfif len(field_value) GT 0>

        <cfif fields.cf_sql_type IS "cf_sql_varchar" OR fields.cf_sql_type IS "cf_sql_longvarchar">


          <cfif fields.field_type_id IS 15 OR fields.field_type_id IS 16><!--- SELECT FIELD FROM LIST --->

            <cfif len(arguments[field_name][1]) GT 0>

              <cfset field_values = arguments[field_name]>

              <cfloop array="#field_values#" index="select_value">
                AND <cfqueryparam value="#select_value#" cfsqltype="cf_sql_varchar"> REGEXP REPLACE(field_#fields.field_id#, '#LIST_TEXT_VALUES_DELIMITER#', '|')
              </cfloop>

            </cfif>

          <cfelse>

            <cfinvoke component="#APPLICATION.coreComponentsPath#/SearchManager" method="generateSearchText" returnvariable="field_value_re">
              <cfinvokeargument name="text" value="#field_value#">
            </cfinvoke>

            AND field_#fields.field_id# REGEXP
            <cfif fields.field_type_id IS 3 OR fields.field_type_id IS 11><!--- Text with HTML format --->
              <cfqueryparam value=">.*#field_value_re#.*<" cfsqltype="cf_sql_varchar">
            <cfelse>
              <cfqueryparam value="#field_value_re#" cfsqltype="cf_sql_varchar">
            </cfif>

          </cfif>

        <cfelse>

          AND field_#fields.field_id# =
          <cfif fields.mysql_type IS "DATE"><!--- DATE --->
            STR_TO_DATE('#field_value#','#dateFormat#')
          <cfelse>
            <cfqueryparam value="#field_value#" cfsqltype="#fields.cf_sql_type#">
          </cfif>

        </cfif>
      </cfif>

    <cfelse><!--- SELECT FIELDS --->

      <!---<cfif isDefined("arguments.#field_name#")>--->
        <!---<cfset selectFields = true>--->
        <cfset field_values = arguments[field_name]>
        <cfloop array="#field_values#" index="select_value">
          <cfif isNumeric(select_value)>
          AND table_row.row_id IN ( SELECT row_id FROM `#client_abb#_#tableTypeTable#_rows_areas`
            WHERE #tableTypeName#_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
            AND field_id = <cfqueryparam value="#fields.field_id#" cfsqltype="cf_sql_integer">
            AND area_id = <cfqueryparam value="#select_value#" cfsqltype="cf_sql_integer"> )
          </cfif>
        </cfloop>

        <!---Esta opción es la adecuada para que se incluyan los elementos con al menos una de las opciones seleccionadas--->
        <!---<cfif arrayLen(field_values) GT 1 OR ( arrayLen(field_values) IS 1 AND isNumeric(field_values[1]) )>
          AND table_row.row_id IN (
            SELECT row_id FROM `#client_abb#_#tableTypeTable#_rows_areas`
            WHERE #tableTypeName#_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
            AND field_id = <cfqueryparam value="#fields.field_id#" cfsqltype="cf_sql_integer">
            AND (
            <cfset curValueCount = 1>
            <cfloop array="#field_values#" index="select_value">
              <cfif isNumeric(select_value)>
                <cfif curValueCount GT 1>
                  OR
                </cfif>
                area_id = <cfqueryparam value="#select_value#" cfsqltype="cf_sql_integer">
                <cfset curValueCount = curValueCount+1>
              </cfif>
            </cfloop>
            )
          )
        </cfif>--->

      <!---</cfif>--->

    </cfif>

  </cfif>

</cfloop>

</cfoutput>
<!---
<cfif selectFields IS true><!--- Select fields values ---->
  AND table_row.row_id IS IN ( SELECT row_id FROM `#client_abb#_#tableTypeTable#_rows_areas`
    WHERE #tableTypeName#_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">
    <cfloop query="fields">

      <cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- SELECT --->
        <cfif isDefined("arguments.#field_name#") AND isNumeric(arguments[field_name])>

          AND ( field_id = <cfqueryparam value="#fields.field_id#" cfsqltype="cf_sql_integer">
          AND area_id = <cfqueryparam value="#arguments[field_name]#" cfsqltype="cf_sql_integer"> )

        </cfif>

      </cfif>

    </cfloop>)

</cfif>--->
