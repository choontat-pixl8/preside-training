<cfoutput>
	<form action="#event.buildLink( page=event.getSystemPageId( "search" ) )#">
		<div class="input-group">
			<input type="text" class="form-control" name="query" value="#encodeForHTMLAttribute( rc.query?:"" )#"/>
			
			<div class="input-group-btn">
				<button class="btn btn-default">Search</button>
			</div>
		</div>
	</form>
</cfoutput>