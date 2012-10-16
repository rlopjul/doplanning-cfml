<cfif export IS true>

	<cfinclude template="page_query.cfm">
	
</cfif>

<cfset page_empty = true>

<cfinclude template="#APPLICATION.path#/templates_pages/udfs.cfm">

<cfoutput>

<!---Eventos--->
<cfinvoke component="#APPLICATION.componentsPath#/components/AreaItemQuery" method="getAreaItems" returnvariable="getAreaEventsResult">
	<cfinvokeargument name="area_id" value="#area_id#">
	<cfinvokeargument name="itemTypeId" value="5">
	<cfinvokeargument name="format_content" value="all">
	<cfinvokeargument name="listFormat" value="true">
	<cfinvokeargument name="limit" value="100000000000000">
	<cfinvokeargument name="offset" value="5">
					
	<cfinvokeargument name="client_abb" value="#clientAbb#">
	<cfinvokeargument name="client_dsn" value="#clientDsn#">
</cfinvoke>

<cfset areaEventsQuery = getAreaEventsResult.query>

<cfif areaEventsQuery.recordCount GT 0>

	<cfif page_empty IS false>
	<div class="separador_items"></div>
	<p><span class="link_16px">Eventos</span></p>
	</cfif>
	
	<cfset page_empty = false>
	
	<cfloop query="areaEventsQuery">
	
		<cfset events_url = titleToUrl(areaEventsQuery.title)>
		
		<div style="margin-top:20px; margin-bottom:20px;">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			  <tr>
				<cfif isNumeric(areaEventsQuery.attached_image_id)><td width="16%">
				<cfif export IS false>
				<img src="download_file.cfm?file=#areaEventsQuery.attached_image_id#&event=#areaEventsQuery.id#" width="108" alt="Imagen evento" />
				<cfelse>
				<img src="file:///#APPLICATION.filesPath#/#clientAbb#/files/#areaEventsQuery.attached_image_id#" width="108" alt="Imagen evento" />
				</cfif>
				</td>
				<td width="2%">&nbsp;</td><td width="82%">
				<cfelse>
				<td>
				</cfif><p class="text_date">
				<cfif areaEventsQuery.start_date NEQ areaEventsQuery.end_date>
				#DateFormat(areaEventsQuery.start_date,"dd/mm/yyyy")# - #DateFormat(areaEventsQuery.end_date,"dd/mm/yyyy")#
				<cfelse>
				#DateFormat(areaEventsQuery.start_date,"dd/mm/yyyy")#
				</cfif></p>
				<a href="evento.cfm?id=#areaEventsQuery.id#&title=#events_url#" class="subtitle">#areaEventsQuery.title#</a>
				<p><a href="evento.cfm?id=#areaEventsQuery.id#&title=#events_url#" class="link_min">Ver evento</a></p>
				</td>
			  </tr>
			</table>
		</div>
	</cfloop>
	
	
	<a href="page.cfm?id=#area_id#" class="link_bold_14px">Eventos recientes</a>

</cfif>

<cfif export IS false AND page_empty IS NOT true>
<div style="height:20px; clear:both"><!-- --></div>
<div style="float:right">
	<form name="print_pdf" action="generate_pdf.cfm?#CGI.QUERY_STRING#" method="post" target="_blank" style="border:0;">
		<input type="hidden" name="page" value="list_events.cfm" />
		<input type="hidden" name="parent_area_id" value="#parent_area_id#" />
		<input type="hidden" name="url" value="#getFileFromPath(CGI.SCRIPT_NAME)#?#CGI.QUERY_STRING#"/>
		<input type="image" name="pdf" value="PDF" title="Haga click para obtener el PDF de esta página" src="#APPLICATION.path#/assets/pdf.png"/>
	</form>
</div>
</cfif>

</cfoutput>