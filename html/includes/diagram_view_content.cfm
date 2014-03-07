<div style="clear:both"></div>

<textarea id="graphContent" style="width:100%; height:500px;">
{
  "cells": [
    {
      "type": "fsa.StartState",
      "size": {
        "width": 20,
        "height": 20
      },
      "position": {
        "x": 50,
        "y": 530
      },
      "angle": 0,
      "id": "4117bfd3-bc2a-46b7-9426-8c5fa82053fb",
      "z": 0,
      "attrs": {
        
      }
    },
    {
      "type": "fsa.State",
      "size": {
        "width": 60,
        "height": 60
      },
      "position": {
        "x": 180,
        "y": 390
      },
      "angle": 0,
      "id": "63bfa8fd-9846-4583-a47f-7cf0a3c20586",
      "z": 1,
      "attrs": {
        "text": {
          "text": "code"
        }
      }
    },
    {
      "type": "fsa.State",
      "size": {
        "width": 60,
        "height": 60
      },
      "position": {
        "x": 340,
        "y": 220
      },
      "angle": 0,
      "id": "e73877a5-cca8-4d82-9d4c-e8b1d6f13867",
      "z": 2,
      "attrs": {
        "text": {
          "text": "slash"
        }
      }
    },
    {
      "type": "fsa.State",
      "size": {
        "width": 60,
        "height": 60
      },
      "position": {
        "x": 600,
        "y": 400
      },
      "angle": 0,
      "id": "fa6e83f3-7c6c-49cb-a6b4-9c8c252a8a0b",
      "z": 3,
      "attrs": {
        "text": {
          "text": "star"
        }
      }
    },
    {
      "type": "fsa.State",
      "size": {
        "width": 60,
        "height": 60
      },
      "position": {
        "x": 190,
        "y": 100
      },
      "angle": 0,
      "id": "7639d5d4-1dd1-4dda-bdae-fe64fd335327",
      "z": 4,
      "attrs": {
        "text": {
          "text": "line"
        }
      }
    },
    {
      "type": "fsa.State",
      "size": {
        "width": 60,
        "height": 60
      },
      "position": {
        "x": 560,
        "y": 140
      },
      "angle": 0,
      "id": "6dcdeb38-6fe3-4c5e-9a5d-93cbd55e05c2",
      "z": 5,
      "attrs": {
        "text": {
          "text": "block"
        }
      }
    },
    {
      "type": "fsa.Arrow",
      "smooth": true,
      "source": {
        "id": "4117bfd3-bc2a-46b7-9426-8c5fa82053fb"
      },
      "target": {
        "id": "63bfa8fd-9846-4583-a47f-7cf0a3c20586"
      },
      "labels": [
        {
          "position": 0.5,
          "attrs": {
            "text": {
              "text": "start",
              "font-weight": "bold"
            }
          }
        }
      ],
      "vertices": [
        
      ],
      "id": "8eeba1f3-d698-4b57-8c20-147e36ba360e",
      "z": 6,
      "attrs": {
        
      }
    },
    {
      "type": "fsa.Arrow",
      "smooth": true,
      "source": {
        "id": "63bfa8fd-9846-4583-a47f-7cf0a3c20586"
      },
      "target": {
        "id": "e73877a5-cca8-4d82-9d4c-e8b1d6f13867"
      },
      "labels": [
        {
          "position": 0.5,
          "attrs": {
            "text": {
              "text": "\/",
              "font-weight": "bold"
            }
          }
        }
      ],
      "vertices": [
        
      ],
      "id": "988d13e7-df86-407e-9fa3-8833b4a65cc8",
      "z": 7,
      "attrs": {
        
      }
    },
    {
      "type": "fsa.Arrow",
      "smooth": true,
      "source": {
        "id": "e73877a5-cca8-4d82-9d4c-e8b1d6f13867"
      },
      "target": {
        "id": "63bfa8fd-9846-4583-a47f-7cf0a3c20586"
      },
      "labels": [
        {
          "position": 0.5,
          "attrs": {
            "text": {
              "text": "other",
              "font-weight": "bold"
            }
          }
        }
      ],
      "vertices": [
        {
          "x": 270,
          "y": 300
        }
      ],
      "id": "cc1e9ee2-bc4f-4efa-a7a9-362f04a0f2c7",
      "z": 8,
      "attrs": {
        
      }
    },
    {
      "type": "fsa.Arrow",
      "smooth": true,
      "source": {
        "id": "e73877a5-cca8-4d82-9d4c-e8b1d6f13867"
      },
      "target": {
        "id": "7639d5d4-1dd1-4dda-bdae-fe64fd335327"
      },
      "labels": [
        {
          "position": 0.5,
          "attrs": {
            "text": {
              "text": "\/",
              "font-weight": "bold"
            }
          }
        }
      ],
      "vertices": [
        
      ],
      "id": "469b8b2f-42ec-49d5-a78d-6c93c44d4f6f",
      "z": 9,
      "attrs": {
        
      }
    },
    {
      "type": "fsa.Arrow",
      "smooth": true,
      "source": {
        "id": "7639d5d4-1dd1-4dda-bdae-fe64fd335327"
      },
      "target": {
        "id": "63bfa8fd-9846-4583-a47f-7cf0a3c20586"
      },
      "labels": [
        {
          "position": 0.5,
          "attrs": {
            "text": {
              "text": "new\n line",
              "font-weight": "bold"
            }
          }
        }
      ],
      "vertices": [
        
      ],
      "id": "fbafca47-bc95-4125-89e5-cee295ae1630",
      "z": 10,
      "attrs": {
        
      }
    },
    {
      "type": "fsa.Arrow",
      "smooth": true,
      "source": {
        "id": "e73877a5-cca8-4d82-9d4c-e8b1d6f13867"
      },
      "target": {
        "id": "6dcdeb38-6fe3-4c5e-9a5d-93cbd55e05c2"
      },
      "labels": [
        {
          "position": 0.5,
          "attrs": {
            "text": {
              "text": "*",
              "font-weight": "bold"
            }
          }
        }
      ],
      "vertices": [
        
      ],
      "id": "16709ab0-8862-44e7-8a79-314b98cca9d8",
      "z": 11,
      "attrs": {
        
      }
    },
    {
      "type": "fsa.Arrow",
      "smooth": true,
      "source": {
        "id": "6dcdeb38-6fe3-4c5e-9a5d-93cbd55e05c2"
      },
      "target": {
        "id": "fa6e83f3-7c6c-49cb-a6b4-9c8c252a8a0b"
      },
      "labels": [
        {
          "position": 0.5,
          "attrs": {
            "text": {
              "text": "*",
              "font-weight": "bold"
            }
          }
        }
      ],
      "vertices": [
        
      ],
      "id": "536eec6a-b0b3-4271-90fb-522945aeabb0",
      "z": 12,
      "attrs": {
        
      }
    },
    {
      "type": "fsa.Arrow",
      "smooth": true,
      "source": {
        "id": "fa6e83f3-7c6c-49cb-a6b4-9c8c252a8a0b"
      },
      "target": {
        "id": "6dcdeb38-6fe3-4c5e-9a5d-93cbd55e05c2"
      },
      "labels": [
        {
          "position": 0.5,
          "attrs": {
            "text": {
              "text": "other",
              "font-weight": "bold"
            }
          }
        }
      ],
      "vertices": [
        {
          "x": 650,
          "y": 290
        }
      ],
      "id": "fed471c1-3eb6-4ec5-b22e-f541d0a0920c",
      "z": 13,
      "attrs": {
        
      }
    },
    {
      "type": "fsa.Arrow",
      "smooth": true,
      "source": {
        "id": "fa6e83f3-7c6c-49cb-a6b4-9c8c252a8a0b"
      },
      "target": {
        "id": "63bfa8fd-9846-4583-a47f-7cf0a3c20586"
      },
      "labels": [
        {
          "position": 0.5,
          "attrs": {
            "text": {
              "text": "\/",
              "font-weight": "bold"
            }
          }
        }
      ],
      "vertices": [
        {
          "x": 490,
          "y": 310
        }
      ],
      "id": "7255dbb2-1d9b-47a2-945c-ae59bc78090a",
      "z": 14,
      "attrs": {
        
      }
    },
    {
      "type": "fsa.Arrow",
      "smooth": true,
      "source": {
        "id": "7639d5d4-1dd1-4dda-bdae-fe64fd335327"
      },
      "target": {
        "id": "7639d5d4-1dd1-4dda-bdae-fe64fd335327"
      },
      "labels": [
        {
          "position": 0.5,
          "attrs": {
            "text": {
              "text": "other",
              "font-weight": "bold"
            }
          }
        }
      ],
      "vertices": [
        {
          "x": 115,
          "y": 100
        },
        {
          "x": 250,
          "y": 50
        }
      ],
      "id": "f443295d-51bb-4010-84e7-36986f7e279a",
      "z": 15,
      "attrs": {
        
      }
    },
    {
      "type": "fsa.Arrow",
      "smooth": true,
      "source": {
        "id": "6dcdeb38-6fe3-4c5e-9a5d-93cbd55e05c2"
      },
      "target": {
        "id": "6dcdeb38-6fe3-4c5e-9a5d-93cbd55e05c2"
      },
      "labels": [
        {
          "position": 0.5,
          "attrs": {
            "text": {
              "text": "other",
              "font-weight": "bold"
            }
          }
        }
      ],
      "vertices": [
        {
          "x": 485,
          "y": 140
        },
        {
          "x": 620,
          "y": 90
        }
      ],
      "id": "c2fce50b-5caf-44c2-8324-bbcea6782f42",
      "z": 16,
      "attrs": {
        
      }
    },
    {
      "type": "fsa.Arrow",
      "smooth": true,
      "source": {
        "id": "63bfa8fd-9846-4583-a47f-7cf0a3c20586"
      },
      "target": {
        "id": "63bfa8fd-9846-4583-a47f-7cf0a3c20586"
      },
      "labels": [
        {
          "position": 0.5,
          "attrs": {
            "text": {
              "text": "other",
              "font-weight": "bold"
            }
          }
        }
      ],
      "vertices": [
        {
          "x": 180,
          "y": 500
        },
        {
          "x": 305,
          "y": 450
        }
      ],
      "id": "9cacb22f-382c-452c-bad1-1b6f32a1693f",
      "z": 17,
      "attrs": {
        
      }
    }
  ]
}
</textarea>

<button id="showButton">Mostrar cambios</button>

<div id="paper"></div><!---style="border-color:#000000; border-width:1px; border-style:solid;"--->

<script>
	
	function setGraphJSON(graph, jsonStr) {

		graph.fromJSON(JSON.parse(jsonStr));

	}

	var graph = new joint.dia.Graph;

	var paper = new joint.dia.Paper({
	    el: $('#paper'),
	    width: 800,
	    height: 600,
	    gridSize: 1,
	    model: graph
	});

	var jsonStr = $("#graphContent").val();
	setGraphJSON(graph, jsonStr);

	$( "#showButton" ).click(function() {
	  
		var jsonStr = $("#graphContent").val();
		setGraphJSON(graph, jsonStr);

	});

</script>

<!--- 
<script>
	
	var graph = new joint.dia.Graph;

	var paper = new joint.dia.Paper({
	    el: $('#paper'),
	    width: 800,
	    height: 600,
	    gridSize: 1,
	    model: graph
	});

	function state(x, y, label) {
	    
	    var cell = new joint.shapes.fsa.State({
	        position: { x: x, y: y },
	        size: { width: 60, height: 60 },
	        attrs: { text : { text: label }}
	    });
	    graph.addCell(cell);
	    return cell;
	};

	function link(source, target, label, vertices) {
	    
	    var cell = new joint.shapes.fsa.Arrow({
	        source: { id: source.id },
	        target: { id: target.id },
	        labels: [{ position: .5, attrs: { text: { text: label || '', 'font-weight': 'bold' } } }],
	        vertices: vertices || []
	    });
	    graph.addCell(cell);
	    return cell;
	}

	var start = new joint.shapes.fsa.StartState({ position: { x: 50, y: 530 } });
	graph.addCell(start);

	var code  = state(180, 390, 'code');
	var slash = state(340, 220, 'slash');
	var star  = state(600, 400, 'star');
	var line  = state(190, 100, 'line');
	var block = state(560, 140, 'block');

	link(start, code,  'start');
	link(code,  slash, '/');
	link(slash, code,  'other', [{x: 270, y: 300}]);
	link(slash, line,  '/');
	link(line,  code,  'new\n line');
	link(slash, block, '*');
	link(block, star,  '*');
	link(star,  block, 'other', [{x: 650, y: 290}]);
	link(star,  code,  '/',     [{x: 490, y: 310}]);
	link(line,  line,  'other', [{x: 115,y: 100}, {x: 250, y: 50}]);
	link(block, block, 'other', [{x: 485,y: 140}, {x: 620, y: 90}]);
	link(code,  code,  'other', [{x: 180,y: 500}, {x: 305, y: 450}]);


	$("#graphContent").val(JSON.stringify(graph.toJSON()));

</script>
 --->



<!---<cfset graph = structNew()>

<cfset graph = {
	    position: { x: 100, y: 30 },
	    size: { width: 100, height: 30 },
	    attrs: { rect: { fill: 'blue' }, text: { text: 'rectángulo', fill: 'white' } }
	}>

<cfoutput>
	<textarea>
		#SerializeJSON(graph)#
	</textarea>

<script>

	var graph = new joint.dia.Graph;

	var paper = new joint.dia.Paper({
	    el: $('##paper-basic'),
	    width: 600,
	    height: 500,
	    model: graph,
	    gridSize: 1
	});

	<!---var rect = new joint.shapes.basic.Rect({
	    position: { x: 100, y: 30 },
	    size: { width: 100, height: 30 },
	    attrs: { rect: { fill: 'blue' }, text: { text: 'cuadro', fill: 'white' } }
	});--->
	
	var rect = new joint.shapes.basic.Rect(#SerializeJSON(graph)#);

	var rect2 = rect.clone();
	rect2.translate(300);

	var link = new joint.dia.Link({
	    source: { id: rect.id },
	    target: { id: rect2.id }
	});

	graph.addCells([rect, rect2, link]);


</script>

</cfoutput>--->


