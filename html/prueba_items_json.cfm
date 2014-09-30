<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<cfoutput>
<title>#APPLICATION.title#</title>
<script src="#APPLICATION.jqueryJSPath#"></script>
<script src="#APPLICATION.path#/jquery/jquery.serializecfjson-0.2.min.js"></script>
<!---<script src="http://examples.cutterscrossing.com/serializeCFJSON/resources/scripts/jquery-plugins/jquery-json/jquery.json-2.3.min.js"></script>
<script src="http://examples.cutterscrossing.com/serializeCFJSON/resources/scripts/google-code-prettify/prettify.js"></script>--->
</cfoutput>
</head>

<cfparam name="URL.area" default="491">
<cfparam name="URL.itemTypeId" default="6">

<body>

<cfoutput>
<b>ÁREA ID: </b> #URL.area#<br/>

<script>

	<!---
	Esta función hace lo mismo que serializeCFJSON los problemas que da serializeCFJSON
	http://cfsimplicity.com/53/simpler-handling-of-json-serialised-coldfusion-query-objects 
	(function( $ ){
	    $.standardiseCfQueryJSON=function( cfQueryJSON )
	    {
	        var result  =   [];
	        $.each( cfQueryJSON.DATA,function( rowNum,rowValue ){
	            var row =   new Object();
	            $.each( cfQueryJSON.COLUMNS,function( position,columnName ){
	                row[ columnName.toLowerCase() ] = rowValue[ position ];
	            });
	            result.push( row );
	        });
	        return result;
	    };
	})( jQuery );--->

	function getAreaItems(areaId, itemTypeId) {

	    $.ajax({
	        url: '#APPLICATION.htmlComponentsPath#/AreaItem.cfc',
	        data: {
	            method: 'getAreaItems',
	            area_id: areaId,
	            itemTypeId: itemTypeId
	        },
	        method:'POST', <!--- En principio, las peticiones de este tipo que no envían datos, se harán por GET, a no ser que se automatice el envío de parametros en el atributo data --->
	        dataType:"json",
	        success: function(data, textStatus){

	        	if( textStatus == "success"){

	        		if(data.result == true) {

	        			console.log(data);

	        			<!---data = $.serializeCFJSON(data);
	        			console.log(data);--->

			        	<!--- Esto es necesario para que funcione bien serializeCFJSON, que falla y no realiza la conversión correctamente
			        	http://www.cutterscrossing.com/index.cfm/2012/5/2/JQuery-Plugin-serializeCFJSON
			        	En lugar de esto se puede llamar a standardiseCfQueryJSON que parece que funciona correctamente
			        	--->
			        	var temp = new Object();
						temp.data = data.areaItems;

						var areaItems = $.serializeCFJSON(temp).data;
						console.log(areaItems);

						$("##dataTextArea").val(JSON.stringify(areaItems));

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

	$(document).ready(function () {
		
		getAreaItems(#URL.area#, #URL.itemTypeId#);

	});

</script>
</cfoutput>
</body>
<textarea id="dataTextArea" style="width:100%;height:200px;"></textarea>
</html>