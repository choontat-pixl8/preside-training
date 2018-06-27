/**
 * @allowedParentPageTypes event_listing
 * @allowedChildPageTypes  none
 * @showInSiteTree         false
 * @sitetreeGridFields     page.title,start_date,end_date,category
 */
component {
	property name="event_listing"  relatedto="event_listing" relationship="many-to-one";
	property name="regions"        relatedto="region"        relationship="many-to-many";
	property name="category"       relatedto="category"      relationship="many-to-one" searchEnabled=true searchSearchable=false;
	property name="event_sessions" relatedto="event_session" relationship="one-to-many" relationshipkey="event_detail";
	property name="document"       relatedTo="asset"         relationship="many-to-one";
	property name="programmes"     relatedto="programme"     relationship="one-to-many"  relationshipkey="event_detail";

	property name="event_name";
	
	property name="start_date" type="date"    dbtype="date";
	property name="end_date"   type="date"    dbtype="date";
	property name="bookeable"  type="boolean" dbtype="bit";
	property name="price"      type="numeric" dbtype="double";
	property name="seat_limit" type="numeric" dbtype="int" default="0";
}