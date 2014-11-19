
<cfset itemTypeId = 20>

<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

<cfif isDefined("URL.#itemTypeName#") AND isNumeric(URL[itemTypeName])>
	<cfset item_id = URL[#itemTypeName#]>
<cfelse>
	Error, parámetros incorrectos
</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getItem" returnvariable="objectItem">
	<cfinvokeargument name="item_id" value="#item_id#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	<!---<cfif itemTypeId IS 20>
		<cfinvokeargument name="with_lock" value="true">
	</cfif>--->
</cfinvoke>


<cfheader name="Content-Disposition" value="filename=""#objectItem.title#.pdf""" charset="UTF-8">

<cfoutput>
	<cfdocument format="pdf" pagetype="a4" margintop="0.5" marginright="0.5" marginbottom="0.2" fontembed="yes" localurl="yes">
	   <cfdocumentitem type="header">
	   </cfdocumentitem>
	   <cfdocumentitem type="footer">
		   <head>
		   </head>
		   <body>
			   	<p style="font-size: 0.5em;" align="right">#cfdocument.currentpagenumber# / #cfdocument.totalpagecount#</p>
		   </body>  
	   </cfdocumentitem>
	   <!DOCTYPE HTML>
		<html lang="es">
		   <head>
			   <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			   <link href="#APPLICATION.htmlPath#/ckeditor/contents.css" rel="stylesheet" type="text/css">
		   </head>	
		   
		   <body style="margin:0;padding:0;">
		   
				#objectItem.description#
			
		   </body>
	   </html>
	</cfdocument>
</cfoutput>
