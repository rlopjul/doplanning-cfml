function mline(areaData){

  var margin = {top: 40, right: 200, bottom: 80, left: 50},
     margin2 = { top: 460, right: 10, bottom: 20, left: 50 },
    width = 900 - margin.left - margin.right ,
    height = 500 - margin.top - margin.bottom ,
    height2 = 500 - margin2.top - margin2.bottom;


var color = d3.scale.category10();

var parseDate = d3.time.format("%d-%m-%Y").parse;



var div = d3.select('body') //select tooltip div over body
                .append("div")
                .attr("class", "tooltip")
                .style("opacity", 0);


var user = [];
var item = [];

areaData.forEach(function(d,i){
    item.push(d.item_type_label);
    user.push(d.user_full_name);

    // Use index.of() to check the index. if it returns -1.
    // push the name to arrayList i.ie(user or item).
    // No need to check for uniq
})

var userName = unique(user);
var item_type = unique(item);

userName.unshift("Check All");
var form = d3.select("#mlineLegend").append("form");

var labelEnter = form.selectAll("span")
    .data(userName)
    .enter()
    .append("span");

labelEnter.append("input")
    .attr({
        type: "checkbox",
        name: "mode",
        id: function(d){ return d;}
    })
    .property("checked",function(d,i){
        if(i == 1) return true;
    });

    labelEnter.append("label")
        .style("font-size", "10px")
        .text(function(d){ return d; });

labelEnter.append("br");

userName.shift();
var nested = d3.nest()
		.key(function(d) { return d.user_full_name })
		.map(areaData)

// only retrieve data from the selected series, using the nest we just created
var lineData ;
var count = 0;

userName.forEach(function(name){
    if( count == 0){
        var data = nested[name];

        lineData = d3.nest()
            .key(function(d){ return d.item_type_label; })
            .entries(data);

    }else{
        var data = nested[name];

        var usrData = d3.nest()
            .key(function(d){ return d.item_type_label; })
            .entries(data);

        lineData = lineData.concat(usrData);
    }
    count +=1;
});

var seriesData;
var checkUser = userName[0];
var checkItem = ["Archivo", "Lista", "Evento"];

function createData(){
    // Creating anested filter to created a nested object with two key values pairs.
    //First wrt item type label and other based on date.
    // using second key to rollup and sum the total items for that particular date.
    var nestedFilter = d3.nest()
                .key( function(d){ if( checkUser.indexOf(d.user_full_name) != -1 ) return d.item_type_label;})
                .key(function(d){ return d.creation_date ; })
                .rollup(function(leaves){
                    var sum = d3.sum(leaves, function(g){ return g.total; });
                    return {
                        creation_date: leaves[0].creation_date,
                        item_type_label: leaves[0].item_type_label,
                        user_full_name: leaves[0].user_full_name,
                        total: sum
                    };
                })
                .entries(areaData);

    //dynamicaaly remove undefined array from object
    nestedFilter.forEach(function(obj, i){

        if(obj.key == "undefined"){
            nestedFilter.splice(i,1);
        }
    });


    //Using map to create one nested object of nestedfilter data.
    //Using the first key in nested data to create object key and using values from second
    // nest to creat a array of values. First map is over the itemtype and second
    // map is over date and total. Aggregate the date and total to first nest.
    seriesData = nestedFilter.map(function (objectArray) {

            return {
                key: objectArray.key,
                values: objectArray.values.map(function (d) {

                    return {creation_date: d.values.creation_date, item_type_label: d.values.item_type_label, user_full_name: d.values.user_full_name, total: d.values.total};
                })
            };
      });
}

d3.selectAll("input").on("change", function() {
    var selected = this.value;
    var check = this.checked ? true : false;

    if(check == true){
        if(this.id == "Check All"){

            checkUser = userName.slice();
            d3.selectAll('input').property('checked',true);
        }else{
            checkUser.push(this.id);
        }
        d3.select("#mlineBrush").select('svg').remove();
        createData();
        drawChart();

    }

    if(check == false){
        var userIndex = checkUser.indexOf(this.id);
        if(this.id == "Check All"){
            checkUser = [];
             d3.selectAll('input').property('checked',false);
        }else{
            checkUser.splice(userIndex, 1);
        }
        d3.select("#mlineBrush").select('svg').remove();
        createData();
        drawChart();

    }
})

createData();
 drawChart();

function unique(arr) {
    var hash = {}, result = [];
    for ( var i = 0, l = arr.length; i < l; ++i ) {
        if ( !hash.hasOwnProperty(arr[i]) ) { //it works with objects! in FF, at least
            hash[ arr[i] ] = true;
            result.push(arr[i]);
        }
    }
    return result;
}

function drawChart(){

    //create an SVG
var svg = d3.select("#mlineBrush").append("svg")
    .attr("width", "100%")
    .attr("height", "100%")
    .attr("viewBox", "0 0 900 500")
    .attr("preserveAspectRatio", "xMinYMin")
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top  + ")");

svg.append("defs")
  .append("clipPath")
    .attr("id", "clip")
    .append("rect")
    .attr("x", 0)
    .attr("y", -5)
    .attr("width", width + 20 )
    .attr("height", height );

    //setup the x and y scales
var x = d3.time.scale()
		.domain([
	    d3.min(lineData, function(c) { return d3.min(c.values, function(v) { return parseDate(v.creation_date); }); }),
	    d3.max(lineData, function(c) { return d3.max(c.values, function(v) { return parseDate(v.creation_date); }); })])
		.range([0, width]);

var x2 = d3.time.scale()
    .domain(x.domain())
    .range([0, width]); // Duplicate xScale for brushing ref later

var y = d3.scale.linear()
    .domain([0, d3.max(lineData, function(c) { return d3.max(c.values, function(v) { return v.total; }); }) ])
    .range([height, 0]);

var y2 = d3.scale.linear()
    .range([height2, 0])
    .domain(y.domain());

var line = d3.svg.line()
    //.interpolate("basis")
    .x(function(d){ return x(parseDate(d.creation_date)); })
    .y(function(d){ return y(d.total); });

var line2 = d3.svg.line()
    .x(function (d) { return x2(parseDate(d.creation_date)); })
    .y(function (d) { return y2(d.total); });

var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom")
    //.tickSize(-width, 0, 0)
    .tickPadding(10);

svg.append("svg:g")
    .attr("class", "x-axis");

var xAxis2 = d3.svg.axis() // xAxis for brush slider
    .scale(x2)
    .orient("bottom")
    .tickPadding(10);

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")
    .tickPadding(8);

svg.append("svg:g")
    .attr("class", "y-axis");

var context = svg.append("g") // Brushing context box container
    .attr("transform", "translate(" + 0 + "," + 410 + ")")
    .attr("class", "context");

context.selectAll('path')
    .data(lineData)
    .enter()
    .append('path')
    .attr('d', function (d) { return line2(d.values); })
    .style("stroke", function(d) { return color(d.key); });

context.append("g")
   .attr("class", "x axis2")
        .attr("transform", "translate(0," + height2 + ")")
        .call(xAxis2);

    var brush = d3.svg.brush()
    .x(x2)
    .on("brush", brushed);


var contextArea = d3.svg.area()
    .interpolate("monotone")
    .x(function(d){ return x2(parseDate(d.creation_date)); })
    .y0(height2)
    .y1(0);

context.append("path")
        .attr("class", "area")
        .attr("d", contextArea(lineData[0].values))
        .attr("fill", "#F1F1F2");

context.append("g")
        .attr("class", "x brush")
        .call(brush)
        .selectAll("rect")
        .attr("height", height2 + 5 )
        .attr("fill", "#E6E7E8");

var thegraph = svg.selectAll(".thegraph")
    .data(seriesData);

var thegraphEnter = thegraph.enter().append("g")
    .attr("clip-path", "url(#clip)")
    .attr("class", "thegraph")
    .attr("id", function(d){ return d.values[0].user_full_name.replace(/\s+/g, '')+ d.key.replace(/\s+/g, ''); })
    .style("stroke-width", "3");

//actually append the line to the graph
	thegraphEnter.append("path")
    	.attr("class", "line")
        .style("stroke", function(d) { return color(d.key); })
      	.attr("d", function(d) { return line(d.values); })
     .transition() // Call Transition Method
	.duration(4000) // Set Duration timing (ms)
	.ease("bounce") ;


    thegraphEnter.append("g").selectAll(".dot")
	    .data( function(d) {return(d.values);} )
        .enter().append("circle")
	   .attr("cx", function (d) {
	       return x(parseDate(d.creation_date));
	    })
	    .attr("cy", function (d) {
	       return y(d.total);
	    })
	    .attr("r", 5)
        .style("stroke", function (d) {
	       return color(this.parentNode.__data__.key)
	    })
	    .attr("fill", function (d) {
	        return color(this.parentNode.__data__.key)
	    })
        .attr("fill-opacity", 1)
	    .attr("stroke-width", 1)
        .style("stroke", "white")
        //.style("stroke-opacity", .8)
        .on("mouseover", function(d){

            div.transition()
                .duration(100)
                .style("opacity", 1);

            div.html(  "Item Type : "+ this.parentNode.__data__.key + "<br/>"+ " No. of Items : " + d.total + "<br/>" + "Date : " + d.creation_date )
                .style("left", (d3.event.pageX) + "px")
                .style("top", (d3.event.pageY - 28) + "px");
        })
    .on("mouseout", function (d) {
	        div.transition().duration(100).style("opacity", 0)
	    }) ;

     var typeClickLegends = [];
     var usrClickLegends = [];

     var legend = svg.selectAll(".legend")
            .data(item_type)
          .enter().append("g")
            .attr("class", "legend")
            .attr('id',function(d){ return d.replace(/\s+/g, ''); })
            .attr("transform", function (d, i) { return "translate(10," + i * 15 + ")"; })
     .on("click", function(d){

         var that = this;
         if(typeClickLegends.indexOf(this) == -1){
            typeClickLegends.push(this);

             d3.selectAll(".thegraph")
                .transition()
                    .duration(500)
                    .style("opacity", 0);

              d3.selectAll(".legend")
                .transition()
                .duration(500)
                .style("opacity", .3);
             var temp_usr = [];

             if(usrClickLegends.length > 0){
                 usrClickLegends.forEach(function(usrLegend){
                     temp_usr.push(usrLegend.id);
                 });

             }else{
                 temp_usr = userName;
             }

             typeClickLegends.forEach(function(legend){

                 temp_usr.forEach(function(name){
                    var lineId = "#"+name.replace(/\s+/g, '')+legend.id;

                    d3.selectAll(lineId)
                        .transition()
                        .duration(500)
                        .style("opacity", 1);
                })
            })
             typeClickLegends.forEach(function(legend){

                 d3.select(legend)
                    .attr("fakeclass", "fakelegend")
                    .transition()
                    .duration(500)
                    .style("opacity", 1);
             })

         }else{

                if(typeClickLegends.length > 1){

                    var currentItemLegend = typeClickLegends.indexOf(this);
                    typeClickLegends.splice( currentItemLegend, 1)

                    userName.forEach(function(name){
                        var lineId = "#"+name.replace(/\s+/g, '')+that.id;

                        d3.selectAll(lineId)
                            .transition()
                            .duration(500)
                            .style("opacity", 0);
                    })

                    d3.select(this)
                        .attr("fakeclass", "fakelegend")
                        .transition()
                        .duration(500)
                        .style("opacity", .3);

                }else{
                    typeClickLegends = [];
                    d3.selectAll(".thegraph")
                        .transition()
                        .duration(500)
                        .style("opacity", 1);

                    d3.selectAll(".legend")
                        .transition()
                        .duration(500)
                        .style("opacity", 1);

                     d3.selectAll(".userlegend")
                        .transition()
                        .duration(500)
                        .style("opacity", 1);

                     d3.select(this)
                    .attr("fakeclass", "fakelegend")
                    .transition()
                    .duration(500)
                    .style("opacity", 1);

            }
         }
     });

        legend.append("rect")
            .attr("x", width + 5)
            .attr("width", 20)
            .attr("height", 10)
            .style("fill",function(d) { return color(d); } );
            //.style("stroke", "grey");

        legend.append("text")
            .attr("x", width + 30)
            .attr("y", 5)
            .attr("dy", ".35em")
            //.style("fill",function(d) { return color(d); } )
            .text(function (d) { return d; });

// update the axes,
  // Add the X Axis
    svg.append("g")
        .attr("clip-path", "url(#clip)")
        .attr("class", "axis x")
        .attr("transform", "translate(0," + height + ")")
        .style("font-family", "sans-serif")
        .style("shape-rendering", "crispEdges")
        .style("font-size", "8px")
        .call(xAxis);

    // Add the Y Axis
    svg.append("g")
        .attr("class", "axis y")
        .style("font-size", "8px")
        .call(yAxis)
        .append("text")
        .attr("transform", "rotate(-90)")
        .attr("x", -150)
        .attr("y", -40)
        .style("text-anchor", "end")
        .style("font-size", 12)
        .style("font-weight", "bold")
        .text("NO. OF ITEMS");;

    function brushed() {

        x.domain(brush.empty() ? x2.domain() : brush.extent()); // If brush is empty then reset the Xscale domain to default, if not then make it the brush extent

        svg.select(".x.axis") // replot xAxis with transition when brush used
            .transition()
            .call(xAxis);

        svg.select(".y.axis") // Redraw yAxis
            .transition()
            .call(yAxis);

        thegraph.selectAll("path") // Redraw lines based on brush xAxis scale and domain
            .transition()
            .attr("d", function(d){ return line(d.values) ; });

        thegraph.selectAll("circle") // Redraw circles based on brush xAxis scale and domain
            .transition()
            .attr("cx", function(d) { return x(parseDate(d.creation_date)); })
            .attr("cy", function (d) { return y(d.total); });
  }// end of brush

}
}
