component {
	property name="eventService" inject="eventService";

	private string function datatable( event, rc, prc, args={} ){
		return _getNotificationSubject( args.eventId?:"" );
	}

	private string function full( event, rc, prc, args={} ){
		var bookersDetail = eventService.getBookersDetailById( args.eventId?:"" );
		
		return renderView(
			  view = "renderers/notifications/seatSoldOut/full"
			, args = { "bookersDetail"=bookersDetail }
		);
	}

	private string function _getNotificationSubject( required string eventId ){
		var eventName = eventService.getEventNameById( eventId );

		return "Event fully booked for " & ( eventName?:"" );
	}
}