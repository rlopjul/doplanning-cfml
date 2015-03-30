<!--- Copyright Era7 Information Technologies 2007-2015 --->
<cfcomponent output="true">

	<cfset component = "Bin">


	<!--- ----------------------- GET ALL BIN ITEMS -------------------------------- --->
	
	<cffunction name="getAllBinItems" returntype="struct" access="public">
		<cfargument name="limit" type="numeric" required="false">
		<cfargument name="full_content" type="boolean" required="false">

		<cfargument name="delete_user_id" type="numeric" required="false">
				
		<cfset var method = "getAllBinItems">

		<cfset var response = structNew()>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/BinManager" method="getAllBinItems" returnvariable="response">
				<cfinvokeargument name="limit" value="#arguments.limit#">
				<cfinvokeargument name="full_content" value="#arguments.full_content#">

				<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">
			</cfinvoke>	

			<cfinclude template="includes/responseHandlerStruct.cfm">
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>



	<!--- restoreBinItem --->

	<cffunction name="restoreBinItem" returntype="void" access="remote">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="return_page" type="string" required="true">
		
		<cfset var method = "restoreBinItem">
		
		<cftry>
			
			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<cfinvoke component="#APPLICATION.componentsPath#/BinManager" method="restoreBinItem" returnvariable="deleteItemResponse">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
			</cfinvoke>	

			<cfif deleteItemResponse.result IS true>

				<cfif itemTypeGender EQ "male">
					<cfset msg = "#itemTypeNameEs# restaurado.">
				<cfelse>
					<cfset msg = "#itemTypeNameEs# restaurada.">
				</cfif>
				<cfset msg = URLEncodedFormat(msg)>
            
				<cflocation url="#arguments.return_page#?msg=#msg#&res=1" addtoken="no">	

			<cfelse>

				<cfset msg = URLEncodedFormat(deleteItemResponse.message)>

				<cflocation url="#arguments.return_page#?msg=#msg#&res=0" addtoken="no">	
				
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>



	<!--- restoreBinItems --->

	<cffunction name="restoreBinItems" returntype="void" access="remote">
		<cfargument name="delete_user_id" type="numeric" required="false">
		<cfargument name="return_page" type="string" required="true">
		
		<cfset var method = "restoreBinItems">
		
		<cftry>
						
			<cfinvoke component="#APPLICATION.componentsPath#/BinManager" method="restoreBinItems" returnvariable="restoreItemResponse">
				<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">
			</cfinvoke>	

			<cfif restoreItemResponse.result IS true>

				<cfset msg = "Elementos restaurados.">
				
				<cfset msg = URLEncodedFormat(msg)>
            
				<cflocation url="#arguments.return_page#?msg=#msg#&res=1" addtoken="no">	

			<cfelse>

				<cfset msg = URLEncodedFormat(restoreItemResponse.message)>

				<cflocation url="#arguments.return_page#?msg=#msg#&res=0" addtoken="no">	
				
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>



	<!--- deleteBinItem --->

	<cffunction name="deleteBinItem" returntype="void" access="remote">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="return_page" type="string" required="true">
		
		<cfset var method = "deleteBinItem">
		
		<cftry>
			
			<!--- deleteBinItem --->
			<cfinvoke component="#APPLICATION.componentsPath#/BinManager" method="deleteBinItem" returnvariable="deleteItemResponse">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
			</cfinvoke>	

			<cfif deleteItemResponse.result IS true>

				<cfset msg = "Elemento eliminado.">
				
				<cfset msg = URLEncodedFormat(msg)>
            
				<cflocation url="#arguments.return_page#?msg=#msg#&res=1" addtoken="no">	

			<cfelse>

				<cfset msg = URLEncodedFormat(deleteItemResponse.message)>

				<cflocation url="#arguments.return_page#?msg=#msg#&res=0" addtoken="no">	
				
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>



	<!--- deleteBinItems --->

	<cffunction name="deleteBinItems" returntype="void" access="remote">
		<cfargument name="delete_user_id" type="numeric" required="false">
		<cfargument name="return_page" type="string" required="true">
		
		<cfset var method = "deleteBinItems">
		
		<cftry>
						
			<cfinvoke component="#APPLICATION.componentsPath#/BinManager" method="deleteBinItems" returnvariable="deleteItemResponse">
				<cfinvokeargument name="delete_user_id" value="#arguments.delete_user_id#">
			</cfinvoke>	

			<cfif deleteItemResponse.result IS true>

				<cfset msg = "Elementos eliminados.">
				
				<cfset msg = URLEncodedFormat(msg)>
            
				<cflocation url="#arguments.return_page#?msg=#msg#&res=1" addtoken="no">	

			<cfelse>

				<cfset msg = URLEncodedFormat(deleteItemResponse.message)>

				<cflocation url="#arguments.return_page#?msg=#msg#&res=0" addtoken="no">	
				
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	


</cfcomponent>