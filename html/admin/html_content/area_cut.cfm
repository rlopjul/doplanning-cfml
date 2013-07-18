<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	
	<cfset area_id = URL.area>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
		<cfinvokeargument name="area_id" value="#area_id#"/>
	</cfinvoke>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaTree" method="outputMainTree">
		<cfinvokeargument name="with_input_type" value="checkbox">
		<cfif objectArea.type EQ "">
			<cfinvokeargument name="disable_input_web" value="true"><!---Esto es para que no se puedan copiar áreas no web a las áreas WEB--->
		<cfelse>
			<cfinvokeargument name="disable_input_area" value="true"><!---Esto es para que no se puedan copiar áreas WEB a las áreas no WEB--->
		</cfif>
	</cfinvoke>

</cfif>