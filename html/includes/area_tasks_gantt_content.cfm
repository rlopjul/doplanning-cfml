<cfoutput>
<!--- 
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8"></script>
 --->

<!---<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">--->

<link type="text/css" href="#APPLICATION.htmlPath#/styles/gantt.css" rel="stylesheet" />
<script src="#APPLICATION.path#/jquery/jquery.serializecfjson-0.2.min.js"></script>
<!---<script src="//cdnjs.cloudflare.com/ajax/libs/moment.js/2.8.3/moment.min.js"></script>--->

<!---<script src="http://d3js.org/d3.v3.min.js"></script>--->
<script src="//cdnjs.cloudflare.com/ajax/libs/d3/3.4.13/d3.min.js"></script>

<script src="#APPLICATION.htmlPath#/scripts/gantt/gantt-chart-d3.min.js"></script>
<script src="#APPLICATION.htmlPath#/scripts/gantt/ganttDP.min.js"></script>

</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">


<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<div class="div_head_subtitle_area">
	<cfoutput>

	<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->
	
		<a href="#itemTypeName#_new.cfm?area=#area_id#" onclick="openUrl('#itemTypeName#_new.cfm?area=#area_id#', 'itemIframe', event)" class="btn btn-default btn-sm" title="<cfif itemTypeGender EQ 'male'>Nuevo<cfelse>Nueva</cfif> #itemTypeNameEs#" lang="es"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i>  
		<cfif itemTypeId IS 7>
			<i class="icon-exchange" style="font-size:18px; color:##0088CC"></i>
		<cfelse>
			<img src="#APPLICATION.htmlPath#/assets/v3/icons/#itemTypeName#.png" style="height:22px;"/>
		</cfif></a>
	
		<span class="divider">&nbsp;</span>

		<a href="#lCase(itemTypeNameP)#.cfm?area=#area_id#&mode=list" class="btn btn-default btn-sm"><i class="icon-th-list" style="font-size:14px; line-height:23px;"></i> <span lang="es">Modo lista</span></a>

		<span class="divider">&nbsp;</span>
		
		<cfif app_version NEQ "mobile">
		<a href="#APPLICATION.htmlPath#/#lCase(itemTypeNameP)#.cfm?area=#area_id#&mode=gantt" class="btn btn-default btn-sm" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
		</cfif>

		<a href="#lCase(itemTypeNameP)#.cfm?area=#area_id#&mode=gantt" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>	
		
		
	</cfif>
	
	</cfoutput>
</div>

<!--- 
<div style="margin-left:2px; margin-right:2px;">
 --->
<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">
<!--- 
</div>
 --->

<div class="div_items">

	<cfoutput>

	<script>

		var selectedLanguage = "es";

		<!---alert(hasLocalStorage());--->

		if(hasLocalStorage())
			selectedLanguage = localStorage.getItem('langJs_currentLang');

		<!---alert(localStorage.getItem('langJs_currentLang'));--->

		if(selectedLanguage == "es") {

			var myFormatters = d3.locale({
			  "decimal": ".",
			  "thousands": ",",
			  "grouping": [3],
			  "currency": ["$", ""],
			  "dateTime": "%a %b %e %X %Y",
			  "date": "%m/%d/%Y",
			  "time": "%H:%M:%S",
			  "periods": ["AM", "PM"],
			  "days": ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"],
			  "shortDays": ["Dom", "Lun", "Mar", "Mie", "Jue", "Vie", "Sáb"],
			  "months": ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"],
			  "shortMonths": ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
			});

			d3.time.format = myFormatters.timeFormat;

		}

	</script>

	<script>

		function getAreaItems(areaId, itemTypeId) {

		    $.ajax({
		        url: '#APPLICATION.htmlComponentsPath#/AreaItem.cfc',
		        data: {
		            method: 'getAreaItems',
		            area_id: areaId,
		            itemTypeId: itemTypeId,
		            parse_dates: false
		        },
		        method:'POST', <!--- En principio, las peticiones de este tipo que no envían datos, se harán por GET, a no ser que se automatice el envío de parametros en el atributo data --->
		        dataType:"json",
		        success: function(data, textStatus){

		        	if( textStatus == "success"){

		        		if(data.result == true) {

		        			<!---console.log(data);--->

		        			<!---data = $.serializeCFJSON(data);
		        			console.log(data);--->

				        	<!--- Esto es necesario para que funcione bien serializeCFJSON, que falla y no realiza la conversión correctamente
				        	http://www.cutterscrossing.com/index.cfm/2012/5/2/JQuery-Plugin-serializeCFJSON
				        	En lugar de esto se puede llamar a standardiseCfQueryJSON que parece que funciona correctamente
				        	--->
				        	var temp = new Object();
							temp.data = data.areaItems;

							var areaItems = $.serializeCFJSON(temp).data;
							
							<!---console.log(areaItems);
							$("##dataTextArea").val(JSON.stringify(areaItems));--->

							setItems(areaItems);

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
			
			getAreaItems(#URL.area#, #itemTypeId#);

		});

	</script>


	<!---<script>

		function comienza()	{

    		//alert("PASO POR TEST");
    		aClient = new HttpClient();
    		aClient.get('#APPLICATION.htmlPath#/scripts/gantt/tasksv5.js', function(answer) 
    		{
        		escribirjson(answer);
    		});
  
		}

	</script>--->

	</cfoutput>
	<!---<div id="infoderecha" visibility="visible" class="infoderecha">
	</div>--->
	<!---<textarea id="dataTextArea" style="width:100%;height:200px;"></textarea>--->


</div>