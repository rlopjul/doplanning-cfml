<cfset clientAbb = "software7">
<cfset rootAreaId = 232>
<cfset areaTypeRequired = "web"> 

<cfset clientDsn = APPLICATION.identifier&"_"&clientAbb>

<cfset webDirectory = "web">

<cfset export = false>

<!---getSubAreas--->
<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreas" returnvariable="menuAreasQuery">
	<cfinvokeargument name="area_id" value="#rootAreaId#">
	<cfinvokeargument name="remove_order" value="true">
					
	<cfinvokeargument name="client_abb" value="#clientAbb#">
	<cfinvokeargument name="client_dsn" value="#clientDsn#">
</cfinvoke>

<cfset menuSubAreasQueries = structNew()>
<cfset menuSubSubAreasQueries = structNew()>

<cfoutput>

<cfhttp method="get" resolveurl="yes"
		url="#APPLICATION.mainUrl#/#webDirectory#/index.cfm"
		file="index.html"
		path="#ExpandPath('#APPLICATION.path#/generated')#" result="pageContent"></cfhttp>
	
<cfdump var="#pageContent#">


<cfloop query="menuAreasQuery">
	
	<cfhttp method="get" resolveurl="yes"
		url="#APPLICATION.mainUrl#/#webDirectory#/page.cfm?id=#menuAreasQuery.id#"
		file="#menuAreasQuery.id#.html"
		path="#ExpandPath('#APPLICATION.path#/generated')#" result="pageContent"></cfhttp>
	
	<cfdump var="#pageContent#">
	
	
	<li><a href="#APPLICATION.path#/#webDirectory#/page.cfm?id=#menuAreasQuery.id#">#menuAreasQuery.name#</a>	
	
	
	<!---getSubAreas--->
	<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreas" returnvariable="menuSubAreasQuery">
		<cfinvokeargument name="area_id" value="#menuAreasQuery.id#">
		<cfinvokeargument name="remove_order" value="true">
						
		<cfinvokeargument name="client_abb" value="#clientAbb#">
		<cfinvokeargument name="client_dsn" value="#clientDsn#">
	</cfinvoke>
	
	<cfset menuSubAreasQueries[menuAreasQuery.id] = menuSubAreasQuery>
	
	
	<cfset subAreasQuery = menuSubAreasQueries[menuAreasQuery.id]>
	
		<cfif subAreasQuery.recordCount GT 0>
		
			<ul>
			<cfloop query="subAreasQuery">
			
				<li><a href="#APPLICATION.path#/#webDirectory#/page.cfm?id=#subAreasQuery.id#">#subAreasQuery.name#</a>				
					
					<!---getSubSubAreas--->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreas" returnvariable="menuSubSubAreasQuery">
						<cfinvokeargument name="area_id" value="#menuSubAreasQuery.id#">
						<cfinvokeargument name="remove_order" value="true">
										
						<cfinvokeargument name="client_abb" value="#clientAbb#">
						<cfinvokeargument name="client_dsn" value="#clientDsn#">
					</cfinvoke>
					
					<cfset menuSubSubAreasQueries[menuSubAreasQuery.id] = menuSubSubAreasQuery>
				
					<cfset subSubAreasQuery = menuSubSubAreasQueries[subAreasQuery.id]>
					<cfif subSubAreasQuery.recordCount GT 0>
						<ul>
						<cfloop query="subSubAreasQuery"><!---SUBSUBAPARTADOS--->
							<li><a href="#APPLICATION.path#/#webDirectory#/page.cfm?id=#subSubAreasQuery.id#">#subSubAreasQuery.name#</a></li>
						</cfloop>
						</ul>
					</cfif>

				</li>
			</cfloop>
			</ul>
									
		</cfif>
	</li>
</cfloop>

</cfoutput>