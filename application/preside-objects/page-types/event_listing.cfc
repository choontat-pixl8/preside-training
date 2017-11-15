/**
 * @allowedParentPageTypes homepage
 * @allowedChildPageTypes  event_detail
 */
component {

	property name="feature_event" relatedto="event_detail" relationship="many-to-many";
	property name="region"        relatedto="region"       relationship="many-to-one";
	property name="categories"    relatedto="category"     relationship="many-to-many";
}