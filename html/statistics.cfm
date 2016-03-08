<cfprocessingdirective suppresswhitespace="true">
<!DOCTYPE html>
<html lang="es">
<head>
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

	<cfoutput>

	function getTotalItemsByUser(areaId, areaType, includeSubareas) {

			$.ajax({
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

								var totalItems = data.totalItems;

								console.log(totalItems);
								$("##dataTextArea").val(JSON.stringify(totalItems));


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

						getTotalItemsByUser(#URL.area#, '#area_type#', true);

				});

				</cfoutput>

			</script>


			<!--- PAGE CONTENT HERE --->



			<textarea id="dataTextArea" style="width:100%;height:300px;"></textarea>




			<!--- END PAGE CONTENT --->

		</div>

	</div><!---END page-content-wrapper --->

</div>

</body>
</html>
</cfprocessingdirective>