component {
	property name="EventService" inject="EventService";

	private function index( event, rc, prc, args={} ) {
		args.eventDetails = EventService.getLatestEvents( args.events );
		
		return renderView( view='widgets/latest_event/index', args=args );
	}

	private function placeholder( event, rc, prc, args={} ) {
		return renderView( view='widgets/latest_event/placeholder', args=args );
	}
}
