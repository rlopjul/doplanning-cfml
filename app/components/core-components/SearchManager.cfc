<!---Copyright Era7 Information Technologies 2007-2013--->

<cfcomponent output="false">

	<cfset component = "SearchManager">	
		
	<!----------------------------------------- generateSearchText -------------------------------------------------->
	
	<cffunction name="generateSearchText" access="public" output="false" returntype="string">
		<cfargument name="text" type="string" required="yes">
		
		<cfset var method = "generateSearchText">
		
		<cfset var text_re = "">
				
		<!---<cfset text_search = replaceList(lCase(text), "a,e,i,o,u", "[aàáäåãæâ],[eèéêë],[iìíîï],[oöôõðòóø],[uüûùú]"))>--->
		
		<cfset text_re = Trim(arguments.text)><!---Remove white space from the beginning and the end--->
		<cfset text_re = replaceList(text_re, "+,?,*,|,(,),[,],\", ",,,,,,,,")><!---Remove special chars to avoid errors--->	
		<cfset text_re = "(#text_re#">
		<!---<cfset text_re = ReplaceNoCase(text_re," ","|","ALL")>--->
		<cfset text_re = ReplaceNoCase(text_re," ",".*","ALL")><!---* --> El caracter que le precede debe aparecer cero, una o más veces--->
		
		<!---<cfset text_re = REReplaceNoCase(text_re,"[aàáäåãæâ]","[aàáäåãæâ]+", "ALL")>--->
		<cfset text_re = REReplaceNoCase(text_re,"[aàáäâ]","[aàáäâ]+", "ALL")>
		<cfset text_re = REReplaceNoCase(text_re,"[eèéêë]","[eèéêë]+", "ALL")>
		<cfset text_re = REReplaceNoCase(text_re,"[iìíîï]","[iìíîï]+", "ALL")>
		<!---<cfset text_re = REReplaceNoCase(text_re,"[oöôõðòóø]","[oöôõðòóø]+", "ALL")>--->
		<cfset text_re = REReplaceNoCase(text_re,"[oöôòó]","[oöôòó]+", "ALL")>
		<cfset text_re = REReplaceNoCase(text_re,"[uüûùú]","[uüûùú]+", "ALL")>
	
		<cfset last_char = Right(text_re,1)>
		<cfif last_char EQ "+">
			<cfset text_len = len(text_re)>
			<cfset text_re = Left(text_re,text_len-1)>		
		</cfif>
		
		<cfset text_re = "#text_re#)">
		
		<!--- IMPORTANTE: se devuelve el texto en mayúscula porque cuando hay un registro en mayúsculas con acentos, no aparece como resultado si no se compara con los caracteres acentuados en mayúscula, o no se pasa el valor a minúscula para compararlo --->

		<cfreturn uCase(text_re)>
				
	</cffunction>

</cfcomponent>