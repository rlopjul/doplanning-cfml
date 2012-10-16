<div class="div_head_subtitle">
Visualizar archivo</div>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="objectFile">
	<cfinvokeargument name="file_id" value="#file_id#">
</cfinvoke>

<cfoutput>
<!---<cfif objectFile.file_type EQ ".swf">

	<cfset width = "100%">
	<cfset height = "100%">
	
	<cfset name = "SWFLoader.swf">
	<cfset swf_name = "SWFLoader">

	<div style="clear:both">
	
	<!---	<script type="text/javascript">
		AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=7,0,19,0','width','#width#','height','#height#','src','#swf_name#','quality','high','pluginspage','http://www.macromedia.com/go/getflashplayer','movie','#swf_name#' ); //end AC code
		</script><noscript>---><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=7,0,19,0" width="#width#" height="#height#">
													<param name="movie" value="#name#" />
													<param name="quality" value="high" />
													<param name="SCALE" value="exactfit">
													<param name="FlashVars" value="loadPage=file_download.cfm?id=#objectFile.id#"/>
													<embed src="#name#" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="#width#" height="#height#" FlashVars="loadPage=file_download.cfm?id=#objectFile.id#"></embed></object><!---</noscript>--->
													
	
	</div>
<cfelseif listFind(".gif,.jpg,.png",objectFile.file_type) GT 0>--->
<cfif listFind(".gif,.jpg,.png",objectFile.file_type) GT 0>

	<img src="#APPLICATION.htmlPath#/file_download.cfm?id=#objectFile.id#" />	
	
</cfif>
</cfoutput>