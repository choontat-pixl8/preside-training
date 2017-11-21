component {
	property name="newsService" inject="NewsService";
	property name="siteTreeService" inject="SiteTreeService";

	private function index( event, rc, prc, args={} ){
		args.newsList = newsService.getNewsList();

		var newsListCount   = newsService.getNewsListCount();
		var loadedNewsCount = args.newsList.recordCount?:0;

		event
			.include( "js-load-news" )
			.includeData( {
				  "loadNewsURL"     = event.buildLink( linkTo="page-types.news_listing.loadNewsAsJson" )
				, "loadedNewsCount" = args.newsList.recordCount ?: 0 
				, "newsListCount"   = newsListCount
			} );

		args.allNewsLoaded = loadedNewsCount >= newsListCount;

		return renderView( view="page-types/news_listing/index", args=args );
	}

	public function detail( event, rc, prc, args={} ){
		args.newsDetail = newsService.getNewsDetailByNewsSlug( prc.newsSlug?:"" );

		event.initializeDummyPresideSiteTreePage(
			  title      = args.newsDetail.title ?: "News Not Found"
			, parentPage = siteTreeService.getPage( systemPage="news_listing" )
		);

		event.setView( view="page-types/news/detail", args=args );
	}

	public function loadNewsAsJson( event, rc, prc, args={} ){
		var startRow  = val ( rc.startFrom?:"" );
		var newsQuery = newsService.getNewsListByRecordNumber( from=startFrom );
		var newsArray = [];

		newsQuery.each( function( news ){
			var newsStruct = {};

			newsStruct[ "newsURL" ] = event.buildLink( linkTo="news/#news.news_slug#" );
			newsStruct[ "title"   ] = news.title;

			newsArray.append( newsStruct );
		} );

		return serializeJSON( newsArray );
	}
}