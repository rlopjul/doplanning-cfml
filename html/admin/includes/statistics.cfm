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

<cfif isDefined("URL.area_id") AND isNumeric(URL.area_id)>
	<cfset area_id = URL.area_id>
<cfelse>
	<cfset area_id = "">
</cfif>

<cfif isDefined("URL.include_subareas") AND URL.include_subareas IS true>
	<cfset include_subareas = URL.include_subareas>
<cfelse>
	<cfset include_subareas = "">
</cfif>

<!--- getGeneralStatistics --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Statistic" method="getGeneralStatistics" returnvariable="getStatisticsResponse">
	<cfif len(from_date) GT 0>
		<cfinvokeargument name="from_date" value="#from_date#"/>
	</cfif>
	<cfif len(end_date) GT 0>
		<cfinvokeargument name="end_date" value="#end_date#"/>
	</cfif>
	<cfif len(user_in_charge) GT 0>
		<cfinvokeargument name="from_user" value="#user_in_charge#"/>
	</cfif>
	<cfif len(area_id) GT 0>
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfif>
	<cfif include_subareas IS true>
		<cfinvokeargument name="include_subareas" value="true">
	</cfif>
</cfinvoke>

<cfset statisticsQuery = getStatisticsResponse.query>

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

	function setSelectedArea(areaId, areaName) {

		$("#area_id").val(areaId);
		$("#area_name").val(areaName);

	}

	function clearFieldSelectedArea(){

		$("#area_id").val("");
		$("#area_name").val("");

	}

	<cfoutput>
	function openUserSelectorWithField(fieldName){

		return openPopUp('#APPLICATION.htmlPath#/iframes/users_select.cfm?field='+fieldName);

	}

	function openAreaSelector(){

		return openPopUp('#APPLICATION.htmlPath#/iframes/area_select.cfm');

	}
	</cfoutput>

</script>

<div class="container">

	<div class="row">
		<div class="col-sm-12">
			<div class="div_message_page_title" lang="es">Estadísticas generales</div>
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

						<label for="from_user" class="col-xs-5 col-sm-3 control-label" lang="es">Usuario</label>

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


					<div class="row" id="listAreaSelector">
						<cfif isNumeric(area_id)>
							<!--- getArea --->
							<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="selectedArea">
								<cfinvokeargument name="area_id" value="#area_id#">
							</cfinvoke>
							<cfset area_name = selectedArea.name>
						<cfelse>
							<cfset area_name = "">
						</cfif>

						<label for="area_id" id="listAreaText" class="col-xs-5 col-sm-3 control-label" lang="es">Área</label>

						<div class="col-xs-6 col-sm-7 col-md-8">
							<input type="hidden" name="area_id" id="area_id" value="#area_id#" />
							<input type="text" name="area_name" id="area_name" class="form-control" value="#area_name#" readonly="true" onclick="openAreaSelector()" />
						</div>
						<div class="col-xs-1 col-sm-1 col-md-1">
							<button onclick="clearFieldSelectedArea()" type="button" class="btn btn-default" lang="es" title="Quitar área seleccionada"><i class="icon-remove"></i></button>
						</div>
					</div>

					<div class="row">
						<div class="col-xs-5 col-sm-3"></div>
						<div class="col-sm-3 col-md-2">
							<button onclick="return openAreaSelector()" type="button" class="btn btn-default" lang="es">Seleccionar área</button>
						</div>

						<div class="col-xs-offset-5 col-xs-7 col-sm-offset-0 col-sm-6">

							<div class="checkbox">
						    <label>
						      <input type="checkbox" name="include_subareas" value="true" <cfif include_subareas IS true>checked</cfif>> <span lang="es">Incluir áreas inferiores a la seleccionada</span>
						    </label>
						  </div>

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

				widgets: ['zebra','filter','stickyHeaders','math','output'],
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

					, output_separator     : ';'
					, output_hiddenColumns : false
					, output_includeFooter : true
					, output_headerRows    : true
					, output_delivery      : 'd'        // (p)opup, (d)ownload
					, output_saveRows      : 'f'        // (a)ll, (v)isible, (f)iltered, jQuery filter selector (string only) or filter function
					, output_duplicateSpans: true        // duplicate output data in tbody colspan/rowspan
					, output_replaceQuote  : '\u201c;'   // change quote to left double quote
					, output_includeHTML   : false        // output includes all cell HTML (except the header cells)
					, output_trimSpaces    : false       // remove extra white-space characters from beginning & end
					, output_wrapQuotes    : false       // wrap every cell output in quotes
					, output_saveFileName  : 'statistics.csv'

			    }
			});

			$("##accessTable").tablesorter({

				widgets: ['zebra'],
				headers: {
					0: {
						sorter: false
					},
					1: {
						sorter: false
					}
				}

			});

			$("##outputTableButton").on("click", function() {

				$("##statisticsTable").trigger('outputTable');

			});

		});
	</script>

	<div class="row">
		<div class="col-sm-12">
			<a class="btn btn-default btn-sm pull-right" role="button" id="outputTableButton"><i class="fa fa-download"></i> <span lang="es">Descargar resultados</span></a>
		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">

			<table id="statisticsTable" class="table table-hover table-bordered table-striped tablesorter-bootstrap data-table" style="margin-top:20px;">

				<thead>
					<tr>
						<th><span lang="es">Elemento</span></th>
						<th><span lang="es">Registros</span></th>
					</tr>
				</thead>

				<tbody>

					<cfloop array="#itemTypesArray#" index="curItemTypeId">
					<tr>
						<td><span lang="es">#itemTypesStruct[curItemTypeId].labelPlural#</span></td>
						<td>#statisticsQuery['#itemTypesStruct[curItemTypeId].table#_count']#</td>
					</tr>
					</cfloop>

				</tbody>

				<tbody class="tablesorter-infoOnly">
				    <tr>
				      <th><span lang="es">Total elementos de área</span></th>
				      <th data-math="above-sum"></th>
				    </tr>
				</tbody>

				<tbody>

					<tr>
						<td><span lang="es">Áreas</span> <cfif len(user_in_charge) GT 0>*</cfif></td>
						<td>#statisticsQuery.areas_count#</td>
					</tr>

					<tr>
						<td><span lang="es">Usuarios</span></td>
						<td>#statisticsQuery.users_count#</td>
					</tr>
				</tbody>


				<tfoot>
				   	<tr>
				   		<th><span lang="es">Total elementos</span></th>
				   		<th data-math="col-sum"></th>
					</tr>
				</tfoot>

		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">

			<table id="accessTable" class="table table-hover table-bordered table-striped tablesorter-bootstrap data-table" style="margin-top:20px;">

				<thead>
					<tr>
						<th><span lang="es">Acción</span></th>
						<th><span lang="es">Registros</span></th>
					</tr>
				</thead>

				<tbody>

					<tr>
						<td><span lang="es">Accesos a la aplicación</span></td>
						<td>#statisticsQuery.users_login_success_count#</td>
					</tr>

					<tr>
						<td><span lang="es">Login fallidos</span> **</td>
						<td>#statisticsQuery.users_login_failed_count#</td>
					</tr>

				</tbody>

			</table>

		</div>
	</div>


	<div class="row">
		<div class="col-sm-12">
			<p class="help-block">
			<cfif len(user_in_charge) GT 0>
			* <span lang="es">Áreas en las que el usuario es responsable</span><br/>
			</cfif>
			** <span lang="es">Login fallidos de todos los usuarios de la aplicación</span></p>
		</div>
	</div>

	</cfoutput>

</div>
