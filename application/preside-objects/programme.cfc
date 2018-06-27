component {
	property name="label";
	property name="start_datetime" dbtype="datetime";

	property name="event_detail"   relatedto="event_detail" relationship="many-to-one";
}