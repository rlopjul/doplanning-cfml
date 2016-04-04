<cfif isDefined("URL.area") AND isNumeric(URL.area)>

	<cfset area_id = URL.area>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getAreaTypeWeb" returnvariable="areaTypeResult">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>
	<cfset area_type = areaTypeResult.areaType>
	<cfset area_name = areaTypeResult.name>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAllAreaItems" returnvariable="getAllAreaItemsResult">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfinvokeargument name="area_type" value="#area_type#">
		<cfinvokeargument name="full_content" value="true">
	</cfinvoke>

	<cfset areaItemsQuery = getAllAreaItemsResult.query>
	<cfset numItems = areaItemsQuery.recordCount>

	<cfoutput>

		<cfsavecontent variable="documentContent">
			<!DOCTYPE HTML>
			<html lang="es">
			   <head>
				   	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
				    <!---<link href="#APPLICATION.htmlPath#/ckeditor/contents.css" rel="stylesheet" type="text/css">--->
				    <!---<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap.3.0.3.min.css" rel="stylesheet">--->
				    <!---<style>
				   		<cfinclude template="#APPLICATION.htmlPath#/bootstrap/bootstrap.3.0.3.min.css">
				    </style>--->
				    <style>
				    	body{
				    		font-family: Arial;
				    		font-size: 12px;
				    	}
				    	h4{
							font-size: 14px;
				    	}
				    </style>
			   </head>

			   <body style="margin:0;padding:0;width:100%">

			   		<!---<table border="1" width="100%" bordercolor="##000000" bgolor="##000000">
			   			<tr>
			   			<td>prueba</td>
			   			</tr>
			   		</table>--->
			   		<h2>#area_name#</h2><br/>

					<cfif numItems GT 0>

						<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsFullList">
							<cfinvokeargument name="itemsQuery" value="#areaItemsQuery#">
							<cfinvokeargument name="return_path" value="#APPLICATION.htmlPath#/">
							<cfinvokeargument name="area_id" value="#area_id#"/>
							<cfinvokeargument name="generatePdf" value="true"/>
						</cfinvoke>

					</cfif>

			   </body>
		   </html>
		</cfsavecontent>

		<cfheader name="Content-Disposition" value="filename=""area_#area_id#.pdf""" charset="UTF-8">

		<cfdocument format="pdf" pagetype="a4" margintop="0.5" marginright="0.5" marginbottom="0.2" fontembed="yes" localurl="yes">
		   <cfdocumentitem type="header">
		   		<body style="margin:0;padding:0;">
		   			<p style="font-size: 0.7em;">DoPlanning<br/>
		   			#DateFormat(now(),APPLICATION.dateFormat)#</p>
		   		</body>
		   </cfdocumentitem>
		   <cfdocumentitem type="footer">
			   <body>
				   	<p style="font-size: 0.5em;" align="right">#cfdocument.currentpagenumber# / #cfdocument.totalpagecount#</p>
			   </body>
		   </cfdocumentitem>

		   #documentContent#

		</cfdocument>
	</cfoutput>

</cfif>
