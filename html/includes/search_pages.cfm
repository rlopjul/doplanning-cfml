<cfif pages GT 0>
	<cfoutput>
	<div class="div_search_pages">
	Páginas: 
	<cfif page GT 1>
	<a href="#current_url#&page=#page-1#" class="a_search_pages">&lt;</a>
	<cfelse>
	&nbsp;
	</cfif>
	&nbsp;	
	<cfloop index="pg" from="1" to="#pages#">
		<cfif pg NEQ page>
			<a href="#current_url#&page=#pg#" class="a_search_pages">#pg#</a>
		<cfelse>
			<span class="search_pages_current">#pg#</span>
		</cfif>
	</cfloop>
	&nbsp;
	<cfif page LT pages>
	<a href="#current_url#&page=#page+1#" class="a_search_pages">&gt;</a>
	<cfelse>
	&nbsp;
	</cfif>
	</div>
	</cfoutput>
<cfelse>
	<div style="height:8px;"></div>
</cfif>