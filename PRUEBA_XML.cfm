<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<!---<cfxml variable="xmlDoc">
<info>
 
	<info_main id="im1">
	 
	<image-list id="il1">
	<image id="i1" />
	<image id="i2" />
	</image-list>
	 
	<name-list id="nl1">
	<name id="n1" />
	<name id="n2" />
	<name id="n3" />
	<name id="n4" />
	</name-list>
	 
	</info_main>
 
	<info_main id="im2">
	 
	<image-list id="il2">
	<image id="i3" />
	<image id="i4" />
	</image-list>
	 
	<name-list id="nl2">
	<name id="n5" />
	<name id="n6" />
	<name id="n7" />
	<name id="n8" />
	</name-list>
	 
	</info_main>
 
</info>
 
</cfxml>
<cfoutput>
#xmlDoc.xmlChildren[1].info_main#
</cfoutput>--->

<!--- Set our values from twitter--->
<!---<cfset consumerKey = "NnzqQl7cPIPDMWJxS0wvTQ">
<cfset consumerSecret = "WSfrXiKmqIt6eXwKoE5SBT7HvEWECXtkf6pCSihMOQ">
<cfset accessToken = "575490855-I82I7USCk2qzXAHYPqcJoQhNHTIcmJ9fZpm0D1JL">
<cfset accessTokenSecret = "ocWlHYr7K0J3NSIELSoHSih5Xk9V6swOqk442XbL3g">
--->
<!---Create java instance of twitter4j and set key values--->
<!---http://twitter4j.org/en/javadoc/index.html--->
<cfset twitter = createObject("Java", "twitter4j.TwitterFactory", "#APPLICATION.path#/app/WS/components/twitter4j-core-2.2.6-SNAPSHOT.jar").getInstance()>
<cfset twitter.setOAuthConsumer(APPLICATION.twitterConsumerKey, APPLICATION.twitterConsumerSecret)>

<cfset accessTokenObject = createObject("Java", "twitter4j.auth.AccessToken", "#APPLICATION.path#/app/WS/components/twitter4j-core-2.2.6-SNAPSHOT.jar")>
<cfset accessTokenObject.init(APPLICATION.twitterAccessToken, APPLICATION.twitterAccessTokenSecret)>

<cfset twitter.setOAuthAccessToken(accessTokenObject)>

<!--- Post a simple message to twitter--->
<!---<cfset twitter.updateStatus("Era7 Information Technologies: http://www.era7.com/")>--->

<!---Buscar si hay que cerrar la conexión o algo parecido--->

</body>
</html>
