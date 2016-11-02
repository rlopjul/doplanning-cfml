<cftry>

  <!--- Check access to static files from HTML generated file related to area file --->
  <cfif isDefined("URL.file") AND URL.abb EQ SESSION.client_abb>

    <cfset fileName = GetFileFromPath(URL.file)>

    <cfif len(fileName) GT 0>

      <cfif isNumeric(listFirst(fileName, "."))><!--- .html files --->
        <cfset fileId = listFirst(fileName, ".")>
      <cfelse>
        <cfset fileId = listFirst(fileName,"_")><!--- .png files --->
      </cfif>

      <cfif len(fileId) GT 0 AND isNumeric(fileId)>

        <cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

        <cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="selectFileQuery">
  				<cfinvokeargument name="file_id" value="#fileId#">
  				<cfinvokeargument name="parse_dates" value="false">
  				<cfinvokeargument name="published" value="false">

  				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
  				<cfinvokeargument name="client_dsn" value="#client_dsn#">
  			</cfinvoke>

        <cfif selectFileQuery.recordCount GT 0>

          <cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getFile" returnvariable="fileQuery">
          	<cfinvokeargument name="get_file_id" value="#fileId#">

            <cfif isNumeric(selectFileQuery.item_type_id) AND isNumeric(selectFileQuery.item_id)>
              <cfinvokeargument name="itemTypeId" value="#selectFileQuery.item_type_id#">
              <cfinvokeargument name="item_id" value="#selectFileQuery.item_id#">
            </cfif>

          	<cfinvokeargument name="return_type" value="query">
          </cfinvoke>

          <cfset filePath = "#APPLICATION.path#/#SESSION.client_id#/temp/#URL.file#">

          <cfset fileType = fileGetMimeType(filePath,false)>

          <cfcontent file="#filePath#" deletefile="no" type="#fileType#" />


        </cfif>

      </cfif>

    </cfif>

  </cfif>

  <cfcatch>

    <cfif isDefined("cfcatch.errorcode") AND isValid("integer",cfcatch.errorcode)>
      <cfset error_code = cfcatch.errorcode>
    <cfelse>
  		<cfset error_code = 10000><!--- Unexpected --->
  	</cfif>

  	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Error" method="showError">
  		<cfinvokeargument name="error_code" value="#error_code#">
  	</cfinvoke>

  </cfcatch>
</cftry>
