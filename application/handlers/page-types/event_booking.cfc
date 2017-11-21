component {
	property name="eventService"                inject="EventService";
	property name="eventBookingService"         inject="EventBookingService";
	property name="emailService"                inject="EmailService";
	property name="notificationService"         inject="NotificationService";
	property name="eventBookingWorkflowService" inject="EventBookingWorkflowService";

	function init(){
		return this;
	}

	private function index( event, rc, prc, args={} ) {
		args.validEventId    = eventService.isEventBookeable ( rc.eventId?:"" );
		args.seatFullyBooked = eventService.isSeatFullyBooked( rc.eventId?:"" );

		var steps = eventBookingWorkflowService.getSteps();

		args.steps       = steps;
		args.currentStep = eventBookingWorkflowService.getCurrentStep();
		args.savedData   = eventBookingWorkflowService.getStateData();
		args.isLastStep  = steps[ steps.len() ] == args.currentStep;

		return renderView(
			  view          = 'page-types/event_booking/index'
			, presideObject = 'event_booking'
			, id            = event.getCurrentPageId()
			, args          = args
		);
	}

	private string function renderStepForm( event, rc, prc, args={} ){
		var rendererName = "render" & ( args.currentStep?:"" ) & "form";

		if ( isCustomFunction( this[ rendererName ]?:"" ) ) {
			return this[ rendererName ]( argumentCollection=arguments );
		}

		return "Step not found";
	}

	private string function renderPersonalDetailForm( event, rc, prc, args={} ){
		return renderView( view="page-types/event_booking/steps/_personal_detail", args=args );
	}

	private string function renderSessionDetailForm( event, rc, prc, args={} ){
		return renderView( view="page-types/event_booking/steps/_session_detail", args=args );
	}

	private string function renderPaymentDetailForm( event, rc, prc, args={} ){
		return renderView( view="page-types/event_booking/steps/_payment_detail", args=args );
	}

	private struct function _processPersonalDetailForm( event ){
		var formName         = "event.booking.personalDetail";
		var formData         = event.getCollectionForForm( formName );
		var validationResult = validateForm( formName=formName, formData=formData );

		return { formData=formData, validationResult=validationResult };
	}

	private struct function _processSessionDetailForm( event ){
		var formName         = "event.booking.sessionDetail";
		var formData         = event.getCollectionForForm( formName );
		var validationResult = validateForm( formName=formName, formData=formData );

		return { formData=formData, validationResult=validationResult };
	}

	private struct function _processPaymentDetailForm( event ){
		var formName         = "event.booking.paymentDetail";
		var formData         = event.getCollectionForForm( formName );
		var validationResult = validateForm( formName=formName, formData=formData );

		return { formData=formData, validationResult=validationResult };
	}

	public string function saveStep( event, rc, prc, args={} ){
		var currentStep          = rc.step?:"";
		var validationMethodName = "_process" & currentStep & "form";
		var persistStruct        = {};
		var validInput           = true;
		var steps                = eventBookingWorkflowService.getSteps();

		if ( isCustomFunction( this[ validationMethodName ]?:"" ) ) {
			var processedResult  = this[ validationMethodName ]( event );
			var validationResult = processedResult.validationResult;

			persistStruct.formData         = processedResult.formData;
			persistStruct.validationResult = validationResult;

			validInput = validationResult.listErrorFields().len() == 0;
		}

		if ( validInput ) {
			if ( steps.find( currentStep ) == steps.len() ) {
				var bookingData = eventBookingWorkflowService.getStateData();

				for ( var formData in persistStruct.formData ) {
					bookingData[ formData ] = persistStruct.formData[ formData ];
				}

				_makeBooking( bookingData );

				persistStruct.finish = true;

				eventBookingWorkflowService.complete();
			} else {
				eventBookingWorkflowService.saveStep( step=currentStep, data=persistStruct.formData );

				args.currentStep = eventBookingWorkflowService.getNextStep( currentStep=currentStep );
			}
		} else {
			args.currentStep = currentStep;
		}

		_redirectToBookingPage( event=event, eventId=rc.eventId, persistStruct=persistStruct );

	}

	public string function previousStep( event, rc, prc, args={} ){
		var currentStep  = rc.step?:"";
		var previousStep = eventBookingWorkflowService.getPreviousStep( currentStep=currentStep );

		eventBookingWorkflowService.saveStep( step=previousStep, data={} );

		eventBookingWorkflowService.toPreviousStep();

		_redirectToBookingPage( event=event, eventId=rc.eventId, persistStruct={} );
	}

	public function makeBooking( event, rc, prc, args={} ){
		var formData = event.getCollectionForForm( "event.booking" );

		for ( var data in formData ) {
			formData[ data ] = filterHTML( formData[ data ] );
		}

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

	private function _makeBooking( required struct bookingData ){
		var pricePerSeat = eventService.getPricePerSeatByEventId( rc.eventId?:"" )?:0;

		bookingData.priceInMYR = pricePerSeat * ( bookingData.seat_count?:0 );
		
		var insertedId = eventBookingService.makeBooking( bookingData );

		bookingData.bookingId = insertedId;

		emailService.send(
			  template    = "eventBookingConfirmation"
			, recipientId = insertedId
			, to          = [ bookingData.email ]
			, subject     = "Event booking confirmation"
			, args        = bookingData
		);

		notificationService.createNotification( topic="eventBooked", type="INFO", data={ bookingId=insertedId } );
	}

	private function _redirectToBookingPage( required any event, required string eventId, struct persistStruct={} ){
		setNextEvent(
			  url           = event.buildLink( page="event_booking", queryString="eventId=#eventId#" )
			, persistStruct = persistStruct
		);
	}
}
