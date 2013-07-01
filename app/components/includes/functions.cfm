<!---
The arrayFindCustom function uses the java.util.list indexOf function to find an element in an array.
v1 by Nathan Dintenfas.

@param array      Array to search. (Required)
@param valueToFind      Value to find. (Required)
@return Returns a number, 0 if no match is found. 
@author Larry C. Lyons (larryclyons@gmail.com) 
@version 2, April 30, 2008 
--->
<cffunction name="arrayFindCustom" access="public" hint="returns the index number of an item if it is in the array" output="false" returntype="numeric">

<cfargument name="array" required="true" type="array">
<cfargument name="valueToFind" required="true" type="string">

<cfreturn (arguments.array.indexOf(arguments.valueToFind)) + 1>
</cffunction>

<cfscript>
/**
* Sorts an array of structures based on a key in the structures.
* 
* @param aofS      Array of structures. 
* @param key      Key to sort by. 
* @param sortOrder      Order to sort by, asc or desc. 
* @param sortType      Text, textnocase, or numeric. 
* @param delim      Delimiter used for temporary data storage. Must not exist in data. Defaults to a period. 
* @return Returns a sorted array. 
* @author Nathan Dintenfass (nathan@changemedia.com) 
* @version 1, December 10, 2001 
*/
function arrayOfStructsSort(aOfS,key){
        //by default we'll use an ascending sort
        var sortOrder = "asc";        
        //by default, we'll use a textnocase sort
        var sortType = "textnocase";
        //by default, use ascii character 30 as the delim
        var delim = ".";
        //make an array to hold the sort stuff
        var sortArray = arraynew(1);
        //make an array to return
        var returnArray = arraynew(1);
        //grab the number of elements in the array (used in the loops)
        var count = arrayLen(aOfS);
        //make a variable to use in the loop
        var ii = 1;
        //if there is a 3rd argument, set the sortOrder
        if(arraylen(arguments) GT 2)
            sortOrder = arguments[3];
        //if there is a 4th argument, set the sortType
        if(arraylen(arguments) GT 3)
            sortType = arguments[4];
        //if there is a 5th argument, set the delim
        if(arraylen(arguments) GT 4)
            delim = arguments[5];
        //loop over the array of structs, building the sortArray
        for(ii = 1; ii lte count; ii = ii + 1)
            sortArray[ii] = aOfS[ii][key] & delim & ii;
        //now sort the array
        arraySort(sortArray,sortType,sortOrder);
        //now build the return array
        for(ii = 1; ii lte count; ii = ii + 1)
            returnArray[ii] = aOfS[listLast(sortArray[ii],delim)];
        //return the array
        return returnArray;
}
</cfscript>


<!---
ESTA FUNCION NO SE UTILIZA
<cfscript>
/**
* Appends a value to an array if the value does not already exist within the array.
* 
* @param a1      The array to modify. 
* @param val      The value to append. 
* @return Returns a modified array or an error string. 
* @author Craig Fisher (craig@altainteractive.com) 
* @version 1, October 29, 2001 
*/
function ArrayAppendUnique(a1,val) {
    if ((NOT IsArray(a1))) {
        writeoutput("Error in <Code>ArrayAppendUnique()</code>! Correct usage: ArrayAppendUnique(<I>Array</I>, <I>Value</I>) -- Appends <em>Value</em> to the array if <em>Value</em> does not already exist");
        return 0;
    }
    if (NOT ListFind(Arraytolist(a1), val)) {
        arrayAppend(a1, val);
    }
    return a1;
}
</cfscript>--->