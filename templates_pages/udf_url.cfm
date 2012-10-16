<cfscript>
/**
* @return String
* @author Alexis Lucena
*/
function titleToUrl(title) {
	
	var str = lCase(trim(title));
	
	str = replaceList(str," ,á,é,í,ó,ú,ñ", "-,a,e,i,o,u,n");
	
	return str;	
}

</cfscript>