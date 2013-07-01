<cfif export IS true>

	<cfinclude template="page_query.cfm">
	
</cfif>

<cfset page_empty = true>

<cfinclude template="#APPLICATION.path#/templates_pages/udfs.cfm">

<cfoutput>

<!---Noticias--->
<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getAreaItems" returnvariable="getAreaNewsResult">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="itemTypeId" value="4">
	<cfinvokeargument name="format_content" value="all">
	<cfinvokeargument name="listFormat" value="true">
	<cfinvokeargument name="limit" value="100000000000000">
	<cfinvokeargument name="offset" value="5">
					
	<cfinvokeargument name="client_abb" value="#clientAbb#">
	<cfinvokeargument name="client_dsn" value="#clientDsn#">
</cfinvoke>

<cfset areaNewsQuery = getAreaNewsResult.query>

<cfif areaNewsQuery.recordCount GT 0>

	<cfif page_empty IS false>
	<div class="separador_items"></div>
	<p><span class="link_16px">Noticias</span></p>
	</cfif>
	
	<cfset page_empty = false>
	
	<cfloop query="areaNewsQuery">
		
		<cfset news_url = titleToUrl(areaNewsQuery.title)>
	
		<div style="margin-top:10px; margin-bottom:10px;">
			<table border="0" cellpadding="0" cellspacing="0" style="width:100%;">
			  <tr>
				<cfif isNumeric(areaNewsQuery.attached_image_id)><td width="16%">
				<cfif export IS false>
				<img src="download_file.cfm?file=#areaNewsQuery.attached_image_id#&news=#areaNewsQuery.id#" width="108" />
				<cfelse>
				<img src="file:///#APPLICATION.filesPath#/#clientAbb#/files/#areaNewsQuery.attached_image_id#" width="108" />
				</cfif>
				</td>
				<td width="2%">&nbsp;</td><td width="82%">
				<cfelse>
				<td>
				</cfif>
				<div class="text_date" style="background-color:##F5F5F5;">#DateFormat(areaNewsQuery.creation_date,"dd/mm/yyyy")#</div>				
				<a href="noticia.cfm?id=#areaNewsQuery.id#&title=#news_url#" class="subtitle">#areaNewsQuery.title#</a>
				<div style="font-size:12px; padding-top:1px;"><cfif len(areaNewsQuery.description) GT 250>#leftToNextSpace(areaNewsQuery.description, 250)#...<cfelse>#areaNewsQuery.description#</cfif></div>
			
				</td>
			  </tr>
			</table>
			<div style="text-align:right;"><a href="noticia.cfm?id=#areaNewsQuery.id#&title=#news_url#" class="link_min">Leer noticia completa</a></div><!---border-bottom-style:solid; border-bottom-color:##CCCCCC; border-bottom-width:1px;--->
		</div>
	</cfloop>
	
	<a href="page.cfm?id=#area_id#" class="link_bold_14px">Noticias recientes</a>
	
</cfif>

<cfif export IS false AND page_empty IS NOT true>
<div style="height:20px; clear:both"><!-- --></div>
<div style="float:right">
	<form name="print_pdf" action="generate_pdf.cfm?#CGI.QUERY_STRING#" method="post" target="_blank" style="border:0;">
		<input type="hidden" name="page" value="list_news.cfm" />
		<input type="hidden" name="parent_area_id" value="#parent_area_id#" />
		<input type="hidden" name="url" value="#getFileFromPath(CGI.SCRIPT_NAME)#?#CGI.QUERY_STRING#"/>
		<input type="image" name="pdf" value="PDF" title="Haga click para obtener el PDF de esta página" src="#APPLICATION.path#/assets/pdf.png"/>
	</form>
</div>
</cfif>

</cfoutput>