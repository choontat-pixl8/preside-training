component {
	/**
	 * @eventDetail.inject presidecms:object:event_detail
	 */

	public any function init( required any eventDetail ){
		_setEventDetail( arguments.eventDetail );

		return this;
	}

	public query function getEventDetail( required string id ){
		return _getEventDetail().selectData(
			selectFields = [
				  "page.id"
				, "page.title"
				, "page.parent_page"
				, "regions.id as regionId"
				, "event_detail.document"
				, "document.title as documentTitle"
			]
			, filter={ id=arguments.id }
		);
	}

	public array function getRegions( required string eventDetailId ){
		var eventRegions = _getEventDetail().selectData(
			  selectFields = [ "regions.id as regionId" ]
			, filter       = { id=arguments.eventDetailId }
		);
		return ValueArray( eventRegions.regionId );
	}

	public query function getAllEventsDetail( required string listingPageId, string regions="" ){
		var selectFields = [
			  "page.id"
			, "page.title"
			, "event_detail.start_date"
			, "event_detail.end_date"
		];
		var filter      = { "page.parent_page"=arguments.listingPageId };

		if ( len( Trim( arguments.regions ) ) ) {
            filter["regions.id"] = ListToArray( arguments.regions );
        }

		return _getEventDetail().selectData( selectFields=selectFields, filter=filter );
	}

	public query function getRelatedEvents( required string listingPageId, required string eventDetailId ){
		var relatedRegions = getRegions( arguments.eventDetailId );
		var selectFields = [
			  "page.id"
			, "page.title"
			, "event_detail.start_date"
			, "event_detail.end_date"
		];
		var filter = "page.parent_page = :page.parent_page and page.id != :page.id and regions.id IN (:regions.id)";
		var filterParams = {
			  "page.parent_page" = arguments.listingPageId
			, "page.id"          = arguments.eventDetailId
			, "regions.id"       = relatedRegions
		};

		return _getEventDetail().selectData( 
			  selectFields = selectFields
			, filter       = filter
			, filterParams = filterParams
		);
	}

	public query function getLatestEvents( required string eventIds ){
		var selectFields              = [ "page.id", "page.title" ];
		var filter                    = "page.id IN (:page.id) AND event_detail.end_date > :event_detail.end_date";
		var eventIdArray              = listToArray( arguments.eventIds );
		var escSingleQuotEventIdArray = eventIdArray.map( function( item ){
			return "'" & replace( item, "'", "\'", "ALL" ) & "'";
		} );
		var filterParams              = {
			  "page.id"               = eventIdArray
			, "event_detail.end_date" = now()
		};
		var orderBy                   = "FIELD( page.id, " & REReplace( escSingleQuotEventIdArray.toString(), "(\[|\])", "", "ALL") & ") ASC";

		return _getEventDetail().selectData( selectFields=selectFields, filter=filter, filterParams=filterParams, orderBy=orderBy );
	}

	public query function getSessionsByEventId( required string eventId ){
		return _getEventDetail().selectData( 
			selectFields=[ "event_session.label", "event_session.id" ]
			, filter={ "event_detail.id"=arguments.eventId }
		);
	}

	public numeric function getPricePerSeatByEventId( required string eventId ){
		var pricePerSeat = _getEventDetail().selectData(
			selectFields=[ "event_detail.price" ]
			, filter={ "event_detail.id"=arguments.eventId }
		).price;

		return val( pricePerSeat );
	}

	public boolean function isEventExpired( required string eventId ){
		var selectFields = [ "(event_detail.end_date < '" & dateFormat( now(), "yyyy-mm-dd" ) & "') as isExpired" ];
		return _getEventDetail().selectData( selectFields=selectFields, filter={ "event_detail.id"=eventId } ).isExpired?:true;
	}

	public boolean function isValidEventId( required string eventId ){
		return _getEventDetail().selectData( filter={ "page.id"=eventId } ).recordCount > 0;
	}

	public boolean function isEventBookeable( required string eventId ){
		return _getEventDetail().selectData(
			  selectFields=[ "event_detail.bookeable" ]
			, filter={ "page.id"=eventId }
		).bookeable == '1' ? true : false;
	}

	private any function _getEventDetail(){
		return variables._eventDetail;
	}

	private void function _setEventDetail( required any eventDetail ){
		variables._eventDetail = arguments.eventDetail;
	}
}