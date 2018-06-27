component {
	property name="newsService" inject="newsService";

	public any function init(){
		return this;
	}

	public boolean function match( required string path, required any event ){
		return REFindNoCase( "^\/news\/(.+\.html|)", arguments.path );
	}

	public void function translate( required string path, required any event ){
		var rc  = event.getCollection();
		var prc = event.getCollection( private=true );

		var newsSlug = _getNewsSlug( path );

		prc.newsSlug = newsSlug;

		rc.event = "page-types.news_listing.detail";
	}

	public boolean function reverseMatch( required struct buildArgs, required any event ){
		var newsSlug = newsService.getNewsSlugById( buildArgs.page?:"" );

		if ( !isEmpty( newsSlug ) ) {
			buildArgs.linkTo = "news/#newsSlug#";
			return true;
		}

		return REFind( "^(\/|)news\/", buildArgs.linkTo?:"" ) == 1;
	}

	public string function build( required struct buildArgs, required any event ){
		var htmlExtensionAppended = REFind( "\.html$", buildArgs.linkTo?:"" );

		return ( buildArgs.linkTo?:"" ) & ( htmlExtensionAppended > 0?"":".html" );
	}

	private string function _getNewsSlug( required string slug ){
		var newsSlug = REReplace( slug, "^\/|(news\/)|(\.html$)", "", "ALL" );

		return newsSlug;
	}
}