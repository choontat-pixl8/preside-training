component {
	property name="eventBookingService" inject="eventBookingService";

	private string function datatable( event, rc, prc, args={} ){
		return _getNotificationSubject( args.bookingId );
	}

	private string function full( event, rc, prc, args={} ){
		var bookingDetail       = eventBookingService.getBookingDetailById( args.bookingId?:"" );
		var notificationDetails = _getNotificationDetails( args.bookingId?:"" );

		event.include( "css-notification-full" );

		return renderView( view="renderers/notifications/eventBooked/full", args=notificationDetails );
	}

	private string function emailSubject( event, rc, prc, args={} ){
		return _getNotificationSubject( args.bookingId );;
	}

	private string function emailHTML( event, rc, prc, args={} ){
		var notificationDetails = this._getNotificationDetails( args.bookingId?:"" );

		return event.setView( view="renderers/notifications/eventBooked/emailHTML", args=notificationDetails, noLayout=true );
	}

	private string function emailText( event, rc, prc, args={} ){
		var notificationDetails = this._getNotificationDetails( args.bookingId?:"" );

		return setView( view="renderers/notifications/eventBooked/emailText", args=notificationDetails, noLayout=true );
	}

	private string function _getNotificationSubject( required string bookingId ){
		var bookerFullName = eventBookingService.getBookerFullNameById( bookingId?:"" );

		return "Event booked by " & bookerFullName;
	}

	private struct function _getNotificationDetails( required string bookingId ){
		var bookingDetail = eventBookingService.getBookingDetailById( bookingId?:"" );
		return {
			  "firstName"      = bookingDetail.first_name      ?: ""
			, "lastName"       = bookingDetail.last_name       ?: ""
			, "seatCount"      = bookingDetail.seat_count      ?: 0
			, "price"          = bookingDetail.priceInMYR      ?: 0
			, "sessions"       = bookingDetail.event_sessions  ?: ""
			, "specialRequest" = bookingDetail.special_request ?: ""
		};
		
	}
}