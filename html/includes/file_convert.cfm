<div class="div_head_subtitle">
Visualizar archivo</div>

<!---<cftry>--->

	<!---<cfinclude template="#APPLICATION.path#/app/includes/convert_file.cfm">--->

	<!---checkParameters--->
	<cfif NOT isDefined("URL.file") OR NOT isDefined("URL.file_type")><!---No value given for one or more required parameters--->
		<cfset error_code = 610>

		<cfthrow errorcode="#error_code#">
	</cfif>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="convertFile" returnvariable="convertFileResponse">
		<cfinvokeargument name="file_id" value="#URL.file#">
		<cfinvokeargument name="file_type" value="#URL.file_type#">
	</cfinvoke>

	<cfset message = convertFileResponse.message>

	<cfset open_file = "">

	<cfif URL.file_type EQ ".pdf">
		<cfset open_file = "&open=1">
	</cfif>

	<cfset download_url = "#APPLICATION.htmlPath#/file_converted_download.cfm?file=#URL.file#&file_type=#URL.file_type##open_file#">

	<cfif convertFileResponse.result IS true AND URL.file_type EQ ".pdf">

		<cflocation url="#download_url#" addtoken="false">

	</cfif>

	<cfif convertFileResponse.result IS true>

		<cfoutput>
		<div class="alert alert-info">#message#</div>

		<div style="clear:both; padding-top:10px; margin-bottom:20px;">

			<cfif URL.file_type NEQ ".html">

					<a href="#download_url##open_file#" class="btn btn-default"><i class="fa fa-eye" aria-hidden="true"></i> <span lang="es">Ver archivo</span></a>

					<!---<div class="div_icon_menus"><a href="#APPLICATION.htmlPath#/file_converted_download.cfm?file=#URL.file#&file_type=#URL.file_type#" class="text_menus"><img src="#APPLICATION.htmlPath#/assets/v3/icons/file_download.png" title="Descargar archivo" alt="Descargar archivo"/></a>
					</div>
					<div class="div_text_menus"><a href="#APPLICATION.htmlPath#/file_converted_download.cfm?file=#URL.file#&file_type=#URL.file_type#" class="text_menus"><br/>Descargar archivo #URL.file_type#</a></div>--->
			<cfelse>

				<div class="div_icon_menus"><a href="#download_url#" target="_blank"><img src="#APPLICATION.htmlPath#/assets/v3/icons/view_file.gif"/></a></div>
				<div class="div_text_menus"><a href="#download_url#" class="text_menus" target="_blank"><br />Ver archivo</a></div>

			</cfif>

		</div>
		</cfoutput>

		<p style="margin-bottom:18px;">
		IMPORTANTE: el archivo generado puede no reproducir exactamente el contenido del original.<br/> Para una visualización detallada se recomienda ver el archivo original.
		</p>

	<cfelse>

		<div class="alert alert-danger">#message#</div>

	</cfif>

	<!---<cfcatch>
		<cfinclude template="components/includes/errorHandler.cfm">
	</cfcatch>

</cftry>--->
