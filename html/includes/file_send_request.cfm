<!--- ESTA PÁGINA NO SE ESTÁ USANDO --->
<cfif isDefined("URL.file") AND isDefined("URL.method")>

	<cfset file_id = URL.file>

	<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>


	<!--- File --->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="objectFile">
		<cfinvokeargument name="file_id" value="#file_id#">
		<cfif isDefined("area_id")>
		<cfinvokeargument name="area_id" value="#area_id#">
		</cfif>
		<cfinvokeargument name="with_owner_area" value="true"> 		
	</cfinvoke>

	<!---Typology fields--->
	<cfset table_id = objectFile.typology_id>
	<cfset tableTypeId = 3>
	<cfset row_id = objectFile.typology_row_id>

	<cfif isNumeric(table_id) AND isNumeric(row_id)>
		
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getRow" returnvariable="getRowResponse">
			<cfinvokeargument name="table_id" value="#table_id#"/>
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#"/>
			<cfinvokeargument name="row_id" value="#row_id#"/>
			<cfinvokeargument name="file_id" value="#objectFile.id#"/>
		</cfinvoke>
		<cfset table = getRowResponse.table>
		<cfset rowQuery = getRowResponse.row>

		<!---Table fields--->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			<cfinvokeargument name="with_types" value="true"/>
			<cfinvokeargument name="file_id" value="#file_id#"/>
		</cfinvoke>

		<cfset fields = fieldsResult.tableFields>

		<!---getRowJSONResponse--->
		<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="getRowJSON" returnvariable="getRowJSONResponse">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			<cfinvokeargument name="row_id" value="#row_id#">
			<cfinvokeargument name="rowQuery" value="#rowQuery#">
			<cfinvokeargument name="file_id" value="#file_id#">
			<cfinvokeargument name="fields" value="#fields#">

			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

		<cfset rowJSON = getRowJSONResponse.rowJSON>

		<cfset requestUrl = "">

		<cfloop query="fields">
			
			<cfif fields.field_type_id IS 14><!---REQUEST URL--->

				<cfset field_name = "field_#fields.field_id#">

				<cfif len(rowQuery[field_name]) GT 0>
					<cfset requestUrl = rowQuery[field_name]>
				</cfif>

			</cfif>

		</cfloop>
		
		<cfif len(requestUrl) GT 0>

			<cfset rowJSON.file_download_path = "/html/file_download.cfm?id=#file_id#">
			<cfset rowJSON.file_id = file_id>

			<!---<cfhttp url="#requestUrl#" method="#URL.method#" result="httpResp" timeout="60">
			    <cfhttpparam type="header" name="Content-Type" value="application/json" />
			    <cfhttpparam type="body" value="#serializeJSON(stFields)#">
			</cfhttp>--->

			<cfdump var="#rowJSON#">

			<cfoutput><textarea>#serializeJSON(rowJSON)#</textarea></cfoutput>

			<cfoutput>
				<html>
					<head>
						<title></title>
					</head>

					<body>

						<form method="post" id="rowForm" action="#requestUrl#">
							<input type="hidden" name="data" value='#serializeJSON(rowJSON)#'/>
							<input type="submit" value="Enviar"/>
						</form>

					</body>
				</html>
			</cfoutput>

		</cfif>		

	</cfif>


</cfif>



