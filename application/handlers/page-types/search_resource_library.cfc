component {
	property name="resourceSearchEngine" inject="ResourceLibrarySearchEngine";

	private function index( event, rc, prc, args={} ){
		_appendSearchResult( argumentCollection=arguments );

		event.include( "css-search" );
		event.include( "js-search" );

		event.includeData( {
			  "loadMoreURL" = event.buildLink( linkTo="page-types.search_resource_library.loadMore" )
			, "totalResult" = args.searchResult.aggregations.total?:0
			, "pageSize"    = 10
		} );

		return renderView(
			  view="page-types/search/resource_lib/index"
			, args=args
		);
	}

	private function _load_search_results( event, rc, prc, args={} ){
		if ( !structKeyExists( args, "searchResult" ) ) {
			_appendSearchResult( argumentCollection=arguments );
		}

		return renderView(
			  view="page-types/search/resource_lib/_search_results"
			, args=args
		);
	}

	public function loadMore( event, rc, prc, args={} ){
		return _load_search_results( argumentCollection=arguments );
	}

	private function _appendSearchResult( event, rc, prc, args={} ){
		var currentPage   = val( rc.currentPage?:"" ) + 1;
		var searchQuery   = trim( rc.query?:"*" );
		    searchQuery   = searchQuery.len() > 0 ? searchQuery : "*";
		var resourceTypes = listToArray( rc.resourceTypes?:"" );

		args.searchResult   = resourceSearchEngine.search(
			  searchQuery   = searchQuery
			, resourceTypes = resourceTypes
			, page          = currentPage
		);
		args.selectedResourceTypes = resourceTypes;
		args.currentPage           = currentPage;
	}
}