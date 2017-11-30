component {
	/**
	 * @newsDetail.inject presidecms:object:news_detail
	 */
	public any function init( required any newsDetail ){
		_setNewsDetail( newsDetail );

		return this;
	}

	public query function getNewsList(){
		var selectFields = [ "news_detail.news_slug", "label as title" ];

		return _getNewsDetail().selectData(
			  selectFields = selectFields
			, orderBy      = "news_detail.datecreated ASC"
			, maxRows      =  2
		);
	}

	public numeric function getNewsListCount(){
		var selectFields = [ "COUNT( id ) AS newsListCount" ];

		return _getNewsDetail().selectData(
			selectFields = selectFields
		).newsListCount;
	}

	public query function getNewsListByRecordNumber( required numeric from, numeric limit=1 ){
		var selectFields = [ "news_detail.news_slug", "label AS title" ];

		return _getNewsDetail().selectData(
			  selectFields = selectFields
			, orderBy      = "news_detail.datecreated ASC"
			, startRow     = from
			, maxRows      = limit
		);
	}

	public struct function getNewsDetailByNewsSlug( required string newsSlug ){
		var selectFields = [ "label AS title", "news_detail.content", "news_detail.datemodified" ];

		var newsDetailQuery = _getNewsDetail().selectData(
			  selectFields = selectFields
			, filter       = { "news_detail.news_slug"=arguments.newsSlug }
		);

		if ( newsDetailQuery.recordCount > 0){
			return queryGetRow( newsDetailQuery, 1 );
		}

		return {};
	}

	private void function _setNewsDetail( required any newsDetail ){
		variables._newsDetail = arguments.newsDetail;
	}

	private any function _getNewsDetail(){
		return variables._newsDetail;
	}
}