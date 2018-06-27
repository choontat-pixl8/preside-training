component {
	/**
	 * @elasticSearchEngine.inject     ElasticSearchEngine
	 * @elasticSearchApiWrapper.inject ElasticSearchApiWrapper
	 * @resourceLibraryService.inject  ResourceLibraryService
	 * @websiteLoginService.inject     WebsiteLoginService
 	**/
	public function init(
		  required any elasticSearchEngine
		, required any elasticSearchApiWrapper
		, required any resourceLibraryService
		, required any websiteLoginService
	){
		_setElasticSerchEngine( elasticSearchEngine );
		_setElasticSearchApiWrapper( elasticSearchApiWrapper );
		_setResourceLibraryService( resourceLibraryService );
		_setWebsiteLoginService( websiteLoginService );

		return this;
	}

	public struct function search( string searchQuery="*", array resourceTypes=[], numeric page=1 ){
		var fieldList = "id,title,resource_type,resource_id,access_restricted";
		var dsl       = _getElasticSearchApiWrapper().generateSearchDsl( q=searchQuery, fieldList=fieldList );
		var filterArr = [];

		dsl.from   = ( ( page - 1 ) * 10 );
		dsl.size   = 10;
		dsl.filter = {
			bool = {
				  "must_not" = []
				, "must"     = [ { "type"={ "value"="resource_library_resource" } } ]
			}
		};

		if ( !_getWebsiteLoginService().isLoggedIn() ) {
			dsl.filter.bool.must.append( {
				"term" = {
					"access_restricted" = false
				}
			} );
		}

		_addAggregation( dsl );

		if ( !resourceTypes.isEmpty() ) {
			filterArr.append( {
				"terms" = {
					"resource_type"=resourceTypes
				}
			} );
		}

		if ( !filterArr.isEmpty() ) {
			dsl.filter.bool.must.append( { "or"=filterArr } );
		}

		var searchResultArray = [];
		var searchResult      = _getElasticSearchEngine().search(
			  fieldList = fieldList
			, q         = searchQuery
			, fullDsl   = dsl
			, sortOrder = "_score desc"
			, page      = page
		);

		for ( var result in searchResult.getResults() ) {
			searchResultArray.append( {
				  id         = result.id
				, resourceId = result.resource_id
				, type       = result.resource_type
				, restricted = result.access_restricted
			} );
		}

		var translatedAggregations = searchResult.getAggregations();

		_translateAggregation( translatedAggregations );

		return {
			  aggregations = translatedAggregations
			, result       = searchResultArray
		};
	}

	private void function _translateAggregation( required struct aggregations ){
		_translateResourceTypes( aggregations );

		aggregations.total    = aggregations.total.doc_count;
		aggregations.pageSize = 10;
	}

	private void function _translateResourceTypes( required struct aggregations ){
		var translatedResourceTypes = [];

		for ( var resourceType in aggregations.resourceTypes.types.buckets ) {
			var translatedResourceType = {
				  recordCount = resourceType.doc_count
				, name        = resourceType.key
			};

			translatedResourceTypes.append( translatedResourceType );
		}

		aggregations.resourceTypes = translatedResourceTypes;
	}

	private void function _addAggregation( required struct dsl ){
		dsl.aggs = {
			  resourceTypes={
				  filter = duplicate( dsl.filter?:{} )
				, aggs   = {
					types = {
						"terms"={ field="resource_type" }
					}
				}
			}
			, total={ filter=dsl.filter?:{} }
		};
	}

	private void function _setElasticSerchEngine( required any elasticSearchEngine ){
		variables._elasticSearchEngine = elasticSearchEngine;
	}

	private any function _getElasticSearchEngine(){
		return variables._elasticSearchEngine;
	}

	private void function _setElasticSearchApiWrapper( required any elasticSearchApiWrapper ){
		variables._elasticSearchApiWrapper = elasticSearchApiWrapper;
	}

	private any function _getElasticSearchApiWrapper(){
		return variables._elasticSearchApiWrapper;
	}

	private void function _setResourceLibraryService( required any resourceLibraryService ){
		variables._resourceLibraryService = resourceLibraryService;
	}

	private any function _getResourceLibraryService(){
		return variables._resourceLibraryService;
	}

	private void function _setWebsiteLoginService( required any websiteLoginService ){
		variables._websiteLoginService = websiteLoginService;
	}

	private any function _getWebsiteLoginService(){
		return variables._websiteLoginService;
	}
		
}