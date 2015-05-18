<cfif rightContent IS true>
<div class="container-fluid" id="homeContent">
</cfif>

	<div class="row">

		<cfif rightContent IS true>
			<div class="col-sm-8">
		<cfelse>
			<div class="col-sm-12">
		</cfif>

			<cfinclude template="#APPLICATION.htmlPath#/includes/last_areas_items.cfm">

		</div>

		<cfif rightContent IS true>

			<div class="col-sm-4" id="homeRightContainer">

				<cfinclude template="#APPLICATION.htmlPath#/includes/home_right_content.cfm">

			</div>
			
		</cfif>
		

	</div>

<cfif rightContent IS true>
</div>
</cfif>