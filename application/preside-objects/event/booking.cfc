/**
 * @allowedChildPageType none
 * @allowedParentPageTypes none
 */
component  {
	property name="label"              required="true" dbtype="varchar" default="Event Booking";
	property name="first_name"         required="true" dbtype="varchar";
	property name="last_name"          required="true" dbtype="varchar";
	property name="email"              required="true" dbtype="varchar";
	property name="seat_count"         required="true" dbtype="int";
	property name="priceInMYR"                         dbtype="double";
	property name="special_request"                    dbtype="text";
	property name="purchase_number";
	property name="credit_card_number" required="true";
	property name="expiry_date"        required="true" dbtype="date";
	property name="sessions"           required="true"               relatedto="event_session" relationship="many-to-many";

}