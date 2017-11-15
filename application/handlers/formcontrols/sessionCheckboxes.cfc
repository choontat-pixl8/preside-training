component {
	property name="eventService" inject="EventService";

	public function index( event, rc, prc, args={} ){
		var sessions = eventService.getSessionsByEventId( rc.eventId?:"" );
		
		args.labels = valueArray( sessions.label );
		args.values = valueArray( sessions.id );

		return renderView( view="formcontrols/checkboxList/index", args=args );
	}
}