<cfcomponent output="false">

	<cfset component = "Utils">


	<!--- removeHTML --->

	<cfscript>


		/**
		* Removes HTML fron string
		*
		*/
		function removeHTML(string) {

			var stringReplaced = REReplace(arguments.string,"<[^>]*>","","ALL");

			return stringReplaced;

		}


	</cfscript>


	<!---    trimDecimal     --->
	<cfscript>

		/**
		* Removes unnecessary 0 after decimal point
		*
		*/
		function trimDecimal(value) {

			if( findOneOf(".", arguments.value) GT 0 )
				return reReplace(REReplace(arguments.value, "0+$", "", "ALL"), "\.+$", "");
			else
				return arguments.value;

		}
	</cfscript>



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

		/**
		* @return Returns a string.
		* @author alucena
		*/
		function leftToNextSpace(str, count) {

			var strLen = len(str);
			if(strLen GT count){
				var nextChar = mid(str,count+1,1);

				if(nextChar != " "){
					var nextSpace = find(" ", str, count+1);

					if(nextSpace GT 0)
						str = left(str, nextSpace-1);
					else
						str = left(str, count);
				}
				else{
					str = left(str, count);
				}
			}

			return str;

		}


	</cfscript>


	<!--- PROVISIONAL
		Esto hay que quitarlo cuando se actualice a Lucee, ya que Lucee incluye una función para esto
	--->

	<cfscript>
			function getQueryRow(query, rowNumber) {
					var i = 0;
					var rowData = StructNew();
					var cols    = ListToArray(query.columnList);
					for (i = 1; i lte ArrayLen(cols); i = i + 1) {
							rowData[cols[i]] = query[cols[i]][rowNumber];
					}
					return rowData;
			}
	</cfscript>


	<!--- insertBR --->

	<cffunction name="insertBR" returntype="string" access="public">
		<cfargument name="string" type="string" required="true">

		<cfset str = replace(arguments.string,chr(13)&chr(10),"<br>","ALL")>
		<cfset str = replace(str,chr(10),"<br>","ALL")><!--- Para datos importados de archivos CSV --->

		<cfreturn str>

	</cffunction>


	<!--- replaceBR --->

	<!---<cffunction name="replaceBR" returntype="string" access="public">
		<cfargument name="string" type="string" required="true">

		<cfset string = replace(string,"<br />",chr(13)&chr(10),"ALL")>

		<cfreturn string>

	</cffunction>--->


	<!--- replaceP --->

	<!---<cffunction name="replaceP" returntype="string" access="public">
		<cfargument name="string" type="string" required="true">

		<cfset string = replace(string,"<p>","","ALL")>
		<cfset string = replace(string,"</p>",chr(13)&chr(10),"ALL")>

		<cfreturn string>

	</cffunction>--->


	<!---http://speeves.erikin.com/2009/06/coldfusion-replace-html-ized-characters.html--->

	<cffunction name="HtmlUnEditFormat" access="public" returntype="string" output="no" displayname="HtmlUnEditFormat" hint="Undo escaped characters">
      <cfargument name="str" type="string" required="Yes" />
      <cfscript>
         var lEntities = "&##xE7;,&##xF4;,&##xE2;,&Icirc;,&Ccedil;,&Egrave;,&Oacute;,&Ecirc;,&OElig,&Acirc;,&laquo;,&raquo;,&Agrave;,&Eacute;,&le;,&yacute;,&chi;,&sum;,&prime;,&yuml;,&sim;,&beta;,&lceil;,&ntilde;,&szlig;,&bdquo;,&acute;,&middot;,&ndash;,&sigmaf;,&reg;,&dagger;,&oplus;,&otilde;,&eta;,&rceil;,&oacute;,&shy;,&gt;,&phi;,&ang;,&rlm;,&alpha;,&cap;,&darr;,&upsilon;,&image;,&sup3;,&rho;,&eacute;,&sup1;,&lt;,&cent;,&cedil;,&pi;,&sup;,&divide;,&fnof;,&iquest;,&ecirc;,&ensp;,&empty;,&forall;,&emsp;,&gamma;,&iexcl;,&oslash;,&not;,&agrave;,&eth;,&alefsym;,&ordm;,&psi;,&otimes;,&delta;,&ouml;,&deg;,&cong;,&ordf;,&lsaquo;,&clubs;,&acirc;,&ograve;,&iuml;,&diams;,&aelig;,&and;,&loz;,&egrave;,&frac34;,&amp;,&nsub;,&nu;,&ldquo;,&isin;,&ccedil;,&circ;,&copy;,&aacute;,&sect;,&mdash;,&euml;,&kappa;,&notin;,&lfloor;,&ge;,&igrave;,&harr;,&lowast;,&ocirc;,&infin;,&brvbar;,&int;,&macr;,&frac12;,&curren;,&asymp;,&lambda;,&frasl;,&lsquo;,&hellip;,&oelig;,&pound;,&hearts;,&minus;,&atilde;,&epsilon;,&nabla;,&exist;,&auml;,&mu;,&frac14;,&nbsp;,&equiv;,&bull;,&larr;,&laquo;,&oline;,&or;,&euro;,&micro;,&ne;,&cup;,&aring;,&iota;,&iacute;,&perp;,&para;,&rarr;,&raquo;,&ucirc;,&omicron;,&sbquo;,&thetasym;,&ni;,&part;,&rdquo;,&weierp;,&permil;,&sup2;,&sigma;,&sdot;,&scaron;,&yen;,&xi;,&plusmn;,&real;,&thorn;,&rang;,&ugrave;,&radic;,&zwj;,&there4;,&uarr;,&times;,&thinsp;,&theta;,&rfloor;,&sub;,&supe;,&uuml;,&rsquo;,&zeta;,&trade;,&icirc;,&piv;,&zwnj;,&lang;,&tilde;,&uacute;,&uml;,&prop;,&upsih;,&omega;,&crarr;,&tau;,&sube;,&rsaquo;,&prod;,&quot;,&lrm;,&spades;";
         var lEntitiesChars = "ç,ô,â,Î,Ç,È,Ó,Ê,Œ,Â,«,»,À,É,?,ý,?,?,?,Ÿ,?,?,?,ñ,ß,„,´,·,–,?,®,‡,?,õ,?,?,ó,­,>,?,?,?,?,?,?,?,?,³,?,é,¹,<,¢,¸,?,?,÷,ƒ,¿,ê,?,?,?,?,?,¡,ø,¬,à,ð,?,º,?,?,?,ö,°,?,ª,‹,?,â,ò,ï,?,æ,?,?,è,¾,&,?,?,“,?,ç,ˆ,©,á,§,—,ë,?,?,?,?,ì,?,?,ô,?,¦,?,¯,½,¤,?,?,?,‘,…,œ,£,?,?,ã,?,?,?,ä,?,¼, ,?,•,?,«,?,?,€,µ,?,?,å,?,í,?,¶,?,»,û,?,‚,?,?,?,”,?,‰,²,?,?,š,¥,?,±,?,þ,?,ù,?,?,?,?,×,?,?,?,?,?,ü,’,?,™,î,?,?,?,˜,ú,¨,?,?,?,?,?,?,›,?,"",?,?";
      </cfscript>
      <cfreturn ReplaceList(arguments.str, lEntities, lEntitiesChars) />
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
				<cfif len(LOCAL.curRowValue) GTE 10 AND isDate(LOCAL.curRowValue)><!---The value is DATE--->

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


	<cffunction name="queryToStruct" access="public" returntype="any" output="false" hint="Converts an entire query or the given record to a struct. This might return a structure (single record) or an array of structures.">
		<!--- Define arguments. --->
		<cfargument name="Query" type="query" required="true" />
		<cfargument name="Row" type="numeric" required="false" default="0" />

		<cfscript>

		// Define the local scope.
		var LOCAL = StructNew();

		// Determine the indexes that we will need to loop over.
		// To do so, check to see if we are working with a given row,
		// or the whole record set.
		if (ARGUMENTS.Row){

		// We are only looping over one row.
		LOCAL.FromIndex = ARGUMENTS.Row;
		LOCAL.ToIndex = ARGUMENTS.Row;

		} else {

		// We are looping over the entire query.
		LOCAL.FromIndex = 1;
		LOCAL.ToIndex = ARGUMENTS.Query.RecordCount;

		}

		// Get the list of columns as an array and the column count.
		LOCAL.Columns = ListToArray( ARGUMENTS.Query.ColumnList );
		LOCAL.ColumnCount = ArrayLen( LOCAL.Columns );

		// Create an array to keep all the objects.
		LOCAL.DataArray = ArrayNew( 1 );

		// Loop over the rows to create a structure for each row.
		for (LOCAL.RowIndex = LOCAL.FromIndex ; LOCAL.RowIndex LTE LOCAL.ToIndex ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){

		// Create a new structure for this row.
		ArrayAppend( LOCAL.DataArray, StructNew() );

		// Get the index of the current data array object.
		LOCAL.DataArrayIndex = ArrayLen( LOCAL.DataArray );

		// Loop over the columns to set the structure values.
		for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE LOCAL.ColumnCount ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){

		// Get the column value.
		LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];

		// Set column value into the structure.
		LOCAL.DataArray[ LOCAL.DataArrayIndex ][ LOCAL.ColumnName ] = ARGUMENTS.Query[ LOCAL.ColumnName ][ LOCAL.RowIndex ];

		}

		}


		// At this point, we have an array of structure objects that
		// represent the rows in the query over the indexes that we
		// wanted to convert. If we did not want to convert a specific
		// record, return the array. If we wanted to convert a single
		// row, then return the just that STRUCTURE, not the array.
		if (ARGUMENTS.Row){

		// Return the first array item.
		return( LOCAL.DataArray[ 1 ] );

		} else {

		// Return the entire array.
		return( LOCAL.DataArray );

		}

		</cfscript>
	</cffunction>


	<cfscript>
	/**
	 * Deletes a var from a query string.
	 * Idea for multiple args from Michael Stephenson (michael.stephenson@adtran.com)
	 *
	 * @param variable 	 A variable, or a list of variables, to delete from the query string.
	 * @param qs 	 Query string to modify. Defaults to CGI.QUERY_STRING.
	 * @return Returns a string.
	 * @author Nathan Dintenfass (nathan@changemedia.com)
	 * @version 1.1, February 24, 2002
	 */
	function queryStringDeleteVar(variable){
		//var to hold the final string
		var string = "";
		//vars for use in the loop, so we don't have to evaluate lists and arrays more than once
		var ii = 1;
		var thisVar = "";
		var thisIndex = "";
		var array = "";
		//if there is a second argument, use that as the query string, otherwise default to cgi.query_string
		var qs = cgi.query_string;
		if(arrayLen(arguments) GT 1)
			qs = arguments[2];
		//put the query string into an array for easier looping
		array = listToArray(qs,"&");
		//now, loop over the array and rebuild the string
		for(ii = 1; ii lte arrayLen(array); ii = ii + 1){
			thisIndex = array[ii];
			thisVar = listFirst(thisIndex,"=");
			//if this is the var, edit it to the value, otherwise, just append
			if(not listFind(variable,thisVar))
				string = listAppend(string,thisIndex,"&");
		}
		//return the string
		return string;
	}



	/**
	 * Produces output used by the vCalendar standard for PIM's (such as Outlook).
	 * There are other tags available such as (CF_AdvancedEmail) that will support multi-part mime encoding where the text of the attachment can be imbeded right into the email
	 *
	 * @param stEvent 	 Structure containg the key/value pairs comprising the vCalendar data.  Keys are shown below:
	 * @param stEvent.description 	 Description for the event.
	 * @param stEvent.subject 	 Subject of the event.
	 * @param stEvent.location 	 Location for the event.
	 * @param stEvent.startTime 	 Event's start time in GMT.
	 * @param stEvent.endTime 	 Event's end time in GMT.
	 * @param stEvent.priority 	 Numeric priority for the event (1,2,3).
	 * @param strEvent.url
	 * @param strEvent.type event(default)/task
	 * @return Returns a string.
	 * @author Chris Wigginton (cwigginton@macromedia.com)
	 * @version 2
	 * modified by alucea
	 */
	function vCal(stEvent)
	{

		var description = "";
		var vCal = "";

		var CRLF=chr(13)&chr(10);

		if (NOT IsDefined("stEvent.startTime"))
			stEvent.startTime = DateConvert('local2Utc', Now());

		if (NOT IsDefined("stEvent.endTime"))
			stEvent.endTime = DateConvert('local2Utc', Now());

		if (NOT IsDefined("stEvent.location"))
			stEvent.location = "N/A";

		if (NOT IsDefined("stEvent.subject"))
			stEvent.subject = "Auto vCalendar Generated";

		if (NOT IsDefined("stEvent.description"))
			stEvent.description = "Autobot VCalendar Generated";

		if (NOT IsDefined("stEvent.priority"))
			stEvent.priority = "1";

		if (NOT IsDefined("stEvent.type"))
			stEvent.type = "event";


		vCal = "BEGIN:VCALENDAR" & CRLF;
		vCal = vCal & "PRODID:-//Microsoft Corporation//OutlookMIMEDIR//EN" & CRLF;
		//vCal = vCal & "VERSION:1.0" & CRLF;
		vCal = vCal & "VERSION:2.0" & CRLF;

		/*if(stEvent.type EQ "task")
			vCal = vCal & "BEGIN:VTODO" & CRLF;
		else*/
			vCal = vCal & "BEGIN:VEVENT" & CRLF;

		vCal = vCal & "DTSTAMP:" &
			DateFormat(now(),"yyyymmdd") & "T" &
			TimeFormat(now(), "HHmmss") & "Z" & CRLF;


		if(stEvent.type EQ "task"){

			vCal = vCal & "DTSTART;VALUE=DATE:" &
				DateFormat(stEvent.startTime,"yyyymmdd") & CRLF;

			stEvent.endTime = dateAdd("d", 1, stEvent.endTime);

			vCal = vCal & "DTEND;VALUE=DATE:" &
				DateFormat(stEvent.endTime, "yyyymmdd") & CRLF;

			/*vCal = vCal & "DUE:" & DateFormat(stEvent.endTime, "yyyymmdd") & "T" &
				TimeFormat(stEvent.endTime, "HHmmss") & "Z" & CRLF;*/

		} else {

			vCal = vCal & "DTSTART:" &
				DateFormat(stEvent.startTime,"yyyymmdd") & "T" &
				TimeFormat(stEvent.startTime, "HHmmss") & "Z" & CRLF;

			vCal = vCal & "DTEND:" & DateFormat(stEvent.endTime, "yyyymmdd") & "T" &
				TimeFormat(stEvent.endTime, "HHmmss") & "Z" & CRLF;
			vCal = vCal & "LOCATION:" & stEvent.location & CRLF;

		}

		if ( IsDefined("stEvent.url") )
			vCal = vCal & "URL:" & stEvent.url & CRLF;

		vCal = vCal & "SUMMARY;ENCODING=QUOTED-PRINTABLE:" & stEvent.subject & CRLF;

		vCal = vCal & "DESCRIPTION:"; //;ENCODING=QUOTED-PRINTABLE

		description = ReplaceNoCase(stEvent.description,"<br />","","ALL");
		description = ReplaceNoCase(stEvent.description,"<br/>","","ALL");
		description = ReplaceNoCase(stEvent.description,"<br>","","ALL");
		description = ReplaceNoCase(description,"<p>","","ALL");
		description = ReplaceNoCase(description,"</p>","","ALL");

		description = removeHTML(description);
		description = HtmlUnEditFormat(description);

		// Convert CF_CRLF (13_10) into =0D=0A with CR/LF and indent sequences*
		// Esto da problemas e impide que el contenido de description salga bien
		//description = REReplace(description,"[#Chr(13)##Chr(10)#]", "=0D=0A=#Chr(13)##Chr(10)#     ", "ALL");
		description = ReplaceNoCase(description, chr(13)&chr(10), "\n", "ALL");
		vCal = vCal & description & CRLF;

		//Esto no funciona
		//vCal = vCal & "X-ALT-DESC;FMTTYPE=text/html:<!DOCTYPE html><html><body>" & stEvent.description & "</body></html>" & CRLF;

		vCal = vCal & "PRIORITY:" & stEvent.priority & CRLF;

		/*if(stEvent.type EQ "task")
			vCal = vCal & "END:VTODO" & CRLF;
		else*/
			vCal = vCal & "END:VEVENT" & CRLF;

		vCal = vCal & "END:VCALENDAR" & CRLF;

		return vCal;

	}

	</cfscript>


	<!---
		https://github.com/JamoCA/CIDRBlocklist
		http://tech.groups.yahoo.com/group/fusebox5/message/2089
	--->
	<cffunction name="isWithinCIDR" access="public" output="false" returntype="boolean" hint="I test if an IP address falls within the given CIDR range.">
		<cfargument name="CIDR" required="true" type="string" hint="A CIDR address range in the form of AAA.BBB.CCC.DDD/xx">
		<cfargument name="TestIP" required="true" type="string" hint="An IP address to test.">
		<cfset var CIDRParts = ListToArray(arguments.CIDR, "/")>
		<cfset var CIDRAddress = ListToArray(CIDRParts[1], ".")>
		<cfset var CIDRMask = 32>
		<cfset var TestIPAddress = ListToArray(arguments.TestIP, ".")>
		<cfset var CIDRRealAddress = 0>
		<cfset var CIDRRealMask = 0>
		<cfset var TestRealAddress = 0>
		<cfset var TestIPA = 0>
		<cfset var TestIPB = 0>
		<cfset var CidrA = 0>
		<cfset var CidrB = 0>
		<cfset var MaskA = 0>
		<cfset var MaskB = 0>
		<cfset var x = "">
		<CFIF ArrayLen(CIDRParts) EQ 2 AND VAL(CIDRParts[2]) GT 1 AND VAL(CIDRParts[2]) LT 33>
			<cfset CIDRMask = CIDRParts[2]>
		</CFIF>

		<!--- Get the integer the CIDR core address represents --->
		<cfset CIDRRealAddress = CIDRAddress[4]>
		<cfset CIDRRealAddress = CIDRRealAddress + CIDRAddress[3] * 256> <!--- 2^8 --->
		<cfset CIDRRealAddress = CIDRRealAddress + CIDRAddress[2] * 65536> <!--- 2^16 --->
		<cfset CIDRRealAddress = CIDRRealAddress + CIDRAddress[1] * 16777216> <!--- 2^24 --->

		<!--- Get the integer representation of the test IP address --->
		<cfset TestRealAddress = TestIPAddress[4]>
		<cfset TestRealAddress = TestRealAddress + TestIPAddress[3] * 256> <!--- 2^8 --->
		<cfset TestRealAddress = TestRealAddress + TestIPAddress[2] * 65536> <!--- 2^16 --->
		<cfset TestRealAddress = TestRealAddress + TestIPAddress[1] * 16777216> <!--- 2^24 --->

		<!--- Get the integer representation of the CIDR mask --->
		<cfloop from="1" to="#CIDRMask#" index="x">
			<cfset CIDRRealMask = CIDRRealMask + 2^(32-x) >
		</cfloop>

		<!--- CF's BitAnd() cannot handle 32-bit unsigned integers, we will
		break these addresses into numbers denoting their left and right half bits --->
		<!--- Just the left 16 bits --->
		<cfset CidrA = int(CIDRRealAddress / 65536)>
		<cfset TestIPA = int(TestRealAddress / 65536)>
		<cfset MaskA = int(CIDRRealMask / 65536)>
		<!--- Just the right 16 bits --->
		<!--- Much more efficient would be to use "mod 65536" but even this does not support unsigned integers --->
		<cfset CidrB = CIDRRealAddress - (CidrA * 65536)>
		<cfset TestIPB = TestRealAddress - (TestIPA * 65536)>
		<cfset MaskB = CIDRRealMask - (MaskA * 65536)>

		<cfif BitAnd(CidrA, MaskA) eq BitAnd(TestIPA, MaskA) AND BitAnd(CidrB, MaskB) eq BitAnd(TestIPB, MaskB)>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>


</cfcomponent>
