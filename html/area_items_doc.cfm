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

		<cfprocessingdirective pageencoding="utf-8">
		<cfheader name="Content-Disposition" value="inline; filename=Area_items.doc" charset="utf-8">
		<cfcontent type="application/msword; charset=utf-8">

		<html
		xmlns:o='urn:schemas-microsoft-com:office:office'
		xmlns:w='urn:schemas-microsoft-com:office:word'
		xmlns='http://www.w3.org/TR/REC-html40'>
		<head><title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

		<!--[if gte mso 9]>
		<xml>
		<w:WordDocument>
		<w:View>Print</w:View>
		<w:Zoom>90</w:Zoom>
		<w:DoNotOptimizeForBrowser/>
		</w:WordDocument>
		</xml>
		<![endif]-->

		<style>
		p.MsoFooter, li.MsoFooter, div.MsoFooter {
			margin:0in;
			margin-bottom:.0001pt;
			mso-pagination:widow-orphan;
			tab-stops:center 3.0in right 6.0in;
			font-size:12.0pt;
		}
		<style>

		<!-- /* Style Definitions */

		@page Section1 {
			size:8.5in 11.0in;
			margin:1.0in 1.25in 1.0in 1.25in ;
			mso-header-margin:.5in;
			mso-header:h1;
			mso-footer: f1;
			mso-footer-margin:.5in;
		}


		div.Section1 {
			page:Section1;
		}

		table##hrdftrtbl {
			margin:0in 0in 0in 9in;
		}
		-->
		</style></head>

		<h2>#area_name#</h2><br/>

		<cfif numItems GT 0>

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsFullList">
				<cfinvokeargument name="itemsQuery" value="#areaItemsQuery#">
				<cfinvokeargument name="return_path" value="#APPLICATION.htmlPath#/">
				<cfinvokeargument name="area_id" value="#area_id#"/>
				<cfinvokeargument name="generatePdf" value="true"/>
			</cfinvoke>

		</cfif>


		<table id='hrdftrtbl' border='1' cellspacing='0' cellpadding='0'>
		<tr><td>
		<div style='mso-element:header' id=h1>
		<p class=MsoHeader style='text-align:center'>Confidential</p>
		</div>
		</td>
		<td>
		<div style='mso-element:footer' id=f1>
		<p class=MsoFooter>Draft
		<span style='mso-tab-count:2'></span><span style='mso-field-code:"" PAGE ""'></span>
		of <span style='mso-field-code:"" NUMPAGES ""'></span></p></div>
		/td></tr>
		</table>
		</body></html>


			<!---<html xmlns:o="urn:schemas-microsoft-com:office:office"
			      xmlns:w="urn:schemas-microsoft-com:office:word"
			      xmlns="http://www.w3.org/TR/REC-html40">
			<html>
			   <head>
				   	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
						<title>DoPlanning</title>
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
		   </html>--->

	</cfoutput>

</cfif>
