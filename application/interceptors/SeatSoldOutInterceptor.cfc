component extends="coldbox.system.Interceptor" {
	property name="presideObjectService" inject="provider:PresideObjectService";
	property name="notificationService"  inject="provider:NotificationService";
	property name="eventService"         inject="provider:EventDetailService";
	property name="eventBookingService"         inject="provider:EventBookingService";

	public void function postInsertObjectData( required any event, required struct interceptData ){
		var objectName = arguments.interceptData.objectName?:"";
		var id = arguments.interceptData.newId?:"";
		var data = arguments.interceptData.data?:"";
		var skipInterception = isBoolean(data.skipInterception?:"") && data.skipInterception;
		
		writeDump(arguments.interceptData);
		if ( skipInterception ) {
			return;
		}

		switch ( objectName ) {
			case "booking":
				if ( _isSeatFullyBooked( id ) ) {
					notificationService.createNotification( topic="seatSoldOut", type="WARNING", data={ bookingId=id } );
				}
				break;
		}
	}

	private boolean function _isSeatFullyBooked( required string bookingId ){
		var eventId = eventBookingService.getEventIdById( bookingId );
		var selectFields = [ 
			"( SUM( booking.seat_count ) >= event_detail.seat_limit AND event_detail.seat_limit > 0 ) AS fullyBooked"
		];
		var result = presideObjectService.selectData(
			  objectName   = "event_detail"
			, selectFields = selectFields
			, filter       = { "event_detail.id"=eventId?:"" }
		);
		//writeDump(result);abort;
		return result.fullyBooked == '1';
	}
}