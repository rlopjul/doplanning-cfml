function drawChart(totalItems){


  //console.log(testdata);
var margin = {top: 40, right: 20, bottom: 80, left: 50},
width = 900 - margin.left - margin.right ,
height = 500 - margin.top - margin.bottom ;

var x = d3.scale.ordinal()
.rangeRoundBands([0, width], .1);

var y = d3.scale.linear()
.rangeRound([height, 0]);


var color = d3.scale.ordinal()    .range(["#8dd3c7","#bebada","#fb8072","#80b1d3","#fdb462","#b3de69","#b15928","#e5c494","#fccde5","#bc80bd","#ccebc5","#ffed6f","#1f78b4"]);

var userList = [];
var checkUser = [];

totalItems.forEach(function(d){

if(userList.indexOf(d.user_full_name) == -1 && d.user_full_name){
userList.push(d.user_full_name);
}
});

userList.unshift("Check All");

var form = d3.select("#stackLegend").append("form");

var checkEnter = form.selectAll("span")
.data(userList)
.enter()
.append("span");

checkEnter.append("input")
.attr({
type: "checkbox",
name: "mode",
class: "stackInput",
id: function(d){ return d.replace(/\s+/g, '-') + "stackLegend"; }
})
.property("checked", function(d,i){
return true;
});

checkEnter.append("label")
.style("font=size", "8px")
.text(function(d){ return d; });

checkEnter.append("br")

userList.shift();
checkUser = userList;

d3.selectAll(".stackInput").on("change", function(){
var check = this.checked ? true : false;
var userId = this.id.replace(/-/g, " ").substr(0, this.id.length - 11);

if( check == true){
if(userId == "Check All"){
  checkUser = userList.slice();
  d3.selectAll('.stackInput').property('checked', true);
}else{
  checkUser.push(userId);
}

d3.select("#userLogArea").select('svg').remove();
updateData();
drawStackBar();
}else{
var userIndex = checkUser.indexOf(userId);
if(userId == "Check All"){
  checkUser = [];
  d3.selectAll(".stackInput").property("checked", false);
}else{
  checkUser.splice(userIndex, 1);
}
d3.select("#userLogArea").select('svg').remove();
updateData();
drawStackBar();
}
})

var nestedData = d3.nest()
      .key( function(d) {
           return d.item_type_label;})
      .entries(totalItems);

//dynamicaaly remove undefined array from object
nestedData.forEach(function(obj, i){

if(obj.key == "undefined"){
  nestedData.splice(i,1);
}
});

//Using map to create one nested object of nestedfilter data.
//Using the first key in nested data to create object key and using values from second
// nest to creat a array of values. First map is over the itemtype and second
// map is over date and total. Aggregate the date and total to first nest.

var layerData;
function updateData(){
  layerData = nestedData.map(function (objectArray) {

    var y0 = 0;
        return {
            key: objectArray.key,
            values: objectArray.values.map(function (d) {

                if( checkUser.indexOf(d.user_full_name) != -1 ){
                   // console.log(checkUser.indexOf(d.user_full_name));
                    return {
                        name: d.user_full_name,
                        y0: y0,
                        y1: y0 += +[d.total]
                    }
                }else{
                    return {
                        name: d.user_full_name,
                        y0: 0,
                        y1: 0
                    }
                }
            }),
        };
      });

      layerData.forEach(function(d) {

        if(d.values[d.values.length - 1].y1 !=0 ){
           d.total = d.values[d.values.length - 1].y1;
       }else{
           for(var i = 0; i < d.values.length; i++ ){
               if( d.values[i].y1 !=0){
                   d.total = d.values[i].y1;
               }
           }
       }
      });

      layerData.sort(function (a, b) {
              return b.values[0].y1 - a.values[0].y1;
          });

          x.domain(layerData.map(function(d) { return d.key; }));
          y.domain([0, d3.max(layerData, function(d) { return d.total; })]);
  }

drawStackBar();
//drawUserLegend()
function drawStackBar(){

var svg = d3.select("#userLogArea").append("svg")
.attr("width", "100%")
.attr("height", "100%")
.attr("viewBox", "0 0 900 500")
.attr("preserveAspectRation", "xMidYMid")
.append("g")
.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

var xAxis = d3.svg.axis()
.scale(x)
.orient("bottom");

svg.append("svg:g")
.attr("class", "x-axis");

var yAxis = d3.svg.axis()
.scale(y)
.orient("left");

svg.append("svg:g")
.attr("class", "y-axis");

updateData();

var layer = svg.selectAll(".stack")
.data(layerData)
.enter().append("g")
.attr("class", "stack")
.attr("id", function(d){
  return d.key.replace(/\s+/g, "")+"stack";
})
.attr("transform", function(d) { return "translate(" + x(d.key) + ",0)"; });

layer.selectAll("rect")
.data(function(d) { return d.values; })
.enter().append("rect")
.attr("width", x.rangeBand())
.attr("y", function(d) { return y(d.y1); })
.attr("height", function(d) { return y(d.y0) - y(d.y1);  })
.style("fill", function(d) { return color(d.name); });

var legend = d3.select
svg.append("g")
.attr("class", "x axis")
.attr("transform", "translate(0," + height + ")")
.call(xAxis)
.selectAll(".tick text")
.call(wrap, x.rangeBand());;

svg.append("g")
.attr("class", "y axis")
.call(yAxis)
.append("text")
.attr("transform", "rotate(-90)")
.attr("y", 6)
.attr("dy", ".71em")
.style("text-anchor", "end")
.text("Total");
}

function wrap(text, width) {
text.each(function() {
var text = d3.select(this),
words = text.text().split(/\s+/).reverse(),
word,
line = [],
lineNumber = 0,
lineHeight = 1.1, // ems
y = text.attr("y"),
dy = parseFloat(text.attr("dy")),
tspan = text.text(null).append("tspan").attr("x", 0).attr("y", y).attr("dy", dy + "em");

while (word = words.pop()) {
line.push(word);
tspan.text(line.join(" "));
if (tspan.node().getComputedTextLength() > width) {
line.pop();
tspan.text(line.join(" "));
line = [word];
tspan = text.append("tspan").attr("x", 0).attr("y", y).attr("dy", ++lineNumber * lineHeight + dy + "em").text(word);
}
}
});
}


//https://gist.github.com/biovisualize/3085882
function drawUserLegend(){
var userName = ["lkj", "asd", "ard", "asiur"];

var svgLegend = d3.select("#stackLegend").append("svg")
.attr("width", 100)
.attr("height", 100);

svgLegend.append("foreignObject")
.data(function(d){ return userName; })
.attr("width", 100)
.attr("height", 100)
.append("xhtml:body")
.html(function(d){  for(var i=0; i<5; i++){  return "<form><input type=checkbox id=check /></form>"; } })
.on("click", function(d, i){
  console.log(i);
  console.log(svgLegend.select("#check").node().checked);
});

}
}
