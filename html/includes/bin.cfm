<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8"></script>

<script src="#APPLICATION.htmlPath#/ckeditor/ckeditor.js?v=4.4.4.4"></script>
</cfoutput>

<script>
	
	$(window).load( function() {		
		
		$('#binTab a').click( function (e) {
			if(e.preventDefault)
		  		e.preventDefault();
				
		  	$(this).tab('show');
		})
		
	} );
	
</script>


<cfset url_return_page = "&return_page="&URLEncodedFormat("#APPLICATION.htmlPath#/iframes/bin.cfm")>

<div><!--- class="contenedor_fondo_blanco"--->

	<div class="container-fluid">

		<div class="row">
			<div class="col-sm-12">
				<cfinclude template="alert_message.cfm">
			</div>
		</div>

	</div>

	<cfif SESSION.user_id EQ SESSION.client_administrator>

	<div class="tabbable">

			
			<ul class="nav nav-tabs" id="binTab">
			  <li class="active"><a href="#tab1">Eliminados por mi</a></li>
			  <li><a href="#tab2">Todos los de la organización</a></li>
			</ul>


		<div class="tab-content">
	  
			<div class="tab-pane active" id="tab1"><!--- My items --->

	</cfif>		

				<!--- All deleted items --->
				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Bin" method="getAllBinItems" returnvariable="getMyItemsResult">
					<!---<cfif isDefined("limit_to") AND isNumeric(limit_to)>
					<cfinvokeargument name="limit" value="#limit_to#">
					</cfif>--->
					<cfinvokeargument name="delete_user_id" value="#SESSION.user_id#">
					<cfinvokeargument name="full_content" value="true">
				</cfinvoke>

				<cfset myItemsQuery = getMyItemsResult.query>
					
				<div class="navbar navbar-default navbar-static-top">
					<div class="container-fluid">
						
						<cfoutput>

						<cfif myItemsQuery.recordCount GT 0>
							<a href="#APPLICATION.htmlComponentsPath#/Bin.cfc?method=restoreBinItems&delete_user_id=#SESSION.user_id##url_return_page#" onclick="return confirmReversibleAction('restaurar');" class="btn btn-primary btn-sm navbar-btn"><i class="icon-undo icon-white"></i> Restaurar todo</a>	

							<a href="#APPLICATION.htmlComponentsPath#/Bin.cfc?method=deleteBinItems&delete_user_id=#SESSION.user_id##url_return_page#" onclick="return confirmAction('eliminar');" class="btn btn-danger btn-sm navbar-btn"><i class="icon-remove icon-white"></i> Eliminar todo definitivamente</a>
						</cfif>	

						<a href="#CGI.SCRIPT_NAME#" class="btn btn-default btn-sm navbar-btn navbar-right" style="margin-left:8px;"><i class="icon-refresh icon-white"></i></a>

						<p class="navbar-text navbar-right">#myItemsQuery.recordCount# elementos</p>	

						</cfoutput>

					</div>
				</div>

				<div class="container-fluid">

					<div class="row">
						<div class="col-sm-12" id="lastItemsContainer" style="overflow:auto;">

						<cfif myItemsQuery.recordCount GT 0>

							<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsFullList">
								<cfinvokeargument name="itemsQuery" value="#myItemsQuery#">
								<cfinvokeargument name="return_path" value="#APPLICATION.htmlPath#/iframes/">
								<cfinvokeargument name="showLastUpdate" value="false">
								<cfinvokeargument name="deletedItems" value="true">
							</cfinvoke>

						<cfelse>		

							<cfoutput>
							<p lang="es">No hay elementos</p>
							</cfoutput>

						</cfif>

						</div>
					</div>

				</div><!--- END container-fluid --->


	<cfif SESSION.user_id EQ SESSION.client_administrator>


			</div><!--- END tab1--->

			<!--- All deleted items --->
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Bin" method="getAllBinItems" returnvariable="getAllItemsResult">
				<cfinvokeargument name="full_content" value="true">
			</cfinvoke>

			<cfset itemsQuery = getAllItemsResult.query>

			<div class="tab-pane" id="tab2">

				
				<div class="navbar navbar-default navbar-static-top">
					<div class="container-fluid">
						
						<cfoutput>

						<cfif itemsQuery.recordCount GT 0>
							<a href="#APPLICATION.htmlComponentsPath#/Bin.cfc?method=restoreBinItems#url_return_page#" onclick="return confirmReversibleAction('restaurar');" class="btn btn-primary btn-sm navbar-btn"><i class="icon-undo icon-white"></i> Restaurar todo</a>	

							<a href="#APPLICATION.htmlComponentsPath#/Bin.cfc?method=deleteBinItems#url_return_page#" onclick="return confirmAction('eliminar');" class="btn btn-danger btn-sm navbar-btn"><i class="icon-remove icon-white"></i> Eliminar todo definitivamente</a>
						</cfif>	

						<a href="#CGI.SCRIPT_NAME#" class="btn btn-default btn-sm navbar-btn navbar-right" style="margin-left:8px;"><i class="icon-refresh icon-white"></i></a>	

						<p class="navbar-text navbar-right">#itemsQuery.recordCount# elementos</p>

						</cfoutput>

					</div>
				</div>

				<div class="container-fluid">

					<div class="row">
						<div class="col-sm-12" id="lastItemsContainer" style="overflow:auto;">

						<cfif itemsQuery.recordCount GT 0>

							<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsFullList">
								<cfinvokeargument name="itemsQuery" value="#itemsQuery#">
								<cfinvokeargument name="return_path" value="#APPLICATION.htmlPath#/iframes/">
								<cfinvokeargument name="showLastUpdate" value="false">
								<cfinvokeargument name="deletedItems" value="true">
							</cfinvoke>

						<cfelse>		

							<cfoutput>
							<p lang="es">No hay elementos</p>
							</cfoutput>

						</cfif>

						</div>
					</div>

				</div><!--- END container-fluid --->


			</div><!--- END tab2--->




		</div><!--- END tab-content --->

	</div><!--- END tabbable --->


	</cfif>

	
</div><!--- END contenedor_fondo_blanco --->