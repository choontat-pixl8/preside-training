component {
	property name="eventService" inject="EventService";

	public function index( event, rc, prc, args={} ){
		args.pricePerSeat = eventService.getPricePerSeatByEventId( rc.eventId?:"" );

		if ( !isDefined( args.name ) && isDefined( args.binding ) ) {
			var bindingNameArray = args.binding.split( "." );
			
			args.name = bindingNameArray[ bindingNameArray.length - 1 ];
		}

		return renderView( view="formcontrols/eventSeatSelector/index", args=args );
	}
}