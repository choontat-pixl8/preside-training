<cfscript>
	addRouteHandler( getModel( dsl="delayedInjector:eventRouteHandler" ) );
	addRouteHandler( getModel( dsl="delayedInjector:resourceExternalLinkRouteHandler" ) );
</cfscript>