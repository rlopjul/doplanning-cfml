<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>

<cfset apiKey = 28563472>
<cfset apiSecret = "155e13718a36a6077960595721274bd23b1089d7">
<cfset jarPath = "#APPLICATION.path#/app/WS/components/opentok-java-sdk-0.91.58-SNAPSHOT.jar">
	
<cfset openTokSDK = createObject("Java", "com.opentok.api.OpenTokSDK", jarPath)>
<cfset openTokSDK.init(apiKey, apiSecret)>

<!---<cfset token = openTokSDK.generate_token("session")>

<cfset openTokRoleConstants = createObject("Java", "com.opentok.api.constants.RoleConstants", jarPath)>

<cfset token2 = openTokSDK.generate_token("session", openTokRoleConstants.SUBSCRIBER)>

<cfoutput>
	#token#<br/>
	#token2#<br/>
</cfoutput>--->


<cfset openTokSessionProperties = createObject("Java", "com.opentok.api.constants.SessionProperties", jarPath)>
<cfset openTokSessionProperties.p2p_preference = "enabled">

<cfset sessionId = openTokSDK.create_session(JavaCast("null", ""), openTokSessionProperties).session_id>

<cfoutput>
	#sessionId#
</cfoutput>

</body>
</html>
