<cfif isDefined("client_abb")>
	<cflocation url="../html/login/?client_abb=#client_abb#" addtoken="no">
</cfif>

<!---
En la nueva versión sin flash, esto no se usa
<cfif isDefined("client_abb")>

	<cfif findNoCase("iphone",CGI.HTTP_USER_AGENT) IS NOT 0>
		<cflocation url="html/" addtoken="no">
	</cfif>

	<cfif isDefined("URL.bgcolor")>
		<cfset background_color = "##"&URL.bgcolor>
	<cfelse>
		<cfset background_color = "##FFFFFF">
	</cfif>
<cfset debug_mode = false>
<cfset swf_name = "dp_login_#APPLICATION.clientLoginVersion#">
<cfset swf_width = "480">
<cfset swf_height = "250">
<cfquery datasource="#APPLICATION.dsn#" name="getClient">
	SELECT *
	FROM app_clients
	WHERE abbreviation = <cfqueryparam value="#client_abb#" cfsqltype="cf_sql_varchar">;
</cfquery>
<!---<cfset client_email_support = getClient.email_support>--->
<!-- saved from url=(0014)about:internet -->
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<cfoutput>
<title>#APPLICATION.title# Login - #getClient.name#</title>
</cfoutput>
<script src="../app/scripts/AC_OETags.js" language="javascript"></script>
<cfoutput>
<style>
body { margin: 0px; overflow:hidden; background-color:#background_color#}
.url_link { font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;}
.help_link { font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px; }
</style>
</cfoutput>
<script language="JavaScript" type="text/javascript">
<!--
// -----------------------------------------------------------------------------
// Globals
// Major version of Flash required
var requiredMajorVersion = 9;
// Minor version of Flash required
var requiredMinorVersion = 0;
// Minor version of Flash required
var requiredRevision = 0;
// -----------------------------------------------------------------------------
// -->
</script>
</head>
<body scroll="no">

<cfoutput>
<table style="width:100%; height:100%;">
<tr><td style="vertical-align:middle; margin:auto;" align="center">
<script language="JavaScript" type="text/javascript" src="../app/scripts/history.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
// Version check for the Flash Player that has the ability to start Player Product Install (6.0r65)
var hasProductInstall = DetectFlashVer(6, 0, 65);

// Version check based upon the values defined in globals
var hasRequestedVersion = DetectFlashVer(requiredMajorVersion, requiredMinorVersion, requiredRevision);


// Check to see if a player with Flash Product Install is available and the version does not meet the requirements for playback
if ( hasProductInstall && !hasRequestedVersion ) {
	// MMdoctitle is the stored document.title value used by the installation process to close the window that started the process
	// This is necessary in order to close browser windows that are still utilizing the older version of the player after installation has completed
	// DO NOT MODIFY THE FOLLOWING FOUR LINES
	// Location visited after installation is complete if installation is required
	var MMPlayerType = (isIE == true) ? "ActiveX" : "PlugIn";
	var MMredirectURL = window.location;
    document.title = document.title.slice(0, 47) + " - Flash Player Installation";
    var MMdoctitle = document.title;

	AC_FL_RunContent(
		"src", "../app/playerProductInstall",
		"FlashVars", "MMredirectURL="+MMredirectURL+'&MMplayerType='+MMPlayerType+'&MMdoctitle='+MMdoctitle+"&main_url=#APPLICATION.mainUrl#&sign_out_url=#APPLICATION.signOutUrl#&path=#APPLICATION.path#&components_path=#APPLICATION.componentsPath#&upload_files_path=#APPLICATION.uploadFilesPath#&default_language=#APPLICATION.defaultLanguage#&debug_mode=#debug_mode#&client_abb=#client_abb#",
		"width", "#swf_width#",
		"height", "#swf_height#",
		"align", "middle",
		"id", "dp_login",
		"quality", "high",
		"bgcolor", "#background_color#",
		"name", "#swf_name#",
		"allowScriptAccess","sameDomain",
		"type", "application/x-shockwave-flash",
		"pluginspage", "http://www.adobe.com/go/getflashplayer"
	);
} else if (hasRequestedVersion) {
	// if we've detected an acceptable version
	// embed the Flash Content SWF when all tests are passed
	AC_FL_RunContent(
			"src", "../app/#swf_name#",
			"width", "#swf_width#",
			"height", "#swf_height#",
			"align", "middle",
			"id", "#swf_name#",
			"quality", "high",
			"bgcolor", "#background_color#",
			"name", "#swf_name#",
			"flashvars",'historyUrl=history.htm%3F&lconid=' + lc_id + '&main_url=#APPLICATION.mainUrl#&sign_out_url=#APPLICATION.signOutUrl#&path=#APPLICATION.path#&components_path=#APPLICATION.componentsPath#&upload_files_path=#APPLICATION.uploadFilesPath#&default_language=#APPLICATION.defaultLanguage#&debug_mode=#debug_mode#&client_abb=#client_abb#',
			"allowScriptAccess","sameDomain",
			"type", "application/x-shockwave-flash",
			"pluginspage", "http://www.adobe.com/go/getflashplayer"
	);
  } else {  // flash is too old or we can't detect the plugin
    var alternateContent = 'Alternate HTML content should be placed here. '
  	+ 'This content requires the Adobe Flash Player. '
   	+ '<a href=http://www.adobe.com/go/getflash/>Get Flash</a>';
    document.write(alternateContent);  // insert non-flash content
  }
// -->
</script>
<noscript>
  	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="#swf_width#" height="#swf_height#" codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
			<param name="movie" value="../app/#swf_name#.swf" />
			<param name="quality" value="high" />
			<param name="bgcolor" value="#background_color#" />
			<param name="allowScriptAccess" value="sameDomain" />
			<param name="flashVars" value="main_url=#APPLICATION.mainUrl#&sign_out_url=#APPLICATION.signOutUrl#&path=#APPLICATION.path#&components_path=#APPLICATION.componentsPath#&upload_files_path=#APPLICATION.uploadFilesPath#&default_language=#APPLICATION.defaultLanguage#&debug_mode=#debug_mode#&client_abb=#client_abb#"/>
			<embed src="../app/#swf_name#.swf" quality="high" bgcolor="#background_color#"
				width="#swf_width#" height="#swf_height#" name="#swf_name#" align="middle"
				play="true"
				loop="false"
				quality="high"
				allowScriptAccess="sameDomain"
				type="application/x-shockwave-flash"
				pluginspage="http://www.adobe.com/go/getflashplayer"
				flashVars="main_url=#APPLICATION.mainUrl#&sign_out_url=#APPLICATION.signOutUrl#&path=#APPLICATION.path#&components_path=#APPLICATION.componentsPath#&upload_files_path=#APPLICATION.uploadFilesPath#&default_language=#APPLICATION.defaultLanguage#&debug_mode=#debug_mode#&client_abb=#client_abb#">
			</embed>
	</object>
</noscript>
</td></tr>
<tr><td style="height:12px"><div style="float:left"><a href="http://www.doplanning.net" class="url_link" target="_blank">www.doplanning.net</a></div><div style="float:right;"><a href="#APPLICATION.helpUrl#" class="help_link" target="_blank">Ayuda</a></div></td></tr>
</table>
</cfoutput>

</body>
</html>
</cfif>--->