<!---IMPORTANTE: ESTO SOLO FUNCIONA PARA EL CLIENTE ESPECIFICADO AQUÍ:--->	
<cfsetting requesttimeout="600">

<!---<cftimer label="Tiempo de ejecución" type="inline">--->
	
<cfset client_abb = "asnc">
<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>

<cfset fileName = "#APPLICATION.filesPath#/#client_abb#/database/#client_abb#_db_export_#DayOfWeek(#now()#)#.txt">

<cfquery datasource="#client_dsn#" name="getTables">
	SHOW TABLES FROM #client_dsn#;
</cfquery>

<cfset tableColumn = "Tables_in_#client_dsn#">

<cfset initContent = "-- Exportación base de datos
-- Fecha: #DateFormat(#now()#, "dd/mm/yyyy")# #TimeFormat(#now()#, "HH:MM:SS")# 

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;">


<cffile action="write" file="#fileName#" charset="utf-8" output="#initContent#">

<cfloop query="getTables">

	<cfset curTable = getTables[tableColumn]>
	<!---<cfset curTable = "#client_abb#_messages">--->	

	<cfquery datasource="#client_dsn#" name="getTable">
		SELECT *
		FROM #curTable#;
	</cfquery>
	
	<cfset exportContent = "">
	
	<cfif getTable.recordCount GT 0>
	

		<cfset exportContent = '
--
-- Data for table `#curTable#`
--
'>
	
		<!---<cfset tableColumns = getTable.GetColumnNames()>--->
		<cfset tableColumnsArray = GetMetaData(getTable)>
		<cfset tableColumnsList = "">
		<cfloop array="#tableColumnsArray#" index="curColumn">
		
			<cfset tableColumnsList = listAppend(tableColumnsList,"`#curColumn.name#`", ",")>
		
		</cfloop>
		
		<!---<cfdump var="#tableColumnsArray#">--->
		<!---<cfdump var="#GetMetaData(getTable)#" />--->
		
		<cfset exportContent = exportContent&"INSERT INTO `#curTable#`	(#tableColumnsList#) VALUES 
">	
		
		<cffile action="append" file="#fileName#" charset="utf-8" output="#trim(exportContent)#">
		
		<cfloop query="getTable">
			
			<cfset cont = 0>
			<cfset columsLen = arrayLen(tableColumnsArray)>
			
			<cfset exportContent = "">
			
			<cfset exportContent = exportContent&"(">
					
			<cfloop array="#tableColumnsArray#" index="curColumn">
				
				<cfswitch expression="#curColumn.typeName#">
					<cfcase value="VARCHAR">
						<cfset columnContent = getTable[curColumn.name]>
						<cfset columnContent = replace(columnContent, "\", "\\", "ALL")>
						<cfset columnContent = replace(columnContent, "'", "\'", "ALL")>
						<cfset columnContent = replace(columnContent, '"', '\"', "ALL")>
						<cfset exportContent = exportContent&"'#columnContent#'">
					</cfcase>
					<cfcase value="LONGVARCHAR">
						<cfset columnContent = getTable[curColumn.name]>
						<cfset columnContent = replace(columnContent, "\", "\\", "ALL")>
						<cfset columnContent = replace(columnContent, "'", "\'", "ALL")>
						<cfset columnContent = replace(columnContent, '"', '\"', "ALL")>
						<cfset exportContent = exportContent&"'#columnContent#'">
					</cfcase>
					<cfcase value="TIMESTAMP">
						<cfif len(getTable[curColumn.name]) GT 0>
							<cfset exportContent = exportContent&"'#dateFormat(#getTable[#curColumn.name#]#,'yyyy-mm-dd')# #timeFormat(#getTable[#curColumn.name#]#, 'HH:MM:SS')#'">
						<cfelse>
							<cfset exportContent = exportContent&"NULL">
						</cfif>
					</cfcase>
					<cfdefaultcase>
						<cfif len(getTable[curColumn.name]) GT 0>
							<cfset exportContent = exportContent&"#getTable[#curColumn.name#]#">
						<cfelse>
							<cfset exportContent = exportContent&"NULL">
						</cfif>
					</cfdefaultcase>
				</cfswitch>
				<cfset cont = cont+1>
				<cfif cont LT columsLen>
					<cfset exportContent = exportContent&",">
				</cfif>
				
			</cfloop>
			
			<cfset exportContent = exportContent&")">
			
			<cfif getTable.currentRow LT getTable.recordCount>
				
				<cfif getTable.currentRow MOD 20 IS 0>
					<cfset exportContent = exportContent&";
">
					<cfset exportContent = exportContent&"INSERT INTO `#curTable#`	(#tableColumnsList#) VALUES 
">	
				<cfelse>
					<cfset exportContent = exportContent&",
">
				</cfif>
			</cfif>
			
			<cffile action="append" file="#fileName#" charset="utf-8" output="#trim(exportContent)#">
			
		</cfloop>
		<cfset exportContent = ";
">
		<cfset exportContent = exportContent&"--
-- END Data for table `#curTable#`
--
">
			
		<cffile action="append" file="#fileName#" charset="utf-8" output="#trim(exportContent)#">
	
	
	</cfif>

</cfloop>

<cfset endContent = "/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;">

<cffile action="append" file="#fileName#" charset="utf-8" output="#trim(endContent)#">

<!---</cftimer>--->