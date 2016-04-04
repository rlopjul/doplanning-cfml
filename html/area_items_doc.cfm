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
				<!-- /* Style Definitions */

				p.MsoHeader, li.MsoHeader, div.MsoHeader{
				    margin:0in;
				    margin-top:.0001pt;
				    mso-pagination:widow-orphan;
				    tab-stops:center 3.0in right 6.0in;
				}
				p.MsoFooter, li.MsoFooter, div.MsoFooter{
				    margin:0in 0in 1in 0in;
				    margin-bottom:.0001pt;
				    mso-pagination:widow-orphan;
				    tab-stops:center 3.0in right 6.0in;
				}
				.header {
				    font-size: 9pt;
				}
				.footer {
				    font-size: 9pt;
				}
				@page Section1{
				    size:8.5in 11.0in;
				    margin:0.5in 0.5in 0.5in 0.5in;
				    mso-header-margin:0.5in;
				    mso-header:h1;
				    mso-footer:f1;
				    mso-footer-margin:0.5in;
				    mso-paper-source:0;
				}
				div.Section1{
				    page:Section1;
				}
				table##hrdftrtbl{
				    margin:0in 0in 0in 9in;
				}
				-->
				</style>
				<style type="text/css" media="screen,print">

					body {
						font-family: "Helvetica";

					}

					pageBreak {
					  clear:all;
					  page-break-before:always;
					  mso-special-character:line-break;
					}

				</style>

				</head>

				<body style='tab-interval:.5in'>

					<div class="Section1">

						<h2>#area_name#</h2><br/>

						<cfif numItems GT 0>

							<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputAllItemsFullList">
								<cfinvokeargument name="itemsQuery" value="#areaItemsQuery#">
								<cfinvokeargument name="return_path" value="#APPLICATION.htmlPath#/">
								<cfinvokeargument name="area_id" value="#area_id#"/>
								<cfinvokeargument name="generatePdf" value="true"/>
								<cfinvokeargument name="generateWord" value="true"/>
							</cfinvoke>

						</cfif>


						<table id='hrdftrtbl' border='1' cellspacing='0' cellpadding='0'>
						<tr>
		          <td>
	              <div style='mso-element:header' id="h1" >
	                <p class="MsoHeader"><!---HEADER--->
	                  <table border="0" width="100%">
	                    <tr>
	                        <td align="left">


	                        </td>

													<td align="right" class="header">

														#DateFormat(now(), APPLICATION.dateFormat)#

													</td>
	                    </tr>
	                  </table>
	                </p>
	             	</div>
		          </td>
			        <td>
		            <div style='mso-element:footer' id="f1">
	                <p class="MsoFooter"><!---FOOTER--->
	                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	                    <tr>
	                        <td align="left" class="footer">


	                        </td>
													<td align="right" class="footer">

														<g:message code="offer.letter.page.label"/> <span style='mso-field-code: PAGE '></span> / <span style='mso-field-code: NUMPAGES '></span>

													</td>
	                    </tr>
	                  </table>
	                </p>
		            </div>
			        </td>
			    	</tr>
			    </table>

					</div><!--- END Section1 --->

				</body>
			</html>
	</cfoutput>

</cfif>
