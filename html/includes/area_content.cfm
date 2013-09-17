<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfoutput>
<div class="div_head_title">
<div class="icon_title">
<a href="area.cfm"><img src="#APPLICATION.htmlPath#/assets/icons_#APPLICATION.identifier#/organization.png" alt="Árbol de la organización" lang="es"/></a>
</div>
<div class="head_title"><a href="area.cfm" lang="es">Árbol de la organización</a></div>
</div>
</cfoutput>

<cfif isDefined("URL.area")><!---Si se le pasa area_id por URL--->

	<cfset area_id = int(URL.area)>
	
	<!---area_allowed--->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="canUserAccessToArea" returnvariable="area_allowed">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>
	
	<!---area_type--->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getAreaType" returnvariable="area_type">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getAreaContent" returnvariable="xmlResponse">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfinvokeargument name="allowed" value="#area_allowed#">
		<cfinvokeargument name="areaType" value="#area_type#">
	</cfinvoke>
	
	<cfxml variable="xmlAreas">
		<cfoutput>
		#xmlResponse.area#
		</cfoutput>
	</cfxml>

	<cfset parent_area_id = xmlAreas.area.xmlAttributes.parent_id>
	
	<cfif isValid("integer",parent_area_id)>
		<cfset return_page = "area.cfm?area=#parent_area_id#">
	<cfelse>
		<cfset return_page = "area.cfm">
	</cfif>
	
	<cfset area_name = xmlAreas.area.xmlAttributes.name>
	<cfset area_allowed = xmlAreas.area.xmlAttributes.allowed>
	<!---<cfset area_type = xmlAreas.area.xmlAttributes.type>Este type es el propio del área y no el que le corresponde por su posición en el árbol, por lo que hay que obtener ese type--->
	<cfset numAreas = ArrayLen(xmlAreas.area.XmlChildren)>
	
<cfelse><!---Si no se le pasa area_id por URL, ESTÁ EN LA RAIZ--->

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getMainTree" returnvariable="getMainTreeResponse">
	</cfinvoke>
	
	<!---<cfset area_id = xmlGetMainTreeResponse.response.result.areas.area[1].xmlAttributes.id>--->
	<!---Si está en la raiz del árbol no se define area_id porque no se está en ningún área--->
	
	<cfxml variable="xmlAreas">
		<cfoutput>
		#getMainTreeResponse.areasXml#
		</cfoutput>
	</cfxml>
	
	<cfset return_page = "mobile.cfm">
	<cfset numAreas = ArrayLen(xmlAreas.areas.XmlChildren)>
	
</cfif>

<cfinclude template="area_checks.cfm">
<cfinclude template="area_menu.cfm">

<!---<textarea style="width:100%; height:150px;"><cfoutput>#xmlAreas#</cfoutput></textarea>--->

<cfif numAreas GT 0>

		<cfoutput>
		<cfloop index="xmlIndex" from="1" to="#numAreas#" step="1">
		
			<cfif isDefined("URL.area")>
				<cfxml variable="xmlArea">
				#xmlAreas.area.area[xmlIndex]#
				</cfxml>
			<cfelse>
				<cfxml variable="xmlArea">
				#xmlAreas.areas.area[xmlIndex]#
				</cfxml>			
			</cfif>
				
			<cfif xmlArea.area.xmlAttributes.allowed EQ true>
				<cfif NOT isDefined("xmlArea.area.xmlAttributes.type") OR xmlArea.area.xmlAttributes.type EQ "">
					<cfset area_image = "assets/icons_#APPLICATION.identifier#/area_small.png">
				<cfelse>
					<cfset area_image = "assets/icons_#APPLICATION.identifier#/area_web_small.png">
				</cfif>
			<cfelse>
				<cfif NOT isDefined("xmlArea.area.xmlAttributes.type") OR xmlArea.area.xmlAttributes.type EQ "">
					<cfset area_image = "assets/icons_#APPLICATION.identifier#/area_small_disabled.png">
				<cfelse>
					<cfset area_image = "assets/icons_#APPLICATION.identifier#/area_web_small_disabled.png">
				</cfif>
			</cfif>
			
		
			<div class="div_area">
				<div class="div_img_area_area">
				<a href="area.cfm?area=#xmlArea.area.xmlAttributes.id#"><img src="#area_image#" alt="Área"/></a>
				</div>
				<div class="div_text_area"><a href="area.cfm?area=#xmlArea.area.xmlAttributes.id#" class="a_area_area">#xmlArea.area.xmlAttributes.name#</a></div>
			</div>		
		</cfloop>
		</cfoutput>

<cfelse>
<div class="div_text_result"><span lang="es">No hay más areas dentro de esta.</span></div>
</cfif>