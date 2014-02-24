<cfcomponent output="false">

	<cfset component = "Utils">


	<!---    generateNewPassword     --->
	
	<cfscript>
	
		/**
		* Generates a password the length you specify.
		* 
		* @param numberOfCharacters      Lengh for the generated password. 
		* @return Returns a string. 
		* @author Tony Blackmon (fluid@sc.rr.com) 
		* @version 1, April 25, 2002 
		*/
		function generatePassword(numberofCharacters) {
			var placeCharacter = "";
			var currentPlace=0;
			var group=0;
			var subGroup=0;
			
			for(currentPlace=1; currentPlace lte numberofCharacters; currentPlace = currentPlace+1) {
			group = randRange(1,4);
			switch(group) {
			case "1":
			subGroup = rand();
				switch(subGroup) {
			case "0":
			placeCharacter = placeCharacter & chr(randRange(33,46));
			break;
			case "1":
			placeCharacter = placeCharacter & chr(randRange(58,64));
			break;
			}
			case "2":
			placeCharacter = placeCharacter & chr(randRange(97,122));
			break;
			case "3":
			placeCharacter = placeCharacter & chr(randRange(65,90));
			break;
			case "4":
			placeCharacter = placeCharacter & chr(randRange(48,57));
			break;
			}
			}
			return placeCharacter;
		}
	
	</cfscript>

	<!--- insertBR --->

	<cffunction name="insertBR" returntype="string" access="public">
		<cfargument name="string" type="string" required="true">

		<cfset str = replace(arguments.string,chr(13)&chr(10),"<br>","ALL")>
		<cfset str = replace(str,chr(10),"<br>","ALL")><!--- Para datos importados de archivos CSV --->

		<cfreturn str>

	</cffunction>


	<!---    queryToCSV     --->
	<cffunction	name="queryToCSV" access="public" returntype="string" output="false" hint="I take a query and convert it to a comma separated value string.">
	 
		<!--- Define arguments. --->
		<cfargument
			name="Query"
			type="query"
			required="true"
			hint="I am the query being converted to CSV."
			/>
	 
		<cfargument
			name="Fields"
			type="string"
			required="true"
			hint="I am the list of query fields to be used when creating the CSV value."
			/>
		
		<cfargument	name="FieldsLabels" type="string" required="false" 
			hint="I am the list of query fields labels to be used when creating the CSV header row."
			/>
	 
		<cfargument
			name="CreateHeaderRow"
			type="boolean"
			required="false"
			default="true"
			hint="I flag whether or not to create a row of header values."
			/>
	 
		<cfargument
			name="Delimiter"
			type="string"
			required="false"
			default=","
			hint="I am the field delimiter in the CSV value."
			/>
	 
		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />
	 
		<!---
			First, we want to set up a column index so that we can
			iterate over the column names faster than if we used a
			standard list loop on the passed-in list.
		--->
		<cfset LOCAL.ColumnNames = [] />
		
		<cfset LOCAL.ColumnLabels = [] >
	 
		<!---
			Loop over column names and index them numerically. We
			are working with an array since I believe its loop times
			are faster than that of a list.
		--->
		<cfloop
			index="LOCAL.ColumnName"
			list="#ARGUMENTS.Fields#"
			delimiters=",">
	 
			<!--- Store the current column name. --->
			<cfset ArrayAppend(
				LOCAL.ColumnNames,
				Trim( LOCAL.ColumnName )
				) />
			
			<cfif NOT isDefined("arguments.FieldsLabels")>
				<cfset ArrayAppend(
					LOCAL.ColumnLabels,
					Trim( LOCAL.ColumnName )
					) />
			</cfif>
	 
		</cfloop>
		
		
		<cfif isDefined("arguments.FieldsLabels")>
		
			<cfloop	index="LOCAL.ColumnLabel"
				list="#arguments.FieldsLabels#"
				delimiters=",">
		 
				<cfset ArrayAppend(
					LOCAL.ColumnLabels,
					Trim( LOCAL.ColumnLabel )
					) />

			</cfloop>
		
		</cfif>
		
	 
		<!--- Store the column count. --->
		<cfset LOCAL.ColumnCount = ArrayLen( LOCAL.ColumnNames ) />
	 
	 
		<!---
			Now that we have our index in place, let's create
			a string buffer to help us build the CSV value more
			effiently.
		--->
		<cfset LOCAL.Buffer = CreateObject( "java", "java.lang.StringBuffer" ).Init() />
	 
		<!--- Create a short hand for the new line characters. --->
		<cfset LOCAL.NewLine = (Chr( 13 ) & Chr( 10 )) />
	 
	 
		<!--- Check to see if we need to add a header row. --->
		<cfif ARGUMENTS.CreateHeaderRow>
	 
			<!--- Create array to hold row data. --->
			<cfset LOCAL.RowData = [] />
	 
			<!--- Loop over the column names. --->
			<cfloop
				index="LOCAL.ColumnIndex"
				from="1"
				to="#LOCAL.ColumnCount#"
				step="1">
	 
				<!--- Add the field name to the row data. --->
				<cfset LOCAL.RowData[ LOCAL.ColumnIndex ] = """#LOCAL.ColumnLabels[ LOCAL.ColumnIndex ]#""" />
	 
			</cfloop>
	 
			<!--- Append the row data to the string buffer. --->
			<cfset LOCAL.Buffer.Append(
				JavaCast(
					"string",
					(
						ArrayToList(
							LOCAL.RowData,
							ARGUMENTS.Delimiter
							) &
						LOCAL.NewLine
					))
				) />
	 
		</cfif>
	 
	 
		<!---
			Now that we have dealt with any header value, let's
			convert the query body to CSV. When doing this, we are
			going to qualify each field value. This is done be
			default since it will be much faster than actually
			checking to see if a field needs to be qualified.
		--->
	 
		<!--- Loop over the query. --->
		<cfloop query="ARGUMENTS.Query">
	 
			<!--- Create array to hold row data. --->
			<cfset LOCAL.RowData = [] />
	 
			<!--- Loop over the columns. --->
			<cfloop
				index="LOCAL.ColumnIndex"
				from="1"
				to="#LOCAL.ColumnCount#"
				step="1">
	 			
				<cfset LOCAL.curRowValue = ARGUMENTS.Query[ LOCAL.ColumnNames[ LOCAL.ColumnIndex ] ][ ARGUMENTS.Query.CurrentRow ]>
				
				<!--- Add the field to the row data. --->
				<cfif len(LOCAL.curRowValue) GTE 10 AND isDate(LOCAL.curRowValue)><!---Is DATE--->
				
					<cfset LOCAL.RowData[ LOCAL.ColumnIndex ] = """#DateFormat(dateConvert("local2Utc", LOCAL.curRowValue), "dd/mm/yyyy")#""" />
				
				<cfelse>
					
					<cfset LOCAL.RowData[ LOCAL.ColumnIndex ] = """#Replace( LOCAL.curRowValue, """", """""", "all" )#""" />
					
				</cfif>
	 
			</cfloop>
	 
	 
			<!--- Append the row data to the string buffer. --->
			<cfset LOCAL.Buffer.Append(
				JavaCast(
					"string",
					(
						ArrayToList(
							LOCAL.RowData,
							ARGUMENTS.Delimiter
							) &
						LOCAL.NewLine
					))
				) />
	 
		</cfloop>
	 
	 
		<!--- Return the CSV value. --->
		<cfreturn LOCAL.Buffer.ToString() />
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




	<!--- queryToArray --->

	<cffunction name="queryToArray" access="public" returntype="array" output="false" hint="This turns a query into an array of structures.">
		<cfargument name="data" type="query" required="yes" />

		<cfscript>

		// Define the local scope.
		var LOCAL = StructNew();

		// Get the column names as an array.
		LOCAL.Columns = ListToArray( ARGUMENTS.Data.ColumnList );

		// Create an array that will hold the query equivalent.
		LOCAL.QueryArray = ArrayNew( 1 );

		// Loop over the query.
		for (LOCAL.RowIndex = 1 ; LOCAL.RowIndex LTE ARGUMENTS.Data.RecordCount ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){

		// Create a row structure.
		LOCAL.Row = StructNew();

		// Loop over the columns in this row.
		for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE ArrayLen( LOCAL.Columns ) ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){

		// Get a reference to the query column.
		LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];

		// Store the query cell value into the struct by key.
		LOCAL.Row[ LOCAL.ColumnName ] = ARGUMENTS.Data[ LOCAL.ColumnName ][ LOCAL.RowIndex ];

		}

		// Add the structure to the query array.
		ArrayAppend( LOCAL.QueryArray, LOCAL.Row );

		}

		// Return the array equivalent.
		return( LOCAL.QueryArray );

		</cfscript>
	</cffunction>
	


</cfcomponent>