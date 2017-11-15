component {
	property name="formsService"        inject="formsService";
	property name="eventService"        inject="EventService";
	property name="eventBookingService" inject="EventBookingService";
	property name="emailService"        inject="EmailService";
	property name="notificationService" inject="NotificationService";

	function init(){
		return this;
	}

	private function index( event, rc, prc, args={} ) {
		args.validEventId    = eventService.isEventBookeable ( rc.eventId?:"" );
		args.seatFullyBooked = eventService.isSeatFullyBooked( rc.eventId?:"" );

		return renderView(
			  view          = 'page-types/event_booking/index'
			, presideObject = 'event_booking'
			, id            = event.getCurrentPageId()
			, args          = args
		);
	}

	public function makeBooking( event, rc, prc, args={} ){
		var formData         = event.getCollectionForForm( "event.booking" );
		var validationResult = validateForm( "event.booking", formData );
		var validInputs      = ( len ( validationResult.listErrorFields() ) == 0 );
		var seatFullyBooked  = eventService.isSeatFullyBooked( rc.eventId?:"" );

		if ( validInputs && !seatFullyBooked ) {
			var pricePerSeat = eventService.getPricePerSeatByEventId( rc.eventId?:"" )?:0;

			formData.priceInMYR = pricePerSeat * ( formData.seat_count?:0 );
			
			var insertedId = eventBookingService.makeBooking( formData );

			formData.bookingId = insertedId;

			emailService.send(
				  template    = "eventBookingConfirmation"
				, recipientId = insertedId
				, to          = [ formData.email ]
				, subject     = "Event booking confirmation"
				, args        = formData
			);

			notificationService.createNotification( topic="eventBooked", type="INFO", data={ bookingId=insertedId } );
		}

		setNextEvent(
			  url           = event.buildLink( page="event_booking", queryString="eventId="&( rc.eventId?:"" ) )
			, persistStruct = {
				  success          = validInputs && !seatFullyBooked
				, args             = args
				, validationResult = validationResult
				, formData         = formData
			}
		 );
	}
}
