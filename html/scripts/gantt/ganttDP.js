
//--------------------------------  PREPARANDO DATOS ---------------------
var anchura=700;
var tareillas=new Array();
var taskNames=new Array();
var taskStatus = {
    "SUCCEEDED" : "bar",
    "FAILED" : "bar-failed"
};
var tasks=new Array();
var hecho="";
var comienza=new Date();
var finaliza=new Date();
var altura=0;

//----------------------------------------------------------------------

function cargarDatos()
{

    if(tareillas.length > 0) {

        for (var i = tareillas.length-1; i >= 0; i--) 
        {
            
            taskNames[i]=tareillas[i].title;
            if (tareillas[i].done===0)
            {
                hecho="FAILED";
            }
            else
            {
                hecho="SUCCEEDED"
            }
            taskStatus[i]=hecho;
            comienza=new Date(tareillas[i].start_date);
            comienza.setHours(0);
            finaliza=new Date(tareillas[i].end_date);
            finaliza.setHours(0);
            var creationDate = new Date(tareillas[i].creation_date);
            tasks[i]={"startDate":comienza,"endDate":finaliza,"creationDate":creationDate,"taskName":tareillas[i].title, "status":hecho, "tareaid":tareillas[i].id}
        };
        altura = tasks.length*37;
        hacerGantt();

    }
}

//-------------------------------  FIN PREPARAR DATOS --------------------

var gantt;

function hacerGantt()
{

tasks.sort(function(a, b) {
    return a.endDate - b.endDate;
});


var maxDate = tasks[tasks.length - 1].endDate;

tasks.sort(function(a, b) {
    return a.startDate - b.startDate;
});

var minDate = tasks[0].startDate;
var format = "%H:%M";
//var timeDomainString = "1month";
var timeDomainString = "1monthOnlyDays";

gantt = d3.gantt().taskTypes(taskNames).taskStatus(taskStatus).tickFormat(format).height(altura).width(anchura);

gantt.timeDomainMode("fit");
changeTimeDomain(timeDomainString);

gantt(tasks);

}

//-------------------------------------------------------

function changeTimeDomain(timeDomainString) {

    this.timeDomainString = timeDomainString;

    switch (timeDomainString) {

        case "1hr":
    	format = "%H:%M:%S";
    	gantt.timeDomain([ d3.time.hour.offset(getEndDate(), -1), getEndDate() ]);
    	break;
        case "3hr":
    	format = "%H:%M";
    	gantt.timeDomain([ d3.time.hour.offset(getEndDate(), -3), getEndDate() ]);
    	break;

        case "6hr":
    	format = "%H:%M";
    	gantt.timeDomain([ d3.time.hour.offset(getEndDate(), -6), getEndDate() ]);
    	break;

        case "1day":
    	format = "%H:%M";
    	gantt.timeDomain([ d3.time.day.offset(getEndDate(), -1), getEndDate() ]);
    	break;

        case "1week":
    	format = "%a %H:%M";
    	gantt.timeDomain([ d3.time.day.offset(getEndDate(), -7), getEndDate() ]);
    	break;

        case "1month":
        format = "%a %H:%M";
        gantt.timeDomain([ d3.time.day.offset(getEndDate(), -7), getEndDate() ]);
        break;

        case "1monthOnlyDays":
        format = "%a";
        gantt.timeDomain([ d3.time.month.offset(getEndDate(), -31), getEndDate() ]);
        break;

        default:
    	format = "%H:%M"



    }
    gantt.tickFormat(format);
    gantt.redraw(tasks);
}

//--------------------------------------------------------------------------

function getEndDate() {
    var lastEndDate = Date.now();
    if (tasks.length > 0) {
	lastEndDate = tasks[tasks.length - 1].endDate;
    }

    return lastEndDate;
}
function verDatos(i)
{
    /*var startDateMoment = moment(i.startDate);
    var creationDateMoment = moment(i.creationDate);

    var contenido="Name of the task: <br>"+i.taskName+"<br><br>Descripción de la tarea:<br> Esto es solo una prueba de todo este trozo<br><br>"+"El id de la tarea es:<br>"+ i.tareaid+ "<br><br> La tarea está hecha: <br>"+i.status+"<br>Fecha: "+startDateMoment.format('DD-MM-YYYY HH:mm:ss')+"<br>Fecha creación: "+creationDateMoment.format('DD-MM-YYYY HH:mm:ss');
    var zonainfo=document.getElementById("infoderecha");
    zonainfo.innerHTML=contenido;*/

    // Open task URL
    var itemUrl = "task.cfm?task="+i.tareaid;
    openUrlLite(itemUrl,'itemIframe');

};


//------------------------------------------------------------------------------------------


// Define 'div' for tooltips
var div = d3.select("body")
    .append("div")  // declare the tooltip div 
    .attr("class", "tooltip") // apply the 'tooltip' class
    .style("opacity", 0);  // set the opacity to nil

function showD3Tooltip(data) {

    div.transition()
            .duration(500)    
            .style("opacity", 0);
        div.transition()
            .duration(200)    
            .style("opacity", .9);    
        div .html('<div class="tooltip-inner">'+
                data.taskName+
                '</div>'
               )     
            .style("left", (d3.event.pageX + 3) + "px")             
            .style("top", (d3.event.pageY - 32) + "px");

}

function hideD3Tooltip(data) {

    div.transition()        
            .duration(500)      
            .style("opacity", 0);   
}


//---------------------------------------------------------

function setItems(items) {

    tareillas = items;
    cargarDatos();
}


//----------------------------  CARGANDO  MIS TAREAS --------------------------------------------------
// para cargar las tareas y pasarlas a javascript usable

/*var HttpClient = function() {
    this.get = function(aUrl, aCallback) {
        anHttpRequest = new XMLHttpRequest();
        anHttpRequest.onreadystatechange = function() { 
            if (anHttpRequest.readyState == 4 && anHttpRequest.status == 200)
                aCallback(anHttpRequest.responseText);
        }

        anHttpRequest.open( "GET", aUrl, true );            
        anHttpRequest.send( null );
    }
}*/

//---------------------------------------------------------

/*function escribirjson(answer)
{   
    //$("#dataTextArea2").val(answer);
    tareillas = JSON.parse(answer);
    cargarDatos();
}*/

//----------------------------------------------------
