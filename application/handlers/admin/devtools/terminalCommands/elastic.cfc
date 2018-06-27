component hint="Elastic Search command" {

	property name="jsonRpc2Plugin"            inject="coldbox:myPlugin:JsonRpc2";
	property name="elasticSearchEngine"       inject="elasticSearchEngine";
	property name="elasticSearchConfigReader" inject="elasticSearchPresideObjectConfigurationReader";

	private any function index( event, rc, prc ) {
		var cliArgs = _getCliArgs();

		switch ( cliArgs[1]?:"" ) {
			case "list"   :
			case "rebuild":
			case "status" :
			case "stop"   :
				var event = "admin.devtools.terminalCommands.elastic.#cliArgs[ 1 ]#";

				return runEvent( event=event, private=true, prePostExempt=true );

			default       : break;
		}

		var message = "
			Usage: elastic [command]#chr( 10 )#Available [command]s:

				list             : List all available indexes
				rebuild [index|] : Rebuild search index for given index name.
				                   Rebuild all if index name is not provided.
				stop    [index]  : Stops the rebuild process for given index name.
				status  [index|] : Get status for given index name. 
				                   Get status for all index if index name is not provided.
		";

		return _renderMessage( message );
	}

	private any function list(){
		var indexes = elasticSearchConfigReader.listIndexes();
		var message = "
			Number of index: #indexes.len()#
		";

		for ( var index in indexes ) {
			message &= "[[b;white;]#index#]#chr( 10 )#";
		}

		return _renderMessage( message );
	}

	private any function rebuild( event, rc, prc ){
		var cliArgs = _getCliArgs();
		var message = "";

		if ( cliArgs.len() GTE 2 ) {
			var indexName = cliArgs[ 2 ];

			if ( !_indexExists( indexName ) ) {
				return _renderMessage( "[[;red;]Index ""#indexName#"" not found.]" );
			}
			var success = "";

			thread name="rebuildElasticSearchIndex" action="run" indexName="#indexName#" {
				elasticSearchEngine.rebuildIndex( ATTRIBUTES.indexName );
			}

			message = "Rebuilding index [[b;white;]#indexName#]. Use [[b;white;]elastic status #indexName#] command to check the build status.";
		} else {
			thread name="rebuildElasticSearchIndexes" action="run" {
				elasticSearchEngine.rebuildIndexes();
			}

			message = "Rebuilding all indexes. Use [[b;white;]elastic status] command to check the build status.";
		}

		return _renderMessage( message );
	}

	private any function status( event, rc, prc ){
		var cliArgs = _getCliArgs();
		var status  = elasticSearchEngine.getStats();
		var message = "";

		if ( cliArgs.len() GTE 2 ) {
			var givenIndexName = cliArgs[ 2 ];

			if ( structIsEmpty( status[ givenIndexName ]?:{} ) ) {
				return _renderMessage( "[[;red;]Index ""#givenIndexName#"" not found.]" );
			}

			var originalIndexName = "";

			for ( var indexName in status ) {
				if ( indexname==givenIndexName ) {
					originalIndexName = indexName;
					break;
				}
			}

			status = { "#originalIndexName#"=status[ givenIndexName ] };
			message = "ElasticSearch status for index [[b;white;]#indexName#]#chr( 10 )#";
		} else {
			message = "ElasticSearch status for all index:#chr( 10 )##chr( 10 )#";
		}

		for ( var indexName in status ) {
			var indexStatus    = status[ indexName ];
			var indexing       = indexStatus.is_indexing?"Yes":"No";
			var success        = indexStatus.last_indexing_success?"Yes":"No";
			var startDatetime  = dateTimeFormat( indexStatus.indexing_started_at, "yyyy-mm-dd HH:nn:ss" );
			var endDatetime    = dateTimeFormat( indexStatus.last_indexing_completed_at, "yyyy-mm-dd HH:nn:ss" );
			var durationInMs   = "#indexStatus.last_indexing_timetaken?:0# ms";
			var record         = indexStatus.totalDocs;
			var expiryDatetime = dateTimeFormat( indexStatus.indexing_expiry, "yyyy-mm-dd HH:nn:ss" );
			var messageColour  = indexStatus.is_indexing?"yellow":indexStatus.last_indexing_success?"lime":"red";

			message &= "[[b;#messageColour#;][ #indexName# \]]
				Indexing : #indexing#
				Success  : #indexing?"-":success#
				Start    : #startDatetime#
				End      : #indexing?"-":endDatetime#
				Duration : #indexing?"-":durationInMs#
				Record   : #record#
				Expiry   : #expiryDatetime?:"-"#
			";
		}

		return _renderMessage( message );
	}

	private any function stop( event, rc, prc ){
		var params  = jsonRpc2Plugin.getRequestParams();
		var cliArgs = IsArray( params.commandLineArgs ?: "" ) ? params.commandLineArgs : [];

		if ( cliArgs.len() GTE 2 ) {
			var indexName = cliArgs[ 2 ];

			if ( !_indexExists( indexName ) ) {
				return _renderMessage( "[[;red;]Index ""#indexName#"" not found.]" );
			} else if ( elasticSearchEngine.isIndexReindexing( indexName ) ) {
				elasticSearchEngine.terminateIndexing( indexName );

				return _renderMessage( "[[;lime;]Indexing process for ""#indexName# ""has been terminated.]" );
			} else {
				return _renderMessage( "[[;yellow;]Indexing process for ""#indexName# ""is not running.]" );
			}
		}

		return _renderMessage( "[[;aqua;]Please provide the name of the index you wish to stop processing.]" );
	}

// PRIVATE HELPERS
	private boolean function _indexExists( required string indexName ){
		return elasticSearchConfigReader.listIndexes().contains( indexName );
	}

	private string function _renderMessage( required string message ){
		message = trim( message );
		message = REReplace( message, "\t+", chr( 9 ), "ALL" );

		return chr( 10 ) & message & chr( 10 );
	}

	private array function _getCliArgs(){
		var params  = jsonRpc2Plugin.getRequestParams();
		var cliArgs = IsArray( params.commandLineArgs ?: "" ) ? params.commandLineArgs : [];

		return cliArgs;
	}
}