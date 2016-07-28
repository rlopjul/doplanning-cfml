<cfif isDefined("FORM.files_ids") AND isDefined("FORM.area_id")>

	<cfset files_ids = FORM.files_ids>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="deleteFiles" returnvariable="resultDeleteFiles">
		<cfinvokeargument name="files_ids" value="#files_ids#">
		<cfinvokeargument name="area_id" value="#FORM.area_id#">
	</cfinvoke>
	<cfset msg = resultDeleteFiles.message>
	<cfset res = resultDeleteFiles.result>

	<cfif res IS false>
		<cflocation url="#return_path#area.cfm?area=#FORM.area_id#&res=#res#&msg=#URLEncodedFormat(msg)#" addtoken="no">
	<cfelse><!--- Show warning message: we don't know if all files result are success --->
		<cflocation url="#return_path#area.cfm?area=#FORM.area_id#&res=-1&msg=#URLEncodedFormat(msg)#" addtoken="no">
	</cfif>

</cfif>

<cfif isDefined("URL.file")>
	<cfset files_ids = URL.file>
<cfelseif isDefined("URL.files")>
	<cfset files_ids = URL.files>
<cfelse>
	<cflocation url="index.cfm" addtoken="no">
</cfif>

<cfif isDefined("URL.area")>

	<cfset area_id = URL.area>

	<cfset itemTypeId = 10>
	<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

	<cfinclude template="#APPLICATION.htmlPath#/includes/area_id.cfm">
	<cfinclude template="#APPLICATION.htmlPath#/includes/area_checks.cfm">

	<cfinclude template="#APPLICATION.htmlPath#/includes/app_page_head.cfm">

<cfelse>

	<cflocation url="index.cfm" addtoken="no">

</cfif>

<div class="div_head_subtitle">
	<cfif isDefined("URL.file")>
		<span lang="es">Eliminar archivo</span>
	<cfelse>
		<span lang="es">Eliminar archivos</span>
	</cfif>
</div>

<cfoutput>

<cfset filesDeleteIds = files_ids>

<cfloop list="#files_ids#" index="file_id">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="objectFile">
		<cfinvokeargument name="file_id" value="#file_id#">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="outputFileSmall">
		<cfinvokeargument name="fileQuery" value="#objectFile#">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="canUserDeleteFile" returnvariable="canUserDeleteFileResposne">
		<cfinvokeargument name="file_id" value="#file_id#">
		<cfinvokeargument name="fileQuery" value="#objectFile#">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>

	<cfif canUserDeleteFileResposne.result IS false>

		<cfset filesDeleteIds = listDeleteAt(filesDeleteIds, listFind(filesDeleteIds, file_id))>

		<div class="alert alert-warning" role="alert">
			#canUserDeleteFileResposne.message#
		</div>

	</cfif>


</cfloop>

<cfif isDefined("area_id")>
		<cfset return_page = "#return_path#files.cfm?area=#area_id#">
</cfif>

<cfif listLen(filesDeleteIds) GT 0>

  <form name="delete_files" method="post" action="#CGI.SCRIPT_NAME#" class="form-horizontal" style="clear:both;">

  	<input type="hidden" name="files_ids" value="#filesDeleteIds#">
		<input type="hidden" name="area_id" value="#area_id#">

    <cfif listLen(filesDeleteIds) GT 1>
  		<input type="submit" class="btn btn-primary" lang="es" value="Eliminar archivos" />
    <cfelse>
      <input type="submit" class="btn btn-primary" lang="es" value="Eliminar archivo" />
    </cfif>

  	<a href="#return_page#" class="btn btn-default" style="float:right;" lang="es">Cancelar</a>

  </form>

<cfelse>

	<div class="alert alert-danger" role="alert">
  	No puede eliminar el archivo o archivos seleccionados.
	</div>

	<a href="#return_page#" class="btn btn-default" lang="es">Cancelar</a>

</cfif>

<div style="height:10px;"><!-- --></div>

</cfoutput>
