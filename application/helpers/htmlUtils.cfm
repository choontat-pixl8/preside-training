<cfscript>
	private string function filterHTML( required string stringContent ) {
		return REReplaceNoCase(arguments.stringContent, "<[^[:space:]][^>]*>", "", "ALL");
	}

	private string function uCaseFirst( required string name ){
		var nameArr   = name.split("[^a-zA-Z0-9]");
        var uCaseName = "";

        for ( var i=1; i<=len( nameArr ); i++ ) {
        	uCaseName &= " #REReplace( nameArr[ i ], "^.", uCase( nameArr[ i ].charAt( 0 ) ) )#";
        }

        return uCaseName.trim();
	}

	private string function toCamelCase( required string name ){
		var nameArr   = name.split("[^a-zA-Z0-9]");
        var uCaseName = REReplace( nameArr[ 1 ], "^.", uCase( nameArr[ 1 ].charAt( 0 ) ) );

        for ( var i=2; i<=len( nameArr ); i++ ) {
        	uCaseName &= REReplace( nameArr[ i ], "^.", uCase( nameArr[ i ].charAt( 0 ) ) );
        }

        return uCaseName.trim();
	}
</cfscript>