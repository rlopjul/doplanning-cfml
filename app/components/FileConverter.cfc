<!---Copyright Era7 Information Technologies 2007-2016

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 31-03-2010

--->
<cfcomponent output="false">

	<cfset component = "FileConverter">

	<!----convertFile--->
	<cffunction name="convertFile" access="public" returntype="void">
		<cfargument name="inputFilePath" type="string" required="yes">
		<cfargument name="outputFilePath" type="string" required="yes">

		<cfset var method = "convertFile">

		<!---<cftry>--->

			<cfscript>
				Config  = createObject("java", "org.artofsolving.jodconverter.office.DefaultOfficeManagerConfiguration").init();
				Config.setOfficeHome("/opt/libreoffice5.2/");
				Manager = Config.buildOfficeManager();

				try{

					Manager.start();

					inPath = arguments.inputFilePath;
					outPath = arguments.outputFilePath;

					OfficeDocumentConverter = createObject("java", "org.artofsolving.jodconverter.OfficeDocumentConverter");
					converter = OfficeDocumentConverter.init( Manager );
					input = createObject("java", "java.io.File").init( inPath );
					output = createObject("java", "java.io.File").init( outPath );
					Converter.convert(input, output);

				} catch (any e) {

					rethrow;

				} finally {

					Manager.stop();

				}
			</cfscript>


			<!---<cfobject type="java" class="com.artofsolving.jodconverter.openoffice.converter.OpenOfficeDocumentConverter" name="jodDocumentConverter">
			<cfobject type="java" class="com.artofsolving.jodconverter.openoffice.connection.SocketOpenOfficeConnection" name="jodOpenOfficeConnection">
			<cfobject type="java" class="java.io.File" name="jodFile">

			<cfset inputFile = jodFile.init(arguments.inputFilePath)>
			<cfset outputFile = jodFile.init(arguments.outputFilePath)>

			<cfset jodOpenOfficeConnection.init("localhost", 8100)>
			<cfset jodOpenOfficeConnection.connect()>
			<cfset success = jodOpenOfficeConnection.isConnected()>

			<cfif success EQ "YES">
			  <cfset jodDocumentConverter.init(jodOpenOfficeConnection)>
			  <cfset jodDocumentConverter.convert(inputFile, outputFile)>
			</cfif>

			<cfset disconn = jodOpenOfficeConnection.disconnect()>--->

			<!---<cfset xmlResponseContent = ''>--->

			<!---<cfinclude template="includes/functionEnd.cfm">--->

		<!---<cfcatch>
			<cfinclude template="includes/errorHandler.cfm">
		</cfcatch>--->

		<!---<cfreturn xmlResponse>--->

	</cffunction>


	<!----getConvertedImages--->
	<!---Aquí se obtienen las imágenes generadas al convertir un archivo a HTML--->

	<cffunction name="getConvertedImages" access="public" returntype="any">
		<cfargument name="directory_path" type="string" required="yes">

		<cfargument name="return_type" type="string" required="no" default="xml">

		<cfset var method = "getConvertedImages">

		<cfset var xmlResult = "">
		<cfset var xmlResponse = "">

		<cfset var imageFileList = "">
		<cfset var imageName = "">


			<cfdirectory directory="#arguments.directory_path#" action="list" name="getDirectoryFiles"/>

			<cfquery dbtype="query" name="getImageFiles">
				SELECT name
				FROM getDirectoryFiles
				WHERE type = 'File'
				AND name LIKE '%.jpg';
			</cfquery>

			<cfloop from="0" to="#getImageFiles.recordCount-1#" index="index">
				<cfset imageName = "img#index#.jpg">
				<cfif fileExists(expandPath(arguments.directory_path&"/"&imageName))>
					<cfset imageFileList = listAppend(imageFileList, imageName)>
				</cfif>
			</cfloop>

			<cfif arguments.return_type EQ "list">

				<cfset xmlResponse = imageFileList>

			<cfelseif arguments.return_type EQ "object">

				<cfset xmlResponse = imageFileList>

			<cfelse>

				<cfset xmlResult = "<files>">

				<cfloop list="#imageFileList#" index="imageFile">
					<!---<cfset xmlResult = xmlResult&'<file physical_name="#imageFile#"></file>'>--->
					<cfset xmlResult = xmlResult&'<file path="#arguments.directory_path#/#imageFile#" />'>
				</cfloop>


				<cfset xmlResult = xmlResult&"</files>">

				<cfset xmlResponse = xmlResult>

			</cfif>


		<cfreturn xmlResponse>

	</cffunction>


</cfcomponent>
