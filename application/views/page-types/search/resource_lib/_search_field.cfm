<cfoutput>
	<form action="#event.buildLink( page=event.getSystemPageId( "search_resource_library" ) )#">
		<div class="input-group">
			<input type="text" class="form-control" name="query" value="#encodeForHTMLAttribute( rc.query?:"" )#"/>
			
			<div class="input-group-btn">
				<button class="btn btn-default">Search Resource Library</button>
			</div>
		</div>
	</form>
</cfoutput>