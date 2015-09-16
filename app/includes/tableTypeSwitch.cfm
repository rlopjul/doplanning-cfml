
<cfinvoke component="#APPLICATION.coreComponentsPath#/TableManager" method="getTableTypeStruct" returnvariable="tableTypeStruct">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>

<cfset tableTypeName = tableTypeStruct.name>
<cfset tableTypeNameP = tableTypeStruct.namePlural>
<cfset tableTypeTable = tableTypeStruct.table>

<cfset tableTypeNameEs = tableTypeStruct.label>

<cfset tableTypeGender = tableTypeStruct.gender>

<cfset itemTypeId = tableTypeStruct.itemTypeId>
<cfset viewTypeId = tableTypeStruct.viewTypeId>
<cfset attachedFileTypeId = tableTypeStruct.attachedFileTypeId>
