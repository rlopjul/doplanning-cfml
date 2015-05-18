<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	
	<cfset area_id = URL.area>

	<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfinvoke>--->
	
	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <!---<h5 id="areaModalLabel" lang="es">Árbol</h4>--->
		</div>

	 	<div class="modal-body" style="width:100%">
	  		
	 		<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" src="iframes/tree.cfm?area=#area_id#" style="height:375px;background-color:##FFFFFF;"></iframe>

		</div>

	</cfoutput>

</cfif>