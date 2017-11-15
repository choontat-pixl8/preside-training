component {
	property name="EventService"     inject="EventService";
	property name="ProgrammeService" inject="ProgrammeService";

	private function index( event, rc, prc, args={} ){

		var pageId  = event.getCurrentPageId();

		args.event            = EventService.getEventDetail( pageId );
		args.isEventExpired   = EventService.isEventExpired( pageId );
		args.isEventBookeable = EventService.isEventBookeable( pageId );
		args.seatFullyBooked  = EventService.isSeatFullyBooked( pageId );
		
		return renderView(
			  view          = "page-types/event_detail/index"
			, args          = args
			, presideObject = "event_detail"
			, id            = pageId
		);
	}

	private function _relatedEvents( event, rc, prc, args={} ){
		args.relatedEvents = EventService.getRelatedEvents(
			  listingPageId = args.parent      ?: ""
			, eventDetailId = args.eventPageId ?: "" 
		);

		return renderView(
			  view = "page-types/event_detail/_related_events"
			, args = args
		);
	}

	private function _programmes( event, rc, prc, args={} ){
		args.programmes = ProgrammeService.getProgrammes( args.eventPageId?:"" );

		return renderView( view="page-types/event_detail/_programmes", args=args );
	}
}