component {
	property name="resourceLibraryService" inject="ResourceLibraryService";
	property name="resourceLibraryDao"     inject="presidecms:object:resource_library_external_link";

	public any function init(){
		return this;
	}

	public boolean function match( required string path, required any event ){
		return REFind( "^(\/|)resource-link\/.+", path )>0;
	}

	public void function translate( required string path, required any event ){
		var rc  = event.getCollection();
		var prc = event.getCollection( private=true );

		var resourceId = REReplace( path, "(^(\/|)resource-link\/)|(\/$)", "", "ALL" );
		
		if ( resourceLibraryService.canUserAccessResource( resourceId ) ) {
			var resourceLibraryQuery = resourceLibraryService.getResourceById( resourceId );
			
			if ( resourceLibraryQuery.resource_type=="resource_library_external_link" ) {
				resourceLibraryService.trackResourceVisit( resourceId );
				
				var selectFields = [ "href" ];
				var filter = { "id"=resourceLibraryQuery.resource_id };
				var externalLinkQuery = resourceLibraryDao.selectData( selectFields=selectFields, filter=filter );

				location( url=externalLinkQuery.href, addtoken=false );
			}
		}
	}

	public boolean function reverseMatch( required struct buildArgs, required any event ){
		return false;
	}

	public string function build( required struct buildArgs, required any event ){
		return false;
	}
}