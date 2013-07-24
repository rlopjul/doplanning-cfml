<cfif isDefined("URL.area") AND isNumeric(URL.area)>

	<cfset area_id = URL.area>

	<cfoutput>
	<script type="text/javascript" src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js"></script>

	<script type="text/javascript">
		var applicationId = "#APPLICATION.identifier#";
	</script>
	<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/tree.min.js"></script>
	</cfoutput>

	<script type="text/javascript">
		
		<cfoutput>
		var curAreaId = #area_id#;
		</cfoutput>

		function treeLoaded () { 
			
			$("#loadingContainer").hide();
			
		}

		function areaSelected(areaId, areaUrl, withLink)  {

			if(areaId != curAreaId){
				parent.setNewParentId(areaId);
			} else {
				$("#areasTreeContainer").jstree("deselect_all"); 
				parent.setNewParentId(undefined);
				alert("No puede seleccionar como área de destino el área a mover");
			}

		}
		
		$(window).load( function() {		

			showTree(true);
			
		});

	</script>

	<cfinclude template="#APPLICATION.htmlPath#/includes/loading_div.cfm">

	<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfinvoke>--->

	<cfprocessingdirective suppresswhitespace="true">
	<div id="areasTreeContainer" style="clear:both">

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaTree" method="outputMainTreeAdmin">
			<!---<cfinvokeargument name="with_input_type" value="checkbox">
			<cfif objectArea.type EQ "">
				<cfinvokeargument name="disable_input_web" value="true"><!---Esto es para que no se puedan copiar áreas no web a las áreas WEB--->
			<cfelse>
				<cfinvokeargument name="disable_input_area" value="true"><!---Esto es para que no se puedan copiar áreas WEB a las áreas no WEB--->
			</cfif>--->
		</cfinvoke>

	</div>
	</cfprocessingdirective>

</cfif>