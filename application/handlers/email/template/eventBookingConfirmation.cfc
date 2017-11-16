component {
	property name="eventBookingService" inject="EventBookingService";

	private struct function prepareParameters( required string bookingId ) {
		return eventBookingService.getBookingDetailById( bookingId );
	}

	private struct function getPreviewParameters() {
		return {
			  "first_name"      = "Thum"
			, "last_name"       = "Choon Tat"
			, "seat_count"      = 2
			, "priceInMYR"      = 100
			, "special_request" = "requests"
			, "sessions"        = "session1, session2, ..."
		};
	}

	private string function defaultSubject(){
		return "Event Booking Confirmation";
	}
}