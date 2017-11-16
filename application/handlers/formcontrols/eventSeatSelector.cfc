component {
	property name="eventService" inject="EventService";

	public function index( event, rc, prc, args={} ){
		var eventId       = rc.eventId?:"";
		var remainingSeat = eventService.getRemainingSeatCountByEventId( eventId );

		args.pricePerSeat  = eventService.getPricePerSeatByEventId( eventId );
		args.remainingSeat = remainingSeat;

		if ( !isDefined( args.name ) && isDefined( args.binding ) ) {
			var bindingNameArray = args.binding.split( "." );
			
			args.name = bindingNameArray[ bindingNameArray.length - 1 ];
		}

		return renderView( view="formcontrols/eventSeatSelector/index", args=args );
	}
}