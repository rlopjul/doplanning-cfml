
<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">
<!---<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">--->

<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
	<cfset table_id = URL[tableTypeName]>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>

<!---Table--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset area_id = table.area_id>

<!---Table users--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableUsers" returnvariable="tableUsersResult">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
	<cfinvokeargument name="with_table" value="true">
</cfinvoke>
<cfset tableUsers = tableUsersResult.tableUsers>
<cfset tableUsersArray = listToArray(valueList(tableUsers.user_id, ","))>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_id.cfm">
<cfinclude template="#APPLICATION.htmlPath#/includes/area_checks.cfm">

<cfif NOT isDefined("includeAppMenu") OR includeAppMenu IS true>
	<cfinclude template="#APPLICATION.htmlPath#/includes/app_page_head.cfm">
</cfif>

<div class="div_head_subtitle"><span lang="es">Añadir editores</span></div>

<div style="clear:both; margin-top:5px;">
	<cfset page_type = 2>
	<cfinclude template="#APPLICATION.htmlPath#/includes/area_users_select.cfm">
</div>

<div style="margin-left:5px;"><small lang="es">Los usuarios que se añadan como editores recibirán un email notificándoselo.</small></div>

<cfoutput>
<script type="text/javascript">

	var tableId = #table_id#;
	var tableTypeId = #tableTypeId#;
	var tableUsers = #serializeJSON(tableUsersArray)#;

	var newUsers = [];

	function addUser(userId, userName){

		if(tableUsers.indexOf(userId) == -1) {
			newUsers.push(userId);
			return true;
		} else {
			alert(userName+" ya es editor de la #tableTypeNameEs#");
			return false;
		}

	}

	function sendUsersForm(){

		showLoadingPage(true);

		var requestUrl = "#APPLICATION.htmlComponentsPath#/Table.cfc?method=addUsersToTable";
		var responseUrl = "#tableTypeName#_users.cfm?#tableTypeName#="+tableId;

		$.ajax({
		  type: "POST",
		  url: requestUrl,
		  data: {table_id:tableId, tableTypeId:tableTypeId, users_ids:newUsers},
		  dataType: "json",
		  success: function(data, status) {

		  	if(status == "success"){
		  		var message = encodeURIComponent(data.message);

		  		goToUrl(responseUrl+"&msg="+message+"&res="+data.result);

		  		<!---openUrl(responseUrl);
		  		hideDefaultModal();
		  		$('body').modalmanager('removeLoading');
		  		showAlertMessage(message, data.result);--->

		  	}else{

		  		showLoadingPage(false);

		  		alert(status);
		  		newUsers = [];
		  	}

		  }
		});

	}

</script>
</cfoutput>
