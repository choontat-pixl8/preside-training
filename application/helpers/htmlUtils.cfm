<cfscript>
	private string function filterHTML( required string stringContent ) {
		return REReplaceNoCase(arguments.stringContent, "<[^[:space:]][^>]*>", "", "ALL");
	}
</cfscript>