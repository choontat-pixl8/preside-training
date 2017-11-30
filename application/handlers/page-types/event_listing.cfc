component {
	property name="region"           inject="presidecms:object:region";
	property name="EventService"     inject="EventService";
	property name="ProgrammeService" inject="ProgrammeService";

	public function publicIndex( event, rc, prc, args={} ){
		var pageId   = event.getCurrentPageId();

		args.regions = region.selectData();
		args.events  = EventService.getAllEventsDetail( listingPageId=pageId, regions=rc.region?:"" );

		return renderView(
			  view          = "page-types/event_listing/index"
			, args          = args
			, presideObject = "event_listing"
		);
	}

	private function index( event, rc, prc, args={} ){

		var pageId   = event.getCurrentPageId();

		args.regions = region.selectData();
		args.events  = EventService.getAllEventsDetail( listingPageId=pageId, regions=rc.region?:"" );

		return renderView(
			  view          = "page-types/event_listing/index"
			, args          = args
			, presideObject = "event_listing"
			, id            = pageId
		);
	}

	private function _relatedEvents( event, rc, prc, args={} ){
		args.relatedEvents = EventService.getAllEventsDetail(
			  listingPageId = args.parent ?: ""
			, regions       = args.region ?: ""
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