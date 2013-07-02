<cfscript>

/**
* @return Returns a string. 
* @author Alexis Lucena
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