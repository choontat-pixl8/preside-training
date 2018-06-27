<cfscript>
	result             = args.searchResult.result       ?:  [];
	aggregations       = args.searchResult.aggregations ?:  [];
	categories         = aggregations.categories        ?:  [];
	resources          = aggregations.resources         ?:  [];
	selectedCategories = args.selectedCategories        ?:  [];
	hasMoreResult      = aggregations.total             GTE aggregations.pageSize;
</cfscript>
<h2>Search Result</h2>
<cfoutput>
	#renderView( view="page-types/search/_search_field", args=args )#

	<h3>Filter By Category</h3>
	<form action="#event.buildLink()#" method="POST">
		<input type="hidden" name="query" value="#encodeForHTMLAttribute( rc.query?:"" )#" />

		<cfif categories.len() GT 1>
			<cfloop array="#categories#" item="category">
				<input
					type  = "checkbox"
					id    = "#category.id#"
					class = "filter"
					name  = "categories"
					value = "#category.id#"
					#selectedCategories.find( category.id ) GT 0 ?"checked":""#/>

				<label for="#category.id#">#category.name# ( #category.recordCount# )</label>
				<br/>
			</cfloop>
		</cfif>

		<cfif resources.recordCount GT 0>
			<input
				type  = "checkbox"
				id    = "filterResources"
				class = "filter"
				name  = "resources"
				value = "true"
				#( rc.resources?:"" ) EQ "true" ?"checked":""#/>
				
			<label for="filterResources">Resources ( #resources.recordCount# )</label>
		</cfif>
	</form>

	<input type="hidden" name="categories" value="#encodeForHTMLAttribute( rc.categories?:"" )#" />

	<table class="table table-striped" id="searchResultTable">
		<thead>
			<tr>
				<th>No.</th>
				<th>Title</th>
				<th>Category</th>
			</tr>
		</thead>
		<tbody>
			#renderViewlet( event="page-types.search._load_search_results", args=args )#
		</tbody>
	</table>

	<cfif hasMoreResult>
		<div class="text-center">
			<button class="btn btn-info" id="loadMore">Load More</button>
		</div>
	</cfif>
</cfoutput>