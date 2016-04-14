<!---<cfif isDefined("URL.from_date")>
	<cfset from_date = URL.from_date>
<cfelse>
	<cfset from_date = "">
</cfif>

<cfif isDefined("URL.end_date")>
	<cfset end_date = URL.end_date>
<cfelse>
	<cfset end_date = "">
</cfif>--->

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
<cfinvoke component="#APPLICATION.componentsPath#/StatisticManager" method="getTotalItems" returnvariable="getStatisticsResponse">
	<!---<cfif len(from_date) GT 0>
		<cfinvokeargument name="from_date" value="#from_date#"/>
	</cfif>
	<cfif len(end_date) GT 0>
		<cfinvokeargument name="end_date" value="#end_date#"/>
	</cfif>
	<cfif len(user_in_charge) GT 0>
		<cfinvokeargument name="from_user" value="#user_in_charge#"/>
	</cfif>--->
	<cfif len(area_id) GT 0>
		<cfinvokeargument name="area_id" value="#area_id#"/>
	<cfelse>

		<!---getRootAreaId--->
		<!---<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getRootAreaId" returnvariable="rootAreaId">
		</cfinvoke>

		<cfinvokeargument name="area_id" value="#rootAreaId#"/>--->

	</cfif>
	<cfif include_subareas IS true>
		<cfinvokeargument name="include_subareas" value="true">
	</cfif>
</cfinvoke>

<cfset totalItemsQuery = getStatisticsResponse.query>

<cfoutput>

#totalItemsQuery.recordCount#

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">
<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
<script src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>
<script src="#APPLICATION.htmlPath#/scripts/tablesFunctions.js?v=2"></script>
</cfoutput>

<script>

	<!---

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

	--->

	function setSelectedArea(areaId, areaName) {

		$("#area_id").val(areaId);
		$("#area_name").val(areaName);

	}

	function clearFieldSelectedArea(){

		$("#area_id").val("");
		$("#area_name").val("");

	}

	<cfoutput>

	function openAreaSelector(){

		return openPopUp('#APPLICATION.htmlPath#/iframes/area_select.cfm');

	}

	</cfoutput>

</script>

<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

<!--- getAllUsers --->
<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getAllUsers" argumentcollection="#arguments#" returnvariable="usersQuery">
	<cfinvokeargument name="order_by" value="user_full_name">
	<cfinvokeargument name="order_type" value="ASC">

	<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
	<cfinvokeargument name="client_dsn" value="#client_dsn#">
</cfinvoke>

<!--- getAreaItemTypesStruct --->
<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
</cfinvoke>

<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

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

					<!---<div class="row">

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

					</div>--->

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

	<script>

		$(document).ready(function() {


			<!---
			$("##statisticsTable").tablesorter({

				widgets: ['zebra','filter','stickyHeaders'],<!---,'math'--->
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
			});--->

		});
	</script>

	<div class="row">
		<div class="col-sm-12">

			<table style="margin-top:20px;"><!---id="statisticsTable" class="table table-hover table-bordered table-striped tablesorter-bootstrap data-table" --->

				<thead>
					<tr>
						<th><span lang="es">Usuario</span></th>
						<!--- Loop items types --->
						<cfloop array="#itemTypesArray#" index="itemTypeId">

							<cfif listFind("13,16", itemTypeId) IS 0><!---Typologies are not included--->

								<th>#itemTypesStruct[itemTypeId].label#</th>

							</cfif>

						</cfloop>

					</tr>
				</thead>


				<tbody>

					<cfloop query="#usersQuery#">

						<tr>
							<td>#usersQuery.user_full_name#</td>

							<!---<cfquery dbtype="query" name="userItemsQuery">
								SELECT *
								FROM totalItemsQuery
								WHERE user_in_charge = <cfqueryparam value="#usersQuery.id#" cfsqltype="cf_sql_integer">;
							</cfquery>--->

							<!--- Loop items types --->
							<cfloop array="#itemTypesArray#" index="itemTypeId">

								<cfif listFind("13,16", itemTypeId) IS 0><!---Typologies are not included--->

									<!---<cfif userItemsQuery.recordCount GT 0>

										<cfquery dbtype="query" name="itemsQuery">
											SELECT count(*) AS total
											FROM userItemsQuery
											WHERE itemTypeId = <cfqueryparam value="#itemTypeId#" cfsqltype="cf_sql_integer">;
										</cfquery>

										<td><cfif itemsQuery.recordCount GT 0>#itemsQuery.total#<cfelse>0</cfif></td>

									<cfelse>

										<td>0</td>

									</cfif>--->

									<td></td>

								</cfif>

							</cfloop>

						</tr>

					</cfloop>

					<!---
					<cfset itemsByType = ArrayNew(1)>

					<!--- Loop items types --->
					<cfloop array="#itemTypesArray#" index="itemTypeId">

						<cfif listFind("13,16", itemTypeId) IS 0><!---Typologies are not included--->

							<cfset itemTypeLabel = itemTypesStruct[itemTypeId].label>

							<cfquery dbtype="query" name="itemsQuery">
								SELECT user_in_charge AS user_id, user_full_name, count(*) AS total
								FROM totalItemsQuery
								WHERE itemTypeId = <cfqueryparam value="#itemTypeId#" cfsqltype="cf_sql_integer">
								GROUP BY user_in_charge, user_full_name;
							</cfquery>

							<cfif itemsQuery.recordCount GT 0>

								<cfloop query="#itemsQuery#">
									<cfset itemTypeStruct = structNew()>
									<cfset itemTypeStruct.item_type_id = itemTypeId>
									<cfset itemTypeStruct.item_type_label = itemTypeLabel>
									<cfset itemTypeStruct.user_id = itemsQuery.user_id>
									<cfset itemTypeStruct.user_full_name = itemsQuery.user_full_name>
									<cfset itemTypeStruct.total = itemsQuery.total>

									<cfset ArrayAppend(itemsByType, itemTypeStruct)>
								</cfloop>

							<cfelse><!--- NO results --->

								<cfset itemTypeStruct = structNew()>
								<cfset itemTypeStruct.item_type_id = itemTypeId>
								<cfset itemTypeStruct.item_type_label = itemTypeLabel>
								<cfset itemTypeStruct.user_id = "">
								<cfset itemTypeStruct.user_full_name = "">
								<cfset itemTypeStruct.total = 0>

								<cfset ArrayAppend(itemsByType, itemTypeStruct)>

							</cfif>

						</cfif>

					</cfloop>--->

				</tbody>

				<!---<tfoot>
				   	<tr>
				   		<th></th>
				   		<th data-math="col-sum"></th>
					</tr>
				</tfoot>--->

		</div>
	</div>

	</cfoutput>

</div>
