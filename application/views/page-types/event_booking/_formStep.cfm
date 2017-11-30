<cfscript>
	saveStepURL     = event.buildLink( linkTo="page-types.event_booking.saveStep" );
	previousStepURL = event.buildLink( linkTo="page-types.event_booking.previousStep" );
	isLastStep      = args.isLastStep?:true;
	currentStep     = args.currentStep?:"";
</cfscript>
<cfoutput>
	<form action="#saveStepURL#" method="POST" class="form form-horizontal">
		<input type="hidden" name="step" value="#currentStep#" />
		<input type="hidden" name="eventId" value="#rc.eventId?:""#" />
		
		#renderViewlet( event="page-types.event_booking.renderStepForm", args=args )#

		<button class="btn btn-warning" type="submit" formaction="#previousStepURL#" formnovalidate>
			Back
		</button>
		<button class="btn btn-success">
			#isLastStep?"Finish":"Continue"#
		</button>
	</form>
</cfoutput>