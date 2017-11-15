<cfset featuredEvents = args.events?:QueryNew("") />

<h2>Featured Events</h2>
<cfif featuredEvents.recordcount >
	<cfoutput query="featuredEvents" maxrows=3>
		<div class="jumbotron">
			<h2>
				<a href="#event.buildLink( page=featuredEvents.id )#">
					#featuredEvents.title#
				</a>
			</h2>
			<h3>
				#dateFormat( featuredEvents.start_date, "dd mmm yyyy" )# - #dateFormat( featuredEvents.end_date, "dd mmm yyyy" )#
			</h3>
		</div>
	</cfoutput>
<cfelse>
	No featured events available.
</cfif>