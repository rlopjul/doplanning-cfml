<!---Este include NO se debe usar directamente, se debe usar sólo el método getTableActionTypesStruct del componente TableManager--->

<!---email--->
<cfset structInsert(actionTypesStruct, 1, {id=1, position=1, name="email", label="Enviar email", actionTypeId=1})>

<!---http request--->
<cfset structInsert(actionTypesStruct, 2, {id=2, position=2, name="request", label="Petición HTTP", actionTypeId=2})>

<!---sms--->
