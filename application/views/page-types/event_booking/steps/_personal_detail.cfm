<cfscript>
	formArgs = {
		  savedData = rc.savedData?:args.savedData?:{}
		, context   = "website"
		, formName  = args.formName?:"event.booking.personalDetail"
	};

	if ( isDefined( "rc.validationResult" ) ) {
		formArgs.validationResult = rc.validationResult?:{};
	}
</cfscript>

<cfoutput>
	#renderForm( argumentCollection=formArgs )#
</cfoutput>