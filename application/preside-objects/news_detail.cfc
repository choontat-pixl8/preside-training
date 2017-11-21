component dataManagerGroup="news_detail"{
	property name="content" dbtype="text";
	property name="news_slug" default="method:autoSlug";

	public string function autoSlug( required struct data ){
		var increment = 1;
		var newsSlug = LCase( REReplace( data.label, " ", "-", "ALL" ) );

		while ( this.dataExists( filter={ "news_slug"=newsSlug } ) ) {
			newsSlug = newsSlug & "-" & toString( ++increment );
		}

		return newsSlug;
	}
}