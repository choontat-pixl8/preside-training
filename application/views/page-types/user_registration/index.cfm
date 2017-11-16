<cf_presideparam name="args.success_message" field="user_registration.success_message" editable="false" />
<cf_presideparam name="args.error_message"   field="user_registration.error_message"   editable="false" />

<cfoutput>
	<cfif isDefined("rc.success")>
		<cfif rc.success>
			<div class="alert alert-success">#encodeForHTML( args.success_message )#</div>
		<cfelse>
			<div class="alert alert-danger">#encodeForHTML( args.error_message )#</div>
		</cfif>
	</cfif>

	<cfif !( rc.success?:false )>
		<form 
			id     = "user-registration-form"
			action = "#event.buildLink( linkTo="page-types.user_registration.registerUser" )#"
			class  = "form form-horizontal"
			method = "POST">
				#renderForm(
					  formName         = "user.registration"
					, context          = "website"
					, formId           = "user-registration-form"
					, validationResult = rc.validationResult?:""
					, savedData        = rc.formData?:{}
				)#
			<center>
				<button class="btn btn-success">Register</button>
			</center>
		</form>
	</cfif>
</cfoutput>