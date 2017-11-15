component {
	property name="eventBookingService" inject="EventBookingService";

	private struct function prepareParameters( required string bookingId ) {
		return eventBookingService.getBookingDetailById( bookingId );
	}

	private struct function getPreviewParameters() {
		return {
			  "first_name" = "Thum"
			, "last_name" = "Choon Tat"
			, "seat_count" = 2
			, "priceInMYR" = 100
			, "special_request" = "requests"
			, "sessions" = "service1, service2, ..."
		};
	}

	private string function defaultSubject(){
		return "Event Booking Confirmation";
	}

	private string function defaultHtmlBody(){
		return "HTML body not found";
	}

	private string function defaultTextBody(){
		return "Text body not found";
	}
}