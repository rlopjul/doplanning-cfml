<!---
<nav class="navbar-default navbar-fixed-top">
	
	<cfoutput>
	<div class="container" style="height:63px">

		<div class="row">

			<div class="col-xs-12">

				<div style="height:10px;"></div>

			</div>

		</div>
    
	  	<div class="row">

			<div class="col-md-9 hidden-xs hidden-sm">

				<span style="font-size:25px; color:##387496; font-weight:100;">#SESSION.client_app_title#</span>

			</div>

			<div class="col-sm-8 visible-sm-block">

				<span style="font-size:16px; color:##387496; font-weight:100;">#SESSION.client_app_title#</span>

			</div>

			<div class="col-xs-8 visible-xs-block">

				<span style="font-size:12px; color:##387496; font-weight:100;">#SESSION.client_app_title#</span>

			</div>

		 	<div class="col-xs-4 col-md-3">

		   		<img src="#APPLICATION.htmlPath#/login/download_login_image.cfm?abb=#SESSION.client_abb#" class="img-responsive center-block" />

		  	</div>

		</div>

	</div>
	

	<div class="container-fluid">

		<div class="row">

			<div class="col-sm-12">
				<cfif find("area_items.cfm", CGI.SCRIPT_NAME) GT 0>
					
					<!---<cfif NOT isDefined("area_type") OR area_type EQ "">--->
						<cfset bar_bg = "##019ED3">
					<!---<cfelse>
						<cfset bar_bg = "##DDDDDD">
					</cfif>--->

				<cfelseif find("search", CGI.SCRIPT_NAME) GT 0>
					<cfset bar_bg = "##4FBFB7">
				<cfelse>
					<cfset bar_bg = "##DDDDDD">
				</cfif>
				 <div style="background-color:#bar_bg#;height:17px;position:absolute;width:100%;left:0;"></div>
			</div>

		</div>

  	</div>

  	</cfoutput>
</nav>
--->