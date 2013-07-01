<!---Copyright Era7 Information Technologies 2007-2012

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 10-05-2012
	
	24-06-2013 alucena: cambiado para usar la variable jarPath con nueva ruta

--->
<cfcomponent output="false">
	
	<cfset component = "TwitterManager">
	
	<cfset jarPath = "libs/twitter4j-core-2.2.6-SNAPSHOT.jar">


	<!--- ----------------------- sendTweet -------------------------------- --->
	
	<cffunction name="sendTweet" returntype="void" output="false" access="public">		
		<cfargument name="content" type="string" required="yes">

		<cfset var method = "sendTweet">
		
		<!---<cfset twitter = createObject("Java", "twitter4j.TwitterFactory", "#APPLICATION.path#/app/WS/components/twitter4j-core-2.2.6-SNAPSHOT.jar").getInstance()>--->
		<cfset twitter = createObject("Java", "twitter4j.TwitterFactory", jarPath).getInstance()>
		<cfset twitter.setOAuthConsumer(APPLICATION.twitterConsumerKey, APPLICATION.twitterConsumerSecret)>
		
		<!---<cfset accessTokenObject = createObject("Java", "twitter4j.auth.AccessToken", "#APPLICATION.path#/app/WS/components/twitter4j-core-2.2.6-SNAPSHOT.jar")>--->
		<cfset accessTokenObject = createObject("Java", "twitter4j.auth.AccessToken", jarPath)>
		<cfset accessTokenObject.init(APPLICATION.twitterAccessToken, APPLICATION.twitterAccessTokenSecret)>
		
		<cfset twitter.setOAuthAccessToken(accessTokenObject)>
		
		<!--- Post a simple message to twitter--->
		<cfset twitter.updateStatus(arguments.content)>	
		
	</cffunction>
	
</cfcomponent>