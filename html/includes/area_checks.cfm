<cfinclude template="#APPLICATION.htmlPath#/includes/app_version.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="loggedUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
</cfinvoke>

<cfset curPage = getFileFromPath(CGI.SCRIPT_NAME)>
<cfset curElement = "">


<!--- itemTypesArray --->
<!---<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
</cfinvoke>

<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>--->

<cfif isDefined("itemTypeId")>

	<cfset curElement = itemTypesStruct[itemTypeId].name>

	<!---
	<cfswitch expression="#itemTypeId#">

		<cfcase value="1">
			<cfset curElement = "messages">
		</cfcase>
		
		<cfcase value="2">
			<cfset curElement = "entries">
		</cfcase>
		
		<cfcase value="3">
			<cfset curElement = "links">
		</cfcase>
		
		<cfcase value="4">
			<cfset curElement = "news">
		</cfcase>
		
		<cfcase value="5">
			<cfset curElement = "events">
		</cfcase>
		
		<cfcase value="6">
			<cfset curElement = "tasks">
		</cfcase>
		
		<cfcase value="7">
			<cfset curElement = "consultations">
		</cfcase>

		<cfcase value="8">
			<cfset curElement = "pubmeds">
		</cfcase>
		
		<cfcase value="9">
			<cfset curElement = "images">
		</cfcase>
		
		<cfcase value="11">
			<cfset curElement = "lists">
		</cfcase>

		<cfcase value="12">
			<cfset curElement = "forms">
		</cfcase>

		<cfcase value="12">
			<cfset curElement = "forms">
		</cfcase>

		<cfcase value="20">
			<cfset curElement = "dp_documents">
		</cfcase>
		
	</cfswitch>
	--->
	
<cfelse>
	
	<cfif find("items",curPage) GT 0>
		<cfset curElement = "items">
	<cfelseif find("file",curPage) GT 0>
		<cfset curElement = "file">
	<cfelseif find("user",curPage) GT 0>
		<cfset curElement = "user">
	</cfif>
	
</cfif>


<cfif isDefined("area_id")>
		
	<cfif NOT isDefined("area_allowed")>
		<!---area_allowed--->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="canUserAccessToArea" returnvariable="area_allowed">
			<cfinvokeargument name="area_id" value="#area_id#">
		</cfinvoke>

	</cfif>
	
	<cfif NOT isDefined("area_name")>
		<!---Esto es para las páginas de items, archivos, usuarios (la mayoría de las páginas excepto la de navegación del arbol area.cfm) que no reciben estos valores--->
		
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="objectArea">
			<cfinvokeargument name="area_id" value="#area_id#">
		</cfinvoke>
		
		<cfset area_name = objectArea.name>

	</cfif>
	
	<!---area_type--->
	<cfif NOT isDefined("area_type")>
		<!---Esto es para las páginas de items, archivos, usuarios (la mayoría de las páginas excepto la de navegación del arbol area.cfm) que no reciben este valor--->
		<!---El tipo de un área depende del tipo de las áreas superiores que tenga.--->
		<!---area_type puede ser web, intranet o NULL--->
		<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getAreaType" returnvariable="area_type">
			<cfinvokeargument name="area_id" value="#area_id#">
		</cfinvoke>--->

		<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaType" returnvariable="areaTypeResult">
			<cfinvokeargument name="area_id" value="#area_id#">
		</cfinvoke>
		<cfset area_type = areaTypeResult.areaType>
		<cfif area_type EQ "web" OR area_type EQ "intranet"><!---Area web url--->
			<cfset webPath = areaTypeResult.webPath>
			<cfset webPathUrl = areaTypeResult.webPathUrl>
		</cfif>
		

	</cfif>

	<!--- areaTypeWeb --->
	<cfif len(area_type) GT 0>
		<cfset areaTypeWeb = true>
	<cfelse>
		<cfset areaTypeWeb = false>
	</cfif>


	<!---is_user_area_responsible--->
	<cfif isDefined("objectArea")>

		<cfif area_allowed IS true>

			<cfif objectArea.user_in_charge EQ SESSION.user_id>
			
				<cfset is_user_area_responsible = true>

			<cfelse>	

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="isUserAreaResponsible" returnvariable="is_user_area_responsible">				
					<cfinvokeargument name="area_id" value="#area_id#">
				</cfinvoke>				

			</cfif>
			
		<cfelse>
			<cfset is_user_area_responsible = false>
		</cfif>

	</cfif>
	
</cfif>