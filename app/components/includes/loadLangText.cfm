<cfset langText = structNew()><!---Almacena los textos de los idiomas--->

<!---<cfinvoke component="#APPLICATION.coreComponentsPath#/Language" method="chargeLangText" returnvariable="langText">
	<cfinvokeargument name="filePath" value="#ExpandPath('#APPLICATION.componentsPath#/language/#component#.xml')#">
	<cfinvokeargument name="curLangText" value="#langText#">
</cfinvoke>--->

<cfinvoke component="#APPLICATION.coreComponentsPath#/Language" method="chargeLangText" returnvariable="langText">
	<cfinvokeargument name="filePath" value="#APPLICATION.componentsPath#/language/#component#.cfm">
</cfinvoke>