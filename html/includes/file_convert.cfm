<div class="div_head_subtitle">
Visualizar archivo</div>

<!---<cftry>--->
	
	<!---<cfinclude template="#APPLICATION.path#/app/includes/convert_file.cfm">--->
	
	<!---checkParameters--->
	<cfif NOT isDefined("URL.file") OR NOT isDefined("URL.file_type")><!---No value given for one or more required parameters--->
		<cfset error_code = 610>
	
		<cfthrow errorcode="#error_code#">
	</cfif>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="convertFile" returnvariable="xmlResponse">
		<cfinvokeargument name="file_id" value="#URL.file#">
		<cfinvokeargument name="file_type" value="#URL.file_type#">
	</cfinvoke>
	
	<cfxml variable="xmlFileConvert">
		<cfoutput>
		#xmlResponse.response.result.file_convert#
		</cfoutput>
	</cfxml>
	
	<cfset message = xmlFileConvert.file_convert.message.xmlText>
	
	<cfoutput>
	<div class="alert">#message#</div>

	<div style="clear:both; padding-top:16px; margin-bottom:20px;">
		<cfif URL.file_type NEQ ".html">
				<div class="div_icon_menus"><a href="#APPLICATION.htmlPath#/file_converted_download.cfm?file=#URL.file#&file_type=#URL.file_type#" class="text_menus"><img src="#APPLICATION.htmlPath#/assets/icons/file_download.png" title="Descargar archivo" alt="Descargar archivo"/></a>
				</div>
				<div class="div_text_menus"><a href="#APPLICATION.htmlPath#/file_converted_download.cfm?file=#URL.file#&file_type=#URL.file_type#" class="text_menus"><br/>Descargar archivo #URL.file_type#</a></div>
		<cfelse>
			<div class="div_icon_menus"><a href="#APPLICATION.htmlPath#/file_converted_download.cfm?file=#URL.file#&file_type=#URL.file_type#" target="_blank"><img src="#APPLICATION.htmlPath#/assets/icons/view_file.gif"/></a></div>
		<div class="div_text_menus"><a href="#APPLICATION.htmlPath#/file_converted_download.cfm?file=#URL.file#&file_type=#URL.file_type#" class="text_menus" target="_blank"><br />Ver archivo</a></div>
		</cfif>
	</div>
	</cfoutput>
	
	<p style="margin-bottom:18px;">
	IMPORTANTE: el archivo generado puede no reproducir exactamente el contenido del original.<br/> Para una visualización detallada se recomienda ver el archivo original.
	</p>
	
	<!---<cfcatch>
		<cfinclude template="components/includes/errorHandler.cfm">
	</cfcatch>										
	
</cftry>--->