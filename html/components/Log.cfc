<!---Copyright Era7 Information Technologies 2007-2013

	Date of file creation: 08-07-2009
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	
--->
<cfcomponent output="true">

	<cfset component = "Log">
	<cfset request_component = "LogManager">
	
	
	<cffunction name="getLogs" returntype="xml" access="public" output="true">
		<cfargument name="date_from" type="string" required="true">
		<cfargument name="date_to" type="string" required="true">
		<cfargument name="action_id" type="string" required="true">
		<cfargument name="page" type="numeric" required="no" default="1">
		<cfargument name="items_page" type="numeric" required="no" default="1000000">
		
		<cfset var method = "getLogs">
		
		<cfset var request_parameters = "">
		
		<cftry>		
			
			<cfset request_parameters = '<logs page="#arguments.page#" items_page="#arguments.items_page#"'>
			<cfif len(arguments.date_from) GT 0>
				<cfset request_parameters = request_parameters&' date_from="#arguments.date_from#"'>
			</cfif>
			<cfif len(arguments.date_to) GT 0>
				<cfset request_parameters = request_parameters&' date_to="#arguments.date_to#"'>
			</cfif>
			<cfif len(arguments.action_id) GT 0>
				<cfset request_parameters = request_parameters&' action_id="#arguments.action_id#"'>
			</cfif>
			<cfset request_parameters = request_parameters&'>'>
			<cfset request_parameters = request_parameters&'</logs>'>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	
	<cffunction name="outputLogsList" returntype="void" output="true" access="public">
		<cfargument name="logs" type="query" required="true">
		<cfargument name="full_content" type="boolean" required="no" default="false">
		<cfargument name="return_page" type="string" required="no">
		<cfargument name="app_version" type="string" required="true">
		
		<cfset var method = "outputItemsList">

		<cftry>
			
			<!--- <cfset logs = arguments.logs> --->
			
			<cfset numLogs = arguments.logs.RecordCount>
			
			<cfif numLogs GT 0>
			
				<script type="text/javascript">
					$(document).ready(function() { 
						
						$("##listTable").tablesorter({ 
							<cfif arguments.full_content IS false>
							widgets: ['zebra','uitheme','select','filter','stickyHeaders'],
							<cfelse>
							widgets: ['zebra','uitheme','select','stickyHeaders'],
							</cfif>
							
							theme : "bootstrap",
							headerTemplate : '{content} {icon}',<!---new in v2.7. Needed to add the bootstrap icon!--->

							sortList: [[2,1]] ,

							headers: { 

								2: { 
									sorter: "datetime" 
								}
		
							}
							<cfif arguments.full_content IS false>
							, widgetOptions : {
								filter_childRows : false,
								filter_columnFilters : true,
								filter_cssFilter : 'tablesorter-filter',
								filter_filteredRow   : 'filtered',
								filter_formatter : null,
								filter_functions : null,
								filter_hideFilters : false,
								filter_ignoreCase : true,
								filter_liveSearch : true,
								//filter_reset : 'button.reset',
								filter_searchDelay : 300,
								filter_serversideFiltering: false,
								filter_startsWith : false,
								filter_useParsedData : false,
						    }
						   </cfif>
						});
						
						//  Adds "over" class to rows on mouseover
						$("##listTable tr").mouseover(function(){
						  $(this).addClass("over");
						});
					
						//  Removes "over" class from rows on mouseout
						$("##listTable tr").mouseout(function(){
						  $(this).removeClass("over");
						});
						
					}); 
				</script>
				
				<cfset alreadySelected = false>
				
		
				<cfif isDefined("arguments.return_page")>
					<cfset rpage = arguments.return_page>
				<cfelse>
					<cfset rpage = "">
				</cfif>	
				
				
				<cfoutput>
				
				<table id="listTable" class="tablesorter">
					<thead>
						<tr>
							<th style="width:40px" class="filter-false"></th>
							<th><span lang="es">De</span></th>
							<th><span lang="es">Fecha</span></th>	
							<th><span lang="es">Acción</span></th>		
						</tr>
					</thead>
					
					<tbody>
					
					<cfloop query="logs">
					
					<!---<cfset item_page_url = "log.cfm?log=#logs.id#&return_page=#URLEncodedFormat(rpage)#">--->
						<cfset item_page_url = "log_item.cfm?log=#logs.id#">

						<!---Item selection--->
						<cfset itemSelected = false>
						
						<cfif alreadySelected IS false>
						
							<!---Esta acción solo se completa si está en la versión HTML2--->
							<script type="text/javascript">
								openUrlHtml2('#item_page_url#','logItemIframe');
							</script>
							<cfset itemSelected = true>
								
							
							<cfif itemSelected IS true>
								<cfset alreadySelected = true>
							</cfif>
							
						</cfif>

						<tr <cfif itemSelected IS true>class="selected"</cfif> onclick="openUrl('#item_page_url#','logItemIframe',event)">

							<td style="text-align:center">								
								#logs.id#
							</td>		
							<td><span>#logs.name#</span></td>
							<td><span>#DateFormat(logs.time, APPLICATION.dateFormat)# #TimeFormat(logs.time, "HH:mm:ss")#</span></td>					
							<td><span>#logs.method#</span></td>
						</tr>
					
					</cfloop>
					
					</tbody>
					</table>
				</cfoutput>
			</cfif>
								
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	
	
	<cffunction name="outputLogItem" returntype="void" output="true" access="public">
		<cfargument name="log" type="query" required="true">
		
		<cfset var method = "outputLogItem">
		
		<cfset var user_page = "">
		
		<cftry>
			
			<cfoutput>
			<div class="div_log_page_title">			
			<span lang="es">Detalles del log</span>
			</div>
			<div class="div_separator"><!-- --></div>
			
		
			<div class="div_user_page_title">
				<cfif len(log.image_type) GT 0>
					<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#log.user_id#&type=#log.image_type#&medium=" alt="#log.name#" class="item_img" style="margin-right:2px;"/>	
				<cfelse>							
					<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#log.name#" class="item_img_default" style="margin-right:2px;"/>
				</cfif><br/>
				<span lang="es" class="div_log_page_label">Usuario</span>
			</div>
			
			<div class="div_separator"><!-- --></div>

			<div class="div_user_page_user">
				<div class="div_log_page_label"><span lang="es">Nombre</span>: <span class="div_log_page_text">#log.name#</span></div>
				<div class="div_log_page_label"><span lang="es">Email</span>: <span class="div_log_page_text">#log.email#</span></div>	
				<div style="clear:both;">&nbsp;</div>	
			</div>			
	
			<div class="div_log_page_log">
				<div class="div_log_page_label"><span lang="es">Log ID:</span> <span class="div_log_page_text">#log.log_id#</span></div>
				<div class="div_log_page_label"><span lang="es">Acción</span>: <span class="div_log_page_text">#log.method#</span></div>
				<div class="div_log_page_label"><span lang="es">Componente:</span> <span class="div_log_page_text">#log.component#</span></div>
				<div class="div_log_page_label"><span lang="es">Fecha:</span> <span class="div_log_page_text">#DateFormat(log.time, APPLICATION.dateFormat)# #TimeFormat(log.time, "HH:mm:ss")#</span></div>
				<div class="div_log_page_label">
					<span lang="es">Petición:</span>
				</div> 
				<!---<cfif IsXML(log.request_content)>
					<cfdump var="#xmlParse(log.request_content)#">
				<cfelse>--->
					<!---<textarea readonly="readonly" class="form-control" style="height:350px">#log.request_content#</textarea>--->
				<!---</cfif>--->
			</div>
			<div style="clear:both;">
				<pre>#log.request_content#</pre>
			</div>
			
			
			</cfoutput>								
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
</cfcomponent>