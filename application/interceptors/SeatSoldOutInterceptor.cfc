component extends="coldbox.system.Interceptor" {
	property name="presideObjectService" inject="provider:PresideObjectService";
	property name="notificationService"  inject="provider:NotificationService";
	property name="eventService"         inject="provider:EventService";
	property name="eventBookingService"  inject="provider:EventBookingService";

	public void function postInsertObjectData( required any event, required struct interceptData ){
		var objectName       = arguments.interceptData.objectName ?: "";
		var data             = arguments.interceptData.data       ?: "";
		var newBookingId     = arguments.interceptData.newId      ?: "";
		var skipInterception = isBoolean( data.skipInterception?:"" ) && data.skipInterception;
		var eventId          = eventBookingService.getEventIdById( newBookingId );

		if ( skipInterception ) {
			return;
		}

		switch ( objectName ) {
			case "booking":
				if ( eventService.isSeatFullyBooked( eventId ) ) {
					notificationService.createNotification( 
						  topic = "seatSoldOut"
						, type  = "WARNING"
						, data  = { eventId=eventId }
					);
				}
				break;
		}
	}
}