<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es">
<head>
	<script src="http://d3js.org/d3.v3.min.js"></script>
  <script src="http://dimplejs.org/dist/dimple.v2.1.6.min.js"></script>

<cfoutput>

<title>Estadísticas #APPLICATION.title#<cfif isDefined("SESSION.client_name")> - #SESSION.client_name#</cfif></title>

<cfinclude template="#APPLICATION.htmlPath#/includes/html_head.cfm">

<script src="#APPLICATION.path#/jquery/jquery.serializecfjson-0.2.min.js"></script>

</cfoutput>

<!--- isUserUserAdministrator --->
<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="isUserUserAdministrator" returnvariable="isUserUserAdministratorResponse">
	<cfinvokeargument name="check_user_id" value="#SESSION.user_id#">
</cfinvoke>

<cfif isUserUserAdministratorResponse.result IS false>
	<cfthrow message="#isUserUserAdministratorResponse.message#">
<cfelse>
	<cfset isUserAdministrator = isUserUserAdministratorResponse.isUserAdministrator>
</cfif>

<script>

	var totalItems;
	<cfoutput>

	function getTotalItemsByUser(areaId, areaType, includeSubareas) {

			return $.ajax({
					url: '#APPLICATION.htmlComponentsPath#/Statistic.cfc',
					data: {
							method: 'getTotalItemsByUser',
							area_id: areaId,
							area_type: areaType,
							include_subareas: includeSubareas
					},
					method:'POST',
					dataType:"json",
					success: function(data, textStatus){

						if( textStatus == "success"){

							if(data.result == true) {

								<!---console.log(data);--->

								<!--- Esto es necesario para que funcione bien serializeCFJSON, que falla y no realiza la conversión correctamente
								http://www.cutterscrossing.com/index.cfm/2012/5/2/JQuery-Plugin-serializeCFJSON
								En lugar de esto se puede llamar a standardiseCfQueryJSON que parece que funciona correctamente
								--->
								//<!---var temp = new Object();
								//temp.data = data.totalItems;

								//var totalItems = $.serializeCFJSON(temp).data;--->

								 var totalItems = data.totalItems;
								 //console.lo
								 //g(totalItems);
								// $("##dataTextArea").val(JSON.stringify(totalItems));


							}else{
								alert(data.message);
							}


						} else
							alert(textStatus);

					},
					error: function(jqXHR, textStatus, errorThrown){
						alert(textStatus+": "+errorThrown);
					}
			});

	}

	</cfoutput>

	$(window).load( function() {

	});

	$(document).ready(function () {

		// Alert
		$('#alertContainer .close').click(function(e) {

			hideAlertMessage();

		});

	});

</script>
</head>

<body onBeforeUnload="onUnloadPage()" onLoad="onLoadPage()" class="body_global">

<!---divLoading--->
<cfinclude template="#APPLICATION.htmlPath#/includes/loading_page_div.cfm">

<!--- Alert --->
<cfinclude template="#APPLICATION.htmlPath#/includes/main_alert.cfm">

<div id="wrapper"><!--- wrapper --->

	<cfinclude template="#APPLICATION.htmlPath#/includes/app_head.cfm">

	<div id="page-content-wrapper"><!--- page-content-wrapper --->

		<div class="container app_main_container">

			<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

			<script>

				<cfoutput>

				$(document).ready(function () {

					var promise = getTotalItemsByUser(#URL.area#, '#area_type#', true);

					promise.success(function (data) {
						drawChart(data.totalItems);
		});

				});

				</cfoutput>

			</script>


			<!--- PAGE CONTENT HERE --->



			<div id="userLogArea">

				<script>
									function drawChart(totalItems){
                    var svg1 = dimple.newSvg('#userLogArea', 700, 400);


                    //d3.tsv("/content/example_data.tsv", function (data) {
                    var myChart = new dimple.chart(svg1,  totalItems);
                    //myChart.setBounds(60, 30, 900, 400);

                    var x = myChart.addCategoryAxis("x", "item_type_id");
                    var y = myChart.addMeasureAxis("y", "total");

                    // In order to deal with cases where order differs by column
                    // it's needed to include it as series definition
                    var s = myChart.addSeries(["user_id"], dimple.plot.bar);

                    var myLegend = myChart.addLegend(200, 10, 380, 20, "left");

                    myChart.svg.attr("width", "100%")
                        .attr("height", "100%")
                        .attr("viewBox", "0 0 700 400");
												s.addOrderRule("item_type_id");
                    myChart.ease = "bounce";
                    myChart.staggerDraw = true;
                    myChart.draw(800);
                    s.categoryFields = ["user_id"];

                    myChart.legends = [];

                    // Get a unique list of Owner values to use when filtering
                    var filterValues = dimple.getUniqueValues(totalItems, "user_id");
										console.log(totalItems);
                    // Get all the rectangles from our now orphaned legend
                    myLegend.shapes.selectAll("rect")
                      // Add a click event to each rectangle
                      .on("click", function (e) {
                        // This indicates whether the item is already visible or not
                        var hide = false;
                        var newFilters = [];
                        // If the filters contain the clicked shape hide it
                        filterValues.forEach(function (f) {
                          if (f === e.aggField.slice(-1)[0]) {
                            hide = true;
                          } else {
                            newFilters.push(f);
                          }
                        });
                        // Hide the shape or show it
                        if (hide) {
                          d3.select(this).style("opacity", 0.2);
                        } else {
                          newFilters.push(e.aggField.slice(-1)[0]);
                          d3.select(this).style("opacity", 0.8);
                        }
                        // Update the filters
                        filterValues = newFilters;
												s.addOrderRule("item_type_id");
                        // Filter the data
                        myChart.data = dimple.filterData(totalItems, "user_id", filterValues);
                        // myChart.addSeries(["Order"], dimple.plot.bar);
                        // Passing a duration parameter makes the chart animate. Without
                        // it there is no transition
                        myChart.draw(800);
                        s.categoryFields = ["user_id"];

                    });
									}

				</script>

                </div>




			<!--- END PAGE CONTENT --->

		</div>

	</div><!---END page-content-wrapper --->

</div>

</body>
</html>
</cfprocessingdirective>
