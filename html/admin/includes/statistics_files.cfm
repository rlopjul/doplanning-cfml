<cfif isDefined("URL.from_date")>
	<cfset from_date = URL.from_date>
<cfelse>
	<cfset from_date = "">
</cfif>

<cfif isDefined("URL.end_date")>
	<cfset end_date = URL.end_date>
<cfelse>
	<cfset end_date = "">
</cfif>

<cfif isDefined("URL.from_user") AND isNumeric(URL.from_user)>
	<cfset user_in_charge = URL.from_user>
<cfelse>
	<cfset user_in_charge = "">
</cfif>

<cfif isDefined("URL.download_user") AND isNumeric(URL.download_user)>
	<cfset download_user_id = URL.download_user>
<cfelse>
	<cfset download_user_id = "">
</cfif>

<!--- getFilesDownloads --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFilesDownloads" returnvariable="filesDownloadsResponse">
	<cfinvokeargument name="parse_dates" value="true">
	<cfif len(from_date) GT 0>
		<cfinvokeargument name="from_date" value="#from_date#"/>
	</cfif>
	<cfif len(end_date) GT 0>
		<cfinvokeargument name="end_date" value="#end_date#"/>
	</cfif>
	<cfif len(user_in_charge) GT 0>
		<cfinvokeargument name="user_in_charge" value="#user_in_charge#"/>
	</cfif>
	<cfif len(download_user_id) GT 0>
		<cfinvokeargument name="download_user_id" value="#download_user_id#"/>
	</cfif>
</cfinvoke>

<cfset filesDownloadsQuery = filesDownloadsResponse.query>

<cfoutput>
<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">
<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
<script src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>
<script src="#APPLICATION.htmlPath#/scripts/tablesFunctions.js?v=2"></script>
</cfoutput>

<script>

	$(function() {

		$('#from_date').datepicker({
		  format: 'dd-mm-yyyy',
		  autoclose: true,
		  weekStart: 1,
		  language: 'es',
		  todayBtn: 'linked',
		  endDate: $('#end_date').val()
		});

		$('#end_date').datepicker({
		  format: 'dd-mm-yyyy',
		  weekStart: 1,
		  language: 'es',
		  todayBtn: 'linked',
		  autoclose: true
		});

	});


	function setEndDate(){
		$('#from_date').datepicker('setEndDate', $('#end_date').val());
	}

	function setFromDate(){
		$('#end_date').datepicker('setStartDate', $('#from_date').val());
	}

	<cfoutput>
	function openUserSelectorWithField(fieldName){

		return openPopUp('#APPLICATION.htmlPath#/iframes/users_select.cfm?field='+fieldName);

	}
	</cfoutput>

</script>

<div class="container">

	<div class="row">
		<div class="col-sm-12">
			<div class="div_message_page_title" lang="es">Estadísticas de descarga de archivos</div>
		</div>
	</div>

	<cfoutput>
	<div class="row">
		<div class="col-sm-12">

			<div class="div_search_bar">

				<form method="get" name="statistics_form" action="#CGI.SCRIPT_NAME#" class="form-horizontal">

					<div class="row">

						<label for="from_date" class="col-xs-5 col-sm-3 control-label" lang="es"><i class="icon-calendar"></i>&nbsp;&nbsp;<span lang="es">Fecha desde</span></label>

						<div class="col-xs-7 col-sm-9">
							<input type="text" name="from_date" id="from_date" class="form-control input_datepicker" value="#from_date#" onchange="setFromDate()">
						</div>

					</div>

					<div class="row">

						<label for="end_date" class="col-xs-5 col-sm-3 control-label"><i class="icon-calendar"></i>&nbsp;&nbsp;<span lang="es">Fecha hasta</span></label>

						<div class="col-xs-7 col-sm-9">
							<input type="text" name="end_date" id="end_date" value="#end_date#" class="form-control input_datepicker" onchange="setEndDate()"/>
						</div>

					</div>

					<div class="row">

						<label for="from_user" class="col-xs-5 col-sm-3 control-label" lang="es">Usuario propietario</label>

						<div class="col-xs-6 col-sm-7 col-md-8">

							<cfif isNumeric(user_in_charge)>

								<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="userQuery">
									<cfinvokeargument name="user_id" value="#user_in_charge#">
								</cfinvoke>

								<cfif userQuery.recordCount GT 0>

									<cfif len(userQuery.user_full_name) GT 0 AND userQuery.user_full_name NEQ " ">
										<cfset from_user_full_name = userQuery.user_full_name>
									<cfelse>
										<cfset from_user_full_name = "USUARIO SELECCIONADO SIN NOMBRE">
									</cfif>

								<cfelse>

									<cfset from_user_full_name = "USUARIO NO ENCONTRADO">
									<cfset user_in_charge = "">

								</cfif>

							<cfelse>

								<cfset from_user_full_name = "">

							</cfif>

							<input type="hidden" name="from_user" id="from_user" value="#user_in_charge#" />
							<input type="text" name="from_user_user_full_name" id="from_user_user_full_name" value="#from_user_full_name#" class="form-control" readonly onclick="openUserSelectorWithField('from_user')" />

						</div>

						<div class="col-xs-1 col-sm-1 col-md-1">
							<button onclick="clearFieldSelectedUser('from_user')" type="button" class="btn btn-default" lang="es" title="Quitar usuario seleccionado"><i class="icon-remove"></i></button>
						</div>

					</div>

					<div class="row">
						<div class="col-xs-5 col-sm-3"></div>
						<div class="col-xs-7 col-sm-8 col-md-9">
							<button onclick="openUserSelectorWithField('from_user')" type="button" class="btn btn-default" lang="es">Seleccionar usuario</button>
						</div>
					</div>


					<div class="row">

						<label for="download_user" class="col-xs-5 col-sm-3 control-label" lang="es">Usuario que realiza descarga</label>

						<div class="col-xs-6 col-sm-7 col-md-8">

							<cfif isNumeric(download_user_id)>

								<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="userQuery">
									<cfinvokeargument name="user_id" value="#download_user_id#">
								</cfinvoke>

								<cfif userQuery.recordCount GT 0>

									<cfif len(userQuery.user_full_name) GT 0 AND userQuery.user_full_name NEQ " ">
										<cfset download_user_full_name = userQuery.user_full_name>
									<cfelse>
										<cfset download_user_full_name = "USUARIO SELECCIONADO SIN NOMBRE">
									</cfif>

								<cfelse>

									<cfset download_user_full_name = "USUARIO NO ENCONTRADO">
									<cfset download_user_id = "">

								</cfif>

							<cfelse>

								<cfset download_user_full_name = "">

							</cfif>

							<input type="hidden" name="download_user" id="download_user" value="#download_user_id#" />
							<input type="text" name="download_user_user_full_name" id="download_user_user_full_name" value="#download_user_full_name#" class="form-control" readonly onclick="openUserSelectorWithField('download_user')" />

						</div>

						<div class="col-xs-1 col-sm-1 col-md-1">
							<button onclick="clearFieldSelectedUser('download_user')" type="button" class="btn btn-default" lang="es" title="Quitar usuario seleccionado"><i class="icon-remove"></i></button>
						</div>

					</div>

					<div class="row">
						<div class="col-xs-5 col-sm-3"></div>
						<div class="col-xs-7 col-sm-8 col-md-9">
							<button onclick="openUserSelectorWithField('download_user')" type="button" class="btn btn-default" lang="es">Seleccionar usuario</button>
						</div>
					</div>


					<div class="row">

						<div class="col-sm-offset-3 col-sm-10">
							<input type="submit" name="search" class="btn btn-primary" style="margin-top:30px;" lang="es" value="Filtrar" />
						</div>

					</div>

				</form>

			</div>

		</div>
	</div>


	<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
	</cfinvoke>

	<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

	<script>

		$(document).ready(function() {


			$("##statisticsTable").tablesorter({

				widgets: ['zebra','filter','stickyHeaders','math'],<!---'select',--->
				headers: {
					0: {
						sorter: "text"
					}
				}
				, widgetOptions : {
					filter_childRows : false,
					filter_columnFilters : true,
					filter_cssFilter : 'tablesorter-filter',
					filter_filteredRow   : 'filtered',
					filter_formatter : null,
					filter_functions : null,
					filter_hideFilters : false,
					filter_ignoreCase : true,
					filter_liveSearch : true,
					//filter_reset : 'button.reset',
					filter_searchDelay : 300,
					filter_serversideFiltering: false,
					filter_startsWith : false,
					filter_useParsedData : false

						, math_data     : 'math' // data-math attribute
					    , math_ignore   : [0,1,2,3,4,7,8,9]
					    , math_mask     : '##000,##'
					    <!---. math_mask     : '##,####0.00'--->
					    <!---, math_complete : function($cell, wo, result, value, arry) {
					        var txt = '<span class="align-decimal"> ' + result + '</span>';
					        if ($cell.attr('data-math') === 'all-sum') {
					          // when the "all-sum" is processed, add a count to the end
					          return txt + ' (Sum of ' + arry.length + ' cells)';
					        }
					        return txt;
					    } --->

			    }
			});

		});
	</script>

	<span class="label label-primary">#filesDownloadsQuery.recordcount# <span lang="es">Archivos</span></span>

	<div class="row">
		<div class="col-sm-12">

			<table id="statisticsTable" class="table table-hover table-bordered table-striped tablesorter-bootstrap data-table" style="margin-top:20px;">

				<thead>
					<tr>
						<th><span lang="es">Nombre físico</span></th>
						<th><span lang="es">Nombre</span></th>
						<th><span lang="es">Tipo de archivo</span></th>
						<th><span lang="es">Fecha de subida</span></th>
						<th><span lang="es">Fecha de reemplazo</span></th>
						<th><span lang="es">Descargas</span></th>
						<th><span lang="es">Adjunto de</span></th>
					</tr>
				</thead>

				<tfoot>
				   	<tr>
				   		<th></th>
				   		<th></th>
				   		<th></th>
				   		<th></th>
				   		<th></th>
				   		<th data-math="col-sum"></th>
				   		<th></th>
					</tr>
				</tfoot>

				<tbody>

					<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

					<cfloop query="filesDownloadsQuery">
						<tr>
							<td>
								<cfif isNumeric(filesDownloadsQuery.area_id)>
									<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#filesDownloadsQuery.file_id#&area=#filesDownloadsQuery.area_id#" onclick="return downloadFileLinked(this,event)">#filesDownloadsQuery.file_name#</a>
									<!---<a href="#APPLICATION.htmlPath#/file.cfm?file=#filesDownloadsQuery.file_id#&area=#filesDownloadsQuery.area_id#" target="_blank"> No todos son archivos de área--->
								<cfelseif isNumeric(filesDownloadsQuery.item_type_id)>
									<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#filesDownloadsQuery.file_id#&#itemTypesStruct[filesDownloadsQuery.item_type_id].name#=#filesDownloadsQuery.item_id#" onclick="return downloadFileLinked(this,event)">#filesDownloadsQuery.file_name#</a>
								<cfelse>
									<span>#filesDownloadsQuery.file_name#</span>
									<!---<a href="#APPLICATION.htmlPath#/file.cfm?file=#filesDownloadsQuery.file_id#" target="_blank">--->
								</cfif>
							</td>
							<td>#filesDownloadsQuery.name#</td>
							<td>#filesDownloadsQuery.file_type#</td>
							<td>#filesDownloadsQuery.uploading_date#</td>
							<td>#filesDownloadsQuery.replacement_date#</td>
							<td>#filesDownloadsQuery.downloads#</td>
							<td>

								<cfif isNumeric(filesDownloadsQuery.item_id)>

									<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
										<cfinvokeargument name="item_id" value="#filesDownloadsQuery.item_id#">
										<cfinvokeargument name="itemTypeId" value="#filesDownloadsQuery.item_type_id#">
										<cfinvokeargument name="parse_dates" value="false">
										<cfinvokeargument name="published" value="false">

										<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
										<cfinvokeargument name="client_dsn" value="#client_dsn#">
									</cfinvoke>

									<cfif itemQuery.recordCount GT 0>

										<cfif listFind("11,12", filesDownloadsQuery.item_type_id) GT 0>

											<!---tableRowUrl--->
											<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getTableRowUrl" returnvariable="areaItemUrl">
												<cfinvokeargument name="table_id" value="#filesDownloadsQuery.item_id#">
												<cfinvokeargument name="tableTypeName" value="#itemTypesStruct[filesDownloadsQuery.item_type_id].name#">
												<cfinvokeargument name="row_id" value="#filesDownloadsQuery.row_id#">
												<cfinvokeargument name="area_id" value="#itemQuery.area_id#">

												<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
											</cfinvoke>

										<cfelse>

											<!---itemUrl--->
											<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaItemUrl" returnvariable="areaItemUrl">
												<cfinvokeargument name="item_id" value="#filesDownloadsQuery.item_id#">
												<cfinvokeargument name="itemTypeName" value="#itemTypesStruct[filesDownloadsQuery.item_type_id].name#">
												<cfinvokeargument name="area_id" value="#itemQuery.area_id#">

												<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
											</cfinvoke>

										</cfif>

										<a href="#areaItemUrl#" target="_blank">#itemTypesStruct[filesDownloadsQuery.item_type_id].label#</a>

									</cfif>

								</cfif>

							</td>
						</tr>
					</cfloop>

				</tbody>

			</table>

		</div>
	</div>

	</cfoutput>


</div>
