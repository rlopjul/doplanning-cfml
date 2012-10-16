<cfif export IS true>

	<cfinclude template="item_query.cfm">
	
</cfif>

<cfoutput>
<h1 class="title">#getItem.title#</h1>
<cfif itemTypeId IS 4><!---News--->
<p class="text_date">#DateFormat(getItem.creation_date,"dd/mm/yyyy")#</p><br />
<cfelse><!---Events--->
<p class="text_date"><cfif len(getItem.place) GT 0>#getItem.place#, </cfif>#DateFormat(getItem.start_date,"dd/mm/yyyy")# - #DateFormat(getItem.end_date,"dd/mm/yyyy")#</p><br />
</cfif>
<!---<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td width="108"><img src="../assets/img1.jpg" alt="ASNC" title="ASNC" /></td>
	<td style="width:20px;">&nbsp;</td>
	<td><p class="text_date">#DateFormat(getItem.creation_date,"dd/mm/yyyy")#</p>
	<p class="subtitle">#getItem.title#</p></td>
  </tr>
</table><br />--->
<cfif isNumeric(getItem.attached_image_id)>
<cfif export IS false>
<img src="#APPLICATION.path#/#areaTypeRequired#/download_file.cfm?file=#getItem.attached_image_id#&#itemTypeName#=#item_id#" alt="Imagen #itemTypeNameEs#" style="float:left;margin-right:10px; margin-bottom:5px;" />
<cfelse>
<img src="file:///#APPLICATION.filesPath#/#clientAbb#/files/#getItem.attached_image_id#" alt="Imagen #itemTypeNameEs#" style="float:left;margin-right:10px; margin-bottom:5px;" />
</cfif>
</cfif>
<div class="item_description">#getItem.description#</div><br />

<cfif len(getItem.link) GT 0 OR isNumeric(getItem.attached_file_id)>
<div style="clear:both;"><span class="title_bold_14px">Más información:</span></div>
		
<ul class="lista_contenidos">
	<cfif len(getItem.link) GT 0>
	<li><a href="#getItem.link#" class="link" target="_blank">#getItem.link#</a></li>
	</cfif>
	<cfif isNumeric(getItem.attached_file_id)>
	<li><a href="download_file.cfm?file=#getItem.attached_file_id#&#itemTypeName#=#item_id#" class="link">#getItem.attached_file_name#</a></li>
	</cfif>
</ul>
</cfif>

<!---Iframe--->
<cfif export IS false AND len(getItem.iframe_url) GT 0>
	<cfif getItem.iframe_display_type IS 1>
		<iframe width="100%" height="400" src="#getItem.iframe_url#" frameborder="0" allowfullscreen></iframe>			
	<cfelse>
		<iframe width="560" height="315" src="#getItem.iframe_url#" frameborder="0" allowfullscreen></iframe>
	</cfif>
</cfif>
<!---END Iframe--->

<cfif export IS false>
<div style="height:35px; clear:both"><!-- --></div>
<cfif areaTypeRequired EQ "web">
	<div style="float:left;">
		<!-- AddThis Button BEGIN -->
		<div class="addthis_toolbox addthis_default_style addthis_32x32_style">
		<a class="addthis_button_preferred_1"></a>
		<a class="addthis_button_preferred_2"></a>
		<a class="addthis_button_preferred_3"></a>
		<a class="addthis_button_preferred_4"></a>
		<a class="addthis_button_compact"></a>
		<a class="addthis_counter addthis_bubble_style"></a>
		</div>
		<script type="text/javascript">var addthis_config = {"data_track_addressbar":true};</script>
		<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js##pubid=#APPLICATION.addThisProfileId#"></script>
		<!-- AddThis Button END -->
	</div>
</cfif>
<div style="float:right">
	<form name="print_pdf" action="generate_pdf.cfm?#CGI.QUERY_STRING#" method="post" target="_blank" style="border:0;">
		<input type="hidden" name="page" value="item_content.cfm" />
		<input type="hidden" name="itemTypeId" value="#itemTypeId#" />
		<input type="hidden" name="url" value="#getFileFromPath(CGI.SCRIPT_NAME)#?#CGI.QUERY_STRING#"/>
		<input type="image" name="pdf" value="PDF" title="Haga click para obtener el PDF de esta página" src="#APPLICATION.path#/assets/pdf.png"/>
	</form>
</div>
</cfif>
</cfoutput>