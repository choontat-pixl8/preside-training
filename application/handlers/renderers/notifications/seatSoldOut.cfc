component {
	property name="eventBookingService" inject="eventBookingService";

	private string function datatable( event, rc, prc, args={} ){
		return _getNotificationSubject( args.bookingId?:"" );
	}

	private string function full( event, rc, prc, args={} ){

	}

	private string function emailSubject( event, rc, prc, args={} ){

	}

	private string function emailHTML( event, rc, prc, args={} ){

	}

	private string function emailText( event, rc, prc, args={} ){

	}

	private string function _getNotificationSubject( required string bookingId ){
		var eventName = eventBookingService.getEventNameById( bookingId );

		return "Event fully booked for " & ( eventName?:"" );
	}

	private struct function _getNotificationDetails( required string bookingId ){

	}
}