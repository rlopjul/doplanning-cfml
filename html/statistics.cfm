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
								<!---var temp = new Object();
								temp.data = data.totalItems;

								var totalItems = $.serializeCFJSON(temp).data;--->

								// var totalItems = data.totalItems;

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
						console.log(data);
						drawChart(data.totalItems);
					});

				});

				</cfoutput>

			</script>


			<!--- PAGE CONTENT HERE --->



			<div id="userLogArea">

				<script>
				    function drawChart(totalItems){


            	var svg1 = dimple.newSvg('#userLogArea', 900, 400);

              var myChart = new dimple.chart(svg1,  totalItems);
              myChart.setBounds(60, 30, 600, 300);

              var x = myChart.addCategoryAxis("x", "item_type_id");
              var y = myChart.addMeasureAxis("y", "total");

              // In order to deal with cases where order differs by column
              // it's needed to include it as series definition

              var s = myChart.addSeries(["user_full_name"], dimple.plot.bar);
							var s2 = myChart.addSeries(["item_type_label"]);

							var userLegend = myChart.addLegend(700, 50, 350, 100, "left", s);
							var typeLegend = myChart.addLegend(700, 250, 350, 100,"left", s2);
              //myChart.svg.attr("width", "100%")
              //  .attr("height", "100%")
              //.attr("viewBox", "0 0 700 400");
              //s.addOrderRule("item_type_id");
              myChart.ease = "bounce";
              myChart.staggerDraw = true;
              myChart.draw(800);

							//remove svg shape for series item_type_id
							//s2.shapes.remove();
              //s.categoryFields = ["user_full_name"];
							//s2.categoryFields = ["item_type_id"];

							myChart.legends = [];
	    // Get a unique list of Owner values to use when filtering
	        var userFilterValues = dimple.getUniqueValues(totalItems, "user_full_name");
	        var typeFilterValues = dimple.getUniqueValues(totalItems, "item_type_label");
	        var hiddenUserValue = [];
	        var hiddenTypeValue = [];

					legendBits = userLegend.shapes;
	 legendBits[0] = legendBits[0]
			 .concat(typeLegend.shapes[0]);

			 // Get all the rectangles from now orphaned legend
			 legendBits.selectAll("rect")
				 // Add a click event to each rectangle
				 .on("click", function (e) {
					 // This indicates whether the item is already visible or not
					 var hide = false;
					 var newUserFilters = [];
					 var newTypeFilters = [];
					 var currentVaue = e.aggField.slice(-1)[0];


					 userFilterValues.forEach(function(f){
							 if(f === currentVaue){
									 var whereIsIt = hiddenUserValue.indexOf(currentVaue);

									 if (whereIsIt > -1) {
											 //it is hidden and needs to be shown.
											 hide = false;
											 hiddenUserValue.splice(whereIsIt, 1);
									 } else {
											 //it needs to be hidden
												hide = true;
												hiddenUserValue.push(currentVaue);
									 }
							 }
					 });

					 typeFilterValues.forEach(function(f){
							 if(f === currentVaue){
									 var whereIsIt = hiddenTypeValue.indexOf(currentVaue);

									 if (whereIsIt > -1) {
											 //it is hidden and needs to be shown.
											 hide = false;
											 hiddenTypeValue.splice(whereIsIt, 1);
									 } else {
											 //it needs to be hidden
												hide = true;
												hiddenTypeValue.push(currentVaue);
									 }
							 }
					 });


			if (hide) {
				d3.select(this).style("opacity", 0.2);
			} else {
				d3.select(this).style("opacity", 0.8);
			}

					 if(hiddenTypeValue.length == "" ){
							 newTypeFilters =  typeFilterValues;
					 }else{
							 newTypeFilters = hiddenTypeValue;
					 }

					 if( hiddenUserValue.length == ""){
							 newUserFilters = userFilterValues;
					 }else{
							 newUserFilters = hiddenUserValue;
					 }
					 console.log(newTypeFilters );
					 // Filter the data
myChart.data = dimple.filterData(dimple.filterData(totalItems, 'user_full_name', newUserFilters), 'item_type_label', newTypeFilters);
			// Passing a duration parameter makes the chart animate. Without
			// it there is no transition

myChart.draw(800);
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
