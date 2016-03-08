<cfif isDefined("URL.user") AND isNumeric(URL.user)>

	<cfset user_id = URL.user>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
		<cfinvokeargument name="user_id" value="#user_id#">
	</cfinvoke>

	<cfoutput>

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    <h4 id="areaModalLabel">Árbol de áreas de #objectUser.user_full_name#</h4>
		</div>

	 	<div class="modal-body">

	 		<!---<div style="margin-bottom:10px;">Usuario:
				<strong>#objectUser.user_full_name#</strong><br/>
			</div>--->

			<iframe marginheight="0" marginwidth="0" scrolling="auto" width="100%" frameborder="0" src="#APPLICATION.htmlPath#/admin/iframes/user_tree.cfm?user=#user_id#" style="height:350px;background-color:##FFFFFF;"></iframe>

		</div>

		<div class="modal-footer">
		    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cerrar</button>
		</div>


	</cfoutput>

</cfif>

<!---<cfinclude template="#APPLICATION.htmlPath#/admin/includes/user_tree.cfm">--->
