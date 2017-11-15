<cf_presideparam name="args.id"              field="page.id"                       editable="false" />
<cf_presideparam name="args.title"           field="page.title"                    editable="true"  />
<cf_presideparam name="args.main_content"    field="page.main_content"             editable="true"  />
<cf_presideparam name="args.success_message" field="event_booking.success_message" editable="false" />
<cf_presideparam name="args.error_message"   field="event_booking.error_message"   editable="false" />

<cfoutput>
	<h1>#args.title#</h1>
	#args.main_content#

	<cfif args.validEventId?:false>
		<cfif isDefined("rc.success")>
			<cfif rc.success>
				<div class="alert alert-success">#encodeForHTML(args.success_message)#</div>
			<cfelse>
				<div class="alert alert-danger">#encodeForHTML(args.error_message)#</div>
			</cfif>
		<cfelseif event.fullyBooked( args.id?:"" )>
			<div class="alert alert-warning">Seat fully booked</div>
		<cfelse>
			<form 
				id     = "booking-form"
				action = "#event.buildLink( linkTo="page-types.event_booking.makeBooking" )#"
				class  = "form form-horizontal"
				method = "POST">
				#renderForm(
					formName = "event.booking"
					, context = "website"
					, formId = "booking-form"
					, validationResult = rc.validationResult?:""
					, savedData = rc.formData?:{}
				)#
				<input type="hidden" name="eventId" value="#encodeForHTMLAttribute( rc.eventId?:"" )#" />
				<center>
					<button class="btn btn-success">Book</button>
				</center>
			</form>
		</cfif>
	<cfelseif args.seatFullyBooked>
		<div class="alert alert-warning">Seat fully booked</div>
	<cfelse>
		<div class="alert alert-danger">Bookeable event not found.</div>
	</cfif>
</cfoutput>