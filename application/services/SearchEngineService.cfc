component {
	/**
	 * @elasticSearchEngine.inject     ElasticSearchEngine
	 * @elasticSearchApiWrapper.inject ElasticSearchApiWrapper
	 * @category.inject                presidecms:object:category
	**/
	public function init( required any elasticSearchEngine, required any elasticSearchApiWrapper, required any category ){
		_setElasticSerchEngine( elasticSearchEngine );
		_setElasticSearchApiWrapper( elasticSearchApiWrapper );
		_setCategory( category );

		return this;
	}

	public struct function search( string searchQuery="*", array categories=[], numeric page=1, boolean filterResources=false ){
		var fieldList = "id,title,category";
		var dsl       = _getElasticSearchApiWrapper().generateSearchDsl( q=searchQuery, fieldList=fieldList );
		var filterArr = [];

		dsl.filter = {
			bool = {
				"must_not" = [ 
					{ "type"={ "value"="event_listing" } } 
				]
				, "must"   = []
			}
		};
		dsl.from   = ( ( page - 1 ) * 10 );
		dsl.size   = 10;

		_addAggregation( dsl );

		if ( !categories.isEmpty() ) {
			filterArr.append( {
				"terms" = {
					"category"=categories
				}
			} );
		}

		if ( filterResources ) {
			filterArr.append( {
				"type" = {
					"value"="resource_library_resource"
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
			var categoryQuery = _getCategory().findById( selectFields=[ "category.label" ], categoryId=result.category );
			
			result.category = categoryQuery.label;

			searchResultArray.append( result );
		}

		var translatedAggregations = searchResult.getAggregations();

		_translateAggregation( translatedAggregations );

		return {
			  aggregations = translatedAggregations
			, result       = searchResultArray
		};
	}

	private void function _translateAggregation( required struct aggregations ){
		_translateCategory(  aggregations );
		_translateResources( aggregations );

		aggregations.total    = aggregations.total.doc_count;
		aggregations.pageSize = 10;
	}

	private void function _translateResources( required struct aggregations ){
		aggregations.resources.recordCount = aggregations.resources.doc_count;

		structDelete( aggregations.resources, "doc_count" );
	}

	private void function _translateCategory( required struct aggregations ){
		var translatedCategories = [];
		
		for ( var category in aggregations.categories.buckets ) {
			var categoryQuery      = _getCategory().findById( selectFields=[ "category.label" ], categoryId=category.key );
			var translatedCategory = {
				  recordCount = category.doc_count
				, name        = categoryQuery.label
				, id          = category.key
			};
			translatedCategories.append( translatedCategory );
		}

		aggregations.categories = translatedCategories;
	}

	private void function _addAggregation( required struct dsl ){
		dsl.aggs = {
			  categories={ "terms"={ field="category" } }
			, resources = {
				filter = {
					"and" = [
						{ "type"={ "value"="resource_library_resource" } }
					]
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

	private void function _setCategory( required any category ){
		variables._category = category;
	}

	private any function _getCategory(){
		return variables._category;
	}
}