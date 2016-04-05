function areaTree(treeXml){
  var margin = {top: 20, right: 120, bottom: 20, left: 120},
    width = 1200 - margin.right - margin.left,
    height = 900 - margin.top - margin.bottom;

var i = 0,
    duration = 750,
    root;

// Calculate total nodes, max label length
	var totalNodes = 0;
	var maxLabelLength = 0;
	// panning variables
	var panSpeed = 200;
	var panBoundary = 20; // Within 20px from edges will pan when dragging.

var tree = d3.layout.tree()
    .size([height, width]);

var diagonal = d3.svg.diagonal()
    .projection(function(d) { return [d.y, d.x]; });

function pan(domNode, direction) {
			var speed = panSpeed;
			if (panTimer) {
				clearTimeout(panTimer);
				translateCoords = d3.transform(svgGroup.attr("transform"));
				if (direction == 'left' || direction == 'right') {
					translateX = direction == 'left' ? translateCoords.translate[0] + speed : translateCoords.translate[0] - speed;
					translateY = translateCoords.translate[1];
				} else if (direction == 'up' || direction == 'down') {
					translateX = translateCoords.translate[0];
					translateY = direction == 'up' ? translateCoords.translate[1] + speed : translateCoords.translate[1] - speed;
				}
				scaleX = translateCoords.scale[0];
				scaleY = translateCoords.scale[1];
				scale = zoomListener.scale();
				svgGroup.transition().attr("transform", "translate(" + translateX + "," + translateY + ")scale(" + scale + ")");
				d3.select(domNode).select('g.node').attr("transform", "translate(" + translateX + "," + translateY + ")");
				zoomListener.scale(zoomListener.scale());
				zoomListener.translate([translateX, translateY]);
				panTimer = setTimeout(function() {
					pan(domNode, speed, direction);
				}, 50);
			}
		}

function visit(parent, visitFn, childrenFn) {
			if (!parent) return;
			visitFn(parent);
			var children = childrenFn(parent);
			if (children) {
				var count = children.length;
				for (var i = 0; i < count; i++) {
					visit(children[i], visitFn, childrenFn);
				}
			}
		}


function zoom() {
			svg.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
		}
		// define the zoomListener which calls the zoom function on the "zoom" event constrained within the scaleExtents

var zoomListener = d3.behavior.zoom().scaleExtent([0.1, 3]).on("zoom", zoom);


function centerNode(source) {
			scale = zoomListener.scale();
			x = -source.y0;
			y = -source.x0;
			x = x * scale + width / 2;
			y = y * scale + height / 2;
			d3.select('g').transition()
				.duration(duration)
				.attr("transform", "translate(" + x + "," + y + ")scale(" + scale + ")");
			zoomListener.scale(scale);
			zoomListener.translate([x, y]);
		}

var svg = d3.select("#treeContainer").append("svg")
    .attr("width", "100%")
    .attr("height", "100%")
    .attr("viewBox", "0 0 1200 900")
    .attr("preserveAspectRatio", "xMinYMin")
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    .attr("class", "overlay")
    .call(zoomListener);


function drawTree(flare) {

    var flareJSON = xmlToJson(flare);

    // Call visit function to establish maxLabelLength
    visit(flareJSON._children[0], function(d) {
		totalNodes++;
		maxLabelLength = Math.max(d.name.length, maxLabelLength);
	}, function(d) {
		return d.children && d.children.length > 0 ? d.children : null;
    });

    root = flareJSON._children[0];
    root.x0 = height/6;
    root.y0 = 0;

    function collapse(d) {
    	if (d.children) {
   	   d._children = d.children;
     	   d._children.forEach(collapse);
      	   d.children = null;
    	}
    }

    root.children.forEach(collapse);
    centerNode(root);
    update(root);

  //  d3.select("#reset").on("click", centerNode(root));

};

drawTree(treeXml);
function update(source) {

	var levelWidth = [1];

	var childCount = function(level, n) {
			if (n.children && n.children.length > 0) {
				if (levelWidth.length <= level + 1) levelWidth.push(0);
					levelWidth[level + 1] += n.children.length;
					n.children.forEach(function(d) {
						childCount(level + 1, d);
					});
				}
			};

	childCount(0, root);
	var newHeight = d3.max(levelWidth) * 25; // 25 pixels per line
	tree = tree.size([newHeight, width]);

	// Compute the new tree layout.
	var nodes = tree.nodes(root).reverse(),
		links = tree.links(nodes);
		// Set widths between levels based on maxLabelLength.
		nodes.forEach(function(d) {
			d.y = (d.depth * (maxLabelLength * 10)); //maxLabelLength * 10px
			});

  // Update the nodes…
  var node = svg.selectAll("g.node")
      .data(nodes, function(d) { return d.id || (d.id = ++i); });

  // Enter any new nodes at the parent's previous position.
  var nodeEnter = node.enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; })
      .on("click", click);

  nodeEnter.append("circle")
      .attr("r", 1e-6)
      .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; });

  nodeEnter.append("text")
      .attr("x", function(d) { return d.children || d._children ? -10 : 10; })
      .attr("dy", ".35em")
      .attr("text-anchor", function(d) { return d.children || d._children ? "end" : "start"; })
      .text(function(d) { return d.name; })
      .style("fill-opacity", 1e-6);

  // Transition nodes to their new position.
  var nodeUpdate = node.transition()
      .duration(duration)
      .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });

  nodeUpdate.select("circle")
      .attr("r", 4.5)
      .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; });

  nodeUpdate.select("text")
      .style("fill-opacity", 1);

  // Transition exiting nodes to the parent's new position.
  var nodeExit = node.exit().transition()
      .duration(duration)
      .attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })
      .remove();

  nodeExit.select("circle")
      .attr("r", 1e-6);

  nodeExit.select("text")
      .style("fill-opacity", 1e-6);

  // Update the links…
  var link = svg.selectAll("path.link")
      .data(links, function(d) { return d.target.id; });

  // Enter any new links at the parent's previous position.
  link.enter().insert("path", "g")
      .attr("class", "link")
      .attr("d", function(d) {
        var o = {x: source.x0, y: source.y0};
        return diagonal({source: o, target: o});
      });

  // Transition links to their new position.
  link.transition()
      .duration(duration)
      .attr("d", diagonal);

  // Transition exiting nodes to the parent's new position.
  link.exit().transition()
      .duration(duration)
      .attr("d", function(d) {
        var o = {x: source.x, y: source.y};
        return diagonal({source: o, target: o});
      })
      .remove();

  // Stash the old positions for transition.
  nodes.forEach(function(d) {
    d.x0 = d.x;
    d.y0 = d.y;
  });
}

// Toggle children on click.
function click(d) {
  if (d.children) {
    d._children = d.children;
    d.children = null;
  } else {
    d.children = d._children;
    d._children = null;
  }
  update(d);
   centerNode(d);
}

function xmlToJson(xml){

    var obj = {};

    if (xml.nodeType == 1) { // element
        // do attributes
        if (xml.attributes.length > 0) {
            for (var j = 0; j < xml.attributes.length; j++) {
                var attribute = xml.attributes.item(j);
                obj[attribute.nodeName] = attribute.nodeValue;
            }
        }
    }

    if (xml.hasChildNodes()) {

        for (var i = 0; i < xml.childNodes.length; i++)
        {
            // if recursive call returned a node, append it to children

            var child = xmlToJson(xml.childNodes.item(i));

            if(child)
            {

                if(!child.name || child.parent_id == 422){
                    (obj.children || (obj.children = [])).push(child);
                }else {
                (obj._children || (obj._children = [])).push(child);
                }
            }

        }

    }

    return obj;

};
}
