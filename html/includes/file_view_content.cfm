<div class="div_head_subtitle">
<span lang="es">Visualizar archivo</span></div>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFile" returnvariable="objectFile">
	<cfinvokeargument name="file_id" value="#file_id#">
</cfinvoke>

<cfoutput>

<cfif app_version NEQ "mobile">
<div class="div_elements_menu">
	<cfif isDefined("area_id")>
	<a href="#APPLICATION.htmlPath#/area_file_view.cfm?file=#file_id#&area=#area_id#" title="Abrir en nueva ventana" target="_blank" class="btn btn-default btn-sm"><i class="icon-external-link"></i> <span lang="es">Ampliar</span></a>
	</cfif>
</div>
</cfif>
<div style="clear:both; height:5px;"><!-- --></div>

<div class="container-fluid" style="position:absolute;width:100%;left:0;">
	<div class="row">
		<div class="col-sm-12">
			<div id="imageDoubleScrollContainer">
				<cfif listFind(".gif,.jpg,.png",objectFile.file_type) GT 0>
					<cfif isDefined("area_id")>
						<img id="imageDoubleScroll" src="#APPLICATION.htmlPath#/file_download.cfm?id=#objectFile.id#&area=#area_id#" alt="#objectFile.name#" title="#objectFile.name#"/>
					<cfelse>
						<img id="imageDoubleScroll" src="#APPLICATION.htmlPath#/file_download.cfm?id=#objectFile.id#" alt="#objectFile.name#" title="#objectFile.name#"/>
					</cfif>
				</cfif>
			</div>
		</div>
	</div>
</div>

<div style="clear:both; height:10px;"><!-- --></div>

<script src="#APPLICATION.mainUrl#/jquery/jquery.doubleScroll.js"></script>
<script>
	$(document).ready(function() {

		$('##imageDoubleScrollContainer').doubleScroll({
				contentElement: "##imageDoubleScroll",
				onlyIfScroll: true, // top scrollbar is not shown if the bottom one is not present
				resetOnWindowResize: true
		});

	});

	$("##imageDoubleScroll").load(function() {

		$(window).resize(); // Para corregir bug que impide que se muestre el scroll horizontal superior

	});

</script>

</cfoutput>
