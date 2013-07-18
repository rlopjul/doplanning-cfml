<cfoutput>
<script src="#APPLICATION.htmlPath#/language/user_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<!---<div class="div_head_subtitle">
Datos Personales
</div>--->
<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfset return_page = "preferences.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Login" method="getUserLoggedIn" returnvariable="xmlResponse">
</cfinvoke>

<cfxml variable="xmlUser">
	<cfoutput>
	#xmlResponse.response.result.user#
	</cfoutput>
</cfxml>
<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="objectUser" returnvariable="objectUser">
	<cfinvokeargument name="xml" value="#xmlUser.user#">
	<cfinvokeargument name="return_type" value="object">
</cfinvoke>


<script type="text/javascript">

	function setLanguageBeforeSend(form) {
		
		var selectedLanguage = $("##language").val();
		
		window.lang.change(selectedLanguage);
		
		return true;	
	}

</script>


<cfinclude template="#APPLICATION.htmlPath#/includes/user_data_form.cfm"/>