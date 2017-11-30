$( document ).ready( function(){
	var startFrom = cfrequest.loadedNewsCount + 1;

	checkHasMoreNews();

	$( '#btnLoadNews' ).click( function(){
		$.ajax( {
			  url: cfrequest.loadNewsURL || ""
			, data: { startFrom : startFrom }
			, success: function( news ){
				var newsArray = JSON.parse( news );

				for ( var i=0; i<newsArray.length; i++ ) {
					var newsLink = $( "<a>"  , { href  : newsArray[i].newsURL } );
					var jumboDiv = $( "<div>", { class : "jumbotron"          } );

					newsLink.text( newsArray[i].title );

					jumboDiv.append( newsLink );

					$( "#news_list" ).append( jumboDiv );
				}

				startFrom += newsArray.length;

				checkHasMoreNews();
			}
			, error: function(){
				alert( "Connection error." );
			}
		} );
	} );

	function checkHasMoreNews(){
		if( startFrom >= cfrequest.newsListCount + 1 ) {
			$( "#btnLoadNews" ).remove();
		}
	}
} );