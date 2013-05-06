<!---Copyright Era7 Information Technologies 2007-2012

	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 09-11-2012
	
--->
<cfcomponent output="false">


	<cffunction name="loadLangText" output="false" access="public" returntype="struct">
		<cfargument name="strLanguages" type="string" required="yes">
		<cfargument name="curLangText" type="struct" required="yes">
		<cfargument name="language" type="string" required="no">
		
		<cfset var xmlLanguages = xmlParse(arguments.strLanguages)>		
		
		<cfset var langText = duplicate(arguments.curLangText)>
		
		<cfloop index="langIndex" from="1" to="#ArrayLen(xmlLanguages.languages.xmlChildren)#" step="1">
		
			<cfset xmlLanguage = xmlLanguages.languages.xmlChildren[langIndex]>
						
			<cfset languageId = xmlLanguage.xmlAttributes.id>
			
			<cfif isDefined("arguments.language")>
			
				<cfif languageId EQ arguments.language>
				
					<cfloop index="curIndex" from="1" to="#ArrayLen(xmlLanguage.xmlChildren)#" step="1">
						
						<cfset curNode = xmlLanguage.xmlChildren[curIndex]>;
						
						<cfset curNodeLen =  ArrayLen(curNode.xmlChildren)>
						
						<cfif curNodeLen GT 0>
							
							<cfloop index="curSubIndex" from="1" to="#curNodeLen#" step="1">
						
								<cfset curSubNode = curNode.xmlChildren[curSubIndex]>
								
								<cfset langText[curNode.xmlName][curSubNode.xmlName] = curSubNode.xmlText>
								
							</cfloop>	
							
						<cfelse>
							<cfset langText[curNode.xmlName] = curNode.xmlText>
						</cfif>
					</cfloop>
					
					<cfreturn langText>
					
				</cfif>	
			
			<cfelse>
			
				<cfloop index="curIndex" from="1" to="#ArrayLen(xmlLanguage.xmlChildren)#" step="1">
						
					<cfset curNode = xmlLanguage.xmlChildren[curIndex]>;
					
					<cfset curNodeLen =  ArrayLen(curNode.xmlChildren)>
					
					<cfif curNodeLen GT 0>
						
						<cfloop index="curSubIndex" from="1" to="#curNodeLen#" step="1">
					
							<cfset curSubNode = curNode.xmlChildren[curSubIndex]>
							
							<cfset langText[languageId][curNode.xmlName][curSubNode.xmlName] = curSubNode.xmlText>
							
						</cfloop>	
						
					<cfelse>
						<cfset langText[languageId][curNode.xmlName] = curNode.xmlText>
					</cfif>
					
				</cfloop>
						
			</cfif>
		
		</cfloop>
		
		<cfreturn langText>
		
	</cffunction>
	
	
	<cffunction name="chargeLangText" output="false" access="public" returntype="struct">
		<cfargument name="filePath" type="string" required="yes">
		<cfargument name="curLangText" type="struct" required="yes">
		<cfargument name="language" type="string" required="no">
		
		<cffile action="read" file="#arguments.filePath#" variable="strLanguages"/>

		<cfinvoke component="Language" method="loadLangText" returnvariable="langText">
			<cfinvokeargument name="strLanguages" value="#strLanguages#">
			<cfinvokeargument name="curLangText" value="#arguments.curlangText#">
			<cfif isDefined("arguments.language")>
				<cfinvokeargument name="language" value="#arguments.language#">
			</cfif>
		</cfinvoke>
		
		<cfreturn langText>
		
	</cffunction>
	
	
	
	<!---setMessageStruct--->
	<cffunction name="setMessageStruct" access="public" returntype="struct">
		<cfargument name="struct_path" type="string" required="yes">
		<cfargument name="langText" type="struct" required="yes">
		<cfargument name="initCommentText" type="string" required="no">
		<cfargument name="endCommentText" type="string" required="no">
				
		<cfset var message = structNew()>		
		<cfset var cur_lang = "">
		
		<cfif isDefined("SESSION.language")>
			<cfset cur_lang = SESSION.language>
		<cfelse>
			<cfset cur_lang = APPLICATION.defaultLanguage>
		</cfif>
			
		<cfset dot_pos = findOneOf(".", arguments.struct_path)>
				
		<cfif dot_pos GT 0>	
			<cfset message[cur_lang] = arguments.initCommentText&arguments.langText[cur_lang][left(arguments.struct_path, dot_pos-1)][right(arguments.struct_path, len(arguments.struct_path)-dot_pos)]&arguments.endCommentText>	
		<cfelse>
			<cfset message[cur_lang] = arguments.initCommentText&arguments.langText[cur_lang]["#arguments.struct_path#"]&arguments.endCommentText>
		
		</cfif>
		
		<cfreturn message>
		
	</cffunction>
	
	
</cfcomponent>