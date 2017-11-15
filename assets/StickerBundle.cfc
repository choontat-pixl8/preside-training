/**
 * Sticker bundle configuration file. See: http://sticker.readthedocs.org/
 */
component {

	public void function configure( bundle ) {

		bundle.addAssets(
			  directory   = "/"
			, match       = function( filepath ){ return ReFindNoCase( "\.(js|css)$", filepath ); }
			, idGenerator = function( filepath ){
				var fileName = ListLast( filePath, "/" );
				var id       = ListLast( filename, "." ) & "-" & ReReplace( filename, "\.(js|css)$", "" );
				return id;
			  }
		);

		bundle.addAsset( id="js-validator", path="/js/core/jquery.validate.js" );

		bundle.asset( "css-bootstrap" ).before( "*" );
		bundle.asset( "js-bootstrap" ).dependsOn( "js-jquery" );
	}

}