component {
	property name="eventBookingService" inject="EventBookingService";

	private struct function prepareParameters( required string recipientId ) {
		return eventBookingService.getBookingDetailById( recipientId );
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

	private string function getToAddress( required string recipientId ) {
		return eventBookingService.getRecipientEmailAddressById( recipientId );
	}
}