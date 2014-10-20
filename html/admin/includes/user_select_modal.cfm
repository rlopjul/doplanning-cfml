<!--- Select user modal --->
<div id="selectUserModal" class="modal fade" tabindex="-1"><!---hide no fuciona en bs3--->

	<div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	    <h4>Seleccionar usuario</h4>
	</div>

 	<div class="modal-body">
 		<cfif NOT isDefined("area_id")>
 			<cfset area_id = parent_area_id>
 		</cfif>
 		<cfset page_type = 1>
 		<cfinclude template="#APPLICATION.htmlPath#/includes/area_users_select.cfm">
 	</div>

</div>	

<cfoutput>
<script>
	
	function showSelectUserModal(){

		<!---
		Esto quitado porque tarda en cargarse el tablesorter al mostrarse
		$('##selectUserModal').modal({
				  keyboard: true,
				  <cfif isDefined("area_id")>
				  	remote: "html_content/area_users_select.cfm?area="+#objectArea.id#,
				  <cfelse>
				  	remote: "html_content/area_users_select.cfm?area="+#parent_area_id#,
				  </cfif>
				});--->
		$('##selectUserModal').modal();
	}

	function setResponsibleUser(userId, userFullName) {
				
		document.getElementById("user_in_charge").value = userId;
		document.getElementById("user_in_charge_full_name").value = userFullName;

		hideModal('##selectUserModal');
	}

</script>
</cfoutput>