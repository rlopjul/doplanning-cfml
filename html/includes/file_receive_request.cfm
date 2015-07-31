<cfif isDefined("FORM.data")>
	
	<cftry>
		
		<cfset dataJSON = DeserializeJSON(FORM.data)>

		<cfset file_download_path = dataJSON["file_download_path"]>
		<cfset visualization = dataJSON["Visualization"]>
		<cfset parameters = dataJSON["Parameters"]>

		<cfif len(visualization) GT 0>
			<cfinclude template="#visualization#">	
		</cfif>
		
		<cfcatch>

			<cfoutput>
				#cfcatch.message#
			</cfoutput>

		</cfcatch>

	</cftry>

</cfif>