$( document ).ready( function(){
	var currentPage = 1;
	var loading     = false;

	$( 'form>.filter' ).change( function(){
		this.parentNode.submit();
	} );

	$( '#loadMore' ).click( function(){
		if ( loading ) {
			return;
		}

		loading = true;

		var that = this;
		
		$.ajax( {
			  url: cfrequest.loadMoreURL
			, data: {
				  currentPage: currentPage
				, query:           $( 'input[type=hidden][name=query]'      ).val() || ''
				, categories:      $( 'input[type=hidden][name=categories]' ).val() || ''
				, resources:       $( '#filterResources:checked'            ).val() || ''
			}
			, success: function( content ){
				$( '#searchResultTable' ).append( content );

				currentPage++;

				if ( ( cfrequest.pageSize ) * currentPage >= cfrequest.totalResult || !content.trim() ) {
					that.parentNode.removeChild( that );
				}
			}
			, error: function(){
				alert( 'connection error' );
			}
			, complete: function(){
				loading = false;
			}
		} );
	} );
} );