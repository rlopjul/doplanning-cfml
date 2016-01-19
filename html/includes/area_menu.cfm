<cfoutput>
<!---<script src="#APPLICATION.htmlPath#/language/area_menu_en.js?v=1" charset="utf-8"></script>--->
<script src="#APPLICATION.path#/jquery/jquery-shorten/jquery.shorten.min.js"></script>

<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="loggedUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
</cfinvoke>--->


<cfif isDefined("area_id")>

	<cfinclude template="#APPLICATION.htmlPath#/includes/app_page_head.cfm">

	<cfinclude template="#APPLICATION.htmlPath#/includes/area_path.cfm">

	<cfif isDefined("areaInfoEnabled") AND areaInfoEnabled IS true>

		<!---subAreas--->
		<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>
		<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreas" returnvariable="subAreasQuery">
			<cfinvokeargument name="area_id" value="#area_id#">
			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>
		<cfif subAreasQuery.recordCount GT 0>

			<cfif subAreasQuery.recordCount GT 20>
				<div class="row">
					<div class="col-sm-12">
						<a class="btn btn-default btn-sm" role="button" data-toggle="collapse" href="~##collapseSubAreas" aria-expanded="false" aria-controls="collapseSubAreas" style="margin-bottom:8px;"><i class="fa fa-plus-square-o"></i> <span lang="es">Mostrar subareas</span> <span class="label label-primary label-as-badge">#subAreasQuery.recordCount#</span></a>
					</div>
				</div>
			</cfif>

			<div class="row">
				<div class="col-sm-12">

					<div <cfif subAreasQuery.recordCount GT 20>class="collapse"</cfif> id="collapseSubAreas">
						<ul class="list-group list-inline" id="subareas_list">
						<cfloop query="subAreasQuery">
							<li class="list-group-item">
							  	<a href="area_items.cfm?area=#subAreasQuery.id#"><img src="#APPLICATION.htmlPath#/assets/v3/icons_dp/area_small.png" alt="Área" title="Área" lang="es"/>&nbsp;&nbsp;#subAreasQuery.name#</a>
							</li>
						</cfloop>
						</ul>
					</div>


				</div>
			</div>
		</cfif>

		<cfinclude template="#APPLICATION.htmlPath#/includes/area_menu_info.cfm">

	</cfif>



</cfif><!---END isDefined("area_id")--->

<!---<div style="clear:both; height:2px;"></div>--->

</cfoutput>
