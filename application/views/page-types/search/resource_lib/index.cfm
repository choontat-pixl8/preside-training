<cfscript>
	result                = args.searchResult.result       ?:  [];
	aggregations          = args.searchResult.aggregations ?:  [];
	resourceTypes         = aggregations.resourceTypes     ?:  [];
	selectedResourceTypes = args.selectedResourceTypes     ?:  [];
	hasMoreResult         = aggregations.total             GTE aggregations.pageSize;
</cfscript>
<h2>Resource Library Search Result</h2>
<cfoutput>
	#renderView( view="page-types/search/resource_lib/_search_field", args=args )#

	<h3>Filter By Resource Type</h3>
	<form action="#event.buildLink()#" method="POST">
		<input type="hidden" name="query" value="#encodeForHTMLAttribute( rc.query?:"" )#" />

		<cfif resourceTypes.len() GT 1>
			<cfloop array="#resourceTypes#" item="resourceType" index="i">
				<input
					type  = "checkbox"
					id    = "resource#i#"
					class = "filter"
					name  = "resourceTypes"
					value = "#resourceType.name#"
					#selectedResourceTypes.find( resourceType.name ) GT 0 ?"checked":""#/>

				<label for="resource#i#">#resourceType.name# ( #resourceType.recordCount# )</label>
				<br/>
			</cfloop>
		</cfif>
	</form>

	<input type="hidden" name="resourceTypes" value="#encodeForHTMLAttribute( rc.resourceTypes?:"" )#" />

	<table class="table table-striped" id="searchResultTable">
		<thead>
			<tr>
				<th>No.</th>
				<th>Title</th>
				<th>Resource Type</th>
			</tr>
		</thead>
		<tbody>
			#renderViewlet( event="page-types.search_resource_library._load_search_results", args=args )#
		</tbody>
	</table>

	<cfif hasMoreResult>
		<div class="text-center">
			<button class="btn btn-info" id="loadMore">Load More</button>
		</div>
	</cfif>
</cfoutput>