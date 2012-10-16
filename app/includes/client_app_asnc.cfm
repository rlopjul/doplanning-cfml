<cfif NOT isDefined("debug_mode")>
	<cfset debug_mode = false>
</cfif>
<cfif isDefined("URL.app") AND (URL.app EQ "areaAdmin" OR URL.app EQ "generalAdmin")>
	<cfif URL.app EQ "areaAdmin">
		<cfset swf_name = "VPNetAreaAdmin">
	<cfelseif URL.app EQ "generalAdmin">
		<cfset swf_name = "VPNetGeneralAdmin">	
	</cfif>
<cfelse>
	<cfset swf_name = "dp_vpnet_#APPLICATION.clientVersion#">
</cfif>
<!-- saved from url=(0014)about:internet -->
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#APPLICATION.title#<cfif isDefined("SESSION.client_name")> - #SESSION.client_name#</cfif></cfoutput></title>
<script src="../app/scripts/AC_OETags.js" language="javascript"></script>
<style>
body { margin: 0px; overflow:hidden }
</style>
<script type="text/javascript">
	function checkScreenResolution()
	{
		var width = screen.width;
		var height = screen.height;
		if(width<1024 || height<768)
			window.location.href = "../html/screen_resolution.cfm";
	}
	checkScreenResolution();
</script>
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
		"FlashVars", "MMredirectURL="+MMredirectURL+'&MMplayerType='+MMPlayerType+'&MMdoctitle='+MMdoctitle+"&main_url=#APPLICATION.mainUrl#&sign_out_url=#APPLICATION.signOutUrl#&path=#APPLICATION.path#&components_path=#APPLICATION.componentsPath#&upload_files_path=#APPLICATION.uploadFilesPath#&resources_path=#APPLICATION.resourcesPath#&help_url=#APPLICATION.helpUrl#&community_url=#APPLICATION.communityUrl#&default_language=#APPLICATION.defaultLanguage#&debug_mode=#debug_mode#" ,
		"width", "100%",
		"height", "100%",
		"align", "middle",
		"id", "DPCore",
		"quality", "high",
		"bgcolor", "##FFFFFF",
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
			"width", "100%",
			"height", "100%",
			"align", "middle",
			"id", "#swf_name#",
			"quality", "high",
			"bgcolor", "##FFFFFF",
			"name", "#swf_name#",
			"flashvars",'main_url=#APPLICATION.mainUrl#&sign_out_url=#APPLICATION.signOutUrl#&path=#APPLICATION.path#&components_path=#APPLICATION.componentsPath#&upload_files_path=#APPLICATION.uploadFilesPath#&resources_path=#APPLICATION.resourcesPath#&help_url=#APPLICATION.helpUrl#&community_url=#APPLICATION.communityUrl#&default_language=#APPLICATION.defaultLanguage#&debug_mode=#debug_mode#',
			"allowScriptAccess","sameDomain",
			"type", "application/x-shockwave-flash",
			"pluginspage", "http://www.adobe.com/go/getflashplayer"
	);
  } else {  // flash is too old or we can't detect the plugin
    var alternateContent = '' + 'This content requires the Adobe Flash Player. '
   	+ '<a href=http://www.adobe.com/go/getflash/>Get Flash</a>';
    document.write(alternateContent);  // insert non-flash content
  }
// -->
</script> 
<noscript>
<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" id="#swf_name#" width="100%" height="100%"	codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
		<param name="movie" value="../app/#swf_name#.swf?#CGI.QUERY_STRING#" />
		<param name="quality" value="high" />
		<param name="bgcolor" value="##FFFFFF" />
		<param name="allowScriptAccess" value="sameDomain" />
		<param name="flashVars" value="main_url=#APPLICATION.mainUrl#&sign_out_url=#APPLICATION.signOutUrl#&path=#APPLICATION.path#&components_path=#APPLICATION.componentsPath#&upload_files_path=#APPLICATION.uploadFilesPath#&resources_path=#APPLICATION.resourcesPath#&default_language=#APPLICATION.defaultLanguage#&debug_mode=#debug_mode#"/>
		<embed src="../app/#swf_name#.swf?#CGI.QUERY_STRING#" quality="high" bgcolor="##FFFFFF"
			width="100%" height="100%" name="#swf_name#" align="middle"
			play="true"
			loop="false"
			quality="high"
			allowScriptAccess="sameDomain"
			type="application/x-shockwave-flash"
			pluginspage="http://www.adobe.com/go/getflashplayer">
		</embed>
</object>
</noscript>
</cfoutput>
</body>
</html>