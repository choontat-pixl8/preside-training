component extends="preside.system.coldboxModifications.RequestContextDecorator" {

	public boolean function fullyBooked( required string eventId ){
		return getModel( "EventService" ).isSeatFullyBooked( eventId );
	}
}