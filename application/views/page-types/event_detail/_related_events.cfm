<cfset relatedEvents=args.relatedEvents?:QueryNew("") />

<h2>Related Events</h2>
<ul>
	<cfoutput query="relatedEvents">
			<li>
				<a href="#event.buildLink( page=relatedEvents.id )#">
					#relatedEvents.title#
				</a>
			</li>
	</cfoutput>
</ul>