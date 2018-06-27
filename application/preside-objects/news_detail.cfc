/**
 * @searchEnabled true
 * @versioned false
**/
component dataManagerGroup="news_detail"{
	property name="category"  relatedTo="category" relationship="many-to-one" searchEnabled=true searchSearchable=false;
	property name="label"     searchEnabled=true;
	property name="content"   dbtype="text";
	property name="news_slug" default="method:autoSlug";

	public string function autoSlug( required struct data ){
		var increment = 1;
		var newsSlug = LCase( REReplace( data.label, " ", "-", "ALL" ) );

		while ( this.dataExists( filter={ "news_slug"=newsSlug } ) ) {
			newsSlug = newsSlug & "-" & toString( ++increment );
		}

		return newsSlug;
	}

	public array function getDataForSearchEngine( string id="", numeric maxRows=100, numeric startRow=1 ){
		var selectFields = [
			  "news_detail.id"
			, "news_detail.label AS title"
			, "news_detail.datecreated"
			, "news_detail.datemodified"
			, "news_detail.category AS newsCategory"
		];
		var filter = {};

		if ( id.len() > 0 ) {
			filter[ "news_detail.id" ] = id;
		}

		var newsDetailQuery = this.selectData(
			  selectFields = selectFields
			, filter       = filter
			, startRow     = arguments.startRow
			, maxRows      = arguments.maxRows
		);
		var newsDetailArray = [];

		for ( var news in newsDetailQuery ) {
			newsDetailArray.append( {
				  id = news.id
				, title = news.title
				, dateCreated = dateTimeFormat( news.datecreated, "yyyy-mm-dd HH:nn" )
				, dateModified = dateTimeFormat( news.datemodified, "yyyy-mm-dd HH:nn" )
				, category = news.newsCategory
			} );
		}

		return newsDetailArray;
	}
}