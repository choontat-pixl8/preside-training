<cfparam name="args.title" default="" />
<cfparam name="args.description" default="" />

<cfset latestEvents = args.eventDetails />
<h2>Latest Events</h2>
<ul>
	<cfoutput query="latestEvents">
		<li>
			<a href="#event.buildLink( page=latestEvents.id )#">
				#latestEvents.title#
			</a>
		</li>
	</cfoutput>
</ul>