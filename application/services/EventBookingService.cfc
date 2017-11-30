component {
	/**
	 * @bookingDetail.inject presidecms:object:booking
	 */

	 public any function init( required booking bookingDetail ){
		_setBookingDetail( arguments.bookingDetail );

		return this;
	}

	public string function makeBooking( required struct bookingDetail ){
		//writeDump(bookingDetail);abort;
		var insertedId = _getBookingDetail().insertData(
			  data                    = bookingDetail
			, insertManyToManyRecords = true
		);
		
		return insertedId;
	}

	public struct function getBookingDetailById( required string bookingId ){
		var selectFields = [
			  "first_name"
			, "last_name"
			, "email"
			, "seat_count"
			, "priceInMYR"
			, "special_request"
			, "event_session.label AS event_sessions"
		];
		var bookingDetailQuery = _getBookingDetail().selectData(
			  selectFields = selectFields
			, filter       = { "id"=bookingId }
		);

		if ( bookingDetailQuery.recordCount == 0 ) {
			return {};
		}

		var eventSessions = valueList  ( bookingDetailQuery.event_sessions );
		var bookingDetail = queryGetRow( bookingDetailQuery, 1             );

		bookingDetail.sessions = eventSessions;

		return bookingDetail;
	}

	public string function getEventIdById( required string bookingId ){
		return _getBookingDetail().selectData(
			  selectFields = [ "event_detail.id AS eventId" ]
			, filter       = { "id"=bookingId }
		).eventId?:"";
	}

	public string function getEventNameById( required string bookingId ){
		return _getBookingDetail().selectData(
			  selectFields = [ "event_detail.event_name as eventName" ]
			, filter       = { "id"=bookingId }
		).eventName?:"";
	}

	public string function getBookerFullNameById( required string bookingId ){
		var selectFields = [ "CONCAT( first_name, ' ', last_name ) AS fullName" ];

		return _getBookingDetail().selectData(
			  selectFields = selectFields
			, filter       = { "id"=bookingId }
		).fullName?:"";
	}

	public string function getRecipientEmailAddressById( required string bookingId ){
		return _getBookingDetail().selectData(
			  selectFields = [ "email" ]
			, filter       = { "id"=bookingId }
		).email?:"";
	}

	private any function _getBookingDetail(){
		return variables._bookingDetail;
	}

	private void function _setBookingDetail( required any bookingDetail ){
		variables._bookingDetail = arguments.bookingDetail;
	}
}