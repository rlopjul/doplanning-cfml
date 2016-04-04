function drawChart(totalItems){


            	var svg1 = dimple.newSvg('#userLogArea', 950, 400);

              var myChart = new dimple.chart(svg1,  totalItems);
              myChart.setBounds(60, 30, 600, 300);

              var x = myChart.addCategoryAxis("x", "item_type_id");
              var y = myChart.addMeasureAxis("y", "total");

              // In order to deal with cases where order differs by column
              // it's needed to include it as series definition

              var s = myChart.addSeries(["user_full_name"], dimple.plot.bar);
							var s2 = myChart.addSeries(["item_type_label"]);

							var userLegend = myChart.addLegend(670, 50, 350, 100, "left", s);
							var typeLegend = myChart.addLegend(670, 250, 350, 100,"left", s2);
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

					 // Filter the data
myChart.data = dimple.filterData(dimple.filterData(totalItems, 'user_full_name', newUserFilters), 'item_type_label', newTypeFilters);
			// Passing a duration parameter makes the chart animate. Without
			// it there is no transition

myChart.draw(800);
 });

            }

