


<!--- getAreaItemTypesOptions --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItemType" method="getAreaItemTypesOptions" returnvariable="getItemTypesOptionsResponse">
</cfinvoke>

<cfset itemsTypesQuery = getItemTypesOptionsResponse.query>

<cfoutput>
<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">
<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
<script src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>
</cfoutput>


<div class="container">

	<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

	<div class="row">
		<div class="col-sm-12">
			<div class="div_message_page_title" lang="es">Categorías de elementos de área</div>
		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">
			<p lang="es">
				Las categorías permiten categorizar los distintos elementos de las áreas. Se definen a partir de un área del árbol, las áreas contenidas en el primer nivel del área seleccionada definirán las categorías disponibles para seleccionar en el elemento.<br/>
				Si un tipo de elemento no dispone de área definida para categorías, no dispondrá de la opción de seleccionar categoría al introducirlo. Los elementos que sí dispongan de área para categorías definida obligarán a seleccionar al menos una de estas categorías al introducirlo. Para que siempre se pueda seleccionar al menos una de estas categorías, se recomienda crear un área llamada por ejemplo "Otros" dentro de las áreas que definen las categorías.<br/>
				Los usuarios podrán filtrar las notificaciones que reciben por email a partir de estas categorías.
			</p>
		</div>
	</div>

	<cfoutput>

	<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
	</cfinvoke>

	<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

	<script>

		function openAreaSelector(itemTypeId){
		
			return openPopUp('#APPLICATION.htmlPath#/iframes/area_select.cfm?itemTypeId='+itemTypeId);
			
		}

		function setSelectedArea(areaId, areaName, itemTypeId) {
			
			$("##item_type_"+itemTypeId+"_category_area_id").val(areaId);
			$("##item_type_"+itemTypeId+"_category_area_name").text(areaName);
			$("##item_type_"+itemTypeId+"_category_remove").show();
				
		}

		function removeCategory(itemTypeId){

			$("##item_type_"+itemTypeId+"_category_area_id").val("");
			$("##item_type_"+itemTypeId+"_category_area_name").text("");
			$("##item_type_"+itemTypeId+"_category_remove").hide();

		}

		$(document).ready(function() { 
			

			$("##categoriesTable").tablesorter({ 

				widgets: ['zebra','uitheme','stickyHeaders'],
				theme : "bootstrap",
				headerTemplate : '{content} {icon}',<!---new in v2.7. Needed to add the bootstrap icon!--->
				headers: { 
					0: {
						sorter: false,
					},
					1: {
						sorter: false,
					}
				}
				, widgetOptions : {
	
			    }
			});


			$("##updateItemTypeData").submit(function( event ) {

				event.preventDefault();

				showLoadingPage(true);

				var form = $(this);

			  	$.ajax({
				  type: "POST",
				  url: form.prop('action'),
				  data: form.serialize(),
				  success: function(data, status) {

				  	if(status == "success"){
				  		//alert(JSON.stringify(data));
				  		var message = data.message;
				  		openUrlLite("#CGI.SCRIPT_NAME#?res="+data.result+"&msg="+encodeURIComponent(message), "_self");

				  	}else
						openUrlLite("#CGI.SCRIPT_NAME#?res=0&msg="+encodeURIComponent(status), "_self");
					
				  },
				  dataType: "json"
				});


			});

		}); 
	</script>
	
	<div class="row">
		<div class="col-sm-12">

			<form id="updateItemTypeData" method="post" action="#APPLICATION.htmlComponentsPath#/AreaItemType.cfc?method=updateAreaItemTypesOptions">

				<div class="row">
					<div class="col-sm-3 col-md-2">

						<input type="submit" class="btn btn-primary btn-block" name="modify" value="Guardar" lang="es"/>

					</div>
				</div>

				<div class="row">
					<div class="col-sm-12">

					<table id="categoriesTable" class="tablesorter" style="margin-top:20px;">

						<thead>
							<tr>
								<th style="width:30%"><span lang="es">Tipo de elemento</span></th>
								<th style="width:70%"><span lang="es">Área para categorías</span></th>	
							</tr>
						</thead>

						<tbody>

							<cfloop array="#itemTypesArray#" index="itemTypeId">
								<cfif itemTypeId NEQ 13 AND itemTypeId NEQ 14 AND itemTypeId NEQ 15 AND itemTypeId NEQ 16>

									<cfquery dbtype="query" name="itemTypeQuery">
										SELECT *
										FROM itemsTypesQuery
										WHERE item_type_id = <cfqueryparam value="#itemTypeId#" cfsqltype="cf_sql_integer">;
									</cfquery>

									<cfif itemTypeQuery.recordCount GT 0>
										
										<cfset category_area_id = itemTypeQuery.category_area_id>
										<cfset category_area_name = itemTypeQuery.category_area_name>

									<cfelse>

										<cfset category_area_id = "">
										<cfset category_area_name = "">

									</cfif>

									<tr>
										<td><span lang="es">#itemTypesStruct[itemTypeId].labelPlural#</span></td>			
										<td>

											<input type="hidden" name="item_type_#itemTypeId#_category_area_id" id="item_type_#itemTypeId#_category_area_id" value="#category_area_id#"/>

											<button onclick="return openAreaSelector(#itemTypeId#)" type="button" class="btn btn-default btn-sm" lang="es">Seleccionar</button>
											&nbsp;
											<span id="item_type_#itemTypeId#_category_area_name">#category_area_name#</span>
											<span id="item_type_#itemTypeId#_category_remove">
												<button type="button" class="btn btn-default btn-sm" onclick="removeCategory(#itemTypeId#)"><i class="fa fa-remove"></i> <span lang="es">Quitar categoría</span></button>
											</span>
											<cfif NOT isNumeric(category_area_id)>
												<script>
													$("##item_type_#itemTypeId#_category_remove").hide();
												</script>
											</cfif>
											
										</td>
									</tr>

								</cfif>
								
							</cfloop>

						</tbody>

					</table>

					</div>
				</div>

				<div class="row">
					<div class="col-sm-3 col-md-2">

						<input type="submit" class="btn btn-primary btn-block" name="modify" value="Guardar" lang="es"/>

					</div>
				</div>

		

			</form>

		</div>
	</div>

	</cfoutput>

</div>