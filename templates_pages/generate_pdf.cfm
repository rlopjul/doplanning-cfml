<cfif isDefined("FORM.page") AND isDefined("FORM.url")>
		
	<cfset export = true>
	
	<cfif isDefined("FORM.itemTypeId")>
		<cfset itemTypeId = FORM.itemTypeId>
	</cfif>
	
	<cfif isDefined("FORM.parent_area_id")>
		<cfset parent_area_id = FORM.parent_area_id>
	</cfif>
	
	<!---<cfset timeprint = DateDiff("s","1/1/1970",Now())>--->
	<cfset fechaprint = Now()>
	
	<cfoutput>
		<cfdocument format="pdf" pagetype="a4" margintop="0.5" marginright="0.5" marginbottom="0.2" fontembed="yes" localurl="yes">
			<cfdocumentsection>
			   <cfdocumentitem type="header">
				<head>
					<link href="#APPLICATION.path#/styles.css" rel="stylesheet" type="text/css" />
				</head>
				<body style="background-color:##FFFFFF">
			   	<p style="font-size:9px;color:##999999;">
				<cfset page_url = "http://#CGI.SERVER_NAME##APPLICATION.path#/#areaTypeRequired#/"&FORM.url>
				<!---<cfif language EQ "es">--->
				PDF obtenido de la #areaTypeRequired# del Área Sanitaria Norte de Córdoba.<br />
				URL: #page_url#<br />
				Fecha: #Day(fechaprint)#-#Month(fechaprint)#-#DatePart('YYYY', fechaprint)#
				<!---<cfelse>
				#APPLICATION.title#<br />
				URL: #page_url#<br />
				Date: #Day(fechaprint)#-#Month(fechaprint)#-#DatePart('YYYY', fechaprint)#
				</cfif>--->
				</p><br/><br/>
				</body>
			   </cfdocumentitem>
			   <cfdocumentitem type="footer">
			   <head>
					<link href="#APPLICATION.path#/styles.css" rel="stylesheet" type="text/css" />
			   </head>
			   <body style="background-color:##FFFFFF">
			   		<p style="text-align:right;font-size:10px;color:##999999;">
					P&aacute;gina #cfdocument.currentpagenumber# de #cfdocument.totalpagecount#
					<!---<cfelse>
					  Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
					  </cfif>--->
					</p>  
			   </body>  
			   </cfdocumentitem>
			   <!---Okay, I have found the error. In CF8, I need to use cfdocument.currentsectionpagenumber and cfdocument.totalsectionpagecount.--->

			   <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
			   <html xmlns="http://www.w3.org/1999/xhtml" lang="es"> 
			   <head>
			   <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			   <!--Copyright Era7 Information Technologies 2007-2012-->
			   <title>ASNC</title>
			   <link href="#APPLICATION.path#/styles.css" rel="stylesheet" type="text/css" />
			   </head>	
			   
			   <body style="background-color:##FFFFFF">
			   
			    <cfinclude template="#APPLICATION.path#/templates_pages/udf_url.cfm">
			    <cfinclude template="head_pdf.cfm">
				<cfinclude template="#FORM.page#">
				
			   </body>
			   </html>
			</cfdocumentsection>
		
		</cfdocument>
	</cfoutput>
</cfif>