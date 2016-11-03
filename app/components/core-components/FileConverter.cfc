<!--- Copyright Era7 Information Technologies 2007-2016 --->
<cfcomponent output="false">

	<cfset component = "FileConverter">

	<!----convertFile--->
	<cffunction name="convertFile" access="public" returntype="void">
		<cfargument name="inputFilePath" type="string" required="yes">
		<cfargument name="outputFilePath" type="string" required="yes">

		<cfset var method = "convertFile">

			<cfscript>

				try {

					Manager = APPLICATION.OfficeManager;

					OfficeDocumentConverter = createObject("java", "org.artofsolving.jodconverter.OfficeDocumentConverter");
					converter = OfficeDocumentConverter.init( Manager );

					input = createObject("java", "java.io.File").init( arguments.inputFilePath );
					output = createObject("java", "java.io.File").init( arguments.outputFilePath );

					Converter.convert(input, output);

				} catch (any e) {

					rethrow;

				} finally {


				}
			</cfscript>

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
