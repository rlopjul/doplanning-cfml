<cfset app_version = "html2">
<cfset limit_to = 100>

<cfoutput>

<!--- Lists --->

<cfset listTypeId = 11>
<cfset listTypeName = "list">
<cfset listTypeNameEs = "Lista">
<cfset curUserId = SESSION.user_id>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAllAreasItems" returnvariable="getAllAreasListsResponse">
	<cfinvokeargument name="itemTypeId" value="#listTypeId#">
</cfinvoke>

<cfset listsQuery = getAllAreasListsResponse.query>
<cfset numItems = listsQuery.recordCount>

<!---<cfdump var="#listsQuery#">--->

<div class="row"><!--- lists container --->
	<div class="col-sm-12">

		<div class="panel panel-default">
		  
		  	<div class="panel-heading">

		  		<div class="row">

					<div class="col-xs-1 hidden-sm" style="vertical-align:middle;">

						<img src="#APPLICATION.htmlPath#/assets/v3/icons/list.png" alt="#listTypeNameEs#" title="#listTypeNameEs#"/> 

					</div>
					<div class="col-xs-11" style="vertical-align:middle;line-height:30px;">

						<cfif numItems GT 0>
						<span lang="es">Listas</span>&nbsp;<span class="label label-info">#numItems#</span>
						<cfelse>
						<span lang="es">No hay listas</span>
						</cfif>

					</div>

				</div>

			</div>

			<ul class="list-group">
				
				<cfloop query="listsQuery">

					<li onclick="openUrl('#listTypeName#_rows.cfm?#listTypeName#=#listsQuery.id#','areaIframe',event)" class="list-group-item" style="padding:5px;cursor:pointer"><!---area_items.cfm?area=#listsQuery.area_id#&#listTypeName#=#listsQuery.id#--->
						<div class="row">
							<!---<div class="col-xs-1" style="vertical-align:middle;">
								<img src="#APPLICATION.htmlPath#/assets/v3/icons/list.png" class="item_img" alt="Lista" title="Lista"/>
							</div>--->
							<div class="col-xs-12">
								#listsQuery.title#
							</div>
						</div>
					</li>

				</cfloop>

			</ul>

		</div>

	</div>
</div>

<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItemsList">
	<cfinvokeargument name="itemsQuery" value="#listsQuery#">
	<cfinvokeargument name="itemTypeId" value="#listTypeId#">
	<cfinvokeargument name="full_content" value="true">
	<cfinvokeargument name="app_version" value="html2">
</cfinvoke>--->


<!--- Tasks --->
<cfset taskTypeId = 6>
<cfset taskTypeName = "task">
<cfset curUserId = SESSION.user_id>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAllAreasItems" returnvariable="getAllAreasTasksResponse">
	<cfinvokeargument name="itemTypeId" value="#taskTypeId#">
	<cfinvokeargument name="recipient_user" value="#curUserId#">
	<cfinvokeargument name="done" value="false">
</cfinvoke>

<cfset tasksQuery = getAllAreasTasksResponse.query>
<cfset numItems = tasksQuery.recordCount>

<!---<cfdump var="#tasksQuery#">--->

<div class="row"><!--- tasks container --->
	<div class="col-sm-12">

		<div class="panel panel-default">

			<div class="panel-heading">

		  		<div class="row">

					<div class="col-xs-1 hidden-sm" style="vertical-align:middle;">

						<img src="#APPLICATION.htmlPath#/assets/v3/icons/task_not_done.png" alt="Tarea no realizada" title="Tarea no realizada" /> 

					</div>
					<div class="col-xs-11" style="vertical-align:middle;line-height:30px;">

						<cfif numItems GT 0>
						<span lang="es">Tareas pendientes</span>&nbsp;<span class="label label-info">#numItems#</span>
						<cfelse>
						<span lang="es">No tiene tareas pendientes</span>
						</cfif>

					</div>

				</div>

			</div>

			<ul class="list-group">

			<cfloop query="tasksQuery">

				<li onclick="openUrl('area_items.cfm?area=#tasksQuery.area_id#&#taskTypeName#=#tasksQuery.id#','areaIframe',event)" class="list-group-item" style="padding:5px;cursor:pointer">
					<div class="row">
						<div class="col-xs-1 hidden-sm" style="vertical-align:middle;">
							<!---<cfif tasksQuery.done IS true>
								<img src="#APPLICATION.htmlPath#/assets/v3/icons/task_done.png" alt="Tarea realizada" title="Tarea realizada" />
							<cfelse>
								<img src="#APPLICATION.htmlPath#/assets/v3/icons/task_not_done.png" alt="Tarea no realizada" title="Tarea no realizada" />
							</cfif>--->
							<cfif len(tasksQuery.user_image_type) GT 0>
								<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#tasksQuery.user_in_charge#&type=#tasksQuery.user_image_type#&small=" alt="#tasksQuery.user_full_name#" class="item_img"/>									
							<cfelse>							
								<img src="#APPLICATION.htmlPath#/assets/v3/icons/user_default.png" alt="#tasksQuery.user_full_name#" class="item_img_default" />
							</cfif>
						</div>
						<div class="col-xs-11">
							#tasksQuery.title# <!---<i>#tasksQuery.end_date#</i>--->

							<cfinvoke component="#APPLICATION.coreComponentsPath#/DateManager" method="createDateFromString" returnvariable="endDate">
								<cfinvokeargument name="strDate" value="#tasksQuery.end_date#">
							</cfinvoke>
							<cfset expiredCompare = dateCompare(now(), endDate, "d")>
							<cfif expiredCompare IS 0>
								<span class="label label-warning" lang="es">Caduca hoy</span>
							<cfelseif expiredCompare IS 1>
								<span class="label label-danger" lang="es">Caducada</span>
							</cfif>
						</div>
					</div>
				</li>
				
			</cfloop>
			</ul>

		</div>
		<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItemsList">
			<cfinvokeargument name="itemsQuery" value="#tasksQuery#">
			<cfinvokeargument name="itemTypeId" value="#taskTypeId#">
			<cfinvokeargument name="full_content" value="true">
			<cfinvokeargument name="app_version" value="html2">
		</cfinvoke>--->
	</div>
</div>





<!--- Events --->
<cfset eventTypeId = 5>
<cfset eventTypeName = "event">

<cfset to_end_date = dateFormat(now(), APPLICATION.dateFormat)>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAllAreasItems" returnvariable="getAllAreasListsResponse">
	<cfinvokeargument name="itemTypeId" value="#eventTypeId#">
	<cfinvokeargument name="limit" value="20">
	<cfinvokeargument name="to_end_date" value="#to_end_date#">
</cfinvoke>

<cfset eventsQuery = getAllAreasListsResponse.query>
<cfset numItems = eventsQuery.recordCount>

<!---<cfdump var="#eventsQuery#">--->


<div class="row"><!--- events container --->
	<div class="col-sm-12">

		<div class="panel panel-default">
		  
		  	<div class="panel-heading">

		  		<div class="row">

					<div class="col-xs-1 hidden-sm" style="vertical-align:middle;">

						<img src="#APPLICATION.htmlPath#/assets/v3/icons/event.png" alt="Evento" title="Evento"/> 

					</div>
					<div class="col-xs-11" style="vertical-align:middle;line-height:30px;">

						<cfif numItems GT 0>
						<span lang="es">Eventos próximos</span>&nbsp;<span class="label label-info">#numItems#</span>
						<cfelse>
						<span lang="es">No hay eventos próximos</span>
						</cfif>

					</div>

				</div>

			</div>

			<ul class="list-group">
				
				<cfloop query="eventsQuery">

					<li onclick="openUrl('area_items.cfm?area=#eventsQuery.area_id#&#eventTypeName#=#eventsQuery.id#','areaIframe',event)" class="list-group-item" style="padding:5px;cursor:pointer">
						<div class="row">
							<!---<div class="col-xs-1" style="vertical-align:middle;">
								<img src="#APPLICATION.htmlPath#/assets/v3/icons/list.png" class="item_img" alt="Lista" title="Lista"/>
							</div>--->
							<div class="col-xs-12">
								#eventsQuery.title# <!---<i>#eventsQuery.start_date#</i>--->

								<cfinvoke component="#APPLICATION.coreComponentsPath#/DateManager" method="createDateFromString" returnvariable="eventEndDate">
									<cfinvokeargument name="strDate" value="#eventsQuery.start_date#">
								</cfinvoke>
								<cfset expiredCompare = dateCompare(now(), eventEndDate, "d")>
								<cfif expiredCompare IS 0>
									<span class="label label-warning" lang="es">Hoy</span>
								</cfif>
							</div>
						</div>
					</li>

				</cfloop>

			</ul>

		</div>

	</div>
</div>


</cfoutput>