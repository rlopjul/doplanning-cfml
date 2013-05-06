<cfset langText = structNew()><!---Almacena los textos de los idiomas--->

<cfinvoke component="#APPLICATION.componentsPath#/components/Language" method="chargeLangText" returnvariable="langText">
	<cfinvokeargument name="filePath" value="#ExpandPath('#APPLICATION.path#/app/language/application.xml')#">
	<cfinvokeargument name="strLanguages" value="#APPLICATION.languages#">
	<cfinvokeargument name="curLangText" value="#langText#">
</cfinvoke>
