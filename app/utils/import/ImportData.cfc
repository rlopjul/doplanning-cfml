<!---Copyright Era7 Information Technologies 2007-2013
	
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena

--->
<cfcomponent displayname="ImportData" output="no">

	
	
	<!---    importTable     --->
	<cffunction name="importTable" output="false" returntype="struct">
		
		<cfargument name="num_colums" type="string" required="true">
		<cfargument name="table_to" type="string" required="true">

		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "importTable">
		
		<cftry>
		
			<cfset fileServerName = "import_data.csv">
							
			<cffile action="Upload" filefield="file" destination="#fileServerName#" nameconflict="overwrite" result="result_cffile" charset="iso-8859-1">
			<cffile action="read" file="#fileServerName#" variable="fileContent" charset="iso-8859-1">
			<cffile action="delete" file="#fileServerName#">

			<cfinvoke component="ImportData" method="CSVToArray" returnvariable="fileArray">
				<cfinvokeargument name="CSV" value="#trim(#fileContent#)#">
				<cfinvokeargument name="delimiter" value=";">
			</cfinvoke>
			
			<!---<cfset numColumns = arrayLen(fileArray[1])>--->
			<cfset numColumns = arguments.num_colums>
			
			<cfsetting requesttimeout="120">
					
			<cfsavecontent variable="queryColumns">
				<cfoutput>	
				INSERT INTO `#arguments.table_to#` (
				<cfloop from="1" to="#numColumns#" index="curColum">
					`#arguments["col_to_#curColum#"]#`
					<cfif curColum NEQ numColumns>
					,
					</cfif>
				</cfloop>
				)
				</cfoutput>			
			</cfsavecontent>
			
			<cftransaction>
				<cfquery datasource="#arguments.client_dsn#" name="truncateTableQuery">
					CREATE TABLE IF NOT EXISTS `#arguments.table_to#` (
						  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
						  `email_login` varchar(255) NOT NULL,
						  `name` varchar(255) NOT NULL,
						  `family_name_1` varchar(255) NOT NULL,
						  `family_name_2` varchar(255) NOT NULL,
						  `address` varchar(255) NOT NULL,
						  `dni` varchar(255) NOT NULL,
						  `nif` varchar(255) NOT NULL,
						  <!---<cfif APPLICATION.moduleLdapUsers IS true>--->
						  	`login_dmsas` varchar(255) NOT NULL,
						  	`login_diraya` varchar(255) NOT NULL,
						  <!---</cfif>--->
						  `internal_user` varchar(45) NOT NULL,
  						  `perfil_cabecera` varchar(255) NOT NULL,
						  PRIMARY KEY (`user_id`)
						) ENGINE=InnoDB DEFAULT CHARSET=utf8;
				</cfquery>
				<cfquery datasource="#arguments.client_dsn#" name="truncateTableQuery">
					TRUNCATE TABLE #arguments.table_to#;
				</cfquery>
			</cftransaction>
					
			<cftransaction>
			<cfloop from="2" to="#ArrayLen(fileArray)#" step="1" index="curIndex">
				
					<cfquery datasource="#arguments.client_dsn#" name="insertQuery">
						#queryColumns#				
						VALUES (
						<cfloop from="1" to="#numColumns#" index="curColum">
							<cfset curValue =  #fileArray[#curIndex#][#curColum#]#>
							<cfif isNumeric(curValue)>
								<cfqueryparam value="#curValue#" cfsqltype="cf_sql_integer">
							<cfelse>
								<cfqueryparam value="#curValue#" cfsqltype="cf_sql_varchar">
							</cfif>
							<cfif curColum NEQ numColumns>
							,
							</cfif>
						</cfloop>
						);
					</cfquery>
				
			</cfloop>
			</cftransaction>
			
			<cfset response = {result="true", message='Carga realizada correctamente.'}>
		
			<cfcatch>
				<cfset response = {result="false", message="Error al importar los datos. Compruebe que el archivo es correcto. #cfcatch.Message#"}>
			</cfcatch>
		</cftry>
		
		<cfreturn #response#>
		
	</cffunction>
	
	
	
	<!--- --------------------------------------------------------------------------------------- ----
	
	Blog Entry:
	Parsing CSV Values In ColdFusion While Handling Embedded Qualifiers And Delimiters
	
	Author:
	Ben Nadel / Kinky Solutions
	
	Link:
	http://www.bennadel.com/index.cfm?dax=blog:498.view
	
	Date Posted:
	Jan 30, 2007 at 8:54 AM
	
	---- --------------------------------------------------------------------------------------- --->

	<cffunction	name="CSVToArray" access="public" returntype="array" output="false"	hint="Converts the given CSV string to an array of arrays.">
	 
		<!--- Define arguments. --->
		<cfargument
			name="CSV"
			type="string"
			required="true"
			hint="This is the CSV string that will be manipulated."
			/>
	 
		<cfargument
			name="Delimiter"
			type="string"
			required="false"
			default=","
			hint="This is the delimiter that will separate the fields within the CSV value."
			/>
	 
		<cfargument
			name="Qualifier"
			type="string"
			required="false"
			default=""""
			hint="This is the qualifier that will wrap around fields that have special characters embeded."
			/>
	 
	 
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
	 
	 
		<!---
			When accepting delimiters, we only want to use the first
			character that we were passed. This is different than
			standard ColdFusion, but I am trying to make this as
			easy as possible.
		--->
		<cfset ARGUMENTS.Delimiter = Left( ARGUMENTS.Delimiter, 1 ) />
	 
		<!---
			When accepting the qualifier, we only want to accept the
			first character returned. Is is possible that there is
			no qualifier being used. In that case, we can just store
			the empty string (leave as-is).
		--->
		<cfif Len( ARGUMENTS.Qualifier )>
	 
			<cfset ARGUMENTS.Qualifier = Left( ARGUMENTS.Qualifier, 1 ) />
	 
		</cfif>
	 
	 
		<!---
			Set a variable to handle the new line. This will be the
			character that acts as the record delimiter.
		--->
		<cfset LOCAL.LineDelimiter = Chr( 10 ) />
	 
	 
		<!---
			We want to standardize the line breaks in our CSV value.
			A "line break" might be a return followed by a feed or
			just a line feed. We want to standardize it so that it
			is just a line feed. That way, it is easy to check
			for later (and it is a single character which makes our
			life 1000 times nicer).
		--->
		<cfset ARGUMENTS.CSV = ARGUMENTS.CSV.ReplaceAll(
			"\r?\n",
			LOCAL.LineDelimiter
			) />
	 
	 
		<!---
			Let's get an array of delimiters. We will need this when
			we are going throuth the tokens and building up field
			values. To do this, we are going to strip out all
			characters that are NOT delimiters and then get the
			character array of the string. This should put each
			delimiter at it's own index.
		--->
		<cfset LOCAL.Delimiters = ARGUMENTS.CSV.ReplaceAll(
			"[^\#ARGUMENTS.Delimiter#\#LOCAL.LineDelimiter#]+",
			""
			)
	 
			<!---
				Get character array of delimiters. This will put
				each found delimiter in its own index (that should
				correspond to the tokens).
			--->
			.ToCharArray()
			/>
	 
	 
		<!---
			Add a blank space to the beginning of every theoretical
			field. This will help in make sure that ColdFusion /
			Java does not skip over any fields simply because they
			do not have a value. We just have to be sure to strip
			out this space later on.
	 
			First, add a space to the beginning of the string.
		--->
		<cfset ARGUMENTS.CSV = (" " & ARGUMENTS.CSV) />
	 
		<!--- Now add the space to each field. --->
		<cfset ARGUMENTS.CSV = ARGUMENTS.CSV.ReplaceAll(
			"([\#ARGUMENTS.Delimiter#\#LOCAL.LineDelimiter#]{1})",
			"$1 "
			) />
	 
	 
		<!---
			Break the CSV value up into raw tokens. Going forward,
			some of these tokens may be merged, but doing it this
			way will help us iterate over them. When splitting the
			string, add a space to each token first to ensure that
			the split works properly.
	 
			BE CAREFUL! Splitting a string into an array using the
			Java String::Split method does not create a COLDFUSION
			ARRAY. You cannot alter this array once it has been
			created. It can merely be referenced (read only).
	 
			We are splitting the CSV value based on the BOTH the
			field delimiter and the line delimiter. We will handle
			this later as we build values (this is why we created
			the array of delimiters above).
		--->
		<cfset LOCAL.Tokens = ARGUMENTS.CSV.Split(
			"[\#ARGUMENTS.Delimiter#\#LOCAL.LineDelimiter#]{1}"
			) />
	 
	 
		<!---
			Set up the default return array. This will be a full
			array of arrays, but for now, just create the parent
			array with no indexes.
		--->
		<cfset LOCAL.Return = ArrayNew( 1 ) />
	 
		<!---
			Create a new active row. Even if we don't end up adding
			any values to this row, it is going to make our lives
			more smiple to have it in existence.
		--->
		<cfset ArrayAppend(
			LOCAL.Return,
			ArrayNew( 1 )
			) />
	 
		<!---
			Set up the row index. THis is the row to which we are
			actively adding value.
		--->
		<cfset LOCAL.RowIndex = 1 />
	 
	 
		<!---
			Set the default flag for wether or not we are in the
			middle of building a value across raw tokens.
		--->
		<cfset LOCAL.IsInValue = false />
	 
	 
		<!---
			Loop over the raw tokens to start building values. We
			have no sense of any row delimiters yet. Those will
			have to be checked for as we are building up each value.
		--->
		<cfloop
			index="LOCAL.TokenIndex"
			from="1"
			to="#ArrayLen( LOCAL.Tokens )#"
			step="1">
	 
	 
			<!---
				Get the current field index. This is the current
				index of the array to which we might be appending
				values (for a multi-token value).
			--->
			<cfset LOCAL.FieldIndex = ArrayLen(
				LOCAL.Return[ LOCAL.RowIndex ]
				) />
	 
			<!---
				Get the next token. Trim off the first character
				which is the empty string that we added to ensure
				proper splitting.
			--->
			<cfset LOCAL.Token = LOCAL.Tokens[ LOCAL.TokenIndex ].ReplaceFirst(
				"^.{1}",
				""
				) />
	 
	 
			<!---
				Check to see if we have a field qualifier. If we do,
				then we might have to build the value across
				multiple fields. If we do not, then the raw tokens
				should line up perfectly with the real tokens.
			--->
			<cfif Len( ARGUMENTS.Qualifier )>
	 
	 
				<!---
					Check to see if we are currently building a
					field value that has been split up among
					different delimiters.
				--->
				<cfif LOCAL.IsInValue>
	 
	 
					<!---
						ASSERT: Since we are in the middle of
						building up a value across tokens, we can
						assume that our parent FOR loop has already
						executed at least once. Therefore, we can
						assume that we have a previous token value
						ALREADY in the row value array and that we
						have access to a previous delimiter (in
						our delimiter array).
					--->
	 
					<!---
						Since we are in the middle of building a
						value, we replace out double qualifiers with
						a constant. We don't care about the first
						qualifier as it can ONLY be an escaped
						qualifier (not a field qualifier).
					--->
					<cfset LOCAL.Token = LOCAL.Token.ReplaceAll(
						"\#ARGUMENTS.Qualifier#{2}",
						"{QUALIFIER}"
						) />
	 
	 
					<!---
						Add the token to the value we are building.
						While this is not easy to read, add it
						directly to the results array as this will
						allow us to forget about it later. Be sure
						to add the PREVIOUS delimiter since it is
						actually an embedded delimiter character
						(part of the whole field value).
					--->
					<cfset LOCAL.Return[ LOCAL.RowIndex ][ LOCAL.FieldIndex ] = (
						LOCAL.Return[ LOCAL.RowIndex ][ LOCAL.FieldIndex ] &
						LOCAL.Delimiters[ LOCAL.TokenIndex - 1 ] &
						LOCAL.Token
						) />
	 
	 
					<!---
						Now that we have removed the possibly
						escaped qualifiers, let's check to see if
						this field is ending a multi-token
						qualified value (its last character is a
						field qualifier).
					--->
					<cfif (Right( LOCAL.Token, 1 ) EQ ARGUMENTS.Qualifier)>
	 
						<!---
							Wooohoo! We have reached the end of a
							qualified value. We can complete this
							value and move onto the next field.
							Remove the trailing quote.
	 
							Remember, we have already added to token
							to the results array so we must now
							manipulate the results array directly.
							Any changes made to LOCAL.Token at this
							point will not affect the results.
						--->
						<cfset LOCAL.Return[ LOCAL.RowIndex ][ LOCAL.FieldIndex ] = LOCAL.Return[ LOCAL.RowIndex ][ LOCAL.FieldIndex ].ReplaceFirst( ".{1}$", "" ) />
	 
						<!---
							Set the flag to indicate that we are no
							longer building a field value across
							tokens.
						--->
						<cfset LOCAL.IsInValue = false />
	 
					</cfif>
	 
	 
				<cfelse>
	 
	 
					<!---
						We are NOT in the middle of building a field
						value which means that we have to be careful
						of a few special token cases:
	 
						1. The field is qualified on both ends.
						2. The field is qualified on the start end.
					--->
	 
					<!---
						Check to see if the beginning of the field
						is qualified. If that is the case then either
						this field is starting a multi-token value OR
						this field has a completely qualified value.
					--->
					<cfif (Left( LOCAL.Token, 1 ) EQ ARGUMENTS.Qualifier)>
	 
	 
						<!---
							Delete the first character of the token.
							This is the field qualifier and we do
							NOT want to include it in the final value.
						--->
						<cfset LOCAL.Token = LOCAL.Token.ReplaceFirst(
							"^.{1}",
							""
							) />
	 
						<!---
							Remove all double qualifiers so that we
							can test to see if the field has a
							closing qualifier.
						--->
						<cfset LOCAL.Token = LOCAL.Token.ReplaceAll(
							"\#ARGUMENTS.Qualifier#{2}",
							"{QUALIFIER}"
							) />
	 
						<!---
							Check to see if this field is a
							self-closer. If the first character is a
							qualifier (already established) and the
							last character is also a qualifier (what
							we are about to test for), then this
							token is a fully qualified value.
						--->
						<cfif (Right( LOCAL.Token, 1 ) EQ ARGUMENTS.Qualifier)>
	 
							<!---
								This token is fully qualified.
								Remove the end field qualifier and
								append it to the row data.
							--->
							<cfset ArrayAppend(
								LOCAL.Return[ LOCAL.RowIndex ],
								LOCAL.Token.ReplaceFirst(
									".{1}$",
									""
									)
								) />
	 
						<cfelse>
	 
							<!---
								This token is not fully qualified
								(but the first character was a
								qualifier). We are buildling a value
								up across differen tokens. Set the
								flag for building the value.
							--->
							<cfset LOCAL.IsInValue = true />
	 
							<!--- Add this token to the row. --->
							<cfset ArrayAppend(
								LOCAL.Return[ LOCAL.RowIndex ],
								LOCAL.Token
								) />
	 
						</cfif>
	 
	 
					<cfelse>
	 
	 
						<!---
							We are not dealing with a qualified
							field (even though we are using field
							qualifiers). Just add this token value
							as the next value in the row.
						--->
						<cfset ArrayAppend(
							LOCAL.Return[ LOCAL.RowIndex ],
							LOCAL.Token
							) />
	 
	 
					</cfif>
	 
	 
				</cfif>
	 
	 
				<!---
					As a sort of catch-all, let's remove that
					{QUALIFIER} constant that we may have thrown
					into a field value. Do NOT use the FieldIndex
					value as this might be a corrupt value at
					this point in the token iteration.
				--->
				<cfset LOCAL.Return[ LOCAL.RowIndex ][ ArrayLen( LOCAL.Return[ LOCAL.RowIndex ] ) ] = Replace(
					LOCAL.Return[ LOCAL.RowIndex ][ ArrayLen( LOCAL.Return[ LOCAL.RowIndex ] ) ],
					"{QUALIFIER}",
					ARGUMENTS.Qualifier,
					"ALL"
					) />
	 
	 
			<cfelse>
	 
	 
				<!---
					Since we don't have a qualifier, just use the
					current raw token as the actual value. We are
					NOT going to have to worry about building values
					across tokens.
				--->
				<cfset ArrayAppend(
					LOCAL.Return[ LOCAL.RowIndex ],
					LOCAL.Token
					) />
	 
	 
			</cfif>
	 
	 
	 
			<!---
				Check to see if we have a next delimiter and if we
				do, is it going to start a new row? Be cautious that
				we are NOT in the middle of building a value. If we
				are building a value then the line delimiter is an
				embedded value and should not percipitate a new row.
			--->
			<cfif (
				(NOT LOCAL.IsInValue) AND
				(LOCAL.TokenIndex LT ArrayLen( LOCAL.Tokens )) AND
				(LOCAL.Delimiters[ LOCAL.TokenIndex ] EQ LOCAL.LineDelimiter)
				)>
	 
				<!---
					The next token is indicating that we are about
					start a new row. Add a new array to the parent
					and increment the row counter.
				--->
				<cfset ArrayAppend(
					LOCAL.Return,
					ArrayNew( 1 )
					) />
	 
				<!--- Increment row index to point to next row. --->
				<cfset LOCAL.RowIndex = (LOCAL.RowIndex + 1) />
	 
			</cfif>
	 
		</cfloop>
	 
	 
		<!--- Return the resultant array of arrays. --->
		<cfreturn LOCAL.Return />
	 
	</cffunction>
	
	
</cfcomponent>