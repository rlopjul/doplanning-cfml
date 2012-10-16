<cfif export IS true>

	<cfinclude template="page_query.cfm">
	
</cfif>

<cfset page_empty = true>

<cfinclude template="#APPLICATION.path#/templates_pages/udfs.cfm">


<cfoutput>
<cfif export IS false>
	<cfif areaTypeRequired EQ "web">
		
		<div style="float:right;width:105px;"><!------>
			<!-- AddThis Button BEGIN -->
			<div class="addthis_toolbox addthis_default_style ">
			<a class="addthis_button_preferred_1"></a>
			<a class="addthis_button_preferred_2"></a>
			<a class="addthis_button_preferred_3"></a>
			<a class="addthis_button_preferred_4"></a>
			<a class="addthis_button_compact"></a>
			<!---<a class="addthis_counter addthis_bubble_style"></a>--->
			</div>
			<script type="text/javascript">var addthis_config = {"data_track_addressbar":true};</script>
			<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js##pubid=#APPLICATION.addThisProfileId#"></script>
			<!-- AddThis Button END -->
		</div>
		<a href="rss_page.cfm?id=#area_id#" target="_blank" style="float:right;"><img src="../assets/rss_small.jpg" alt="RSS de esta página" title="RSS de esta página" /></a>
	
	</cfif>
</cfif>
<h1 class="title">#area_name#</h1><br />

<cfif parent_area_id IS 497>
<p style="font-size:14px">#getArea.description#</p>
<div style="height:15px;"><!-- --></div>
</cfif>


<!---Entradas--->
<cfinvoke component="#APPLICATION.componentsPath#/components/AreaItemQuery" method="getAreaItems" returnvariable="getAreaEntriesResult">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="itemTypeId" value="2">
	<cfinvokeargument name="format_content" value="all">
	<cfinvokeargument name="listFormat" value="true">
					
	<cfinvokeargument name="client_abb" value="#clientAbb#">
	<cfinvokeargument name="client_dsn" value="#clientDsn#">
</cfinvoke>

<cfset areaEntriesQuery = getAreaEntriesResult.query>

<cfif areaEntriesQuery.recordCount GT 0>
	
	<cfset page_empty = false>
	
	<cfloop query="areaEntriesQuery">
			
		<cfif areaEntriesQuery.display_type IS 2><!---Lista--->
			<cfset item_content_margin_left = "20px">
		<cfelse>
			<cfset item_content_margin_left = "0">
		</cfif>
		
		<div style="clear:both; margin-bottom:20px;">
			<a name="entry-#areaEntriesQuery.id#"></a>
			<cfif areaEntriesQuery.display_type IS 2><!---Lista---><img src="../assets/bullet.jpg" alt="List item" style="margin-right:10px;"/></cfif><span class="subtitle">#areaEntriesQuery.title#</span>
			
			<div style="margin-left:#item_content_margin_left#"><!---div item content--->
			
			<cfif areaEntriesQuery.display_type IS 1 OR areaEntriesQuery.display_type IS 2 OR areaEntriesQuery.display_type IS 3 OR areaEntriesQuery.display_type IS 4><!---Imagen a la izquierda o a la derecha o listado de elementos--->
				
				<cfif areaEntriesQuery.display_type IS 3>
					<cfset image_position = "right">
					<cfset image_margin = "left">
				<cfelse>
					<cfset image_position = "left">
					<cfset image_margin = "right">
				</cfif>
				
			
				<div class="item_description">
				<cfif isNumeric(areaEntriesQuery.attached_image_id)>
					<cfif export IS false>
						<img src="download_file.cfm?file=#areaEntriesQuery.attached_image_id#&amp;entry=#areaEntriesQuery.id#" alt="#areaEntriesQuery.title#" title="#areaEntriesQuery.title#" style="float:#image_position#; margin-top:5px; margin-#image_margin#:10px; margin-bottom:5px;" />
					<cfelse>
						<img src="file:///#APPLICATION.filesPath#/#clientAbb#/files/#areaEntriesQuery.attached_image_id#" alt="#areaEntriesQuery.title#" title="#areaEntriesQuery.title#" style="float:#image_position#; margin-top:5px; margin-#image_margin#:10px; margin-bottom:5px;" />
					</cfif>
				</cfif>#areaEntriesQuery.description#</div>
				
			
			<cfelseif areaEntriesQuery.display_type IS 5><!---Figura con pie--->
				
				<div style="text-align:center;">
				<cfif isNumeric(areaEntriesQuery.attached_image_id)>
					<cfif export IS false>
						<img src="download_file.cfm?file=#areaEntriesQuery.attached_image_id#&amp;entry=#areaEntriesQuery.id#" alt="#areaEntriesQuery.title#" title="#areaEntriesQuery.title#" style="clear:both; margin-top:5px; text-align:center;" />
					<cfelse>
						<img src="file:///#APPLICATION.filesPath#/#clientAbb#/files/#areaEntriesQuery.attached_image_id#" alt="#areaEntriesQuery.title#" title="#areaEntriesQuery.title#" style="clear:both; margin-top:5px; text-align:center;" />
					</cfif>
				</cfif>
				</div>
				<div class="item_description">#areaEntriesQuery.description#</div>
			
			</cfif>
			
			<cfif len(areaEntriesQuery.link) GT 0>
			<a href="#areaEntriesQuery.link#" class="link" target="_blank">#areaEntriesQuery.link#</a>
			</cfif>
			
			<cfif isNumeric(areaEntriesQuery.attached_file_id)>
				<p>Archivo: <a href="download_file.cfm?file=#areaEntriesQuery.attached_file_id#&amp;entry=#areaEntriesQuery.id#" class="link">#areaEntriesQuery.attached_file_name#</a>&nbsp;<a href="download_file.cfm?file=#areaEntriesQuery.attached_file_id#&amp;entry=#areaEntriesQuery.id#" class="link"><img src="../assets/download_document.png" alt="Descargar documento" title="Descargar documento" /></a></p>
			</cfif>
			
			<cfif len(areaEntriesQuery.iframe_url) GT 0>
				<cfif areaEntriesQuery.iframe_display_type IS 1>
					<iframe width="100%" height="400" src="#areaEntriesQuery.iframe_url#" frameborder="0" allowfullscreen></iframe>			
				<cfelse>
					<iframe width="560" height="315" src="#areaEntriesQuery.iframe_url#" frameborder="0" allowfullscreen></iframe>
				</cfif>
			</cfif>
			
			</div><!---END div item content--->
		</div>
		
	</cfloop>
	
</cfif>




<!---Noticias--->
<cfinvoke component="#APPLICATION.componentsPath#/components/AreaItemQuery" method="getAreaItems" returnvariable="getAreaNewsResult">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="itemTypeId" value="4">
	<cfinvokeargument name="format_content" value="all">
	<cfinvokeargument name="listFormat" value="true">
	<cfinvokeargument name="limit" value="5">
					
	<cfinvokeargument name="client_abb" value="#clientAbb#">
	<cfinvokeargument name="client_dsn" value="#clientDsn#">
</cfinvoke>

<cfset areaNewsQuery = getAreaNewsResult.query>

<cfif areaNewsQuery.recordCount GT 0>

	<cfif page_empty IS false>
	<div class="separador_items"></div>
	<h2 class="subtitle_16px">Noticias</h2>
	</cfif>
	
	<cfset page_empty = false>
	
	<cfloop query="areaNewsQuery">
		
		<cfset news_url = titleToUrl(areaNewsQuery.title)>
		
		<div style="margin-top:10px; margin-bottom:10px;">
			<table border="0" cellpadding="0" cellspacing="0" style="width:100%;">
			  <tr>
				<cfif isNumeric(areaNewsQuery.attached_image_id)><td style="width:16%">
				<cfif export IS false>
				<img src="download_file.cfm?file=#areaNewsQuery.attached_image_id#&amp;news=#areaNewsQuery.id#" width="108" alt="#areaNewsQuery.title#" />
				<cfelse>
				<img src="file:///#APPLICATION.filesPath#/#clientAbb#/files/#areaNewsQuery.attached_image_id#" width="108" alt="#areaNewsQuery.title#" />
				</cfif>
				</td>
				<td style="width:2%">&nbsp;</td><td style="width:82%">
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
	
	<cfif getAreaNewsResult.count GT 5>
		<div style="padding-top:10px;"><a href="noticias_anteriores.cfm?id=#area_id#" class="link_bold_14px">Noticias anteriores</a></div>
	</cfif>
	
</cfif>



<!---Eventos--->
<cfinvoke component="#APPLICATION.componentsPath#/components/AreaItemQuery" method="getAreaItems" returnvariable="getAreaEventsResult">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="itemTypeId" value="5">
	<cfinvokeargument name="format_content" value="all">
	<cfinvokeargument name="listFormat" value="true">
					
	<cfinvokeargument name="client_abb" value="#clientAbb#">
	<cfinvokeargument name="client_dsn" value="#clientDsn#">
</cfinvoke>

<cfset areaEventsQuery = getAreaEventsResult.query>

<cfif areaEventsQuery.recordCount GT 0>

	<cfif page_empty IS false>
	<div class="separador_items"></div>
	<h2 class="subtitle_16px">Eventos</h2>
	</cfif>
	
	<cfset page_empty = false>
	
	<cfloop query="areaEventsQuery">
		<cfset event_url = titleToUrl(areaEventsQuery.title)>
	
		<div style="margin-top:20px; margin-bottom:20px;">
			<table border="0" cellpadding="0" cellspacing="0" style="width:100%">
			  <tr>
				<cfif isNumeric(areaEventsQuery.attached_image_id)><td style="width:16%">
				<cfif export IS false>
				<img src="download_file.cfm?file=#areaEventsQuery.attached_image_id#&amp;event=#areaEventsQuery.id#" width="108" alt="#areaEventsQuery.title#" />
				<cfelse>
				<img src="file:///#APPLICATION.filesPath#/#clientAbb#/files/#areaEventsQuery.attached_image_id#" width="108" alt="#areaEventsQuery.title#" />
				</cfif>
				</td>
				<td style="width:2%">&nbsp;</td><td style="width:82%">
				<cfelse>
				<td>
				</cfif><p class="text_date">
				<cfif len(areaEventsQuery.place) GT 0>#areaEventsQuery.place#, </cfif>
				<cfif areaEventsQuery.start_date NEQ areaEventsQuery.end_date>
				#DateFormat(areaEventsQuery.start_date,"dd/mm/yyyy")# - #DateFormat(areaEventsQuery.end_date,"dd/mm/yyyy")#
				<cfelse>
				#DateFormat(areaEventsQuery.start_date,"dd/mm/yyyy")#
				</cfif></p>
				<a href="evento.cfm?id=#areaEventsQuery.id#&title=#event_url#" class="subtitle">#areaEventsQuery.title#</a>
				<p><a href="evento.cfm?id=#areaEventsQuery.id#&title=#event_url#" class="link_min">Ver evento</a></p>
				</td>
			  </tr>
			</table>
		</div>
	</cfloop>
	
	<cfif getAreaNewsResult.count GT 5>
		<div style="padding-top:10px;"><a href="eventos_anteriores.cfm?id=#area_id#" class="link_bold_14px">Eventos anteriores</a></div>
	</cfif>

</cfif>


<!---Enlaces--->
<cfif APPLICATION.identifier EQ "vpnet">

	<cfinvoke component="#APPLICATION.componentsPath#/components/AreaItemQuery" method="getAreaItems" returnvariable="getAreaLinksResult">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfinvokeargument name="itemTypeId" value="3">
		<cfinvokeargument name="format_content" value="all">
		<cfinvokeargument name="listFormat" value="true">
						
		<cfinvokeargument name="client_abb" value="#clientAbb#">
		<cfinvokeargument name="client_dsn" value="#clientDsn#">
	</cfinvoke>
	
	<cfset areaLinksQuery = getAreaLinksResult.query>
	
	<cfif areaLinksQuery.recordCount GT 0>
	
		<cfif page_empty IS false>
		<div class="separador_items"></div>
		<h2 class="subtitle_16px">Enlaces</h2><br />
		</cfif>
		
		<cfset page_empty = false>
		
		<ul class="lista_contenidos">
			<cfloop query="areaLinksQuery">
		
				<li><a name="link-#areaLinksQuery.id#"></a><a href="#areaLinksQuery.link#" class="link" target="_blank" rel="nofollow">#areaLinksQuery.title#</a> &nbsp; <a href="#areaLinksQuery.link#" class="link" target="_blank" rel="nofollow"><img src="../assets/enlace.png" alt="Enlace" title="Enlace" /></a>
				<p>#areaLinksQuery.description#</p><br />
				</li>
			
			</cfloop>
		</ul>
			
	</cfif>
	
</cfif>

<!---Documentos--->
<cfinvoke component="#APPLICATION.componentsPath#/components/FileQuery" method="getAreaFiles" returnvariable="areaFilesQuery">
	<cfinvokeargument name="area_id" value="#area_id#">

	<cfinvokeargument name="client_abb" value="#clientAbb#">
	<cfinvokeargument name="client_dsn" value="#clientDsn#">
</cfinvoke>

<cfif areaFilesQuery.recordCount GT 0>

	<cfif page_empty IS false>
	<div class="separador_items"></div>
	<h2 class="subtitle_16px">Documentos</h2><br />
	</cfif>
	
	<cfset page_empty = false>
	
	<cfloop query="areaFilesQuery">
		<cfset cur_file_size = areaFilesQuery.file_size>
		
		<cfset file_size_kb = Fix(areaFilesQuery.file_size/1024)>
		<cfif file_size_kb IS 0>
			<cfset file_size_kb = 1>
		</cfif>
		<cfset file_size_kb = file_size_kb&" KB">
		
		<cfif cur_file_size LT (1024*1024)><!---File size is LT a mega byte--->
			<cfset cur_file_size = file_size_kb>
		<cfelse>
		
			<cfset cur_file_size = cur_file_size/(1024*1024)>
			<cfset cur_file_size = round(cur_file_size*100)/100>
			
			<cfset cur_file_size = file_size&" MB">
			
		</cfif>
	
		<div class="div_documents">
		<a name="document-#areaFilesQuery.id#"></a>
		<a href="download_file.cfm?file=#areaFilesQuery.id#&amp;area=#area_id#" class="link">#areaFilesQuery.name#</a> (#areaFilesQuery.file_type#, #cur_file_size#) &nbsp; <a href="download_file.cfm?file=#areaFilesQuery.id#&amp;area=#area_id#" class="link"><img src="../assets/download_document.png" alt="Descargar documento" title="Descargar documento" /></a>
			<p>#areaFilesQuery.description#</p>
		</div>
	</cfloop>
	<!---<div class="div_documents">
				<a href="##" class="link">Lorem ipsum dolor sit amet, consectetur adipiscing elit</a> (PDF, 3MB) &nbsp; <img src="../assets/download_document.png" alt="Descargar documento" title="Descargar documento" />
				<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.
	Integer a enim at mauris placerat iaculis.</p>
	</div>--->
</cfif>


<cfif export IS false AND page_empty IS NOT true>
<div style="height:20px; clear:both"><!-- --></div>
<div style="float:right">
	<form name="print_pdf" action="generate_pdf.cfm?#CGI.QUERY_STRING#" method="post" target="_blank" style="border:0;">
		<input type="hidden" name="page" value="page_content.cfm" />
		<input type="hidden" name="parent_area_id" value="#parent_area_id#" />
		<input type="hidden" name="url" value="#getFileFromPath(CGI.SCRIPT_NAME)#?#CGI.QUERY_STRING#"/>
		<input type="image" name="pdf" value="PDF" title="Haga click para obtener el PDF de esta página" alt="Obtener PDF de esta página" src="#APPLICATION.path#/assets/pdf.png"/>
	</form>
</div>
</cfif>

</cfoutput>