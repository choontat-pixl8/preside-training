<cfset programmes = args.programmes?:QueryNew("") />

<h2>Programmes:</h2>
<ul>
	<cfoutput query="programmes">
		<li>#programmes.label# from #dateTimeFormat( programmes.start_datetime, "yyyy-mm-dd HH:nn:ss" )#</li>
	</cfoutput>
</ul>