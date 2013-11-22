<cfset langText = structNew()><!---Almacena los textos de los idiomas--->

<cfinvoke component="#APPLICATION.coreComponentsPath#/Language" method="chargeLangText" returnvariable="langText">
	<cfinvokeargument name="filePath" value="#APPLICATION.componentsPath#/language/#component#.cfm">
</cfinvoke>